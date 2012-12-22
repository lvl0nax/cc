$(".navregister .control .controls").click(function(){

    $(".navregister .control .controls").removeClass('active');

    $(this).addClass('active');

    $('.navregister .tabsformsblock .cont').removeClass('visible');

    $('.navregister .tabsformsblock .cont').eq($(this).index()).addClass('visible');

});



$(".navadd .control .controls").click(function(){

    $(".navadd .control .controls").removeClass('active');

    $(this).addClass('active');

    $('.navadd .tabsformsblock .cont').removeClass('visible');

    $('.navadd .tabsformsblock .cont').eq($(this).index()).addClass('visible');

});



$(document).ready(function(){

    $('img[alt="Photo"]').click(function(){
        $(this).next().trigger('click');
    });

    $('#grant_image_photo').fileupload({
        dataType: 'html',
        url: '<%= images_path %>',
        done: function (e, data) {
            var $src = $(data.result).attr('src');
            $('img[alt="Photo"]').attr('src', $src);
            $('#grant_image').val($src);
        }
    });

    $('.button, .tabsformsblock .cont, .nav .control .controls').click(function(event){

        event.stopPropagation();

    });

}).click(function(){

        $(".regWup").removeClass('regWupact');

        $("#headerWrap .reg").removeClass('btnactiv');



        $(".eddWup").removeClass('eddWupact');

        $("#headerWrap .edd").removeClass('btnactiv');


        $('.bbg').removeClass('bbgvisible');

    });