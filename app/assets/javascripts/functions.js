function closeItemPopup() {
  $('.create_links').hide();
  $('.reg-buttons').hide();
  $('#popup-wrap').html("").removeClass();
  $('#popup-wrap').removeAttr('style');
  $('.create_grant').removeClass("cr_select");
  $('.create_event').removeClass("cr_select");
  $('.create_training').removeClass("cr_select");
  $('.add').removeClass("add_select");
  $('.registration').removeClass("reg-select");
}

//velidation register form - need refactoring with above code validation
function formvalidate() {
  $("#new_user").validate({
    rules: {
      "user[email]": {
        required: true,
        email: true
      },
      "user[password]": {
        required: true,
        minlength: 6
      },
      "user[password_confirmation]": {
        required: true,
        minlength: 6,
        equalTo: "#user_password"
      }
    },
    messages:{
      "user[email]": {
        required: "Введите Email",
        email: "Email некорректный"
      },
      "user[password]": {
        required: "Введите пароль",
        minlength: "Пароль должен быть не меньше 6 символов"
      },
      "user[password_confirmation]": {
        required: "Потвторите пороль",
        minlength: "Пароль должен быть не меньше 6 символов",
        equalTo: "Пароли не совпадают"
      }
    }
  });

  test();

}

// ajax register
function test () {
  /*alert($("#new_user").serialize());*/
  $.ajax({
    type: "POST",
    url: "/users",
    data: $("#new_user").serialize(),
    success: function(data, status, jqXHR){ 
      if (data.match("Email is already taken")) {
        alert("Данный email уже используется")
      } else {
        if (data.match("ПАРОЛЬ ЕЩЕ РАЗ")) {
          alert("Что-то пошло не так. Проверьте ваши данные и попробуйте еще раз.")
        } else {
          if ($("#user_role").val() == "employer"){
            location.replace("/compinfos/new");
          }else{
            location.replace("/resumes/new");
          }
        } 
      }
    },
    error: function(){ alert(2); }

  });

}

//ajax login
function fnlogin () {
  $.ajax({
    type: "POST",
    url: "/users/sign_in",
    data: $("#new_session").serialize(),
    
    success: function(data, status, jqXHR){ 
      location.reload();
    },
    error: function(jqXHR, textStatus, error){ 
      $(".error").html("").append("Пожалуйста, проверьте введенные данные и повторите попытку снова.");
      $("#user_email").addClass("red-border");
      $("#user_password").addClass("red-border");
    }
    
  });
}

//area on search menu
function areashow(){
  $(".select").click(function(event){ event.stopPropagation()});
  $("#evcreateclick").click(function(event){ event.stopPropagation()});
  $('.ardec').fadeIn();

  /*$('#evcreateclick').bind('click', function () {
    $('.ardec').fadeIn();
  });
  $('#new_event').bind('click', function () {
    $('.ardec').fadeIn();
  });*/
}
function areahide(){
  $(".select").click(function(event){ event.stopPropagation()});
  $("#evcreateclick").click(function(event){ event.stopPropagation()});
  $('.ardec').fadeOut();

}


//show items  - event/training/grant
function showevent(temp){
    closeItemPopup();
    scrollPopup();

    $("#popup-wrap").click(function(event){ event.stopPropagation()});
    if ($("#container").is(".wait-click")){$("#container").removeClass();}
    
    $('#popup-wrap').removeClass().addClass("show-popup").load("/events/"+temp, function(){
    $('#popup-wrap').center();
      
      if ($("#container").is(".wait-click")){}
      else {  
        $('#container').addClass("wait-click");}
        var x_coordinate = $("#geo-map").data().x ; /*|| 59.93365223894488*/
        var y_coordinate = $("#geo-map").data().y ; /*|| 30.300378486327617*/
        /*alert(y_coordinate);*/
        geocoder = new google.maps.Geocoder();/**/
        geo.setLoc(x_coordinate,y_coordinate);/**/
        /*geo.init({elementString: "#geo-map", map: 'gm'}, {latitude: 59.93365223894488, longitude: 30.300378486327617});/**/
        geo.init({isFirstSet: true, map: 'gm', elementString: "#geo-map"});/**/
    }); 
}
function showtraining(temp){

    closeItemPopup();
    scrollPopup();
    $("#popup-wrap").click(function(event){ event.stopPropagation()});


    if ($("#container").is(".wait-click")){$("#container").removeClass();}
    /*var tmp = $(this).data("content");
    alert(temp);*/
    $('#popup-wrap').removeClass().addClass("show-popup").load("/trainings/"+temp, function(){
    $('#popup-wrap').center();
      if ($("#container").is(".wait-click")){}
      else {  
        $('#container').addClass("wait-click");}
        var x_coordinate = $("#geo-map").data().x; /*|| 59.93365223894488*/
        var y_coordinate = $("#geo-map").data().y; /*|| 30.300378486327617*/
        /*alert(y_coordinate);*/
        geocoder = new google.maps.Geocoder();/**/
        geo.setLoc(x_coordinate,y_coordinate);/**/
        /*geo.init({elementString: "#geo-map", map: 'gm'}, {latitude: 59.93365223894488, longitude: 30.300378486327617});/**/
        geo.init({isFirstSet: true, map: 'gm', elementString: "#geo-map"});/**/
    });
}

