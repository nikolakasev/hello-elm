module Commands exposing (fetchProcesses)

import Http
import RemoteData
import Messages exposing (Msg)
import Model exposing (processesDecoder)


fetchProcesses : Cmd Msg
fetchProcesses =
    Http.get fetchProcessesUrl processesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Messages.OnFetchProcesses


fetchProcessesUrl : String
fetchProcessesUrl =
    "http://localhost:3000/processes"
