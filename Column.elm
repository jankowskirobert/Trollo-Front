module Column exposing (..)

import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html exposing (..)
import Material
import Material.Textfield as Textfield
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options
import BoardTask


model : Model
model =
    { data = BoardTask.ColumnView "" []
    , addCard = BoardTask.AddCard "" ""
    , dialogAction = None
    , mdl = Material.model
    }


type Msg
    = AddToList
    | SetCardDialog
    | Mdl (Material.Msg Msg)


type DialogAction
    = AddNewCard
    | None


type alias Model =
    { data : BoardTask.ColumnView
    , addCard : BoardTask.AddCard
    , dialogAction : DialogAction
    , mdl : Material.Model
    }


getBoardColumn : Model -> Html Msg
getBoardColumn model =
    let
        column =
            model.data

        rows =
            column.cards

        rendered_ =
            rows
                |> List.map (\l -> getColumnCard l)
                |> div []
    in
        div []
            [ section [ class "list" ]
                [ div [] [ header [] [ text column.title ] ]
                , rendered_
                , viewButton 0 model column
                ]
            ]


getColumnCard : BoardTask.CardView -> Html Msg
getColumnCard card =
    article [ class "card" ] [ header [] [ text card.title ] ]


viewButton : Int -> Model -> BoardTask.ColumnView -> Html Msg
viewButton idx model column =
    Button.render Mdl
        [ 1 ]
        model.mdl
        [ Button.raised, Dialog.openOn "click", Options.onClick SetCardDialog ]
        [ text "Add Card" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddToList ->
            let
                data_ =
                    model.data

                cardsA =
                    data_.cards
            in
                -- ( { model }, Cmd.none )
                ( { model | data = { data_ | cards = BoardTask.putElementToList " " cardsA } }, Cmd.none )

        SetCardDialog ->
            ( { model | dialogAction = AddNewCard }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model


view : Model -> Html Msg
view model =
    div [] [ getBoardColumn model, viewDialog model ]


viewDialog : Model -> Html Msg
viewDialog model =
    let
        ( title, content, actions ) =
            case model.dialogAction of
                AddNewCard ->
                    d0 model

                None ->
                    ( [ div [] [] ], [ div [] [] ], [ div [] [] ] )
    in
        Dialog.view []
            [ Dialog.title [] title
            , Dialog.content [] content
            , Dialog.actions [] actions
            ]


d0 : Model -> ( List (Html Msg), List (Html Msg), List (Html Msg) )
d0 model =
    ( [ text "Add New Card" ]
    , [ Textfield.render Mdl
            [ 2 ]
            model.mdl
            [ Textfield.label "Title"
            , Textfield.floatingLabel
            ]
            [ text "Close" ]
      ]
    , [ Button.render Mdl
            [ 0 ]
            model.mdl
            [ Dialog.closeOn "click"
            ]
            [ text "Close" ]
      , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Button.colored
            , Button.raised
            , Dialog.closeOn "click"
            , Options.onClick AddToList
            ]
            [ text "Submit" ]
      ]
    )
