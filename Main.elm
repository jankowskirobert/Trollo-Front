module Main exposing (..)

import App.Model exposing (Msg, init, subscriptions, Model)
import App.View exposing (view)
import App.Update exposing (update)
import Html


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
