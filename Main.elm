module Main exposing (..)

import App.Model exposing (Msg, init, subscriptions, Model, delta2url, location2messages)
import App.View exposing (view)
import App.Update exposing (update)
import RouteUrl exposing (RouteUrlProgram)


main : RouteUrlProgram Never Model Msg
main =
    RouteUrl.program
        { delta2url = delta2url
        , location2messages = location2messages
        , init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
