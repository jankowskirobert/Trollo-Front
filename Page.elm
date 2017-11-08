module Page exposing (Page(..), pageToString)

import BoardTask


type Page
    = BoardsPage
    | BoardDetailsPage
    | PageNotFound


pageToString : Page -> String
pageToString page =
    case page of
        BoardsPage ->
            "#boards"

        BoardDetailsPage ->
            "#board"

        PageNotFound ->
            "#404"
