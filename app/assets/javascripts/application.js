//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
	/*$('.trainings input:checkbox').click(function() {
		$('.temp_month').toggle();
	});
*/
  $('#events_search').submit( function () {
    alert("test");
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });


  $('.add').on("click", function(){
    if ($(this).data().reg){
      $('.create_links').show();
      $('.add').addClass("add_select");
      $(".reg-buttons").hide();
    } 
    else {
      alert("Для добавления события залогиньтесь, пожалуйста.")
    }
  });

  /*$("#new_user").on();*/
  /*$(document).on("ajax:error", "#new_user", function(evt, xhr, settings){alert(1);});*/



  $(document).on('click',".wait-click" ,function() {
    if ($("#popup-wrap").is(".show-popup")) {
      $("#popup-wrap").html("").removeClass();
      $("#container").removeClass("wait-click");
    }
  });

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

	$('.create_grant a').bind('click', function(){
		/*$('#container').css("min-height", "900px");*/
		$(".reg-buttons").hide();
    $('.create_grant').addClass("cr_select");
    $('.create_event').removeClass("cr_select");
    $('.create_training').removeClass("cr_select");
		$('#popup-wrap').removeClass().addClass("grant-popup").load("/grants/new");
		return false;
	});

	$('.create_training a').bind('click', function(){
		$(".reg-buttons").hide();
		$('#popup-wrap').removeClass().attr("onclick", "areahide();").addClass("grant-popup").load("/trainings/new", function(){
        geocoder = new google.maps.Geocoder();
        geo.setLoc("59.93365223894488","30.300378486327617");
        geo.init({isFirstSet: true, map: 'gm', elementString : "#geo-map"});
		});
    $('.create_training').addClass("cr_select");
    $('.create_event').removeClass("cr_select");
    $('.create_grant').removeClass("cr_select");
		return false;
	});

	$('.create_event a').bind('click', function(){
		$(".reg-buttons").hide();
		$('#popup-wrap').removeClass().attr("onclick", "areahide();").addClass("grant-popup").load("/events/new", function(){
        geocoder = new google.maps.Geocoder();
        geo.setLoc("59.93365223894488","30.300378486327617");
        geo.init({isFirstSet: true, map: 'gm', elementString : "#geo-map"});
		});
    $('.create_event').addClass("cr_select");
    $('.create_training').removeClass("cr_select");
    $('.create_grant').removeClass("cr_select");
		return false;
	});

	$('.registration').bind('click', function(){
    if ($(this).data().reg){alert("Для регистрации разлогиньтесь, пожалуйста.")} 
    else {
  		$(this).addClass("reg-select");
  		$('.create_links').hide();
  		$(".reg-buttons").show();
  		$('#popup-wrap').removeClass().addClass("reg-popup").load("/users/sign_up", function(){
  		});
    }
	});
	
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
	$('#container').bind('click', function () {
		$(".ard").fadeOut();
		$(".arde").fadeOut();
		$(".ardc").fadeOut();
		/*if ($("#popup-wrap").is(".show-popup")) 
			$("#popup-wrap").removeClass();*/
	});

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


	$("#login").bind("click", function(){
		$("#login-form").load("/users/sign_in");
		return false;
	});

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

function closeItemPopup() {
  $('.create_links').hide();
  $('.reg-buttons').hide();
  $('#popup-wrap').html("").removeClass();
  $('.create_grant').removeClass("cr_select");
  $('.create_event').removeClass("cr_select");
  $('.create_training').removeClass("cr_select");
  $('.add').removeClass("add_select");
  $('.registration').removeClass("reg-select");
}

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
}
function test () {
  /*alert($("#new_user").serialize());*/
  $.ajax({
    type: "POST",
    url: "/users",
    data: $("#new_user").serialize(),
    success: function(data, status, jqXHR){ 
      if (data.match("ПАРОЛЬ ЕЩЕ РАЗ")) {
        alert("Скорее всего данный email уже используется")
      } else {
        location.replace("/resumes/new");
      }
    },
    error: function(){ alert(2);},
    ajaxComlpete: function(){alert(1231)}
  });
  return false;
}


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

function showevent(temp){
    $("#popup-wrap").click(function(event){ event.stopPropagation()});
    if ($("#container").is(".wait-click")){$("#container").removeClass();}
    
    $('#popup-wrap').removeClass().addClass("show-popup").load("/events/"+temp, function(){
      
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
    $("#popup-wrap").click(function(event){ event.stopPropagation()});

    if ($("#container").is(".wait-click")){$("#container").removeClass();}
    /*var tmp = $(this).data("content");
    alert(temp);*/
    $('#popup-wrap').removeClass().addClass("show-popup").load("/trainings/"+temp, function(){
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

function showgrant(temp){
    $("#popup-wrap").click(function(event){ event.stopPropagation()});

    if ($("#container").is(".wait-click")){$("#container").removeClass();}
   
    $('#popup-wrap').removeClass().addClass("show-popup").load("/grants/"+temp, function(){
      if ($("#container").is(".wait-click")){}
      else  
        $('#container').addClass("wait-click");
    });
}