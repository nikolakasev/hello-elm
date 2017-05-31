module Main exposing (..)

import Html exposing (Html, button, div, text, h5, blockquote, p, br, a, i, span)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Json.Decode exposing (int, string, at, list, map, Decoder, decodeString)
import Json.Decode.Pipeline exposing (decode, required, optional, custom)
import Json.Decode.Extra exposing (date)
import Date exposing (Date)
import Dict exposing (Dict)


main : Program Never (List ActionableProcess) Msg
main =
    Html.beginnerProgram { view = view, model = [ someProcess ], update = update }


type alias Id =
    String


type alias Ingredient =
    { name : String, value : String }


type Action
    = Doubt -- when a maybe occurs
    | FourEyePrinciple -- when two persons need to give approval
    | SecondOpinion -- when the first person gave the approval or rejected


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
        [ i [ class "small material-icons left" ] [ text "thumb_up" ]
        , text "Approve"
        ]
    , span [] [ text " " ] -- put some space between the buttons
    , a
        [ class "waves-effect waves-light btn-floating red"
        , onClick <| Rejected processId
        ]
        [ i [ class "small material-icons left" ] [ text "thumb_down" ]
        , text "Reject"
        ]
    ]


processes : String
processes =
    """{
    "value" : [
        {
          "id": "436fdbcf-2505-4483-adc7-88b8e3b7c370",
          "recipe": "Carbonara cake",
          "started": "2017-05-24T15:55:11Z",
          "events": ["OvenPreheated", "ChefInfo"]
        },
        {
          "id": "e0e86e03-eb25-4ff7-ab48-a7653655e666",
          "recipe": "Carbonara cake",
          "started": "2017-04-20T15:53:06Z",
          "events": ["OvenPreheated", "OvenFailure"]
        }]
    }"""


type alias ProcessWithEvents =
    { id : String, recipe : String, started : Date, events : List String }


processDecoder : Decoder ProcessWithEvents
processDecoder =
    decode ProcessWithEvents
        |> required "id" string
        |> required "recipe" string
        |> required "started" date
        |> required "events" (list string)


type alias Processes =
    { value : List ProcessWithEvents }


processesDecoder : Decoder Processes
processesDecoder =
    decode Processes
        |> required "value" (list processDecoder)


ingredientDecoder : Decoder Ingredient
ingredientDecoder =
    decode Ingredient
        |> required "name" string
        |> required "value" string


resulto : Result String Processes
resulto =
    decodeString processesDecoder processes


type alias ActionableRecipe =
    { eventOfInterest : String, action : Action, compensatingEvent : String }


filterProcess : String -> String -> List ProcessWithEvents
filterProcess forRecipe withEvent =
    case resulto of
        Ok processes ->
            List.filter (\p -> List.member withEvent p.events && p.recipe == forRecipe) processes.value

        _ ->
            []


config : Dict String ActionableRecipe
config =
    Dict.fromList [ ( "Carbonara cake", { eventOfInterest = "OvenFailure", action = Doubt, compensatingEvent = "Maybe" } ) ]


determineActions : Dict String ActionableRecipe -> Dict String (List ProcessWithEvents)
determineActions config =
    Dict.map (\recipeName actionableRecipe -> filterProcess recipeName actionableRecipe.eventOfInterest) config
