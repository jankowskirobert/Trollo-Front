module BoardDetails.View exposing (..)

import BoardDetails.Model exposing (Msg(..), Model, DialogAction(..))
import Html.Lazy
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Debug


-- import Column


getBoardColumn : BoardTask.ColumnView -> Model -> Html Msg
getBoardColumn column model =
    let
        rows =
            [ BoardTask.CardView "UNI1" True "TITLE1" "DESC1" 1 ]

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
    div [] []



-- Button.render Mdl
--     [ 1 ]
--     model.mdl
--     [ Button.raised, Dialog.openOn "click", Options.onClick (SetCardDialog column) ]
--     [ text "Add Card" ]


viewColumns : Model -> Html Msg
viewColumns model =
    let
        stored =
            model.columns

        -- storedCol =
        --     stored.data
    in
        stored
            |> List.map
                (\l ->
                    -- Html.map ColumnMsg
                    --     (Column.view l)
                    getBoardColumn
                        l
                        model
                )
            |> div [ class "main_board" ]



-- viewDialog : Model -> Html Msg
-- viewDialog model =
--     let
--         ( title, content, actions ) =
--             case model.dialogAction of
--                 AddNewCard ->
--                     d0 model
--                 AddNewColumn ->
--                     ( [ div [] [] ], [ div [] [] ], [ div [] [] ] )
--                 None ->
--                     ( [ div [] [] ], [ div [] [] ], [ div [] [] ] )
--     in
--         Dialog.view []
--             [ Dialog.title [] title
--             , Dialog.content [] content
--             , Dialog.actions [] actions
--             ]


view : Model -> Html Msg
view model =
    div []
        [ viewColumns model

        -- , viewDialog model
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
--             , Options.onClick AddToList
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
