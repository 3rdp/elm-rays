module View exposing (root)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)
import View.Svg


root : Model -> Html msg
root model =
    div []
        [ case model.mouse of
            Just position ->
                View.Svg.root model.walls position

            _ ->
                Html.text "Initializing."
        , copy
        ]


copy : Html msg
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
