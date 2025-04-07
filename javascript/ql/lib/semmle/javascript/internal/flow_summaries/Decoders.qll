private import javascript
private import semmle.javascript.dataflow.FlowSummary
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.dataflow.internal.DataFlowPrivate as Private
private import FlowSummaryUtil

private class TextDecoderEntryPoint extends API::EntryPoint {
  TextDecoderEntryPoint() { this = "global.TextDecoder" }

  override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef("TextDecoder") }
}

pragma[nomagic]
API::Node textDecoderConstructorRef() { result = any(TextDecoderEntryPoint e).getANode() }

class DecodeLike extends SummarizedCallable {
  DecodeLike() { this = "TextDecoder#decode" }

  override InstanceCall getACall() {
    result =
      textDecoderConstructorRef().getAnInstantiation().getReturn().getMember("decode").getACall()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0]" and
    output = "ReturnValue"
  }
}
