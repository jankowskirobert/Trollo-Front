module BoardTask
    exposing
        ( CardView
        , AddCard
        , AddColumn
        , ColumnView
        , BoardView
        , getCardView
        , getExampleSetOfData
        , putElementToList
        , getExampleSetOfBoards
        , Msg
        , Model
        , model
        )

import Json.Decode
import Http

-- STRUCTURE


type alias Team =
    { teamId : Int, name : String }


type alias CardView =
    { uniqueNumber : String, status : Bool, title : String, description : String,  boardID : Int }


type alias ColumnView =
    { title : String, cards : List CardView }


type alias BoardView =
    { title : String, columns : List ColumnView }


type alias AddCard =
    { title : String, body : String }


type alias AddColumn =
    { title : String }


type alias AddBoard =
    { title : String, teams : List Team }

type alias Model =
    { cardFromRest : CardView
    }

model : Model
model = 
    {
        cardFromRest = CardView "UNI1" True "TITLE1" "DESC1" 1
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetInitialCard ->
            (model, getCardView "aa1fafe2-c4a5-11e7-b1df-3200105b0f20")
        GetCardFromApi (Ok card) ->
            ( {model | cardFromRest = card}, Cmd.none)
        GetCardFromApi (Err _) ->    
            ( model, Cmd.none )
            


decodeCardViewFromJson : Json.Decode.Decoder CardView
decodeCardViewFromJson =
    Json.Decode.map5 CardView
        (Json.Decode.at [ "uniqueNumber" ] Json.Decode.string)
        (Json.Decode.at [ "status" ] Json.Decode.bool)
        (Json.Decode.at [ "title" ] Json.Decode.string)
        (Json.Decode.at [ "description" ] Json.Decode.string)
        (Json.Decode.at [ "boardID" ] Json.Decode.int)


getExampleSetOfData : ColumnView
getExampleSetOfData =
    ColumnView "UUU"
        [ CardView "UNI1" True "TITLE1" "DESC1" 1
        , CardView "UNI1" True "TITLE1" "DESC1" 1
        , CardView "UNI1" True "TITLE1" "DESC1" 1
        , CardView "UNI1" True "TITLE1" "DESC1" 1
        ]


getExampleSetOfData2 : ColumnView
getExampleSetOfData2 =
    ColumnView "UUU2"
        [ CardView "UNI21" True "TITLE1" "DESC1" 1
        , CardView "UNI1" True "TITLE1" "DESC1" 1
        , CardView "UNI1" True "TITLE1" "DESC1" 1
        , CardView "UNI1" True "TITLE1" "DESC1" 1
        ]


getExampleSetOfBoards : List BoardView
getExampleSetOfBoards =
    [ BoardView "Board 1" [ getExampleSetOfData, getExampleSetOfData ], BoardView "Board 2" [ getExampleSetOfData2, getExampleSetOfData2 ] ]


putElementToList : String -> List CardView -> List CardView
putElementToList column lst =
    (CardView "UNI1" True "TITLE1" "DESC1" 1) :: lst


isListExist : List ColumnView -> String -> Bool
isListExist columns listname =
    List.member listname (List.map (\x -> x.title) columns)

type Msg = GetCardFromApi (Result Http.Error CardView) | GetInitialCard

getCardView : String -> Cmd Msg 
getCardView cardId =
   let
     url = "https://127.0.0.1/card/"++cardId
     req = Http.get url decodeCardViewFromJson
   in
 Http.send GetCardFromApi req

getColumnView : Cmd Msg 
getColumnView =
   let
     url = "https://jsonplaceholder.typicode.com/posts/1"
     req = Http.get url decodeCardViewFromJson
   in
 Http.send GetCardFromApi req

getBoardView : Cmd Msg 
getBoardView =
   let
     url = "https://jsonplaceholder.typicode.com/posts/1"
     req = Http.get url decodeCardViewFromJson
   in
 Http.send GetCardFromApi req

--  getCardList : 