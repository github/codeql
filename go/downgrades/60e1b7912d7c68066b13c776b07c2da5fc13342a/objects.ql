class Type_ extends @type {
  string toString() { result = "Type" }
}

// The schema for types and typename are:
//
// types(unique int id: @type, int kind: int ref);
// objects(unique int id: @object, int kind: int ref, string name: string ref);
from Type_ type, int object, int kind
where
  objects(type, object) and
  types(type, kind) and
  kind != 40 // @typealias
select type, object
