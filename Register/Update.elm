module Register.Update exposing (update)

import Page exposing (..)
import Register.Model exposing (Model, Msg(..), Status(..))
import Debug
import Json.Decode
import Json.Encode
import Http
import BoardTask
import Login.Model as Login


update : Msg -> Model -> ( Model, Cmd Msg, Maybe Status )
update msg model =
    case Debug.log "MessageRegister" msg of
        Cancel ->
            ( model, Cmd.none, Maybe.Nothing )

        Register ->
            ( model, loginToApi model.username model.password, Maybe.Nothing )

        SetUsername usr ->
            ( { model | username = usr }, Cmd.none, Maybe.Nothing )

        SetPassword pss ->
            ( { model | password = pss }, Cmd.none, Maybe.Nothing )

        ConfirmPassword pssCnf ->
            ( { model | email = pssCnf }, Cmd.none, Maybe.Nothing )

        PostRegister (Ok _) ->
            ( model, Cmd.none, Just Successful )

        PostRegister (Err err) ->
            ( model, Cmd.none, Maybe.Nothing )


encodeLogin : String -> String -> Json.Encode.Value
encodeLogin user pass =
    let
        val =
            [ ( "username", Json.Encode.string user )
            , ( "email", Json.Encode.string user )
            , ( "password", Json.Encode.string pass )
            ]
    in
        val
            |> Json.Encode.object


loginToApi : String -> String -> Cmd Msg
loginToApi user pass =
    let
        url =
            "http://0.0.0.0:8000/register/"

        req =
            Http.request
                { body = (Http.jsonBody (encodeLogin user pass))
                , expect = Http.expectStringResponse (\_ -> Ok ())
                , method = "POST"
                , headers = []
                , timeout = Nothing
                , url = url
                , withCredentials = False
                }

        -- req =
        --     Http.post url (Http.jsonBody (encodBoardView board)) decodeBoard
    in
        Http.send PostRegister req
