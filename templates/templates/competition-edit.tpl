{* Smarty *}
{include "modules/header.tpl"}
{include "modules/modal-add-user.tpl"}
<script src="js/chosen.jquery.min.js"></script>
<script src="js/jquery-sortable.js"></script>
<!-- implement fileupload -->
<script src="js/upload/jquery.ui.widget.js"></script>
<script src="js/upload/jquery.iframe-transport.js"></script>
<script src="js/upload/jquery.fileupload.js"></script>
<script>
    $(function(){
        $('#startlist_table').sortable({
            containerSelector: 'div',
            itemPath: '> .route_table',
            itemSelector: 'div.dragabble',
            placeholder: '<div class="placeholder row" style="border: 1px solid #000; height: 25px; background: #ffff00"/>',
            onDrop: function  (item, container, _super) {
                $('#startlist .route_table').each(function(){
                    var i = 0;
                    var route_id = $(this).attr('alt');
                    $('.dragabble',this).each(function(){
                         i++;
                        var ride_id = $(this).attr('alt');
                        $('.span1 .ordering',this).val(i);
                        $('.span1 .ordering',this).attr('name','ordering['+ride_id+']['+route_id+']');
                        $('.span1 .ordering_txt',this).html(i);
                    });
                });
                change_riders_ordering();
                _super(item)
            }
        });
        {literal}
        $('.delete_rider').click(function(){
            var rid = $(this).attr('alt');
            var $this = $(this).closest('div.dragabble');
            api_query({
                qmethod: "POST",
                amethod: "delete_rider",
                params: {rid:rid},
                success: function (data) {
                    $this.remove();
                    $('#startlist .route_table').each(function(){
                        var i = 0;
                        var route_id = $(this).attr('alt');
                        $('.dragabble',this).each(function(){
                            i++;
                            var ride_id = $(this).attr('alt');
                            $('.span1 .ordering',this).val(i);
                            $('.span1 .ordering',this).attr('name','ordering['+ride_id+']['+route_id+']');
                            $('.span1 .ordering_txt',this).html(i);
                        });
                    });
                    change_riders_ordering();
                },
                fail: "standart"
            });
        });
        {/literal}

        $("#fileupload_file").fileupload({
            url: '/api/api.php?m=file_club_upload&id={$comp.id}',
            dataType: 'json',
            done: function (e, data) {
                resp = data.result;
                if (resp.type=="success") {
                    $('.comp-added-files').append('<li class="'+resp.response.ext+'-file">'+resp.response.filename+'<button type="button" class="close">&times;</button></li>');
                } else {
                    alert(resp.response[0]);
                }
            }
        });
    })
    {literal}
    $(document).ready(function(){
        $('.compt-results').on('change','.user_id',function()
        {
            var user_id = $('option:selected',this).val();
            var $this = $(this).closest('tr');
            api_query({
                qmethod: "POST",
                amethod: "user_horses",
                params:  {id:user_id},
                success: function (data) {
                    $this.find('select.horse').html(data);
                },
                fail:    "standart"
            });

            api_query({
                qmethod: "POST",
                amethod: "get_user_club",
                params:  {id:user_id},
                success: function (data) {
                    $this.find('.club_id').val(data.club_id);
                    if(data.club_name == null) data.club_name = 'Частный владелец';
                    $this.find('.team span').html(data.club_name);
                },
                fail:    "standart"
            });
        });
        $('.compt-results').on('click','.add_horse',function(){
            var user_id = $(this).closest('tr').find('.user_id option:selected').val();
            $('#modal_add_horse .o_uid').val(user_id);
            $('#modal_add_horse').modal("show");

        });
        $('#addRoute .type').change(function(){
            $('#addRoute input.sub_type').prop('checked',false);
            var select = $('option:selected',this).val();
            $('#addRoute input.sub_type').each(function(){
                var type = $(this).attr('alt');
                if(type == select){
                    $(this).closest('label').css('display','');
                }else{
                    $(this).closest('label').css('display','none');
                }
            });
        });
    });
    {/literal}
</script>
<link  href="css/chosen.css" rel="stylesheet">
<script>
	function edit_comp(form) {
		api_query({
			qmethod: "POST",
			amethod: "comp_edit",
			params: $(form).serialize(),
			success: function (data) {
				alert(data[0]);
			},
			fail: "standart"
		});
	}
    function change_riders_ordering(){
        api_query({
            qmethod: "POST",
            amethod: "change_riders_ordering",
            params: $('#form_riders_ordering').serialize(),
            success: function (data) {
            },
            fail: "standart"
        });
    }
    $(function(){
        {literal}$(".clubs-page .chosen-select").chosen({no_results_text: "Не найдено по запросу",inherit_select_classes: true, placeholder_text_multiple: "Выберите виды"});{/literal}
    });
</script>


<div class="container clubs-page club-admin main-blocks-area club-block club-add-comp">
		<div class="row">
		
			<div class="span12 lthr-bgborder block club-tabs">
				<h3 class="inner-bg">Настройки клуба<span class="pull-right text-italic"><a href="/club.php?id={$comp.o_cid}">Вернуться в клуб</a></span></h3>
				<div class="row">
				<ul id="clubTab" class="nav nav-tabs new-tabs tabs2">
					<li><a href="/club-admin.php?id={$comp.o_cid}#main-admin">Основные</a></li>
					<li><a href="/club-admin.php?id={$comp.o_cid}#about-admin">О клубе</a></li>
					<li><a href="/club-admin.php?id={$comp.o_cid}#members-admin">Участники</a></li>
					<li class="active"><a href="#competitions-admin" data-toggle="tab">Соревнования</a></li>
					<li><a href="/club-admin.php?id={$comp.o_cid}#adv-admin">Реклама</a></li>
					<li><a href="/club-admin.php?id={$comp.o_cid}#contact-admin">Контакты</a></li>
				</ul>
				
				<div id="friendsTabContent" class="tab-content bg-white">
				
			<div class="tab-pane in active" id="competitions-admin">
					<div class="row">
					<form onsubmit="edit_comp(this); return false;">
						<input type="hidden" name="id" value="{$comp.id}">
						<div class="span12">
							<div class="row option-row">
								<div class="title-hr">
									<div class="title span7">Редактирование соревнования</div>
									<button href="club-admin-add-comp.php" class="btn btn-warning span3">Сохранить изменения</button>
									<a href="/club-admin.php?id={$comp.o_cid}" class="btn span1">Отмена</a>
								</div>
							</div>
						</div>
							
						<div class="row option-row">
							<h5 class="title-hr">Главные настройки</h5>
									<div class="span6">
											<div class="row">
											<div class="controls controls-row">
												<label class="span6">Название соревнования</label>
												<input type="text" class="span6" name="name" value="{$comp.name}">
												<label class="span3">Дата начала</label>
												<label class="span3">Дата завершения</label>
												<input type="text" class="span3" placeholder="дд.мм.гггг" name="bdate" value="{$comp.bdate}">
												<input type="text" class="span3" placeholder="дд.мм.гггг" name="edate" value="{$comp.edate}">
												<label class="span3">Страна</label>
												<label class="span3">Город</label>
												<select class="span3" name="country">
													{foreach $const_countries as $country}
														<option {if $country == $comp.country}selected{/if}>{$country}</option>
													{/foreach}
											   </select>
												<input type="text" class="span3" name="city" value="{$comp.city}">
											   <label class="span6">Адрес проведения соревнования</label>
												<input type="text" class="span6" name="address" value="{$comp.address}">
												<label class="span6">Вид соревнований</label>
												<select class="span6 chosen-select" name="type[]" multiple>
													{foreach $const_types as $type}
														<option {if $comp.type|strstr:$type}selected{/if}>{$type}</option>
													{/foreach}
											   </select>
											</div>
											</div>
										</div>
									
									<div class="span6">
										<div class="controls controls-row">
											<label class="span6">Описание соревнования</label>
											<textarea class="span6" rows="5" name="desc">{$comp.desc}</textarea>
                                            <label class="span25">Документы  (pdf, word, excel):</label>
                                            <div class="fileupload span25" id="fileupload_file">
                                                <input type="file" name="avatar">
                                                <button class="btn btn-add-file">Добавить файл</button>
                                            </div>
                                            <ul class="unstyled span6 comp-added-files">
                                                {foreach $files as $file}

                                                    <li class="{$file.ext}-file">{$file.file}<button type="button" class="close">&times;</button></li>
                                                {/foreach}
                                            </ul>
                                            <label class="span6">Количество денников в наличии</label>
                                            <input type="number" name="dennik" class="span1" value="{$comp.dennik}">
										</div>
									</div>
						</div>
						</form>

							<div class="row option-row">
								<h5 class="title-hr">Маршруты соревнования</h5>
								<table class="table table-striped competitions-table routes">
									<tbody><tr>
									  <th>Дата/Время</th>
									  <th>Маршрут</th>
									  <th>Высота</th>
									  <th>Зачёт для</th>
									  <th>Статус</th>
									  <th><a class="btn btn-warning" href="#" onclick="prepare_to_add(); return false;">Добавить маршруты</a></th>
									</tr>
									{if $comp.routes}
										{foreach $comp.routes as $route}
											 <tr>
												<td class="comp-date"><p>{$route.bdate}</p></td>
												<td class="route">
													<a href="/competition.php?id={$comp.id}">{$route.name}</a>
												</td>
												<td class="height"><p>{$route.height}</p></td>
												<td class="credit-for"><p>{$route.exam}</p></td>
												<td class="status"><p>{$route.status}</p></td>
												<td class="change"><a href="#" class="btn btn-grey" onclick="prepare_to_edit({$route.id}); return false;">Изменить</a><button type="button" class="close" onclick="delete_route({$route.id}, this); return false;">&times;</button></td>
											</tr>
										{/foreach}
									{else}
										<tr>
											<td colspan="6" style="text-align: center;">Маршрутов пока нет</td>
										</tr>
									{/if}
								</tbody>
								</table>
						</div>
						
					<div class="row option-row">
						<div class="span12">
            <ul class="nav nav-tabs">
              {*<li><a href="#compt-members" data-toggle="tab">Участники</a></li>*}
              <li class="active"><a href="#compt-results" data-toggle="tab">Результаты</a></li>
              <li><a href="#startlist" data-toggle="tab">Стартовый лист</a></li>
              <li><a href="#compt-gallery" data-toggle="tab">Галерея</a></li>
              <li><a href="#compt-disqus" data-toggle="tab">Обсуждения</a></li>
            </ul>
            
			<div class="tab-content">
              
			  {*<div class="tab-pane in active" id="compt-members">
					<div class="span12">
						<h3 class="inner-bg">Всадники<span class="pull-right">223 человека</span></h3>
								<ul class="clubs-members">
									<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg"><p>Александр Гетманский</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg"><p>Елена Урановая</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
								</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Зрители<span class="pull-right">223 человека</span></h3>
								<ul class="clubs-members">
									<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg"><p>Александр Гетманский</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg"><p>Елена Урановая</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
								</ul>
					</div> 
					<div class="span12">
						<h3 class="inner-bg">Фотографы<span class="pull-right">223 человека</span></h3>
								<ul class="clubs-members">
									<li><a href="user-sample.php"><img src="i/sample-ava-1.jpg"><p>Александр Гетманский</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-2.jpg"><p>Елена Урановая</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-3.jpg"><p>Наталья Валюженич</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-4.jpg"><p>Кирилл Комоносов</p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-5.jpg"><p>Эрик Филлимонов </p></a></li>
									<li><a href="user-sample.php"><img src="i/sample-ava-6.jpg"><p>Екатерина Мариненко</p></a></li>
								</ul>
					</div> 
              </div> <!-- compt-members -->*}

