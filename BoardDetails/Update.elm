module BoardDetails.Update exposing (..)

import BoardDetails.Model exposing (Model, Msg(..), DialogAction(..))
import BoardTask
import BoardDetails.Card.Edit as CardEdit


-- import Column


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoneMsg ->
            ( model, Cmd.none )

        EditName ->
            ( model, Cmd.none )

        AddToList ->
            ( model, Cmd.none )

        AddNewList ->
            case model.newColumnName of
                Nothing ->
                    ( model, Cmd.none )

                Just x ->
                    let
                        cols =
                            model.columns
                    in
                        ( { model | columns = cols ++ [ (BoardTask.ColumnView 1 1 x 1) ], showDialog = False }, Cmd.none )

        SetDialogAction action ->
            case action of
                AddNewColumn ->
                    ( { model | dialogAction = action, showDialog = True }, Cmd.none )

                ShowCardDetail card_ ->
                    ( { model | dialogAction = action, currentCard = Just card_, showDialog = True }, Cmd.none )

                None ->
                    ( { model | dialogAction = action, showDialog = False }, Cmd.none )

                AddCard x ->
                    ( { model | dialogAction = action, showDialog = True, currentColumnIdx = Just x }, Cmd.none )

        SetNewColumndName name ->
            ( { model | newColumnName = Just name }, Cmd.none )

        SetNewCardName name ->
            ( { model | newCardName = Just name }, Cmd.none )

        AddNewCard ->
            case ( model.newCardName, model.currentColumnIdx ) of
                ( Nothing, _ ) ->
                    ( model, Cmd.none )

                ( _, Nothing ) ->
                    ( model, Cmd.none )

                ( Just x, Just y ) ->
                    let
                        card_ =
                            model.card

                        updated =
                            card_ ++ [ Just (BoardTask.CardView "UNIX" True x "DESC" 1 y) ]

                        ( m, c ) =
                            CardEdit.update (CardEdit.UpdateList updated) model.cardModel
                    in
                        ( { model | card = updated, cardModel = m, showDialog = False }, Cmd.none )

        CardMsg msg_ ->
            let
                ( m, c ) =
                    CardEdit.update msg_ model.cardModel

                list_ =
                    m.currentList
            in
                ( { model | cardModel = m, card = list_ }, Cmd.map CardMsg c )



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
