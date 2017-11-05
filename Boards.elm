module Boards exposing (Model, model, Msg, view, update)

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
import BoardTask
import Material.Typography as Typography
import Material.Icon as Icon
import BoardDetails
import Page
import Navigation


type Msg
    = Mdl (Material.Msg Msg)
    | AddBoard
    | UpdateCurrentBoardView


type alias Model =
    { mdl : Material.Model
    , boards : List BoardTask.BoardView
    , boardDetails : BoardTask.BoardView
    }


model : Model
model =
    let
        boards_ =
            BoardTask.getExampleSetOfBoards

        board_ =
            List.head boards_

        stricBoard_ =
            Maybe.withDefault (BoardTask.BoardView "" []) board_
    in
        ({ mdl = Material.model, boards = boards_, boardDetails = stricBoard_ })


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Page.Page )
update msg model =
    case msg of
        AddBoard ->
            ( model, Cmd.none, Maybe.Nothing )

        UpdateCurrentBoardView ->
            let
                boards =
                    model.boards

                board_ =
                    List.head boards

                stricBoard_ =
                    Maybe.withDefault (BoardTask.BoardView "" []) board_
            in
                ( { model | boardDetails = stricBoard_ }, Cmd.none, Just (Page.BoardDetailsPage) )

        Mdl msg_ ->
            let
                ( md, cm ) =
                    Material.update Mdl msg_ model
            in
                ( md, cm, Maybe.Nothing )


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
    model.boards
        |> List.map
            (\i ->
                std [ Grid.size Grid.All 4, color 5 ]
                    [ Card.view
                        [ Options.css "width" "200px"
                        , Options.css "height" "200px"
                        , Options.css "background" "rgba(255, 0, 255, 1)"
                        , Options.onClick (UpdateCurrentBoardView)
                        ]
                        [ Card.text [ Card.expand ] [] -- Filler
                        , Card.text
                            [ Options.css "background" "rgba(0, 0, 0, 0.5)" ]
                            -- Non-gradient scrim
                            [ Options.span
                                [ white, Typography.title, Typography.contrast 1.0 ]
                                [ text i.title ]
                            , Button.render Mdl
                                [ 1 ]
                                model.mdl
                                [ Button.icon, Button.ripple ]
                                [ Icon.i "phone" ]
                            , li [] [ a [ href ("#board") ] [ text "jhjhkhk" ] ]
                            ]
                        ]
                    ]
            )
        |> Grid.grid []
