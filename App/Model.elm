module App.Model exposing (..)

import Boards as BoardsModule
import BoardDetails
import Page as Router exposing (Page(..))
import Navigation exposing (Location)
import RouteUrl exposing (HistoryEntry(..), UrlChange)
import Material


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( { boards = BoardsModule.model
      , activePage = Router.BoardsPage
      , boardDetails = BoardDetails.model
      , mdl = Material.model
      }
    , Cmd.none
    )


type Msg
    = BoardsMsg BoardsModule.Msg
    | BoardDetailsMsg BoardDetails.Msg
    | SetActivePage Router.Page
    | Mdl (Material.Msg Msg)


type alias Model =
    { activePage : Router.Page
    , boards : BoardsModule.Model
    , boardDetails : BoardDetails.Model
    , mdl : Material.Model
    }



-- delta2url : Model -> Model -> Maybe UrlChange
-- delta2url previous current =
--     case current.activePage of
--         BoardsPage ->
--             Just <| UrlChange NewEntry "/#boards"
--         BoardDetailsPage ->
--             Just <| UrlChange NewEntry "/#board"
--         PageNotFound ->
--             Just <| UrlChange NewEntry "/#404"
--         Home ->
--             Just <| UrlChange NewEntry ""
-- location2messages : Location -> List Msg
-- location2messages location =
--     case location.hash of
--         "" ->
--             [ SetActivePage BoardsPage ]
--         "#boards" ->
--             [ SetActivePage BoardsPage ]
--         "#board" ->
--             [ SetActivePage BoardDetailsPage ]
--         _ ->
--             [ SetActivePage PageNotFound ]
