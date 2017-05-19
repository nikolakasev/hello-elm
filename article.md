<function> : (a -> b) -> List a -> List b
List.map (\n -> n + 1) (List.range 1 9)

type Movement = Right Int | Left Int | Stop Bool | Coordinates (Float, Float)

type Maybe a = Just a | Nothing

union types can be recursive:

type IntList = Empty | Node Int IntList

predicates : List (Int -> Bool)
predicates =
  [ (\n -> n % 2 == 0)
  , (\n -> n % 3 == 0)
  ]

divisible : Int -> Bool
divisible n =
  List.all (\f -> f n) predicates