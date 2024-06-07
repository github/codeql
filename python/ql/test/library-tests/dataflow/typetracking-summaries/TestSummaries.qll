private import python
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.ApiGraphs

/**
 * This module ensures that the `callStep` predicate in
 * our type tracker implementation does not refer to the
 * `getACall` predicate on `SummarizedCallable`.
 */
module RecursionGuard {
  private import semmle.python.dataflow.new.internal.TypeTrackingImpl::TypeTrackingInput as TT

  private class RecursionGuard extends SummarizedCallable {
    RecursionGuard() { this = "TypeTrackingSummariesRecursionGuard" }

    override DataFlow::CallCfgNode getACall() {
      result.getFunction().asCfgNode().(NameNode).getId() = this and
      (TT::callStep(_, _) implies any())
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      none()
    }

    override DataFlow::CallCfgNode getACallSimple() { none() }

    override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }
  }

  predicate test(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    TT::levelStepNoCall(nodeFrom, nodeTo)
  }
}

private class SummarizedCallableIdentity extends SummarizedCallable {
  SummarizedCallableIdentity() { this = "TTS_identity" }

  override DataFlow::CallCfgNode getACall() { none() }

  override DataFlow::CallCfgNode getACallSimple() {
    result.getFunction().asCfgNode().(NameNode).getId() = this
  }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

// For lambda flow to work, implement lambdaCall and lambdaCreation
private class SummarizedCallableApplyLambda extends SummarizedCallable {
  SummarizedCallableApplyLambda() { this = "TTS_apply_lambda" }

  override DataFlow::CallCfgNode getACall() { none() }

  override DataFlow::CallCfgNode getACallSimple() {
    result.getFunction().asCfgNode().(NameNode).getId() = this
  }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
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
  SummarizedCallableReversed() { this = "TTS_reversed" }

  override DataFlow::CallCfgNode getACall() { none() }

  override DataFlow::CallCfgNode getACallSimple() {
    result.getFunction().asCfgNode().(NameNode).getId() = this
  }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0].ListElement" and
    output = "ReturnValue.ListElement" and
    preservesValue = true
  }
}

private class SummarizedCallableMap extends SummarizedCallable {
  SummarizedCallableMap() { this = "TTS_list_map" }

  override DataFlow::CallCfgNode getACall() { none() }

  override DataFlow::CallCfgNode getACallSimple() {
    result.getFunction().asCfgNode().(NameNode).getId() = this
  }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
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
  SummarizedCallableAppend() { this = "TTS_append_to_list" }

  override DataFlow::CallCfgNode getACall() { none() }

  override DataFlow::CallCfgNode getACallSimple() {
    result.getFunction().asCfgNode().(NameNode).getId() = this
  }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
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
  SummarizedCallableJsonLoads() { this = "TTS_json.loads" }

  override DataFlow::CallCfgNode getACall() {
    result = API::moduleImport("json").getMember("loads").getACall()
  }

  override DataFlow::CallCfgNode getACallSimple() { none() }

  override DataFlow::ArgumentNode getACallback() {
    result = API::moduleImport("json").getMember("loads").getAValueReachableFromSource()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue.ListElement" and
    preservesValue = true
  }
}

// read and store
private class SummarizedCallableReadSecret extends SummarizedCallable {
  SummarizedCallableReadSecret() { this = "TTS_read_secret" }

  override DataFlow::CallCfgNode getACall() { none() }

  override DataFlow::CallCfgNode getACallSimple() {
    result.getFunction().asCfgNode().(NameNode).getId() = this
  }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0].Attribute[secret]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SummarizedCallableSetSecret extends SummarizedCallable {
  SummarizedCallableSetSecret() { this = "TTS_set_secret" }

  override DataFlow::CallCfgNode getACall() { none() }

  override DataFlow::CallCfgNode getACallSimple() {
    result.getFunction().asCfgNode().(NameNode).getId() = this
  }

  override DataFlow::ArgumentNode getACallback() { result.asExpr().(Name).getId() = this }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[1]" and
    output = "Argument[0].Attribute[secret]" and
    preservesValue = true
  }
}
