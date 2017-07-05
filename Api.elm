module Api exposing (fetchProcesses, fetchDetails, submitSensoryEvent)

import RemoteData.Http exposing (get, post)
import Messages exposing (Msg)
import Model exposing (Id, Ingredient, processesDecoder, processWithIngredientsDecoder, decodeResponse, encodeSensory)


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
        Messages.Approved event processId ->
            postForSensoryEvent (event ++ "Approved") processId

        Messages.Rejected event processId ->
            postForSensoryEvent (event ++ "Rejected") processId

        _ ->
            Cmd.none


postForSensoryEvent : String -> String -> Cmd Msg
postForSensoryEvent event processId =
    post (processUrl ++ "/" ++ processId) (Messages.OnSensorySubmit processId) decodeResponse (encodeSensory event processId [ { name = "boo", value = "haha" } ])
