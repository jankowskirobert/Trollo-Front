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


update : Msg -> Model -> ( ( Model, Cmd Msg ), Maybe BoardTask.AuthToken )
update msg model =
    case Debug.log "MessageLogin" msg of
        SignIn ->
            case ( model.username, model.password ) of
                ( Just u, Just p ) ->
                    ( ( model
                      , loginToApi u p
                      )
                    , Maybe.Nothing
                    )

                ( _, Nothing ) ->
                    ( ( model
                      , Cmd.none
                        -- , Maybe.Nothing
                      )
                    , Maybe.Nothing
                    )

                ( Nothing, _ ) ->
                    ( ( model
                      , Cmd.none
                        -- , Maybe.Nothing
                      )
                    , Maybe.Nothing
                    )

        SignOut ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , Maybe.Nothing
            )

        Register ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , Maybe.Nothing
            )

        SetUsername usr ->
            ( ( { model | username = Just usr }
              , Cmd.none
                -- , Maybe.Nothing
              )
            , Maybe.Nothing
            )

        SetPassword pss ->
            ( ( { model | password = Just pss }
              , Cmd.none
                -- , Maybe.Nothing
              )
            , Maybe.Nothing
            )

        CannotLogin ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , Maybe.Nothing
            )

        SuccessfulLogin ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , Maybe.Nothing
            )

        PostLogin (Err error) ->
            ( ( model
              , Cmd.none
                -- , Maybe.Nothing
              )
            , Maybe.Nothing
            )

        PostLogin (Ok token) ->
            ( ( { model | token = Just token }
              , Cmd.none
                -- , Maybe.Nothing
              )
            , Just token
            )


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
            "http://0.0.0.0:8000/authorise/"

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
