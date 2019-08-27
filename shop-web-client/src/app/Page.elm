module Page exposing (Page(..), view)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Session exposing (Session)


{-| Determines which navbar link (if any) will be rendered as active.
Note that we don't enumerate every page here, because the navbar doesn't
have links for every page. Anything that's not part of the navbar falls
under Other.
-}
type Page
    = Other
    | ProductList


{-| Take a page's Html and frames it with a header and footer.
The caller provides the current user, so we can display in either
"signed in" (rendering username) or "signed out" mode.
isLoading is for determining whether we should show a loading spinner
in the header. (This comes up during slow page transitions.)
-}
view : Session -> Page -> { title : String, body : Html msg } -> Document msg
view session page { title, body } =
    { title = title
    , body = [ templateView body ]
    }


templateView : Html msg -> Html msg
templateView body =
    div [ class "absolute inset-0 w-full h-full bg-gray-200 font-sans antialiasing overflow-y-scroll" ]
        [ div [ class "border-t-4 border-green-700" ] [ body ]
        ]
