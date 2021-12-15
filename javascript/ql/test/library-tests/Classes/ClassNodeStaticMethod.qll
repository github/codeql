import javascript

query predicate test_ClassNodeStaticMethod(
  DataFlow::ClassNode class_, string name, DataFlow::FunctionNode res
) {
  res = class_.getStaticMethod(name)
}
