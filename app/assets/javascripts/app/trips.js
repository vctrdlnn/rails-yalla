$(function () {
  var panes = $('[data-map-affix="true"]');

  $(window).scroll(function() {

  });

  panes.each(function () {
    pane = $(this);
    var panePosition = panes.offset().top;
    var position = panePosition - $(window).scrollTop();
  });

  // var panePosition = panes.offset().top; //get the offset top of the element

  // $(window).scroll(function() {
  //   var position = panePosition - $(window).scrollTop();
  //   var mapPreview = $('#' + panes.data('map-affix-target'));

  //   if (position <= 0) {
  //     mapPreview.css({position: 'fixed', top: '60px'});
  //   } else {
  //     mapPreview.css({position: 'relative', top: '0'});
  //   }
  // });
})
