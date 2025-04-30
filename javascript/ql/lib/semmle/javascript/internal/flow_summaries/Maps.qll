/**
 * Contains flow summaries and steps modelling flow through `Map` objects.
 */

private import javascript
private import semmle.javascript.dataflow.FlowSummary
private import FlowSummaryUtil

private DataFlow::SourceNode mapConstructorRef() { result = DataFlow::globalVarRef("Map") }

class MapConstructor extends SummarizedCallable {
  MapConstructor() { this = "Map constructor" }

  override DataFlow::InvokeNode getACallSimple() {
    result = mapConstructorRef().getAnInstantiation()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[0]." + ["ArrayElement", "SetElement", "IteratorElement"] + ".Member[0]" and
      output = "ReturnValue.MapKey"
      or
      input = "Argument[0]." + ["ArrayElement", "SetElement", "IteratorElement"] + ".Member[1]" and
      output = "ReturnValue.MapValue"
      or
      input = ["Argument[0].WithMapKey", "Argument[0].WithMapValue"] and
      output = "ReturnValue"
    )
  }
}

/**
 * A read step for `Map#get`.
 *
 * This is implemented as a step instead of a flow summary, as we currently do not expose a MaD syntax
 * for map values with a known key.
 */
class MapGetStep extends DataFlow::AdditionalFlowStep {
  override predicate readStep(
    DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ
  ) {
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = "get" and
      call.getNumArgument() = 1 and
      pred = call.getReceiver() and
      succ = call
    |
      contents = DataFlow::ContentSet::mapValueFromKey(call.getArgument(0).getStringValue())
      or
      not exists(call.getArgument(0).getStringValue()) and
      contents = DataFlow::ContentSet::mapValueAll()
    )
  }
}

/**
 * A read step for `Map#set`.
 *
 * This is implemented as a step instead of a flow summary, as we currently do not expose a MaD syntax
 * for map values with a known key.
 */
class MapSetStep extends DataFlow::AdditionalFlowStep {
  override predicate storeStep(
    DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ
  ) {
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = "set" and
      call.getNumArgument() = 2 and
      pred = call.getArgument(1) and
      succ.(DataFlow::ExprPostUpdateNode).getPreUpdateNode() = call.getReceiver()
    |
      contents = DataFlow::ContentSet::mapValueFromKey(call.getArgument(0).getStringValue())
      or
      not exists(call.getArgument(0).getStringValue()) and
      contents = DataFlow::ContentSet::mapValueWithUnknownKey()
    )
  }
}

class MapGet extends SummarizedCallable {
  MapGet() { this = "Map#get" }

  override DataFlow::MethodCallNode getACallSimple() {
    none() and // TODO: Disabled for now - need MaD syntax for known map values
    result.getMethodName() = "get" and
    result.getNumArgument() = 1
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[this].MapValue" and
    output = "ReturnValue"
  }
}

class MapSet extends SummarizedCallable {
  MapSet() { this = "Map#set" }

  override DataFlow::MethodCallNode getACallSimple() {
    result.getMethodName() = "set" and
    result.getNumArgument() = 2
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = ["Argument[this].WithMapKey", "Argument[this].WithMapValue"] and
    output = "ReturnValue"
    or
    preservesValue = true and
    none() and // TODO: Disabled for now - need MaD syntax for known map values
    (
      input = "Argument[0]" and
      output = "Argument[this].MapKey"
      or
      input = "Argument[1]" and
      output = "Argument[this].MapValue"
    )
  }
}

class MapGroupBy extends SummarizedCallable {
  MapGroupBy() { this = "Map#groupBy" }

  override DataFlow::CallNode getACallSimple() {
    result = mapConstructorRef().getAMemberCall("groupBy") and
    result.getNumArgument() = 2
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[0].ArrayElement" and
      output = ["Argument[1].Parameter[0]", "ReturnValue.MapValue.ArrayElement"]
      or
      input = "Argument[1].ReturnValue" and
      output = "ReturnValue.MapKey"
    )
  }
}
