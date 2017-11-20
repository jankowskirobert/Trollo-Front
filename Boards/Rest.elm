-- I will be back!


module Boards.Rest exposing (..)

import BoardTask
import Debug
import Http
import Json.Decode


type alias Model =
    { boards : List BoardTask.BoardView
    , errorMessage : Maybe String
    }


type Msg
    = NoOp
    | GetBardsFromApi (Result Http.Error (List BoardTask.BoardView))
    | FetchAll


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


getBoardView : Cmd Msg
getBoardView =
    let
        url =
            "http://localhost:8000/boards/"

        req =
            Http.get url decodeBoards
    in
        Http.send GetBardsFromApi req


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GetBardsFromApi (Ok item) ->
            let
                log =
                    Debug.log "OK HTTP" (toString item)
            in
                ( { model | boards = item }, Cmd.none )

        GetBardsFromApi (Err err) ->
            let
                log =
                    Debug.log "ERROR HTTP" (toString err)
            in
                ( { model | errorMessage = Just ((toString err) ++ (". Failed to fetch boards: offline mode")) }, Cmd.none )

        FetchAll ->
            ( model, getBoardView )
