module Login.View exposing (view)

import Login.Model exposing (Model, Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


--	  <button class="btn btn-lg btn-primary btn-block"  name="Submit" value="Login" type="Submit">Login</button>


view : Model -> Html Msg
view model =
    div [] [ loginForm ]


heading : Attribute msg
heading =
    style
        [ ( " text-align", "center" )
        , ( "margin-bottom", "30px" )
        ]


loginForm : Html Msg
loginForm =
    div [ class "wrapper" ]
        [ Html.form []
            [ h3 [ heading ] [ text "Welcome Back! Please Sign In" ]
            , hr [] []
            , input [ placeholder ("Enter username "), onInput SetUsername ] []
            , input [ placeholder ("Enter password "), onInput SetPassword ] []
            , button
                [ class "btn btn-success"
                , onClick (SingIn)
                ]
                [ text "Sing in" ]
            ]
        ]
