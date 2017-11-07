module Page exposing (Page(..), pageToString)

import BoardTask


type Page
    = Home
    | BoardsPage
    | BoardDetailsPage
    | PageNotFound


pageToString : Page -> String
pageToString page =
    case page of
        Home ->
            ""

        BoardsPage ->
            "#boards"

        BoardDetailsPage ->
            "#board"

        PageNotFound ->
            "#404"
