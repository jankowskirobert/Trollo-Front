module Boards.View exposing (view)

import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html exposing (..)
import Array
import Boards.Model exposing (Model, Msg(..))
import BoardTask
import Dialog


-- Cell variants
-- Grid


boardGridBox : Model -> BoardTask.BoardView -> Int -> Html Msg
boardGridBox model board idx =
    div []
        [ button
            [ onClick (SetOperation (Boards.Model.Choose board))
            ]
            [ div []
                [ text (board.title ++ " ")
                , text ((toString board.viewId) ++ " ")
                , text ((toString board.id) ++ " ")
                ]
            ]
        , button
            [ onClick (SetOperation (Boards.Model.Edit idx board))
            ]
            [ text "Edit Name"
            ]
        ]


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
                                boardGridBox model x index
                    )
                |> div []
    in
        div []
            [ s
            , button [ onClick (SetOperation Boards.Model.AddNewBoard) ] [ text "Add Board" ]
            , Dialog.view
                (if model.showDialog then
                    Just (dialogConfig model)
                 else
                    Nothing
                )
            ]


dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    case model.opr of
        Boards.Model.Edit _ _ ->
            case model.currentBoard of
                Just x ->
                    let
                        currentName_ =
                            x.title
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
            , header = Just (h3 [] [ text "Edit Board Name" ])
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
