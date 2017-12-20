module BoardDetails.Model exposing (..)

import BoardTask
import BoardDetails.Card.Edit as CardEdit
import BoardDetails.Rest as CardRest


-- import Column


model : Model
model =
    { columns =
        []
    , showDialog = False
    , newColumnName = Maybe.Nothing
    , dialogAction = None
    , card = [] --BoardTask.getExampleSetOfCards
    , currentCard = Maybe.Nothing
    , currentCardIndex = Maybe.Nothing
    , newCardName = Maybe.Nothing
    , currentColumnIdx = Maybe.Nothing
    , currentColumn = Maybe.Nothing
    , cardModel = CardEdit.model
    , cardRest = CardRest.model
    , comments = []
    }


type Msg
    = NoneMsg
    | AddToList
    | EditName
    | AddNewList
    | SetDialogAction DialogAction
    | SetNewColumndName String
    | SetNewCardName String
    | AddNewCard
    | CardMsg CardEdit.Msg
    | RestCardMsg CardRest.Msg
    | EditList
    | FetchColumns BoardTask.BoardView



-- | SetCardDialog BoardTask.ColumnView
-- -- | ColumnMsg Column.Msg
-- | SetColumnDialog


type DialogAction
    = AddNewColumn
    | ShowCardDetail BoardTask.CardView
    | AddCard BoardTask.ColumnView
    | EditColumn Int BoardTask.ColumnView
    | None


type alias Model =
    { columns : List BoardTask.ColumnView
    , showDialog : Bool
    , newColumnName : Maybe String
    , dialogAction : DialogAction
    , card : List BoardTask.CardView
    , currentCard : Maybe BoardTask.CardView
    , currentCardIndex : Maybe Int
    , newCardName : Maybe String
    , currentColumnIdx : Maybe Int
    , currentColumn : Maybe BoardTask.ColumnView
    , cardModel : CardEdit.Model
    , cardRest : CardRest.Model
    , comments : List BoardTask.CommentView

    -- , addColumn : BoardTask.AddColumn
    -- , dialogAction : DialogAction
    -- , mdl : Material.Model
    -- , activeColumnView : Maybe BoardTask.ColumnView
    -- , column : List Column.Model
    }
