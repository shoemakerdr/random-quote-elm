import Html exposing (Html, button, div, text, p)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


franklin : Quote
franklin = Quote "The only thing to fear is fear itself." "Franklin D Roosevelt"


main : Program Never Model Msg
main =
  Html.program
    { init =
        init franklin []
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { current : Quote
  , all : List Quote
  }


type alias Quote =
  { quote : String
  , author : String
  }


init : Quote -> List Quote -> (Model, Cmd Msg)
init current list =
  ( Model current list
  , Cmd.none
  )



-- UPDATE


type Msg
  = Tweet
  | FetchQuotes
  | GetRandomQuote
  | NewQuote Quote


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tweet ->
      (model, Cmd.none)

    FetchQuotes ->
      (model, Cmd.none)

    GetRandomQuote ->
      (model, Cmd.none)

    NewQuote current ->
      ( { model | current = current }, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  let
    quote = model.current.quote
    author = model.current.author
  in
    div []
      [ div []
        [ p [style [("text-align", "center")] ] [ text quote ]
        , p [style [("text-align", "center")] ] [ text ("- " ++ author)]
        ]
      , button [ onClick Tweet ] [ text "Tweet This Quote" ]
      , button [ onClick GetRandomQuote ] [ text "New Quote" ]
      ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


-- getRandomGif : String -> Cmd Msg
-- getRandomGif topic =
  -- let
    -- url =
      -- "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  -- in
    -- Http.send NewGif (Http.get url decodeGifUrl)


-- decodeGifUrl : Decode.Decoder String
-- decodeGifUrl =
  -- Decode.at ["data", "image_url"] Decode.string
