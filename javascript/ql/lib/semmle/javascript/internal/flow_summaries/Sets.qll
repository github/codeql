/**
 * Contains flow summaries and steps modelling flow through `Set` objects.
 */

private import javascript
private import semmle.javascript.dataflow.FlowSummary
private import FlowSummaryUtil

private DataFlow::SourceNode setConstructorRef() { result = DataFlow::globalVarRef("Set") }

class SetConstructor extends SummarizedCallable {
  SetConstructor() { this = "Set constructor" }

  override DataFlow::InvokeNode getACallSimple() {
    result = setConstructorRef().getAnInstantiation()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[0]." + ["ArrayElement", "SetElement", "IteratorElement"] and
      output = "ReturnValue.SetElement"
      or
      input = "Argument[0].MapKey" and
      output = "ReturnValue.SetElement.Member[0]"
      or
      input = "Argument[0].MapValue" and
      output = "ReturnValue.SetElement.Member[1]"
    )
  }
}

class SetAdd extends SummarizedCallable {
  SetAdd() { this = "Set#add" }

  override DataFlow::MethodCallNode getACallSimple() {
    result.getMethodName() = "add" and
    result.getNumArgument() = 1
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0]" and
    output = "Argument[this].SetElement"
  }
}
