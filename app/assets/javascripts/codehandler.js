$(document).ready(function () {
    $("[name='switch']").bootstrapSwitch();

    var myTextarea = document.getElementById("code-editor");
    var editor = CodeMirror.fromTextArea(myTextarea, {
        lineNumbers: true,
        mode: "dang",
        theme: "icecoder"
    });

    function codeEvalResultHandler(response) {
        console.warn(response);

        var output = response.responseJSON;

        $("#code-result").html('');
        $.each(output, function (i, result) {
            var div = $("<div>");

            div.html(result);

            if (result.indexOf('[x]') == 0 || result.indexOf('Expected') == 0)
                div.css('color', '#D60303');

            $("#code-result").append(div);
        });
    }

    function runCode() {
        $.ajax({
            url: "http://localhost:3000/ide/eval",
            type: "POST",
            data: {code: editor.getValue()},
            dataType: "json",
            complete: codeEvalResultHandler
        });
    }


    // --> Event handling <--

    function handleCtrlKeyEvents(e) {
        if (e.which == 13)
            runCode();
        else if (e.which == 83)
            e.preventDefault();

    }

    $("#settings-drawer-button").hover(function () {
        $("#settings-drawer").css("transform", "translate(0)");
    });

    $("#settings-drawer").mouseleave(function () {
        $("#settings-drawer").css("transform", "translate(-100%)");
    });

    $("#file-drawer-button").hover(function () {
        $("#file-drawer").css("transform", "translate(0)");
        $("#file-drawer-button").find("span").removeClass("fa-folder");
        $("#file-drawer-button").find("span").addClass("fa-folder-open");
    });

    $("#file-drawer").mouseleave(function () {
        $("#file-drawer").css("transform", "translate(100%)");
        $("#file-drawer-button").find("span").removeClass("fa-folder-open");
        $("#file-drawer-button").find("span").addClass("fa-folder");
    });

    $("#run-code").click(function () {
        runCode();
    });

    $(document).keydown(function (e) {
        if (e.ctrlKey)
            handleCtrlKeyEvents(e);
    });
});