function scrollPopup()
{
  if (!$("#items").length) return;
  if ($(window).scrollTop() <= $("#items").offset().top) {
    $('html, body').animate({scrollTop: $("#items").offset().top }, 200);
  }
}

function showgrant(temp){
    closeItemPopup();
    scrollPopup();

    $("#popup-wrap").click(function(event){ event.stopPropagation()});

    if ($("#container").is(".wait-click")){$("#container").removeClass();}
   
    $('#popup-wrap').removeClass().addClass("show-popup").load("/grants/"+temp, function(){
    $('#popup-wrap').center();
      if ($("#container").is(".wait-click")){}
      else  
        $('#container').addClass("wait-click");
    });
}


function itemshow(sclass){
  /*var str = "."+ sclass*/
  var item = $("."+ sclass);
  if (item.attr("active"))
  {
    item.fadeOut().removeAttr("active");
  }
  else
  {
    item.fadeIn().attr("active", "active");
  }
}


//for search items
function srch() {
  /*var t = $("#events_search").serialize();
  alert(t);*/

  $.ajax({
    type: "POST",
    url: "/events",
    data: $("#events_search").serialize(),
    
    success: function(data, status, jqXHR){ 
      /*location.reload();*/
      //  $('#items').html();
      //  $('#items').append("<%= j render(@items) %>");
      // /*if (@items.length > 12) {*/
      //  $(".pagination").replaceWith("<%= j will_paginate(@items) %>");
      // /*}
      // else{
      //  $(".pagination").remove();
      // }*/
    },
    error: function(jqXHR, textStatus, error){ 
      alert("status " + textStatus);
    }
  });
}

//adding participant to events/training/grant
function addpart(){
  var url = $(".participant div").data("url");
  var id = $(".participant div").data("id");
  var item = $(".participant div").data("item");
  $.ajax({
    type: "GET",
    url: url,
    /*data: id,*/
    /*success: function(){ 
      alert("tests1");
    },
    error: function(jqXHR, textStatus, errorThrown){ 
      alert("error ");
      
    }*/
    complete: function(){
      if (item == "grant"){
        showgrant(id);
      }else if (item == "event"){
        showevent(id)
      }else {
        showtraining(id)
      }
    }
  });
}

//delete participant
function delpart(){
  var url = $(".participant div").data("url");
  var id = $(".participant div").data("id");
  var item = $(".participant div").data("item");
  $.ajax({
    type: "GET",
    url: url,
    data: id,
    success: function(){ 
      if (item == "grant"){
        showgrant(id);
      }else if (item == "event"){
        showevent(id)
      }else {
        showtraining(id)
      }
    },
    error: function(jqXHR, textStatus, errorThrown){ 
      alert(errorThrown);
    }
  });
}

// add area to current_user
function addareas(){
  var tmp;
  var t=[];
  var s = "";
  $("#arealist input[type=checkbox]").each( function(){
    tmp = $(this).attr("checked");
    if (tmp) {
      t.push($(this).data("id"));
    }
  });
  s = "" + t;
  $.ajax({
    type: "POST",
    url: "/areas/add_to_user",
    data: {array: s},
    success: function(data,status,jqXHR){ 
      location.reload();
    },
    error: function(jqXHR, textStatus, errorThrown){ 
      alert(errorThrown);
    }
  });
}