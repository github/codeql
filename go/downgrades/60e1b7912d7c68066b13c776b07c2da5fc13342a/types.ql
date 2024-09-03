class Type_ extends @type {
  string toString() { result = "Type" }
}

// The schema for types is:
//
// types(unique int id: @type, int kind: int ref);
from Type_ type, int kind
where
  types(type, kind) and
  kind != 40 // @typealias
select type, kind
