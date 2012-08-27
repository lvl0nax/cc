var geo = function(t){
    var geocoder, map, marker, searcherArea, savePanel, userpic, geoTitle, guestPageText = false, flagBounds = false;
    // default values for init
    t.values = {
        map : "ya",
        accuracy : 300,
        elementString: "#fs-map",
        elementInfoString: "#geomap-info",
        isEdit : false
    };

    // obj coordinates (example : geo.coords.latitude )
    var coords = {
        latitude : 0,
        longitude : 0,
        accuracy : 0,
        method: 'map'
    };

    // params включает параметры относительно карты:
    // map - тип карты, accuracy - доступное знаечние погрешности, elementString - строка, содержащая стринговое значение для селектора
    // coordinates включает в себя параметры положения если мы их знаем до инита

    t.init = function(params, coordinates){
        t.values = $.extend(t.values, params);
        t.elementMap = $(t.values.elementString);
        t.elementInfoString = $(t.values.elementInfoString);
        searcherArea = $("#search-area");
        savePanel = $("#save-panel");
        userpic = $("#map-userpic");
        geoTitle = $("#geomap-title");

        t.elementMap.removeClass("loader");

        t.elementInfoString.addClass("h");

        if(coordinates && coordinates.latitude != 'undefined' && coordinates.longitude != 'undefined') {
            t.setLoc(coordinates.latitude, coordinates.longitude);
            _init({type: "static"});
        } else {
            if(!!navigator.geolocation && !t.values.isFirstSet){
                var image_helper = "/app/geo/i/help_";
                if($.browser.mozilla){image_helper = ""}
                if($.browser.webkit){image_helper += "webkit.jpg"}
                if($.browser.opera){image_helper += "opera.jpg"}
                if($.browser.safari){image_helper = ""}
                $(t.elementInfoString).show().html("<div style='margin: 0 0 10px'> Ждём вашего разрешения и получения координат</div> <div><img src='" + image_helper + "' /></div>");
                navigator.geolocation.getCurrentPosition(_getValueFromGeocoder, _errorGeocoder);
                if($.browser.safari){$(t.elementInfoString).hide()};
            } else {
                _init();
            }
        }
    };

    t.getLoc = function(){ return coords; };

    t.setLoc = function(lat, long, acc, method){
        coords.latitude = lat;
        coords.longitude = long;
        coords.accuracy = acc != undefined ? acc : 0;
        coords.method = method != undefined ? method : 'map';
    };

    t.saveLoc = function(isPopup, isBtn){
        //t.elementMap.addClass("loader");

        if(isBtn) coords.accuracy = 0;

        $("#save-panel").animate({ "marginTop" : -36 }, 500);
        _ajax.post('/geo/index/save/', {isPopup: isPopup, lat: t.getLoc().latitude, long: t.getLoc().longitude, accuracy: t.getLoc().accuracy, method: t.getLoc().method}, function(html, status, data){
            if(isPopup == 1){
                location.reload();
            } else {
                _init({type: "static"});
            }
        });
    };

    t.gmSearch = function() {
        var address = $(".search-address", searcherArea).val();
        geocoder.geocode( { 'address': address}, function(results, status) {
            if (status == "OK") {
                var res = results[0].geometry.location;
                t.setLoc(res.lat(), res.lng(), 0, 'map');
                map.setCenter(res);
                map.setZoom(13)
                marker.setPosition(res);
                savePanel.animate({ "marginTop" : 0 }, 500);
            } else {
                alert("Невозможно преобразовать адрес в координаты");
            }
        });
    };

    // Private methods

    // берёт значения из геокодера
    var _getValueFromGeocoder = function(position) {

        if(!t.values.isEdit){ t.setLoc(position.coords.latitude, position.coords.longitude, position.coords.accuracy, 'native'); }

        if(position.coords.accuracy > 300){
            coords.method = 'map';
            if(t.values.isEdit){
                $(t.values.elementInfoString).html("<div class='geomap-info-title'>Внимание</div> Погрешность ваших координат оказалась слишком большой, укажите своё месторасположение вручную").show();
                $(t.values.elementInfoString).click(function(){ $(t.values.elementInfoString).hide(); $(this).unbind('click'); });
                setTimeout(function(){ $(t.values.elementInfoString).hide() }, 5000)

            }
            _init();

        } else {
            if(t.values.isEdit){

                t.setLoc(position.coords.latitude, position.coords.longitude, position.coords.accuracy, 'native');

                $(t.values.elementInfoString).html("<div class='geomap-info-title'>Координаты найдены</div> Если хотите их уточнить, передвиньте маркер").show();
                $(t.values.elementInfoString).click(function(){ $(t.values.elementInfoString).hide(); $(this).unbind('click'); });
                setTimeout(function(){ $(t.values.elementInfoString).hide() }, 5000)

                _init();

            } else {
                coords.method = 'native';
                t.saveLoc();
            }
        }
    };

    var _init = function(params){
        _init[t.values.map](params);
    };

    _init.ya = function(params){
        if( params == undefined || params.type == undefined || params.type == "choice" ){

            $("#geomap-overlay").addClass('h')

            savePanel.animate({ "marginTop" : 0 }, 500);

            geoTitle.html("Укажите адрес");

            if(!t.values.isEdit){
                t.elementInfoString.hide();
            }

            if(!coords.latitude && !coords.longitude) t.setLoc(55.750387, 37.616084);

            if(!map){
                map = new ymaps.Map("fs-map", {
                    center: [t.getLoc().latitude,
                        t.getLoc().longitude],
                    zoom: 12,
                    type: "yandex#map",
                    behaviors: ["drag", "scrollZoom"]
                });
            } else {
                map.setZoom( 12 );
                map.panTo( [t.getLoc().latitude, t.getLoc().longitude], {} );
            }

            map.behaviors.enable(["drag", "ScrollZoom"]).getMap().controls.add('smallZoomControl');

            marker = new ymaps.Placemark(
                [t.getLoc().latitude, t.getLoc().longitude], {
                    hintContent: 'Подвинь меня!'
                }, {
                    draggable: true
                });

            marker.events.add("dragend", function(){
                console.log(marker.geometry.getBounds());
                t.setLoc(marker.geometry.getBounds()[0][0], marker.geometry.getBounds()[0][1]);
            });

            map.events.add("boundschange", function(){
                if(flagBounds) {
                    flagBounds = false;

                    t.setLoc(map.getCenter()[0], map.getCenter()[1]);

                    map.geoObjects.remove(marker);

                    marker = new ymaps.Placemark(
                        [map.getCenter()[0], map.getCenter()[1]], {
                            hintContent: 'Подвинь меня!'
                        }, {
                            draggable: true
                        });

                    marker.events.add("dragend", function(){
                        console.log(marker.geometry.getBounds());
                        t.setLoc(marker.geometry.getBounds()[0][0], marker.geometry.getBounds()[0][1]);
                    });

                    map.geoObjects.add(marker);
                }
            });

            searchControl = new ymaps.control.SearchControl({ provider: 'yandex#map', noPlacemark : true, resultsPerPage : 1 });

            searchControl.events.add("resultselect", function(){
                flagBounds = true;
            });


            map.controls.add(searchControl, { right: '0', top: '0' });

            map.geoObjects.add(marker);

            userpic.fadeOut(200);

        } else {

            t.elementInfoString.hide();

            searcherArea.fadeOut(200);

            t.elementMap.removeClass("loader");

            if(!map){
                map = new ymaps.Map("fs-map", {
                    center: [coords.latitude, coords.longitude],
                    zoom: 14,
                    type: "yandex#map"
                });
            } else {
                map.setZoom( 14 );
                map.controls.remove(searchControl);
                map.controls.remove('smallZoomControl');
                map.geoObjects.remove(marker);
                map.panTo( [t.getLoc().latitude, t.getLoc().longitude], {} )
            }
            map.behaviors.disable(["drag", "DblClickZoom", "ScrollZoom"]);

            $("#geomap-overlay").removeClass('h')
        }
    };
    _init.gm = function(params){

        if( params == undefined || params.type == undefined || params.type == "choice" ){

            savePanel.animate({ "marginTop" : 0 }, 500);

            geoTitle.html("Укажите адрес");

            if(!t.values.isEdit){
                t.elementInfoString.hide();
            }

            userpic.fadeOut(200);

            geocoder = new google.maps.Geocoder();

            if(coords.latitude != 0 && coords.longitude != 0){
                var myLatlng = new google.maps.LatLng(coords.latitude, coords.longitude);
            } else {
                var myLatlng = new google.maps.LatLng(55.750387, 37.616084);
                t.setLoc(55.750387, 37.616084)
            }



            var myOptions = {
                zoom: 12,
                center: myLatlng,
                panControl: false,
                zoomControl: true,
                mapTypeControl: false,
                scaleControl: false,
                streetViewControl: false,
                overviewMapControl: false,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };
            map = new google.maps.Map(t.elementMap[0], myOptions);

            marker = new google.maps.Marker({
                map: map,
                draggable: true,
                position: myLatlng,
                animation: google.maps.Animation.DROP
            });


            google.maps.event.addListener(marker, 'dragend', function(event) {
                t.setLoc(event.latLng.lat(), event.latLng.lng(), 0, 'map');
            });

            searcherArea.fadeIn(200);
            $(".search-btn", searcherArea).click(function(){ t.gmSearch(); });
            $(".search-address", searcherArea).keydown(function(event){ return ( event.keyCode == 13 && !$.browser.msie ) ? t.gmSearch() : true; });

        } else {
            t.elementInfoString.hide();

            searcherArea.fadeOut(200);
            userpic.fadeIn(200);

            if (guestPageText) {
                geoTitle.html(guestPageText);
            } else {
                geoTitle.html("Ваше местоположение <span class='jslink fs-edit-anketa' onclick='geo.init()'>редактировать</span>");
            }

            t.elementMap.removeClass("loader").html("").css({
                "backgroundImage" : "url(http://maps.google.com/maps/api/staticmap?center=" + coords.latitude + "," + coords.longitude + "&zoom=13&size=440x239&maptype=roadmap&sensor=false)"
            });

        }
    };

    t.destroyMap = function(){
        if(map && t.values.map == "ya"){
            map.destroy();
            map = undefined;
        }
    };

    // error callback for geocoder
    var _errorGeocoder = function(err) {
        console.log(err);
        _init();
    };

    t.showPopup = function(){
        $.post("/geo/ajax/mapShow/", {ajax: true}, function(data){
            popup.show(data, {width: 440, title: "Ваше месторасположение"});
        })

    };

    t.pleaseTalk = function(id, el){
        _ajax.post('/geo/index/ask/', {userId: id}, function(html, status, data){
            if (typeof(data['type']) !='undefined' && data['type'] == 'ok') {
                if (typeof(el) != 'undefined') {
                    el.parent().hide()
                }
            }
            if (typeof(data['text']) != 'undefined') {
                fs.notify(data['text']);
            }
        });
    };

    t.pleaseTalkProfile = function(id, el){
        _ajax.post('/geo/index/ask/', {userId: id}, function(html, status, data){
            if (typeof(data['type']) !='undefined' && data['type'] == 'ok') {
                if (typeof(el) != 'undefined') {
                    $(el).html("Координаты не указаны");
                    $(el).removeClass('jslink');
                    $(el).onclick = null;
                }
            }
            if (typeof(data['text']) != 'undefined') {
                fs.notify(data['text']);
            }
        });
    };

    t.setGuestPageText = function(text) {
        guestPageText = text;
    };

    return t;
}({});

