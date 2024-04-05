module Letter exposing
    ( Letter
    , Type(..)
    , alt
    , array
    , box
    , inactive
    , isRussian
    , map
    , row
    , typeToString
    )

import Array exposing (Array)
import Html exposing (Attribute, Html, input, span, text)
import Html.Attributes exposing (style, type_, value)
import Json.Encode as E
import String



-- ALPHABET


isRussian : Char -> Bool
isRussian letter =
    List.member letter <| String.toList "йцукенгшщзхъфывапролджэячсмитьбюё"



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
    Array.repeat 5 <| Letter 'я' Absent


array : Array Letter -> E.Value
array letters =
    E.object [ ( "letters", E.array toJson letters ) ]


toJson : Letter -> E.Value
toJson letter =
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



-- VIEW


styles =
    [ style "border-radius" "8px"
    , style "display" "inline-block"
    , style "font-size" "1.5rem"
    , style "width" "36px"
    , style "margin" "8px"
    , style "padding" "8px 0"
    , style "text-align" "center"
    , style "caret-color" "transparent"
    , style "text-transform" "uppercase"
    ]


inactive : Letter -> Html msg
inactive { rune, ty } =
    span (styles ++ typeToStyle ty) [ text <| String.fromChar rune ]


box : List (Attribute msg) -> Letter -> Html msg
box attrs { rune, ty } =
    let
        inputStyle =
            [ type_ "text"
            , value <| String.fromChar rune
            ]
    in
    input (styles ++ inputStyle ++ typeToStyle ty ++ attrs) []


typeToStyle : Type -> List (Attribute msg)
typeToStyle ty =
    case ty of
        Absent ->
            [ style "background-color" "#5f5f5f"
            , style "color" "white"
            , style "border" "4px solid transparent"
            ]

        Present ->
            [ style "background-color" "white"
            , style "color" "black"
            , style "border" "4px solid transparent"
            ]

        Exact ->
            [ style "background-color" "#fedd30"
            , style "color" "black"
            , style "border" "4px solid transparent"
            ]



-- letterInputBoxes =
--     Array.indexedMap letterInputBox model.letters |> Array.toList
-- letterInputBox index letter =
-- historyBoxes =
--     List.map
--         (Array.map historyBox
--             >> Array.toList
--             >> div []
--         )
--         model.history
-- historyBox letter =
--     span
--         [ class <| "letter"
--         , class <| Letter.typeToString letter.ty
--         ]
--         [ text <| String.fromChar letter.rune ]
