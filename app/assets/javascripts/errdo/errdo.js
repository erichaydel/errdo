//= require highcharts
//= require chartkick
//= require_tree .

$(document).ready(function() {
  $('.tabs ul li').on('click', function() {
    var div = $(this).find('a').attr('container');
    $('.tabs ul li').removeClass('is-active');
    $(this).addClass('is-active');

    $(".tabbed").addClass('is-hidden');
    $(div).removeClass('is-hidden');
  });
});
