module BoardDetails.Card.Edit exposing (..)

import BoardTask
import Dialog
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { currentCard : Maybe BoardTask.CardView
    , currentCardIndex : Maybe Int
    , newCardName : Maybe String
    , currentCardDescription : Maybe String
    , currentList : List (Maybe BoardTask.CardView)
    , showDialog : Bool
    }


model : Model
model =
    Model Maybe.Nothing Maybe.Nothing Maybe.Nothing Maybe.Nothing [] False


type Msg
    = EditCardDetail Int BoardTask.CardView
    | SetNewCardName String
    | SetNewCardDescription String
    | UpdateCurrentCard
    | None
    | UpdateList (List (Maybe BoardTask.CardView))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetNewCardName name ->
            ( { model | newCardName = Just name }, Cmd.none )

        SetNewCardDescription description ->
            ( { model | currentCardDescription = Just description }, Cmd.none )

        EditCardDetail idx card ->
            ( { model | currentCardIndex = Just idx, currentCard = Just card, showDialog = True }, Cmd.none )

        UpdateCurrentCard ->
            let
                cards_ =
                    model.currentList
            in
                ( { model | currentList = (updateCardOnList model cards_), showDialog = False }, Cmd.none )

        None ->
            ( { model | showDialog = False }, Cmd.none )

        UpdateList newList ->
            ( { model | currentList = newList }, Cmd.none )


updateCardOnList : Model -> List (Maybe BoardTask.CardView) -> List (Maybe BoardTask.CardView)
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


updateElement2 : List (Maybe a) -> Int -> a -> List (Maybe a)
updateElement2 list id board =
    List.take id list ++ (Just board) :: List.drop (id + 1) list


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
    { closeMessage = Just (None)
    , containerClass = Nothing
    , header = Just (h3 [] [ text "Edit Card Details" ])
    , body =
        Just
            (div []
                [ div [] [ input [ placeholder ("Enter name "), onInput SetNewCardName ] [] ]
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