<style>
.compt-results input[type=text] {
	width: 90px;
}
.standarts input[type=text] {
	width: 30px !important;
}
.disq td {
	background-color: red !important;
}
</style>
<script>
function send_results(form) {
	api_query({
		qmethod: "POST",
		amethod: "comp_results_update",
		params: $(form).serialize(),
		success: function (data) {
			alert(data[0]);
		},
		fail: "standart"
	})
}

function pre_add(el) {
	var element = $(el).closest("tr");
	var new_tr = element.clone();
	new_tr.find("input[type=text]").val("");
	new_tr.find("span").html("");
    new_tr.find("select option[value=0]").prop("selected",true);
    new_tr.find('.chosen-container').remove();
    {literal}new_tr.find('select.user_id').chosen({no_results_text: "Не найдено по запросу",inherit_select_classes: true, placeholder_text_multiple: "Выберите виды"});{/literal}
    new_tr.find('.chosen-container').css('width','134px');
	new_tr.insertBefore(element);
}

function aft_add(el) {
	var element = $(el).closest("tr");
	var new_tr = element.clone();
	new_tr.find("input[type=text]").val("");
    new_tr.find("span").html("");
	new_tr.find("select option[value=0]").prop("selected",true);
    new_tr.find('.chosen-container').remove();
    {literal}new_tr.find('select.user_id').chosen({no_results_text: "Не найдено по запросу",inherit_select_classes: true, placeholder_text_multiple: "Выберите виды"});{/literal}
    new_tr.find('.chosen-container').css('width','134px');
	new_tr.insertAfter(element);
}

