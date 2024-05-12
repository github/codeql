import javascript
private import semmle.javascript.security.dataflow.CommandInjectionCustomizations

query predicate commandInjectionSinks(DataFlow::Node node) {
  node instanceof CommandInjection::Sink
}
