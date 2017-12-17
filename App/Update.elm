module App.Update exposing (..)

import App.Model exposing (..)
import Page
import Boards.Update as Boards
import Debug
import BoardDetails.Update as BoardDetails
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
                    Boards.update msg_ subModel
            in
                case p of
                    Nothing ->
                        ( { model | activePage = Page.BoardsPage m }
                        , Cmd.batch
                            [ (Cmd.map BoardsMsg c)
                            ]
                        )

                    Just g ->
                        ( { model | activePage = g }, Cmd.map BoardsMsg c )

        ( SetActivePage page, _ ) ->
            let
                cmd =
                    case page of
                        Page.BoardsPage _ ->
                            (Cmd.map BoardsMsg (Cmd.map BoardsModel.RestMsg Rest.getBoardView))

                        Page.BoardDetailsPage _ _ ->
                            Cmd.none

                        Page.LoginPage _ ->
                            Cmd.none

                        Page.LogoutPage ->
                            Cmd.none

                        Page.RegisterPage ->
                            Cmd.none

                        Page.PageNotFound ->
                            Cmd.none
            in
                ( { model | activePage = page }, cmd )

        ( GoHome i, _ ) ->
            ( model, Cmd.none )

        ( BoardDetailsMsg msg_, Page.BoardDetailsPage view subModel ) ->
            let
                detailed =
                    { subModel | board = Just view }

                ( m, c ) =
                    BoardDetails.update msg_ detailed
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
                                    Boards.update BoardsModel.FetchAvaliableBoards BoardsModel.model
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

        ( RegisterMsg msg_, Page.RegisterPage ) ->
            -- let
            --     ( m, c, p ) =
            --         Register.update msg_ subM
            -- in
            --     case p of
            --         Nothing ->
            --             ( model, Cmd.map RegisterMsg c )
            --         Just g ->
            --             ( { model | activePage = g }, Cmd.map RegisterMsg c )
            ( model, Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )
