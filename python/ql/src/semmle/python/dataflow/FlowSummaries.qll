/**
 * Flow summaries of specific functions
 * We may want to move these out into the framework models.
 */

import python
private import new.DataFlow
private import semmle.python.ApiGraphs
import FlowSummary

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
    SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
  ) {
    input = SummaryComponentStack::singleton(SummaryComponent::parameter(0)) and
    output =
      SummaryComponentStack::push(SummaryComponent::content(any(DataFlow::ListElementContent c)),
        SummaryComponentStack::return()) and
    preservesValue = false
  }
}

private class ListElementContentRequired extends RequiredSummaryComponentStack {
  ListElementContentRequired() { this = SummaryComponentStack::return() }

  override predicate required(SummaryComponent c) {
    c = SummaryComponent::content(any(DataFlow::ListElementContent lec))
  }
}
