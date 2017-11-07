module Boards.Update exposing (update)

import Material
import Boards.Model exposing (Msg(..), Model)
import BoardTask


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
