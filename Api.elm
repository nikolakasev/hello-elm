module Api exposing (fetchProcesses, fetchDetails, submitSensoryEvent)

import RemoteData.Http exposing (get)
import Messages exposing (Msg)
import Model exposing (Id, Ingredient, processesDecoder, processWithIngredientsDecoder, encodeSensory)


fetchProcesses : Cmd Msg
fetchProcesses =
    get fetchProcessesUrl Messages.OnFetchProcesses processesDecoder


fetchProcessesUrl : String
fetchProcessesUrl =
    "http://localhost:3000/api/processes"


fetchDetails : Id -> Cmd Msg
fetchDetails process =
    get (processUrl ++ "/" ++ process) Messages.OnFetchDetails processWithIngredientsDecoder


processUrl : String
processUrl =
    "http://localhost:3000/api/process"


submitSensoryEvent : Msg -> Cmd Msg
submitSensoryEvent action =
    case action of
        Messages.Approved processId ->
            Cmd.none

        Messages.Rejected processId ->
            Cmd.none

        _ ->
            Cmd.none
