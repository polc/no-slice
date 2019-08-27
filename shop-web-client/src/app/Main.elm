module Main exposing (Model, init, main, subscriptions, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Page
import Page.Checkout as Checkout
import Page.NotFound as NotFound
import Page.ProductList as ProductList
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)



-- MODEL


type Model
    = NotFound NotFound.Model
    | ProductList ProductList.Model
    | Checkout Checkout.Model


type Msg
    = Ignored
    | ClickedLink Browser.UrlRequest
    | ChangedUrl Url
    | ChangedRoute (Maybe Route)
    | GotProductListMsg ProductList.Msg
    | GotCheckoutMsg Checkout.Msg


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    changeRouteTo (Route.fromUrl url) (Session.init key)



-- UPDATE


toSession : Model -> Session
toSession model =
    case model of
        ProductList value ->
            value.session

        Checkout value ->
            value.session

        NotFound value ->
            value.session


changeRouteTo : Maybe Route -> Session -> ( Model, Cmd Msg )
changeRouteTo maybeRoute session =
    case maybeRoute of
        Nothing ->
            ( NotFound (NotFound.init session), Cmd.none )

        Just Route.ProductList ->
            updateWith ProductList GotProductListMsg (ProductList.init session)

        Just Route.Checkout ->
            updateWith Checkout GotCheckoutMsg (Checkout.init session)


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( Ignored, _ ) ->
            ( model, Cmd.none )

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl (toSession model).navKey (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) (toSession model)

        ( ChangedRoute route, _ ) ->
            changeRouteTo route (toSession model)

        ( GotProductListMsg subMsg, ProductList subModel ) ->
            ProductList.update subMsg subModel
                |> updateWith ProductList GotProductListMsg

        ( GotCheckoutMsg subMsg, Checkout subModel ) ->
            Checkout.update subMsg subModel
                |> updateWith Checkout GotCheckoutMsg

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view (toSession model) page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        NotFound _ ->
            viewPage Page.Other (\_ -> Ignored) NotFound.view

        ProductList productList ->
            viewPage Page.ProductList GotProductListMsg (ProductList.view productList)

        Checkout checkout ->
            viewPage Page.Other GotCheckoutMsg (Checkout.view checkout)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }
