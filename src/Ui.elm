module Ui exposing (..)

import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (style)


container : List (Attribute msg) -> List (Html msg) -> Html msg
container attrs tags =
    let
        myattrs =
            [ style "width" "90%"
            , style "max-width" "680px"
            , style "margin" "auto"
            ]
    in
    div (myattrs ++ attrs) tags


button_ attrs messsage =
    let
        myattrs =
            [ style "border-radius" "8px"
            , style "border" "4px transparent"
            , style "display" "inline-block"
            , style "font-size" "1.5rem"
            , style "margin" "8px"
            , style "padding" "4px 8px"
            , style "text-align" "center"
            , style "cursor" "pointer"
            , style "color" "black"
            ]
    in
    button (myattrs ++ attrs) [ text messsage ]