function rem(el) {
	$(el).closest("tr").remove();
}

function cancel_disq(el) {
	$(el).closest("tr").removeClass("disq")
	.find("[name*=disq]").val("0");
    $(el).closest("tr").find("[name*=pos]").css("display","");
}
function disq(el) {
	$(el).closest("tr").addClass("disq")
	.find("[name*=disq]").val("1");
    $(el).closest("tr").find("[name*=pos]").css("display","none");
}
$(function () {
	$('#fileupload').fileupload({
		maxNumberOfFiles: 1,
		dataType: 'json',
		url: "/api/api.php?m=comp_results_parse&id={$comp.id}",
		done: function (e, data) {
			var result = data.result
			if (result.type == "success") {
				window.location.reload();
			} else {
				errors = "";
				for (i = 0;i < result.response.length; ++i)
					errors += result.response[i] + "<br>";
				alert(errors);
			}
		}
	});
})
</script>

              
			  <div class="tab-pane active" id="compt-results">
				<form onsubmit="send_results(this);return false;">
				<input type="hidden" name="id" value="{$comp.id}" >
				<div class="c-results-btns">
					<ul>
						<li><div class="fileupload btn btn-warning" id="fileupload">
							Загрузить файл
							<input type="file" name="xls">
						</div></li>
						<li><a href="/api/generate_xls.php?id={$comp.id}" target="_blank" class="btn btn-warning">Скачать результаты</a></li>
                        <li><button class="btn btn-warning">Сохранить</button></li>
						<li><a href="#modal-add-user" data-toggle="modal" class="btn btn-warning">Добавить всадника</a></li>
					</ul>
				</div>

						{if $comp.routes}
							{foreach $comp.routes as $route}
                    <table class="table table-striped competitions-table compt-results admin-compts">
                        <tbody>
                        {if $route.sub_type == 'на чистоту и трезвость'}
                        <tr>
                            <th rowspan="2">№</th>
                            <th rowspan="2">Всадник</th>
                            <th rowspan="2">Разряд</th>
                            <th rowspan="2">Лошадь</th>
                            <th rowspan="2">Команда</th>
                            <th colspan="2"><center>Маршрут</center></th>
                            <th rowspan="2"> </th>
                        </tr>
                        <tr>
                            <th>Ш.О.</th>
                            <th>Время</th>
                        </tr>
                        {elseif $route.sub_type == 'с перепрыжкой'}

                            <tr>
                                <th rowspan="2">№</th>
                                <th rowspan="2">Всадник</th>
                                <th rowspan="2">Разряд</th>
                                <th rowspan="2">Лошадь</th>
                                <th rowspan="2">Команда</th>
                                <th colspan="2"><center>Маршрут</center></th>
                                <th colspan="2"><center>Перепрыжка</center></th>
                                <th rowspan="2"> </th>
                            </tr>
                            <tr>
                                <th>Ш.О.</th>
                                <th>Время</th>
                                <th>Ш.О.</th>
                                <th>Время</th>
                            </tr>
                        {elseif $route.sub_type == ''}
                        <tr>
                            <th>№</th>
                            <th>Всадник</th>
                            <th>Разряд</th>
                            <th>Лошадь</th>
                            <th>Команда</th>
                            <th>Ш.О.</th>
                            <th>Время </th>
                            <th>Ш.О.</th>
                            <th>Пере- прыжка</th>
                            <th>Норма</th>
                            <th> </th>
                        </tr>
                        {/if}
								<tr><td colspan="11" class="table-caption">{$route.name}</td></tr> 
								{foreach $comp.results.{$route.id} as $res}
									<tr {if $res.disq}class="disq"{/if} data-disq={$res.disq}>
										<td class="n total standarts">
											<input type="text" name="pos[{$route.id}][]" value="{$res.rank}" {if $res.disq}style="display: none"{/if}>
											<input type="hidden" name="disq[{$route.id}][]" value="{$res.disq}">
										</td>
										<td class="name">
                                            <select name="fio[{$route.id}][]" style="width: 140px" class="chosen-select user_id">
                                                <option value="0">Выбрать всадника</option>
                                                {foreach $users as $usr}
                                                    <option value="{$usr.id}" {if $usr.id == $res.user_id}selected="selected"{/if}>{$usr.lname} {$usr.fname}, {$usr.bdate}, {$usr.city}</option>
                                                {/foreach}
                                            </select>
                                        </td>
										<td class="discharge standarts"><input type="text" name="degree[{$route.id}][]" value="{$res.razryad}"></td>
										<td class="horse" alt="{$res.horse}">

                                            <select name="horse[{$route.id}][]" class="horse" style="width: 80px">
                                                {foreach $res.horses as $horse}
                                                    <option value="{$horse.id}" {if $horse.id == $res.horse}selected="selected"{/if}>{$horse.nick}</option>
                                                {/foreach}
                                            </select>
                                            <center><a href="javascript:void(0)" class="add_horse">+</a></center>
                                        </td>
										<td class="team">
                                            <span>{$res.club}{if $res.club == '' && $res.user_id}Частный владелец{/if}</span>
                                            <input type="hidden" name="club_id[{$route.id}][]" class="club_id" value="{$res.club_id}">
                                        </td>
										<td class="standarts"><input type="text" name="shtraf_route[{$route.id}][]" value="{$res.shtraf_route}"></td>
										<td class="standarts"><input type="text" name="time[{$route.id}][]" value="{$res.time}"></td>
										<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость'}style="display: none"{/if}><input type="text" name="shtraf[{$route.id}][]" value="{$res.shtraf}"></td>
										<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость'}style="display: none"{/if}><input type="text" name="reroute[{$route.id}][]" value="{$res.rerun}"></td>
										<td class="standarts" {if $route.sub_type == 'на чистоту и трезвость' || $route.sub_type == 'с перепрыжкой'}style="display: none"{/if}><input type="text" name="norma[{$route.id}][]" value="{$res.norma}"></td>
										<td class="closebtn"><div class="dropdown button">
												<button type="button" class="close dropdown-toggle" role="button" data-toggle="dropdown">&equiv;</button>
													<ul id="menu1" class="dropdown-menu" role="menu">
														<li><a tabindex="-1" href="#" onclick="pre_add(this); return false;"><i class="icon-chevron-up"></i> Добавить ряд выше</a></li>
														<li><a tabindex="-1" href="#" onclick="aft_add(this); return false;"><i class="icon-chevron-down"></i> Добавить ряд ниже</a></li>
														<li class="divider"></li>
														<li><a tabindex="-1" href="#" onclick="disq(this); return false;"><i class="icon-remove-sign"></i> Исключить</a></li>
														<li><a tabindex="-1" href="#" onclick="cancel_disq(this); return false;"><i class="icon-remove-sign"></i> Отменить исключение</a></li>
														<li><a tabindex="-1" href="#" onclick="rem(this); return false;"><i class="icon-minus-sign"></i> Удалить всадника</a></li>
													</ul>
												</div></td>
									</tr>
								{/foreach}
                        </tbody>
                    </table>
							{/foreach}
						{else}
                            <table class="table table-striped competitions-table compt-results admin-compts">
                                <tbody><tr>
                                    <th>№</th>
                                    <th>Всадник</th>
                                    <th>Разряд</th>
                                    <th>Лошадь</th>
                                    <th>Команда</th>
                                    <th>Штраф. очки маршрут</th>
                                    <th>Время маршрут</th>
                                    <th>Штраф. очки</th>
                                    <th>Пере- прыжка</th>
                                    <th>Норма</th>
                                    <th> </th>
                                </tr>
							<tr>
								<td colspan="11" style="text-align: center;">Для редактирования результатов добавьте маршрут.</td>
							</tr>
                            </tbody>
                            </table>
						{/if}

              	</form>
              </div><!-- compt-results -->
              <div class="tab-pane" id="startlist">
                  <form action="#" id="form_riders_ordering" onsubmit="change_riders_ordering(); return false;">
                  <div class="table table-striped competitions-table compt-results admin-compts" id="startlist_table">
                        <div class="row header">
                          <div class="span1">№</div>
                          <div class="span2">Всадник</div>
                          <div class="span2">Разряд</div>
                          <div class="span2">Лошадь</div>
                          <div class="span2">Владелец лошади</div>
                          <div class="span2">Клуб</div>
                          <div class="span1">Удалить</div>
                      </div>
                      {if $comp.routes}

                              {foreach $comp.routes as $route}
                                  <div class="route_table" alt="{$route.id}"><div class="row"><div class="table-caption no-drag span12">{$route.name}</div></div>
                                  {if $comp.startlist.{$route.id}}

                                          {foreach $comp.startlist.{$route.id} as $res}
                                              <div class="dragabble row" alt="{$res.ride_id}">
                                                  <div class="span1">
                                                      <span class="ordering_txt">{$res.ordering}</span>
                                                      <input type="hidden" name="ordering[{$res.ride_id}][{$route.id}]" class="ordering" value="{$res.ordering}">
                                                  </div>
                                                  <div class="span2">{$res.fio}</div>
                                                  <div class="span2">-</div>
                                                  <div class="span2">{$res.horse}</div>
                                                  <div class="span2">{if $res.owner}{$res.owner}{else}{$res.ownerName}{/if}</div>
                                                  <div class="span2">{$res.club}</div>
                                                  <div class="span1"><a href="javascript:void()" class="delete_rider" alt="{$res.ride_id}">удалить</a> </div>
                                              </div>
                                          {/foreach}

                                  {else}
                                      <div class="row dragabble">
                                          <div class="span12" style="text-align: center;"></div>
                                      </div>
                                  {/if}

                                   </div>
                              {/foreach}

                      {else}
                          <div class="row">
                              <div class="span12" style="text-align: center;">Нет маршрутов.</div>
                          </div>
                      {/if}
                  </div>
                  </form>
              </div><!-- compt-startlist -->
			  
			  <div class="tab-pane" id="compt-gallery">
                <div class="photos">
					<ul class="photo-wall">
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-1.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
						<li><img src="i/sample-img-3.jpg"></li>
						<li><img src="i/sample-img-4.jpg"></li>
						<li><img src="i/sample-img-5.jpg"></li>
						<li><img src="i/sample-img-2.jpg"></li>
					</ul>
				</div>
              </div><!-- compt-gallery -->
			  
			  <div class="tab-pane" id="compt-disqus">
              </div>
			  
            </div>
          </div>
					</div>
						
					</div>
				</div> <!-- //competitions-club -->
				
				<div class="tab-pane" id="adv-admin">
					<div class="row">
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
						<div class="span2" style="text-align: justify">
							<h4>Инфраструктура КСК «Битца»</h4>
							<p>Инфрастуктура включает все необходимое как для профессиональных занятий спортом, так и для активного и комфортного отдыха.</p>
						</div>
					</div>
				</div> <!-- //gallery-club -->
				
				<div class="tab-pane" id="contact-admin">
					<div class="row">
							<div class="span12">
									<p>еальность. Катарсис, как следует из вышесказанного, решительно подчеркивает смысл жизни, учитывая опасность, которую представляли собой писания Дюринга для не окрепшего еще немецкого рабочего движения. Отношение к современности понимает под собой конфликт, однако Зигварт считал критерием истинности необходимость и общезначимость, для которых нет никакой опоры в объективном мире. Искусство заполняет бабувизм, при этом буквы А, В, I, О символизируют соответственно общеутвердительное, общеотрицательное, частноутвердительное и частноотрицательное суждения.</p>
							</div>
						</div>
				</div> <!-- //contact-club -->
				
			
				</div>
			</div>
			</div>

		</div> <!-- /row -->
