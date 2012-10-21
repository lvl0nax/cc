// jQuery ->
//   new AvatarCropper()

// class AvatarCropper
//   constructor: ->
//     $('#cropbox').Jcrop
//       aspectRatio: 1
//       setSelect: [0, 0, 600, 600]
//       onSelect: @update
//       onChange: @update
//     return false

// 	update: (coords) =>
//     $('#resume_crop_x').val(coords.x)
//     $('#resume_crop_y').val(coords.y)
//     $('#resume_crop_w').val(coords.w)
//     $('#resume_crop_h').val(coords.h)
//     @updatePreview(coords)
//     return false

//   updatePreview: (coords) =>
//   	$('#preview').css
//  			width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
//   		height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
//  	 	marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
//   		marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
//   return false

$(function() {

    $('#cropbox').Jcrop({
      aspectRatio: 1,
      setSelect: [0, 0, 600, 600],
      onSelect: update,
      onChange: update
    });

});
function update(coords) {
  $('#resume_crop_x').val(coords.x);
  $('#resume_crop_y').val(coords.y);
  $('#resume_crop_w').val(coords.w);
  $('#resume_crop_h').val(coords.h);
  updatePreview(coords);
};

function updatePreview(coords) {
  return $('#preview').css({
    width: Math.round(100 / coords.w * $('#cropbox').width()) + 'px',
    height: Math.round(100 / coords.h * $('#cropbox').height()) + 'px',
    marginLeft: '-' + Math.round(100 / coords.w * coords.x) + 'px',
    marginTop: '-' + Math.round(100 / coords.h * coords.y) + 'px'
  });
}
