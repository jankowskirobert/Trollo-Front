module Login.Update exposing (update)

import Login.Model exposing (Model, Msg(..), Status(..))
import Debug
import Page exposing (Page(..))
import Boards.Model as Boards


update : Msg -> Model -> ( ( Model, Cmd Msg ), Status )
update msg model =
    case Debug.log "MessageLogin" msg of
        SignIn ->
            let
                state_ =
                    if (checkLogin model.username model.password) then
                        Successful
                    else
                        Fail
            in
                ( ( { model | status = state_ }
                  , Cmd.none
                  )
                , state_
                )

        SignOut ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , None
            )

        Register ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , None
            )

        SetUsername usr ->
            ( ( { model | username = Just usr }
              , Cmd.none
                -- , Maybe.Nothing
              )
            , None
            )

        SetPassword pss ->
            ( ( { model | password = Just pss }
              , Cmd.none
                -- , Maybe.Nothing
              )
            , None
            )

        CannotLogin ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , Fail
            )

        SuccessfulLogin ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , None
            )


checkLogin : Maybe String -> Maybe String -> Bool
checkLogin usr pass =
    case Debug.log "MessageLoginCheck" ( usr, pass ) of
        ( Just u, Just p ) ->
            if u == "user" && p == "pass" then
                True
            else
                False

        ( _, Nothing ) ->
            False

        ( Nothing, _ ) ->
            False
