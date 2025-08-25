class Expr extends @expr {
  string toString() { none() }
}

class AggregateLiteral extends Expr, @aggregateliteral {
  override string toString() { none() }
}

class MemberVariable extends @membervariable {
  string toString() { none() }
}

from AggregateLiteral aggregate, Expr initializer, MemberVariable field, int position
where aggregate_field_init(aggregate, initializer, field, position)
select aggregate, initializer, field, position, false
