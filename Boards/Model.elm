module Boards.Model exposing (Msg(..), Model, model, Operation(..))

import BoardTask
import Material


type Msg
    = AddBoard
    | EditBoardName
    | SetOperation Operation
    | SetNewBoardName String


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
    { boards = List.map (\x -> Just x) BoardTask.getExampleSetOfBoards
    , opr = None
    , currentBoard = Maybe.Nothing
    , newBoardName = Maybe.Nothing
    , currentBoardIdx = Maybe.Nothing
    , showDialog = False
    }
