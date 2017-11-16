module Boards.View exposing (view)

import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html exposing (..)
import Array
import Boards.Model exposing (Model, Msg(..))
import BoardTask
import Dialog
import Boards.Rest as Rest


-- Cell variants
-- Grid


boardGridBox : Model -> BoardTask.BoardView -> Int -> Html Msg
boardGridBox model board idx =
    div [ boardStyle ]
        [ button
            [ onClick (SetOperation (Boards.Model.Choose board))
            , boardButtonStyle
            ]
            [ div [ class "d-flex w-100 justify-content-between" ]
                [ text (board.boardTitle ++ " ")
                , text ((toString board.id) ++ " ")
                , h5 [ class "mb-1" ] [ text board.boardTitle ]
                , small [] [ text "3 days ago" ]
                ]
            ]
        , button
            [ onClick (SetOperation (Boards.Model.Edit idx board)), boardButtonStyle2 ]
            [ text "Edit"
            ]
        ]


boardStyle : Attribute msg
boardStyle =
    style
        [ ( "backgroundColor", "white" )
        , ( "position", "relative" )
        , ( "float", "left" )
        , ( "height", "74px" )
        , ( "width", "200px" )
        , ( "margin", "10px" )
        ]


boardButtonStyle : Attribute msg
boardButtonStyle =
    style
        [ ( "color", "#646464" )
        , ( "backgroundColor", "white" )
        , ( "position", "absolute" )
        , ( "font-size", "20" )
        , ( "border", "none" )
        , ( "overflow", "hidden" )
        , ( "outline", "none" )
        , ( "width", "100%" )
        , ( "height", "48px" )
        , ( "webkit-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "moz-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        ]


boardButtonStyle2 : Attribute msg
boardButtonStyle2 =
    style
        [ ( "color", "white" )
        , ( "backgroundColor", "#166494" )
        , ( "position", "absolute" )
        , ( "font-size", "20" )
        , ( "border", "none" )
        , ( "overflow", "hidden" )
        , ( "outline", "none" )
        , ( "width", "100%" )
        , ( "height", "26px" )
        , ( "bottom", "0px" )
        , ( "webkit-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "moz-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        ]



--  <a href="#" class="list-group-item list-group-item-action flex-column align-items-start active">
--     <div class="d-flex w-100 justify-content-between">
--       <h5 class="mb-1">List group item heading</h5>
--       <small>3 days ago</small>
--     </div>
--     <p class="mb-1">Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit.</p>
--     <small>Donec id elit non mi porta.</small>
--   </a>


view : Model -> Html Msg
view model =
    let
        s =
            model.boards
                |> List.indexedMap
                    (\index i ->
                        case i of
                            Nothing ->
                                div [] []

                            Just x ->
                                div [] [ boardGridBox model x index ]
                    )
                |> div [ class "" ]
    in
        div []
            [ s
            , div [ boardStyle ]
                [ button
                    [ onClick (SetOperation Boards.Model.AddNewBoard)
                    , boardButtonStyle
                    , style [ ( "box-shadow", "none" ) ]
                    ]
                    [ text "+ Add new board" ]
                , Dialog.view
                    (if model.showDialog then
                        Just (dialogConfig model)
                     else
                        Nothing
                    )
                ]
            , button
                [ class "btn btn-success"
                , onClick FetchAll
                ]
                [ text "OK" ]
            ]


dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    case model.opr of
        Boards.Model.Edit _ _ ->
            case model.currentBoard of
                Just x ->
                    let
                        currentName_ =
                            x.boardTitle
                    in
                        { closeMessage = Just (SetOperation Boards.Model.None)
                        , containerClass = Nothing
                        , header = Just (h3 [] [ text "Edit Board Name" ])
                        , body = Just (input [ placeholder ("Enter name / " ++ currentName_), onInput SetNewBoardName ] [])
                        , footer =
                            Just
                                (button
                                    [ class "btn btn-success"
                                    , onClick EditBoardName
                                    ]
                                    [ text "OK" ]
                                )
                        }

                Nothing ->
                    dialogConfigErrorMsg

        Boards.Model.AddNewBoard ->
            { closeMessage = Just (SetOperation Boards.Model.None)
            , containerClass = Nothing
            , header = Just (h3 [] [ text "Add Board" ])
            , body = Just (input [ placeholder ("Enter name "), onInput SetNewBoardName ] [])
            , footer =
                Just
                    (button
                        [ class "btn btn-success"
                        , onClick AddBoard
                        ]
                        [ text "OK" ]
                    )
            }

        Boards.Model.Choose _ ->
            dialogConfigErrorMsg

        Boards.Model.None ->
            dialogConfigErrorMsg


dialogConfigErrorMsg : Dialog.Config Msg
dialogConfigErrorMsg =
    { closeMessage = Just (SetOperation Boards.Model.None)
    , containerClass = Nothing
    , header = Just (h3 [] [ text "ERROR!" ])
    , body = Just (text "Board not found")
    , footer =
        Just
            (button
                [ class "btn btn-success"
                , onClick (SetOperation Boards.Model.None)
                ]
                [ text "OK" ]
            )
    }
