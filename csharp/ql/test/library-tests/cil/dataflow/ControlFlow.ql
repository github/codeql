import csharp

query predicate deadCode(MethodCall c) {
  c.getTarget().getName() = "DeadCode" and
  not exists(ControlFlow::Node node | node.getElement() = c)
}
