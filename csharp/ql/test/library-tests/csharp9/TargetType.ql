import csharp

query predicate conditional(ConditionalExpr expr, string t, string t1, string t2) {
  expr.getType().toStringWithTypes() = t and
  expr.getThen().getType().toStringWithTypes() = t1 and
  expr.getElse().getType().toStringWithTypes() = t2
}

query predicate implicitCasts(CastExpr expr, string type, string childType) {
  expr.getFile().getStem() = "TargetType" and
  expr.fromSource() and
  not exists(expr.getTypeAccess()) and
  type = expr.getType().toStringWithTypes() and
  childType = expr.getExpr().getType().toStringWithTypes()
}

query predicate implicitConversions(OperatorCall opCall, string type, string childType) {
  opCall.getFile().getStem() = "TargetType" and
  opCall.fromSource() and
  opCall.getTarget().getFunctionName() = "op_Implicit" and
  opCall.getTarget().getReturnType().toStringWithTypes() = type and
  opCall.getAnArgument().getType().toStringWithTypes() = childType
}
