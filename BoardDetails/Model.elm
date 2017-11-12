module BoardDetails.Model exposing (..)

import BoardTask


-- import Column


model : Model
model =
    { board = Maybe.Nothing
    , columns =
        []

    -- , mdl = Material.model
    }


type Msg
    = NoneMsg



-- = AddToList
-- | SetCardDialog BoardTask.ColumnView
-- -- | ColumnMsg Column.Msg
-- | SetColumnDialog


type DialogAction
    = AddNewCard
    | AddNewColumn
    | None


type alias Model =
    { board : Maybe BoardTask.BoardView
    , columns : List BoardTask.ColumnView

    -- , addColumn : BoardTask.AddColumn
    -- , dialogAction : DialogAction
    -- , mdl : Material.Model
    -- , activeColumnView : Maybe BoardTask.ColumnView
    -- , column : List Column.Model
    }
