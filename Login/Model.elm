module Login.Model exposing (Model, Msg(..), Status(..), model)

import Http
import BoardTask


type alias Model =
    { username : Maybe String
    , password : Maybe String
    , passwordConfirm : Maybe String
    , status : Status
    , token : Maybe BoardTask.AuthToken
    }


model : Model
model =
    { username = Maybe.Nothing
    , password = Maybe.Nothing
    , passwordConfirm = Maybe.Nothing
    , status = None
    , token = Maybe.Nothing
    }


type Status
    = Successful
    | Fail
    | None


type Msg
    = SignIn
    | SignOut
    | Register
    | SetUsername String
    | SetPassword String
    | CannotLogin
    | SuccessfulLogin
    | PostLogin (Result Http.Error BoardTask.AuthToken)
