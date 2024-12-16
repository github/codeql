/**
 * @name Access to dangling pointer.
 * @description Accessing a pointer after the lifetime of it's target has ended is undefined behavior.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id rust/dangling-ptr
 * @tags security
 *       reliability
 *       correctness
 *       external/cwe/cwe-825
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.DanglingPointerExtensions

module PointerDereferenceFlow = TaintTracking::Global<PointerDereferenceConfig>;

import PointerDereferenceFlow::PathGraph

from
  PointerDereferenceFlow::PathNode sourceNode, PointerDereferenceFlow::PathNode sinkNode,
  DataFlow::Node targetValue, BlockExpr valueScope, BlockExpr accessScope
where
  // flow from a pointer or reference to the dereference
  PointerDereferenceFlow::flowPath(sourceNode, sinkNode) and
  createsPointer(sourceNode.getNode(), targetValue) and
  // check that the dereference is outside the lifetime of the target; in
  // practice this is only possible for a pointer, and the dereference has to
  // be in unsafe code, though we don't explicitly check for either.
  valueScope(targetValue.asExpr().getExpr(), valueScope) and
  accessScope = sinkNode.getNode().asExpr().getExpr().getEnclosingBlock() and
  not maybeOnStack(valueScope, accessScope)
select sinkNode.getNode(), sourceNode, sinkNode,
  "Access of a pointer to $@ after the end of it's lifetime.", targetValue, targetValue.toString()
