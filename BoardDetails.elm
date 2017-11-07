module BoardDetails exposing (Model, model, view, update, Msg)

import Html.Lazy
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Debug
import Material


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


model : Model
model =
    { data = BoardTask.BoardView "" []
    , addCard = BoardTask.AddCard "" ""
    , addColumn = BoardTask.AddColumn ""
    , dialogAction = None
    , mdl = Material.model
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


type Msg
    = AddToList
    | SetCardDialog BoardTask.ColumnView
    | SetColumnDialog
    | Mdl (Material.Msg Msg)


type DialogAction
    = AddNewCard
    | AddNewColumn
    | None


type alias Model =
    { data : BoardTask.BoardView
    , addCard : BoardTask.AddCard
    , addColumn : BoardTask.AddColumn
    , dialogAction : DialogAction
    , mdl : Material.Model
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
-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddToList ->
            -- let
            -- view_ =
            --     model.activeColumnView
            -- cards_ =
            --     view_.cards
            -- isInBoard =
            --     cards_
            --         ++ [ (BoardTask.CardView 1 1 "column" "Test1") ]
            -- in
            -- if addcard.title /= "" then
            --     ( { model | data = BoardTask.putCardElementToList model.addCard column_, addCard = BoardTask.AddCard "" "" }, Cmd.none )
            -- else
            ( model, Cmd.none )

        SetCardDialog columView_ ->
            ( { model | dialogAction = AddNewCard }, Cmd.none )

        SetColumnDialog ->
            ( { model | dialogAction = AddNewColumn }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model



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


getBoardColumn : BoardTask.ColumnView -> Model -> Html Msg
getBoardColumn column model =
    let
        rows =
            column.cards

        rendered_ =
            rows
                |> List.map (\l -> getColumnCard l)
                |> div []
    in
        div []
            [ section [ class "list" ]
                [ div [] [ header [] [ text column.title ] ]
                , rendered_
                , viewButton 0 model column
                ]
            ]


getColumnCard : BoardTask.CardView -> Html Msg
getColumnCard card =
    article [ class "card" ] [ header [] [ text card.title ] ]



-- view : Model -> Html Msg
-- view =
--     Html.Lazy.lazy view_


viewButton : Int -> Model -> BoardTask.ColumnView -> Html Msg
viewButton idx model column =
    button [ onClick SetColumnDialog ]
        [ text ("Add Card #" ++ toString idx) ]


viewColumns : Model -> Html Msg
viewColumns model =
    let
        data_ =
            model.data

        columns_ =
            data_.columns
    in
        columns_
            |> List.map
                (\l ->
                    getBoardColumn l model
                )
            |> div [ class "main_board" ]


viewDialog : Model -> Html Msg
viewDialog model =
    let
        ( title, content, actions ) =
            case model.dialogAction of
                AddNewCard ->
                    ( "", "", "" )

                AddNewColumn ->
                    ( "", "", "" )

                None ->
                    ( "", "", "" )
    in
        div [] []



-- Dialog.view []
--     [ Dialog.title [] title
--     , Dialog.content [] content
--     , Dialog.actions [] actions
--     ]


view : Model -> Html Msg
view model =
    div []
        [ viewColumns model
        , viewDialog model

        -- , Button.render Mdl
        --     [ 1 ]
        --     model.mdl
        --     [ Button.raised, Dialog.openOn "click", Options.onClick SetColumnDialog ]
        --     [ text "Add Column" ]
        ]



-- d0 : Model -> ( List (Html Msg), List (Html Msg), List (Html Msg) )
-- d0 model =
--     ( [ text "Add New Card" ]
--     , [ Textfield.render Mdl
--             [ 2 ]
--             model.mdl
--             [ Textfield.label "Title"
--             , Textfield.floatingLabel
--             ]
--             [ text "Close" ]
--       ]
--     , [ Button.render Mdl
--             [ 0 ]
--             model.mdl
--             [ Dialog.closeOn "click"
--             ]
--             [ text "Close" ]
--       , Button.render Mdl
--             [ 1 ]
--             model.mdl
--             [ Button.colored
--             , Button.raised
--             , Dialog.closeOn "click"
--             ]
--             [ text "Submit" ]
--       ]
--     )
-- -- title, content, actions
-- d1 : Model -> ( List (Html Msg), List (Html Msg), List (Html Msg) )
-- d1 model =
--     ( [ text "Hello!" ]
--     , [ text "D1" ]
--     , [ Button.render Mdl
--             [ 0 ]
--             model.mdl
--             [ Dialog.closeOn "click" ]
--             [ text "Close" ]
--       , Button.render Mdl
--             [ 3 ]
--             model.mdl
--             [ Button.colored
--             , Button.raised
--             , Dialog.closeOn "click"
--             ]
--             [ text "Submit" ]
--       ]
--     )
-- d2 : Model -> ( List (Html Msg), List (Html Msg), List (Html Msg) )
-- d2 model =
--     ( [ text "Hello!" ]
--     , [ text "D2" ]
--     , [ Button.render Mdl
--             [ 0 ]
--             model.mdl
--             [ Dialog.closeOn "click" ]
--             [ text "Close" ]
--       ]
--     )
-- div [ class "main_board" ]
--   [ section [ class "list" ] [text model.title], button [ onClick boardMessage ] [ text "More Please!" ]]
