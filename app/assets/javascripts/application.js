// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-1.9.1
//= require jquery-ui
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.ui.datepicker
//= require bootstrap
//= require turbolinks
//= require validate/jquery.validate
//= require leaflet
//= require gmaps
//= require admin/wishes
//= require_tree .


function show_save() {
    if ($('#h_wished_locations').val() == 'true') {
        $('#save-wish-form-cont').show();
    }
    else {
        $('#save-wish-form-cont').hide();
    }

    if ($('#route_id').val() != '' && $('#location_id').val() != '') {
        $("#step-2 *").removeAttr('disabled').on('click');
    }
    else {
        $("#step-2 *").attr("disabled", "disabled").off('click');
    }

}
