module App exposing (..)

import Html.Lazy
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Boards as BoardsModule
import Material.Dialog as Dialog
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options
import Material
import BoardDetails
import Route as Router exposing (Route(..), Page(..))
import Navigation exposing (Location)
import RouteUrl exposing (HistoryEntry(..), UrlChange)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( { mdl = Material.model
      , boards = BoardsModule.model
      , activePage = Router.BoardsPage
      }
    , Cmd.none
    )


type Msg
    = BoardsMsg BoardsModule.Msg
    | SetActivePage Router.Page


type alias Model =
    { mdl : Material.Model
    , activePage : Router.Page
    , boards : BoardsModule.Model
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardsMsg msg ->
            let
                result =
                    BoardsModule.update msg model.boards
            in
                ( { model | boards = Tuple.first result }
                , Cmd.none
                )

        SetActivePage page ->
            ( { model | activePage = page }, Cmd.none )



-- Mdl action_ ->
--     Material.update Mdl action_ model
-- case msg of
--     SetActivePage page ->
--         ( { model | activePage = page }, Cmd.none )
--     Mdl action_ ->
--         Material.update Mdl action_ model


view : Model -> Html Msg
view =
    Html.Lazy.lazy view_


view_ : Model -> Html Msg
view_ model =
    case model.activePage of
        Router.BoardsPage ->
            Html.map BoardsMsg (BoardsModule.view model.boards)

        Router.BoardDetailsPage ->
            div [] [ text " details" ]

        PageNotFound ->
            div [] [ text "404" ]


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    case current.activePage of
        BoardsPage ->
            Just <| UrlChange NewEntry ""

        BoardDetailsPage ->
            Just <| UrlChange NewEntry "/#board"

        PageNotFound ->
            Just <| UrlChange NewEntry "/#404"


location2messages : Location -> List Msg
location2messages location =
    case location.hash of
        "" ->
            [ SetActivePage BoardsPage ]

        "#board" ->
            [ SetActivePage BoardDetailsPage ]

        _ ->
            [ SetActivePage PageNotFound ]
