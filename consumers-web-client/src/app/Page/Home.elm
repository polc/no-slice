module Page.Home exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Session exposing (Session)



---- MODEL ----


type alias Model =
    { session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session }, Cmd.none )



---- UPDATE ----


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> { title : String, body : Html Msg }
view model =
    { title = "Welcome on Bio App !"
    , body =
        div []
            [ h1 [ class "text-xl text-blue-500" ] [ text "Welcome on Bio App !" ]
            , img [ class "img-logo" ] []
            ]
    }
