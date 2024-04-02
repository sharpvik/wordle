module Main exposing (..)

import Array exposing (Array)
import Array.Extra as Arr
import Browser
import Html exposing (Html, button, div, input, li, span, text, ul)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onClick, onDoubleClick, onInput)
import Http
import Letter exposing (Letter, Type(..))
import Service



-- MODEL & MSG


type alias Model =
    { letters : Array Letter
    , words : List String
    , history : List (Array Letter)
    }


type Msg
    = GotLetterInput Int String
    | GotLetterAlt Int
    | GotPossibleWords (Result Http.Error (List String))
    | Submit
    | Restart
    | Restarted (Result Http.Error ())



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { letters = Letter.row
    , words = []
    , history = []
    }



-- VIEW


view : Model -> Browser.Document Msg
view =
    Browser.Document "Wordle" << body


body : Model -> List (Html Msg)
body model =
    let
        letterInputBoxes =
            Array.indexedMap letterInputBox model.letters |> Array.toList

        letterInputBox index letter =
            input
                [ type_ "text"
                , value <| String.fromChar letter.rune
                , class <| "letter"
                , class <| Letter.typeToString letter.ty
                , onInput <| GotLetterInput index
                , onDoubleClick <| GotLetterAlt index
                ]
                []

        restartButton =
            button
                [ class "restart"
                , onClick <| Restart
                ]
                [ text "Restart" ]

        submitButton =
            button
                [ class "submit"
                , onClick <| Submit
                ]
                [ text "Submit" ]

        historyBoxes =
            List.map
                (Array.map historyBox
                    >> Array.toList
                    >> div []
                )
                model.history

        historyBox letter =
            span
                [ class <| "letter"
                , class <| Letter.typeToString letter.ty
                ]
                [ text <| String.fromChar letter.rune ]
    in
    historyBoxes
        ++ letterInputBoxes
        ++ submitButton
        :: restartButton
        :: viewPossibleWords model


viewPossibleWords : Model -> List (Html Msg)
viewPossibleWords { words } =
    List.map (\word -> li [] [ text word ]) words |> ul [] |> List.singleton



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotLetterInput index contents ->
            case String.uncons contents of
                Just ( char, _ ) ->
                    ( updateLetter index char model, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        GotLetterAlt index ->
            ( updateAltLetter index model, Cmd.none )

        GotPossibleWords response ->
            ( updatePossibleWords response model, Cmd.none )

        Submit ->
            ( model, Service.getPossibleWords model.letters GotPossibleWords )

        Restart ->
            ( model, Service.restartTheGame Restarted )

        Restarted _ ->
            ( initModel, Cmd.none )


updateLetter : Int -> Char -> Model -> Model
updateLetter index char model =
    { model | letters = Arr.update index (Letter.map char) model.letters }


updateAltLetter : Int -> Model -> Model
updateAltLetter index model =
    { model | letters = Arr.update index Letter.alt model.letters }


updatePossibleWords : Result Http.Error (List String) -> Model -> Model
updatePossibleWords response model =
    case response of
        Ok words ->
            { model
                | words = words
                , history = model.history ++ [ model.letters ]
            }

        Err (Http.BadStatus code) ->
            { model
                | words = [ "FAILURE STATUS CODE: " ++ String.fromInt code ]
            }

        Err (Http.BadBody reason) ->
            { model
                | words = [ "FAILURE TO READ BODY: " ++ reason ]
            }

        Err _ ->
            { model
                | words = [ "FAILURE" ]
            }



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
