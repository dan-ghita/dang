$(document).ready(function () {
    $('#signup-button').click(function(){
        $('#signup-form').css('display', 'block');
        $('#signin-form').css('display', 'none');
    });

    $('#signin-button').click(function(){
        $('#signup-form').css('display', 'none');
        $('#signin-form').css('display', 'block');
    });

    setTimeout(function() {
        $('#notification').fadeOut('fast');
    }, 2000);
});