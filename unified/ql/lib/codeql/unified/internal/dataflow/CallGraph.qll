private import unified
private import AllDataFlow
private import codeql.unified.internal.typeinference.TypeInference as T
private import codeql.unified.internal.NameBinding as N
private import codeql.unified.internal.ExprPositions

DataFlowCallable viableCallable(DataFlowCall c) {
  result.asSourceCallable() = T::resolveCallTarget(c.asExplicitCall())
  or
  result.asSourceCallable() = resolveAccessor(c.asGetterCall()).(GetterDeclaration)
  or
  result.asSourceCallable() = resolveAccessor(c.asSetterCall()).(SetterDeclaration)
  or
  result.asSummarizedCallable().matchesCall(c.asExplicitCall())
}

private AccessorDeclaration resolveAccessor(Expr access) {
  result.getNameNode() = N::getStaticBindingTargetFromRef(access)
}
