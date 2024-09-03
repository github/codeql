class Type_ extends @type {
  string toString() { result = "Type" }
}

// The schema for types and typename are:
//
// types(unique int id: @type, int kind: int ref);
// typename(unique int tp: @type ref, string name: string ref);
from Type_ type, string name, int kind
where
  typename(type, name) and
  types(type, kind) and
  kind != 40 // @typealias
select type, name
