module BoardTask
    exposing
        ( CardView
        , AddCard
        , AddColumn
        , ColumnView
        , BoardView
        , putCardElementToList
        , getEmptyDataSet
        , decodeFromJson
        , getExampleSetOfData
        , putElementToList
        )

import Json.Decode


-- STRUCTURE


type alias Team =
    { teamId : Int, name : String }


type alias CardView =
    { userId : Int, id : Int, title : String, body : String }


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



-- EMPTY SET


getEmptyDataSet : CardView
getEmptyDataSet =
    { userId = 0
    , id = 0
    , title = ""
    , body = ""
    }


decodeFromJson : Json.Decode.Decoder CardView
decodeFromJson =
    Json.Decode.map4 CardView
        (Json.Decode.at [ "userId" ] Json.Decode.int)
        (Json.Decode.at [ "id" ] Json.Decode.int)
        (Json.Decode.at [ "title" ] Json.Decode.string)
        (Json.Decode.at [ "body" ] Json.Decode.string)


getExampleSetOfData : ColumnView
getExampleSetOfData =
    ColumnView "UUU"
        [ CardView 1 1 "Test1" "Test1"
        , CardView 1 1 "Test2" "Test1"
        , CardView 1 1 "Test3" "Test1"
        , CardView 1 1 "Test4" "Test1"
        ]


putElementToList : String -> List CardView -> List CardView
putElementToList column lst =
    (CardView 1 1 column "Test1") :: lst


putCardElementToList : AddCard -> ColumnView -> ColumnView
putCardElementToList card columns =
    let
        cards =
            columns.cards
    in
        ({ columns | cards = cards ++ [ CardView 1 1 card.title card.body ] })
