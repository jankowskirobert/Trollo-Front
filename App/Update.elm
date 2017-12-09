module App.Update exposing (..)

import App.Model exposing (..)
import Page
import Boards.Update as Boards
import Debug
import BoardDetails.Update as BoardDetails
import Login.Update as Login
import Login.Model as LoginModel
import Register.Update as Register


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Message" ( msg, model.activePage ) of
        ( BoardsMsg msg_, Page.BoardsPage ) ->
            let
                ( m, c, p ) =
                    Boards.update msg_ model.boardsModel
            in
                case p of
                    Nothing ->
                        ( { model | boardsModel = m }, Cmd.map BoardsMsg c )

                    Just g ->
                        ( { model | activePage = g, boardsModel = m }, Cmd.map BoardsMsg c )

        ( SetActivePage page, _ ) ->
            ( { model | activePage = page }, Cmd.none )

        ( GoHome i, _ ) ->
            ( model, Cmd.none )

        ( BoardDetailsMsg msg_, Page.BoardDetailsPage view ) ->
            -- let
            --     ( m, c ) =
            --         BoardDetails.update msg_ subM
            -- in
            -- case p of
            --     Nothing ->
            --         ( model, Cmd.map BoardDetailsMsg c )
            --     Just g ->
            -- ( model, Cmd.map BoardDetailsMsg c )
            ( model, Cmd.none )

        ( LoginMsg msg_, Page.LoginPage ) ->
            let
                ( ( m, c ), out ) =
                    Login.update msg_ model.loginModel

                newModel_ =
                    case out of
                        LoginModel.Successful ->
                            { model | user = { status = True } }

                        LoginModel.Fail ->
                            { model | user = { status = False } }

                        LoginModel.None ->
                            { model | user = { status = False } }
            in
                ( { newModel_ | loginModel = m }
                , Cmd.map LoginMsg c
                )

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
