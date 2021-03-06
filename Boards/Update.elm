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


update : BoardTask.User -> Msg -> Model -> ( Model, Cmd Msg, Maybe Page.Page )
update session msg model =
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
                            | boards = (BoardTask.BoardView 0 x "" model.publicAccess "") :: boards_
                            , showDialog = False
                          }
                        , Cmd.batch [ Cmd.map RestMsg (Rest.saveBoardView session.auth (BoardTask.BoardView 0 x "" model.publicAccess "")) ]
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
                        , Just (Page.BoardDetailsPage selectedBoard bdModel)
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

        SetNewBoardDescription desc_ ->
            ( { model | newBoardDesc = Just desc_ }
            , Cmd.none
            , Maybe.Nothing
            )

        TogglePublic ->
            ( { model | publicAccess = not model.publicAccess }
            , Cmd.none
            , Maybe.Nothing
            )

        EditBoardName ->
            case model.currentBoard of
                Nothing ->
                    ( model, Cmd.none, Maybe.Nothing )

                Just choosedBoard ->
                    let
                        ( newM, newC ) =
                            case ( model.newBoardName, model.newBoardDesc ) of
                                ( Nothing, Nothing ) ->
                                    ( model, Cmd.none )

                                ( Just x, Nothing ) ->
                                    let
                                        board_ =
                                            { choosedBoard | boardTitle = x, public_access = model.publicAccess }
                                    in
                                        ( { model
                                            | opr = Just HideDialog
                                            , showDialog = False
                                            , newBoardName = Maybe.Nothing
                                          }
                                        , Cmd.batch [ Cmd.map RestMsg (Rest.updateBoardView session.auth board_) ]
                                        )

                                ( Nothing, Just y ) ->
                                    let
                                        board_ =
                                            { choosedBoard | boardDescription = y, public_access = model.publicAccess }
                                    in
                                        ( { model
                                            | opr = Just HideDialog
                                            , showDialog = False
                                            , newBoardName = Maybe.Nothing
                                          }
                                        , Cmd.batch [ Cmd.map RestMsg (Rest.updateBoardView session.auth board_) ]
                                        )

                                ( Just x, Just y ) ->
                                    let
                                        board_ =
                                            { choosedBoard | boardTitle = x, boardDescription = y, public_access = model.publicAccess }
                                    in
                                        ( { model
                                            | opr = Just HideDialog
                                            , showDialog = False
                                            , newBoardName = Maybe.Nothing
                                          }
                                        , Cmd.batch [ Cmd.map RestMsg (Rest.updateBoardView session.auth board_) ]
                                        )
                    in
                        ( newM, newC, Maybe.Nothing )

        FetchAvaliableBoards ->
            ( model
            , Cmd.batch [ Cmd.map RestMsg (Rest.getBoardView session.auth) ]
            , Maybe.Nothing
            )

        RestMsg msg_ ->
            let
                ( m, c ) =
                    Rest.update session msg_ model.rest

                remaped =
                    m.boards
            in
                ( { model | rest = m, boards = remaped }, Cmd.map RestMsg c, Maybe.Nothing )

        None ->
            ( model, Cmd.none, Maybe.Nothing )


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
