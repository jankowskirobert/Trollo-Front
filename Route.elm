module Route exposing (Route(..), Page(..))

import Boards
import BoardDetails
import BoardTask
import Html exposing (Attribute)
import Html.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


-- ROUTING --


type Page
    = BoardsPage
    | BoardDetailsPage
    | PageNotFound


type Route
    = Boards
    | BoardDetails String
