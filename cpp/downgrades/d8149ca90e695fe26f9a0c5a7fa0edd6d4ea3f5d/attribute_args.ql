class AttributeArg extends @attribute_arg {
  string toString() { none() }
}

class Attribute extends @attribute {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

from AttributeArg arg, int kind, int kind_new, Attribute attr, int index, Location location
where
  attribute_args(arg, kind, attr, index, location) and
  if arg instanceof @attribute_arg_expr then kind_new = 0 else kind_new = kind
select arg, kind_new, attr, index, location