</div>
<script>

function add_option() {
	return $("<div class='opt'> \
		<select class='span2' name='opt_name[]'> \
			<option>Тип грунта</option> \
			<option selected>Вступительный взнос</option> \
			<option>Дистанция </option> \
			<option>Размеры боевого поля</option> \
			<option>Размеры разминочного поля</option> \
	</select> \
	<input class='span3' type='text' name='opt[]' /> \
	<a href='#' class='span1' onclick='del_option(this); return false;'>удалить</a> \
	</div> \
	<div class='clear'></div>").appendTo("#addRoute #options");	
}

function del_option(el) {
	var element = $(el).closest(".opt");
	var next_clear = element.next(".clear");
	element.remove();
	next_clear.remove();
}

function add_route(form) {
	api_query({
		qmethod: "POST",
		amethod: "comp_route_add",
		params: $(form).serialize(),
		success: function (data) {
			window.location.reload();
		},
		fail: function (data) { //your modal not work
			var err = "";
			for (i=0;i<data.length;++i) {
				err += data[i] + "\n";
			}
			alert(err);
		}
	});
}

function edit_route(form) {
	api_query({
		qmethod: "POST",
		amethod: "comp_route_edit",
		params: $(form).serialize(),
		success: function (data) {
			window.location.reload();
		},
		fail: function (data) { //your modal not work
			var err = "";
			for (i=0;i<data.length;++i) {
				err += data[i] + "\n";
			}
			alert(err);
		}
	});
}

