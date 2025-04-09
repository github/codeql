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

class TypedArraySet extends SummarizedCallable {
  TypedArraySet() { this = "TypedArray#set" }

  override InstanceCall getACall() {
    result = typedArrayConstructorRef().getInstance().getMember("set").getACall()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0].ArrayElement" and
    output = "Argument[this].ArrayElement"
  }
}

class TypedArraySubarray extends SummarizedCallable {
  TypedArraySubarray() { this = "TypedArray#subarray" }

  override InstanceCall getACall() { result.getMethodName() = "subarray" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[this].ArrayElement" and
    output = "ReturnValue.ArrayElement"
  }
}

private class ArrayBufferEntryPoint extends API::EntryPoint {
  ArrayBufferEntryPoint() { this = ["global.ArrayBuffer", "global.SharedArrayBuffer"] }

  override DataFlow::SourceNode getASource() {
    result = DataFlow::globalVarRef(["ArrayBuffer", "SharedArrayBuffer"])
  }
}

pragma[nomagic]
API::Node arrayBufferConstructorRef() { result = any(ArrayBufferEntryPoint a).getANode() }

class ArrayBufferConstructorSummary extends SummarizedCallable {
  ArrayBufferConstructorSummary() { this = "ArrayBuffer constructor" }

  override DataFlow::InvokeNode getACall() {
    result = arrayBufferConstructorRef().getAnInstantiation()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0].ArrayElement" and
    output = "ReturnValue.ArrayElement"
  }
}

class TransferLike extends SummarizedCallable {
  TransferLike() { this = "ArrayBuffer#transfer" }

  override InstanceCall getACall() {
    result.getMethodName() = ["transfer", "transferToFixedLength"]
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[this].ArrayElement" and
    output = "ReturnValue.ArrayElement"
  }
}
