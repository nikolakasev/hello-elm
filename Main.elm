module Main exposing (..)

import Html exposing (Html, button, div, text, h4, h5, blockquote, p, br, a, i, span)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Dict exposing (Dict)
import Model exposing (Id, Ingredient, Processes, Process, ProcessWithIngredients, testProcesses)
import Messages exposing (..)
import Api
import RemoteData exposing (WebData)
import List.FlatMap exposing (flatMap)


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


type Action
    = Doubt -- when a maybe occurs
    | FourEyePrinciple -- when two persons need to give approval
    | SecondOpinion -- when the first person gave the approval or rejected



-- + event + ingredient


type alias ActionableProcess =
    { id : Id, name : String, action : Action, info : Maybe (List Ingredient) }


someProcess : ActionableProcess
someProcess =
    { id = "7fbedbdf-c017-4fc9-b30a-3d356e12d0bf", name = "Carbonara cake", action = Doubt, info = Just [ { name = "Oven Temperature", value = "285" }, { name = "Chef Name", value = "John Doe" } ] }


type alias Model =
    { processes : WebData Processes, actionables : List ActionableProcess, details : Int }


init : ( Model, Cmd Msg )
init =
    ( model, Api.fetchProcesses )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


model : Model
model =
    { processes = RemoteData.Loading, actionables = [ someProcess ], details = 0 }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnFetchProcesses response ->
            ( { model | processes = response }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model.processes of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            loading

        RemoteData.Success p ->
            error "Loaded."

        RemoteData.Failure err ->
            error <| toString err



--  div [ class "row" ] <| List.map actionableCard model.actionables


actionableCard : ActionableProcess -> Html Msg
actionableCard forProcess =
    div [ class "col m4" ]
        [ div [ class "card" ]
            [ div [ class "card-content" ] <|
                [ h5 [ class "truncate" ] [ text forProcess.name ]
                , blockquote [] [ text <| actionToText forProcess.action ]
                , loadingOrInfo forProcess.info
                , br [] []
                ]
                    ++ actionButtons forProcess.id
            ]
        ]


loadingOrInfo : Maybe (List Ingredient) -> Html msg
loadingOrInfo list =
    case list of
        Just ingredients ->
            supportingInfo ingredients

        Nothing ->
            cardProgress


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



{- shows the green circle rotating at the top of the page, used on initial page load -}


loading : Html msg
loading =
    div [ class "preloader-wrapper small active" ]
        [ div [ class "spinner-layer spinner-green-only" ]
            [ div [ class "circle-clipper left" ] [ div [ class "circle" ] [] ]

            --  , div [ class "gap-patch" ] [ div [ class "circle" ] [] ]
            --  , div [ class "circle-clipper right" ] [ div [ class "circle" ] [] ]
            ]
        ]



{- shows a progress bar in a card, used when loading ingregients for a process -}


cardProgress : Html msg
cardProgress =
    div [ class "progress" ]
        [ div [ class "indeterminate" ] [] ]


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


determineActions : Processes -> Dict String ActionableRecipe -> List ActionableProcess
determineActions forProcesses withConfig =
    -- filter processes containing an event of interest and turn them into actionable processes
    Dict.map
        (\recipe config ->
            List.map (flip processToActionable config) (filterProcess forProcesses recipe config.eventOfInterest)
        )
        withConfig
        --extract all actionable processes from the map
        |> Dict.toList
        |> flatMap (\( recipe, processes ) -> processes)



--|> Dict.map
-- convert into an actionable process
--|> Dict.map (\recipe ( processes, config ) -> recipe)


processToActionable : Process -> ActionableRecipe -> ActionableProcess
processToActionable process config =
    { id = process.id, name = process.recipe, action = config.action, info = Nothing }


test : Result String (List ActionableProcess)
test =
    -- pass each process from testProcesses as the first parameter to determineActions
    Result.map (flip determineActions config) testProcesses
