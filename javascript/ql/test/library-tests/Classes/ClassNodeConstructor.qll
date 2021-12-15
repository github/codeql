import javascript

query predicate test_ClassNodeConstructor(DataFlow::ClassNode class_, DataFlow::FunctionNode res) {
  res = class_.getConstructor()
}
