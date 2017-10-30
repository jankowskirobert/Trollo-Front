import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Material.Dialog as Dialog 
import Material.Button as Button
import Material
-- import Json.Encode as Encode
-- import Json.Decode
-- import Json.Decode.Pipeline as JDP exposing (required)
-- import Task
import Http

main : Program Never Model Msg
main =
  Html.program {view = view, update = update, subscriptions = subscriptions, init = init}

subscriptions :  Model -> Sub Msg
subscriptions model =
  Sub.none

initModel : Model
initModel =
  { mdl = Material.model,
  data = BoardTask.getExampleSetOfData
  }

init : ( Model, Cmd Msg)
init = 
    ( initModel , Cmd.none )
    
-- getExampleData : Cmd Msg
-- getExampleData =
--   let
--     url = "https://jsonplaceholder.typicode.com/posts/1"
--     req = Http.get url BoardTask.decodeFromJson
--   in
--    Http.send Refresh req
--  Refresh (Result Http.Error BoardTask.ExampleData) | 
type Msg = NewData | AddToList | Acknowledge | Mdl (Material.Msg Msg)

type alias Model =
  { 
     mdl : Material.Model,
     data : List BoardTask.ExampleData
  }

element : Model -> Html Msg
element model = 
  Dialog.view
    [ ]
    [ Dialog.title [] [ text "Greetings" ]
    , Dialog.content [] 
        [ p [] [ text "A strange game—the only winning move is not to play." ]
        , p [] [ text "How about a nice game of chess?" ] 
        ]
    , Dialog.actions [ ]
      [ Button.render Mdl [0] model.mdl
          [ Dialog.closeOn "click" ]
          [ text "Chess" ]
      , Button.render Mdl [1] model.mdl
          [ Button.disabled ]
          [ text "GTNW" ]
      ]
    ]

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Acknowledge ->
      (model , Cmd.none)
    NewData ->
      (model, Cmd.none)
    AddToList ->
      ({model | data = BoardTask.putRandomElementToList model.data}, Cmd.none)
    Mdl action_ ->
      Material.update Mdl action_ model
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
getBoardColumn : String -> Model -> Html Msg
getBoardColumn columnName model =
  let
    rendered = 
    model.data
      |> List.map (\l -> getColumnCard l.title )
      |> div []
  in
    div [ class "main_board" ]
        [ section [ class "list" ] 
          [
                div [] [header [] [ text columnName ] ],
                rendered,
                element model,
                Button.render Mdl [1] model.mdl
      [ Dialog.openOn "click" ] 
      [ text "Open dialog" ]
                -- getAddNewCardButton 
                        
        
          ]
        ]

getColumnCard : String -> Html Msg
getColumnCard cardName = 
  article [ class "card" ] [header [] [ text cardName ] ]

-- getAddNewCardButton : Html Msg
-- getAddNewCardButton =  
--   button [ Dialog. ] [ text "Add Card" ]

-- <div class="modal fade" id="myModal" role="dialog">
--     <div class="modal-dialog modal-sm">
--       <div class="modal-content">
--         <div class="modal-header">
--           <button type="button" class="close" data-dismiss="modal">&times;</button>
--           <h4 class="modal-title">Modal Header</h4>
--         </div>
--         <div class="modal-body">
--           <p>This is a small modal.</p>
--         </div>
--         <div class="modal-footer">
--           <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
--         </div>
--       </div>
--     </div>
--   </div>

-- VIEW
view : Model -> Html Msg
view model =
    getBoardColumn "UUU" model
    -- div [ class "main_board" ]
    --   [ section [ class "list" ] [text model.title], button [ onClick boardMessage ] [ text "More Please!" ]]