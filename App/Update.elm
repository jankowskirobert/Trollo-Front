module App.Update exposing (..)

import App.Model exposing (..)
import Page
import Boards
import BoardDetails
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
                update (SetActivePage Page.BoardDetailsPage) updated

        SetActivePage page ->
            ( { model | activePage = page }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model

        BoardDetailsMsg msg ->
            lift .boardDetails (\m x -> { m | boardDetails = x }) BoardDetailsMsg BoardDetails.update msg model
