jQuery.noConflict();
jQuery(document).ready(function() {
  jQuery('a.version-link').cluetip({
    sticky: true,
    mouseOutClose: true,
    showTitle: false,
    topOffset: 70,
    closeText: "",
    waitImage: false
  });
});
