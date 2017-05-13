<function> : (a -> b) -> List a -> List b
List.map (\n -> n + 1) (List.range 1 9)

type Movement = Right Int | Left Int | Stop Bool | Coordinates (Float, Float)

type Maybe a = Just a | Nothing

union types can be recursive:

type IntList = Empty | Node Int IntList
