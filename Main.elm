module Main exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main : Program Never Int Msg
main =
    Html.beginnerProgram { view = view, model = 0, update = update }


type alias Model =
    Int


model : Model
model =
    0


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , -- call tellMeIfNumber by turning the model which is Int into a Maybe first
          div [] [ text (tellMeIfNumber (Just model)) ]
        , button [ onClick Increment ] [ text "+" ]
        ]


tellMeIfNumber : Maybe Int -> String
tellMeIfNumber maybeNumber =
    case maybeNumber of
        Nothing ->
            "Nope, no number"

        Just number ->
            "Yup! The number is " ++ toString number
