module Service exposing (..)

import Array exposing (Array)
import Http
import Json.Decode as D exposing (Decoder)
import Letter exposing (Letter)



-- GET POSSIBLE WORDS


getPossibleWords : Array Letter -> (Result Http.Error (List String) -> msg) -> Cmd msg
getPossibleWords letters msg =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "/"
        , body = Http.jsonBody <| Letter.array letters
        , expect = Http.expectJson msg possibleWordsDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


possibleWordsDecoder : Decoder (List String)
possibleWordsDecoder =
    D.list D.string



-- RESTART THE GAME


restartTheGame : (Result Http.Error () -> msg) -> Cmd msg
restartTheGame msg =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "/"
        , body = Http.emptyBody
        , expect = Http.expectWhatever msg
        , timeout = Nothing
        , tracker = Nothing
        }
