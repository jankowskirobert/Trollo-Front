module App.Update exposing (..)

import App.Model exposing (..)
import Page
import Boards
import BoardDetails
import Debug


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardsMsg msg ->
            let
                ( model_, cmd, path ) =
                    Boards.update msg model.boards

                log =
                    Debug.log ("Have: " ++ path) "Should: #board"
            in
                ( { model | boards = model_ }
                , Cmd.none
                )

        SetActivePage page ->
            ( { model | activePage = page }, Cmd.none )

        BoardDetailsMsg msg ->
            let
                result =
                    BoardDetails.update msg model.boardDetails
            in
                ( { model | boardDetails = Tuple.first result }
                , Cmd.none
                )
