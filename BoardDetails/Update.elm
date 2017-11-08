module BoardDetails.Update exposing (..)

import BoardDetails.Model exposing (Model, Msg(..), DialogAction(..))
import Material


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddToList ->
            -- let
            -- view_ =
            --     model.activeColumnView
            -- cards_ =
            --     view_.cards
            -- isInBoard =
            --     cards_
            --         ++ [ (BoardTask.CardView 1 1 "column" "Test1") ]
            -- in
            -- if addcard.title /= "" then
            --     ( { model | data = BoardTask.putCardElementToList model.addCard column_, addCard = BoardTask.AddCard "" "" }, Cmd.none )
            -- else
            ( model, Cmd.none )

        SetCardDialog columView_ ->
            ( { model | dialogAction = AddNewCard }, Cmd.none )

        SetColumnDialog ->
            ( { model | dialogAction = AddNewColumn }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model
