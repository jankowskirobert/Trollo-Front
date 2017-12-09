module App.View exposing (..)

import Html.Lazy
import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page exposing (..)
import Boards.View as Boards exposing (view)
import BoardDetails.View as BoardDetails
import Login.View as Login
import Register.View as Register
import BoardTask


-- view : Model -> Html Msg
-- view =
--     Html.Lazy.lazy view_


view : Model -> Html Msg
view model =
    let
        h_ =
            case model.activePage of
                BoardsPage ->
                    div [] [ Html.map BoardsMsg (Boards.view model.boardsModel) ]

                BoardDetailsPage subModel ->
                    -- Html.map BoardDetailsMsg (BoardDetails.view model.boardDetails)
                    -- div [] [ Html.map BoardDetailsMsg (BoardDetails.view subModel) ]
                    div [] []

                -- (BoardDetails.view { data_ | data = board })
                PageNotFound ->
                    div [] [ text "404" ]

                LoginPage ->
                    div [] [ Html.map LoginMsg (Login.view model.loginModel) ]

                LogoutPage ->
                    div [] [ text "login" ]

                RegisterPage ->
                    -- div [] [ Html.map RegisterMsg (Register.view subModel) ]
                    div [] []
    in
        div [ headerStyle ]
            [ testLogin model.user
            , button [ onClick (SetActivePage Page.LoginPage) ] [ text "Login" ]
            , button [ onClick (SetActivePage Page.BoardsPage) ] [ text "Boards" ]
            , h_
            ]



--[ button [ onClick (GoHome 1) ] [ text "Go Home" ], h_ ]


testLogin : BoardTask.User -> Html Msg
testLogin x =
    case x.status of
        True ->
            div [] [ text "USER FOUND" ]

        False ->
            div [] [ text "USER NOT FOUND #2" ]



-- header : Model -> Html Msg
-- header model =
--     div []
--         [ Layout.row
--             [ css "transition" "height 333ms ease-in-out 0s"
--             , css "height" "74px"
--             , css "padding" "0rem"
--             ]
--             [ Layout.title []
--                 [ button
--                     [ headerButtonStyle
--                     ]
--                     [ img
--                         [ src "logo.png"
--                         , width 180
--                         , height 74
--                         ]
--                         []
--                     ]
--                 , testLogin model.user
--                 ]
--             , Layout.spacer
--             ]
--         ]


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
