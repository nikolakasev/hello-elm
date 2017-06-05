module Main exposing (..)

import Html exposing (Html, button, div, text, h4, h5, blockquote, p, br, a, i, span)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Dict exposing (Dict)
import Model exposing (Ingredient, Processes, Process, ProcessWithIngredients, testProcesses)


main : Program Never (List ActionableProcess) Msg
main =
    Html.beginnerProgram { view = view, model = [ someProcess ], update = update }


type alias Id =
    String


type Action
    = Doubt -- when a maybe occurs
    | FourEyePrinciple -- when two persons need to give approval
    | SecondOpinion -- when the first person gave the approval or rejected



-- + event + ingredient


type alias ActionableProcess =
    { id : Id, name : String, action : Action, info : List Ingredient }


someProcess : ActionableProcess
someProcess =
    { id = "7fbedbdf-c017-4fc9-b30a-3d356e12d0bf", name = "Carbonara cake", action = Doubt, info = [ { name = "Oven Temperature", value = "285" }, { name = "Chef Name", value = "John Doe" } ] }


type alias Model =
    List ActionableProcess


model : Model
model =
    []


type Msg
    = Approved Id
    | Rejected Id


update : Msg -> Model -> Model
update msg model =
    case msg of
        Approved id ->
            model

        Rejected id ->
            model


view : Model -> Html Msg
view model =
    div [ class "row" ] <| List.map actionableCard [ someProcess ]


actionableCard : ActionableProcess -> Html Msg
actionableCard forProcess =
    div [ class "col m4" ]
        [ div [ class "card" ]
            [ div [ class "card-content" ] <|
                [ h5 [ class "truncate" ] [ text forProcess.name ]
                , blockquote [] [ text <| actionToText forProcess.action ]
                , supportingInfo forProcess.info
                , br [] []
                ]
                    ++ actionButtons forProcess.id
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


supportingInfo : List Ingredient -> Html msg
supportingInfo ingredients =
    div [] <| List.map (\i -> p [] [ text <| String.join ": " [ i.name, i.value ] ]) ingredients


actionButtons : Id -> List (Html Msg)
actionButtons processId =
    [ a
        [ class "waves-effect waves-light btn-floating"
        , onClick <| Approved processId
        ]
        [ icon "thumb_up"
        , text "Approve"
        ]
    , span [] [ text " " ] -- put some space between the buttons
    , a
        [ class "waves-effect waves-light btn-floating red"
        , onClick <| Rejected processId
        ]
        [ icon "thumb_down"
        , text "Reject"
        ]
    ]


loading : Html msg
loading =
    div [ class "preloader-wrapper small active" ]
        [ div [ class "spinner-layer spinner-green-only" ]
            [ div [ class "circle-clipper left" ] [ div [ class "circle" ] [] ]

            --  , div [ class "gap-patch" ] [ div [ class "circle" ] [] ]
            --  , div [ class "circle-clipper right" ] [ div [ class "circle" ] [] ]
            ]
        ]


noProcessesFound : Html msg
noProcessesFound =
    div []
        [ h4 [] [ text "No actionable proceses found." ]
        ]


error : String -> Html msg
error message =
    div []
        [ icon "error"
        , h4 [] [ text message ]
        ]


icon : String -> Html msg
icon name =
    i [ class "small material-icons left" ] [ text name ]


type alias ActionableRecipe =
    { eventOfInterest : String, action : Action, compensatingEvent : String, ingredient : String }


filterProcess : Processes -> String -> String -> List Process
filterProcess list forRecipe withEvent =
    List.filter (\p -> List.member withEvent p.events && p.recipe == forRecipe) list.value


config : Dict String ActionableRecipe
config =
    Dict.fromList [ ( "Carbonara cake", { eventOfInterest = "OvenFailure", action = Doubt, compensatingEvent = "Maybe", ingredient = "AnswerWithYesOrNo" } ) ]


determineActions : Processes -> Dict String ActionableRecipe -> Dict String ( List Process, ActionableRecipe )
determineActions forProcesses withConfig =
    Dict.map (\recipeName actionableRecipe -> ( filterProcess forProcesses recipeName actionableRecipe.eventOfInterest, actionableRecipe )) withConfig


test : Result String (Dict String ( List Process, ActionableRecipe ))
test =
    -- pass each process from testProcesses as the first parameter to determineActions
    Result.map (flip determineActions config) testProcesses
