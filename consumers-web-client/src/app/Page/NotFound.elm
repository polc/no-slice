module Page.NotFound exposing (view)

import Html exposing (Html, a, h1, main_, text)
import Html.Attributes exposing (class, id, tabindex)
import Route exposing (..)



-- VIEW


view : { title : String, body : Html msg }
view =
    { title = "Page Not Found"
    , body =
        main_ [ id "content", class "container", tabindex -1 ]
            [ h1 [] [ text "Not Found" ]
            , a [ Route.href Route.Home ] [ text "Back to home page" ]
            ]
    }
