module Boards.Update exposing (update)

import Material
import Boards.Model exposing (Msg(..), Model, Operation(..))
import BoardTask


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddBoard ->
            let
                boards_ =
                    model.boards
            in
                ( { model | boards = (BoardTask.BoardView "" []) :: boards_ }, Cmd.none )

        UpdateCurrentBoardView board ->
            ( { model | boardDetails = board, opr = Choose }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model
