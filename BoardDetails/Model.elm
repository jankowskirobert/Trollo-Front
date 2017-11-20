module BoardDetails.Model exposing (..)

import BoardTask
import BoardDetails.Card.Model as Card


-- import Column


model : Model
model =
    { board = Maybe.Nothing
    , columns =
        []
    , showDialog = False
    , newColumnName = Maybe.Nothing
    , dialogAction = None
    , card = [] --BoardTask.getExampleSetOfCards
    , currentCard = Maybe.Nothing
    , currentCardIndex = Maybe.Nothing
    , newCardName = Maybe.Nothing
    , currentColumnIdx = Maybe.Nothing
    , currentCardDescription = Maybe.Nothing
    , cardUpdateModel = UpdateCardModel Maybe.Nothing Maybe.Nothing Maybe.Nothing Maybe.Nothing
    , cardModel = Card.model

    -- , mdl = Material.model
    }


type Msg
    = NoneMsg
    | AddToList
    | EditName
    | AddNewList
    | SetDialogAction DialogAction
    | SetNewColumndName String
    | SetNewCardName String
    | SetNewCardDescription String
    | UpdateCurrentCard
    | AddNewCard
    | CardMsg Card.Msg



-- | SetCardDialog BoardTask.ColumnView
-- -- | ColumnMsg Column.Msg
-- | SetColumnDialog


type DialogAction
    = AddNewColumn
    | ShowCardDetail BoardTask.CardView
    | EditCardDetail Int BoardTask.CardView
    | AddCard Int
    | None


type alias UpdateCardModel =
    { currentCard : Maybe BoardTask.CardView
    , currentCardIndex : Maybe Int
    , newCardName : Maybe String
    , currentCardDescription : Maybe String
    }


type alias Model =
    { board : Maybe BoardTask.BoardView
    , columns : List BoardTask.ColumnView
    , showDialog : Bool
    , newColumnName : Maybe String
    , dialogAction : DialogAction
    , card : List (Maybe BoardTask.CardView)
    , currentCard : Maybe BoardTask.CardView
    , currentCardIndex : Maybe Int
    , newCardName : Maybe String
    , currentColumnIdx : Maybe Int
    , currentCardDescription : Maybe String
    , cardUpdateModel : UpdateCardModel
    , cardModel : Card.Model

    -- , addColumn : BoardTask.AddColumn
    -- , dialogAction : DialogAction
    -- , mdl : Material.Model
    -- , activeColumnView : Maybe BoardTask.ColumnView
    -- , column : List Column.Model
    }
