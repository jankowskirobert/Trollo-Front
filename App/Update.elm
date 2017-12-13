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
        ( BoardsMsg msg_, Page.BoardsPage subModel ) ->
            let
                ( m, c, p ) =
                    Boards.update msg_ subModel
            in
                case p of
                    Nothing ->
                        ( { model | activePage = Page.BoardsPage m }, Cmd.map BoardsMsg c )

                    Just g ->
                        ( { model | activePage = g }, Cmd.map BoardsMsg c )

        ( SetActivePage page, _ ) ->
            ( { model | activePage = page }, Cmd.none )

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

                newModel_ =
                    case out of
                        Nothing ->
                            { model | user = { status = False } }

                        Just token ->
                            { model | user = { status = True } }
            in
                ( { newModel_ | activePage = Page.LoginPage { m | token = out } }
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
