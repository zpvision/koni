<?php
/* Including functional dependencies */
include_once ("../core/config.php");
include_once (LIBRARIES_DIR . "smarty/smarty.php");
include_once (CORE_DIR . "core_includes/templates.php");

/* Logic part of 'sms' page */
$assigned_vars = array(
	"page_title" 	=> "Подтверждение > Одноконники",
	"login" 		=> $_GET["login"] //WARN: POSSIBLE XSS INJECTION, CONFIGURE SMARTY
);
template_render($assigned_vars, "registration_verify.tpl");