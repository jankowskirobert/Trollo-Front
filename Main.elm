import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
-- import Json.Encode as Encode
-- import Json.Decode
-- import Json.Decode.Pipeline as JDP exposing (required)
-- import Task
import Http

main : Program Never (List BoardTask.ExampleData) Msg
main =
  Html.program {view = view, update = update, subscriptions = subscriptions, init = init}

subscriptions :  List BoardTask.ExampleData -> Sub Msg
subscriptions model =
  Sub.none

init : ( (List BoardTask.ExampleData), Cmd Msg)
init = 
    ( BoardTask.getExampleSetOfData , Cmd.none )
    
-- getExampleData : Cmd Msg
-- getExampleData =
--   let
--     url = "https://jsonplaceholder.typicode.com/posts/1"
--     req = Http.get url BoardTask.decodeFromJson
--   in
--    Http.send Refresh req
--  Refresh (Result Http.Error BoardTask.ExampleData) | 
type Msg = NewData | AddToList

-- UPDATE
update : Msg -> (List BoardTask.ExampleData) -> ((List BoardTask.ExampleData), Cmd Msg)
update msg model =
  case msg of
    NewData ->
      (model, Cmd.none)
    AddToList ->
      (BoardTask.putRandomElementToList model, Cmd.none)
    -- Refresh (Ok newResponse) ->
    --   (newResponse, Cmd.none)
    -- Refresh (Err _) ->
    --   (model, Cmd.none)

-- view model =
--   div []
--     [ button [ onClick Decrement ] [ text "-" ]
--     , div [] [ text (toString model) ]
--     , button [ onClick Increment ] [ text "+" ]
--     ]
--  <article class="card">
--         <header>Drag and Drop CSS</header>
--         <div class="detail">1/2</div>
--       </article>
getBoardColumn : String -> (List BoardTask.ExampleData) -> Html Msg
getBoardColumn columnName listOfTask =
  let
    rendered = 
    listOfTask
      |> List.map (\l -> getColumnCard l.title )
      |> div []
  in
    div [ class "main_board" ]
        [ section [ class "list" ] 
          [
                div [] [header [] [ text columnName ] ],
                rendered,
                (getAddNewCardButton )
          ]
        ]

getColumnCard : String -> Html Msg
getColumnCard cardName = 
  article [ class "card" ] [header [] [ text cardName ] ]

getAddNewCardButton : Html Msg
getAddNewCardButton =
  button [ onClick AddToList ] [ text "Add Card" ]

-- VIEW
view : List BoardTask.ExampleData -> Html Msg
view model =
    getBoardColumn "UUU" model
    -- div [ class "main_board" ]
    --   [ section [ class "list" ] [text model.title], button [ onClick boardMessage ] [ text "More Please!" ]]