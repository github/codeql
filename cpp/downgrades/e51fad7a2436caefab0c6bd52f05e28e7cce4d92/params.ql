class Parameter extends @parameter {
  string toString() { none() }
}

class ParameterizedElement extends @parameterized_element {
  string toString() { none() }
}

class Type extends @type {
  string toString() { none() }
}

from Parameter param, ParameterizedElement pe, int index, Type type
where
  params(param, pe, index, type) and
  not pe instanceof @requires_expr
select param, pe, index, type
