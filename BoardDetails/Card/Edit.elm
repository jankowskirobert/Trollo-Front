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
    , currentList : List BoardTask.CardView
    , showDialog : Bool
    , comments : List BoardTask.CommentView
    }


model : Model
model =
    Model Maybe.Nothing Maybe.Nothing Maybe.Nothing Maybe.Nothing [] False []


type Msg
    = EditCardDetail Int BoardTask.CardView (List BoardTask.CommentView)
    | SetNewCardName String
    | SetNewCardDescription String
      -- | SetCardArchive
    | UpdateCurrentCard
    | None
    | UpdateList (List BoardTask.CardView)
    | SetNewCardComment String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetNewCardName name ->
            ( { model | newCardName = Just name }, Cmd.none )

        SetNewCardDescription description ->
            ( { model | currentCardDescription = Just description }, Cmd.none )

        EditCardDetail idxOnList card coms ->
            ( { model | currentCardIndex = Just idxOnList, currentCard = Just card, showDialog = True, comments = coms }, Cmd.none )

        UpdateCurrentCard ->
            let
                list =
                    model.currentList
            in
                ( { model | currentList = (updateCardOnList model list), showDialog = False }, Cmd.none )

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

        SetNewCardComment commentBody ->
            ( model, Cmd.none )


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
        lst =
            model.currentList

        ele =
            case model.currentCardIndex of
                Nothing ->
                    div [] []

                Just idx ->
                    case (Array.get idx (Array.fromList lst)) of
                        Nothing ->
                            div [] []

                        Just card ->
                            commentsSectionInDialog model.comments card
    in
        { closeMessage = Just (None)
        , containerClass = Nothing
        , header = Just (h3 [] [ text "Edit Card Details" ])
        , body =
            Just
                (div []
                    [ div [] [ input [ placeholder ("Enter name "), onInput SetNewCardName ] [] ]
                    , div [] [ input [ placeholder ("Enter desc "), onInput SetNewCardDescription ] [] ]
                    , ele
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


commentsSectionInDialog : List BoardTask.CommentView -> BoardTask.CardView -> Html Msg
commentsSectionInDialog coms card =
    div []
        [ hr [] []
        , input [ placeholder ("Enter new comment"), onInput SetNewCardComment ] []
        , table [] [ thead [] [], (commentListInDialog card coms) ]
        ]


commentListInDialog : BoardTask.CardView -> List BoardTask.CommentView -> Html Msg
commentListInDialog card list =
    List.map (\x -> commentViewInDialog x) list |> tbody []


commentViewInDialog : BoardTask.CommentView -> Html Msg
commentViewInDialog com =
    tr []
        [ td [] [ text com.body ]
        , td [] [ text (toString com.added) ]
        ]



-- <tr>
--         <td>John</td>
--         <td>Doe</td>
--         <td>john@example.com</td>
--       </tr>
