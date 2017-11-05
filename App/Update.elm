module App.Update exposing (..)

import App.Model exposing (..)
import Page
import Boards


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardsMsg msg ->
            let
                result =
                    Boards.update msg model.boards
            in
                ( { model | boards = Tuple.first result }
                , Cmd.none
                )

        SetActivePage page ->
            ( { model | activePage = page }, Cmd.none )
