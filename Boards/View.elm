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
    div [ class "col col-lg-2" ]
        [ a
            [ onClick (SetOperation (Boards.Model.Choose board))
            , class "list-group-item list-group-item-action flex-column align-items-start"
            ]
            [ div [ class "d-flex w-100 justify-content-between" ]
                [ text (board.title ++ " ")
                , text ((toString board.viewId) ++ " ")
                , text ((toString board.id) ++ " ")
                , h5 [ class "mb-1" ] [ text board.title ]
                , small [] [ text "3 days ago" ]
                ]
            ]
        , button
            [ onClick (SetOperation (Boards.Model.Edit idx board))
            ]
            [ text "Edit Name"
            ]
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
                                div [ class "row justify-content-md-center d-flex flex-nowrap" ] [ boardGridBox model x index ]
                    )
                |> div [ class "" ]
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
