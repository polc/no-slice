module Session exposing (Session, User(..), addCartItemToSession, init, removeCartItemFromSession)

import Browser.Navigation as Nav
import Cart exposing (..)
import Dict exposing (Dict)



-- TYPES


type User
    = LoggedIn
    | Guest


type alias Session =
    { user : User
    , navKey : Nav.Key
    , cart : Cart
    }



-- CHANGES


init : Nav.Key -> Session
init navKey =
    { user = Guest
    , navKey = navKey
    , cart = { items = Dict.empty }
    }


addCartItemToSession : ( ProductId, Product ) -> Session -> Session
addCartItemToSession item session =
    { session | cart = addItemToCart item session.cart }


removeCartItemFromSession : ProductId -> Session -> Session
removeCartItemFromSession productId session =
    { session | cart = removeItemFromCart productId session.cart }
