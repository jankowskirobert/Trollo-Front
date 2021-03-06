module BoardTask
    exposing
        ( CardView
        , AddCard
        , AddColumn
        , ColumnView
        , BoardView
        , getExampleSetOfData
        , getColumnsForBoard
        , Msg
        , User
        , model
        , CommentView
        , AuthToken
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
    { uniqueNumber : String, archiveStatus : Bool, title : String, description : String, tableID : Int, color : String, owner : String }


type alias ColumnView =
    { id : Int, tableTitle : String, boardID : Int, tableDescription : String }


type alias BoardView =
    { id : Int, boardTitle : String, boardDescription : String, public_access : Bool, owner : String }


type alias CommentView =
    { id : Int
    , body : String
    , added : Date.Date
    , cardId : String
    }


type alias AuthToken =
    { token : String
    }


type alias AddCard =
    { title : String, body : String }


type alias AddColumn =
    { title : String }


type alias AddBoard =
    { title : String, teams : List Team }


type alias User =
    { status : Bool
    , auth : Maybe AuthToken
    }


model : User
model =
    { status = False
    , auth = Maybe.Nothing
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


isListExist : List ColumnView -> String -> Bool
isListExist columns listname =
    List.member listname (List.map (\x -> x.tableTitle) columns)


type Msg
    = GetCardFromApi (Result Http.Error CardView)
    | GetInitialCard
