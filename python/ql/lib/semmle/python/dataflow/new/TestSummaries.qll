/**
 * Provides a set of flow summaries to be used for debugging.
 * Import this file in FlowSummary.qll.
 */

private import python
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.ApiGraphs

private class SummarizedCallableIdentity extends SummarizedCallable {
  SummarizedCallableIdentity() { this = "identity" }

  override Call getACall() { result.getFunc().(Name).getId() = this }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

// For lambda flow to work, implement lambdaCall and lambdaCreation
private class SummarizedCallableApplyLambda extends SummarizedCallable {
  SummarizedCallableApplyLambda() { this = "apply_lambda" }

  override Call getACall() { result.getFunc().(Name).getId() = this }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[1]" and
    output = "Argument[0].Parameter[0]" and
    preservesValue = true
    or
    input = "Argument[0].ReturnValue" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SummarizedCallableReversed extends SummarizedCallable {
  SummarizedCallableReversed() { this = "reversed" }

  override Call getACall() { result.getFunc().(Name).getId() = this }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0].ListElement" and
    output = "ReturnValue.ListElement" and
    preservesValue = true
  }
}

private class SummarizedCallableMap extends SummarizedCallable {
  SummarizedCallableMap() { this = "map" }

  override Call getACall() { result.getFunc().(Name).getId() = this }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[1].ListElement" and
    output = "Argument[0].Parameter[0]" and
    preservesValue = true
    or
    input = "Argument[0].ReturnValue" and
    output = "ReturnValue.ListElement" and
    preservesValue = true
  }
}

// Typetracking needs to use a local flow step not including summaries
// Typetracking needs to use a call graph not including summaries
private class SummarizedCallableJsonLoads extends SummarizedCallable {
  SummarizedCallableJsonLoads() { this = "json.loads" }

  override Call getACall() {
    result = API::moduleImport("json").getMember("loads").getACall().asExpr()
  }

  override DataFlow::ArgumentNode getACallback() {
    result = API::moduleImport("json").getMember("loads").getAValueReachableFromSource()
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue.ListElement" and
    preservesValue = true
  }
}
