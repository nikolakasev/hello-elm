module Api exposing (fetchProcesses, fetchDetails)

import Http
import RemoteData
import Messages exposing (Msg)
import Model exposing (processesDecoder, processWithIngredientsDecoder)


fetchProcesses : Cmd Msg
fetchProcesses =
    Http.get fetchProcessesUrl processesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Messages.OnFetchProcesses


fetchProcessesUrl : String
fetchProcessesUrl =
    "http://localhost:3000/processes"


fetchDetails : String -> Cmd Msg
fetchDetails process =
    Http.get (fetchDetailsUrl ++ "/" ++ process) processWithIngredientsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Messages.OnFetchDetails


fetchDetailsUrl : String
fetchDetailsUrl =
    "http://localhost:3000/process"
