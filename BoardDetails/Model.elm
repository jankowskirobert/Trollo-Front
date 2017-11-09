module BoardDetails.Model exposing (..)

import BoardTask
import Material
import Column


model : Model
model =
    { data = BoardTask.BoardView "" []
    , addCard = BoardTask.AddCard "" ""
    , addColumn = BoardTask.AddColumn ""
    , activeColumnView = Maybe.Nothing
    , dialogAction = None
    , mdl = Material.model
    , column = Column.model
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
    { data : BoardTask.BoardView
    , addCard : BoardTask.AddCard
    , addColumn : BoardTask.AddColumn
    , dialogAction : DialogAction
    , mdl : Material.Model
    , activeColumnView : Maybe BoardTask.ColumnView
    , column : Column.Model
    }
