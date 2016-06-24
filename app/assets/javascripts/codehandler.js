$(document).ready(function () {
    $("[name='switch']").bootstrapSwitch();

    var documentId = 0;
    var myTextarea = document.getElementById("code-editor");


    var autoComplete = function (cm) {
        CodeMirror.showHint(cm, CodeMirror.hint.dang, {completeSingle: false});
    };

    CodeMirror.commands.autocomplete = autoComplete;

    var editor = CodeMirror.fromTextArea(myTextarea, {
        lineNumbers: true,
        mode: "dang",
        theme: "icecoder",
        extraKeys: {
            "Ctrl-Space": "autocomplete"
        }
    });

    function isNumber(keyCode) {
        return keyCode >= 48 && keyCode <= 57;
    }

    function isAlpha(keyCode) {
        return keyCode >= 65 && keyCode <= 90;
    }

    function isDash(keyCode) {
        return keyCode == 189;
    }

    editor.on("keyup", function (cm, event) {
        if (!cm.state.completionActive &&
            !event.ctrlKey &&
            (isNumber(event.keyCode) || isAlpha(event.keyCode) || isDash(event.keyCode))
        ) {
            CodeMirror.commands.autocomplete(cm, null, {completeSingle: false});
        }
    });

    function updateSettings(response) {
        console.log(response);

        var settings = response.responseJSON.settings[0];
        editor.setOption("lineNumbers", settings.line_numbers);
        editor.setOption("smartIndent", settings.auto_indent);
        if(settings.auto_correct)
            CodeMirror.commands.autocomplete = autoComplete;
        else
            CodeMirror.commands.autocomplete = function () {};
        $("#line-numbers-switch").bootstrapSwitch('state', settings.line_numbers, true);
        $("#auto-indent-switch").bootstrapSwitch('state', settings.auto_indent, true);
        $("#auto-complete-switch").bootstrapSwitch('state', settings.auto_correct, true);
    }

    function syncSettings() {
        $.ajax({
            url: "/settings/show",
            type: "GET",
            dataType: "json",
            complete: updateSettings
        });
    }

    syncSettings();

    function notify(message) {
        $('#notification').html(message).fadeIn('fast');
        setTimeout(function () {
            $('#notification').fadeOut('fast');
        }, 2000);
    }

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

    function saveDocumentHandler(response) {
        console.warn(response);

        var output = response.responseJSON;

        if (!output.success)
            return;

        var document = output.document
        $('#document-title').html(document.name);
        var div = $("<div>");
        div.addClass('col-md-12');
        div.addClass('file');
        div.attr('id', document.id);
        div.html(document.name + '<br>' + document.created_at);

        $('.file-drawer-content').append(div);

        notify(output.message);
    }

    function runCode() {
        $.ajax({
            url: "/ide/eval",
            type: "POST",
            data: {code: editor.getValue()},
            dataType: "json",
            complete: codeEvalResultHandler
        });
    }

    function saveNewDocument(name) {
        $.ajax({
            url: "/documents/create",
            type: "POST",
            data: {name: name, code: editor.getValue()},
            dataType: "json",
            complete: saveDocumentHandler
        });
    }

    function saveDocument(name) {
        $.ajax({
            url: "/documents/update",
            type: "PUT",
            data: {id: documentId, code: editor.getValue()},
            dataType: "json"
        });
    }

    function handleSaveEvent() {
        if($('#signup-button').length != 0)
            return;
        var name = $('#document-title').text();
        if (name == '' || name.length == 0) {
            $('#save-document-popup').css('display', 'block');
            $('#popup-shadow').css('display', 'block');
        } else {
            saveDocument(name);
        }
    }

    function loadFileHandler(response) {
        console.warn(response);

        var output = response.responseJSON;

        if (!output.success)
            notify(output.error);
        else {
            editor.setValue(output.code);
            $('#document-title').html(output.name);
        }
    }

    // --> Event handling <--

    function handleCtrlKeyEvents(e) {
        if (e.which == 13)
            runCode();
        else if (e.which == 83) {
            e.preventDefault();
            handleSaveEvent();
        }
    }

    function handleOtherKeyEvents(e) {
        if (e.which == 27) // esc
            if ($('#save-document-popup').css('display') != 'none')
                $('#cancel-save-script-button').click();
    }

    $(document).keydown(function (e) {
        if (e.ctrlKey)
            handleCtrlKeyEvents(e);
        else
            handleOtherKeyEvents(e)
    });

    $("#settings-drawer-button").hover(function () {
        $("#settings-drawer").css("transform", "translate(0)");
    });

    $("#settings-drawer").mouseleave(function () {
        $("#settings-drawer").css("transform", "translate(-100%)");
    });

    $("#file-drawer-button").hover(function () {
        $("#file-drawer").css("transform", "translate(0)");
        $("#file-drawer-button")
            .find("span")
            .removeClass("fa-folder")
            .addClass("fa-folder-open");
    });

    $("#file-drawer").mouseleave(function () {
        $("#file-drawer").css("transform", "translate(100%)");
        $("#file-drawer-button")
            .find("span")
            .removeClass("fa-folder-open")
            .addClass("fa-folder");
    });

    $('#save-script-button').click(function () {
        var name = $('#file-name').val();
        console.error(name);
        if (name == '' || name.length == 0)
            alert("File name can't be empty");
        else {
            saveNewDocument(name);
            $('#save-document-popup').css('display', 'none');
            $('#popup-shadow').css('display', 'none');
        }
    });

    $('#cancel-save-script-button').click(function () {
        $('#save-document-popup').css('display', 'none');
        $('#popup-shadow').css('display', 'none');
    });

    $("#run-code").click(function () {
        runCode();
    });

    $(".file")
        .hover(function () {
            $(this).addClass('file-highlight');
        })
        .mouseleave(function () {
            $(this).removeClass('file-highlight');
        })
        .click(function () {
            documentId = this.id;

            $.ajax({
                url: "/documents/show",
                type: "GET",
                data: {id: this.id},
                dataType: "json",
                complete: loadFileHandler
            });
        });

    function updateServerSettings(settingName, settingValue) {
        $.ajax({
            url: "/settings/update",
            type: "PUT",
            data: {settingName: settingName, settingValue: settingValue},
            dataType: "json"
        });
    }

    $("#line-numbers-switch").on('switchChange.bootstrapSwitch', function (event, state) {
        editor.setOption("lineNumbers", state);
        updateServerSettings("line_numbers", state);
    });

    $("#auto-indent-switch").on('switchChange.bootstrapSwitch', function (event, state) {
        editor.setOption("smartIndent", state);
        updateServerSettings("auto_indent", state);
    });

    $("#auto-complete-switch").on('switchChange.bootstrapSwitch', function (event, state) {
        if(state)
            CodeMirror.commands.autocomplete = autoComplete;
        else
            CodeMirror.commands.autocomplete = function () {};
        updateServerSettings("auto_correct", state);
    });
});