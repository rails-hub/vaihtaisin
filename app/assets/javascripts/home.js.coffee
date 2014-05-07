$ ->
  $(document).ready ->
    $("#sign_up_form").validate
      rules:
        "user[name]":
          required: true

        "user[email]":
          required: true
          email: true

        "user[password]":
          required: true
          minlength: 8

        "user[password_confirmation]":
          required: true
          minlength: 8
          equalTo : "#password"

    $("#sign_in_form").validate
      rules:
        "user[email]":
          required: true
          email: true

        "user[password]":
          required: true
          minlength: 8
