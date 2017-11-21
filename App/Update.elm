module App.Update exposing (..)

import App.Model exposing (..)
import Page
import Boards.Update as Boards
import Boards.Model as BoardModel
import Debug
import Material.Helpers exposing (pure, lift, map1st, map2nd)
import BoardDetails.Update as BoardDetails
import BoardTask
import Boards.Rest as Rest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Message" msg of
        BoardsMsg msg_ ->
            let
                ( m, c, p ) =
                    Boards.update msg_ model.boards

                bd_ =
                    model.boardDetails

                updated =
                    case Debug.log "Message" m.currentBoard of
                        Nothing ->
                            bd_

                        Just x ->
                            { bd_ | columns = (BoardTask.getColumnsForBoard x.id), board = Just x }
            in
                case p of
                    Nothing ->
                        ( { model | boards = m, boardDetails = updated }, Cmd.map BoardsMsg c )

                    --REVOLUTION!!!! cmd.map command by model
                    Just g ->
                        ( { model | boards = m, activePage = g, boardDetails = updated }, Cmd.map BoardsMsg c )

        SetActivePage page ->
            ( { model | activePage = page }, Cmd.none )

        GoHome i ->
            ( { model | activePage = Page.BoardsPage }, Cmd.map BoardsMsg (Cmd.map BoardModel.RestMsg Rest.getBoardView) )

        BoardDetailsMsg msg_ ->
            let
                ( m, c ) =
                    BoardDetails.update msg_ model.boardDetails
            in
                ( { model | boardDetails = m }, Cmd.none )
