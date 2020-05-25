module Types exposing (..)

import Vectors exposing (..)


type alias Walls =
    List Vectors.Line

type alias Model =
    { walls : Walls
    , mouse : Maybe Position
    }

type Msg
    = Change Position
