//= require jquery
//= require_tree .

$(document).ready(function() {

  $('#temp_month .list a').live('click', function () {
    $("#events_search input[name=year]").val($(this).data('year'));
    $("#events_search input[name=month]").val($(this).data('month'));
    $("#events_search").submit();
    return false;
  });

  $('#temp_month').live('mouseenter', function() {
    $(this).find('.list').animate({left: '0px'}, 200);
    $(this).find('.this').animate({left: '300px'}, 200);
  });

  $('#temp_month').live('mouseleave', function() {
    $(this).find('.list').animate({left: '-300px'}, 200);
    $(this).find('.this').animate({left: '0px'}, 200);
  });

  $('select').selectbox({ effect: "slide" });

  $("#events_search input[type=checkbox]").bind("click", function(){$("#events_search").submit()});

  var url=document.location.href;
  $.each($(".login a"), function(){
    if (this.href==url){$(this).parent().addClass('acta');}
  });

  $('#events_search').submit( function () {
    $("#items").html("");
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });

  $('.add').on("click", function(){
      $('.create_links').show();
      $('.add').addClass("add_select");
      $(".reg-buttons").hide();
      $('.create_grant a').click();

  });

  $('#temp_month').mouseover(function () {
    
  });

  jQuery.fn.center = function () {
    this.css("position","fixed");
    if ($(window).height() - this.height() > 0) {      
      this.css("top", ($(window).height() - this.height() ) / 2 + "px");
    } else {
      this.css("top", '10px');
    }
    this.css("left", ($(window).width() - this.width() ) / 2 + "px");
    return this;
  }
  $(document).on('click',".wait-click" ,function() {
    if ($("#popup-wrap").is(".show-popup")) {
      $("#popup-wrap").html("").removeClass();
      $("#container").removeClass("wait-click");
    }
  });

  //login
  $(document).on("submit","#new_session", function(event){
      event.preventDefault();
      fnlogin();
    });
  //registration submit
  $(document).on("submit","#new_user", function(event){
      event.preventDefault();
      test();
    });

  // set geo coordinate when mouse leave map-area
  $(document).on('hover',"#geo-map" ,function() {
    $("input[id*='y_coordinate']").val(geo.getLoc().longitude);
    $("input[id*='x_coordinate']").val(geo.getLoc().latitude);
  });

  /*$(document).on('click', "#close" ,function() {
    $('.create_links').hide();
    $('.reg-buttons').hide();
    $('#popup-wrap').html("").removeClass();
    $('.create_grant').removeClass("cr_select");
    $('.create_event').removeClass("cr_select");
    $('.create_training').removeClass("cr_select");
    $('.add').removeClass("add_select");
    $('.registration').removeClass("reg-select");
  });
  */

  //open popup for creating grant
  $('.create_grant a').bind('click', function(){
    $('#content-body').css("min-height", "900px");
    $(".reg-buttons").hide();
    $('.create_grant').addClass("cr_select");
    $('.create_event').removeClass("cr_select");
    $('.create_training').removeClass("cr_select");
    $('#popup-wrap').removeClass().addClass("grant-popup").load("/grants/new", function() {
      $('#popup-wrap select').selectbox({ effect: "slide" });
    });
    return false;
  });
  // --//-- fortraining
  $('.create_training a').bind('click', function(){
    $('#content-body').css("min-height", "900px");
    $(".reg-buttons").hide();
    $('#popup-wrap').removeClass().attr("onclick", "areahide();").addClass("grant-popup").load("/trainings/new", function(){
        geocoder = new google.maps.Geocoder();
        geo.setLoc("59.93365223894488","30.300378486327617");
        geo.init({isFirstSet: true, map: 'gm', elementString : "#geo-map"});
        $('#popup-wrap select').selectbox({ effect: "slide" });        
    });
    $('.create_training').addClass("cr_select");
    $('.create_event').removeClass("cr_select");
    $('.create_grant').removeClass("cr_select");
    

    return false;
  });
  // for event
  $('.create_event a').bind('click', function(){
    $('#content-body').css("min-height", "900px");
    $(".reg-buttons").hide();
    $('#popup-wrap').removeClass().attr("onclick", "areahide();").addClass("grant-popup").load("/events/new", function(){
        geocoder = new google.maps.Geocoder();
        geo.setLoc("59.93365223894488","30.300378486327617");
        geo.init({isFirstSet: true, map: 'gm', elementString : "#geo-map"});
    });
    $('.create_event').addClass("cr_select");
    $('.create_training').removeClass("cr_select");
    $('.create_grant').removeClass("cr_select");
    $('#new_event select').selectbox({ effect: "slide" });
    return false;
  });

  // open registration form
  $('.registration').bind('click', function(){
    
    if ($(this).data().reg){alert("Для регистрации разлогиньтесь, пожалуйста.")} 
    else {
      $('#login-form').html("");
      $('.error').html("");
      $(this).addClass("reg-select");
      $('.create_links').hide();
      $(".reg-buttons").show();
      $('#popup-wrap').removeClass().addClass("reg-popup").load("/users/sign_up", function(){
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
      });
    
    }
  });
  
  //select role
  $('.person-button').bind("click", function(){
    $('#user_role').val("employee");
    $(this).addClass("rselected");
    $('.comp-button').removeClass("rselected");
  });
  $('.comp-button').bind("click", function(){
    $('#user_role').val("employer");
    $(this).addClass("rselected");
    $('.person-button').removeClass("rselected");
  });

  //hide area and company dropdown
  $('#container').bind('click', function () {
    $(".ard").fadeOut();
    $(".arde").fadeOut();
    $(".ardc").fadeOut();
    /*if ($("#popup-wrap").is(".show-popup")) 
      $("#popup-wrap").removeClass();*/
  });

  // company or area dropdown
  $('#trclick').bind('click', function () {
    $('.ard').fadeIn();
    $(".arde").fadeOut();
    $(".ardc").fadeOut();
  });
  $('#trcclick').bind('click', function () {
    $('.ardc').fadeIn();
    $(".ard").fadeOut();
    $(".arde").fadeOut();
  });
  $('#evclick').bind('click', function () {
    $('.arde').fadeIn();
    $(".ard").fadeOut();
    $(".ardc").fadeOut();
  });

  $(".select").click(function(event){ event.stopPropagation()});

  $(".select div.input input.check_boxes").bind("click", function(){
    if ($(this).attr('checked'))
    {
      $(this).attr('checked', 'checked').parent().css('color', '#76a38a');

    }else{
      
      $(this).removeAttr('checked').parent().css('color', 'black');
    }
    

  });

  $("#arealist input[type=checkbox]").each(function(){
    if ($(this).attr("checked") ){ 
      $(this).parent().css("color", "#76a38a")
    }
  });
/*
  $(".select label.checkbox").bind("click", function(){
    if ($(this).children.attr("ckecked"))
      {
        $(this).css("color", "#76a38a");
      }
    else
      {
        $(this).css("color", "black");
      }
  });

*/

  //login form load
  $("#login").bind("click", function(){
    closeItemPopup();
    $("#login-form").load("/users/sign_in");
    return false;
  });

  // for checkbox style
  var temp = $(".menu label.checkbox input");
  for (var i=0; i<temp.length; i++){ doCheckbox(temp.eq(i));}
  function doCheckbox(elem)
  {
    if (elem.attr("checked"))
    {
      elem.parent().css("background-position", "0 -20px");
    }
    else
    {
      elem.parent().css("background-position", "0 0");

    }
  }

  var tp = $(".menu label.mnl input");
  for (var i=0; i<temp.length; i++){ doCheckboxmn(tp.eq(i));}
  function doCheckboxmn(elem)
  {
    if (elem.attr("checked"))
    {
      elem.parent().children("span.chkimg").first().css("background-position", "0 -19px");
    }
    else
    {
      elem.parent().children("span.chkimg").first().css("background-position", "0 0");
    }
  }

  
});/*
$('.trainings input:checkbox').click(function() {
  if (this.checked)
    $(".temp_event").show();
  else
    $(".temp_event").hide();
});*/

// for close any popup 
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