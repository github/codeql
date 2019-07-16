import csharp

private newtype TValueCategory =
  TLValue() or
  TRValue()

abstract class ValueCategory extends TValueCategory {
  abstract string toString();
}

abstract class RValue extends ValueCategory {
}

abstract class LValue extends ValueCategory {
}

//ValueCategory getExprValueCategory(Expr expr) {
//  (
//     result instanceof LValue
//  )
//}
