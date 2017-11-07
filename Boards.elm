module Boards exposing (Model, model, Msg, view, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import BoardTask
import BoardDetails
import Page
import Navigation


type Msg
    = AddBoard
    | UpdateCurrentBoardView BoardTask.BoardView


type alias Model =
    { boards : List BoardTask.BoardView
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
        ({ boards = boards_, boardDetails = stricBoard_ })


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Page.Page )
update msg model =
    case msg of
        AddBoard ->
            ( model, Cmd.none, Maybe.Nothing )

        UpdateCurrentBoardView board ->
            let
                boards =
                    model.boards

                board_ =
                    List.head boards

                stricBoard_ =
                    Maybe.withDefault (BoardTask.BoardView "" []) board_
            in
                ( { model | boardDetails = board }, Cmd.none, Just (Page.BoardDetailsPage) )


view : Model -> Html Msg
view model =
    model.boards
        |> List.map
            (\i ->
                div [] [ button [ onClick (UpdateCurrentBoardView i) ] [ text i.title ] ]
            )
        |> div []
