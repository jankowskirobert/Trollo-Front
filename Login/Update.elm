module Login.Update exposing (update)

import Login.Model exposing (Model, Msg(..), Status(..))
import Debug
import Page exposing (Page(..))
import Boards.Model as Boards
import Base64
import Json.Decode
import Json.Encode
import Http
import BoardTask


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

        PostLogin (Err error) ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , None
            )

        PostLogin (Ok token) ->
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


decodeToken : Json.Decode.Decoder BoardTask.AuthToken
decodeToken =
    Json.Decode.map
        BoardTask.AuthToken
        (Json.Decode.field "token" Json.Decode.string)


encodeLogin : String -> String -> Json.Encode.Value
encodeLogin user pass =
    let
        val =
            [ ( "username", Json.Encode.string user )
            , ( "password", Json.Encode.string pass )
            ]
    in
        val
            |> Json.Encode.object


loginToApi : String -> String -> Cmd Msg
loginToApi user pass =
    let
        url =
            "http://0.0.0.0:8000/login/"

        req =
            Http.request
                { body = (Http.jsonBody (encodeLogin user pass))
                , expect = Http.expectJson decodeToken
                , method = "POST"
                , headers = []
                , timeout = Nothing
                , url = url
                , withCredentials = False
                }

        -- req =
        --     Http.post url (Http.jsonBody (encodBoardView board)) decodeBoard
    in
        Http.send PostLogin req
