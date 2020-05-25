module Raycasting exposing (solveRays)

import List.Extra
import Types exposing (..)
import Vectors exposing (..)


solveRays : Position -> Walls -> List Line
solveRays position walls =
    walls
        |> List.concatMap (toRays position)
        |> List.filterMap (curtail walls)


toRays : Position -> Line -> List Line
toRays position line =
    let
        rayToStart =
            lineBetween position (start line)

        rayToEnd =
            lineBetween position (end line)

        delta =
            degrees 0.1
    in
        [ addToAngle delta rayToStart
        , addToAngle (delta * -1) rayToStart
        , addToAngle delta rayToEnd
        , addToAngle (delta * -1) rayToEnd
        ]


curtail : Walls -> Line -> Maybe Line
curtail walls line =
    walls
        |> List.filterMap (intersect line)
        |> List.Extra.minimumBy (.vector >> .length)


intersect : Line -> Line -> Maybe Line
intersect ray target =
    let
        rayStart =
            start ray

        wallStart =
            start target

        rayComponents =
            components ray

        targetComponents =
            components target

        targetLength =
            ((rayStart.x * rayComponents.dy)
                - (rayStart.y * rayComponents.dx)
                + (wallStart.y * rayComponents.dx)
                - (wallStart.x * rayComponents.dy)
            )
                / ((rayComponents.dy * targetComponents.dx)
                    - (rayComponents.dx * targetComponents.dy)
                  )

        rayLength =
            (wallStart.x - rayStart.x + targetComponents.dx * targetLength)
                / rayComponents.dx
    in
        if rayLength < 0 then
            Nothing
        else if targetLength < 0 || target.vector.length < targetLength then
            Nothing
        else
            Just (withLength rayLength ray)
