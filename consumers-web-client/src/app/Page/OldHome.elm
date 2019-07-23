module Page.Home exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Session exposing (Session)



---- MODEL ----


type alias Model =
    { session : Session
    , clicks : Int
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, clicks = 0 }, Cmd.none )



---- UPDATE ----


type Msg
    = Increment


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | clicks = model.clicks + 100 }, Cmd.none )



---- VIEW ----


view : Model -> { title : String, body : Html Msg }
view model =
    { title = "Buy some food"
    , body =
        div []
            [ h1 [ class "text-lg text-purple-600" ] [ text "Welcome on Click App !" ]
            , h2 [ class "subtitle" ] [ text ("You clicked " ++ String.fromInt model.clicks ++ " time") ]
            , button [ onClick Increment, class "btn btn-blue" ] [ text "Click here!" ]
            , img [ class "img-logo" ] []
            ]
    }
