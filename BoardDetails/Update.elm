module BoardDetails.Update exposing (..)

import BoardDetails.Model exposing (Model, Msg(..), DialogAction(..))
import BoardTask
import BoardDetails.Card.Model as Card


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
                    let
                        updateMode =
                            model.cardUpdateModel

                        updated =
                            { updateMode | currentCardIndex = Just idx_, currentCard = Just card_ }
                    in
                        ( { model | dialogAction = action, cardUpdateModel = updated, showDialog = True }, Cmd.none )

                AddCard x ->
                    ( { model | dialogAction = action, showDialog = True, currentColumnIdx = Just x }, Cmd.none )

        SetNewColumndName name ->
            ( { model | newColumnName = Just name }, Cmd.none )

        SetNewCardName name ->
            let
                updateMode =
                    model.cardUpdateModel

                updated =
                    { updateMode | newCardName = Just name }
            in
                ( { model | newCardName = Just name, cardUpdateModel = updated }, Cmd.none )

        UpdateCurrentCard ->
            -- case ( model.currentCard, model.currentCardIndex, model.newCardName ) of
            --     ( Nothing, Nothing, Nothing ) ->
            --         ( model, Cmd.none )
            --     ( Nothing, Just x, Nothing ) ->
            --         ( model, Cmd.none )
            --     ( Nothing, Nothing, Just x ) ->
            --         ( model, Cmd.none )
            --     ( Just x, Nothing, Nothing ) ->
            --         ( model, Cmd.none )
            --     ( Just x, Just y, Nothing ) ->
            --         ( model, Cmd.none )
            --     ( Just x, Nothing, Just y ) ->
            --         ( model, Cmd.none )
            --     ( Nothing, Just x, Just y ) ->
            --         ( model, Cmd.none )
            --     ( Just x, Just y, Just z ) ->
            let
                -- h =
                --     { x | title = z }
                cards_ =
                    model.card

                updateModel =
                    model.cardUpdateModel
            in
                ( { model | card = (updateCardOnList updateModel cards_), showDialog = False }, Cmd.none )

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
                            Card.update (Card.UpdateList updated) model.cardModel
                    in
                        ( { model | card = updated, cardModel = m, showDialog = False }, Cmd.none )

        SetNewCardDescription desc ->
            let
                updateMode =
                    model.cardUpdateModel

                updated =
                    { updateMode | currentCardDescription = Just desc }
            in
                ( { model | currentCardDescription = Just desc, cardUpdateModel = updated }, Cmd.none )

        CardMsg msg_ ->
            let
                ( m, c ) =
                    Card.update msg_ model.cardModel

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


updateCardOnList : BoardDetails.Model.UpdateCardModel -> List (Maybe BoardTask.CardView) -> List (Maybe BoardTask.CardView)
updateCardOnList updateModel listToUpdateOn =
    case updateModel.currentCard of
        Nothing ->
            listToUpdateOn

        Just selectedCard ->
            case updateModel.currentCardIndex of
                Nothing ->
                    listToUpdateOn

                Just selectedCardIndex ->
                    let
                        ( newName, newDescription ) =
                            case ( updateModel.newCardName, updateModel.currentCardDescription ) of
                                ( Nothing, Nothing ) ->
                                    let
                                        oldName =
                                            selectedCard.title

                                        oldDescription =
                                            selectedCard.description
                                    in
                                        ( oldName, oldDescription )

                                ( Just newName_, Nothing ) ->
                                    let
                                        oldDescription =
                                            selectedCard.description
                                    in
                                        ( newName_, oldDescription )

                                ( Nothing, Just newDesc_ ) ->
                                    let
                                        oldName =
                                            selectedCard.title
                                    in
                                        ( oldName, newDesc_ )

                                ( Just newTitle_, Just newDesc_ ) ->
                                    ( newTitle_, newDesc_ )

                        updated =
                            { selectedCard | title = newName, description = newDescription }
                    in
                        (updateElement2 listToUpdateOn selectedCardIndex updated)
