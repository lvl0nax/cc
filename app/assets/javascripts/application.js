// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//onclick="$('.temp_event').hide();"
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
		
	});

	$(document).on('click',"#close" ,function() {
		$('.create_links').hide();
		$('#popup-wrap').html("").removeClass("grant-popup");
		$('.create_grant').removeClass("cr_select");
    $('.create_event').removeClass("cr_select");
    $('.create_training').removeClass("cr_select");
    $('.add').removeClass("add_select");
	});

	$('.create_grant a').bind('click', function(){
		$('#container').css("min-height", "900px");
		$('#popup-wrap').addClass("grant-popup");
    $('.create_grant').addClass("cr_select");
    $('.create_event').removeClass("cr_select");
    $('.create_training').removeClass("cr_select");
		$('#popup-wrap').load("/grants/new");
		return false;
	});

	$('.create_training a').bind('click', function(){
		$('#popup-wrap').addClass("grant-popup").load("/trainings/new", function(){
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
		$('#popup-wrap').addClass("grant-popup").load("/events/new", function(){
        geocoder = new google.maps.Geocoder();
        geo.setLoc("59.93365223894488","30.300378486327617");
        geo.init({isFirstSet: true, map: 'gm', elementString : "#geo-map"});
		});
    $('.create_event').addClass("cr_select");
    $('.create_training').removeClass("cr_select");
    $('.create_grant').removeClass("cr_select");
		return false;
	});

	
});/*
$('.trainings input:checkbox').click(function() {
	if (this.checked)
		$(".temp_event").show();
	else
  	$(".temp_event").hide();
});*/