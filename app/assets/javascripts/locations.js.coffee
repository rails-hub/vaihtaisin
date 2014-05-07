$ ->
  $(document).ready ->
    $("#route_id").change ->
      district = $(this).val()
      district_text = $("#route_id option:selected").text()
      $.ajax
        url: '/locations/locations?id=' + district,
        type: 'get',
        dataType: 'html',
        success: (data) ->
#          $('#d_location').html(district_text)
          $('#states').html data
          show_save()

    $('#validuntil').change ->
      date_text = $(this).val()
#      $('#date_select').html(date_text)
      show_save()

    $('#wish_route_id').change ->
      district = $(this).val()
      not_location = $('#location_id').val()
      if (not_location == '' || not_location == null)
        not_location  = $('#location_offer_id').val();
      else
        $('#location_offer_id').val(not_location);
      district_text = $("#route_id option:selected").text()
      $.ajax
        url: '/locations/locations?id=' + district + '&wish=' + true + '&not_location=' + not_location,
        type: 'get',
        dataType: 'html',
        success: (data) ->
          $('#wished_locations').html data
          show_save()

