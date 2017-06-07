module Model exposing (..)

import Json.Decode exposing (int, string, at, list, map, nullable, Decoder, decodeString)
import Json.Decode.Pipeline exposing (decode, required, optional, custom)
import Json.Decode.Extra exposing (date)
import Date exposing (Date)


type alias Id =
    String


type alias Process =
    { id : Id, recipe : String, started : Date, events : List String }


processDecoder : Decoder Process
processDecoder =
    decode Process
        |> required "id" string
        |> required "recipe" string
        |> required "started" date
        |> required "events" (list string)


type alias ProcessWithIngredients =
    { id : Id, ingredients : List Ingredient }


processWithIngredientsDecoder : Decoder ProcessWithIngredients
processWithIngredientsDecoder =
    decode ProcessWithIngredients
        |> required "id" string
        |> required "ingredients" (list ingredientDecoder)


type alias Processes =
    { value : List Process }


processesDecoder : Decoder Processes
processesDecoder =
    decode Processes
        |> required "value" (list processDecoder)


type alias Ingredient =
    { name : String, value : String }


ingredientDecoder : Decoder Ingredient
ingredientDecoder =
    decode Ingredient
        |> required "name" string
        |> required "value" string


type alias Event =
    { name : String, ingredients : List String }


eventDecoder : Decoder Event
eventDecoder =
    decode Event
        |> required "name" string
        |> required "ingredients" (list string)


type alias Recipe =
    { name : String, events : List Event }


recipeDecoder : Decoder Recipe
recipeDecoder =
    decode Recipe
        |> required "name" string
        |> required "events" (list eventDecoder)


type alias Recipes =
    { value : List Recipe }


recipesDecoder : Decoder Recipes
recipesDecoder =
    decode Recipes
        |> required "value" (list recipeDecoder)



-- what follows is test decoder functions and JSON data to use


processes : String
processes =
    """{
    "value" : [
        {
          "id": "436fdbcf-2505-4483-adc7-88b8e3b7c370",
          "recipe": "Carbonara cake",
          "started": "2017-05-24T15:55:11Z",
          "events": ["OvenPreheated", "ChefInfo"]
        },
        {
          "id": "e0e86e03-eb25-4ff7-ab48-a7653655e666",
          "recipe": "Carbonara cake",
          "started": "2017-04-20T15:53:06Z",
          "events": ["OvenPreheated", "OvenFailure"]
        },
        {
          "id": "e1e86e03-eb25-4ff7-ab48-a7653655e666",
          "recipe": "Carbonara cake",
          "started": "2017-04-21T15:53:06Z",
          "events": ["OvenPreheated", "OvenFailure"]
        }]
    }"""


recipes : String
recipes =
    """{
      "value": [
        {
          "name": "Carbonara cake",
          "events": [
            {
              "name": "SpaghettiCookedAndDrained",
              "ingredients": ["Spaghetti", "ResidualWaterInMil"]
            },
            {
              "name": "ChefInfo",
              "ingredients": ["ChefEmail", "ChefPhoneNumber", "ChefBirthDate"]
            },
            {
              "name": "OvenFailure",
              "ingredients": ["Reason"]
            },
            {
              "name": "Maybe",
              "description": "Give your advice",
              "ingredients": ["AnswerWithYesOrNo"]
            }
          ]
        }
      ]
    }"""


processWithIngredients : String
processWithIngredients =
    """
  {
    "id": "e0e86e03-eb25-4ff7-ab48-a7653655e666",
    "ingredients": [
      {"name": "OvenTemperature", "value": "285"},
      {"name": "SpaghettiWeight", "value": "150"},
      {"name": "ChefName", "value": "John Doe"},
      {"name": "OrderId", "value": "ABC-341234"}
    ]
  }
  """


testProcesses : Result String Processes
testProcesses =
    decodeString processesDecoder processes


testProcessWithIngredients : Result String ProcessWithIngredients
testProcessWithIngredients =
    decodeString processWithIngredientsDecoder processWithIngredients


testRecipes : Result String Recipes
testRecipes =
    decodeString recipesDecoder recipes
