module BoardDetails.Update exposing (..)

import BoardDetails.Model exposing (Model, Msg(..), DialogAction(..))
import BoardTask
import BoardDetails.Card.Edit as CardEdit
import Debug
import BoardDetails.Rest as CardRest
import Array


-- import Column


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Message Details" msg of
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

                        nxtIdx =
                            List.length cols
                    in
                        ( { model | columns = cols ++ [ (BoardTask.ColumnView nxtIdx x 1 "Example") ], showDialog = False }, Cmd.none )

        SetDialogAction action ->
            case action of
                AddNewColumn ->
                    ( { model | dialogAction = action, showDialog = True }, Cmd.none )

                EditColumn idx lst ->
                    ( { model | dialogAction = action, showDialog = True, currentColumnIdx = Just idx, currentColumn = Just lst }, Cmd.none )

                ShowCardDetail card_ ->
                    ( { model | dialogAction = action, currentCard = Just card_, showDialog = True }, Cmd.none )

                None ->
                    ( { model | dialogAction = action, showDialog = False }, Cmd.none )

                AddCard x ->
                    ( { model | dialogAction = action, showDialog = True, currentColumn = Just x }, Cmd.none )

        SetNewColumndName name ->
            ( { model | newColumnName = Just name }, Cmd.none )

        SetNewCardName name ->
            ( { model | newCardName = Just name }, Cmd.none )

        AddNewCard ->
            case model.card of
                Nothing ->
                    case ( model.newCardName, model.currentColumn ) of
                        ( Nothing, _ ) ->
                            ( model, Cmd.none )

                        ( _, Nothing ) ->
                            ( model, Cmd.none )

                        ( Just x, Just y ) ->
                            let
                                cardToPut =
                                    (BoardTask.CardView 0 "OFFLINE INIT" x "OFFLINE INIT" 0 y.id)

                                updated =
                                    [ cardToPut ]

                                ( mR, cR ) =
                                    CardRest.update (CardRest.AddCard cardToPut) model.cardRest

                                ( m, c ) =
                                    CardEdit.update (CardEdit.UpdateList (Just updated)) model.cardModel
                            in
                                ( { model | card = (Just updated), cardModel = m, showDialog = False }, Cmd.batch [ Cmd.map RestCardMsg (CardRest.saveCardView cardToPut), (Cmd.map CardMsg c) ] )

                --Cmd.batch [ (Cmd.map RestCardMsg cR), (Cmd.map CardMsg c) ]
                Just cards_ ->
                    case ( model.newCardName, model.currentColumn ) of
                        ( Nothing, _ ) ->
                            ( model, Cmd.none )

                        ( _, Nothing ) ->
                            ( model, Cmd.none )

                        ( Just x, Just y ) ->
                            let
                                cardToPut =
                                    (BoardTask.CardView 1 "OFFLINE " x "OFFLINE " 1 y.id)

                                updated =
                                    cards_ ++ [ cardToPut ]

                                ( mR, cR ) =
                                    CardRest.update (CardRest.AddCard cardToPut) model.cardRest

                                ( m, c ) =
                                    CardEdit.update (CardEdit.UpdateList (Just updated)) model.cardModel
                            in
                                ( { model | card = (Just updated), cardModel = m, showDialog = False }, Cmd.batch [ Cmd.map RestCardMsg (CardRest.saveCardView cardToPut), (Cmd.map CardMsg c) ] )

        -- Cmd.batch [ (Cmd.map RestCardMsg (CardRest.saveCardView cardToPut)), (Cmd.map CardMsg c) ]
        CardMsg msg_ ->
            let
                ( m, c ) =
                    CardEdit.update msg_ model.cardModel

                list_ =
                    m.currentList
            in
                ( { model | cardModel = m, card = list_ }, Cmd.map CardMsg c )

        RestCardMsg msg_ ->
            let
                ( m, c ) =
                    CardRest.update msg_ model.cardRest

                lgs =
                    Debug.log "Message Details REST" msg_
            in
                ( { model | cardRest = m }, Cmd.map RestCardMsg c )

        EditList ->
            case model.currentColumnIdx of
                Nothing ->
                    ( { model | showDialog = False }, Cmd.none )

                Just idx ->
                    case model.currentColumn of
                        Nothing ->
                            ( { model | showDialog = False }, Cmd.none )

                        Just lst ->
                            case model.newColumnName of
                                Nothing ->
                                    ( model, Cmd.none )

                                Just newName ->
                                    let
                                        afterUpdate =
                                            { lst | title = newName }

                                        lsts =
                                            model.columns
                                    in
                                        ( { model | showDialog = False, columns = updateElement lsts idx afterUpdate }, Cmd.none )



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


updateElement : List a -> Int -> a -> List a
updateElement list indexOnList card =
    let
        arry_ =
            Array.fromList list

        updated =
            Array.set indexOnList (card) arry_
    in
        --List.take id list ++ (Just board) :: List.drop (id + 1) list
        Array.toList updated
