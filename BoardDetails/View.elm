module BoardDetails.View exposing (..)

import BoardDetails.Model exposing (Msg(..), Model, DialogAction(..))
import Html.Lazy
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Debug
import Dialog


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
    let
        currBoard =
            model.board

        boardName =
            case currBoard of
                Nothing ->
                    "Untitled"

                Just x ->
                    x.title
    in
        div []
            [ text boardName
            , viewColumns model
            , button
                [ class "btn btn-outline-info"
                , onClick (SetDialogAction BoardDetails.Model.AddNewColumn)
                ]
                [ text "Add Column" ]
            , Dialog.view
                (if model.showDialog then
                    Just (dialogConfig model)
                 else
                    Nothing
                )

            -- , viewDialog model
            ]


dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    { closeMessage = Just (SetDialogAction BoardDetails.Model.None)
    , containerClass = Nothing
    , header = Just (h3 [] [ text "List Name" ])
    , body = Just (input [ placeholder ("Enter name "), onInput SetNewColumndName ] [])
    , footer =
        Just
            (button
                [ class "btn btn-success"
                , onClick AddNewList
                ]
                [ text "OK" ]
            )
    }
