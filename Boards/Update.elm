module Boards.Update exposing (update)

import Boards.Model exposing (Msg(..), Model, Operation(..))
import BoardTask
import Page exposing (Page(..))
import Debug
import Http
import Json.Decode
import Json.Decode.Pipeline
import Boards.Rest as Rest


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Page )
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
                            | boards = (Just (BoardTask.BoardView 3 x "")) :: boards_
                            , showDialog = False
                          }
                        , Cmd.none
                        , Maybe.Nothing
                        )

        SetOperation oper ->
            case oper of
                Edit boardId board ->
                    ( { model
                        | opr = oper
                        , currentBoardIdx = Just boardId
                        , currentBoard = Just board
                        , showDialog = True
                      }
                    , Cmd.none
                    , Maybe.Nothing
                    )

                None ->
                    ( { model
                        | opr = oper
                        , currentBoardIdx = Maybe.Nothing
                        , currentBoard = Maybe.Nothing
                        , showDialog = False
                      }
                    , Cmd.none
                    , Maybe.Nothing
                    )

                AddNewBoard ->
                    ( { model
                        | opr = oper
                        , showDialog = True
                      }
                    , Cmd.none
                    , Maybe.Nothing
                    )

                Choose selectedBoard ->
                    ( { model | opr = oper, currentBoard = (Just selectedBoard), showDialog = False }
                    , Cmd.none
                    , Just BoardDetailsPage
                    )

                ConnectionError message ->
                    ( { model
                        | opr = oper
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
                                    in
                                        ( { model
                                            | boards = (updateElement2 boards_ idx board_)
                                            , opr = None
                                            , showDialog = False
                                            , newBoardName = Maybe.Nothing
                                          }
                                        , Cmd.none
                                        , Maybe.Nothing
                                        )

        GetBardsFromApi (Ok item) ->
            let
                log =
                    Debug.log "OK HTTP" (toString item)

                brds_ =
                    List.map (\x -> Just x) item
            in
                ( { model | boards = brds_ }, Cmd.none, Maybe.Nothing )

        GetBardsFromApi (Err err) ->
            let
                log =
                    Debug.log "ERROR HTTP" (toString err)
            in
                ( { model | opr = ConnectionError ((toString err) ++ (". Failed to fetch boards: offline mode")), showDialog = True }, Cmd.none, Maybe.Nothing )

        RestMsg msg_ ->
            let
                ( m, c ) =
                    Rest.update msg_ model.rest

                remaped =
                    List.map (\x -> Just x) m.boards
            in
                ( { model | rest = m, boards = remaped }, Cmd.map RestMsg c, Maybe.Nothing )


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
