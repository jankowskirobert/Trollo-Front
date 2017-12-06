module Register.Update exposing (update)

import Page exposing (..)
import Register.Model exposing (Model, Msg(..), Status(..))
import Debug


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Page )
update msg model =
    case Debug.log "MessageRegister" msg of
        Cancel ->
            ( model, Cmd.none, Maybe.Nothing )

        Register ->
            ( model, Cmd.none, Maybe.Nothing )

        SetUsername usr ->
            ( { model | username = Just usr }, Cmd.none, Maybe.Nothing )

        SetPassword pss ->
            ( { model | passwordConfirm = Just pss }, Cmd.none, Maybe.Nothing )

        ConfirmPassword pssCnf ->
        ( { model | passwordConfirm = Just pssCnf }, Cmd.none, Maybe.Nothing )
