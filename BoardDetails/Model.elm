module BoardDetails.Model exposing (..)

import BoardTask


-- import Column


model : Model
model =
    { board = Maybe.Nothing
    , columns =
        []
    , showDialog = False
    , newColumnName = Maybe.Nothing
    , dialogAction = None

    -- , mdl = Material.model
    }


type Msg
    = NoneMsg
    | AddToList
    | EditName
    | AddNewList
    | SetDialogAction DialogAction
    | SetNewColumndName String



-- | SetCardDialog BoardTask.ColumnView
-- -- | ColumnMsg Column.Msg
-- | SetColumnDialog


type DialogAction
    = AddNewColumn
    | None


type alias Model =
    { board : Maybe BoardTask.BoardView
    , columns : List BoardTask.ColumnView
    , showDialog : Bool
    , newColumnName : Maybe String
    , dialogAction : DialogAction

    -- , addColumn : BoardTask.AddColumn
    -- , dialogAction : DialogAction
    -- , mdl : Material.Model
    -- , activeColumnView : Maybe BoardTask.ColumnView
    -- , column : List Column.Model
    }
