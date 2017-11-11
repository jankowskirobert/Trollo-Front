module App.View exposing (..)

import Html.Lazy
import App.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page exposing (..)
import Boards.View as Boards exposing (view)
import Material.Options as Options exposing (css, when)
import BoardDetails.View as BoardDetails
import Material.Layout as Layout
import Material.Icon as Icon
import Material.Color as Color


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
                    Html.map BoardsMsg (Boards.view model.boards)

                BoardDetailsPage ->
                    Html.map BoardDetailsMsg (BoardDetails.view model.boardDetails)

                -- (BoardDetails.view { data_ | data = board })
                PageNotFound ->
                    div [] [ text "404" ]
    in
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.onSelectTab GoHome
            ]
            { header = header model
            , drawer = []
            , tabs = ( [ text "Boards" ], [ Color.background (Color.color Color.Teal Color.S400) ] )
            , main = [ h_ ]
            }


header : Model -> List (Html Msg)
header model =
    [ Layout.row
        [ css "transition" "height 333ms ease-in-out 0s"
        , css "padding" "2rem"
        ]
        [ Layout.title [] [ text "Trollo" ]
        , Layout.spacer
        , Layout.navigation []
            [ Layout.link
                [-- Options.onClick ToggleHeader
                ]
                [ Icon.i "photo" ]
            ]
        ]
    ]
