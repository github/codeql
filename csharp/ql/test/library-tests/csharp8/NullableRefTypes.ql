import csharp
import semmle.code.csharp.dataflow.Nullness

query predicate suppressNullableWarnings(SuppressNullableWarningExpr e, Expr op) {
  op = e.getExpr()
}

query predicate nullableDataFlow(DataFlow::Node src, DataFlow::Node sink) {
  src.getEnclosingCallable().hasName("TestSuppressNullableWarningExpr") and
  DataFlow::localFlowStep(src, sink)
}

query predicate nullableControlFlow(
  ControlFlow::Node a, ControlFlow::Node b, ControlFlow::SuccessorType t
) {
  a.getEnclosingCallable().hasName("TestSuppressNullableWarningExpr") and
  b = a.getASuccessorByType(t)
}

query predicate nonNullExpressions(NonNullExpr e) {
  e.getEnclosingCallable().getName() = "TestSuppressNullableWarningExpr"
}

query predicate assignableTypes(Assignable a, AnnotatedType t) {
  a.getFile().getBaseName() = "NullableRefTypes.cs" and
  t.getLocation() instanceof SourceLocation and
  a.getLocation() instanceof SourceLocation and
  t = a.getAnnotatedType()
}

query predicate arrayElements(Variable v, ArrayType array, AnnotatedType elementType) {
  v.getFile().getBaseName() = "NullableRefTypes.cs" and
  array = v.getType() and
  elementType = array.getAnnotatedElementType()
}

query predicate returnTypes(Callable c, string t) {
  c.getFile().getBaseName() = "NullableRefTypes.cs" and
  t = c.getAnnotatedReturnType().toStringWithTypes()
}

query predicate typeArguments(ConstructedGeneric generic, int arg, string argument) {
  (
    generic = any(Variable v | v.fromSource()).getType()
    or
    generic = any(MethodCall mc).getTarget()
  ) and
  argument = generic.getAnnotatedTypeArgument(arg).toStringWithTypes()
}

query predicate nullableTypeParameters(TypeParameter p) {
  p.getConstraints().hasNullableRefTypeConstraint()
}

query predicate annotatedTypeConstraints(TypeParameter p, AnnotatedType t) {
  t = p.getConstraints().getAnAnnotatedTypeConstraint() and
  t.getLocation() instanceof SourceLocation
}

