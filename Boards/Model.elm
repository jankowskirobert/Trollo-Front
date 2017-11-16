module Boards.Model exposing (Msg(..), Model, model, Operation(..))

import BoardTask
import Http


type Msg
    = AddBoard
    | EditBoardName
    | SetOperation Operation
    | SetNewBoardName String
    | GetBardsFromApi (Result Http.Error (List BoardTask.BoardView))
    | FetchAll


type Operation
    = Choose BoardTask.BoardView
    | Edit Int BoardTask.BoardView
    | None
    | AddNewBoard


type alias Model =
    { boards : List (Maybe BoardTask.BoardView)
    , currentBoard : Maybe BoardTask.BoardView
    , opr : Operation
    , newBoardName : Maybe String
    , currentBoardIdx : Maybe Int
    , showDialog : Bool
    }


model : Model
model =
    { boards = []
    , opr = None
    , currentBoard = Maybe.Nothing
    , newBoardName = Maybe.Nothing
    , currentBoardIdx = Maybe.Nothing
    , showDialog = False
    }
