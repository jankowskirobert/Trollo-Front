module Login.Update exposing (update)

import Page exposing (..)
import Login.Model exposing (Model, Msg(..), Status(..))
import Debug


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Page )
update msg model =
    case Debug.log "MessageLogin" msg of
        SignIn ->
            ( { model | status = Successful }, Cmd.none, Just BoardsPage )

        SignOut ->
            ( model, Cmd.none, Maybe.Nothing )

        Register ->
            ( model, Cmd.none, Maybe.Nothing )

        SetUsername usr ->
            ( { model | username = Just usr }, Cmd.none, Maybe.Nothing )

        SetPassword pss ->
            ( { model | password = Just pss }, Cmd.none, Maybe.Nothing )
