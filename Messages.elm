module Messages exposing (..)

import Model exposing (Processes, ProcessWithIngredients, Id)
import RemoteData exposing (WebData)


type Msg
    = OnFetchProcesses (WebData Processes)
    | OnFetchDetails (WebData ProcessWithIngredients)
    | Approved Id
    | Rejected Id
