class TypeParamType_ extends @typeparamtype {
  string toString() { result = "Type Param Type" }
}

class CompositeType_ extends @compositetype {
  string toString() { result = "Composite Type" }
}

class DeclaredFunction_ extends @declfunctionobject {
  string toString() { result = "Declared Function" }

  // Ident_ getDeclaration() { defs(result, this) }
  string getName() { objects(this, _, result) }
}

from TypeParamType_ tp, string name, CompositeType_ bound, DeclaredFunction_ declFunction
where
  typeparam(tp, name, bound) and
  declFunction = min(DeclaredFunction_ df | | df order by df.getName())
select tp, name, bound, declFunction, 0
