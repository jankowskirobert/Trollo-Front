module BoardTask exposing (CardView, AddCard, putCardElementToList, getEmptyDataSet, decodeFromJson, getExampleSetOfData, putRandomElementToList, putElementToList)

import Json.Decode


-- STRUCTURE


type alias CardView =
    { userId : Int, id : Int, title : String, body : String }


type alias AddCard =
    { title : String, body : String }



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


getExampleSetOfData : List CardView
getExampleSetOfData =
    [ CardView 1 1 "Test1" "Test1"
    , CardView 1 1 "Test2" "Test1"
    , CardView 1 1 "Test3" "Test1"
    , CardView 1 1 "Test4" "Test1"
    ]


putRandomElementToList : List CardView -> List CardView
putRandomElementToList lst =
    (CardView 1 1 "Test1" "Test1") :: lst


putElementToList : String -> List CardView -> List CardView
putElementToList column lst =
    (CardView 1 1 column "Test1") :: lst


putCardElementToList : AddCard -> List CardView -> List CardView
putCardElementToList card lst =
    (CardView 1 1 card.title card.body) :: lst
