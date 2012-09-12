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
		$('.create_links').show();
		$('.add').addClass("add_select");
		$(".reg-buttons").hide();
	});

	$(document).on('click',"#close" ,function() {
		$('.create_links').hide();
		$('.reg-buttons').hide();
		$('#popup-wrap').html("").removeClass();
		$('.create_grant').removeClass("cr_select");
	    $('.create_event').removeClass("cr_select");
	    $('.create_training').removeClass("cr_select");
	    $('.add').removeClass("add_select");
	    $('.registration').removeClass("reg-select");
	});


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
		$('#popup-wrap').removeClass().addClass("grant-popup").load("/trainings/new", function(){
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
		$('#popup-wrap').removeClass().addClass("grant-popup").load("/events/new", function(){
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
		$(this).addClass("reg-select");
		$('.create_links').hide();
		$(".reg-buttons").show();
		$('#popup-wrap').removeClass().addClass("reg-popup").load("/users/sign_up", function(){
		});
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
		/*if ($("#popup-wrap").is(".show-popup")) 
			$("#popup-wrap").removeClass();*/
	});

	$('#trclick').bind('click', function () {
		$('.ard').fadeIn();
		
	});
	$('#evclick').bind('click', function () {
		$('.arde').fadeIn();
	});


	$(".select").click(function(event){ event.stopPropagation()});

	$('.temp_training').bind("click", function(){
		tmp = $(this).data("content");
		/*alert('test');*/
		$('#popup-wrap').removeClass().addClass("show-popup").load("/trainings/"+tmp, function(){
			/*$('#container').bind('click', function () {$("#popup-wrap").removeClass();});*/
		});
	});
	$('.temp_event').bind("click", function(){
		tmp = $(this).data("content");
		/*alert('test');*/
		$('#popup-wrap').removeClass().addClass("show-popup").load("/events/"+tmp, function(){
		});
	});
	$('.temp_grant').bind("click", function(){
		tmp = $(this).data("content");
		/*alert('test');*/
		$('#popup-wrap').removeClass().addClass("show-popup").load("/grants/"+tmp, function(){
		});
	});
});/*
$('.trainings input:checkbox').click(function() {
	if (this.checked)
		$(".temp_event").show();
	else
  	$(".temp_event").hide();
});*/