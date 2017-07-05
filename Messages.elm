module Messages exposing (..)

import Model exposing (Processes, ProcessWithIngredients, Id, Event)
import RemoteData exposing (WebData)


type Msg
    = OnFetchProcesses (WebData Processes)
    | OnFetchDetails (WebData ProcessWithIngredients)
    | OnSensorySubmit Id (WebData String)
    | Approved Event Id
    | Rejected Event Id
