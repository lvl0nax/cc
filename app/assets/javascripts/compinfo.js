$(function() {

    $('#cropbox').Jcrop({
      aspectRatio: 1,
      setSelect: [0, 0, 380, 600],
      onSelect: update,
      onChange: update
    });

});

function update(coords) {
  $('#compinfo_crop_x').val(coords.x);
  $('#compinfo_crop_y').val(coords.y);
  $('#compinfo_crop_w').val(coords.w);
  $('#compinfo_crop_h').val(coords.h);
  updatePreview(coords);
  updatePreview2(coords);
};

function updatePreview(coords) {
  return $('#preview').css({
    width: Math.round(100 / coords.w * $('#cropbox').width()) + 'px',
    height: Math.round(100 / coords.h * $('#cropbox').height()) + 'px',
    marginLeft: '-' + Math.round(100 / coords.w * coords.x) + 'px',
    marginTop: '-' + Math.round(100 / coords.h * coords.y) + 'px'
  });
}

function updatePreview2(coords) {
  return $('#preview2').css({
    width: Math.round(54 / coords.w * $('#cropbox').width()) + 'px',
    height: Math.round(46 / coords.h * $('#cropbox').height()) + 'px',
    marginLeft: '-' + Math.round(54 / coords.w * coords.x) + 'px',
    marginTop: '-' + Math.round(46 / coords.h * coords.y) + 'px'
  });
}