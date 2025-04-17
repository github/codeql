class Type extends @type {
  string toString() { none() }
}

class Expr extends @expr {
  string toString() { none() }
}

from Type decltype, Expr expr, Type basetype, boolean parentheses
where decltypes(decltype, expr, basetype, parentheses)
select decltype, expr, 0, basetype, parentheses
