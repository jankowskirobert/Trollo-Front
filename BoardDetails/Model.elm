module BoardDetails.Model exposing (..)

import BoardTask
import BoardDetails.Card.Edit as CardEdit
import BoardDetails.Rest as CardRest
import Date
import Task
import Time


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
    , currentCardDescription = Maybe.Nothing
    , newCommentBody = Maybe.Nothing
    , currentDate = Maybe.Nothing
    , newColor = Maybe.Nothing
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
    | SetNewCardDescription String
      -- | SetCardArchive
    | UpdateCurrentCard
    | SetNewCardComment String
    | AddNewComment
    | SaveNewDate Date.Date
    | UpdateCurrentDate
    | UpdateColor String



-- | SetCardDialog BoardTask.ColumnView
-- -- | ColumnMsg Column.Msg
-- | SetColumnDialog


type DialogAction
    = AddNewColumn
    | ShowCardDetail BoardTask.CardView
    | AddCard BoardTask.ColumnView
    | EditColumn Int BoardTask.ColumnView
    | EditCard BoardTask.CardView (List BoardTask.CommentView)
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
    , newCommentBody : Maybe String
    , currentDate : Maybe Date.Date
    , newColor : Maybe String
    , currentCardDescription : Maybe String

    -- , addColumn : BoardTask.AddColumn
    -- , dialogAction : DialogAction
    -- , mdl : Material.Model
    -- , activeColumnView : Maybe BoardTask.ColumnView
    -- , column : List Column.Model
    }
