module BoardDetails.Rest exposing (..)

import BoardTask
import Debug
import Http
import Json.Decode
import Json.Encode
import Task


type alias Model =
    { cards : List BoardTask.CardView
    , card : Maybe BoardTask.CardView
    , comments : List BoardTask.CommentView
    , comment : Maybe BoardTask.CommentView
    , columns : List BoardTask.ColumnView
    , column : Maybe BoardTask.ColumnView
    }


model : Model
model =
    { cards = []
    , card = Maybe.Nothing
    , comments = []
    , comment = Maybe.Nothing
    , columns = []
    , column = Maybe.Nothing
    }


type Msg
    = GetCardsFromApi (Result Http.Error (List BoardTask.CardView))
    | GetCardFromApi (Result Http.Error BoardTask.CardView)
    | SaveCardToApi (Result Http.Error BoardTask.CardView)
    | GetColumnsFromApi (Result Http.Error (List BoardTask.ColumnView))
    | GetColumnFromApi (Result Http.Error BoardTask.ColumnView)
    | SaveColumnToApi (Result Http.Error BoardTask.ColumnView)
    | UpdateColumnToApi (Result Http.Error BoardTask.ColumnView)
    | AddCard BoardTask.CardView
    | FetchAllCards
    | FetchAllColumns BoardTask.BoardView


update : BoardTask.User -> Msg -> Model -> ( Model, Cmd Msg )
update session msg model =
    case Debug.log "Card Rest" msg of
        GetColumnsFromApi (Err err) ->
            ( model, Cmd.none )

        GetColumnsFromApi (Ok item) ->
            ( { model | columns = item }, Cmd.none )

        GetColumnFromApi (Err err) ->
            ( model, Cmd.none )

        GetColumnFromApi (Ok item) ->
            ( model, Cmd.none )

        GetCardsFromApi (Err err) ->
            ( model, Cmd.none )

        GetCardsFromApi (Ok item) ->
            ( { model | cards = item }, Cmd.none )

        GetCardFromApi (Err err) ->
            ( model, Cmd.none )

        GetCardFromApi (Ok item) ->
            ( model, Cmd.none )

        SaveCardToApi (Err err) ->
            let
                debugLog =
                    Debug.log "Card Rest save one Error: " err
            in
                ( model, Cmd.none )

        SaveCardToApi (Ok item) ->
            let
                debugLog =
                    Debug.log "Card Rest save one Ok: " item

                cards_ =
                    model.cards
            in
                ( model, Cmd.none )

        SaveColumnToApi (Err err) ->
            let
                debugLog =
                    Debug.log "Card Rest save one Error: " err
            in
                ( model, Cmd.none )

        SaveColumnToApi (Ok item) ->
            let
                debugLog =
                    Debug.log "Card Rest save one Ok: " item

                cards_ =
                    model.columns
            in
                ( model, Cmd.none )

        UpdateColumnToApi (Err err) ->
            let
                debugLog =
                    Debug.log "Card Rest save one Error: " err
            in
                ( model, Cmd.none )

        UpdateColumnToApi (Ok item) ->
            let
                debugLog =
                    Debug.log "Card Rest save one Ok: " item

                cards_ =
                    model.columns
            in
                ( model, Cmd.none )

        FetchAllCards ->
            ( model, getCardsView session.auth )

        FetchAllColumns boardView ->
            ( model, getColumnsView session.auth boardView )

        AddCard card_ ->
            ( { model | card = Just card_ }, saveCardView session.auth card_ )


decodeCard : Json.Decode.Decoder BoardTask.CardView
decodeCard =
    Json.Decode.map7
        BoardTask.CardView
        (Json.Decode.field "uniqueNumber" Json.Decode.string)
        (Json.Decode.field "archiveStatus" Json.Decode.bool)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "description" Json.Decode.string)
        (Json.Decode.field "tableID" Json.Decode.int)
        (Json.Decode.field "color" Json.Decode.string)
        (Json.Decode.field "owner" Json.Decode.string)


decodeCards : Json.Decode.Decoder (List BoardTask.CardView)
decodeCards =
    Json.Decode.list decodeCard


decodeColumn : Json.Decode.Decoder BoardTask.ColumnView
decodeColumn =
    Json.Decode.map4
        BoardTask.ColumnView
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "tableTitle" Json.Decode.string)
        (Json.Decode.field "boardID" Json.Decode.int)
        (Json.Decode.field "tableDescription" Json.Decode.string)


