module Page exposing (Page(..))

import BoardTask
import Boards.Model as Boards
import BoardDetails.Model as BoardDetails
import Login.Model as Login
import Register.Model as Register


type Page
    = BoardsPage Boards.Model
    | BoardDetailsPage BoardTask.BoardView BoardDetails.Model
    | LoginPage Login.Model
    | LogoutPage
    | RegisterPage Register.Model
    | PageNotFound
