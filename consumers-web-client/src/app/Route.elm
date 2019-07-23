module Route exposing (Route(..), fromUrl, href, parser)

-- ROUTING

import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


type Route
    = Home


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Home ->
                    []
    in
    "/" ++ String.join "/" pieces
