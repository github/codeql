import javascript

query predicate test_PropWriteBase(DataFlow::PropWrite p, DataFlow::Node res) { res = p.getBase() }
