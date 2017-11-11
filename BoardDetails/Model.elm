module BoardDetails.Model exposing (..)

import BoardTask
import Material
import Column


model : Model
model =
    { board = Maybe.Nothing
    , columns = [] ]
    , mdl = Material.model
    }


type Msg
    = AddToList
    | SetCardDialog BoardTask.ColumnView
    | ColumnMsg Column.Msg
    | SetColumnDialog
    | Mdl (Material.Msg Msg)


type DialogAction
    = AddNewCard
    | AddNewColumn
    | None


type alias Model =
    { board : Maybe BoardTask.BoardView
    , columns : List BoardTask.ColumnView
    , addColumn : BoardTask.AddColumn
    , dialogAction : DialogAction
    , mdl : Material.Model
    , activeColumnView : Maybe BoardTask.ColumnView
    , column : List Column.Model
    }
