module Boards exposing (Model, model, Msg, view, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import BoardTask
import BoardDetails
import Page
import Navigation
import Material


type Msg
    = AddBoard
    | UpdateCurrentBoardView BoardTask.BoardView
    | Mdl (Material.Msg Msg)


type alias Model =
    { boards : List BoardTask.BoardView
    , boardDetails : BoardTask.BoardView
    , mdl : Material.Model
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
        ({ boards = boards_, boardDetails = stricBoard_, mdl = Material.model })


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddBoard ->
            ( model, Cmd.none )

        UpdateCurrentBoardView board ->
            let
                boards =
                    model.boards

                board_ =
                    List.head boards

                stricBoard_ =
                    Maybe.withDefault (BoardTask.BoardView "" []) board_
            in
                ( { model | boardDetails = board }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    model.boards
        |> List.map
            (\i ->
                div [] [ button [ onClick (UpdateCurrentBoardView i) ] [ text i.title ] ]
            )
        |> div []
