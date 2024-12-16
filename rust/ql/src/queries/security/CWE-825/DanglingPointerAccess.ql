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
  PointerDereferenceFlow::flowPath(sourceNode, sinkNode) and
  createsPointer(sourceNode.getNode(), targetValue) and
  valueScope(targetValue.asExpr().getExpr(), valueScope) and
  accessScope = sinkNode.getNode().asExpr().getExpr().getEnclosingBlock() and
  not maybeOnStack(valueScope, accessScope)
select sinkNode.getNode(), sourceNode, sinkNode,
  "Access of a pointer to $@ after the end of it's lifetime.", targetValue, targetValue.toString()
