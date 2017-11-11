module Boards.View exposing (view)

import Html exposing (..)
import Array
import Material.Grid exposing (..)
import Material.Color as Color
import Material
import Boards.Model exposing (Model, Msg(..))
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options


style : Int -> List (Options.Style a)
style h =
    [ Options.css "text-sizing" "border-box"
    , Options.css "background-color" "#BDBDBD"
    , Options.css "height" (toString h ++ "px")
    , Options.css "padding-left" "8px"
    , Options.css "padding-top" "4px"
    , Options.css "color" "white"
    ]



-- Cell variants


democell : Int -> List (Options.Style a) -> List (Html a) -> Cell a
democell k styling =
    cell <| List.concat [ style k, styling ]


small : List (Options.Style a) -> List (Html a) -> Cell a
small =
    democell 50


std : List (Options.Style a) -> List (Html a) -> Cell a
std =
    democell 200



-- Grid


color : Int -> Options.Style a
color k =
    Array.get ((k + 0) % Array.length Color.hues) Color.hues
        |> Maybe.withDefault Color.Teal
        |> flip Color.color Color.S500
        |> Color.background


view : Model -> Html Msg
view model =
    let
        s =
            model.boards
                |> List.map
                    (\i ->
                        std [ size All 4, color 5, Options.onClick (UpdateCurrentBoardView i) ] [ div [] [ text i.title ] ]
                    )
                |> grid []
    in
        div []
            [ s
            , Button.render Mdl
                [ 1 ]
                model.mdl
                [ Button.raised, Dialog.openOn "click", Options.onClick (AddBoard) ]
                [ text "Add Card" ]
            ]
