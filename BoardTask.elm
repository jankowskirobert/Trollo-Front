module BoardTask exposing (ExampleData, getEmptyDataSet, decodeFromJson, getExampleSetOfData, putRandomElementToList)
import Json.Decode

-- STRUCTURE
type alias ExampleData = { userId : Int, id : Int, title : String, body : String}

-- EMPTY SET
getEmptyDataSet : ExampleData
getEmptyDataSet = 
    { userId = 0
    , id = 0
    , title = ""
    , body = ""
    }

decodeFromJson : Json.Decode.Decoder ExampleData
decodeFromJson = 
  Json.Decode.map4 ExampleData
   (Json.Decode.at ["userId"] Json.Decode.int)
   (Json.Decode.at ["id"] Json.Decode.int)
   (Json.Decode.at ["title"] Json.Decode.string)
   (Json.Decode.at ["body"] Json.Decode.string)

getExampleSetOfData : (List ExampleData)
getExampleSetOfData =
    [
        ExampleData 1 1 "Test1" "Test1",
        ExampleData 1 1 "Test2" "Test1",
        ExampleData 1 1 "Test3" "Test1",
        ExampleData 1 1 "Test4" "Test1"
    ]

putRandomElementToList : (List ExampleData)-> (List ExampleData)
putRandomElementToList lst =
   ( ExampleData 1 1 "Test1" "Test1") :: lst