import cpp

/*
 * Plainer output for CStyleCast, that does not reference the (potentially platform
 * dependent) type of the cast.
 */

class CStyleCastPlain extends CStyleCast {
  override string toString() { result = "Conversion of " + getExpr().toString() }
}

from Expr e
select e, e.getValue(), e.getValueText()
