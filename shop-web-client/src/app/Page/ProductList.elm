module Page.ProductList exposing (Model, Msg, init, update, view)

import Cart exposing (..)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Illustration
import Route exposing (href)
import Session exposing (..)
import UI



---- MODEL ----


type alias Model =
    { session : Session
    , showCartModal : Bool
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, showCartModal = False }, Cmd.none )



---- UPDATE ----


type Msg
    = None
    | AddProductToCart ( ProductId, Product )
    | RemoveProductFromCart ProductId
    | ToggleCartModal


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        AddProductToCart product ->
            ( { model | session = addCartItemToSession product model.session }, Cmd.none )

        RemoveProductFromCart productId ->
            ( { model | session = removeCartItemFromSession productId model.session }, Cmd.none )

        ToggleCartModal ->
            ( { model | showCartModal = not model.showCartModal }, Cmd.none )



---- VIEW ----


view : Model -> { title : String, body : Html Msg }
view { session, showCartModal } =
    { title = "My Kebab Shop - Menu"
    , body =
        div []
            [ if showCartModal then
                cartModalView session.cart RemoveProductFromCart

              else
                text ""
            , bottomBarView showCartModal session.cart
            , div [ class "flex" ]
                [ div [ class "max-w-6xl mx-auto mt-4 mb-12 sm:mt-12 sm:mb-4" ] (List.map categoryView categories)
                , div [ class "hidden md:block flex-shrink-0 md:h-screen w-full md:w-96 sticky top-0 flex" ]
                    [ cartView session.cart
                        RemoveProductFromCart
                        [ UI.largeButton "a" [ href Route.Checkout ] [ text "Check out" ]
                        , span [ class "md:hidden block mx-auto mt-4 mb-8", onClick None ]
                            [ button [ class "border-b-4 border-green-600" ]
                                [ text "Back to menu" ]
                            ]
                        ]
                    ]
                ]
            ]
    }


categoryView : Category -> Html Msg
categoryView category =
    div [ class "mx-4 mb-4 sm:mb-12" ]
        [ div [ class "flex justify-between items-baseline border-b-2 border-grey-900" ]
            [ h2 [ class "h-full font-display font-bold tracking-wide uppercase text-gray-800 py-4 border-b-2 border-green-700 -mb-2px" ] [ text category.name ]
            ]
        , div [ class "flex flex-wrap -mx-4 mt-6 overflow-hidden" ] (category.products |> Dict.toList |> List.map productView)
        ]


productView : ( ProductId, Product ) -> Html Msg
productView ( productId, product ) =
    div [ class "w-full max-w-sm mx-auto my-4 px-4 overflow-hidden lg:w-1/2 xl:w-1/3" ]
        [ div [ class "h-full flex flex-col bg-white shadow-xl rounded-lg" ]
            [ img [ class "h-48 rounded-t object-cover", src "https://d1ralsognjng37.cloudfront.net/c9af7d3d-a7ed-4640-bbaf-f2b4b102bbf5.jpeg" ] []
            , div [ class "mx-6 -mt-4" ]
                [ span [ class "p-3 rounded-lg text-white bg-green-700" ] [ product.price |> priceView ]
                ]
            , div [ class "mx-6 mt-8 flex" ]
                [ h3 [ class "w-full h-full font-display font-bold text-gray-800" ] [ text product.name ]
                ]
            , p [ class "mx-6 mt-2 text-sm text-gray-600" ] [ text (product.description |> Maybe.withDefault "") ]
            , div [ class "mx-6 mt-auto pt-6 pb-4 flex justify-between items-baseline" ]
                [ div [ class "text-green-700" ]
                    [ Illustration.informationOutline "h-5 w-5"
                    ]
                , button [ class "text-green-700 border-b-2 border-green-700 hover:text-green-900 hover:border-green-900", onClick (AddProductToCart ( productId, product )) ] [ text "Add To Cart" ]
                ]
            ]
        ]


bottomBarView : Bool -> Cart -> Html Msg
bottomBarView showCartModal cart =
    if Dict.size cart.items > 0 || showCartModal then
        div [ class "md:hidden h-16 w-full fixed bottom-0" ]
            [ if showCartModal then
                checkoutBarView cart

              else
                cartSummaryBar cart
            ]

    else
        text ""


checkoutBarView : Cart -> Html Msg
checkoutBarView cart =
    div [ class "h-full flex shadow-t-xl" ]
        [ button [ class "w-1/3 h-full flex items-center justify-center bg-white text-gray-700 font-bold", onClick ToggleCartModal ] [ text "Back" ]
        , a [ class "w-2/3 h-full flex items-center justify-center bg-green-700 text-white font-bold", href Route.Checkout ] [ text "Check out" ]
        ]


cartSummaryBar : Cart -> Html Msg
cartSummaryBar cart =
    button [ class "h-full w-full px-6 py-2 bg-green-700 flex items-baseline justify-between text-white", onClick ToggleCartModal ]
        [ span [ class "flex border-2 p-1 rounded" ]
            [ cart |> cartNumberOfItems |> String.fromInt |> text
            , Illustration.shoppingCart "mt-1 ml-2 h-4 w-4"
            ]
        , span [ class "font-display font-bold tracking-wide" ]
            [ text "View order"
            ]
        , span [] [ cart |> cartPrice |> priceView ]
        ]


cartModalView : Cart -> (ProductId -> msg) -> Html msg
cartModalView cart removeMsg =
    div [ class "fixed inset-0 h-full w-full overflow-y-auto" ]
        [ div [ class "relative flex h-full" ]
            [ cartView cart removeMsg []
            , div [ class "mb-24" ] []
            ]
        ]
