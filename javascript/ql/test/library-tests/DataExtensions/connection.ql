import javascript
private import semmle.javascript.security.dataflow.SqlInjectionCustomizations

query predicate sqlInjectionSinks(DataFlow::Node node) { node instanceof SqlInjection::Sink }
