module Page.Checkout exposing (Model, Msg, init, update, view)

import Cart exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (attribute, class, placeholder, type_)
import Html.Events exposing (onClick)
import Illustration
import Session exposing (..)
import UI



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
    | RemoveProductFromCart ProductId


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        RemoveProductFromCart productId ->
            ( { model | session = removeCartItemFromSession productId model.session }, Cmd.none )



---- VIEW ----


view : Model -> { title : String, body : Html Msg }
view model =
    { title = "My Kebab Shop - Checkout"
    , body =
        div [ class "flex items-start" ]
            [ div [ class "hidden md:block flex-shrink-0 h-screen w-96 sticky top-0 flex" ]
                [ cartView model.session.cart RemoveProductFromCart []
                ]
            , div [ class "md:mt-12 w-full flex flex-wrap justify-center" ]
                [ div [ class "w-full max-w-lg mt-4 mx-4 p-4 sm:p-8 bg-white shadow-lg" ]
                    [ formHeader 1 "Delivery Address"
                    , form [ class "mt-8" ]
                        [ div [ class "sm:flex sm:justify-between" ]
                            [ textInput "First name" "John"
                            , div [ class "w-4" ] []
                            , textInput "Last name" "Smith"
                            ]
                        , textInput "Address" "6 Avenue de l'Hotel Dieu, Nantes"
                        , textareaInput "Address supplement" "e.g. Entry code, stairs, floor, .."
                        , textInput "Phone number" "+33 6 00 00 00 00"
                        , checkboxInput "Receive delivery time by SMS (free)" "Yes No"
                        ]
                    ]
                , div [ class "w-full max-w-lg mt-4 mx-4 p-4 sm:p-8 flex flex-col justify-between bg-white shadow-lg" ]
                    [ div []
                        [ formHeader 2 "Payment"
                        , form [ class "mt-8" ]
                            [ textInput "Card number" "4242 1312 8766 6123"
                            , textInput "Card holder" "John Smith"
                            , div [ class "flex justify-between" ]
                                [ textInput "Expiration date" "06/24"
                                , div [ class "w-4" ] []
                                , textInput "CVC" "123"
                                ]
                            ]
                        ]
                    , UI.largeButton "button" [ class "bg-gray-700" ] [ text "Pay ", model.session.cart |> cartPrice |> priceView ]
                    ]
                ]
            ]
    }


formHeader : Int -> String -> Html Msg
formHeader step title =
    div [ class "flex items-center font-display font-bold tracking-wide uppercase text-gray-800" ]
        [ div [ class "flex items-center justify-center h-6 w-6 border-2 border-green-700 rounded-full mr-3" ]
            [ span [] [ step |> String.fromInt |> text ]
            ]
        , h2 [] [ text title ]
        ]


textInput : String -> String -> Html Msg
textInput labelText placeholderText =
    div [ class "mb-6 text-gray-800" ]
        [ label [ class "font-bold tracking-wide text-sm" ] [ text labelText ]
        , input [ class "form-input mt-1 block w-full", placeholder placeholderText ] []
        ]


textareaInput : String -> String -> Html Msg
textareaInput labelText placeholderText =
    div [ class "mb-6 text-gray-800" ]
        [ label [ class "font-bold tracking-wide text-sm" ] [ text labelText ]
        , textarea [ class "form-textarea mt-1 block w-full", attribute "rows" "2", placeholder placeholderText ] []
        ]


checkboxInput : String -> String -> Html Msg
checkboxInput labelText placeholderText =
    label [ class "flex items-center" ]
        [ input [ class "form-checkbox text-green-700", type_ "checkbox", attribute "checked" "checked", placeholder placeholderText ] []
        , span [ class "ml-2 font-bold tracking-wide text-sm text-gray-800" ] [ text labelText ]
        ]
