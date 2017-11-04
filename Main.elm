module Main exposing (..)

import Html.Lazy
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Boards
import Material.Dialog as Dialog
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Options as Options
import Material


-- import Json.Encode as Encode
-- import Json.Decode
-- import Json.Decode.Pipeline as JDP exposing (required)
-- import Task

import Http


main : Program Never Model Msg
main =
    Html.program { view = view, update = update, subscriptions = subscriptions, init = init }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


initModel : Model
initModel =
    { mdl = Material.model
    , boards = Boards.model
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


type Msg
    = BoardsMsg Boards.Msg
    | Mdl (Material.Msg Msg)


type alias Model =
    { mdl : Material.Model
    , boards : Boards.Model
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardsMsg msg ->
            ( model, Cmd.none )

        Mdl action_ ->
            Material.update Mdl action_ model



-- Refresh (Ok newResponse) ->
--   (newResponse, Cmd.none)
-- Refresh (Err _) ->
--   (model, Cmd.none)
-- view model =
--   div []
--     [ button [ onClick Decrement ] [ text "-" ]
--     , div [] [ text (toString model) ]
--     , button [ onClick Increment ] [ text "+" ]
--     ]
--  <article class="card">
--         <header>Drag and Drop CSS</header>
--         <div class="detail">1/2</div>
--       </article>


view : Model -> Html Msg
view =
    Html.Lazy.lazy view_


view_ : Model -> Html Msg
view_ model =
    div [] []
