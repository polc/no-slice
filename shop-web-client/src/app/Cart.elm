module Cart exposing (Cart, CartItem, Category, Product, ProductId, addItemToCart, cartItemPrice, cartItemView, cartNumberOfItems, cartPrice, cartSubtotalPrice, cartTaxPrice, cartView, categories, priceView, products, removeItemFromCart, updateCartItem)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Illustration exposing (hamburger)
import Route
import UI exposing (largeButton)


type alias ProductId =
    String


type alias Product =
    { name : String
    , description : Maybe String
    , price : Int
    }


type alias Category =
    { id : String
    , name : String
    , products : Dict ProductId Product
    }


type alias CartItem =
    { quantity : Int
    , product : Product
    }


type alias Cart =
    { items : Dict ProductId CartItem
    }


products : Dict String Product
products =
    Dict.fromList
        [ ( "1", Product "Doner Spring Rolls - Frühlingsrolle" (Just "Traditional Turkish pizza, toasted flatbread topped with marinated minced beef. Served with a wedge of lemon.") 1920 )
        , ( "2", Product "The Original German Doner Kebab" (Just "Your choice of doner meats with fries.") 421 )
        , ( "3", Product "Doner Nachos" (Just "Your choice of doner meats, fresh lettuce, tomato, onion and green cabbage and 3 signature sauces served in a flatbread wrap.") 222 )
        , ( "4", Product "Doner Burger" (Just "Your choice of doner meats, fresh iceberg lettuce, tomato, onion, dill pickle and our signature burger sauce served in a brioche bun.") 23 )
        , ( "5", Product "The Original German Doner Kebab" (Just "Your choice of doner meats with fries.") 165 )
        , ( "6", Product "Doner Durum Wrap" Nothing 499 )
        ]


categories : List Category
categories =
    [ Category "1" "Menus" products
    , Category "2" "Kebabs " products
    , Category "3" "Plateaux" products
    , Category "4" "Desserts" products
    ]



-- CHANGES


updateCartItem : Product -> Maybe CartItem -> Maybe CartItem
updateCartItem product mabyeCartItem =
    case mabyeCartItem of
        Just cartItem ->
            Just { cartItem | quantity = cartItem.quantity + 1 }

        Nothing ->
            Just { quantity = 1, product = product }


addItemToCart : ( ProductId, Product ) -> Cart -> Cart
addItemToCart ( productId, product ) cart =
    { cart | items = Dict.update productId (updateCartItem product) cart.items }


removeItemFromCart : ProductId -> Cart -> Cart
removeItemFromCart productId cart =
    { cart | items = Dict.remove productId cart.items }



-- VIEW


cartItemPrice : CartItem -> Int
cartItemPrice cartItem =
    cartItem.product.price * cartItem.quantity


cartSubtotalPrice : Cart -> Int
cartSubtotalPrice cart =
    Dict.foldl (\_ cartItem totalPrice -> cartItemPrice cartItem + totalPrice) 0 cart.items


cartTaxPrice : Cart -> Int
cartTaxPrice cart =
    cartSubtotalPrice cart // 239


cartPrice : Cart -> Int
cartPrice cart =
    cartSubtotalPrice cart + cartTaxPrice cart


cartNumberOfItems : Cart -> Int
cartNumberOfItems cart =
    Dict.foldl (\_ cartItem numberOfItems -> cartItem.quantity + numberOfItems) 0 cart.items


priceView : Int -> Html msg
priceView price =
    text (String.fromFloat (toFloat price / 100) ++ " €")


cartView : Cart -> (ProductId -> msg) -> List (Html msg) -> Html msg
cartView cart removeMsg buttons =
    div [ class "h-full w-full flex flex-col bg-white" ]
        [ div [ class "px-8 py-8" ]
            [ h1 [ class "font-display font-bold tracking-wide uppercase text-gray-800 py-6 border-b-2 border-green-700 -mb-2px" ] [ text "My Order" ] ]
        , div [ class "h-full rounded-t-4xl px-8 text-gray-800" ]
            ([ div [ class "flex flex-col" ]
                (case cart.items |> Dict.size of
                    0 ->
                        [ div [ class "mx-auto flex flex-col items-center text-sm" ]
                            [ Illustration.hamburger "h-32"
                            , span [ class "mt-4 text-gray-800 font-display font-bold tracking-wide" ] [ text "Your cart is empty" ]
                            , span [ class "mt-1 mb-12 text-gray-600" ] [ text "Start by adding some items from the menu" ]
                            ]
                        ]

                    _ ->
                        cart.items |> Dict.toList |> List.map (cartItemView removeMsg)
                )
             , div [ class "border-t" ] []
             , div [ class "mt-4 flex justify-between items-baseline text-sm" ]
                [ span [] [ text ("Subtotal (" ++ (cart |> cartNumberOfItems |> String.fromInt) ++ " items)") ]
                , span [] [ cart |> cartSubtotalPrice |> priceView ]
                ]
             , div [ class "mt-2 flex justify-between items-baseline text-sm" ]
                [ span [] [ text "Delivery" ]
                , span [] [ cart |> cartTaxPrice |> priceView ]
                ]
             , div [ class "mt-4 border-t" ] []
             , div [ class "mt-4 flex justify-between items-baseline" ]
                [ span [] [ text "Total" ]
                , span [ class "text-3xl" ] [ cart |> cartPrice |> priceView ]
                ]
             ]
                ++ buttons
            )
        ]


cartItemView : (ProductId -> msg) -> ( ProductId, CartItem ) -> Html msg
cartItemView removeMsg ( productId, cartItem ) =
    div [ class "mb-6 flex" ]
        [ img [ class "h-16 rounded-t object-cover", src "https://d1ralsognjng37.cloudfront.net/c9af7d3d-a7ed-4640-bbaf-f2b4b102bbf5.jpeg", alt "" ] []
        , div [ class "ml-4 flex flex-col justify-between text-sm" ]
            [ h1 [ class "font-display font-bold tracking-wide" ]
                [ text (String.fromInt cartItem.quantity ++ " x ")
                , text cartItem.product.name
                ]
            , span [ class "text-gray-600" ] [ cartItem |> cartItemPrice |> priceView ]
            ]
        , button [ class "flex-shrink-0 ml-auto h-4 w-4", onClick (removeMsg productId) ]
            [ Illustration.closeOutline "my-1 h-4 w-4"
            ]
        ]