function delete_route(id, element) {
	api_query({
		qmethod: "POST",
		amethod: "comp_route_delete",
		params: {
			id: id
		},
		success: function (data) {
			$(element).closest("tr").remove();
		},
		fail: "standart"
	});
}

function prepare_to_edit(id) {
	api_query({
		qmethod: "POST",
		amethod: "comp_route_info",
		params: {
			id : id
		},
		success: function (data) {
			var form = $("#addRoute");
			form.find("#options .opt").remove();
			$.each(data, function (index, value) {
				form.find("[name="+index+"]").val(value);
			});
			$.each(data.options, function (index, value) {
				var new_opt = add_option();
				new_opt.find("select").val(index);
				new_opt.find("input").val(value);
			});
			form.find("h3").text("Изменение маршрута");
			form.find("form").attr("onsubmit", "edit_route(this); return false;");
			form.find("[name=id]").val(data.id);
			form.modal("show");
		},
		fail: "standart"
	});
}

function prepare_to_add() {
	var mdl = $("#addRoute");
	mdl.find("#options .opt").remove();
	mdl.find("h3").text("Добавление маршрута");
	mdl.find("form").attr("onsubmit", "add_route(this); return false;");
	mdl.find("input[type=text]").val("");
	add_option();
	mdl.modal("show");
}



