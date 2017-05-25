# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
    number = 1 # liczba pytań w ankiecie
    $("#add_new_question").on "click", -> # dodanie nowego pytania
        $("#survey-generator").append($("#new_question").html()) # dodanie nowego pytania do formularza
        $("#survey-generator").children(":last").children(".answers").children(":not(:last-child)").children("input").attr("name","answers["+number+"][]") # dodanie odpowiedniego indekstu do nazw inputów
        $("#survey-generator").children(":last").find("strong").html((++number)+".") # dopisanie kolejnej liczby do nowego pytania
        $("#survey-generator").children(":last").find("input:checkbox").prop("value",number-1) # ustawienie wartości checkboxa jako indeks pytania
        $("html, body").animate({ scrollTop: $(document).height() }, 500); # zescrollowanie do nowo dodanego pytania

    $("#survey-generator").on "click", "input", ( -> # dodanie nowej odpowiedzi
        if $(this).parent().hasClass("has-error") # jeśli kliknięte pole było zaznaczone jako błędne
            $(this).parent().removeClass("has-error") # usunięcie błędu
            if $(this).next().hasClass("input-group-btn") # jeśli dane pole miało przycisk usuwania
                $(this).next().children().addClass("btn-default").removeClass("btn-danger") # podmiana przycisku z błędem na domyślny przycisk

        if $(this).parent().hasClass("answer-generator") && $(this).is($(this).parents().eq(1).find("input:last")) # jeśli naciśnięte zostało ostatnie pole na odpowiedź
            $(this).attr("placeholder","Odpowiedź").removeClass("pressForNewAnswer") # zmiana placeholdera, usunięcie przeźroczystości

            name = $(this).parent().prev().children("input").attr("name") # odczytanie nazwy poprzedniego inputu
            $(this).attr("name",name) # ustawienie odczytanej nazwy inputu do dodanej odpowiedzi

            answerNumberString = $(this).parent().prev().children("span").html() # odczytanie numeru z ostatniej odpowiedzi tego pytania
            answerNumber = parseInt(answerNumberString) # usunięcie kropki i parsowanie do integer
            $(this).prev().removeClass("hidden").html(answerNumber+1+".") # dodanie numeru do odpowiedzi
            $(this).next().removeClass("hidden") # wyświetlenie przycisku usuwającego odpowiedź
            $(this).parent().parent().append($("#new_answer").html()) # dodanie nowego pola na odpowiedź
    )
    $("#survey-generator").on "click", ".remove-question", ( -> 
        question = $(this).parents().eq(3) # zapisanie div'a z klasą row zawierającego pytanie i wszystkie odpowiedzi do zmiennej question
        if number > 1 # jeśli ankieta zawiera więcej niż jedno pytanie
            while question.next().length # jeśli ankieta zawiera jakieś kolejne pytanie
                question = question.next() # zapisanie kolejnego pytanie do zmiennej
                questionNumberString = question.find("span").first().children("strong").html() # odczytanie numeru tego pytania 
                questionNumber = parseInt(questionNumberString) # usunięcie kropki i parsowanie do integer
                question.find("span").first().children("strong").html((questionNumber-1)+".") # zmniejszenie numeru pytania o 1
                question.find("input:checkbox").prop("value",number-2) # zmniejszenie wartości checkboxa o 1 (ma być o 1 mniejsza od numeracji pytania)

                question.children(".answers").children(":not(:last-child)").children("input").attr("name","answers["+(questionNumber-2)+"][]") # zmniejszenie indeksu tabeli 2-wymiarowej w nazwie inputu
            $(this).parents().eq(3).remove() # usunięcie oryginalnego pytania
            number-- # zmniejszenie liczby reprezentującej liczbę pytań w ankiecie
    )

    $("#survey-generator").on "click", ".remove-answer", ( ->
        answerNumberString = $(this).parents().eq(1).siblings(":last").prev().children("span").first().html() # sprawdzenie numeru ostatniej odpowiedzi tego pytania
        if !(answerNumberString == "1." || answerNumberString == "2.") # jeśli pytanie ma więcej niż 2 odpowiedzi
            answer = $(this).parents().eq(1) # zapisanie diva zawierającego input na tekst oraz span'y z numerem pytania i przyciskiem X do zmiennej answer
            while answer.next().length # jeśli pytanie zawiera jakieś kolejną odpowiedź
                answer = answer.next() # zapisanie kolejnej odpowiedzi do zmiennej
                answerNumberString = answer.children("span").first().html() # odczytanie numeru tej odpowiedzi
                answerNumber = parseInt(answerNumberString) # usunięcie kropki i parsowanie do integer
                answer.children("span").first().html((answerNumber-1)+".") # zmniejszenie numeru odpowiedzi o 1
            $(this).parents().eq(1).remove() # usunięcie oryginalnej odpowiedzi
    )
    $("#survey_is_available_for_all").on "click", -> # jeśli kliknięty został checkbox pozwalający WSZYSTKIM na dostęp do wyników ankiety
        $("#survey_is_public").prop('checked', true) # zaznaczony zostaje także checkbox pozwalający ANKIETOWANYM na dostęp do wyników ankiety
        
    $("#survey_is_public").on "click", -> # jeśli odznaczony został checkbox pozwalający ANKIETOWANYM na dostęp do wyników ankiety
        $("#survey_is_available_for_all").prop('checked', false) # odznaczony zostaje także checkbox pozwalający WSZYSTKIM na dostęp do wyników ankiety

    $("form#survey-generator-form").on "submit",  -> # walidacja formularza po naciśnięciu przycisku
        validation = true # formularz wstępnie zostaje oceniony jako poprawnie uzupełniony
        $("input[type=text]").each( -> # dla każdego pola tekstowego
            if $(this).val() == "" && !$(this).hasClass("pressForNewAnswer") && !$(this).parents().eq(3).is("#new_question") # jeśli jest puste i nie jest ani polem do dodawania odpowiedzi ani schowanym pytaniem
                validation = false # formularz zostaje oceniony jako błędnie uzupełniony
                $(this).parent().addClass("has-error") # puste pole zostaje oznaczone czerwonym kolorem
                if $(this).next().hasClass("input-group-btn") # jeśli dane pole miało przycisk usuwania
                    $(this).next().children().removeClass("btn-default").addClass("btn-danger") # podmiana domyślnego przycisku na przycisk z błędem
        ) 
        if !validation # jeśli formularz nie przeszedł walidacji, dane z formularza NIE zostaną przesłane do serwera
            # $("div[role=alert]").removeClass("hidden")
            if !$("form#survey-generator-form").prev().is($("div[role=alert]"))
                $("form#survey-generator-form").before('<div class="alert alert-danger" role="alert">
                                                            <button type="button" class="close">&times;</button>
                                                            <strong>Błąd!</strong> W ankiecie znaleziono niewypełnione pola. Proszę je wypełnić i spróbować ponownie zapisać ankietę.
                                                        </div>')
            $("html, body").animate({ scrollTop: 0 }, 200); # zescrollowanie do początku strony
            false
        else
            true
    $(".container").on "click", "button.close", ->
        $(this).parent().remove()

    $('body').tooltip(selector: '[data-toggle=tooltip]') # włączenie podpowiedzi pojawiających się po najechaniu na przyciski X przy pytaniach i odpowiedziach
    $('#survey_start_date, #survey_end_date').datepicker({
        maxViewMode: 2,
        language: "pl",
        autoclose: true,
        todayHighlight: true
    });

    $("form#survey-form").on "submit", ->
        validation = true # formularz wstępnie zostaje oceniony jako poprawnie uzupełniony
        if $("#respondent_age").length && $("#respondent_age").val() == "" # jeśli pole na wiek jest puste
            $("#respondent_age").parent().addClass("has-error") # oznacz pole jako błędne
            validation = false
        if $('input:radio[name="respondent[sex]"]').length
            sexError = !$('input:radio[name="respondent[sex]"]').first().is(':checked') && !$('input:radio[name="respondent[sex]"]').last().is(':checked') # jeśli płeć nie została określona ustaw flagę błędu
        if sexError && $('.respondent-sex h2').children().length == 0 # jeśli znaleziono błąd przy deklaracji płci i komunikat błędu nie został już dodany
            $('.respondent-sex h2').append('<span class="no-answer-error"><span class="glyphicon glyphicon-arrow-left inline" style="font-size:24px"></span>Brak odpowiedzi</span>') # dodanie komunikatu błędu
            validation = false
        $(".question").each ( -> # dla każdego pytania
            answerIsSelected = false # wstępnie zostaje ustalone, że żadna z odpowiedzi nie została zaznaczona
            $(this).find("input").each ( -> # dla każdej odpowiedzi
                if $(this).is(':checked')# jeśli odpowiedź została zaznaczona
                    answerIsSelected = true  # ustawienie flagi zaznaczenia odpowiedzi
                    false # przerwanie pętli each, odpowiednik break
            ) 
            if !answerIsSelected  # jeśli żadna z odpowiedzi nie została zaznaczona
                validation = false 
                if !$(this).find("h2").children().is("span") # jeśli komunikat błędu nie został już wcześniej dodany
                    $(this).find("h2").append('<span class="no-answer-error"><span class="glyphicon glyphicon-arrow-left inline" style="font-size:24px"></span>Brak odpowiedzi</span>') # dodanie komunikatu błędu
        )
        if !validation
            if !$("form#survey-form").prev().is($("div[role=alert]"))
                $("form#survey-form").before('<div class="alert alert-danger" role="alert">
                                                            <button type="button" class="close">&times;</button>
                                                            <strong>Błąd!</strong> W ankiecie znaleziono pytania bez zaznaczonej odpowiedzi. Proszę na nie odpowiedzieć i spróbować ponownie wysłać ankietę.
                                                        </div>')
            $("html, body").animate({ scrollTop: 0 }, 200); # zescrollowanie do początku strony
            false
        else
            true
        
    $("#respondent_age").on "click", ->
        if $(this).parent().hasClass("has-error") # jeśli kliknięte pole było zaznaczone jako błędne
            $(this).parent().removeClass("has-error") # usunięcie błędu
    $("input:radio,input:checkbox").on "click", ->
        element = $(this).parent().parent().parent() # zapisanie elementu DOM do zmiennej w celu późniejszego określenia, który input został naciśnięty
        if !element.hasClass("answer") # jeśli naciśnięty input nie jest odpowiedzią
            element = element.prev() # oznacza to, że jest polem płci i tekst, z którego ma być usunięty błąd znajduje się element wcześniej
        else
            element = element.parent().prev() # w przeciwnym wypadku nacisnęliśmy pole odpowiedzi i tekst, z którego ma być usunięty błąd znajduje się wyżej w hierarchii
        
        if element.children().is("span") # jeśli komunikat błędu jest dopisany
            element.children().fadeOut(100, -> element.children().remove()) # komunikat błędu zostaje usunięty
        
