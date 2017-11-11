module App.Update exposing (..)

import App.Model exposing (..)
import Page
import Boards.Update as Boards exposing (update)
import Boards.Model as BoardModel
import BoardDetails.Update as BoardDetails
import Debug
import Material
import Material.Helpers exposing (pure, lift, map1st, map2nd)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Message" msg of
        BoardsMsg msg ->
            let
                ( m, c ) =
                    lift .boards (\m x -> { m | boards = x }) BoardsMsg Boards.update msg model

                details =
                    m.boardDetails

                detailsData =
                    m.boards

                updated =
                    { m | boardDetails = { details | data = detailsData.boardDetails } }
            in
                case detailsData.opr of
                    BoardModel.Choose ->
                        ( { updated | activePage = Page.BoardDetailsPage }, Cmd.none )

                    BoardModel.Edit ->
                        ( model, Cmd.none )

                    BoardModel.None ->
                        ( model, Cmd.none )

        SetActivePage page ->
            ( { model | activePage = page }, Cmd.none )

        GoHome i ->
            ( { model | activePage = Page.BoardsPage }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

        BoardDetailsMsg msg ->
            lift .boardDetails (\m x -> { m | boardDetails = x }) BoardDetailsMsg BoardDetails.update msg model
