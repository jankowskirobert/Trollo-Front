module BoardDetails.Card.Edit exposing (..)

import BoardTask
import Dialog
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import Debug


type alias Model =
    { currentCard : Maybe BoardTask.CardView
    , currentCardIndex : Maybe Int
    , newCardName : Maybe String
    , currentCardDescription : Maybe String
    , currentList : Maybe (List BoardTask.CardView)
    , showDialog : Bool
    }


model : Model
model =
    Model Maybe.Nothing Maybe.Nothing Maybe.Nothing Maybe.Nothing Maybe.Nothing False


type Msg
    = EditCardDetail Int BoardTask.CardView
    | SetNewCardName String
    | SetNewCardDescription String
    | UpdateCurrentCard
    | None
    | UpdateList (Maybe (List BoardTask.CardView))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetNewCardName name ->
            ( { model | newCardName = Just name }, Cmd.none )

        SetNewCardDescription description ->
            ( { model | currentCardDescription = Just description }, Cmd.none )

        EditCardDetail idxOnList card ->
            ( { model | currentCardIndex = Just idxOnList, currentCard = Just card, showDialog = True }, Cmd.none )

        UpdateCurrentCard ->
            case model.currentList of
                Nothing ->
                    ( { model | showDialog = False }, Cmd.none )

                Just list ->
                    ( { model | currentList = Just (updateCardOnList model list), showDialog = False }, Cmd.none )

        None ->
            ( { model | showDialog = False }, Cmd.none )

        UpdateList newList ->
            ( { model
                | currentList = newList
                , currentCard = Maybe.Nothing
                , currentCardIndex = Maybe.Nothing
                , newCardName = Maybe.Nothing
                , currentCardDescription = Maybe.Nothing
              }
            , Cmd.none
            )


updateCardOnList : Model -> List BoardTask.CardView -> List BoardTask.CardView
updateCardOnList updateModel listToUpdateOn =
    let
        xx =
            Debug.log "Message Card M:" updateModel
    in
        case Debug.log "Message Card" updateModel.currentCard of
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


updateElement2 : List a -> Int -> a -> List a
updateElement2 list indexOnList card =
    let
        arry_ =
            Array.fromList list

        updated =
            Array.set indexOnList (card) arry_
    in
        --List.take id list ++ (Just board) :: List.drop (id + 1) list
        Array.toList updated


view : Model -> Html Msg
view model =
    Dialog.view
        (if model.showDialog then
            Just (dialogConfig model)
         else
            Nothing
        )


dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    let
        ele =
            case model.currentList of
                Nothing ->
                    "List not found"

                Just lst ->
                    case model.currentCardIndex of
                        Nothing ->
                            "Index not found"

                        Just idx ->
                            case (Array.get idx (Array.fromList lst)) of
                                Nothing ->
                                    "Card not found"

                                Just card ->
                                    card.title
    in
        { closeMessage = Just (None)
        , containerClass = Nothing
        , header = Just (h3 [] [ text "Edit Card Details" ])
        , body =
            Just
                (div []
                    [ div [] [ input [ placeholder ("Enter name " ++ ele), onInput SetNewCardName ] [] ]
                    , div [] [ input [ placeholder ("Enter desc "), onInput SetNewCardDescription ] [] ]
                    ]
                )
        , footer =
            Just
                (button
                    [ class "btn btn-success"
                    , onClick UpdateCurrentCard
                    ]
                    [ text "OK" ]
                )
        }
