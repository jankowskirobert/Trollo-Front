module BoardDetails.Update exposing (..)

import BoardDetails.Model exposing (Model, Msg(..), DialogAction(..))
import BoardTask
import BoardDetails.Card.Edit as CardEdit
import Debug
import BoardDetails.Rest as CardRest
import Array
import Date
import Task
import Time


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
                        ( { model | showDialog = False }
                        , Cmd.batch
                            [ Cmd.map RestCardMsg (CardRest.saveColumnView session.auth board (BoardTask.ColumnView nxtIdx x 0 "Example"))
                            , Cmd.map RestCardMsg (CardRest.getColumnsView session.auth board)
                            ]
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

                EditCard card coms ->
                    ( { model
                        | currentCard = Just card
                        , showDialog = True
                        , comments = []
                        , dialogAction = action
                        , currentCardDescription = Maybe.Nothing
                        , newColor = Maybe.Nothing
                        , newCardName = Maybe.Nothing
                      }
                    , Cmd.none
                    )

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
                                (BoardTask.CardView "1" False x "OFFLINE " y.id "#ffffff" "")

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
                                , Cmd.map RestCardMsg (CardRest.getCardsView session.auth)
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
                                        ( { model
                                            | showDialog = False
                                          }
                                        , Cmd.batch
                                            [ (Cmd.map RestCardMsg (CardRest.updateColumnView session.auth afterUpdate))
                                            , (Cmd.map RestCardMsg (CardRest.getColumnsView session.auth board))
                                            ]
                                        )

        SetNewCardDescription description ->
            ( { model | currentCardDescription = Just description }, Cmd.none )

        UpdateCurrentCard ->
            let
                newCmd =
                    case model.currentCard of
                        Nothing ->
                            [ Cmd.none ]

                        Just card ->
                            let
                                card_ =
                                    case ( model.newCardName, model.currentCardDescription, model.newColor ) of
                                        ( Nothing, Nothing, Nothing ) ->
                                            card

                                        ( Just newName, Nothing, Nothing ) ->
                                            { card | title = newName, archiveStatus = model.archivedCard }

                                        ( Just newName, Just desc, Nothing ) ->
                                            { card | title = newName, description = desc, archiveStatus = model.archivedCard }

                                        ( Nothing, Just desc, Nothing ) ->
                                            { card | description = desc, archiveStatus = model.archivedCard }

                                        ( Just newName, Just desc, Just col ) ->
                                            { card | title = newName, description = desc, color = col, archiveStatus = model.archivedCard }

                                        ( Nothing, Just desc, Just col ) ->
                                            { card | description = desc, color = col, archiveStatus = model.archivedCard }

                                        ( Nothing, Nothing, Just col ) ->
                                            { card | color = col, archiveStatus = model.archivedCard }

                                        ( Just newName, Nothing, Just col ) ->
                                            { card | title = newName, color = col, archiveStatus = model.archivedCard }
                            in
                                [ Cmd.map RestCardMsg (CardRest.updateCardView session.auth card_)
                                , Cmd.map RestCardMsg (CardRest.getCardsView session.auth)
                                ]
            in
                ( { model | showDialog = False }, Cmd.batch newCmd )

        SetNewCardComment commentBody ->
            ( { model | newCommentBody = Just commentBody }, Task.perform SaveNewDate Date.now )

        AddNewComment ->
            case model.newCommentBody of
                Nothing ->
                    ( model, Cmd.none )

                Just comm ->
                    case model.currentDate of
                        Nothing ->
                            ( model, Cmd.none )

                        Just date ->
                            let
                                newComment =
                                    BoardTask.CommentView 0 comm date ""

                                currComments =
                                    model.comments
                            in
                                ( { model | comments = currComments ++ [ newComment ] }, Cmd.none )

        UpdateCurrentDate ->
            ( model, Task.perform SaveNewDate Date.now )

        SaveNewDate date ->
            ( { model | currentDate = Just date }, Cmd.none )

        UpdateColor color ->
            ( { model | newColor = Just color }, Cmd.none )

        TogglePublic ->
            let
                state =
                    model.archivedCard
            in
                ( { model | archivedCard = (not state) }, Cmd.none )


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