decodeColumns : Json.Decode.Decoder (List BoardTask.ColumnView)
decodeColumns =
    Json.Decode.list decodeColumn


encodColumn : BoardTask.BoardView -> BoardTask.ColumnView -> Json.Encode.Value
encodColumn board column =
    let
        val =
            [ ( "tableDescription", Json.Encode.string column.tableDescription )
            , ( "tableTitle", Json.Encode.string column.tableTitle )
            , ( "boardID", Json.Encode.int board.id )
            ]
    in
        val
            |> Json.Encode.object


encodColumnFull : BoardTask.ColumnView -> Json.Encode.Value
encodColumnFull column =
    let
        val =
            [ ( "tableDescription", Json.Encode.string column.tableDescription )
            , ( "tableTitle", Json.Encode.string column.tableTitle )
            , ( "id", Json.Encode.int column.id )
            , ( "boardID", Json.Encode.int column.boardID )
            ]
    in
        val
            |> Json.Encode.object



--{ uniqueNumber : String, status : Bool, title : String, description : String, boardID : Int, columnID : Int }


getCardsView : Maybe BoardTask.AuthToken -> Cmd Msg
getCardsView token =
    let
        url =
            "http://0.0.0.0:8000/cards"

        header =
            case token of
                Nothing ->
                    []

                Just token_ ->
                    [ Http.header "Authorization" ("Token " ++ token_.token) ]

        request =
            Http.request
                { method = "GET"
                , headers = header
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson decodeCards
                , timeout = Nothing
                , withCredentials = False
                }

        -- req =
        --     Http.get url decodeCards
    in
        Http.send GetCardsFromApi request


getCardsVieColumnView : Maybe BoardTask.AuthToken -> BoardTask.ColumnView -> Cmd Msg
getCardsVieColumnView token column =
    let
        url =
            "http://localhost:8000/table/" ++ (toString column.id) ++ "cards"

        header =
            case token of
                Nothing ->
                    []

                Just token_ ->
                    [ Http.header "Authorization" ("Token " ++ token_.token) ]

        request =
            Http.request
                { method = "GET"
                , headers = header
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson decodeCards
                , timeout = Nothing
                , withCredentials = False
                }

        -- req =
        --     Http.get url decodeCardsaa
    in
        Http.send GetCardsFromApi request


getCardView : Maybe BoardTask.AuthToken -> String -> Cmd Msg
getCardView token identity =
    let
        url =
            "http://0.0.0.0:8000/card/" ++ identity

        header =
            case token of
                Nothing ->
                    []

                Just token_ ->
                    [ Http.header "Authorization" ("Token " ++ token_.token) ]

        request =
            Http.request
                { method = "GET"
                , headers = header
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson decodeCard
                , timeout = Nothing
                , withCredentials = False
                }

        -- req =
        --     Http.get url decodeCard
    in
        Http.send GetCardFromApi request


getColumnView : Maybe BoardTask.AuthToken -> String -> Cmd Msg
getColumnView token identity =
    let
        url =
            "http://0.0.0.0:8000/table/" ++ identity

        header =
            case token of
                Nothing ->
                    []

                Just token_ ->
                    [ Http.header "Authorization" ("Token " ++ token_.token) ]

        request =
            Http.request
                { method = "GET"
                , headers = header
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson decodeColumn
                , timeout = Nothing
                , withCredentials = False
                }

        -- req =
        --     Http.get url decodeColumn
    in
        Http.send GetColumnFromApi request


getColumnsView : Maybe BoardTask.AuthToken -> BoardTask.BoardView -> Cmd Msg
getColumnsView token boardView =
    let
        url =
            "http://0.0.0.0:8000/board/" ++ (toString boardView.id) ++ "/tables"

        header =
            case token of
                Nothing ->
                    []

                Just token_ ->
                    [ Http.header "Authorization" ("Token " ++ token_.token) ]

        request =
            Http.request
                { method = "GET"
                , headers = header
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectJson decodeColumns
                , timeout = Nothing
                , withCredentials = False
                }

        -- req =
        --     Http.get url decodeColumns
    in
        Http.send GetColumnsFromApi request


