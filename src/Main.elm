import Html exposing (Html, button, div, text, p)
import Html.Events exposing (onClick)


main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }


-- MODEL

type alias Model = 
  { quote : String
  , author : String
  }

model : Model
model =
  { quote = "The only thing to fear is fear itself."
  , author = "Franklin D Roosevelt"
  }


-- UPDATE

type Msg
  = Tweet
  | NewQuote


update : Msg -> Model -> Model
update msg model =
  case msg of
    Tweet ->
      model

    NewQuote ->
      model


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] 
      [ p [] [ text model.quote ]
      , p [] [ text ("- " ++ model.author)]
      ]
    , button [ onClick Tweet ] [ text "Tweet This Quote" ]
    , button [ onClick NewQuote ] [ text "New Quote" ]
    ]
