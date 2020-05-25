module State exposing (..)

-- TODO: I wasn't able to get elm/mouse package, I guess I should use Browser.Events instead
import Browser
import Browser.Events as Event
import Platform.Cmd as Cmd
import Platform.Sub as Sub
import Types exposing (..)
import Json.Decode as Decode
import Vectors exposing (..)

initialModel : Model
initialModel =
    { walls =
        [ { position = { x = 0, y = 0 }, vector = { length = 600, angle = degrees 0 } }
        , { position = { x = 0, y = 600 }, vector = { length = 600, angle = degrees 0 } }
        , { position = { x = 0, y = 0 }, vector = { length = 600, angle = degrees 90 } }
        , { position = { x = 600, y = 0 }, vector = { length = 600, angle = degrees 90 } }
        , { position = { x = 400, y = 400 }, vector = { length = 50, angle = degrees 315 } }
        , { position = { x = 220, y = 400 }, vector = { length = 50, angle = degrees 290 } }
        , { position = { x = 100, y = 480 }, vector = { length = 150, angle = degrees 250 } }
        , { position = { x = 450, y = 200 }, vector = { length = 120, angle = degrees 235 } }
        , { position = { x = 70, y = 50 }, vector = { length = 300, angle = degrees 70 } }
        , { position = { x = 300, y = 150 }, vector = { length = 200, angle = degrees 30 } }
        ]
    , mouse = Nothing
    }


initialCmd : Cmd Msg
initialCmd =
    Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change position ->
            -- ( { model | mouse = Just mouse }
            ( { model | mouse = Just position }
            , Cmd.none
            )

decodeXPosition : Decode.Decoder Float
decodeXPosition =
  Decode.at ["clientX"] Decode.float

decodeYPosition : Decode.Decoder Float
decodeYPosition =
  Decode.at ["clientY"] Decode.float

log : String -> Decode.Decoder a -> Decode.Decoder a
log message =
    Decode.map (Debug.log message)

subscriptions : Model -> Sub Msg
subscriptions _ =   
  Event.onMouseMove (Decode.map2 toPositionMsg (log "X:" decodeXPosition) decodeYPosition)

toPositionMsg : Float -> Float -> Msg
toPositionMsg x y = Change (Position x y)