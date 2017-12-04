module MyDialog exposing (Config, view, map, mapMaybe, DialogSize(Small, Medium, Large))

--UKRADŁEM I PRZEROBIŁEM

import Exts.Html.Bootstrap exposing (..)
import Exts.Maybe exposing (maybe, isJust)
import Html
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Maybe exposing (andThen)


type DialogSize
    = Small
    | Medium
    | Large


view : Maybe (Config msg) -> Html msg
view maybeConfig =
    let
        displayed =
            isJust maybeConfig

        modalClass =
            case maybeConfig of
                Nothing ->
                    "modal-dialog"

                Just x ->
                    case x.sizeOf of
                        Nothing ->
                            "modal-dialog"

                        Just y ->
                            case y of
                                Small ->
                                    "modal-dialog modal-sm"

                                Medium ->
                                    "modal-dialog"

                                Large ->
                                    "modal-dialog modal-lg"
    in
        div
            (case
                maybeConfig
                    |> Maybe.andThen .containerClass
             of
                Nothing ->
                    []

                Just containerClass ->
                    [ class containerClass ]
            )
            [ div
                ([ classList
                    [ ( "modal", True )
                    , ( "in", displayed )
                    ]
                 , style
                    [ ( "display"
                      , if displayed then
                            "block"
                        else
                            "none"
                      )
                    ]
                 ]
                )
                [ div [ class modalClass ]
                    [ div [ class "modal-content" ]
                        (case maybeConfig of
                            Nothing ->
                                [ empty ]

                            Just config ->
                                [ wrapHeader config.closeMessage config.header
                                , maybe empty wrapBody config.body
                                , maybe empty wrapFooter config.footer
                                ]
                        )
                    ]
                ]
            , backdrop maybeConfig
            ]


wrapHeader : Maybe msg -> Maybe (Html msg) -> Html msg
wrapHeader closeMessage header =
    if closeMessage == Nothing && header == Nothing then
        empty
    else
        div [ class "modal-header" ]
            [ maybe empty closeButton closeMessage
            , Maybe.withDefault empty header
            ]


closeButton : msg -> Html msg
closeButton closeMessage =
    button [ class "close", onClick closeMessage ]
        [ text "x" ]


wrapBody : Html msg -> Html msg
wrapBody body =
    div [ class "modal-body" ]
        [ body ]


wrapFooter : Html msg -> Html msg
wrapFooter footer =
    div [ class "modal-footer" ]
        [ footer ]


backdrop : Maybe (Config msg) -> Html msg
backdrop config =
    div [ classList [ ( "modal-backdrop in", isJust config ) ] ]
        []


{-| The configuration for the dialog you display. The `header`, `body`
and `footer` are all `Maybe (Html msg)` blocks. Those `(Html msg)` blocks can
be as simple or as complex as any other view function.
Use only the ones you want and set the others to `Nothing`.
The `closeMessage` is an optional `Signal.Message` we will send when the user
clicks the 'X' in the top right. If you don't want that X displayed, use `Nothing`.
-}
type alias Config msg =
    { closeMessage : Maybe msg
    , containerClass : Maybe String
    , header : Maybe (Html msg)
    , body : Maybe (Html msg)
    , footer : Maybe (Html msg)
    , sizeOf : Maybe DialogSize
    }


{-| This function is useful when nesting components with the Elm
Architecture. It lets you transform the messages produced by a
subtree.
-}
map : (a -> b) -> Config a -> Config b
map f config =
    { closeMessage = Maybe.map f config.closeMessage
    , containerClass = config.containerClass
    , header = Maybe.map (Html.map f) config.header
    , body = Maybe.map (Html.map f) config.body
    , footer = Maybe.map (Html.map f) config.footer
    , sizeOf = Just Medium
    }


{-| For convenience, a varient of `map` which assumes you're dealing with a `Maybe (Config a)`, which is often the case.
-}
mapMaybe : (a -> b) -> Maybe (Config a) -> Maybe (Config b)
mapMaybe =
    Maybe.map << map
