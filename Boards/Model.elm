module Boards.Model exposing (Msg(..), Model, model, Operation(..))

import Material
import BoardTask


type Msg
    = AddBoard
    | UpdateCurrentBoardView BoardTask.BoardView
    | Mdl (Material.Msg Msg)


type Operation
    = Choose
    | Edit
    | None


type alias Model =
    { boards : List BoardTask.BoardView
    , boardDetails : BoardTask.BoardView
    , mdl : Material.Model
    , opr : Operation
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
        ({ boards = boards_, boardDetails = stricBoard_, mdl = Material.model, opr = None })
