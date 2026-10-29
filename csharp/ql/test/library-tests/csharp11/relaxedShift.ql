import csharp

query predicate userdefinedoperators(BinaryOperator op, string qlclass, Type t) {
  op.getFile().getStem() = "RelaxedShift" and
  qlclass = op.getAPrimaryQlClass() and
  t = op.getDeclaringType() and
  op != op.getUnboundDeclaration()
}

query predicate binaryoperatorcalls(OperatorCall oc, BinaryOperator o, Expr left, Expr right) {
  oc.getFile().getStem() = "RelaxedShift" and
  o = oc.getTarget() and
  left = oc.getArgument(0) and
  right = oc.getArgument(1)
}
