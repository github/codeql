/**
 * @name Loop variable capture
 * @description Capture of a loop variable is not the same as capturing the value of a loop variable, and may be erroneous.
 * @kind path-problem
 * @tags correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/loop-variable-capture
 */

import python
import semmle.python.dataflow.new.DataFlow

abstract class Loop extends AstNode {
  abstract Variable getALoopVariable();
}

class ForLoop extends Loop, For {
  override Variable getALoopVariable() {
    this.getTarget() = result.getAnAccess().getParentNode*() and
    result.getScope() = this.getScope()
  }
}

predicate capturesLoopVariable(CallableExpr capturing, Loop loop, Variable var) {
  var.getAnAccess().getScope() = capturing.getInnerScope() and
  capturing.getParentNode+() = loop and
  var = loop.getALoopVariable()
}

module EscapingCaptureFlowSig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { capturesLoopVariable(node.asExpr(), _, _) }

  predicate isSink(DataFlow::Node node) {
    // Stored in a field.
    // This appeared to lead to FPs through wrapper classes.
    // exists(DataFlow::AttrWrite aw | aw.getObject() = node)
    // or
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
  }

  predicate isBarrierOut(DataFlow::Node node) { isSink(node) }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet cs) {
    isSink(node) and
    exists(cs)
  }
}

module EscapingCaptureFlow = DataFlow::Global<EscapingCaptureFlowSig>;

import EscapingCaptureFlow::PathGraph

predicate escapingCapture(
  CallableExpr capturing, Loop loop, Variable var, EscapingCaptureFlow::PathNode source,
  EscapingCaptureFlow::PathNode sink
) {
  capturesLoopVariable(capturing, loop, var) and
  capturing = source.getNode().asExpr() and
  EscapingCaptureFlow::flowPath(source, sink)
}

from
  CallableExpr capturing, AstNode loop, Variable var, string descr,
  EscapingCaptureFlow::PathNode source, EscapingCaptureFlow::PathNode sink
where
  escapingCapture(capturing, loop, var, source, sink) and
  if capturing instanceof Lambda then descr = "lambda" else descr = "function"
select capturing, source, sink,
  "This " + descr + " captures the loop variable $@, and may escape the loop by being stored $@.",
  loop, var.getId(), sink, "here"
