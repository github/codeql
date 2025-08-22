/**
 * Defines the default source and sink recognition for `InlineFlowTest.qll`.
 *
 * We reuse these predicates in some type-tracking tests that don't wish to bring in the
 * test configuration from `InlineFlowTest`.
 */

private import javascript

predicate defaultSource(DataFlow::Node src) { src.(DataFlow::CallNode).getCalleeName() = "source" }

predicate defaultSink(DataFlow::Node sink) {
  exists(DataFlow::CallNode call | call.getCalleeName() = "sink" | sink = call.getAnArgument())
}

bindingset[src]
string getSourceArgString(DataFlow::Node src) {
  src.(DataFlow::CallNode).getAnArgument().getStringValue() = result
  or
  src.(DataFlow::ParameterNode).getName() = result
}
