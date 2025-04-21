class Expr extends @expr {
  string toString() { none() }
}

class AggregateLiteral extends Expr, @aggregateliteral {
  override string toString() { none() }
}

from AggregateLiteral aggregate, Expr initializer, int element_index, int position
where aggregate_array_init(aggregate, initializer, element_index, position, _)
select aggregate, initializer, element_index, position
