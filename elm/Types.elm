module Types where

import Json.Encode as Json
import String
import Native.Types

type KnownTypes
    = MaybeType KnownTypes
    | ListType KnownTypes
    | IntType
    | FloatType
    | BoolType
    | StringType
    | ComplexType
    | ResolvedType String
    | Unknown


typeToKnownTypes : String -> KnownTypes
typeToKnownTypes string =
    case string of
        "Int" ->
            IntType
        "Float" ->
            FloatType
        "Bool" ->
            BoolType
        "String" ->
            StringType
        "Something" ->
            ComplexType
        _ ->
            case String.words string of
                [] ->
                    Unknown
                [x] ->
                    Unknown
                x::xs ->
                    case x of
                        "Maybe" ->
                            MaybeType (typeToKnownTypes <| String.join " " xs)
                        "List" ->
                            ListType (typeToKnownTypes <| String.join " " xs)
                        _ ->
                            Unknown

knownTypesToString : KnownTypes -> String
knownTypesToString known =
    case known of
        Unknown ->
            "_Unknown"

        ComplexType ->
            "ComplexType"

        ResolvedType name ->
            String.trim name

        IntType ->
            "IntType"

        FloatType ->
            "Float"

        StringType ->
            "String"

        BoolType ->
            "Bool"

        ListType nested ->
            "List " ++ (knownTypesToString nested)

        MaybeType nested ->
            "Maybe " ++ (knownTypesToString nested)



suggestType : Json.Value -> KnownTypes
suggestType value =
    Native.Types.makeGuessAtType value
        |> typeToKnownTypes


toValue : String -> Json.Value
toValue =
    Native.Types.toValue

keys : Json.Value -> List String
keys =
    Native.Types.keys

get : String -> Json.Value -> Maybe Json.Value
get =
    Native.Types.get

unsafeGet : String -> Json.Value -> Json.Value
unsafeGet =
    Native.Types.unsafeGet
