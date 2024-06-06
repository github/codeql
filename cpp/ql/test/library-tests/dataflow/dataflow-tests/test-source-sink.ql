import TestBase

query predicate astFlow(AstTest::DataFlow::Node source, AstTest::DataFlow::Node sink) {
  AstTest::AstFlow::flow(source, sink)
}

query predicate irFlow(IRTest::DataFlow::Node source, IRTest::DataFlow::Node sink) {
  IRTest::IRFlow::flow(source, sink)
}
