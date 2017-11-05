module Main exposing (..)

import App exposing (Msg, view, init, update, subscriptions, Model)
import RouteUrl exposing (RouteUrlProgram)


main : RouteUrlProgram Never Model Msg
main =
    RouteUrl.program
        { delta2url = App.delta2url
        , location2messages = App.location2messages
        , init = App.init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
