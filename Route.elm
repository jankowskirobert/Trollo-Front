module Route exposing (Route(..), Page(..), href, newUrl, modifyUrl, fromLocation, isEqual)

import Boards
import BoardDetails
import BoardTask
import Html exposing (Attribute)
import Html.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


-- ROUTING --


type Page
    = BoardsPage Boards.Model
    | BoardDetailsPage BoardDetails.Model


type Route
    = Boards
    | BoardDetails String


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Boards (s "")
        , Url.map BoardDetails (s "board" </> string)
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Boards ->
                    [ "login" ]

                BoardDetails boardName ->
                    [ "profile", boardName ]
    in
        "#/" ++ String.join "/" pieces



-- PUBLIC HELPERS --


toRoute : Page -> Route
toRoute page =
    case page of
        BoardsPage _ ->
            Boards

        BoardDetailsPage model ->
            BoardDetails model.data.title


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


newUrl : Page -> Cmd msg
newUrl =
    Navigation.newUrl << routeToString << toRoute



-- modifyUrl : Route -> Cmd msg
-- modifyUrl =
--     routeToString >> Navigation.modifyUrl


modifyUrl : Page -> Cmd msg
modifyUrl =
    Navigation.modifyUrl << routeToString << toRoute


fromLocation : Location -> Maybe Route
fromLocation location =
    parseHash route location


isEqual : Route -> Page -> Bool
isEqual urlPage page =
    urlPage == toRoute page
