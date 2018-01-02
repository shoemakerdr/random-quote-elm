import Html exposing (Html, button, div, text, p, a, h1)
import Html.Attributes exposing (rel, href, target, class)
import Html.Events exposing (onClick)
import Http exposing (..)
import Json.Decode as JD exposing (string, decodeString, Decoder)
import Json.Decode.Pipeline as Pipeline
import Random
import Random.List as RL


franklin : Quote
franklin = Quote "The only thing to fear is fear itself." "Franklin D Roosevelt"


main : Program Never Model Msg
main =
  Html.program
    { init =
        init franklin [] ""
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { current : Quote
  , all : List Quote
  , errorMessage : String
  }


type alias Quote =
  { quote : String
  , name : String
  }


init : Quote -> List Quote -> String -> (Model, Cmd Msg)
init current list err =
  ( Model current list err
  , getQuotes
  )



-- UPDATE


type Msg
  = FetchQuotes (Result Http.Error (List Quote))
  | GetRandomQuote
  | NewQuote (Maybe Quote, List Quote)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FetchQuotes (Ok quotes) ->
      ( { model | all = quotes }, Cmd.none)

    FetchQuotes (Err error) ->
      ( { model | errorMessage = toString error }, Cmd.none)

    GetRandomQuote ->
      (model, Random.generate NewQuote <| randomQuote model.all)

    NewQuote (current, _) ->
      case current of
        Just quote ->
          ( { model | current = quote }, Cmd.none)

        Nothing ->
          ( { model | current = franklin }, Cmd.none)


randomQuote : List Quote -> Random.Generator (Maybe Quote, List Quote)
randomQuote quotes =
  RL.choose quotes


-- VIEW


view : Model -> Html Msg
view model =
  let
    quote = model.current.quote
    name = model.current.name
    errorMessage = model.errorMessage
    twitterUrl = "https://twitter.com/intent/tweet?hashtags=FreeCodeCamp&text=" ++ quote ++ " - " ++ name
  in
    div []
      [ h1 [ class "title" ] [ text "Elm Random Quote Generator"]
      , div [ class "quote-wrapper"]
        [ p [ class "quote" ] [ text quote ]
        , p [ class "author" ] [ text name ]
        ]
      , div [ class "button-wrapper"]
        [ a [ href twitterUrl, target "__blank"]
          [ button [ class "button" ] [ text "Tweet This Quote" ]
          ]
        , button [ class "button", onClick GetRandomQuote ] [ text "New Quote" ]
        ]
      , div [] [ text errorMessage ]
      ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getQuotes : Cmd Msg
getQuotes =
  let
    url = "https://raw.githubusercontent.com/shoemakerdr/RandomQuoteProject/master/quotes.json"
  in
    Http.send FetchQuotes (Http.get url quoteListDecoder)



-- DECODER


quoteDecoder : Decoder Quote
quoteDecoder =
  Pipeline.decode Quote
  |> Pipeline.required "quote" string
  |> Pipeline.required "name" string


quoteListDecoder : Decoder (List Quote)
quoteListDecoder =
  JD.list quoteDecoder

