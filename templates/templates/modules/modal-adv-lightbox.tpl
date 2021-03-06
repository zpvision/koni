{* Smarty *}
<script>
    {literal}
    function update_description(form) {
        api_query({
            qmethod: "POST",
            amethod: "gallery_update_description",
            params: $(form).serialize(),
            success: function (resp) {
                var desc = $('#change_description_form textarea').val();
                $('#change_description_form').css('display','none');
                $('#gallery_desc').html(desc);
                $('#gallery_desc').css('display','');
            },
            fail: "standart"
        })
    }

    function change_description(){
        var desc = $('#gallery_desc').html();
        $('#change_description_form').css('display','inline-block');
        $('#change_description_form textarea').html(desc);
        $('#gallery_desc').css('display','none');
    }
    {/literal}
</script>
<!-- модалка галереи -->
<div id="modal-gallery-post" class="modal hide modal900 modal-notitle modal-gallery-post" tabindex="-1" role="dialog">
    <div class="modal-images-gallery">
        <a href="#" class="gallery-slide-left" id="gallery_prev"></a>
        <a href="#" class="gallery-slide-right" id="gallery_next"></a>
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <img src="i/sample-img-1.jpg" id="gallery_full" />
    </div>
    <div class="modal-body">
        <table class="image-info"> <!-- класс .without-descr добавленный к таблице делает модалку без начального описания-->
            <tr>
                <td class="info" align="right">
                    <ul>
                        <li><p class="dt">Добавлена:</p>
                            <p class="dd date" id="gallery_date">15.02.2013 в 14:11</p></li>
                        <li><p class="dt">Отправитель:</p>
                            <p class="dd author" id="gallery_author"><a href="#">Leon Ramos</a></p></li>
                    </ul>
                </td>
        </table>
    </div>
    <div class="comments_container">

    </div>
</div>
<!-- //модалка галереи -->