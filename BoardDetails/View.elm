module BoardDetails.View exposing (..)

import BoardDetails.Model exposing (Msg(..), Model, DialogAction(..))
import Html.Lazy
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import BoardTask
import Debug
import Dialog


-- import Column


getBoardColumn : BoardTask.ColumnView -> Model -> Html Msg
getBoardColumn column model =
    let
        rows =
            [ BoardTask.CardView "UNI1" True "TITLE1" "DESC1" 1 ]

        rendered_ =
            rows
                |> List.map (\l -> getColumnCard l)
                |> div [detailsStyle]
    in
        div []
            [ section [ class "list", detailsStyleCol]
                [ div [] [ header [] [ text column.title ] ]
                , rendered_
                , viewButton 0 model column
                ]
            ]


detailsStyleCol : Attribute msg
detailsStyleCol =
  style
    [ ("backgroundColor", "#3D88BF")
    , ("color","white")
    ]

detailsStyle =
  style
    [ ("backgroundColor", "#3D88BF")
    , ("color","black")
    ]

getColumnCard : BoardTask.CardView -> Html Msg
getColumnCard card =
    article [ class "card" ] [ header [] [ text card.title ] ]



-- view : Model -> Html Msg
-- view =
--     Html.Lazy.lazy view_


viewButton : Int -> Model -> BoardTask.ColumnView -> Html Msg
viewButton idx model column =
    div [] []



-- Button.render Mdl
--     [ 1 ]
--     model.mdl
--     [ Button.raised, Dialog.openOn "click", Options.onClick (SetCardDialog column) ]
--     [ text "Add Card" ]


viewColumns : Model -> Html Msg
viewColumns model =
    let
        stored =
            model.columns

        -- storedCol =
        --     stored.data
    in
        stored
            |> List.map
                (\l ->
                    -- Html.map ColumnMsg
                    --     (Column.view l)
                    getBoardColumn
                        l
                        model
                )
            |> div [ class "main_board" ]



-- viewDialog : Model -> Html Msg
-- viewDialog model =
--     let
--         ( title, content, actions ) =
--             case model.dialogAction of
--                 AddNewCard ->
--                     d0 model
--                 AddNewColumn ->
--                     ( [ div [] [] ], [ div [] [] ], [ div [] [] ] )
--                 None ->
--                     ( [ div [] [] ], [ div [] [] ], [ div [] [] ] )
--     in
--         Dialog.view []
--             [ Dialog.title [] title
--             , Dialog.content [] content
--             , Dialog.actions [] actions
--             ]


view : Model -> Html Msg
view model =
    let
        currBoard =
            model.board

        boardName =
            case currBoard of
                Nothing ->
                    "Untitled"

                Just x ->
                    x.title
    in
        div [boardTextStyle]
            [ text boardName
            , viewColumns model
            , button
                [ addColumnStyle
                , onClick (SetDialogAction BoardDetails.Model.AddNewColumn)
                ]
                [ text "Add Column" ]
            , Dialog.view
                (if model.showDialog then
                    Just (dialogConfig model)
                 else
                    Nothing
                )

            -- , viewDialog model
            ]


boardTextStyle : Attribute msg
boardTextStyle =
  style
    [ 
      ("font-size", "24px")
    , ("padding-left", "10px")
    , ("padding-top", "20px")
    ]



addColumnStyle : Attribute msg
addColumnStyle =
  style
    [ ("color", "white")
    , ("backgroundColor", "#166494")
    , ("font-size", "20")
    , ("border", "none")
    , ("overflow","hidden")
    , ("outline","none")
    , ("height", "36px")
    , ("padding-left", "10px")
    , ("webkit-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)")
    , ("moz-box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)")
    , ("box-shadow", "0px 2px 2px 0px rgba(211,211,211,1)")
    ]



dialogConfig : Model -> Dialog.Config Msg
dialogConfig model =
    { closeMessage = Just (SetDialogAction BoardDetails.Model.None)
    , containerClass = Nothing
    , header = Just (h3 [] [ text "List Name" ])
    , body = Just (input [ placeholder ("Enter name "), onInput SetNewColumndName ] [])
    , footer =
        Just
            (button
                [ class "btn btn-success"
                , onClick AddNewList
                ]
                [ text "OK" ]
            )
    }
