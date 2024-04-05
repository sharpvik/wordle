module Ui exposing (..)

import Html exposing (Attribute, Html, div)
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
