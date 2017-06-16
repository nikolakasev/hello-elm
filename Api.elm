module Api exposing (fetchProcesses, fetchDetails)

import RemoteData.Http exposing (get)
import Messages exposing (Msg)
import Model exposing (Id, Ingredient, processesDecoder, processWithIngredientsDecoder, encodeSensory)


fetchProcesses : Cmd Msg
fetchProcesses =
    get fetchProcessesUrl Messages.OnFetchProcesses processesDecoder


fetchProcessesUrl : String
fetchProcessesUrl =
    "http://localhost:3000/processes"


fetchDetails : Id -> Cmd Msg
fetchDetails process =
    get (processUrl ++ "/" ++ process) Messages.OnFetchDetails processWithIngredientsDecoder


processUrl : String
processUrl =
    "http://localhost:3000/process"
