module UI exposing (largeButton)

import Html exposing (..)
import Html.Attributes exposing (..)
import Illustration exposing (cheveronRight)
import VirtualDom


largeButton : String -> List (Attribute msg) -> List (Html msg) -> Html msg
largeButton element attributes nodes =
    VirtualDom.node element
        (List.concat [ [ class "mt-8 p-2 w-full flex rounded-lg bg-green-700" ], attributes ])
        [ div [ class "w-full flex justify-between items-center" ]
            [ span [ class "ml-4 font-bold text-white" ] nodes
            , span [ class "p-4 bg-white rounded-lg" ] [ cheveronRight "h-6 w-6 text-gray-800" ]
            ]
        ]
