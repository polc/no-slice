module Page.NotFound exposing (Model, init, view)

import Html exposing (Html, a, h1, main_, text)
import Html.Attributes exposing (class, id, tabindex)
import Route exposing (..)
import Session exposing (Session)


type alias Model =
    { session : Session
    }


init : Session -> Model
init session =
    { session = session }



-- VIEW


view : { title : String, body : Html msg }
view =
    { title = "Page Not Found"
    , body =
        main_ [ id "content", class "container", tabindex -1 ]
            [ h1 [] [ text "Not Found" ]
            , a [ Route.href Route.ProductList ] [ text "Back to home page" ]
            ]
    }
