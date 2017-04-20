# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    $("#add_new_question").on "click", ->
        $("#survey").append($("#new_question").html())

    $(document).on("focus", "#survey > .row > .answers > input", ( -> 
        if $(this).is($(this).parent().find("input:last"))
            $(this).parent().append($("#new_answer").html())
    ))