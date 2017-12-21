module App.Update exposing (..)

import App.Model exposing (..)
import Page
import Boards.Update as Boards
import Debug
import BoardDetails.Update as BoardDetails
import BoardDetails.Model as BoardDetailsModel
import BoardDetails.Rest as BoardDetailsRest
import Login.Update as Login
import Login.Model as LoginModel
import Register.Update as Register
import Boards.Model as BoardsModel
import Boards.Rest as Rest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Message" ( msg, model.activePage ) of
        ( BoardsMsg msg_, Page.BoardsPage subModel ) ->
            let
                ( m, c, p ) =
                    Boards.update model.user msg_ subModel
            in
                case p of
                    Nothing ->
                        ( { model | activePage = Page.BoardsPage m }
                        , Cmd.batch
                            [ (Cmd.map BoardsMsg c)
                            ]
                        )

                    Just g ->
                        let
                            cmdAfter =
                                case g of
                                    Page.BoardDetailsPage view _ ->
                                        let
                                            token =
                                                model.user
                                        in
                                            [ Cmd.map BoardsMsg c
                                            , Cmd.map BoardDetailsMsg (Cmd.map BoardDetailsModel.RestCardMsg (BoardDetailsRest.getColumnsView token.auth view))
                                            , Cmd.map BoardDetailsMsg (Cmd.map BoardDetailsModel.RestCardMsg (BoardDetailsRest.getCardsView token.auth))
                                            ]

                                    _ ->
                                        [ Cmd.map BoardsMsg c, Cmd.none ]
                        in
                            ( { model | activePage = g }, Cmd.batch cmdAfter )

        ( SetActivePage page, subModel ) ->
            let
                cmd =
                    case page of
                        Page.BoardsPage _ ->
                            let
                                token =
                                    model.user
                            in
                                (Cmd.map BoardsMsg (Cmd.map BoardsModel.RestMsg (Rest.getBoardView token.auth)))

                        Page.BoardDetailsPage view _ ->
                            let
                                token =
                                    model.user
                            in
                                Cmd.map BoardDetailsMsg (Cmd.map BoardDetailsModel.RestCardMsg (BoardDetailsRest.getColumnsView token.auth view))

                        _ ->
                            Cmd.none
            in
                ( { model | activePage = page }, cmd )

        ( GoHome i, _ ) ->
            ( model, Cmd.none )

        ( BoardDetailsMsg msg_, Page.BoardDetailsPage view subModel ) ->
            let
                ( m, c ) =
                    BoardDetails.update model.user view msg_ subModel
            in
                ( { model | activePage = Page.BoardDetailsPage view m }, Cmd.map BoardDetailsMsg c )

        ( LoginMsg msg_, Page.LoginPage subModel ) ->
            let
                ( ( m, c ), out ) =
                    Login.update msg_ subModel

                usr =
                    model.user

                funOut =
                    case out of
                        Nothing ->
                            let
                                updated =
                                    { model | user = { usr | status = False } }
                            in
                                ( { updated | activePage = Page.LoginPage { m | token = out } }
                                , Cmd.batch
                                    [ (Cmd.map LoginMsg c)
                                    ]
                                )

                        Just token ->
                            let
                                updated =
                                    { model | user = { usr | status = True, auth = Just token } }

                                ( bm, bc, bp ) =
                                    Boards.update updated.user BoardsModel.FetchAvaliableBoards BoardsModel.model
                            in
                                ( { updated | activePage = Page.BoardsPage BoardsModel.model }
                                , Cmd.batch
                                    [ (Cmd.map LoginMsg c)
                                    , (Cmd.map BoardsMsg bc)
                                    ]
                                )
            in
                funOut

        ( LoginMsg msg_, _ ) ->
            ( model, Cmd.none )

        ( RegisterMsg msg_, Page.RegisterPage subM ) ->
            let
                ( m, c, p ) =
                    Register.update msg_ subM
            in
                case p of
                    Nothing ->
                        ( model, Cmd.map RegisterMsg c )

                    Just g ->
                        ( { model | activePage = Page.LoginPage LoginModel.model }, Cmd.batch [ (Cmd.map RegisterMsg c) ] )

        ( _, _ ) ->
            ( model, Cmd.none )
