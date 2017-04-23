# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
    number = 1
    $("#add_new_question").on "click", ->
        $("#survey").append($("#new_question").html()) # dodanie nowego pytania do formularza
        $("#survey").children().last().find("strong").html((++number)+".") # dopisanie kolejnej liczby do nowego pytania

    $(document).on("focus", "#survey > .row > .answers > .answer > input", ( -> 
        if $(this).is($(this).parent().parent().find("input:last")) # jeśli naciśnięte zostało ostatnie pole na odpowiedź
            $(this).attr("placeholder","").removeClass("pressForNewAnswer") # zmiana placeholdera, usunięcie przeźroczystości

            answerNumberString = $(this).parent().prev().children("span").html() # odczytanie numeru z ostatniej odpowiedzi tego pytania
            answerNumber = parseFloat(answerNumberString.substring(0,answerNumberString.length-1)) # usunięcie kropki i parsowanie do integer
            $(this).prev().removeClass("hidden").html(answerNumber+1+".") # dodanie numeru do odpowiedzi
            $(this).next().children().removeClass("hidden") # wyświetlenie przycisku usuwającego odpowiedź
            $(this).parent().parent().append($("#new_answer").html()) # dodanie nowego pola na odpowiedź
    ))
    $(document).on("click", ".remove-question", ( -> 
        question = $(this).parent().parent().parent().parent()
        while question.next().length
            question = question.next()
            questionNumberString = question.find("span").first().children("strong").html()
            questionNumber = parseFloat(questionNumberString.substring(0,questionNumberString.length-1))
            question.find("span").first().children("strong").html((questionNumber-1)+".")
        $(this).parent().parent().parent().parent().remove()
        number--
    ))

    $(document).on("click", ".remove-answer", ( -> 
        answer = $(this).parent().parent()
        while answer.next().length
            answer = answer.next()
            answerNumberString = answer.children("span").first().html()
            answerNumber = parseFloat(answerNumberString.substring(0,answerNumberString.length-1))
            answer.children("span").first().html((answerNumber-1)+".")
        $(this).parent().parent().remove()
    ))
    $('body').tooltip(selector: '[data-toggle=tooltip]')