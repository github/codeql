import javascript

query predicate test_ClassNodeInstanceMethod(
  DataFlow::ClassNode class_, string name, DataFlow::FunctionNode res
) {
  res = class_.getInstanceMethod(name)
}
