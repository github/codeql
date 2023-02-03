private import codeql.ruby.frameworks.Twirp
private import codeql.ruby.DataFlow

query predicate sourceTest(DataFlow::Node s) { s instanceof Twirp::UnmarshaledParameter }

query predicate ssrfSinkTest(DataFlow::Node n) { n instanceof Twirp::ServiceUrlAsSsrfSink }

query predicate serviceInstantiationTest(DataFlow::Node n) {
  n instanceof Twirp::ServiceInstantiation
}
