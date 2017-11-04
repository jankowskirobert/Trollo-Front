module Boards exposing (Model, model, Msg)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Material.Dialog as Dialog
import Material.Button as Button
import Material.Card as Card
import Material.Textfield as Textfield
import Material.Options as Options
import Material
import Array
import Material.Grid as Grid
import Material.Color as Color
import BoardTask as BoardTask
import Material.Typography as Typography
import Material.Icon as Icon


type Msg
    = Mdl (Material.Msg Msg)
    | AddBoard


type alias Model =
    { mdl : Material.Model
    , boards : List BoardTask.BoardView
    }


model : Model
model =
    { mdl = Material.model, boards = BoardTask.getExampleSetOfBoards }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddBoard ->
            ( model, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


democell : Int -> List (Options.Style a) -> List (Html a) -> Grid.Cell a
democell k styling =
    Grid.cell <| List.concat [ style k, styling ]


std : List (Options.Style a) -> List (Html a) -> Grid.Cell a
std =
    democell 200


color : Int -> Options.Style a
color k =
    Array.get ((k + 0) % Array.length Color.hues) Color.hues
        |> Maybe.withDefault Color.Teal
        |> flip Color.color Color.S500
        |> Color.background


style : Int -> List (Options.Style a)
style h =
    [ Options.css "text-sizing" "border-box"
    , Options.css "background-color" "#BDBDBD"
    , Options.css "height" (toString h ++ "px")
    , Options.css "padding-left" "8px"
    , Options.css "padding-top" "4px"
    , Options.css "color" "white"
    ]


white : Options.Property c m
white =
    Color.text Color.white


view : Model -> Html Msg
view model =
    List.range 1 3
        |> List.map
            (\i ->
                std [ Grid.size Grid.All 4, color 5 ]
                    [ Card.view
                        [ Options.css "width" "256px"
                        , Options.css "height" "256px"
                        , Options.css "background" "url('assets/elm.png') center / cover"
                        ]
                        [ Card.text [ Card.expand ] [] -- Filler
                        , Card.text
                            [ Options.css "background" "rgba(0, 0, 0, 0.5)" ]
                            -- Non-gradient scrim
                            [ Options.span
                                [ white, Typography.title, Typography.contrast 1.0 ]
                                [ text "Elm programming" ]
                            , Button.render Mdl
                                [ 1 ]
                                model.mdl
                                [ Button.icon, Button.ripple ]
                                [ Icon.i "phone" ]
                            ]
                        ]
                    ]
            )
        |> Grid.grid []
