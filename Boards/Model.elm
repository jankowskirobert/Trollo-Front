module Boards.Model exposing (Msg(..), Model, model)

import Material
import BoardTask


type Msg
    = AddBoard
    | UpdateCurrentBoardView BoardTask.BoardView
    | Mdl (Material.Msg Msg)


type alias Model =
    { boards : List BoardTask.BoardView
    , boardDetails : BoardTask.BoardView
    , mdl : Material.Model
    }


model : Model
model =
    let
        boards_ =
            BoardTask.getExampleSetOfBoards

        board_ =
            List.head boards_

        stricBoard_ =
            Maybe.withDefault (BoardTask.BoardView "" []) board_
    in
        ({ boards = boards_, boardDetails = stricBoard_, mdl = Material.model })
