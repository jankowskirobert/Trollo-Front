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


init : Location -> ( Model, Cmd Msg )
init location =
    { mdl = Material.model
    , boards = BoardsModule.model
    , activePage = Router.BoardsPage BoardsModule.model
    }
        |> urlUpdate location


type
    Msg
    -- = Mdl (Material.Msg Msg)
    = BoardsMsg BoardsModule.Msg
    | UrlChanged Location


type alias Model =
    { mdl : Material.Model
    , activePage : Router.Page
    , boards : BoardsModule.Model
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChanged newLocation ->
            urlUpdate newLocation model

        BoardsMsg msg ->
            let
                result =
                    BoardsModule.update msg model.boards
            in
                ( { model | boards = Tuple.first result }
                , Cmd.none
                )



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
    let
        boardsModel =
            model.boards
    in
        case model.activePage of
            Router.BoardsPage z ->
                Html.map BoardsMsg (BoardsModule.view model.boards)

            Router.BoardDetailsPage z ->
                div [] []


urlUpdate : Location -> Model -> ( Model, Cmd Msg )
urlUpdate newLocation model =
    case Router.fromLocation newLocation of
        Nothing ->
            ( model
            , Router.modifyUrl model.activePage
            )

        Just validRoute ->
            if Router.isEqual validRoute model.activePage then
                ( model, Cmd.none )
            else
                case validRoute of
                    Router.Boards ->
                        ( { model | activePage = Router.BoardsPage model.boards }
                        , Cmd.none
                        )

                    Router.BoardDetails name ->
                        ( model
                        , Cmd.none
                        )


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    case current.activePage of
        BoardsPage z ->
            Just <| UrlChange NewEntry "/#boards"

        BoardDetailsPage z ->
            Just <| UrlChange NewEntry "/#board"


location2messages : Location -> List Msg
location2messages location =
    case location.hash of
        "" ->
            [ SetActivePage BoardsPage ]

        "#boards" ->
            [ SetActivePage BoardDetailsPage ]

        "#board" ->
            [ SetActivePage MyAccount ]