saveColumnView : Maybe BoardTask.AuthToken -> BoardTask.BoardView -> BoardTask.ColumnView -> Cmd Msg
saveColumnView token boardView columnView =
    let
        url =
            "http://0.0.0.0:8000/tables/"

        header =
            case token of
                Nothing ->
                    []

                Just token_ ->
                    [ Http.header "Authorization" ("Token " ++ token_.token) ]

        req =
            Http.request
                { body = (Http.jsonBody (encodColumn boardView columnView))
                , expect = Http.expectJson decodeColumn
                , headers = header
                , method = "POST"
                , timeout = Nothing
                , url = url
                , withCredentials = False
                }

        -- req =
        --     Http.post url (Http.jsonBody (encodBoardView board)) decodeBoard
    in
        Http.send SaveColumnToApi req


updateColumnView : Maybe BoardTask.AuthToken -> BoardTask.ColumnView -> Cmd Msg
updateColumnView token columnView =
    let
        url =
            "http://0.0.0.0:8000/tables/"

        header =
            case token of
                Nothing ->
                    []

                Just token_ ->
                    [ Http.header "Authorization" ("Token " ++ token_.token) ]

        req =
            Http.request
                { body = (Http.jsonBody (encodColumnFull columnView))
                , expect = Http.expectJson decodeColumn
                , headers = header
                , method = "PUT"
                , timeout = Nothing
                , url = url
                , withCredentials = False
                }

        -- req =
        --     Http.post url (Http.jsonBody (encodBoardView board)) decodeBoard
    in
        Http.send UpdateColumnToApi req


saveCardView : Maybe BoardTask.AuthToken -> BoardTask.CardView -> Cmd Msg
saveCardView token card =
    let
        debugLog =
            Debug.log "Card Rest save one Method" card

        url =
            "http://0.0.0.0:8000/cards/"

        header =
            case token of
                Nothing ->
                    []

                Just token_ ->
                    [ Http.header "Authorization" ("Token " ++ token_.token) ]

        req =
            Http.request
                { body = (Http.jsonBody (encodCardView card))
                , expect = Http.expectJson decodeCard
                , headers = header
                , method = "POST"
                , timeout = Nothing
                , url = url
                , withCredentials = False
                }
    in
        Http.send SaveCardToApi req


updateCardView : Maybe BoardTask.AuthToken -> BoardTask.CardView -> Cmd Msg
updateCardView token card =
    let
        debugLog =
            Debug.log "Card Rest save one Method" card

        url =
            "http://0.0.0.0:8000/cards/"

        header =
            case token of
                Nothing ->
                    []

                Just token_ ->
                    [ Http.header "Authorization" ("Token " ++ token_.token) ]

        req =
            Http.request
                { body = (Http.jsonBody (encodCardViewFull card))
                , expect = Http.expectJson decodeCard
                , headers = header
                , method = "PUT"
                , timeout = Nothing
                , url = url
                , withCredentials = False
                }
    in
        Http.send SaveCardToApi req


encodCardView : BoardTask.CardView -> Json.Encode.Value
encodCardView card =
    let
        val =
            [ ( "archiveStatus", Json.Encode.bool card.archiveStatus )
            , ( "title", Json.Encode.string card.title )
            , ( "description", Json.Encode.string card.description )
            , ( "tableID", Json.Encode.int card.tableID )
            , ( "color", Json.Encode.string card.color )
            ]
    in
        val
            |> Json.Encode.object


encodCardViewFull : BoardTask.CardView -> Json.Encode.Value
encodCardViewFull card =
    let
        val =
            [ ( "archiveStatus", Json.Encode.bool card.archiveStatus )
            , ( "title", Json.Encode.string card.title )
            , ( "uniqueNumber", Json.Encode.string card.uniqueNumber )
            , ( "description", Json.Encode.string card.description )
            , ( "tableID", Json.Encode.int card.tableID )
            , ( "color", Json.Encode.string card.color )
            ]
    in
        val
            |> Json.Encode.object



-- (Json.Decode.field "uniqueNumber" Json.Decode.string)
-- (Json.Decode.field "archiveStatus" Json.Decode.bool)
-- (Json.Decode.field "title" Json.Decode.string)
-- (Json.Decode.field "description" Json.Decode.string)
-- (Json.Decode.field "tableID" Json.Decode.int)
-- (Json.Decode.field "color" Json.Decode.string)
-- (Json.Decode.field "owner" Json.Decode.string)
