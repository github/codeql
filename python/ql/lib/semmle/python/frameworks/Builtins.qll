/**
 * Provides classes modeling security-relevant aspects of built-ins.
 */

import python
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.ApiGraphs

/** A flow summary for `reversed`. */
class ReversedSummary extends SummarizedCallable {
  ReversedSummary() { this = "builtins.reversed" }

  override CallNode getACall() { result = API::builtin("reversed").getACall().getNode() }

  override DataFlow::ArgumentNode getACallback() {
    result = API::builtin("reversed").getAValueReachableFromSource()
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0].ListElement" and
    output = "ReturnValue.ListElement" and
    preservesValue = true
  }
}
