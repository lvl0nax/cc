$(document).ready(function () {
	$(".fjqtrans .jqTransformCheckbox").click(function () {
		var thisIndex = $(this).parents(".ffscr").index();
		if (thisIndex == 3){
			var hc = $(this).parents(".ffscr").hasClass("nowSmall");
			if (hc){
				$(this).parents(".ffscr").removeClass("nowSmall");
				$(this).parents(".ffscr").css({"overflow":"visible"});
				$(this).parents(".ffscr").animate({
					"height":"60px",
					"padding":"10px"
				});
				$(this).animate({
					"width":"19px",
					"height":"19px"
				});
				$(this).parents("span").animate({
					"fontSize":"20px",
					"lineHeight":"18px"
				});
				$(this).parents(".jqTransformCheckboxWrapper").animate({
					"paddingTop":"2px"
				});
				$(this).parents(".sizeBig").css({
					"backgroundColor":"transparent"
				});


				$(this).parents("span").css({
					"color":"white"
				});

				$(this).parents(".ffscr").find(".numerick").css({"display":"none"});
			}else{
				$(this).parents(".ffscr").addClass("nowSmall");
				$(this).parents(".ffscr").css({"overflow":"hidden"});
				$(this).parents(".ffscr").animate({
					"height":"10px",
					"padding":"0px"
				});
				$(this).animate({
					"width":"10px",
					"height":"10px"
				});
				$(this).parents("span").animate({
					"fontSize":"12px",
					"lineHeight":"10px"
				});
				$(this).parents(".jqTransformCheckboxWrapper").animate({
					"paddingTop":"1px"
				});
				$(this).parents(".sizeBig").css({
					"backgroundColor":"white",
					"display":"inline-block",
					"position": "relative",
					"top": "-3px",
					"paddingRight":"4px"
				});


				$(this).parents("span").css({
					"color":"black"
				});

				$(this).parents(".ffscr").find(".numerick").css({"display":"inline-block"});
			};
		} else{
			var hc = $(this).parents(".ffscr").hasClass("nowSmall");
			if (hc){
				$(this).parents(".ffscr").removeClass("nowSmall");
				$(this).parents(".ffscr").css({"overflow":"visible"});
				$(this).parents(".ffscr").animate({
					"height":"40px",
					"padding":"10px"
				});
				$(this).animate({
					"width":"19px",
					"height":"19px"
				});
				$(this).parents("span").animate({
					"fontSize":"20px",
					"lineHeight":"18px"
				});
				$(this).parents(".jqTransformCheckboxWrapper").animate({
					"paddingTop":"2px"
				});
				$(this).parents(".sizeBig").css({
					"backgroundColor":"transparent"
				});


				$(this).parents("span").css({
					"color":"white"
				});

				$(this).parents(".ffscr").find(".numerick").css({"display":"none"});
			}else{
				$(this).parents(".ffscr").addClass("nowSmall");
				$(this).parents(".ffscr").css({"overflow":"hidden"});
				$(this).parents(".ffscr").animate({
					"height":"10px",
					"padding":"0px"
				});
				$(this).animate({
					"width":"10px",
					"height":"10px"
				});
				$(this).parents("span").animate({
					"fontSize":"12px",
					"lineHeight":"10px"
				});
				$(this).parents(".jqTransformCheckboxWrapper").animate({
					"paddingTop":"1px"
				});
				$(this).parents(".sizeBig").css({
					"backgroundColor":"white",
					"display":"inline-block",
					"position": "relative",
					"top": "-3px",
					"paddingRight":"4px"
				});


				$(this).parents("span").css({
					"color":"black"
				});

				$(this).parents(".ffscr").find(".numerick").css({"display":"inline-block"});
			};
		};
	});
});