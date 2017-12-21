module Register.View exposing (view)

import Register.Model exposing (Model, Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


--	  <button class="btn btn-lg btn-primary btn-block"  name="Submit" value="Login" type="Submit">Login</button>


view : Model -> Html Msg
view model =
    div [] [ registerForm ]


heading : Attribute msg
heading =
    style
        [ ( " text-align", "center" )
        , ( "padding-top", "15px" )
        , ( "padding-left", "15px" )
        , ( "padding-right", "15px" )
        , ( "color", "white" )
        ]


registerForm : Html Msg
registerForm =
    div [ registerFormStyle ]
        [ Html.form [ onSubmit Register ]
            [ h3 [ heading ] [ text "Hello kid! Wanna register?" ]
            , hr [] []
            , input [ inputStyle, placeholder ("Enter username "), onInput SetUsername ] []
            , p [] []
            , input [ inputStyle, placeholder ("Enter password "), onInput SetPassword ] []
            , p [] []
            , button
                [ registerButtonStyle
                ]
                [ text "Register" ]
            ]
        ]


registerFormStyle : Attribute msg
registerFormStyle =
    style
        [ ( "margin", "auto" )
        , ( "color", "#646464" )
        , ( "backgroundColor", "#3D88BF" )
        , ( "width", "230px" )
        , ( "height", "300px" )
        , ( "margin-top", "30px" )
        ]


inputStyle : Attribute msg
inputStyle =
    style
        [ ( " text-align", "center" )
        , ( "margin-left", "30px" )
        , ( "margin-top", "8px" )
        ]


registerButtonStyle : Attribute msg
registerButtonStyle =
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
