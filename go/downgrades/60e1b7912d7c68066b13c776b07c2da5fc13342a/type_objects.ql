class Type_ extends @type {
  string toString() { result = "Type" }
}

class Object_ extends @object {
  string toString() { result = "Object" }
}

// The schema for types and typename are:
//
// types(unique int id: @type, int kind: int ref);
// type_objects(unique int tp: @type ref, int object: @object ref);
from Type_ type, Object_ object, int kind
where
  type_objects(type, object) and
  types(type, kind) and
  kind != 40 // @typealias
select type, object
