module BoardDetails.Model exposing (..)

import BoardTask
import Material


model : Model
model =
    { data = BoardTask.BoardView "" []
    , addCard = BoardTask.AddCard "" ""
    , addColumn = BoardTask.AddColumn ""
    , dialogAction = None
    , mdl = Material.model
    }


type Msg
    = AddToList
    | SetCardDialog BoardTask.ColumnView
    | SetColumnDialog
    | Mdl (Material.Msg Msg)


type DialogAction
    = AddNewCard
    | AddNewColumn
    | None


type alias Model =
    { data : BoardTask.BoardView
    , addCard : BoardTask.AddCard
    , addColumn : BoardTask.AddColumn
    , dialogAction : DialogAction
    , mdl : Material.Model
    }
