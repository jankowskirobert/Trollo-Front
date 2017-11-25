module BoardDetails.View exposing (..)

import BoardDetails.Model exposing (Msg(..), Model, DialogAction(..))
import Html.Lazy
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Debug
import Dialog
import BoardDetails.Card.Edit as CardEdit


-- import Column


getBoardColumn : BoardTask.ColumnView -> Model -> Html Msg
getBoardColumn column model =
    let
        cards_ =
            case model.card of
                Nothing ->
                    []

                Just list ->
                    getCardsForColumn column.id list

        rendered_ =
            cards_
                |> List.map (\( index, l ) -> getColumnCard index l)
                |> div [ detailsStyle ]
    in
        div []
            [ section [ class "list", detailsStyleCol ]
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
                [ listDetailsButtonStyle
                , onClick (SetDialogAction (BoardDetails.Model.ShowCardDetail card))
                ]
                [ text "View Details" ]
            , button
                [ listDetailsButtonStyle
                , onClick (BoardDetails.Model.CardMsg (CardEdit.EditCardDetail indexOnList card))
                ]
                [ text "Edit Details" ]
            ]
        ]


detailsStyleCol : Attribute msg
detailsStyleCol =
    style
        [ ( "backgroundColor", "#3D88BF" )
        , ( "color", "white" )
        ]


detailsStyle =
    style
        [ ( "backgroundColor", "#3D88BF" )
        , ( "color", "black" )
        ]



-- view : Model -> Html Msg
-- view =
--     Html.Lazy.lazy view_


viewButton : Int -> Model -> BoardTask.ColumnView -> Html Msg
viewButton idx model column =
    div []
        [ button
            [ listDetailsButtonStyle
            , onClick (SetDialogAction (BoardDetails.Model.AddCard column))
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


getCardsForColumn : Int -> List BoardTask.CardView -> List ( Int, BoardTask.CardView )
getCardsForColumn columnId list =
    let
        maped =
            List.indexedMap (\idx ele -> ( idx, ele )) list

        hasAnything =
            List.filter
                (\( x, y ) ->
                    y.columnID == columnId
                )
                maped
    in
        hasAnything


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
                    x.boardTitle
    in
        div [ boardTextStyle ]
            [ text boardName
            , viewColumns model
            , button
                [ addColumnStyle
                , onClick (SetDialogAction BoardDetails.Model.AddNewColumn)
                ]
                [ text "Add Column" ]
            , Dialog.view
                (if model.showDialog then
                    Just (dialogConfig model)
                 else
                    Nothing
                )
            , Html.map CardMsg (CardEdit.view model.cardModel)

            -- , viewDialog model
            ]


boardTextStyle : Attribute msg
boardTextStyle =
    style
        [ ( "font-size", "24px" )
        , ( "padding-left", "10px" )
        , ( "padding-top", "20px" )
        ]


addColumnStyle : Attribute msg
addColumnStyle =
    style
        [ ( "color", "white" )
        , ( "backgroundColor", "#166494" )
        , ( "font-size", "20" )
        , ( "border", "none" )
        , ( "overflow", "hidden" )
        , ( "outline", "none" )
        , ( "height", "36px" )
        , ( "padding-left", "10px" )
        , ( "webkit-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "moz-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        ]


listDetailsButtonStyle : Attribute msg
listDetailsButtonStyle =
    style
        [ ( "color", "#646464" )
        , ( "backgroundColor", "#E3EBEE" )
        , ( "font-size", "16" )
        , ( "border", "none" )
        , ( "overflow", "hidden" )
        , ( "outline", "none" )
        , ( "height", "30px" )
        , ( "margin", "5px" )
        , ( "webkit-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "moz-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
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

        AddCard _ ->
            { closeMessage = Just (SetDialogAction BoardDetails.Model.None)
            , containerClass = Nothing
            , header = Just (h3 [] [ text "List Name" ])
            , body = Just (input [ placeholder ("Enter name "), onInput SetNewCardName ] [])
            , footer =
                Just
                    (button
                        [ class "btn btn-success"
                        , onClick AddNewCard
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
