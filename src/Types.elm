module Types exposing (..)

import Vectors exposing (..)


type alias Walls =
    List Vectors.Line

type CursorState
    = Raycasting
    | Drawing
    | Erasing

type alias Model =
    { walls : Walls
    , mouse : Maybe Position
    , camera : Position
    , cursor : CursorState
    , vectorStart : Maybe Position
    }

type Msg
    = Change Position
    | CursorStateChange
    | SvgRootClick