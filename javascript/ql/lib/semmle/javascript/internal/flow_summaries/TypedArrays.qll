private import javascript
private import semmle.javascript.dataflow.FlowSummary
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.dataflow.internal.DataFlowPrivate as Private
private import FlowSummaryUtil

private class TypedArrayEntryPoint extends API::EntryPoint {
  TypedArrayEntryPoint() { this = "global.Uint8Array" }

  override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef("Uint8Array") }
}

pragma[nomagic]
API::Node typedArrayConstructorRef() { result = any(TypedArrayEntryPoint e).getANode() }

class TypedArrayConstructorSummary extends SummarizedCallable {
  TypedArrayConstructorSummary() { this = "TypedArray constructor" }

  override DataFlow::InvokeNode getACall() {
    result = typedArrayConstructorRef().getAnInstantiation()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0].ArrayElement" and
    output = "ReturnValue.ArrayElement"
  }
}

class BufferTypedArray extends DataFlow::AdditionalFlowStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::PropRead p |
      p = typedArrayConstructorRef().getInstance().getMember("buffer").asSource() and
      pred = p.getBase() and
      succ = p
    )
  }
}
