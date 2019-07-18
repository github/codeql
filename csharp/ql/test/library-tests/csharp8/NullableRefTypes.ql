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

query predicate arrayElements(Variable v, AnnotatedArrayType array, AnnotatedType elementType) {
  v.getFile().getBaseName() = "NullableRefTypes.cs" and
  array = v.getAnnotatedType() and
  elementType = array.getElementType()
}

query predicate returnTypes(Callable c, string t) {
  c.getFile().getBaseName() = "NullableRefTypes.cs" and
  t = c.getAnnotatedReturnType().toString()
}

query predicate typeArguments(AnnotatedConstructedType generic, int arg, string argument) {
  (
    generic.getType() = any(Variable v | v.fromSource()).getType()
    //or
    // generic.getType() = any(MethodCall mc).getTarget()
  ) and
  argument = generic.getTypeArgument(arg).toString()
}

query predicate nullableTypeParameters(TypeParameter p) {
  p.getConstraints().hasNullableRefTypeConstraint()
}

query predicate annotatedTypeConstraints(TypeParameter p, AnnotatedType t) {
  t = p.getConstraints().getAnAnnotatedTypeConstraint() and
  t.getLocation() instanceof SourceLocation
}

query predicate typeNotAnnotated(Type type) { not exists(AnnotatedType at | at.getType() = type) }
