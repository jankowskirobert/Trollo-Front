module App.Model exposing (..)

import Boards.Model as Boards exposing (Model, model, Msg(..))
import Navigation exposing (Location)
import BoardTask
import BoardDetails.Model as BoardDetails
import Boards.Update as Bb
import Boards.Rest as Rest
import BoardDetails.Rest as CardRest
import Login.Model as Login
import Login.View as LoginView
import Register.Model as Register
import Register.View as RegisterView
import Page exposing (Page(..))


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( { activePage = (BoardsPage)
      , user = BoardTask.model
      , loginModel = Login.model
      , boardsModel = Boards.model
      }
    , Cmd.batch
        [--(Cmd.map BoardsMsg (Cmd.map RestMsg Rest.getBoardView))
         -- , (Cmd.map BoardDetailsMsg (Cmd.map BoardDetails.RestCardMsg CardRest.getCardsView))
         -- , (Cmd.map LoginMsg (Cmd.map Login.RestCardMsg CardRest.getCardsView))
        ]
    )


type Msg
    = BoardsMsg Boards.Msg
    | BoardDetailsMsg BoardDetails.Msg
    | LoginMsg Login.Msg
    | RegisterMsg Register.Msg
    | SetActivePage Page
    | GoHome Int


type alias Model =
    { activePage : Page
    , user : BoardTask.User
    , loginModel : Login.Model
    , boardsModel : Boards.Model
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
