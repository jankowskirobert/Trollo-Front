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
    , comments : List BoardTask.ComentView
    , comment : Maybe BoardTask.ComentView
    }


model : Model
model =
    { cards = []
    , card = Maybe.Nothing
    , comments = []
    , comment = Maybe.Nothing
    }


type Msg
    = GetCardsFromApi (Result Http.Error (List BoardTask.CardView))
    | GetCardFromApi (Result Http.Error BoardTask.CardView)
    | SaveCardToApi (Result Http.Error BoardTask.CardView)
    | AddCard BoardTask.CardView


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Card Rest" msg of
        GetCardsFromApi (Err err) ->
            ( model, Cmd.none )

        GetCardsFromApi (Ok item) ->
            ( model, Cmd.none )

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
                ( { model | card = Just item, cards = cards_ ++ [ item ] }, Cmd.none )

        AddCard card_ ->
            ( { model | card = Just card_ }, saveCardView card_ )


decodeCard : Json.Decode.Decoder BoardTask.CardView
decodeCard =
    Json.Decode.map6
        BoardTask.CardView
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "status" Json.Decode.string)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "description" Json.Decode.string)
        (Json.Decode.field "boardId" Json.Decode.int)
        (Json.Decode.field "columnId" Json.Decode.int)


decodeCards : Json.Decode.Decoder (List BoardTask.CardView)
decodeCards =
    Json.Decode.list decodeCard



--{ uniqueNumber : String, status : Bool, title : String, description : String, boardID : Int, columnID : Int }


getCardsView : Cmd Msg
getCardsView =
    let
        url =
            "http://localhost:8000/cards"

        req =
            Http.get url decodeCards
    in
        Http.send GetCardsFromApi req


getCardView : String -> Cmd Msg
getCardView identity =
    let
        url =
            "http://localhost:8000/cards/" ++ identity

        req =
            Http.get url decodeCard
    in
        Http.send GetCardFromApi req


saveCardView : BoardTask.CardView -> Cmd Msg
saveCardView card =
    let
        debugLog =
            Debug.log "Card Rest save one Method" card

        url =
            "http://localhost:8000/cards"

        -- req =
        req =
            Http.post url (Http.jsonBody (encodCardView card)) decodeCard

        debugLog2 =
            Debug.log "Card Rest save one Method2" req
    in
        Http.send SaveCardToApi req


encodCardView : BoardTask.CardView -> Json.Encode.Value
encodCardView card =
    let
        val =
            [ ( "status", Json.Encode.string card.status )
            , ( "title", Json.Encode.string card.title )
            , ( "description", Json.Encode.string card.description )
            , ( "boardId", Json.Encode.int card.boardId )
            , ( "columnId", Json.Encode.int card.columnId )
            ]
    in
        val
            |> Json.Encode.object
