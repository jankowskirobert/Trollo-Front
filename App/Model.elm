module App.Model exposing (..)

import Boards as BoardsModule
import BoardDetails
import Material
import Page as Router exposing (Page(..))
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
      , boardDetails = BoardDetails.model
      }
    , Cmd.none
    )


type Msg
    = BoardsMsg BoardsModule.Msg
    | BoardDetailsMsg BoardDetails.Msg
    | SetActivePage Router.Page


type alias Model =
    { mdl : Material.Model
    , activePage : Router.Page
    , boards : BoardsModule.Model
    , boardDetails : BoardDetails.Model
    }


delta2url : Model -> Model -> Maybe UrlChange
delta2url previous current =
    case current.activePage of
        BoardsPage ->
            Just <| UrlChange NewEntry "/#boards"

        BoardDetailsPage ->
            Just <| UrlChange NewEntry "/#board"

        PageNotFound ->
            Just <| UrlChange NewEntry "/#404"

        Home ->
            Just <| UrlChange NewEntry ""


location2messages : Location -> List Msg
location2messages location =
    case location.hash of
        "" ->
            [ SetActivePage BoardsPage ]

        "#boards" ->
            [ SetActivePage BoardsPage ]

        "#board" ->
            [ SetActivePage BoardDetailsPage ]

        _ ->
            [ SetActivePage PageNotFound ]
