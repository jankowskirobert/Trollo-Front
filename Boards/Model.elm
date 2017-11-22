module Boards.Model exposing (Msg(..), Model, model, Operation(..))

import BoardTask
import Http
import Boards.Rest as Rest


type Msg
    = AddBoard
    | EditBoardName
    | SetOperation Operation
    | SetNewBoardName String
    | RestMsg Rest.Msg


type Operation
    = Choose BoardTask.BoardView
    | Edit Int BoardTask.BoardView
    | None
    | ConnectionError String
    | AddNewBoard


type alias Model =
    { boards : List (Maybe BoardTask.BoardView)
    , currentBoard : Maybe BoardTask.BoardView
    , opr : Operation
    , newBoardName : Maybe String
    , currentBoardIdx : Maybe Int
    , showDialog : Bool
    , rest : Rest.Model
    }


model : Model
model =
    { boards = []
    , opr = None
    , currentBoard = Maybe.Nothing
    , newBoardName = Maybe.Nothing
    , currentBoardIdx = Maybe.Nothing
    , showDialog = False
    , rest = Rest.Model [] Maybe.Nothing
    }
