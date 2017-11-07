module Boards.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html
import Material
import Boards.Model exposing (Model, Msg(..))


view : Model -> Html Msg
view model =
    model.boards
        |> List.map
            (\i ->
                div [] [ button [ onClick (UpdateCurrentBoardView i) ] [ text i.title ] ]
            )
        |> div []
