import csharp

private newtype TValueCategory =
  TLValue() or
  TRValue()

abstract class ValueCategory extends TValueCategory {
  abstract string toString();
}

abstract class RValue extends ValueCategory {
}

class LValue extends ValueCategory {
  override string toString() {
    result = "lvalue"
  }
}

ValueCategory getExprValueCategory(Expr expr) {
  (
     result instanceof LValue
  )
}
