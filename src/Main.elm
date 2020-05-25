module Main exposing (main)

{-| The entry-point for the raycaster.

@docs main
-}

import Browser
import Types exposing (..)
import State exposing (..)
import View exposing (..)

init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, initialCmd )

{-| Start the program running.
-}
--main : Program Never Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = root
        }



-- to add packages just type "npx elm install name-of/package"
-- in a new terminal (the "+"" to the right of "yarn start" )