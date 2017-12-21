module Login.View exposing (view)

import Login.Model exposing (Model, Msg(..), Status(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


--	  <button class="btn btn-lg btn-primary btn-block"  name="Submit" value="Login" type="Submit">Login</button>


view : Model -> Html Msg
view model =
    div [] [ loginForm model ]


heading : Attribute msg
heading =
    style
        [ ( " text-align", "center" )
        , ( "padding-top", "15px" )
        , ( "padding-left", "15px" )
        , ( "padding-right", "15px" )
        , ( "color", "white" )
        ]


loginForm : Model -> Html Msg
loginForm model =
    let
        title =
            case model.status of
                Fail ->
                    "Fail - not found"

                Successful ->
                    "OK"

                None ->
                    "NONE"
    in
        div []
            [ Html.form [ onSubmit SignIn, loginFormStyle ]
                [ h3 [] [ text ("Welcome Back! Please Sign In " ++ title) ]
                , hr [] []
                , input
                    [ placeholder ("Enter username ")
                    , onInput SetUsername
                    ]
                    []
                , p [] []
                , input
                    [ type_ "password"
                    , placeholder ("Enter password ")
                    , onInput SetPassword
                    ]
                    []
                , p [] []
                , button
                    []
                    [ text "Sign in" ]
                ]
            ]


loginFormStyle : Attribute msg
loginFormStyle =
    style
        [ ( "margin", "auto" )
        , ( "color", "#646464" )
        , ( "backgroundColor", "#3D88BF" )
        , ( "width", "230px" )
        , ( "height", "250px" )
        , ( "margin-top", "30px" )
        ]


inputStyle : Attribute msg
inputStyle =
    style
        [ ( " text-align", "center" )
        , ( "margin-left", "30px" )
        , ( "margin-top", "8px" )
        ]


loginButtonStyle : Attribute msg
loginButtonStyle =
    style
        [ ( "color", "#646464" )
        , ( "backgroundColor", "#E3EBEE" )
        , ( "font-size", "16" )
        , ( "border", "none" )
        , ( "overflow", "hidden" )
        , ( "outline", "none" )
        , ( "height", "30px" )
        , ( "margin-left", "32px" )
        , ( "margin-top", "8px" )
        , ( "webkit-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "moz-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        , ( "box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)" )
        ]
