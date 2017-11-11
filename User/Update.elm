module User.Module exposing (..)

import User.Model exposing (Msg(..), Model)
import Page exposing (Page(..))


update : Msg -> Model -> ( Model, Cmd Msg, Page )
update msg model =
    case msg of
        Login ->
            ( model, Cmd.none, LoginPage )

        Logout ->
            ( model, Cmd.none, LogoutPage )
