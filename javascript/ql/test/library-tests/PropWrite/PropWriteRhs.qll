import javascript

query predicate test_PropWriteRhs(DataFlow::PropWrite p, DataFlow::Node res) { res = p.getRhs() }
