-- I will be back!


module Boards.Rest exposing (..)

import BoardTask
import Debug
import Http
import Json.Decode
import Json.Encode
import Base64


type alias Model =
    { boards : List BoardTask.BoardView
    , board : Maybe BoardTask.BoardView
    , errorMessage : Maybe String
    , errorOccured : Maybe Bool
    }


type Msg
    = NoOp
    | GetBoardsFromApi (Result Http.Error (List BoardTask.BoardView))
    | SaveBoardToApi (Result Http.Error BoardTask.BoardView)
    | UpdateBoardToApi (Result Http.Error BoardTask.BoardView)
    | EditBoard BoardTask.BoardView
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
            "http://0.0.0.0:8000/boards"

        -- //Authorization: Basic cm9iZXJ0OmFwaXBhc3N3b3Jk
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" "Basic cm9iZXJ0OmFwaXBhc3N3b3Jk"
                    ]
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson decodeBoards
                , timeout = Nothing
                , withCredentials = False
                }

        req =
            Http.get url decodeBoards
    in
        Http.send GetBoardsFromApi request


saveBoardView : BoardTask.BoardView -> Cmd Msg
saveBoardView board =
    let
        url =
            "http://0.0.0.0:8000/boards/"

        req =
            Http.request
                { body = (Http.jsonBody (encodBoardView board))
                , expect = Http.expectJson decodeBoard
                , headers =
                    [ Http.header "Authorization" "Basic cm9iZXJ0OmFwaXBhc3N3b3Jk" ]
                , method = "POST"
                , timeout = Nothing
                , url = url
                , withCredentials = False
                }

        -- req =
        --     Http.post url (Http.jsonBody (encodBoardView board)) decodeBoard
    in
        Http.send SaveBoardToApi req


updateBoardView : BoardTask.BoardView -> Cmd Msg
updateBoardView board =
    let
        url =
            "http://0.0.0.0:8000/boards/"

        req =
            Http.request
                { body = (Http.jsonBody (encodFullBoardView board))
                , expect = Http.expectJson decodeBoard
                , headers =
                    [ Http.header "Authorization" "Basic cm9iZXJ0OmFwaXBhc3N3b3Jk" ]
                , method = "PUT"
                , timeout = Nothing
                , url = url
                , withCredentials = False
                }

        -- Http.post
        -- url
    in
        Http.send UpdateBoardToApi req


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GetBoardsFromApi (Ok item) ->
            let
                log =
                    Debug.log "OK HTTP" (toString item)
            in
                ( { model | boards = item }, Cmd.none )

        GetBoardsFromApi (Err err) ->
            let
                log =
                    Debug.log "ERROR HTTP" (toString err)
            in
                ( { model | errorMessage = Just ((toString err) ++ (". Failed to fetch boards: offline mode")), errorOccured = Just True }, Cmd.none )

        SaveBoardToApi (Ok item) ->
            let
                log =
                    Debug.log "OK HTTP" (toString item)

                boards_ =
                    model.boards
            in
                ( { model | boards = boards_ ++ [ item ] }, Cmd.none )

        SaveBoardToApi (Err err) ->
            let
                log =
                    Debug.log "ERROR HTTP" (toString err)
            in
                ( { model | errorMessage = Just ((toString err) ++ (". Failed to fetch boards: offline mode")), errorOccured = Just True }, Cmd.none )

        UpdateBoardToApi (Ok item) ->
            let
                log =
                    Debug.log "OK HTTP" (toString item)
            in
                ( { model | board = Just item }, getBoardView )

        UpdateBoardToApi (Err err) ->
            let
                log =
                    Debug.log "ERROR HTTP" (toString err)
            in
                ( { model | board = Maybe.Nothing, errorMessage = Just ((toString err) ++ (". Failed to fetch boards: offline mode")), errorOccured = Just True }, Cmd.none )

        FetchAll ->
            ( model, getBoardView )

        EditBoard b ->
            ( model, updateBoardView b )


encodBoardView : BoardTask.BoardView -> Json.Encode.Value
encodBoardView board =
    let
        val =
            [ ( "boardTitle", Json.Encode.string board.boardTitle )
            , ( "boardDescription", Json.Encode.string board.boardDescription )
            ]
    in
        val
            |> Json.Encode.object


encodFullBoardView : BoardTask.BoardView -> Json.Encode.Value
encodFullBoardView board =
    let
        val =
            [ ( "boardTitle", Json.Encode.string board.boardTitle )
            , ( "boardDescription", Json.Encode.string board.boardDescription )
            , ( "id", Json.Encode.int board.id )
            ]
    in
        val
            |> Json.Encode.object


updateElement2 : List (Maybe a) -> Int -> a -> List (Maybe a)
updateElement2 list id board =
    List.take id list ++ (Just board) :: List.drop (id + 1) list


buildAuthorizationToken : String -> String -> String
buildAuthorizationToken username password =
    let
        result =
            Base64.encode (username ++ ":" ++ password)
    in
        case result of
            Ok value ->
                value

            Err error ->
                "error: " ++ error
