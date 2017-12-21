module Register.Model exposing (Model, Msg(..), Status(..), model)

import Http
import Result


type alias Model =
    { username : String
    , password : String
    , email : String
    }


model : Model
model =
    { username = ""
    , password = ""
    , email = ""
    }


type Status
    = Successful
    | Fail
    | None


type Msg
    = Cancel
    | Register
    | SetUsername String
    | SetPassword String
    | ConfirmPassword String
    | PostRegister (Result Http.Error ())
