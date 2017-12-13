module Boards.Update exposing (update)

import Boards.Model exposing (Msg(..), Model, Operation(..))
import BoardTask
import Debug
import Http
import Json.Decode
import Json.Decode.Pipeline
import Boards.Rest as Rest
import Array
import Page
import BoardDetails.Model as BoardDetails


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Page.Page )
update msg model =
    case Debug.log "[BOARDS]Message" msg of
        AddBoard ->
            case model.newBoardName of
                Nothing ->
                    ( model, Cmd.none, Maybe.Nothing )

                Just x ->
                    let
                        boards_ =
                            model.boards
                    in
                        ( { model
                            | boards = (BoardTask.BoardView 0 x "") :: boards_
                            , showDialog = False
                          }
                        , Cmd.batch [ Cmd.map RestMsg (Rest.saveBoardView (BoardTask.BoardView 0 x "")) ]
                        , Maybe.Nothing
                        )

        SetOperation oper ->
            case oper of
                Edit boardId board ->
                    ( { model
                        | opr = Just oper
                        , currentBoardIdx = Just boardId
                        , currentBoard = Just board
                        , showDialog = True
                      }
                    , Cmd.none
                    , Maybe.Nothing
                    )

                HideDialog ->
                    ( { model
                        | opr = Just oper
                        , currentBoardIdx = Maybe.Nothing
                        , currentBoard = Maybe.Nothing
                        , showDialog = False
                      }
                    , Cmd.none
                    , Maybe.Nothing
                    )

                AddNewBoard ->
                    ( { model
                        | opr = Just oper
                        , showDialog = True
                      }
                    , Cmd.none
                    , Maybe.Nothing
                    )

                Choose selectedBoard ->
                    let
                        bdModel =
                            BoardDetails.model
                    in
                        ( { model
                            | opr = Just oper
                            , currentBoard = (Just selectedBoard)
                            , showDialog = False
                          }
                        , Cmd.none
                        , Just (Page.BoardDetailsPage selectedBoard { bdModel | board = Just selectedBoard })
                        )

                ConnectionError message ->
                    ( { model
                        | opr = Just oper
                        , showDialog = True
                      }
                    , Cmd.none
                    , Maybe.Nothing
                    )

        SetNewBoardName name_ ->
            ( { model | newBoardName = Just name_ }
            , Cmd.none
            , Maybe.Nothing
            )

        EditBoardName ->
            case model.currentBoard of
                Nothing ->
                    ( model, Cmd.none, Maybe.Nothing )

                Just choosedBoard ->
                    case model.newBoardName of
                        Nothing ->
                            ( model, Cmd.none, Maybe.Nothing )

                        Just x ->
                            case model.currentBoardIdx of
                                Nothing ->
                                    ( model, Cmd.none, Maybe.Nothing )

                                Just idx ->
                                    let
                                        boards_ =
                                            model.boards

                                        board_ =
                                            { choosedBoard | boardTitle = x }

                                        -- ( m, c ) =
                                        --     Rest.update (Rest.EditBoard board_) model.rest
                                        updatedBoards =
                                            (updateElement boards_ idx board_)
                                    in
                                        ( { model
                                            | boards = updatedBoards
                                            , opr = Just HideDialog
                                            , showDialog = False
                                            , newBoardName = Maybe.Nothing
                                          }
                                        , Cmd.batch [ Cmd.map RestMsg (Rest.updateBoardView board_) ]
                                        , Maybe.Nothing
                                        )

        RestMsg msg_ ->
            let
                ( m, c ) =
                    Rest.update msg_ model.rest

                remaped =
                    m.boards
            in
                ( { model | rest = m, boards = remaped }, Cmd.map RestMsg c, Maybe.Nothing )

        None ->
            ( model, Cmd.none, Maybe.Nothing )


decodeBoard : Json.Decode.Decoder BoardTask.BoardView
decodeBoard =
    Json.Decode.map3
        BoardTask.BoardView
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "boardTitle" Json.Decode.string)
        (Json.Decode.field "boardDescription" Json.Decode.string)


decodeBoards : Json.Decode.Decoder (List BoardTask.BoardView)
decodeBoards =
    Json.Decode.list decodeBoard


updateElement2 : List (Maybe a) -> Int -> a -> List (Maybe a)
updateElement2 list id board =
    List.take id list ++ (Just board) :: List.drop (id + 1) list


updateElement : List a -> Int -> a -> List a
updateElement list indexOnList card =
    let
        arry_ =
            Array.fromList list

        updated =
            Array.set indexOnList (card) arry_
    in
        --List.take id list ++ (Just board) :: List.drop (id + 1) list
        Array.toList updated
