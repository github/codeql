class AggregateLiteral extends @aggregateliteral {
  string toString() { none() }
}

class Expr extends @expr {
  string toString() { none() }
}

class Field extends @membervariable {
  string toString() { none() }
}

from AggregateLiteral al, Expr init, Field field, int position
where exprparents(init, position, al) and aggregate_field_init(al, init, field)
select al, init, field, position
