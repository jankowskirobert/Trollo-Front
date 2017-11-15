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
        cards_ =
            model.card

        rows =
            getCardsForColumn column.id cards_

        rendered_ =
            rows
                |> List.indexedMap (\index l -> getColumnCard index l)
                |> div []
    in
        div []
            [ section [ class "list" ]
                [ div [] [ header [] [ text column.title ] ]
                , rendered_
                , viewButton 0 model column
                ]
            ]


getColumnCard : Int -> BoardTask.CardView -> Html Msg
getColumnCard indexOnList card =
    article [ class "card" ]
        [ div
            []
            [ header [] [ text card.title ]
            , button
                [ class "btn btn-outline-info"
                , onClick (SetDialogAction (BoardDetails.Model.ShowCardDetail card))
                ]
                [ text "View Details" ]
            , button
                [ class "btn btn-outline-info"
                , onClick (SetDialogAction (BoardDetails.Model.EditCardDetail indexOnList card))
                ]
                [ text "Edit Details" ]
            ]
        ]



-- view : Model -> Html Msg
-- view =
--     Html.Lazy.lazy view_


viewButton : Int -> Model -> BoardTask.ColumnView -> Html Msg
viewButton idx model column =
    div []
        [ button
            [ class "btn btn-outline-info"

            -- , onClick (SetDialogAction (BoardDetails.Model.ShowCardDetail card))
            ]
            [ text "Add Card" ]
        ]


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


getCardsForColumn : Int -> List (Maybe BoardTask.CardView) -> List BoardTask.CardView
getCardsForColumn columnId list =
    let
        hasAnything =
            List.filter
                (\x ->
                    case x of
                        Nothing ->
                            False

                        Just t ->
                            (t.columnID == columnId)
                )
                list

        onlyHasRealValues =
            List.filterMap (\x -> x) hasAnything
    in
        onlyHasRealValues


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
    case model.dialogAction of
        AddNewColumn ->
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

        ShowCardDetail _ ->
            case model.currentCard of
                Nothing ->
                    dialogConfigErrorMsg

                Just card_ ->
                    { closeMessage = Just (SetDialogAction BoardDetails.Model.None)
                    , containerClass = Nothing
                    , header = Just (h3 [] [ text "Show Card Details" ])
                    , body = Just (div [] [ text card_.title, text card_.description ])
                    , footer =
                        Just
                            (button
                                [ class "btn btn-success"
                                , onClick (SetDialogAction BoardDetails.Model.None)
                                ]
                                [ text "OK" ]
                            )
                    }

        EditCardDetail _ _ ->
            case ( model.currentCard, model.currentCardIndex ) of
                ( Nothing, Nothing ) ->
                    dialogConfigErrorMsg

                ( Nothing, Just x ) ->
                    dialogConfigErrorMsg

                ( Just x, Nothing ) ->
                    dialogConfigErrorMsg

                ( Just card_, Just idx_ ) ->
                    { closeMessage = Just (SetDialogAction BoardDetails.Model.None)
                    , containerClass = Nothing
                    , header = Just (h3 [] [ text "Edit Card Details" ])
                    , body = Just (div [] [ div [] [ input [ placeholder ("Enter name "), onInput SetNewCardName ] [] ], div [] [] ])
                    , footer =
                        Just
                            (button
                                [ class "btn btn-success"
                                , onClick UpdateCurrentCard
                                ]
                                [ text "OK" ]
                            )
                    }

        None ->
            dialogConfigErrorMsg


dialogConfigErrorMsg : Dialog.Config Msg
dialogConfigErrorMsg =
    { closeMessage = Just (SetDialogAction BoardDetails.Model.None)
    , containerClass = Nothing
    , header = Just (h3 [] [ text "ERROR!" ])
    , body = Just (text "Board not found")
    , footer =
        Just
            (button
                [ class "btn btn-success"
                , onClick (SetDialogAction BoardDetails.Model.None)
                ]
                [ text "OK" ]
            )
    }
