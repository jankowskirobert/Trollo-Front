module BoardTask
    exposing
        ( CardView
        , AddCard
        , AddColumn
        , ColumnView
        , BoardView
        , getExampleSetOfData
        , getExampleSetOfBoards
        , getColumnsForBoard
        , Msg
        , User
        , model
        , CommentView
        )

import Json.Decode
import Json.Decode.Pipeline
import Http
import Array
import Tuple
import Date


-- STRUCTURE


type alias Team =
    { teamId : Int, name : String }


type alias CardView =
    { id : Int, status : String, title : String, description : String, boardId : Int, columnId : Int }


type alias ColumnView =
    { id : Int, title : String, boardID : Int, tableDescription : String }


type alias BoardView =
    { id : Int, boardTitle : String, boardDescription : String }


type alias CommentView =
    { id : Int
    , body : String
    , added : Date.Date
    , cardId : String
    }


type alias AddCard =
    { title : String, body : String }


type alias AddColumn =
    { title : String }


type alias AddBoard =
    { title : String, teams : List Team }


type alias User =
    { status : Bool
    }


model : User
model =
    { status = False
    }



-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
--     case msg of
--         GetInitialCard ->
--             ( model, getCardView "aa1fafe2-c4a5-11e7-b1df-3200105b0f20" )
--         GetCardFromApi (Ok card) ->
--             ( { model | cardFromRest = card }, Cmd.none )
--         GetCardFromApi (Err _) ->
--             ( model, Cmd.none )


getExampleSetOfData : ColumnView
getExampleSetOfData =
    ColumnView 1 "UUU" 1 "QQS"


getExampleSetOfColumns : List ColumnView
getExampleSetOfColumns =
    []


getColumnsForBoard : Int -> List ColumnView
getColumnsForBoard boardId =
    List.filter (\x -> (x.boardID == boardId)) getExampleSetOfColumns


getExampleSetOfBoards : List BoardView
getExampleSetOfBoards =
    [ BoardView 1 "Board 1" "", BoardView 2 "Board 2" "" ]


indicesOf : a -> List a -> List Int
indicesOf thing things =
    things
        |> List.indexedMap (,)
        |> List.filter (\( idx, item ) -> item == thing)
        |> List.map Tuple.first


firstIndexOf : a -> List a -> Int
firstIndexOf thing things =
    indicesOf thing things
        |> List.minimum
        |> Maybe.withDefault -1


getBoards : User -> List BoardView
getBoards user =
    getExampleSetOfBoards


isListExist : List ColumnView -> String -> Bool
isListExist columns listname =
    List.member listname (List.map (\x -> x.title) columns)


type Msg
    = GetCardFromApi (Result Http.Error CardView)
    | GetInitialCard
