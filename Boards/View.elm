module Boards.View exposing (view)

import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html exposing (..)
import Array
import Boards.Model exposing (Model, Msg(..))
import BoardTask
import MyDialog as Dialog


-- Cell variants
-- Grid


boardGridBox : Model -> BoardTask.BoardView -> Int -> Html Msg
boardGridBox model board idx =
    let
        access_type =
            case board.public_access of
                True ->
                    "Public"

                False ->
                    "Private"
    in
        div [ boardStyle ]
            [ button
                [ onClick (SetOperation (Boards.Model.Choose board))
                , boardButtonStyle
                ]
                [ div [ class "d-flex w-100 justify-content-between" ]
                    [ div
                        [ style
                            [ ( "float", "left" )
                            , ( "width", "70%" )
                            ]
                        ]
                        [ text (board.boardTitle ++ " ") ]
                    , div
                        [ style
                            [ ( "float", "right" )
                            ]
                        ]
                        [ text access_type ]
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


view : Model -> Html Msg
view model =
    let
        s =
            model.boards
                |> List.indexedMap
                    (\index x ->
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
            ]


dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    case model.opr of
        Nothing ->
            dialogConfigErrorMsg (Just "No opr found")

        Just is ->
            case is of
                Boards.Model.Edit _ _ ->
                    case model.currentBoard of
                        Just x ->
                            let
                                currentName_ =
                                    x.boardTitle
                            in
                                { closeMessage = Just (SetOperation Boards.Model.HideDialog)
                                , containerClass = Nothing
                                , sizeOf = Just Dialog.Medium
                                , header = Just (h3 [] [ text "Board Details" ])
                                , body =
                                    Just
                                        (div []
                                            [ div []
                                                [ input
                                                    [ placeholder ("Enter name / " ++ currentName_)
                                                    , onInput SetNewBoardName
                                                    , style
                                                        [ ( "width", "100%" )
                                                        ]
                                                    ]
                                                    []
                                                ]
                                            , div []
                                                [ input
                                                    [ placeholder ("Enter description / " ++ x.boardDescription)
                                                    , onInput SetNewBoardDescription
                                                    , style
                                                        [ ( "width", "100%" )
                                                        ]
                                                    ]
                                                    []
                                                ]
                                            , div []
                                                [ input
                                                    [ type_ "checkbox"
                                                    , onClick TogglePublic
                                                    , checked x.public_access
                                                    ]
                                                    []
                                                , text "Public Access"
                                                ]
                                            , div []
                                                [ text "Owner: "
                                                , text x.owner
                                                ]
                                            ]
                                        )
                                , footer =
                                    Just
                                        (button
                                            [ class "btn btn-success"
                                            , onClick EditBoardName
                                            ]
                                            [ text "Save" ]
                                        )
                                }

                        Nothing ->
                            dialogConfigErrorMsg (Just "Board not found")

                Boards.Model.AddNewBoard ->
                    { closeMessage = Just (SetOperation Boards.Model.HideDialog)
                    , containerClass = Nothing
                    , sizeOf = Just Dialog.Medium
                    , header = Just (h3 [] [ text "Add Board" ])
                    , body =
                        Just
                            (div []
                                [ input
                                    [ placeholder ("Enter name ")
                                    , onInput SetNewBoardName
                                    ]
                                    []
                                , div []
                                    [ input [ type_ "checkbox", onClick TogglePublic ] []
                                    , text "Public Access"
                                    ]
                                ]
                            )
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
                    dialogConfigErrorMsg (Just "Board not found")

                Boards.Model.HideDialog ->
                    dialogConfigErrorMsg (Just "Board not found")

                Boards.Model.ConnectionError msg ->
                    dialogConfigErrorMsg (Just msg)


dialogConfigErrorMsg : Maybe String -> Dialog.Config Msg
dialogConfigErrorMsg message =
    let
        errorMsg =
            case message of
                Nothing ->
                    "Internal Error"

                Just msg_ ->
                    msg_
    in
        { closeMessage = Just (SetOperation Boards.Model.HideDialog)
        , containerClass = Nothing
        , header = Just (h3 [] [ text "ERROR!" ])
        , body = Just (text errorMsg)
        , sizeOf = Just Dialog.Medium
        , footer =
            Just
                (button
                    [ class "btn btn-success"
                    , onClick (SetOperation Boards.Model.HideDialog)
                    ]
                    [ text "OK" ]
                )
        }
