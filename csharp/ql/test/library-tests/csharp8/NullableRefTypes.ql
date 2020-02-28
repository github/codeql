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

query predicate assignableTypes(Assignable a, AnnotatedType t, string n) {
  a.getFile().getBaseName() = "NullableRefTypes.cs" and
  t.getLocation() instanceof SourceLocation and
  a.getLocation() instanceof SourceLocation and
  t = a.getAnnotatedType() and
  n = t.getAnnotations().getNullability().toString()
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

query predicate methodTypeArguments(ConstructedGeneric generic, int arg, string argument) {
  generic = any(MethodCall mc).getTarget() and
  argument = generic.getAnnotatedTypeArgument(arg).toString()
}

query predicate constructedTypes(AnnotatedConstructedType at, int i, string arg, string nullability) {
  arg = at.getTypeArgument(i).toString() and
  at.getLocation().getFile().getBaseName() = "NullableRefTypes.cs" and
  nullability = at.getAnnotations().getNullability().toString()
}

query predicate nullableTypeParameters(TypeParameter p) {
  p.getConstraints().hasNullableRefTypeConstraint() and
  p.getLocation().getFile().getBaseName() = "NullableRefTypes.cs"
}

query predicate annotatedTypeConstraints(TypeParameter p, AnnotatedType t) {
  t = p.getConstraints().getAnAnnotatedTypeConstraint() and
  t.getLocation() instanceof SourceLocation
}

query predicate typeNotAnnotated(Type type) { not exists(AnnotatedType at | at.getType() = type) }

query predicate expressionTypes(Expr expr, string type) {
  type = expr.getAnnotatedType().toString() and
  expr.getFile().getBaseName() = "NullableRefTypes.cs"
}

query predicate exprFlowState(Expr expr, string state) {
  expr.getFile().getBaseName() = "NullableRefTypes.cs" and
  (
    expr.hasMaybeNullFlowState() and state = "Maybe null"
    or
    expr.hasNotNullFlowState() and state = "Not null"
  )
}
