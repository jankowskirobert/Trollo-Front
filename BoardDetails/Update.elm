module BoardDetails.Update exposing (..)

import BoardDetails.Model exposing (Model, Msg(..), DialogAction(..))
import BoardTask
import BoardDetails.Card.Edit as CardEdit
import Debug
import BoardDetails.Rest as CardRest
import Array


-- import Column


update : BoardTask.User -> BoardTask.BoardView -> Msg -> Model -> ( Model, Cmd Msg )
update session board msg model =
    case Debug.log "Message Details" msg of
        NoneMsg ->
            ( model, Cmd.none )

        EditName ->
            ( model, Cmd.none )

        AddToList ->
            ( model, Cmd.none )

        FetchColumns view ->
            ( model, Cmd.map RestCardMsg (CardRest.getColumnsView session.auth view) )

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
                        ( { model | columns = cols ++ [ (BoardTask.ColumnView nxtIdx x 1 "Example") ], showDialog = False }
                        , Cmd.batch [ Cmd.map RestCardMsg (CardRest.saveColumnView session.auth board (BoardTask.ColumnView nxtIdx x 0 "Example")) ]
                        )

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
            let
                cards_ =
                    model.card
            in
                case ( model.newCardName, model.currentColumn ) of
                    ( Nothing, _ ) ->
                        ( model, Cmd.none )

                    ( _, Nothing ) ->
                        ( model, Cmd.none )

                    ( Just x, Just y ) ->
                        let
                            cardToPut =
                                (BoardTask.CardView "1" False x "OFFLINE " y.id "" "")

                            updated =
                                cards_ ++ [ cardToPut ]

                            ( mR, cR ) =
                                CardRest.update session (CardRest.AddCard cardToPut) model.cardRest

                            ( m, c ) =
                                CardEdit.update (CardEdit.UpdateList (updated)) model.cardModel
                        in
                            ( { model
                                | card = (updated)
                                , cardModel = m
                                , showDialog = False
                              }
                            , Cmd.batch
                                [ Cmd.map RestCardMsg (CardRest.saveCardView session.auth cardToPut)
                                , (Cmd.map CardMsg c)
                                ]
                            )

        -- Cmd.batch [ (Cmd.map RestCardMsg (CardRest.saveCardView cardToPut)), (Cmd.map CardMsg c) ]
        CardMsg msg_ ->
            let
                ( m, c ) =
                    CardEdit.update msg_ model.cardModel

                list_ =
                    m.currentList

                currComs =
                    model.comments
            in
                ( { model | cardModel = m, card = list_, comments = m.comments }, Cmd.map CardMsg c )

        RestCardMsg msg_ ->
            let
                ( m, c ) =
                    CardRest.update session msg_ model.cardRest

                columns_ =
                    m.columns

                cards =
                    m.cards

                lgs =
                    Debug.log "Message Details REST" msg_
            in
                ( { model | cardRest = m, columns = columns_, card = cards }, Cmd.map RestCardMsg c )

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
                                            { lst | tableTitle = newName }

                                        lsts =
                                            model.columns
                                    in
                                        ( { model | showDialog = False, columns = updateElement lsts idx afterUpdate }, Cmd.batch [ Cmd.map RestCardMsg (CardRest.updateColumnView session.auth afterUpdate) ] )


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
