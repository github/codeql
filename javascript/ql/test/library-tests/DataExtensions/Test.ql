import javascript
private import semmle.javascript.security.dataflow.CommandInjectionCustomizations
private import semmle.javascript.security.dataflow.SqlInjectionCustomizations

query predicate commandInjectionSinks(DataFlow::Node node) {
  node instanceof CommandInjection::Sink
}

query predicate sqlInjectionSinks(DataFlow::Node node) { node instanceof SqlInjection::Sink }

query predicate remoteFlowSources(RemoteFlowSource node) { any() }
