{* Smarty *}
{include "modules/header.tpl"}

<script type="text/javascript" src="js/bootstrap-multiselect.js"></script>
<script type="text/javascript" src="js/prettify.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<link rel="stylesheet" href="css/range.css">
<script type="text/javascript">
    $(document).ready(function() {
        window.prettyPrint() && prettyPrint();

        $('#event-clubs').multiselect({
            /*includeSelectAllOption: true,*/
            enableFiltering: true,
            maxHeight: 150,
            numberDisplayed: 10,
            nonSelectedText: 'Выберите из списка',
            filterPlaceholder: 'Поиск'
        });

        $(function() {
            $( "#adv-height" ).slider({
                range: true,
                min: 40,
                max: 220,
                step: 5,
                values: [ 40, 220 ],
                slide: function( event, ui ) {
                    var CustomAmount =  "От " + ui.values[ 0 ] + " до " + ui.values[ 1 ] + " см.";
                    document.getElementById('adv-height-amount').innerHTML = CustomAmount;
                    $('#height_from').val(ui.values[ 0 ]);
                    $('#height_to').val(ui.values[ 1 ]);
                }
            });
            $('#height_from').val($( "#adv-height" ).slider( "values", 0 ));
            $('#height_to').val($( "#adv-height" ).slider( "values", 1 ));
            var startAmount =   "От " + $( "#adv-height" ).slider( "values", 0 ) + " до " + $( "#adv-height" ).slider( "values", 1 ) + " см.";
            document.getElementById('adv-height-amount').innerHTML = startAmount;
        });
        search('#find_events');
    });
</script>
{literal}
    <script>
        function search(form){
            api_query({
                qmethod: "POST",
                amethod: "find_events",
                params:  $(form).serialize(),
                success: function (data) {
                    if(data == ''){
                        $('#search-results').html('<tr>\
                                <th>Дата</th>\
                                <th>Соревнование</th>\
                                <th>Вид</th>\
                                <th>Местоположение</th>\
                                <th>Клуб</th>\
                                <th>Статус</th>\
                        </tr><tr><td colspan="6"><div class="text-center"><strong>Ничего не найдено</strong></div></td></tr>');
                    }else{
                        $('#search-results').html('<tr>\
                                <th>Дата</th>\
                                <th>Соревнование</th>\
                                <th>Вид</th>\
                                <th>Местоположение</th>\
                                <th>Клуб</th>\
                                <th>Статус</th>\
                        </tr>'+data);
                    }

                },
                fail:    "standart"
            })
        }
    </script>
{/literal}
<div class="container main-blocks-area events-page">
    <div class="row">
        <div class="span12 lthr-bgborder filter-block block">
            <h3 class="inner-bg">Мероприятия<span class="pull-right"><a  href="my-events.php"> перейти к моим мероприятияем</a></span></h3>


            <div class="row">
                <form class="search-filter" id="find_events">

                    <table class="search-filter-block">
                        <tr>
                            <td colspan="2">
                                <label>Поиск по названию соревнования</label>
                                <input type="text" name="name" class="span6">
                            </td>
                            <td>
                                <label>Вид соревнования</label>
                                <select name="type" class="span3">
                                    <option value="">Любой</option>
                                    {foreach $const_types as $type}
                                        <option>{$type}</option>
                                    {/foreach}
                                </select>
                            </td>
                            <td rowspan="4">
                                <input type="submit" value="Найти" class="span3 btn btn-warning btn-large" onclick="search('#find_events'); return false;">
                                <p class="text-center"><a href="#">Сбросить фильтр</a></p>
                                <hr/>
                                <p class="block-descr">Создавать мероприятие может только предстватель одного из <a href="clubs.php">клубов</a>.</p>
                                <!--<div class="banner">
                                    <a href="club-sample.php"><img src="i/club-sample-adv.jpg"></a>
                                </div>-->
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Дата начала</label>
                                <input type="text" name="bdate" class="span3">
                            </td>
                            <td>
                                <label>Дата окончания</label>
                                <input type="text" name="edate" class="span3">
                            </td>
                            <td>
                                <label>Статус</label>
                                <select name="status" class="span3">
                                    <option value="">Любой</option>
                                    <option>Всероссийский</option>
                                    <option>Международный</option>
                                    <option>Местный</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Страна</label>
                                <input type="text" name="country" class="span3">
                            </td>
                            <td>
                                <label>Город</label>
                                <input type="text" name="city" class="span3">
                            </td>
                            <td>
                                <label>Вид</label>
                                <select name="exam" class="span3">
                                    <option value="">Все</option>
                                    <option>Дети 12-14 лет</option>
                                    <option>Любители 18-30 лет</option>
                                    <option>Любители 31 год и старше</option>
                                    <option>Юноши 14-18 лет</option>
                                    <option>Взрослые спортсмены</option>
                                    <option>Взрослые спортсмены на молодых лошадях 4-5 лет</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" class="rowspan2">
                                <label>Клубы</label>
                                <select id="event-clubs" multiple="multiple" name="club[]" class="span6 chosen-select">
                                    {foreach $clubs as $club}
                                        <option>{$club.name}</option>
                                    {/foreach}
                                </select>
                            </td>
                            <td>
                                <label>Высота</label>
                                <div id="adv-height"></div>
                                <div id="adv-height-amount" class="range-amount"></div>
                                <input type="hidden" name="height_from" id="height_from" value="40">
                                <input type="hidden" name="height_to" id="height_to" value="220">
                            </td>
                        </tr>

                    </table>

                </form>
            </div>
        </div>

        <div class="span12 brackets-horizontal"></div>

        <div class="span12 lthr-bgborder block clubs-search-results">
            <h3 class="inner-bg">Результаты поиска</h3>
            <div class="row">
                <table class="table table-striped competitions-table clubs-results">
                    <tbody id="search-results"><tr>
                        <th>Дата</th>
                        <th>Соревнование</th>
                        <th>Вид</th>
                        <th>Местоположение</th>
                        <th>Клуб</th>
                        <th>Статус</th>
                    </tr>

                    </tbody>
                </table>
            </div>
        </div>



    </div> <!-- /row -->
</div>

{include "modules/footer.tpl"}