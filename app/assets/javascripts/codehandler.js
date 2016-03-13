$(document).ready(function () {
    function codeEvalResultHandler( response ){
        console.warn(response);

        var output = response.responseJSON;

        $("#code-result").html('');
        $.each(output, function(i, result) {
            var div = $("<div>")

            div.html(result);

            if(result.indexOf('[x]') == 0)
                div.css('color', 'red');

            $("#code-result").append(div);
        });
    }

    function runCode(code) {
        $.ajax({
            url: "http://localhost:3000/ide/eval",
            type: "GET",
            data: {code: code},
            dataType: "json",
            complete: codeEvalResultHandler
        });
    }

    $("#run-code").click(function () {
        var code = $("#code-editor").val();
        runCode(code);
    });

    $(document).keypress(function(e) {
        if(e.ctrlKey && (e.which == 10)) {
            var code = $("#code-editor").val();
            runCode(code);
        }
    });
});