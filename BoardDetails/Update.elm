module BoardDetails.Update exposing (..)

import BoardDetails.Model exposing (Model, Msg(..), DialogAction(..))
import BoardTask


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

                EditCardDetail idx_ card_ ->
                    ( { model | dialogAction = action, currentCardIndex = Just idx_, currentCard = Just card_, showDialog = True }, Cmd.none )

                AddCard x ->
                    ( { model | dialogAction = action, showDialog = True, currentColumnIdx = Just x }, Cmd.none )

        SetNewColumndName name ->
            ( { model | newColumnName = Just name }, Cmd.none )

        SetNewCardName name ->
            ( { model | newCardName = Just name }, Cmd.none )

        UpdateCurrentCard ->
            case ( model.currentCard, model.currentCardIndex, model.newCardName ) of
                ( Nothing, Nothing, Nothing ) ->
                    ( model, Cmd.none )

                ( Nothing, Just x, Nothing ) ->
                    ( model, Cmd.none )

                ( Nothing, Nothing, Just x ) ->
                    ( model, Cmd.none )

                ( Just x, Nothing, Nothing ) ->
                    ( model, Cmd.none )

                ( Just x, Just y, Nothing ) ->
                    ( model, Cmd.none )

                ( Just x, Nothing, Just y ) ->
                    ( model, Cmd.none )

                ( Nothing, Just x, Just y ) ->
                    ( model, Cmd.none )

                ( Just x, Just y, Just z ) ->
                    let
                        h =
                            { x | title = z }

                        cards_ =
                            model.card
                    in
                        ( { model | card = (updateElement2 cards_ y h), showDialog = False }, Cmd.none )

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
                    in
                        ( { model | card = card_ ++ [ Just (BoardTask.CardView "UNIX" True x "DESC" 1 y) ], showDialog = False }, Cmd.none )



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
