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
        question = $(this).parent().parent().parent().parent() # zapisanie div'a z klasą row zawierającego pytanie i wszystkie odpowiedzi do zmiennej question
        while question.next().length # jeśli ankieta zawiera jakieś kolejne pytanie
            question = question.next() # zapisanie kolejnego pytanie do zmiennej
            questionNumberString = question.find("span").first().children("strong").html() # odczytanie numeru tego pytania 
            questionNumber = parseFloat(questionNumberString.substring(0,questionNumberString.length-1)) # usunięcie kropki i parsowanie do integer
            question.find("span").first().children("strong").html((questionNumber-1)+".") # zmniejszenie numeru pytania o 1
        $(this).parent().parent().parent().parent().remove() # usunięcie oryginalnego pytania
        number--
    ))

    $(document).on("click", ".remove-answer", ( -> 
        answer = $(this).parent().parent() # zapisanie diva zawierającego input na tekst oraz span'y z numerem pytania i przyciskiem X do zmiennej answer
        while answer.next().length # jeśli pytanie zawiera jakieś kolejną odpowiedź
            answer = answer.next() # zapisanie kolejnej odpowiedzi do zmiennej
            answerNumberString = answer.children("span").first().html() # odczytanie numeru tej odpowiedzi
            answerNumber = parseFloat(answerNumberString.substring(0,answerNumberString.length-1)) # usunięcie kropki i parsowanie do integer
            answer.children("span").first().html((answerNumber-1)+".") # zmniejszenie numeru odpowiedzi o 1
        $(this).parent().parent().remove() # usunięcie oryginalnej odpowiedzi
    ))
    $('body').tooltip(selector: '[data-toggle=tooltip]') # włączenie podpowiedzi pojawiających się po najechaniu na przyciski X przy pytaniach i odpowiedziach