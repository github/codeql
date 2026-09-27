private import unified
private import AllDataFlow
private import codeql.unified.internal.NameBinding as N

private Callable getCallableFromNameBinding(NameBinding binding) {
  binding = result.(FunctionDeclaration).getNameNode()
}

DataFlowCallable viableCallable(DataFlowCall c) {
  exists(CallExpr call, Callable callable, NameBinding target |
    c.asExplicitCall() = call and
    target = N::getStaticBindingTarget(N::getIdentifierFromRef(call.getCallee())) and
    callable = getCallableFromNameBinding(target) and
    result.asSourceCallable() = callable
  )
}
