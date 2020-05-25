module View.Svg exposing (root)

import Html exposing (Html)
import Raycasting
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (..)
import Vectors exposing (..)


root : Walls -> Position -> Html msg
root walls position =
    svg
        [ width "600"
        , height "600"
        ]
        [ drawRays walls position
        , drawWalls walls
        , drawCursor position
        ]


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
