module Letter exposing
    ( Letter
    , Type(..)
    , alt
    , array
    , map
    , row
    , typeToString
    )

import Array exposing (Array)
import Json.Encode as E



-- LETTER


type alias Letter =
    { rune : Char, ty : Type }


map : Char -> Letter -> Letter
map char letter =
    { letter | rune = char }


alt : Letter -> Letter
alt letter =
    { letter | ty = nextType letter.ty }


row : Array Letter
row =
    Array.repeat 5 <| Letter 'з' Absent


array : Array Letter -> E.Value
array letters =
    E.object [ ( "letters", E.array value letters ) ]


value : Letter -> E.Value
value letter =
    E.object
        [ ( "type", E.string <| typeToString letter.ty )
        , ( "rune", E.string <| String.fromChar letter.rune )
        ]



-- TYPE


type Type
    = Absent
    | Present
    | Exact


typeToString : Type -> String
typeToString ty =
    case ty of
        Absent ->
            "absent"

        Present ->
            "present"

        Exact ->
            "exact"


nextType : Type -> Type
nextType ty =
    case ty of
        Absent ->
            Present

        Present ->
            Exact

        Exact ->
            Absent
