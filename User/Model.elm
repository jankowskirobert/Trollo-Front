module User.Model exposing (..)

import BoardTask


type Msg
    = Login
    | Logout


type alias Model =
    { boards : List (Maybe BoardTask.BoardView)
    }