</script>
<div id="addRoute" class="modal hide" tabindex="-1" role="dialog" aria-hidden="false">
     <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
            <h3>Добавление маршрута</h3>
    </div>
    <div class="modal-body">
            <form class="form-horizontal" onsubmit="add_route(this);return false;">
            	<input type="hidden" name="cid" value="{$comp.id}">
            	<input type="hidden" name="id" value="">
                <div class="controls controls-row">
                    <label class="span6">Вид соревнования<span class="req-field">*</span></label>
                    <select class="span3 type" name="type">
						{foreach $const_types as $type}
							<option>{$type}</option>
						{/foreach}
                    </select><br/>
                    <div class="span6">
                        <label class="sub_type" style="display: none"><input type="radio" name="sub_type" class="sub_type" alt="Конкур" value="на чистоту и трезвость"> на чистоту и трезвость</label><br/>
                        <label class="sub_type" style="display: none"><input type="radio" name="sub_type" class="sub_type" alt="Конкур" value="с перепрыжкой"> с перепрыжкой</label>
                    </div>

                    <div class="span6"><hr></div>
                </div>
                
                <div class="controls controls-row">
                    <label class="span3">Маршрут<span class="req-field">*</span></label>
                    <label class="span3">Дата начала<span class="req-field">*</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Время начала</label>
                    <input type="text" class="span3" name="name">
                    <div class="span3">
                        <input type="text" class="span-mini" name="date"><input type="text" class="span-mini" name="time">
                    </div>
                </div>
                
                <div class="controls controls-row">
                    <label class="span3">Статус<span class="req-field">*</span></label>
                    <label class="span3">Зачёт для<span class="req-field">*</span></label>
                    <select class="span3" name="status">
                        <option>Всероссийский</option>
                        <option>Международный</option>
                        <option>Местный</option>
                    </select>
                    <select class="span3" name="exam">
                        <option>Дети 12-14 лет</option>
                        <option>Любители 18-30 лет</option>
                        <option>Любители 31 год и старше</option>
                        <option>Юноши 14-18 лет</option>
                        <option>Взрослые спортсмены</option>
                        <option>Взрослые спортсмены на молодых лошадях 4-5 лет</option>
                    </select>
                </div>          
                <div class="controls controls-row">
                    <label class="span6">Высота<span class="req-field">*</span></label>
                    <input type="text" class="span3" name="height">
                    <div class="span6"><hr></div>
                </div>
                
                <div class="controls controls-row multi-select" id="options">
    
                    <p class="span6"><a href="#" onclick="add_option();return false;">Добавить ещё опций</a></p>
                </div>
                
                <div class="controls controls-row">
                         <button type="submit" class="btn btn-warning span3">Добавить маршрут</button>
                         <button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
                 </div>
            </form> 
    </div>
