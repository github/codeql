import cpp

class SomeCStyleCast extends CStyleCast {
  override string toString() { result = "(some cast)..." }
}

from Expr e
select e
