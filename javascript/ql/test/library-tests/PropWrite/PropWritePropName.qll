import javascript

query predicate test_PropWritePropName(DataFlow::PropWrite p, string res) {
  res = p.getPropertyName()
}
