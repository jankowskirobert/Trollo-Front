module App.Model exposing (..)

import Boards.Model as Boards exposing (Model, model, Msg(..))
import Page as Router exposing (Page(..))
import Navigation exposing (Location)
import BoardTask
import BoardDetails.Model as BoardDetails
import Boards.Update as Bb
import Boards.Rest as Rest
import BoardDetails.Rest as CardRest
import Login.Model as Login
import Login.View as LoginView


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( { boards = Boards.model
      , activePage = Router.BoardsPage
      , user = BoardTask.model
      , boardDetails = BoardDetails.model
      , login = Login.Model Maybe.Nothing Maybe.Nothing Maybe.Nothing
      }
    , Cmd.batch
        [ (Cmd.map BoardsMsg (Cmd.map RestMsg Rest.getBoardView))
        , (Cmd.map BoardDetailsMsg (Cmd.map BoardDetails.RestCardMsg CardRest.getCardsView))

        -- , (Cmd.map LoginMsg (Cmd.map Login.RestCardMsg CardRest.getCardsView))
        ]
    )


type Msg
    = BoardsMsg Boards.Msg
    | BoardDetailsMsg BoardDetails.Msg
    | LoginMsg Login.Msg
    | SetActivePage Router.Page
    | GoHome Int


type alias Model =
    { activePage : Router.Page
    , user : BoardTask.User
    , boards : Boards.Model
    , boardDetails : BoardDetails.Model
    , login : Login.Model
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
