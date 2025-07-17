/** Definitions for reasoning about loop variable capture issues. */

import python
import semmle.python.dataflow.new.DataFlow

/** A looping construct. */
abstract class Loop extends AstNode {
  /**
   * Gets a loop variable of this loop.
   * For example, `x` and `y` in `for x,y in pairs: print(x+y)`
   */
  abstract Variable getALoopVariable();
}

/** A `for` loop. */
private class ForLoop extends Loop, For {
  override Variable getALoopVariable() {
    this.getTarget() = result.getAnAccess().getParentNode*() and
    result.getScope() = this.getScope()
  }
}

/** Holds if the callable `capturing` captures the variable `var` from the loop `loop`. */
predicate capturesLoopVariable(CallableExpr capturing, Loop loop, Variable var) {
  var.getAnAccess().getScope() = capturing.getInnerScope() and
  capturing.getParentNode+() = loop and
  var = loop.getALoopVariable()
}

/** Dataflow configuration for reasoning about callables that capture a loop variable and then may escape from the loop. */
module EscapingCaptureFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { capturesLoopVariable(node.asExpr(), _, _) }

  predicate isSink(DataFlow::Node node) {
    // Stored in a dict/list.
    exists(Assign assign, Subscript sub |
      sub = assign.getATarget() and node.asExpr() = assign.getValue()
    )
    or
    // Stored in a list.
    exists(DataFlow::MethodCallNode mc | mc.calls(_, "append") and node = mc.getArg(0))
    or
    // Used in a yield statement, likely included in a collection.
    // The element of comprehension expressions desugar to involve a yield statement internally.
    exists(Yield y | node.asExpr() = y.getValue())
    // Checks for storing in a field leads to false positives, so are omitted.
  }

  predicate isBarrierOut(DataFlow::Node node) { isSink(node) }

  predicate isBarrier(DataFlow::Node node) {
    // Incorrect virtual dispatch to __call__ methods is a source of FPs.
    exists(Function call |
      call.getName() = "__call__" and
      call.getArg(0) = node.(DataFlow::ParameterNode).getParameter()
    )
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet cs) {
    isSink(node) and
    (
      cs.(DataFlow::TupleElementContent).getIndex() in [0 .. 10] or
      cs instanceof DataFlow::ListElementContent or
      cs instanceof DataFlow::SetElementContent or
      cs instanceof DataFlow::DictionaryElementAnyContent
    )
  }
}

/** Dataflow for reasoning about callables that capture a loop variable and then escape from the loop. */
module EscapingCaptureFlow = DataFlow::Global<EscapingCaptureFlowConfig>;

/** Holds if `capturing` is a callable that captures the variable `var` of the loop `loop`, and then may escape the loop via a flow path from `source` to `sink`. */
predicate escapingCapture(
  CallableExpr capturing, Loop loop, Variable var, EscapingCaptureFlow::PathNode source,
  EscapingCaptureFlow::PathNode sink
) {
  capturesLoopVariable(capturing, loop, var) and
  capturing = source.getNode().asExpr() and
  EscapingCaptureFlow::flowPath(source, sink)
}
