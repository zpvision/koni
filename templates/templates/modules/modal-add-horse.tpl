<!-- implement jcrop -->
<script src="js/upload/jquery.Jcrop.min.js"></script>
<link rel="stylesheet" href="js/upload/jquery.Jcrop.min.css" type="text/css" />

{* Smarty *}
<script>
function add_parents() {
	$("<div class='controls controls-row'> \
		<select class='span2' name='pname[]'> \
			<option selected>Отец</option> \
			<option>Мать</option> \
			<option>Дедушка</option> \
			<option>Бабушка</option> \
		</select> \
		<input type='text' class='span4 offset1' placeholder='Имя отца лошади' name='parent[]'> \
	</div>").appendTo("#parents");	
}

function new_horse(form) {
	api_query({
		qmethod: "POST",
		amethod: "horses_add",
		params:  $(form).serialize(),
		success: function (data) {
			document.location.reload();
		},
		fail:    "standart"
	})
}

function update_photo_coords(c) {
    $('#modal-change-horse-avatar .step3 input[name=x1]').val(c.x);
    $('#modal-change-horse-avatar .step3 input[name=y1]').val(c.y);
    $('#modal-change-horse-avatar .step3 input[name=x2]').val(c.x2);
    $('#modal-change-horse-avatar .step3 input[name=y2]').val(c.y2);
}

function crop_horse(el) {
    api_query({
        qmethod: "POST",
        amethod: "horse_upload_avatar_crop",
        params:  $(el).serialize(),
        success: function (data) {
            $("#modal-add-horse img").attr("src", data.avatar);
            $("#modal-change-horse-avatar").modal("hide");
        },
        fail:    "standart"
    })
}

function new_horse_prepare() {
	$("#modal-add-horse form").attr("onsubmit", "new_horse(this);return false;");
	$("#modal-add-horse input[type=text]").val("");
	$("#modal-add-horse input[type=hidden]:not(.admin_user_id)").val("");
	$("#modal-add-horse #parents").html("");
	//avatar
	$("#modal-add-horse img").attr("src", "http://placehold.it/200x200");
	$("#modal-add-horse [name=avatar]").val("http://placehold.it/200x200");
	add_parents();
	$("#modal-add-horse").modal("show");	
}

{literal}
function delete_horse(hid, element,id) {
	if (confirm("Вы действительно хотите удалить лошадь?")) {
		api_query({
			qmethod: "POST",
			amethod: "horses_delete",
			params:  {id : hid,uid:id},
			success: function (data) {
				$(element).closest(".my-horse").remove();
			},
			fail:    "standart"
		})
	}
}

function edit_horse_prepare(hid) { //form clear
	api_query({
		qmethod: "POST",
		amethod: "horses_info",
		params:  {id : hid},
		success: function (data) {
			console.log(data);
			$.each(data, function( index, value ) {
				$("#modal-add-horse [name="+index+"]").eq(0).val(value);
			});
			if (data.parents != "") {
				var parents = $.parseJSON(data.parents);
				$("#modal-add-horse #parents").html("");
				$.each(parents, function( index, value ) {
					add_parents();
					var place = $("#modal-add-horse #parents .controls-row:last");
					place.find("select").val(index);
					place.find("input").val(value);
				});
			}
			$("#modal-add-horse form").attr("onsubmit", "edit_horse(this);return false;");
			$("#modal-add-horse input[name=hid]").val(data.id);	
			$("#modal-add-horse img").attr("src", data.avatar);		
			$("#modal-add-horse").modal("show");
		},
		fail:    "standart"
	})
}

function edit_horse(form) {
	api_query({
		qmethod: "POST",
		amethod: "horses_edit",
		params:  $(form).serialize(),
		success: function (data) {
			document.location.reload();
		},
		fail:    "standart"
	})
}

