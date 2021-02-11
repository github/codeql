import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.frameworks.Stdlib as Stdlib
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate

// private import semmle.python.dataflow.new.RemoteFlowSources
/**
 * A call to `json.loads`
 * See https://docs.python.org/3/library/json.html#json.loads
 */
private class JsonLoads extends SummarizedCallable {
  JsonLoads() {
    this.getCallableValue().getName() = "loads"
    // this = any(JsonLoadsCall c).getCallable()  // gives non-monotonic recursion
    // this.getACall() = API::moduleImport("json").getMember("loads").getAUse().asCfgNode() // gives non-monotonic recursion
  }

  override predicate propagatesFlow(
    SummaryInput input, ContentList inputContents, SummaryOutput output, ContentList outputContents,
    boolean preservesValue
  ) {
    input = SummaryInput::parameter(0) and
    inputContents = ContentList::empty() and
    output = SummaryOutput::return() and
    outputContents = ContentList::listElement() and
    preservesValue = false
  }
}

private class JsonLoadsCall extends DataFlow::CfgNode {
  JsonLoadsCall() { this = API::moduleImport("json").getMember("loads").getACall() }

  DataFlowPrivate::DataFlowCallable getCallable() { result.getACall() = node }
}
