module Main exposing (..)

import App exposing (Msg, view, init, update, subscriptions, Model)
import RouteUrl exposing (RouteUrlProgram)


main : RouteUrlProgram Never Model Msg
main =
    RouteUrl.program
        { delta2url = ExampleViewer.delta2url
        , location2messages = ExampleViewer.url2messages
        , init = ExampleViewer.init
        , update = ExampleViewer.update
        , view = ExampleViewer.view
        , subscriptions = ExampleViewer.subscriptions
        }
