class AggregateLiteral extends @aggregateliteral {
  string toString() { none() }
}

class Expr extends @expr {
  string toString() { none() }
}

from AggregateLiteral al, Expr init, int index, int position
where exprparents(init, position, al) and aggregate_array_init(al, init, index)
select al, init, index, position
