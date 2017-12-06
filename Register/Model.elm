module Register.Model exposing (Model, Msg(..), Status(..))


type alias Model =
    { username : Maybe String
    , password : Maybe String
    , passwordConfirm : Maybe String
    , status : Status
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
