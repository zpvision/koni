<?php
/* This is site constants file */

$const_mounth = array(
	1 => "январь",
	2 => "февраль",
	3 => "март",
	4 => "апрель",
	5 => "май",
	6 => "июнь",
	7 => "июль",
	8 => "август",
	9 => "сентябрь",
	10 => "октябрь",
	11 => "ноябрь",
	12 => "декабрь"
);
$db = new db;
$const_countries = $db->getAll("SELECT id,country_name_ru
                                                FROM country_
                                                ORDER BY oid ASC");

//make yours
$const_countries_old = $db->getCol("SELECT country_name_ru
                                                FROM country_
                                                ORDER BY oid ASC");

$const_work = array(
	"Тренер",
	"Владелец лошади",
	"Любитель",
	"Берейтор",
	"Спортсмен",
	"Ветеринар",
	"Коневод",
	"Коваль",
	"Фотограф",
	"Конюх",
	"Инструктор по ВЕ",
	"Коновод",
	"Начкон",
	"Зоотехник",
	"Наездник",
	"Иппотерапевт",
	"Продавец",
	"Жокей"
);

$const_horses_sex = array(
	"Мерин",
	"Жеребец",
	"Кобыла"
);

$const_horses_poroda = array(
	"Абиссинская",
	"Австралийская Брамби",
	"Австралийская рабочая",
	"Адаевская",
	"Албанская",
	"Алтайская",
	"Альтер",
	"Американский верховой пони",
	"Амурская",
	"Англо-арабская",
	"Англо-донская",
	"Англо-Кабардинская",
	"Андалузская",
	"Андравида",
	"Аппалуза",
	"Арааппалуза",
	"Арабская",
	"Аргентинская верховая (Криоло)",
	"Арденская",
	"Астурийская",
	"Ахалтекинская",
	"Ацтека",
	"Баварская",
	"Баден-Вюртембергская",
	"Бакскин",
	"Балеарнская",
	"Балкарская",
	"Бан-ей",
	"Банкер",
	"Басото",
	"Башкирская",
	"Белорусская упряжная",
	"Белужди",
	"Бельгийская теплокровная",
	"Бельгийская теплокровная",
	"Берберийская",
	"Бирум",
	"Блэк Форрест-пони",
	"Боер",
	"Ботиа",
	"Брабансон",
	"Бранденбургская",
	"Бретонская",
	"Буденновская",
	"Булонская",
	"Бурятская",
	"Великопольская",
	"Венгерская теплокровная",
	"Вестфальская",
	"Владимирский тяжеловоз",
	"Восточно-Болгарская",
	"Вятская",
	"Галисийская",
	"Галисийский пони",
	"Ганноверская",
	"Гвангкси",
	"Гельдерландская",
	"Гессенская",
	"Гидран",
	"Голландская верховая",
	"Голландская упряжная",
	"Голштинская",
	"Готландская",
	"Гронингенская",
	"Гуцульская",
	"Дартмурский пони",
	"Датская",
	"Дейлс Пони",
	"Делибозская",
	"Джерма",
	"Джинжу",
	"Донгольская",
	"Донская",
	"Дулмен пони",
	"Дунайская",
	"Египетская",
	"Ерская",
	"Жмудская",
	"Иомудская",
	"Иранская",
	"Ирландская рабочая",
	"Ирландская спортивная",
	"Исландский пони",
	"Кабардинская",
	"Казахская",
	"Казивари",
	"Кайюс",
	"Калабрезе",
	"Калмыцкая",
	"Камаргская",
	"Камполина",
	"Канадская",
	"Карабаирская",
	"Карабахская",
	"Карачаевская",
	"Карельская",
	"Картуханская",
	"Каспийская",
	"Кватгани",
	"Квортерхорс",
	"Керри Бог Пони",
	"Киргизская",
	"Кирди",
	"Кисбер Фелвер",
	"Кисо",
	"Кладрубская",
	"Клайдесдейл",
	"Клевлендская гнедая",
	"Кнабструп",
	"Кнабструппер",
	"Колорадо рейнджер",
	"Коннемара",
	"Криоло",
	"Кузнецская",
	"Кустанайская",
	"Кушумская",
	"Латвийская теплокровная",
	"Липицианская",
	"Литовская тяжеловозная",
	"Лозино",
	"Локайская",
	"Лошадь Пржевальского",
	"Лузитано",
	"М'Байяр",
	"Малопольская",
	"Мангаларга",
	"Марвари",
	"Мегрельская",
	"Мезенская",
	"Мекленбургская",
	"Меренский пони",
	"Мессара",
	"Миниатюрная лошадь",
	"Минусинская",
	"Мисаки",
	"Миссури фокстроттер",
	"Мияко",
	"Монгольская",
	"Моравская",
	"Морган",
	"Мулы",
	"Мургезская",
	"Мустанг Кигера",
	"Мустанги",
	"Нарымская",
	"Ноитгедахский пони",
	"Нома",
	"Норвежский Фиорд",
	"Нордландская",
	"Норийская",
	"Нью Форест пони",
	"Ньюфаундленд пони",
	"Ольденбургская",
	"Онежская",
	"Орловский рысак",
	"Паломино",
	"Пантанейро",
	"Пасо-фино",
	"Перунский пасо",
	"Першерон",
	"Печорская",
	"Пинто",
	"Пиринейский тарпан",
	"Польский коник",
	"Пэйнт",
	"Райд-пони",
	"Рейнская",
	"РокиМаунтин",
	"Русская верховая",
	"Русская тяжеловозная",
	"Русский рысак",
	"Саксонская",
	"Саньхэма",
	"Северный шведский пони",
	"Северовосточная",
	"Советская тяжеловозная",
	"Сомалийский пони",
	"Сорайя",
	"Стандартбредная",
	"Суданская",
	"Суффолкская",
	"Тавдинская",
	"Тарпан",
	"Тенессийская верховая",
	"Терская",
	"Токара",
	"Торийская",
	"Тракененская",
	"Тувинская",
	"Тушинская",
	"Тюрингская",
	"Украинская верховая",
	"Уэльский пони",
	"Фалабелла",
	"Фарерский пони",
	"Фелл пони",
	"Фесссалийская",
	"Финская лошадь",
	"Фиордская",
	"Флеве",
	"Флоридский крэкер",
	"Фоута",
	"Французская верховая",
	"французская верховая (сель)",
	"Французская рысистая",
	"Фредериксборская",
	"Фрейбергская",
	"Фризская",
	"Фуриозо",
	"Хайлэнд Пони",
	"Хакасская",
	"Хакнэ",
	"Хафлингер",
	"Хеку",
	"Хоккайдская",
	"Цангерсхайде",
	"Цвайбрюкен",
	"Чеджи",
	"Чешская теплокровная",
	"Чилийский Корралеро",
	"Чинкотегу пони",
	"Чистокровная верховая",
	"Шагия",
	"Шайр",
	"Шварцвальдская",
	"Шведская полукровная",
	"Швейцарская полукровная",
	"Шетлендский пони",
	"Шлезвигская",
	"Эксмур пони",
	"Эстонская",
	"Ютландская",
	"Якутская",
	"Другая"
);

$const_horses_mast = array(
	"Серая масть",
	"Вороная масть",
	"Гнедая масть",
	"Рыжая",
	"Чубарая",
	"Пегая",
	"Игреневая",
	"Другая"
);

$const_horses_spec = array(
	"Бега",
	"Военно-прикладной спорт",
	"Вольтижировка",
	"Выездка",
	"Выставки",
	"Драйвинг",
	"Конкур",
	"Паралемпийский спорт",
	"Пробеги",
	"Прочее",
	"Рейтинг",
	"Семинар",
	"Скачки",
	"Спорт - прочее",
	"Троеборье"
);

$const_ability = array(
	"Занятия конкуром",
	"Раздевалка",
	"Прогулки в лес/поле",
	"Троеборные препятствия",
	"Туалет",
	"Аренда денников",
	"Обучение",
	"Участие в соревнованиях",
);

$const_club_type = array(
	"Открытый клуб",
	"Закрытый клуб"
);