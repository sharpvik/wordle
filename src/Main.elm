module Main exposing (..)

import Array exposing (Array)
import Array.Extra as Arr
import Browser
import Html exposing (Html, button, div, input, li, span, text, ul)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onClick, onDoubleClick, onInput)
import Http
import Json.Decode exposing (Decoder, list, string)
import Json.Encode as E


type alias Model =
    { letters : Array Letter
    , words : List String
    , history : List (Array Letter)
    }


type alias Letter =
    { rune : Char, ty : Type }


replaceRune : Char -> Letter -> Letter
replaceRune char letter =
    { letter | rune = char }


altLetter : Letter -> Letter
altLetter letter =
    { letter | ty = nextType letter.ty }


nextType : Type -> Type
nextType ty =
    case ty of
        Absent ->
            Present

        Present ->
            Placed

        Placed ->
            Absent


type Type
    = Absent
    | Present
    | Placed


typeToString : Type -> String
typeToString ty =
    case ty of
        Absent ->
            "absent"

        Present ->
            "present"

        Placed ->
            "placed"


type Msg
    = GotLetterInput Int String
    | GotLetterAlt Int
    | GotPatchResponse (Result Http.Error (List String))
    | Submit
    | Restart
    | Restarted (Result Http.Error ())


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { letters = rowOfLetters
    , words = []
    , history = []
    }


rowOfLetters : Array Letter
rowOfLetters =
    Array.repeat 5 <| Letter 'з' Absent


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
                , class <| typeToString letter.ty
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
                , class <| typeToString letter.ty
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

        GotPatchResponse resp ->
            case resp of
                Ok words ->
                    ( { model
                        | words = words
                        , history = model.history ++ [ model.letters ]
                      }
                    , Cmd.none
                    )

                _ ->
                    ( { model | words = [ "FAILURE" ] }, Cmd.none )

        Submit ->
            ( model, getPossibleWords model )

        Restart ->
            ( model, restartTheGame )

        Restarted _ ->
            ( initModel, Cmd.none )


updateLetter : Int -> Char -> Model -> Model
updateLetter index char model =
    { model | letters = Arr.update index (replaceRune char) model.letters }


updateAltLetter : Int -> Model -> Model
updateAltLetter index model =
    { model | letters = Arr.update index altLetter model.letters }


restartTheGame : Cmd Msg
restartTheGame =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "/"
        , body = Http.emptyBody
        , expect = Http.expectWhatever Restarted
        , timeout = Nothing
        , tracker = Nothing
        }


getPossibleWords : Model -> Cmd Msg
getPossibleWords { letters } =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "/"
        , body = Http.jsonBody <| lettersEncoder letters
        , expect = Http.expectJson GotPatchResponse possibleWordsDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


lettersEncoder : Array Letter -> E.Value
lettersEncoder letters =
    E.object [ ( "letters", E.array letterEncoder letters ) ]


letterEncoder : Letter -> E.Value
letterEncoder letter =
    E.object
        [ ( "type", E.string <| typeToString letter.ty )
        , ( "rune", E.string <| String.fromChar letter.rune )
        ]


possibleWordsDecoder : Decoder (List String)
possibleWordsDecoder =
    list string


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
