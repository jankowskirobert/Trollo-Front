module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Material.Dialog as Dialog
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options
import Material


-- import Json.Encode as Encode
-- import Json.Decode
-- import Json.Decode.Pipeline as JDP exposing (required)
-- import Task

import Http


main : Program Never Model Msg
main =
    Html.program { view = view, update = update, subscriptions = subscriptions, init = init }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


initModel : Model
initModel =
    { mdl = Material.model
    , data = BoardTask.getExampleSetOfData
    , addCard = BoardTask.AddCard "" ""
    , dialogAction = None
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- getExampleData : Cmd Msg
-- getExampleData =
--   let
--     url = "https://jsonplaceholder.typicode.com/posts/1"
--     req = Http.get url BoardTask.decodeFromJson
--   in
--    Http.send Refresh req
--  Refresh (Result Http.Error BoardTask.ExampleData) |


type Msg
    = NewData
    | AddToList
    | SetTitle String
    | SetColumn String
    | SetCardDialog
    | SetColumnDialog
    | Acknowledge
    | Mdl (Material.Msg Msg)


type DialogAction
    = AddNewCard
    | AddNewColumn
    | None


type alias Model =
    { mdl : Material.Model
    , data : List BoardTask.CardView
    , addCard : BoardTask.AddCard
    , dialogAction : DialogAction
    }



-- dialogBuilder : Model -> Html Msg -> Html Msg -> Html Msg
-- dialogBuilder model =
--     Dialog.view
--         [ Options.id "TEST"
--         ]
--         [ Dialog.title [] [ text "Add new card" ]
--         , Dialog.content []
--             [ content
--             ]
--         , Dialog.actions
--             []
--             [ dialogActions ]
--         ]


element : Model -> Html Msg
element model =
    div []
        [ Dialog.view []
            [ Dialog.title [] [ text "Add new card" ]
            , Dialog.content []
                [ Textfield.render Mdl
                    [ 2 ]
                    model.mdl
                    [ Textfield.label "Title"
                    , Textfield.floatingLabel
                    , Textfield.text_
                    , Options.onInput SetTitle
                    ]
                    []
                ]
            , Dialog.actions []
                [ Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.colored
                    , Button.raised
                    , Dialog.closeOn "click"
                    , Options.onClick AddToList
                    ]
                    [ text "Submit" ]
                , Button.render Mdl
                    [ 1 ]
                    model.mdl
                    [ Dialog.closeOn "click" ]
                    [ text "Cancel" ]
                ]
            ]
        , Dialog.view
            []
            [ Dialog.title [] [ text "Add new Column" ]
            , Dialog.content []
                [ Textfield.render Mdl
                    [ 2 ]
                    model.mdl
                    [ Textfield.label "Title"
                    , Textfield.floatingLabel
                    , Textfield.text_
                    ]
                    []
                ]
            , Dialog.actions []
                [ Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.colored
                    , Button.raised
                    , Dialog.closeOn "click"
                    ]
                    [ text "Submit" ]
                , Button.render Mdl
                    [ 1 ]
                    model.mdl
                    [ Dialog.closeOn "click" ]
                    [ text "Cancel" ]
                ]
            ]
        , Dialog.view
            []
            [ Dialog.title [] [ text "ERROR!" ]
            , Dialog.content []
                []
            , Dialog.actions []
                [ Button.render Mdl
                    [ 1 ]
                    model.mdl
                    [ Dialog.closeOn "click" ]
                    [ text "Cancel" ]
                ]
            ]
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Acknowledge ->
            ( model, Cmd.none )

        NewData ->
            ( model, Cmd.none )

        AddToList ->
            ( { model | data = BoardTask.putCardElementToList model.addCard model.data }, Cmd.none )

        SetTitle title_ ->
            let
                cardTitle =
                    model.addCard
            in
                ( { model | addCard = { cardTitle | title = title_ }, dialogAction = AddNewCard }, Cmd.none )

        SetColumn title_ ->
            let
                cardTitle =
                    model.addCard
            in
                ( { model | dialogAction = AddNewColumn }, Cmd.none )

        SetCardDialog ->
            ( { model | dialogAction = AddNewCard }, Cmd.none )

        SetColumnDialog ->
            ( { model | dialogAction = AddNewColumn }, Cmd.none )

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
                |> List.map (\l -> getColumnCard l.title)
                |> div []
    in
        div [ class "main_board" ]
            [ section [ class "list" ]
                [ div [] [ header [] [ text columnName ] ]
                , rendered
                , Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.raised, Dialog.openOn "click", Options.onClick SetCardDialog ]
                    [ text "Add Card" ]
                , Button.render Mdl
                    [ 1 ]
                    model.mdl
                    [ Button.raised, Dialog.openOn "click", Options.onClick SetColumnDialog ]
                    [ text "Add Card 2" ]

                -- getAddNewCardButton
                ]
            ]


getColumnCard : String -> Html Msg
getColumnCard cardName =
    article [ class "card" ] [ header [] [ text cardName ] ]



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
    div []
        [ getBoardColumn "UUU" model
        , let
            ( title, content, actions ) =
                case model.dialogAction of
                    AddNewCard ->
                        d0 model

                    AddNewColumn ->
                        d1 model

                    None ->
                        d2 model
          in
            Dialog.view []
                [ Dialog.title [] title
                , Dialog.content [] content
                , Dialog.actions [] actions
                ]
        ]


d0 : Model -> ( List (Html Msg), List (Html Msg), List (Html Msg) )
d0 model =
    ( [ text "Hello!" ]
    , [ text "D0" ]
    , [ Button.render Mdl
            [ 3 ]
            model.mdl
            [ Dialog.closeOn "click" ]
            [ text "Close" ]
      ]
    )


d1 : Model -> ( List (Html Msg), List (Html Msg), List (Html Msg) )
d1 model =
    ( [ text "Hello!" ]
    , [ text "D1" ]
    , [ Button.render Mdl
            [ 3 ]
            model.mdl
            [ Dialog.closeOn "click" ]
            [ text "Close" ]
      ]
    )


d2 : Model -> ( List (Html Msg), List (Html Msg), List (Html Msg) )
d2 model =
    ( [ text "Hello!" ]
    , [ text "D2" ]
    , [ Button.render Mdl
            [ 3 ]
            model.mdl
            [ Dialog.closeOn "click" ]
            [ text "Close" ]
      ]
    )



-- div [ class "main_board" ]
--   [ section [ class "list" ] [text model.title], button [ onClick boardMessage ] [ text "More Please!" ]]