</div>
<script>
    function save_horse(form) {
        api_query({
            qmethod: "POST",
            amethod: "horses_add_admin",
            params: $(form).serialize(),
            success: function (id) {
                var name = $(form).find('input[name="nick"]').val();
                var o_uid = $(form).find('.o_uid').val();
                $('#compt-results select.user_id').each(function(){
                    var tmp_selected = $('option:selected',this).val();
                    if(tmp_selected == o_uid){
                        $(this).closest('tr').find('select.horse').append('<option value="'+id+'">'+name+'</option>');
                    }
                });
                $('#modal_add_horse input[type="text"]').val("");
                $('#modal_add_horse select option:first-child').prop("selected",true);
                $('#modal_add_horse').modal("hide");
            },
            fail: function (err) { //our modal not working
                console.log(err);
                var errs = "";
                for (i=0;i<err.length;++i)
                    errs += err[i] + "\n";
                alert(errs);
            }
        })
    }
</script>
<div id="modal_add_horse" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Добавление лошади</h3>
    </div>
    <div class="modal-body">
        <form class="form-horizontal" action="#" onsubmit="save_horse(this); return false;">
            <div class="controls controls-row">
                <label class="span3">Кличка лошади:</label><label class="span3">Пол лошади:</label>
                <input type="text" class="span3" name="nick">
                <select class="span3 offset1" name="sex">
                    {foreach $const_horses_sex as $sex}
                        <option>{$sex}</option>
                    {/foreach}
                </select>
            </div>
            <div class="controls controls-row">
                <label class="span3">Рост лошади:</label><label class="span3">Порода:</label>
                <input type="text" class="span3" name="rost">
                <select class="span3 offset1" name="poroda">
                    {foreach $const_horses_poroda as $poroda}
                        <option>{$poroda}</option>
                    {/foreach}
                </select>
            </div>
            <div class="controls controls-row">
                <label class="span3">Масть:</label><label class="span3">Паспорт:</label>
                <select class="span3 offset1" name="mast">
                    {foreach $const_horses_mast as $mast}
                        <option>{$mast}</option>
                    {/foreach}
                </select>
                <input type="text" class="span3" name="pasport">
            </div>
            <div class="controls controls-row">
                <label class="span3">Год рождения:</label><label class="span3">Место рождения:</label>
                <input type="text" class="span3" name="byear">
                <input type="text" class="span3" placeholder="Пример, клуб 'СССР'" name="bplace">
            </div>
            <div class="controls controls-row">
                <input type="hidden" class="o_uid" name="o_uid" value="">
                <button type="submit" class="btn btn-warning span3">Добавить</button>
                <button class="btn span3" data-dismiss="modal" aria-hidden="true">Отмена</button>
            </div>
        </form>
    </div>
</div>

{include "modules/footer.tpl"}