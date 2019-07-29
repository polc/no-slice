module Page.Home exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, height, src, alt, style, width)
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
        div [ class "w-full h-full bg-gray-200 antialiasing pb-24" ]
            [ div [ class "h-2 bg-red-700" ] []
            , div [ class "max-w-4xl mx-auto" ]
              [ div [ class "m-4" ]
                  [ h1 [ class "text-2xl sm:text-4xl" ] [ text "My Bio Shop" ]
                  , p [ class "text-sm sm:text-base text-gray-600" ] [ text "6 Avenue de l'Hotel Dieu, Nantes" ]
                  , p [ class "text-sm sm:text-base text-green-800" ] [ text "Open from 11AM to 15PM" ]
                  ]
              , img [ class "h-40 w-full object-cover", alt "Bio Shop dishes", src "https://d1ralsognjng37.cloudfront.net/b52405a6-b848-4820-a1f2-ed99267801e4" ] []
              , category "Menus"
              , category "Galettes"
              , category "Plateaux"
              , category "Desserts"

              ]

            ]
    }

category : String -> Html Msg
category title =
    div []
        [ h1 [ class "m-4 text-xl font-semibold" ] [ text title ]
        , div [ class "sm:overflow-hidden"]
          [ div [ class "sm:flex sm:flex-wrap sm:-mx-2"]
              [ item "Francis Munster" "8 garden saumon, 6 fondant cheese, 8 samba acho, 50 carottes" "4,50 €"
              , item "Tony Burger" "8 garden saumon, 6 fondant cheese, 8 samba acho, 50 carottes" "4,50 €"
              , item "Carole Biquette" "8 garden saumon, 6 fondant cheese, 8 samba acho, 50 carottes" "4,50 €"
              , item "Véronique Jambon" "8 garden saumon, 6 fondant cheese, 8 samba acho, 50 carottes, 2 pommes" "4,50 €"
              , item "Florence Forestière" "8 garden saumon, 6 fondant cheese, 8 samba acho, 50 carottes, 2 pommes" "4,50 €"
              ]
          ]
        ]


item : String -> String -> String -> Html Msg
item title description price =
    div [ class "sm:w-1/2 sm:px-2 sm:my-1" ]
        [ div [ class "flex bg-white p-4 border-b rounded" ]
          [ div [ class "w-full" ]
            [ h2 [ class "text-md font-medium text-gray-800" ] [ text title ]
            , p [ class "mt-2 text-sm text-gray-600" ]
                [ span [ class "ellipsis"] [ text description ]
                ]
            , p [ class "mt-2 text-sm text-gray-800" ] [ text price ]
            ]
        , img [ class "ml-2 w-24 h-24 rounded", alt (title ++ " food"), src "https://d1ralsognjng37.cloudfront.net/3948fafc-6dc7-4f0e-b654-64ab0d67422e.jpeg" ] []

          ]
        ]
