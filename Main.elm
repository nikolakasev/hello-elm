module Main exposing (..)

import Html exposing (Html, button, div, text, h5, blockquote)
import Html.Attributes exposing (class)


main : Program Never (List ActionableProcess) Msg
main =
    Html.beginnerProgram { view = view, model = [ someProcess ], update = update }


type alias Ingredient =
    { name : String, value : String }


type Action
    = Doubt -- when a maybe occurs
    | FourEyePrinciple -- when two persons need to give approval
    | SecondOpinion -- when the first person gave the approval or rejected


type alias ActionableProcess =
    { id : String, name : String, action : Action, info : List Ingredient }


someProcess : ActionableProcess
someProcess =
    { id = "7fbedbdf-c017-4fc9-b30a-3d356e12d0bf", name = "Carbonara cake", action = Doubt, info = [ { name = "Oven Temperature", value = "285" }, { name = "Chef Name", value = "John Doe" } ] }


type alias Model =
    List ActionableProcess


model : Model
model =
    []


type Msg
    = Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model


view : Model -> Html Msg
view model =
    div [ class "row" ] (List.map actionableCard [ someProcess ])


actionableCard : ActionableProcess -> Html Msg
actionableCard forProcess =
    div [ class "col m4" ]
        [ div [ class "card" ]
            [ div [ class "card-content" ]
                [ h5 [ class "truncate" ] [ text forProcess.name ]
                , blockquote [] [ text <| actionToText forProcess.action ]
                ]
            ]
        ]


actionToText : Action -> String
actionToText action =
    case action of
        Doubt ->
            "Maybe happened."

        FourEyePrinciple ->
            "Four-eye principle required."

        SecondOpinion ->
            "Second opinion required."


tellMeIfNumber : Maybe Int -> String
tellMeIfNumber maybeNumber =
    case maybeNumber of
        Nothing ->
            "Nope, no number"

        Just number ->
            "Yup! The number is " ++ toString number
