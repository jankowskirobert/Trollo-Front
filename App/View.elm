module App.View exposing (..)

import Html.Lazy
import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page exposing (..)
import Boards.View as Boards exposing (view)
import Boards.Model as BoardsModel
import BoardDetails.View as BoardDetails
import Login.View as Login
import Login.Model as LoginModel
import Register.View as Register
import Register.Model as RegisterModel
import BoardTask


-- view : Model -> Html Msg
-- view =
--     Html.Lazy.lazy view_


view : Model -> Html Msg
view model =
    let
        h_ =
            case model.activePage of
                BoardsPage subModel ->
                    div [] [ Html.map BoardsMsg (Boards.view subModel) ]

                BoardDetailsPage view subModel ->
                    -- Html.map BoardDetailsMsg (BoardDetails.view model.boardDetails)
                    div [] [ Html.map BoardDetailsMsg (BoardDetails.view view subModel) ]

                -- div [] []
                -- (BoardDetails.view { data_ | data = board })
                PageNotFound ->
                    div [] [ text "404" ]

                LoginPage subModel ->
                    div [] [ Html.map LoginMsg (Login.view subModel) ]

                LogoutPage ->
                    div [] [ text "login" ]

                RegisterPage subModel ->
                    div [] [ Html.map RegisterMsg (Register.view subModel) ]
    in
        div [ headerStyle ]
            [ logoBuilder
            , article []
                [ header []
                    [ u [ headerNavigationUl ]
                        [ li
                            [ headerNavigationLi
                            , headerNavigationLiA
                            , headerNavigationLiAHover
                            , onClick (SetActivePage (Page.LoginPage LoginModel.model))
                            ]
                            [ text "Login"
                            ]
                        , li
                            [ headerNavigationLi
                            , headerNavigationLiA
                            , headerNavigationLiAHover
                            , onClick (SetActivePage (Page.BoardsPage BoardsModel.model))
                            ]
                            [ text "Boards"
                            ]
                        , li
                            [ headerNavigationLi
                            , headerNavigationLiA
                            , headerNavigationLiAHover
                            , onClick (SetActivePage (Page.RegisterPage RegisterModel.model))
                            ]
                            [ text "Register"
                            ]
                        ]
                    ]
                , h_
                , footer [] []
                ]
            ]



--[ button [ onClick (GoHome 1) ] [ text "Go Home" ], h_ ]


testLogin : BoardTask.User -> Html Msg
testLogin x =
    case x.status of
        True ->
            let
                token =
                    case x.auth of
                        Nothing ->
                            "ERROR"

                        Just auth ->
                            auth.token
            in
                div [] [ text ("USER FOUND:" ++ token) ]

        False ->
            div [] [ text "USER NOT FOUND #2" ]


logoBuilder : Html Msg
logoBuilder =
    header
        [ style [ ( "transition", "height 333ms ease-in-out 0s" ), ( "height", "74px" ), ( "padding", "0rem" ) ] ]
        [ button
            [ headerButtonStyle
            ]
            [ img
                [ src "logo.png"
                , width 180
                , height 74
                ]
                []
            ]
        ]


headerStyle : Attribute msg
headerStyle =
    style
        [ ( "backgroundColor", "white" )
        , ( "height", "74px" )
        , ( "width", "100%" )
        ]


headerButtonStyle : Attribute msg
headerButtonStyle =
    style
        [ ( "backgroundColor", "Transparent" )
        , ( "border", "none" )
        , ( "overflow", "hidden" )
        , ( "outline", "none" )
        ]


headerNavigationUl : Attribute msg
headerNavigationUl =
    style
        [ ( "list-style-type", "none" )
        , ( "margin", "0" )
        , ( "padding", "0" )
        , ( "overflow", "hidden" )
        , ( "background-color", "#333" )
        ]


headerNavigationLi : Attribute msg
headerNavigationLi =
    style
        [ ( "float", "right" )
        ]


headerNavigationLiA : Attribute msg
headerNavigationLiA =
    style
        [ ( "display", "block" )
        , ( "color", "white" )
        , ( "text-align", "center" )
        , ( "padding", "14px 16px" )
        , ( "text-decoration", "none" )
        ]


headerNavigationLiAHover : Attribute msg
headerNavigationLiAHover =
    style
        [ ( "background-color", "#111" )
        ]



-- <style>
-- ul {
--     list-style-type: none;
--     margin: 0;
--     padding: 0;
--     overflow: hidden;
--     background-color: #333;
-- }
-- li {
--     float: left;
-- }
-- li a {
--     display: block;
--     color: white;
--     text-align: center;
--     padding: 14px 16px;
--     text-decoration: none;
-- }
-- li a:hover {
--     background-color: #111;
-- }
-- </style>
-- </head>
-- <body>
-- <ul>
--   <li><a class="active" href="#home">Home</a></li>
--   <li><a href="#news">News</a></li>
--   <li><a href="#contact">Contact</a></li>
--   <li><a href="#about">About</a></li>
-- </ul>
-- </body>
