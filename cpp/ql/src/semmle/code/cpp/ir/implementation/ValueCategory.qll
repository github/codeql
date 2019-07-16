private import cpp

private newtype TValueCategory =
  TLValue() or
  TXValue() or
  TPRValue()

abstract class ValueCategory extends TValueCategory {
  abstract string toString();
}

abstract class GLValue extends ValueCategory {
}

abstract class RValue extends ValueCategory {
}

class LValue extends GLValue, TLValue {
  override string toString() {
    result = "lvalue"
  }
}

class XValue extends GLValue, RValue, TXValue {
  override string toString() {
    result = "xvalue"
  }
}

class PRValue extends RValue, TPRValue {
  override string toString() {
    result = "prvalue"
  }
}

ValueCategory getExprValueCategory(Expr expr) {
  (
    expr.isLValueCategory() and result instanceof LValue
  ) or (
    expr.isXValueCategory() and result instanceof XValue
  ) or (
    expr.isPRValueCategory() and result instanceof PRValue
  )
}
