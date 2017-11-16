module App.Model exposing (..)

import Boards.Model as Boards exposing (Model, model, Msg(..))
import Page as Router exposing (Page(..))
import Navigation exposing (Location)
import RouteUrl exposing (HistoryEntry(..), UrlChange)
import BoardTask
import BoardDetails.Model as BoardDetails
import Boards.Update as Bb


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( { boards = Boards.model
      , activePage = Router.BoardsPage
      , user = BoardTask.model
      , boardDetails = BoardDetails.model
      }
    , Cmd.map BoardsMsg Bb.getBoardView
    )


type Msg
    = BoardsMsg Boards.Msg
    | BoardDetailsMsg BoardDetails.Msg
    | SetActivePage Router.Page
    | GoHome Int


type alias Model =
    { activePage : Router.Page
    , user : BoardTask.User
    , boards : Boards.Model
    , boardDetails : BoardDetails.Model
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
