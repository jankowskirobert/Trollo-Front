module App.View exposing (..)

import Html.Lazy
import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page exposing (..)
import Boards.View as Boards exposing (view)
import BoardDetails.View as BoardDetails


tabs : List (Model -> Html Msg)
tabs =
    [ (.boards >> Boards.view >> Html.map BoardsMsg)
    ]


view : Model -> Html Msg
view =
    Html.Lazy.lazy view_


view_ : Model -> Html Msg
view_ model =
    let
        h_ =
            case model.activePage of
                BoardsPage ->
                    div [] [ Html.map BoardsMsg (Boards.view model.boards) ]

                BoardDetailsPage ->
                    -- Html.map BoardDetailsMsg (BoardDetails.view model.boardDetails)
                    div [] [ Html.map BoardDetailsMsg (BoardDetails.view model.boardDetails) ]

                -- (BoardDetails.view { data_ | data = board })
                PageNotFound ->
                    div [] [ text "404" ]

                LoginPage ->
                    div [] [ text "login" ]

                LogoutPage ->
                    div [] [ text "login" ]
    in
        div []
            [ button [ onClick (GoHome 1) ] [ text "Go Home" ], h_ ]
