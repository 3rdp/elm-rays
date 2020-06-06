module View.Svg exposing (root)

import Html exposing (Html)
import Html.Events as Event
import Raycasting
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (..)
import Vectors exposing (..)

noopSvg = g [] []

root : Model -> Html Msg
root model =
    svg
        [ width "600"
        , height "600"
        -- FIXME: don't render this onClick handler if we're not in drawing state
        , Event.onClick SvgRootClick
        ]
        [ case model.mouse of
            Just mousePosition ->
                drawRays model.walls mousePosition
            _ ->
                noopSvg
        , drawWalls model.walls
        , case model.mouse of
            Just mousePosition ->
                -- TODO: draw different cursor depending on wherther you're raycasting or doing anything else
                drawCursor mousePosition
            _ ->
                noopSvg
        -- , drawFloatingButton model.cursor
        -- , drawFloatingButton (Debug.log "drawFloatingButton" model.cursor)
        ]
        -- done: render a floating action button, it will indicate CursorState


neighbours : List a -> List ( a, a )
neighbours xs =
    List.map2 Tuple.pair
        xs
        ((xs ++ xs)
            |> List.tail
            |> Maybe.withDefault []
        )


drawRays : Walls -> Position -> Svg msg
drawRays walls position =
    g []
        (Raycasting.solveRays
            { x =  position.x
            , y =  position.y
            }
            walls
            |> List.sortBy (.vector >> .angle)
            |> neighbours
            |> List.map drawTriangle
        )


drawWalls : Walls -> Svg msg
drawWalls walls =
    g []
        (List.map drawLine walls)


drawLine : Line -> Svg msg
drawLine line =
    let
        lineStart =
            Vectors.start line

        lineEnd =
            Vectors.end line
    in
        Svg.line
            [ x1 (String.fromFloat lineStart.x)
            , y1 (String.fromFloat lineStart.y)
            , x2 (String.fromFloat lineEnd.x)
            , y2 (String.fromFloat lineEnd.y)
            , stroke "black"
            , strokeWidth "5"
            , strokeLinecap "round"
            ]
            []


drawTriangle : ( Line, Line ) -> Svg msg
drawTriangle ( a, b ) =
    let
        formatPoint point =
            String.fromFloat point.x ++ "," ++ String.fromFloat point.y
    in
        polygon
            [ fill "gold"
            , stroke "gold"
            , points
                (String.join " "
                    (List.map formatPoint
                        [ Vectors.start a
                        , Vectors.end a
                        , Vectors.end b
                        , Vectors.start b
                        ]
                    )
                )
            ]
            []


drawCursor : Position -> Svg msg
drawCursor position =
    circle
        [ cx (String.fromFloat position.x)
        , cy (String.fromFloat position.y)
        , r "5"
        , fill "red"
        ]
        []

circleForFAB =
    circle
        [ cx "550"
        , cy "550"
        , r "40"
        , fill "magenta"
        ] []

textForFAB = text_ [ x "535", y "570", fill "white", fontSize "50", fontFamily "monospace" ]

drawFloatingButton : CursorState -> Svg Msg
drawFloatingButton cursor =
    case cursor of
        Raycasting ->
            g [ Event.onClick CursorStateChange ]
            [ circleForFAB
            , textForFAB [ text "R" ]
            ]
        Drawing ->
            g [ Event.onClick CursorStateChange ]
            [ circleForFAB
            , textForFAB [ text "D" ]
            ]
        Erasing ->
            g [ Event.onClick CursorStateChange ]
            [ circleForFAB
            , textForFAB [ text "E" ]
            ]
