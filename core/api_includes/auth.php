<?php
/* Including functional dependencies */
include_once (LIBRARIES_DIR . "password_compat/password.php");
include_once (CORE_DIR . "core_includes/others.php");
include_once (CORE_DIR . "core_includes/session.php");

function api_auth_register() {
	/* Validate data */
	validate_fields($fields, $_POST, array(
			"site",
			"work"
		), array(
			"login",
			"passwd1",
			"passwd2",
			"fname",
			"lname",
			"mname",
			"bday",
			"bmounth",
			"byear",
			"country",
			"city",
			"mail",
			"phone",
			"adress",
			"accept"
		), array(
			"login" 	=> "login",
			"passwd1" 	=> "pass",
			"phone" 	=> "phone",
			"mail" 		=> "email",
			"site" 		=> "url"
		), 
	$errors, false);

	/* Checking equality passwords */
	if ($fields["passwd1"] != $fields["passwd2"]) {
		$errors[] = "Пароли не совпадают.";
	}

	/* Checking uniqueness Login & password pair */
	$db = new db;
	$check_uniq = $db->getOne("SELECT id FROM users WHERE mail=?s OR login=?s", $fields["mail"], $fields["login"]);
	if ($check_uniq !== false) {
		$errors[] = "Пользователь с таким логином или почтой уже зарегистрирован.";
	}

	/* Checking user birthdate */
	if (!checkdate($fields["bmounth"], $fields["bday"], $fields["byear"])) {
		$errors[] = "Дата рождения неверна.";
	}

	if (!empty($errors)) {
		aerr($errors); 
	}

	unset($fields["accept"]);

	/* Hashing password */
	$fields["password"] = password_hash($fields["passwd1"], PASSWORD_DEFAULT);
	unset($fields["passwd1"]); 
	unset($fields["passwd2"]);	

	/* Making MYSQL dbate */
	$fields["bdate"] = (int)$fields["byear"] . "-" . (int)$fields["bmounth"] . "-" . (int)$fields["bday"];
	unset($fields["byear"]); 
	unset($fields["bmounth"]);	
	unset($fields["bday"]); 	

	/* Making MYSQL work set */
	if (isset($fields["work"])){
		$fields["work"] = implode(",", $fields["work"]);
	}

	/* Making verify code */
	$fields["hash"] = others_generate_code(5);

	/* Insert to db */
	$db->query("INSERT INTO users (`" . implode("` ,`", array_keys($fields)) . "`) VALUES (?a);", $fields);

	/* Mail client details to user */
    mail($fields["mail"], "Odnokonniki", "
    	Здравствуйте. 
		Спасибо за регистрацию.
		Логин: {$fields["login"]}
		Код подтверждения: {$fields["hash"]}
		Ссылка для подтверждения: http://odnokonniki.ru/sms.php?login={$fields["login"]}
	");

	aok(array("Пользователь успешно зарегистрирован. На вашу почту отправлено письмо, код с которого нужно будет указать далее."), "/sms.php?login={$fields["login"]}");
}

function api_auth_sms_validate() {
	/* Validate data */
	validate_fields($fields, $_POST, array(), array(
			"login",
			"code"
		), array(), $errors, false);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Checking code from db */
	$db = new db;
	$code = $db->getOne("SELECT hash FROM users WHERE login=?s AND hash=?s", $fields["login"], $fields["code"]);
	if ($code === false) {
		aerr(array("Подтвержение регистрации невозможно. Проверьте введенные данные."));
	} else {
		$db->query("UPDATE users SET hash='' WHERE login=?s", $fields["login"]);
		aok(array("Регистрация подтверждена. Сейчас вас перенаправит на страницу входа. Спасибо."), "/login.php?login={$fields["login"]}");
	}
}

function api_auth_login() {
	/* Validate data */
	validate_fields($fields, $_POST, array(), array(
			"login",
			"pass"
		), array(), $errors, false);

	if (!empty($errors)) {
		aerr($errors);
	}

	/* Calculate login or email entered */
	if (validate_email($fields["login"])) {
		$field_name = "mail";
	} else {
		$field_name = "login";
	}

	/* Getting client details of entered user */
	$db = new db;
	$details = $db->getRow("SELECT id, password, hash FROM users WHERE ?n = ?s", $field_name, $fields["login"]);

	/* Check and auth */
	if (password_verify($fields["pass"], $details["password"]) && strlen($details["hash"]) != 5) {
		session_auth($details["id"]);
		aok(array("Вход осуществлен успешно."), "/inner.php");
	} else {
		aerr(array("Данные неверны или пользователь не зарегистрирован (не верифицирован)."));
	}
}

function api_auth_logout() {
	session_logout();
	aok(array("Все хорошо."), "/login.php");
}

function api_auth_pass_restore() {
	/* Validate data */
	validate_fields($fields, $_POST, array(), array("mail"), array(), $errors, false);

	if (!empty($errors)) {
		aerr($errors); 
	}

	/* Generate and send verification code */
	$db = new db;
	$code = md5(time() . others_generate_code(5));
	$id = $db->getOne("SELECT id FROM users WHERE mail=?s", $fields["mail"]);
	if ($id !== false) {
		$db->query("UPDATE users SET restore = ?s WHERE id = ?s", $code, $id);
	    mail($fields["mail"], "Odnokonniki", " 
	    	Здравствуйте.
			На вашем аккаунте была заказана смена пароля.
			Для подтверждения смены пароля, пройдите по ссылке: http://odnokonniki.ru/restore.php?mail={$fields["mail"]}&code={$code}
			Если вы этого не делали, просто проигнорируйте это письмо.
		");
	}
	aok(array("Если такой пользователь существует, то ему выслано письмо с подтверждением."));
}
