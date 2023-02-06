class AttributeArgument extends @attribute_arg {
  string toString() { none() }
}

class Attribute extends @attribute {
  string toString() { none() }
}

class LocationDefault extends @location_default {
  string toString() { none() }
}

from AttributeArgument arg, int kind, Attribute attr, int index, LocationDefault location
where
  attribute_args(arg, kind, attr, index, location) and
  not arg instanceof @attribute_arg_constant_expr
select arg, kind, attr, index, location
