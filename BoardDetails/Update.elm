module BoardDetails.Update exposing (..)

import BoardDetails.Model exposing (Model, Msg(..), DialogAction(..))


-- import Column


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- AddToList ->
        --     case model.activeColumnView of
        --         Nothing ->
        --             ( model, Cmd.none )
        --         Just x ->
        --             let
        --                 cards =
        --                     x.cards
        --             in
        --                 ( model, Cmd.none )
        -- -- let
        -- --     cards_ =
        -- --         view_.cards
        -- --     isInBoard =
        -- --         cards_
        -- --             ++ [ (BoardTask.CardView 1 1 "column" "Test1") ]
        -- -- in
        -- --     if addcard.title /= "" then
        -- --         ( { model | data = BoardTask.putCardElementToList model.addCard column_, addCard = BoardTask.AddCard "" "" }, Cmd.none )
        -- --     else
        -- SetCardDialog columView_ ->
        --     ( { model | dialogAction = AddNewCard, activeColumnView = Just columView_ }, Cmd.none )
        -- SetColumnDialog ->
        --     ( { model | dialogAction = AddNewColumn }, Cmd.none )
        NoneMsg ->
            ( model, Cmd.none )



-- ColumnMsg msg ->
--     let
--         items = Array.fromList column
--         ( m, c, col ) =
--              lift .column (\m x -> { m | column = x }) ColumnMsg Column.update msg model
--     in
--         ( m, Cmd.none )
