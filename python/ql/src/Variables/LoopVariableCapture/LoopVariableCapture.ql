/**
 * @name Loop variable capture
 * @description Capturing a loop variable is not the same as capturing its value, and can lead to unexpected behavior or bugs.
 * @kind path-problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/loop-variable-capture
 */

import python
import LoopVariableCaptureQuery
import EscapingCaptureFlow::PathGraph

from
  CallableExpr capturing, AstNode loop, Variable var, string descr,
  EscapingCaptureFlow::PathNode source, EscapingCaptureFlow::PathNode sink
where
  escapingCapture(capturing, loop, var, source, sink) and
  if capturing instanceof Lambda then descr = "lambda" else descr = "function"
select capturing, source, sink,
  "This " + descr + " captures the loop variable $@, and may escape the loop by being stored at $@.",
  loop, var.getId(), sink, "this location"
