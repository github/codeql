class Type extends @type {
  string toString() { none() }
}

class Expr extends @expr {
  string toString() { none() }
}

from Type decltype, Expr expr, Type basetype, boolean parentheses
where decltypes(decltype, expr, _, basetype, parentheses)
select decltype, expr, basetype, parentheses
