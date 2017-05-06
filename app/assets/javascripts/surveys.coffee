# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
    number = 1 # liczba pytań w ankiecie
    $("#add_new_question").on "click", -> # dodanie nowego pytania
        $("#survey").append($("#new_question").html()) # dodanie nowego pytania do formularza
        $("#survey").children(":last").children(".answers").children(":not(:last-child)").children("input").attr("name","answers["+number+"][]") # dodanie odpowiedniego indekstu do nazw inputów
        $("#survey").children(":last").find("strong").html((++number)+".") # dopisanie kolejnej liczby do nowego pytania
        $("html, body").animate({ scrollTop: $(document).height() }, 500); # zescrollowanie do nowo dodanego pytania

    $("#survey").on "click", "input", ( -> # dodanie nowej odpowiedzi
        if $(this).parent().hasClass("has-error") # jeśli kliknięte pole było zaznaczone jako błędne
            $(this).parent().removeClass("has-error") # usunięcie błędu
            if $(this).next().hasClass("input-group-btn") # jeśli dane pole miało przycisk usuwania
                $(this).next().children().addClass("btn-default").removeClass("btn-danger") # podmiana przycisku z błędem na domyślny przycisk

        if $(this).parent().hasClass("answer") && $(this).is($(this).parents().eq(1).find("input:last")) # jeśli naciśnięte zostało ostatnie pole na odpowiedź
            $(this).attr("placeholder","").removeClass("pressForNewAnswer") # zmiana placeholdera, usunięcie przeźroczystości

            name = $(this).parent().prev().children("input").attr("name") # odczytanie nazwy poprzedniego inputu
            $(this).attr("name",name) # ustawienie odczytanej nazwy inputu do dodanej odpowiedzi

            answerNumberString = $(this).parent().prev().children("span").html() # odczytanie numeru z ostatniej odpowiedzi tego pytania
            answerNumber = parseFloat(answerNumberString.substring(0,answerNumberString.length-1)) # usunięcie kropki i parsowanie do integer
            $(this).prev().removeClass("hidden").html(answerNumber+1+".") # dodanie numeru do odpowiedzi
            $(this).next().removeClass("hidden") # wyświetlenie przycisku usuwającego odpowiedź
            $(this).parent().parent().append($("#new_answer").html()) # dodanie nowego pola na odpowiedź
    )
    $("#survey").on "click", ".remove-question", ( -> 
        question = $(this).parents().eq(3) # zapisanie div'a z klasą row zawierającego pytanie i wszystkie odpowiedzi do zmiennej question
        if number > 1 # jeśli ankieta zawiera więcej niż jedno pytanie
            while question.next().length # jeśli ankieta zawiera jakieś kolejne pytanie
                question = question.next() # zapisanie kolejnego pytanie do zmiennej
                questionNumberString = question.find("span").first().children("strong").html() # odczytanie numeru tego pytania 
                questionNumber = parseFloat(questionNumberString.substring(0,questionNumberString.length-1)) # usunięcie kropki i parsowanie do integer
                question.find("span").first().children("strong").html((questionNumber-1)+".") # zmniejszenie numeru pytania o 1

                question.children(".answers").children(":not(:last-child)").children("input").attr("name","answers["+(questionNumber-2)+"][]") # zmniejszenie indeksu tabeli 2-wymiarowej w nazwie inputu
            $(this).parents().eq(3).remove() # usunięcie oryginalnego pytania
            number-- # zmniejszenie liczby reprezentującej liczbę pytań w ankiecie
    )

    $("#survey").on "click", ".remove-answer", ( ->
        answerNumberString = $(this).parents().eq(1).siblings(":last").prev().children("span").first().html() # sprawdzenie numeru ostatniej odpowiedzi tego pytania
        if !(answerNumberString == "1." || answerNumberString == "2.") # jeśli pytanie ma więcej niż 2 odpowiedzi
            answer = $(this).parents().eq(1) # zapisanie diva zawierającego input na tekst oraz span'y z numerem pytania i przyciskiem X do zmiennej answer
            while answer.next().length # jeśli pytanie zawiera jakieś kolejną odpowiedź
                answer = answer.next() # zapisanie kolejnej odpowiedzi do zmiennej
                answerNumberString = answer.children("span").first().html() # odczytanie numeru tej odpowiedzi
                answerNumber = parseFloat(answerNumberString.substring(0,answerNumberString.length-1)) # usunięcie kropki i parsowanie do integer
                answer.children("span").first().html((answerNumber-1)+".") # zmniejszenie numeru odpowiedzi o 1
            $(this).parents().eq(1).remove() # usunięcie oryginalnej odpowiedzi
    )
    $("#survey_is_available_for_all").on "click", -> # jeśli kliknięty został checkbox pozwalający WSZYSTKIM na dostęp do wyników ankiety
        $("#survey_is_public").prop('checked', true) # zaznaczony zostaje także checkbox pozwalający ANKIETOWANYM na dostęp do wyników ankiety
        
    $("#survey_is_public").on "click", -> # jeśli odznaczony został checkbox pozwalający ANKIETOWANYM na dostęp do wyników ankiety
        $("#survey_is_available_for_all").prop('checked', false) # odznaczony zostaje także checkbox pozwalający WSZYSTKIM na dostęp do wyników ankiety

    $("form#new_survey").on "submit",  -> # walidacja formularza po naciśnięciu przycisku
        validation = true # formularz wstępnie zostaje oceniony jako poprawnie uzupełniony
        $("input[type=text]").each( -> # dla każdego pola tekstowego
            if $(this).val() == "" && !$(this).hasClass("pressForNewAnswer") && !$(this).parents().eq(3).is("#new_question") # jeśli jest puste i nie jest ani polem do dodawania odpowiedzi ani schowanym pytaniem
                validation = false # formularz zostaje oceniony jako błędnie uzupełniony
                $(this).parent().addClass("has-error") # puste pole zostaje oznaczone czerwonym kolorem
                if $(this).next().hasClass("input-group-btn") # jeśli dane pole miało przycisk usuwania
                    $(this).next().children().removeClass("btn-default").addClass("btn-danger") # podmiana domyślnego przycisku na przycisk z błędem
        ) 
        if !validation # jeśli formularz nie przeszedł walidacji, dane z formularza NIE zostaną przesłane do serwera
            false
        else
            true
        

    $('body').tooltip(selector: '[data-toggle=tooltip]') # włączenie podpowiedzi pojawiających się po najechaniu na przyciski X przy pytaniach i odpowiedziach
    $('#survey_start_date, #survey_end_date').datetimepicker({locale: 'pl', format: 'LL'});