module Messages exposing (..)

import Model exposing (Processes)
import RemoteData exposing (WebData)


type Msg
    = OnFetchProcesses (WebData Processes)
