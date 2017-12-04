module BoardDetails.Card.Edit exposing (..)

import BoardTask
import MyDialog as Dialog
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import Debug
import Date
import Task
import Time


type alias Model =
    { currentCard : Maybe BoardTask.CardView
    , currentCardIndex : Maybe Int
    , newCardName : Maybe String
    , currentCardDescription : Maybe String
    , currentList : List BoardTask.CardView
    , showDialog : Bool
    , newCommentBody : Maybe String
    , comments : List BoardTask.CommentView
    , currentDate : Maybe Date.Date
    }


model : Model
model =
    Model
        Maybe.Nothing
        Maybe.Nothing
        Maybe.Nothing
        Maybe.Nothing
        []
        False
        Maybe.Nothing
        []
        Maybe.Nothing


type Msg
    = EditCardDetail Int BoardTask.CardView (List BoardTask.CommentView)
    | SetNewCardName String
    | SetNewCardDescription String
      -- | SetCardArchive
    | UpdateCurrentCard
    | None
    | UpdateList (List BoardTask.CardView)
    | SetNewCardComment String
    | AddNewComment
    | SaveNewDate Date.Date
    | UpdateCurrentDate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetNewCardName name ->
            ( { model | newCardName = Just name }, Cmd.none )

        SetNewCardDescription description ->
            ( { model | currentCardDescription = Just description }, Cmd.none )

        EditCardDetail idxOnList card coms ->
            ( { model
                | currentCardIndex = Just idxOnList
                , currentCard = Just card
                , showDialog = True
                , comments = coms
              }
            , Cmd.none
            )

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
        , containerClass = Just "modal-dialog modal-lg"
        , header = Just (h3 [] [ text "Edit Card Details" ])
        , sizeOf = Just Dialog.Large
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
        , input
            [ placeholder ("Enter new comment")
            , onInput SetNewCardComment
            ]
            []
        , button
            [ class "btn btn-success"
            , onClick AddNewComment
            ]
            [ text "Add Comment" ]
        , table [ class "table table-bordered" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Comment" ]
                    , th [] [ text "Date" ]
                    ]
                ]
            , (commentListInDialog card coms)
            ]
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