$(function () {
	$("#modal-add-horse #fileupload").fileupload({
		url: '/api/api.php?m=gallery_horse_upload_avatar',
		dataType: 'json',
		done: function (e, data) {
			resp = data.result;
			if (resp.type=="success") {
				console.log(resp.response.avatar);
				var mdl = $("#modal-add-horse");
				mdl.find("[name=avatar]").val(resp.response.avatar);
				mdl.find("img").attr("src", resp.response.avatar);
                $("#modal-change-horse-avatar .step3 input[name=avatar]").val(resp.response.avatar);
                $('#modal-change-horse-avatar').modal('show');
                $("#modal-change-horse-avatar .step3").css("display", "");
                $("#future-horse-avatar").Jcrop({
                    aspectRatio: 1,
                    onChange: update_photo_coords,
                    onSelect: update_photo_coords
                }, function () {
                    jcrop_api = this;
                    jcrop_api.setImage(resp.response.avatar, function () {
                        jcrop_api.setSelect([10,10,210,210]);
                    });

                });
			} else {
				alert(resp.response[0]);
			}
		}
	});
});
{/literal}
</script>
<div id="modal-add-horse" class="modal hide" tabindex="-1" role="dialog" aria-hidden="true">
	 <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			<h3 >Добавление лошади</h3>
	</div>
	<div class="modal-body" style="overflow-y: visible">
			<form class="form-horizontal"  method="post" action="#" onsubmit="new_horse(this);return false;">
						<div class="row">	
														
							<div class="controls controls-row">
								<label class="span3">Кличка лошади:</label><label class="span3">Пол лошади:</label>
								<input type="text" name="nick" class="span3">
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
								<label class="span3">Масть:</label><label class="span3">Специализация:</label>
								<select class="span3 offset1" name="mast">
									{foreach $const_horses_mast as $mast}
										<option>{$mast}</option>
									{/foreach}
							   </select>
								<select class="span3 offset1" name="spec">
									{foreach $const_horses_spec as $spec}
										<option>{$spec}</option>
									{/foreach}
							   </select>
							</div>
							
							<div class="controls controls-row">
								<label class="span3">Год рождения: <span class="req">*</span></label><label class="span3">Место рождения: <span class="req">*</span></label>
								<input type="text" class="span3" name="byear">
								<input type="text" class="span3" placeholder="Пример, клуб 'СССР'" name="bplace">
							</div>

                            <div class="controls controls-row">
								<label class="span6">Паспорт:</label>
                                <input type="text" class="span6" name="pasport">

							</div>
							
							<hr/>

							<div id="parents">
								<div class="controls controls-row">
									<label class="span7">Родословная:</label>
									<select class="span2" name="pname[]">
										<option selected>Отец</option>
										<option>Мать</option>
										<option>Дедушка</option>
										<option>Бабушка</option>
								   </select>
								   <input type="text" class="span4 offset1" placeholder="Имя отца лошади" name="parent[]">
								</div>	
							</div>

							<div class="controls controls-row">
								<label class="span7"><a href="#" onclick="add_parents();return false;">Добавить ещё родственников</a></label>
							</div>
							
							<hr/>
							
							<div class="controls controls-row">
								<div class="span3">
									<img src="http://placehold.it/200x200" />
									<input name="avatar" type="hidden" value ="http://placehold.it/200x200" /> {*XSS*}
									<input name="hid" type="hidden" value ="0" /> 
								</div>
								<div class="span3 offset1">
									<p>Главная фотография</p>
									<div class="content-add-buttons row">
										<div class="fileupload" id="fileupload">
										  <input type="file" name = "hav">
										  <button class="btn btn-add-photo"><i class="icon-camera"></i> Добавить фото</button>
										</div>
									</div>
									<p class="avatar-descr"><br/>Вы можете загрузить изображение в формате JPG, GIF или PNG. Если у Вас возникают проблемы с загрузкой, попробуйте выбрать фотографию меньшего размера.</p>
								</div>
							</div>
							
							<hr/>
							
							<!--<div class="add-files-to-gallery">
									<p>Добавить фото и видео в галерею лошади</p>
									<div class="content-add-buttons row">
										<div class="fileupload add-files-to-gallery">
											<input type="file" >
											<button class="btn btn-add-photo"><i class="icon-camera"></i> Добавить файлы</button>
										</div>
									</div>
							</div>-->
							
							<div class="controls controls-row">
								<label class="span3">О лошади</label>
								<textarea class="span6" rows="10" name="about"></textarea>
							</div>
							
						</div>
						<hr/>
						<div class="row">	
							<div class="controls controls-row">
								<center>
                                    <input type="hidden" name="user_id" class="user_id" value="">
                                    <input type="hidden" name="admin_user_id" class="admin_user_id" value="">
                                    <input type="hidden" name="name" class="name" value="">
                                    <input type="hidden" name="lname" class="lname" value="">
								<button type="submit" class="btn btn-warning span3">Сохранить</button>
								<button class="btn  span3"  data-dismiss="modal" aria-hidden="true">Отмена</button>
								</center>
							</div>
						</div>
			</form>
	</div>
</div>

<div id="modal-change-horse-avatar" class="modal hide modal700" tabindex="-1" role="dialog">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 >Изменить аватар</h3>
    </div>
    <div class="modal-body step3" style="display: none;">
        <form class="form-horizontal" action="#" onsubmit="crop_horse(this);return false;">
            <p>Выбранная область будет показываться на Вашей странице.</p>
            <center>
                <img src="http://placehold.it/1x1" id="future-horse-avatar" />
                <div class="change-avatar-buttons">
                    <input type="hidden" name="x1" value="10" />
                    <input type="hidden" name="y1" value="10" />
                    <input type="hidden" name="x2" value="210" />
                    <input type="hidden" name="y2" value="210" />
                    <input type="hidden" name="avatar" value="" />
                    <input type="hidden" name="id" value="{$club.id}" />
                    <button type="submit" class="btn btn-warning">Сохранить</button>
                    <button class="btn" data-dismiss="modal" aria-hidden="true">Отмена</button>
                </div>
            </center>
        </form>
    </div>
</div>