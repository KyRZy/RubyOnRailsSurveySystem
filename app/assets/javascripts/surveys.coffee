# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    number = 1
    $("#add_new_question").on "click", ->
        $("#survey").append($("#new_question").html())
        $("#survey").children().last().find("strong").html((++number)+".")

    $(document).on("focus", "#survey > .row > .answers > .answer > input", ( -> 
        if $(this).is($(this).parent().find("input:last"))
            $(this).attr("placeholder","").removeClass("pressForNewAnswer")

            numberString = $(this).parent().prev().children("span").html()
            number = parseFloat(numberString.substring(0,numberString.length-1))
            $(this).prev().removeClass("hidden").html(number+1+".")

            $(this).parent().parent().append($("#new_answer").html())
    ))