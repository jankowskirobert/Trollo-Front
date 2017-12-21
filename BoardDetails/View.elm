module BoardDetails.View exposing (..)

import BoardDetails.Model exposing (Msg(..), Model, DialogAction(..))
import Html.Lazy
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Debug
import MyDialog as Dialog
import BoardDetails.Card.Edit as CardEdit
import Json.Encode
import Array


-- import Column


getBoardColumn : Int -> BoardTask.ColumnView -> Model -> Html Msg
getBoardColumn idx column model =
    let
        cards_ =
            getCardsForColumn column.id model.card

        rendered_ =
            cards_
                |> List.map (\( index, l ) -> getColumnCard index l model.comments)
                |> div [ detailsStyle ]
    in
        div []
            [ section [ class "list", detailsStyleCol ]
                [ div [] [ header [] [ text column.tableTitle ] ]
                , rendered_
                , viewButton idx model column
                ]
            ]


getColumnCard : Int -> BoardTask.CardView -> List BoardTask.CommentView -> Html Msg
getColumnCard indexOnList card coms =
    article [ class "card" ]
        [ div
            []
            [ header []
                [ div
                    [ style [ ( "word-wrap", "break-word" ) ]
                    ]
                    [ text card.title
                    , span
                        [ property "innerHTML" (Json.Encode.string "&nbsp;&nbsp;&nbsp;&nbsp;")
                        , style
                            [ ( "background-color", card.color )
                            , ( "float", "right" )
                            ]
                        ]
                        []
                    ]
                ]
            , button
                [ listDetailsButtonStyle
                , onClick (SetDialogAction (BoardDetails.Model.ShowCardDetail card))
                ]
                [ text "View Details" ]
            , button
                [ listDetailsButtonStyle
                , onClick (SetDialogAction (BoardDetails.Model.EditCard card coms))
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
        , button
            [ listDetailsButtonStyle
            , onClick (SetDialogAction (BoardDetails.Model.EditColumn idx column))
            ]
            [ text "Edit List Details" ]
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
            |> List.indexedMap
                (\idx l ->
                    getBoardColumn idx l model
                )
            |> div [ class "main_board" ]


getCardsForColumn : Int -> List BoardTask.CardView -> List ( Int, BoardTask.CardView )
getCardsForColumn columnId list =
    let
        maped =
            List.indexedMap (\idx ele -> ( idx, ele )) list

        hasAnything =
            List.filter
                (\( x, y ) ->
                    y.tableID == columnId
                )
                maped
    in
        hasAnything


view : BoardTask.BoardView -> Model -> Html Msg
view board model =
    div [ boardTextStyle ]
        [ text board.boardTitle
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
            , sizeOf = Just Dialog.Medium
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
                    , sizeOf = Just Dialog.Large
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
            , sizeOf = Just Dialog.Medium
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

        EditColumn _ _ ->
            { closeMessage = Just (SetDialogAction BoardDetails.Model.None)
            , containerClass = Nothing
            , sizeOf = Just Dialog.Medium
            , header = Just (h3 [] [ text "Edit list" ])
            , body = Just (input [ placeholder ("Enter name "), onInput SetNewColumndName ] [])
            , footer =
                Just
                    (button
                        [ class "btn btn-success"
                        , onClick EditList
                        ]
                        [ text "OK" ]
                    )
            }

        EditCard _ _ ->
            dialogConfigEditCard model


dialogConfigErrorMsg : Dialog.Config Msg
dialogConfigErrorMsg =
    { closeMessage = Just (SetDialogAction BoardDetails.Model.None)
    , containerClass = Nothing
    , header = Just (h3 [] [ text "ERROR!" ])
    , body = Just (text "Board not found")
    , sizeOf = Just Dialog.Medium
    , footer =
        Just
            (button
                [ class "btn btn-success"
                , onClick (SetDialogAction BoardDetails.Model.None)
                ]
                [ text "OK" ]
            )
    }


dialogConfigEditCard : Model -> Dialog.Config Msg
dialogConfigEditCard model =
    -- lst =
    --     model.comments
    -- ele =
    --     case model.currentCardIndex of
    --         Nothing ->
    --             div [] []
    --         Just idx ->
    --             case (Array.get idx (Array.fromList lst)) of
    --                 Nothing ->
    --                     div [] []
    --                 Just card ->
    --                     commentsSectionInDialog model.comments card
    case model.currentCard of
        Nothing ->
            dialogConfigErrorMsg

        Just crd ->
            let
                styles =
                    style [ ( "background-color", crd.color ) ]
            in
                { closeMessage = Just (SetDialogAction BoardDetails.Model.None)
                , containerClass = Just "modal-dialog modal-lg"
                , header = Just (h3 [ styles ] [ text "Edit Card Details" ])
                , sizeOf = Just Dialog.Large
                , body =
                    Just
                        (div []
                            [ div [] [ input [ placeholder ("Enter name "), onInput SetNewCardName ] [] ]
                            , div [] [ input [ placeholder ("Enter desc "), onInput SetNewCardDescription ] [] ]
                            , div []
                                [ input
                                    [ type_ "checkbox"
                                    , onClick TogglePublic
                                    , checked crd.archiveStatus
                                    ]
                                    []
                                ]

                            -- , ele
                            , input [ type_ "color", onInput UpdateColor ] [ text "label color" ]
                            ]
                        )
                , footer =
                    Just
                        (button
                            [ class "btn btn-success"
                            , onClick UpdateCurrentCard
                            ]
                            [ text "OK" ]
                        )
                }


commentsSectionInDialog : List BoardTask.CommentView -> BoardTask.CardView -> Html Msg
commentsSectionInDialog coms card =
    div []
        [ hr [] []
        , input
            [ placeholder ("Enter new comment")
            , onInput SetNewCardComment
            ]
            []
        , button
            [ class "btn btn-success"
            , onClick AddNewComment
            ]
            [ text "Add Comment" ]
        , table [ class "table table-bordered" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Comment" ]
                    , th [] [ text "Date" ]
                    ]
                ]
            , (commentListInDialog card coms)
            ]
        ]


commentListInDialog : BoardTask.CardView -> List BoardTask.CommentView -> Html Msg
commentListInDialog card list =
    List.map (\x -> commentViewInDialog x) list |> tbody []


commentViewInDialog : BoardTask.CommentView -> Html Msg
commentViewInDialog com =
    tr []
        [ td [] [ text com.body ]
        , td [] [ text (toString com.added) ]
        ]
