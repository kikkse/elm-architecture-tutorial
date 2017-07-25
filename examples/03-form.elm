module Main exposing (..)

import Html exposing (Html, div, input, button, text, br)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Char exposing (isUpper)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias ValidationMessage =
    ( String, String )


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , age : Int
    , validation : Maybe ValidationMessage
    }


model : Model
model =
    Model "" "" "" -1 Nothing



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Validate


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Age ageEntered ->
            { model | age = Result.withDefault -1 (String.toInt ageEntered) }

        Validate ->
            let
                vm =
                    if String.length model.name < 3 then
                        ( "red", "Name must be longer than 3" )
                    else if not (String.any isUpper model.name) then
                        ( "red", "At least one character must be uppercase" )
                    else if model.password /= model.passwordAgain then
                        ( "red", "Passwords do not match" )
                    else if model.age < 0 then
                        ( "red", "Age is invalid" )
                    else
                        ( "green", "OK" )
            in
                { model | validation = Just vm }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , br [] []
        , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , input [ type_ "number", placeholder "Age", onInput Age ] []
        , button [ onClick Validate ] [ text "VALIDATE!!!" ]
        , viewValidation model.validation
        ]


viewValidation : Maybe ValidationMessage -> Html msg
viewValidation validation =
    case validation of
        Nothing ->
            div [] []

        Just ( color, message ) ->
            div [ style [ ( "color", color ) ] ] [ text message ]
