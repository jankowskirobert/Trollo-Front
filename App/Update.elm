module App.Update exposing (..)

import App.Model exposing (..)
import Page
import Boards.Update as Boards exposing (update)
import Boards.Model as BoardModel
import Debug
import Material.Helpers exposing (pure, lift, map1st, map2nd)
import BoardDetails.Update as BoardDetails


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Message" msg of
        BoardsMsg msg_ ->
            let
                ( m, c, p ) =
                    Boards.update msg_ model.boards

                -- details =
                --     m.boardDetails
                -- detailsData =
                --     m.boards
                -- updated =
                --     { m | boardDetails = { details | data = detailsData.boardDetails } }
            in
                case p of
                    Nothing ->
                        ( { model | boards = m }, Cmd.none )

                    Just g ->
                        ( { model | boards = m, activePage = g }, Cmd.none )

        SetActivePage page ->
            ( { model | activePage = page }, Cmd.none )

        GoHome i ->
            ( { model | activePage = Page.BoardsPage }, Cmd.none )

        BoardDetailsMsg msg_ ->
            let
                ( m, c ) =
                    BoardDetails.update msg_ model.boardDetails
            in
                ( { model | boardDetails = m }, Cmd.none )



-- BoardDetailsMsg msg ->
--     lift .boardDetails (\m x -> { m | boardDetails = x }) BoardDetailsMsg BoardDetails.update msg model
