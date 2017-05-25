module Main exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main : Program Never (List String) Msg
main =
    Html.beginnerProgram { view = view, model = [ "one", "two" ], update = update }


type alias Ingredient =
    { name : String, value : String }


type Action
    = Doubt -- when a maybe occurs
    | FourEyePrinciple -- when two persons need to give approval


type alias ActionableProcess =
    { id : String, action : Action }


type alias Model =
    List String


model : Model
model =
    []


type Msg
    = Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            "added" :: model


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Increment ] [ text "-" ]
        , -- call tellMeIfNumber by turning the model which is Int into a Maybe first
          div [] [ text (List.length model |> toString) ]
        , button [ onClick Increment ] [ text "+" ]
        ]


tellMeIfNumber : Maybe Int -> String
tellMeIfNumber maybeNumber =
    case maybeNumber of
        Nothing ->
            "Nope, no number"

        Just number ->
            "Yup! The number is " ++ toString number
