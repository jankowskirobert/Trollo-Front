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
                ( model_, cmd, page ) =
                    Boards.update msg model.boards

                log =
                    page
            in
                case page of
                    Nothing ->
                        ( { model | boards = model_ }, Cmd.none )

                    Just x ->
                        let
                            log_ =
                                Debug.log ("Have: " ++ (Page.pageToString x)) "Should: #board"
                        in
                            update (SetActivePage x) { model | boards = model_ }

        SetActivePage page ->
            ( { model | activePage = page }, Cmd.none )

        BoardDetailsMsg msg ->
            let
                details =
                    model.boardDetails

                detailsData =
                    model.boards

                ( model_, cmd ) =
                    BoardDetails.update msg { details | data = detailsData.boardDetails }
            in
                ( { model | boardDetails = model_ }
                , Cmd.none
                )
