module Boards.Update exposing (update)

import Boards.Model exposing (Msg(..), Model, Operation(..))
import BoardTask
import Material


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddBoard ->
            case model.newBoardName of
                Nothing ->
                    ( model, Cmd.none )

                Just x ->
                    let
                        boards_ =
                            model.boards
                    in
                        ( { model | boards = (Just (BoardTask.BoardView 3 3 x)) :: boards_, showDialog = False }, Cmd.none )

        UpdateCurrentBoardView board ->
            ( { model | currentBoard = Just board, opr = Choose }, Cmd.none )

        SetOperation oper ->
            case oper of
                Edit boardId board ->
                    ( { model | opr = oper, currentBoardIdx = Just boardId, currentBoard = Just board, showDialog = True }, Cmd.none )

                None ->
                    ( { model | opr = oper, currentBoardIdx = Maybe.Nothing, currentBoard = Maybe.Nothing, showDialog = False }, Cmd.none )

                AddNewBoard ->
                    ( { model | opr = oper, showDialog = True }, Cmd.none )

                Choose ->
                    ( { model | opr = oper }, Cmd.none )

        SetNewBoardName name_ ->
            ( { model | newBoardName = Just name_ }, Cmd.none )

        EditBoardName ->
            case model.currentBoard of
                Nothing ->
                    ( model, Cmd.none )

                Just choosedBoard ->
                    case model.newBoardName of
                        Nothing ->
                            ( model, Cmd.none )

                        Just x ->
                            case model.currentBoardIdx of
                                Nothing ->
                                    ( model, Cmd.none )

                                Just idx ->
                                    let
                                        boards_ =
                                            model.boards

                                        board_ =
                                            { choosedBoard | title = x }
                                    in
                                        ( { model
                                            | boards = (updateElement2 boards_ idx board_)
                                            , opr = None
                                            , showDialog = False
                                            , newBoardName = Maybe.Nothing
                                          }
                                        , Cmd.none
                                        )


updateElement2 : List (Maybe BoardTask.BoardView) -> Int -> BoardTask.BoardView -> List (Maybe BoardTask.BoardView)
updateElement2 list id board =
    List.take id list ++ (Just board) :: List.drop (id + 1) list
