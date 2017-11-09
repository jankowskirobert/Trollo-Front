module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html


-- model


type alias Model =
    { username : String
    , password : String
    }


initModel : Model
initModel =
    { username = ""
    , password = ""
    }



-- update


type Msg
    = UsernameInput String
    | PasswordInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UsernameInput username ->
            { model | username = username }

        PasswordInput password ->
            { model | password = password }



-- view


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Login Page... So far" ]
        , Html.form []
            [ input
                [ type_ "text"
                , onInput UsernameInput
                , placeholder "Username"
                ]
                []
            , input
                [ type_ "password"
                , onInput PasswordInput
                , placeholder "Password"
                ]
                []
            , input [ type_ "submit" ]
                [ text "Login" ]
            ]
        , hr [] []
        , h4 [] [ text "Login model : " ]
        , p [] [ text <| toString model ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }