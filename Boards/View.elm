module Boards.View exposing (view)

import Html exposing (..)
import Array
import Material.Grid exposing (..)
import Material.Options exposing (Style, css, onClick)
import Material.Color as Color
import Material
import Boards.Model exposing (Model, Msg(..))


style : Int -> List (Style a)
style h =
    [ css "text-sizing" "border-box"
    , css "background-color" "#BDBDBD"
    , css "height" (toString h ++ "px")
    , css "padding-left" "8px"
    , css "padding-top" "4px"
    , css "color" "white"
    ]



-- Cell variants


democell : Int -> List (Style a) -> List (Html a) -> Cell a
democell k styling =
    cell <| List.concat [ style k, styling ]


small : List (Style a) -> List (Html a) -> Cell a
small =
    democell 50


std : List (Style a) -> List (Html a) -> Cell a
std =
    democell 200



-- Grid


color : Int -> Style a
color k =
    Array.get ((k + 0) % Array.length Color.hues) Color.hues
        |> Maybe.withDefault Color.Teal
        |> flip Color.color Color.S500
        |> Color.background


view : Model -> Html Msg
view model =
    model.boards
        |> List.map
            (\i ->
                std [ size All 4, color 5, onClick (UpdateCurrentBoardView i) ] [ div [] [ text i.title ] ]
            )
        |> grid []
