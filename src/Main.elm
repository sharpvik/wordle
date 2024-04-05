module Main exposing (..)

import Array exposing (Array)
import Array.Extra as Arr
import Browser
import Browser.Dom exposing (focus)
import Html exposing (Html, button, div, li, text, ul)
import Html.Attributes exposing (id, style)
import Html.Events exposing (onClick, onDoubleClick, onInput)
import Http
import Letter exposing (Letter, Type(..), isRussian)
import Service
import Task
import Ui exposing (container)



-- MODEL & MSG


type alias Model =
    { letters : Array Letter
    , words : List String
    , history : List (Array Letter)
    , focused : Int
    }


type Msg
    = Ignore
    | GotLetterInput String
    | GotLetterAlt Int
    | GotPossibleWords (Result Http.Error (List String))
    | Submit
    | Restart
    | Restarted (Result Http.Error ())



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, useBox 0 )


initModel : Model
initModel =
    { letters = Letter.row
    , words = []
    , history = []
    , focused = 0
    }



-- VIEW


view : Model -> Browser.Document Msg
view =
    Browser.Document "Wordle" << body


body : Model -> List (Html Msg)
body model =
    let
        historyBoxes =
            List.map
                (Array.map Letter.inactive
                    >> Array.toList
                    >> div []
                )
                model.history

        inputBoxes =
            Array.indexedMap box model.letters |> Array.toList

        box index =
            Letter.box <|
                [ onInput <| GotLetterInput
                , onDoubleClick <| GotLetterAlt index
                , id <| boxId index
                ]
                    ++ (if index == model.focused then
                            [ style "border" "4px solid #fedd30" ]

                        else
                            []
                       )

        restartButton =
            button
                [ onClick Restart
                , style "background-color" "red"
                , style "border" "4px solid red"
                , style "border-radius" "8px"
                , style "display" "inline-block"
                , style "font-size" "1.5rem"
                , style "margin" "8px"
                , style "padding" "4px 8px"
                , style "text-align" "center"
                , style "cursor" "pointer"
                ]
                [ text "Restart" ]

        submitButton =
            button
                [ onClick Submit
                , style "background-color" "darkorange"
                , style "border" "4px solid darkorange"
                , style "border-radius" "8px"
                , style "display" "inline-block"
                , style "font-size" "1.5rem"
                , style "margin" "8px"
                , style "padding" "4px 8px"
                , style "text-align" "center"
                , style "cursor" "pointer"
                ]
                [ text "Submit" ]
    in
    historyBoxes
        ++ inputBoxes
        ++ submitButton
        :: restartButton
        :: viewPossibleWords model
        |> container []
        |> List.singleton


viewPossibleWords : Model -> List (Html Msg)
viewPossibleWords { words } =
    let
        item word =
            li
                [ style "display" "inline-block"
                , style "padding" "8px"
                , style "margin" "8px"
                , style "background-color" "white"
                ]
                [ text word ]
    in
    List.map item words |> ul [] |> List.singleton



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Ignore ->
            ( model, Cmd.none )

        GotLetterInput contents ->
            case String.uncons <| String.reverse contents of
                Just ( char, _ ) ->
                    if isRussian char then
                        ( updateLetter char model, Cmd.none )

                    else if char == ' ' then
                        ( updateAltLetter model.focused model, Cmd.none )

                    else if Char.isDigit char then
                        ( char
                            |> String.fromChar
                            |> String.toInt
                            |> Maybe.withDefault 0
                            |> (\n -> n - 1)
                            |> setFocus model
                        , Cmd.none
                        )

                    else
                        ( model, Cmd.none )

                Nothing ->
                    ( shiftFocus -1 model, Cmd.none )

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


updateLetter : Char -> Model -> Model
updateLetter char model =
    { model | letters = Arr.update model.focused (Letter.map char) model.letters }
        |> shiftFocus 1


shiftFocus : Int -> Model -> Model
shiftFocus shift model =
    setFocus model <| model.focused + shift


setFocus : Model -> Int -> Model
setFocus model id =
    { model | focused = modBy 5 id }


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



-- CMD


useBox : Int -> Cmd Msg
useBox =
    Task.attempt (\_ -> Ignore) << focus << boxId


boxId : Int -> String
boxId =
    String.fromInt >> (++) "box"



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
