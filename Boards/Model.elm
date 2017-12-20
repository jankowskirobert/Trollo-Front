module Boards.Model exposing (Msg(..), Model, model, Operation(..))

import BoardTask
import Http
import Boards.Rest as Rest


type Msg
    = AddBoard
    | EditBoardName
    | SetOperation Operation
    | SetNewBoardName String
    | SetNewBoardDescription String
    | RestMsg Rest.Msg
    | FetchAvaliableBoards
    | TogglePublic
    | None


type Operation
    = Choose BoardTask.BoardView
    | Edit Int BoardTask.BoardView
    | ConnectionError String
    | AddNewBoard
    | HideDialog


type alias Model =
    { boards : List BoardTask.BoardView
    , currentBoard : Maybe BoardTask.BoardView
    , opr : Maybe Operation
    , newBoardName : Maybe String
    , newBoardDesc : Maybe String
    , currentBoardIdx : Maybe Int
    , showDialog : Bool
    , rest : Rest.Model
    , publicAccess : Bool
    }


model : Model
model =
    { boards = []
    , opr = Maybe.Nothing
    , currentBoard = Maybe.Nothing
    , newBoardName = Maybe.Nothing
    , newBoardDesc = Maybe.Nothing
    , currentBoardIdx = Maybe.Nothing
    , showDialog = False
    , rest = Rest.Model [] Maybe.Nothing Maybe.Nothing Maybe.Nothing
    , publicAccess = False
    }
