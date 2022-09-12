private import python
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.ApiGraphs

/** This module ensures that the `callStep` predicate in
 * our type tracker implelemtation does not refer to the
 * `getACall` predicate on `SummarizedCallable`.
 */
module RecursionGuard {
  private import semmle.python.dataflow.new.internal.TypeTrackerSpecific as TT

  private class RecursionGuard extends SummarizedCallable {
    RecursionGuard() { this = "RecursionGuard" }

    override CallNode getACall() {
      result.getFunction().(NameNode).getId() = this and
      (TT::callStep(_, _) implies any())
    }

    override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }
  }
}

private class SummarizedCallableIdentity extends SummarizedCallable {
  SummarizedCallableIdentity() { this = "identity" }

  override CallNode getACall() { result.getFunction().(NameNode).getId() = this }

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

  override CallNode getACall() { result.getFunction().(NameNode).getId() = this }

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

  override CallNode getACall() { result.getFunction().(NameNode).getId() = this }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0].ListElement" and
    output = "ReturnValue.ListElement" and
    preservesValue = true
  }
}

private class SummarizedCallableMap extends SummarizedCallable {
  SummarizedCallableMap() { this = "map" }

  override CallNode getACall() { result.getFunction().(NameNode).getId() = this }

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

private class SummarizedCallableAppend extends SummarizedCallable {
  SummarizedCallableAppend() { this = "append_to_list" }

  override CallNode getACall() { result.getFunction().(NameNode).getId() = this }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = false
    or
    input = "Argument[1]" and
    output = "ReturnValue.ListElement" and
    preservesValue = true
  }
}

private class SummarizedCallableJsonLoads extends SummarizedCallable {
  SummarizedCallableJsonLoads() { this = "json.loads" }

  override CallNode getACall() {
    result = API::moduleImport("json").getMember("loads").getACall().getNode()
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
