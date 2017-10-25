import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Json.Encode as Encode
import Json.Decode
import Json.Decode.Pipeline as JDP exposing (required)
import Task
import Http

main =
  Html.program {view = view, update = update, subscriptions = subscriptions, init = init}

subscriptions : ExampleData -> Sub Msg
subscriptions model =
  Sub.none

init : (ExampleData, Cmd Msg)
init =
    ( ExampleData 1 1 "Empty" "Empty", Cmd.none )

getExampleData =
  let
    url = "https://jsonplaceholder.typicode.com/posts/1"
    req = Http.get url decodeThisData
  in
   Http.send Refresh req

type alias ExampleData = { userId : Int, id : Int, title : String, body : String}

decodeThisData : Json.Decode.Decoder ExampleData
decodeThisData = 
  Json.Decode.map4 ExampleData
   (Json.Decode.at ["userId"] Json.Decode.int)
   (Json.Decode.at ["id"] Json.Decode.int)
   (Json.Decode.at ["title"] Json.Decode.string)
   (Json.Decode.at ["body"] Json.Decode.string)

type Msg = Refresh (Result Http.Error ExampleData) | NewData


update : Msg -> ExampleData -> (ExampleData, Cmd Msg)
update msg model =
  case msg of
    NewData ->
      (model, getExampleData)
    Refresh (Ok newResponse) ->
      (newResponse, Cmd.none)
    Refresh (Err _) ->
      (model, Cmd.none)

-- view model =
--   div []
--     [ button [ onClick Decrement ] [ text "-" ]
--     , div [] [ text (toString model) ]
--     , button [ onClick Increment ] [ text "+" ]
--     ]

view : ExampleData -> Html Msg
view model =
  div []
    [ h2 [] [text model.title], button [ onClick NewData ] [ text "More Please!" ]]