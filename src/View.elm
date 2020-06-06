module View exposing (root)

import Html exposing (..)
import Html.Events as Event
import Html.Attributes exposing (..)
import Types exposing (..)
import View.Svg


root : Model -> Html Msg
root model =
    div [ style "display" "flex", style "flex-direction" "row"]
        [ div [] [ View.Svg.root model ]
        , copy
        , drawFloatingBtn model.cursor
        ]


copy : Html Msg
copy =
    div
        [ style
            "text-align" "center"
        ]
        [ div []
            [ Html.text "A raycasting hack in "
            , a [ href "http://elm-lang.org/" ]
                [ text "Elm" ]
            , text ", based on "
            , a [ href "http://ncase.me/sight-and-light" ]
                [ text "this excellent tutorial" ]
            , text "."
            ]
        , div []
            [ a [ href "https://github.com/krisajenkins/elm-rays" ]
                [ text "Source Code"
                ]
            ]
        ]

circleForFAB =
    div
        [ style "position" "absolute"
        , style "width" "80px"
        , style "height" "80px"
        , style "border-radius" "40px"
        , style "background-color" "magenta"
        , style "color" "white"
        , style "font-size" "50px"
        , style "font-family" "monospace"
        , style "right" "20px"
        , style "bottom" "60px"
        , style "text-align" "center"
        , style "line-height" "80px"
        , Event.onClick CursorStateChange
        ]

drawFloatingBtn : CursorState -> Html Msg
drawFloatingBtn cursor =
    case cursor of
        Raycasting ->
            circleForFAB [ text "R" ]
        Drawing ->
            circleForFAB [ text "D" ]
        Erasing ->
            circleForFAB [ text "E" ]
