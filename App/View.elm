module App.View exposing (..)

import Html.Lazy
import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page exposing (..)
import Boards
import BoardDetails


view : Model -> Html Msg
view =
    Html.Lazy.lazy view_


view_ : Model -> Html Msg
view_ model =
    case model.activePage of
        BoardsPage ->
            Html.map BoardsMsg (Boards.view model.boards)

        BoardDetailsPage ->
            let
                boards =
                    model.boards

                model_ =
                    model.boardDetails

                board =
                    boards.boardDetails
            in
                Html.map BoardDetailsMsg (BoardDetails.view { model_ | data = board })

        -- (BoardDetails.view { data_ | data = board })
        PageNotFound ->
            div [] [ text "404" ]
