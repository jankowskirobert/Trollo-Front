module App.View exposing (..)

import Html.Lazy
import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page exposing (..)
import Boards.View as Boards exposing (view)
import BoardDetails.View as BoardDetails
import Material.Options as Options exposing (css, when)
import Material.Layout as Layout

tabs : List (Model -> Html Msg)
tabs =
    [ (.boards >> Boards.view >> Html.map BoardsMsg)
    ]


view : Model -> Html Msg
view =
    Html.Lazy.lazy view_


view_ : Model -> Html Msg
view_ model =
    let
        h_ =
            case model.activePage of
                BoardsPage ->
                    div [] [ Html.map BoardsMsg (Boards.view model.boards) ]

                BoardDetailsPage ->
                    -- Html.map BoardDetailsMsg (BoardDetails.view model.boardDetails)
                    div [] [ Html.map BoardDetailsMsg (BoardDetails.view model.boardDetails) ]

                -- (BoardDetails.view { data_ | data = board })
                PageNotFound ->
                    div [] [ text "404" ]

                LoginPage ->
                    div [] [ text "login" ]

                LogoutPage ->
                    div [] [ text "login" ]
    in
        div [headerStyle]
            [ header model, h_ ]
            --[ button [ onClick (GoHome 1) ] [ text "Go Home" ], h_ ]


header : Model -> Html Msg
header model =
    div  []
    [Layout.row
        [ css "transition" "height 333ms ease-in-out 0s"
        , css "height" "74px"
        , css "padding" "0rem"
        ]
        [ Layout.title [] [ button [ onClick (GoHome 1), headerButtonStyle] [ img [ src "logo.png", width 180, height 74] [] ] ]
        , Layout.spacer]]


headerStyle : Attribute msg
headerStyle =
  style
    [ ("backgroundColor", "white")
    , ("height", "74px")
    , ("width", "100%")
    ]

headerButtonStyle : Attribute msg
headerButtonStyle =
  style
    [ ("backgroundColor", "Transparent")
    , ("border", "none")
    , ("overflow","hidden")
    , ("outline","none")
    ]