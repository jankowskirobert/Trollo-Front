module BoardDetails.Update exposing (..)

import BoardDetails.Model exposing (Model, Msg(..), DialogAction(..))
import BoardTask


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

        EditName ->
            ( model, Cmd.none )

        AddToList ->
            ( model, Cmd.none )

        AddNewList ->
            let
                cols =
                    model.columns
            in
                ( { model | columns = cols ++ [ (BoardTask.ColumnView 1 1 "UUU" 1) ] }, Cmd.none )



-- ColumnMsg msg ->
--     let
--         items = Array.fromList column
--         ( m, c, col ) =
--              lift .column (\m x -> { m | column = x }) ColumnMsg Column.update msg model
--     in
--         ( m, Cmd.none )


updateElement2 : List (Maybe a) -> Int -> a -> List (Maybe a)
updateElement2 list id board =
    List.take id list ++ (Just board) :: List.drop (id + 1) list
