module Page exposing (Page(..), pageToString)


type Page
    = BoardsPage
    | BoardDetailsPage
    | PageNotFound


pageToString : Page -> String
pageToString page =
    case page of
        BoardsPage ->
            ""

        BoardDetailsPage ->
            "#board"

        PageNotFound ->
            "#404"
