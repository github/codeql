/**
 * @name Access of a pointer after its lifetime has ended
 * @description Dereferencing a pointer after the lifetime of its target has ended
 *              causes undefined behavior and may result in memory corruption.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id rust/access-after-lifetime-ended
 * @tags reliability
 *       security
 *       external/cwe/cwe-825
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.AccessAfterLifetimeExtensions
import AccessAfterLifetimeFlow::PathGraph

/**
 * A data flow configuration for detecting accesses to a pointer after its
 * lifetime has ended.
 */
module AccessAfterLifetimeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof AccessAfterLifetime::Source }

  predicate isSink(DataFlow::Node node) { node instanceof AccessAfterLifetime::Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof AccessAfterLifetime::Barrier }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    exists(Variable target, DataFlow::Node sink | result = target.getLocation() |
      isSink(sink) and
      narrowDereferenceAfterLifetime(source, sink, target)
    )
  }
}

module AccessAfterLifetimeFlow = TaintTracking::Global<AccessAfterLifetimeConfig>;

pragma[inline]
predicate narrowDereferenceAfterLifetime(DataFlow::Node source, DataFlow::Node sink, Variable target) {
  // check that the dereference is outside the lifetime of the target
  AccessAfterLifetime::dereferenceAfterLifetime(source, sink, target) and
  // include only results inside `unsafe` blocks, as other results tend to be false positives
  (
    sink.asExpr().getExpr().getEnclosingBlock*().isUnsafe() or
    sink.asExpr().getExpr().getEnclosingCallable().(Function).isUnsafe()
  ) and
  // exclude cases with sources / sinks in macros, since these results are difficult to interpret
  not source.asExpr().getExpr().isFromMacroExpansion() and
  not sink.asExpr().getExpr().isFromMacroExpansion()
}

from
  AccessAfterLifetimeFlow::PathNode sourceNode, AccessAfterLifetimeFlow::PathNode sinkNode,
  Variable target
where
  // flow from a pointer or reference to the dereference
  AccessAfterLifetimeFlow::flowPath(sourceNode, sinkNode) and
  // check that the dereference is outside the lifetime of the target
  narrowDereferenceAfterLifetime(sourceNode.getNode(), sinkNode.getNode(), target)
select sinkNode.getNode(), sourceNode, sinkNode,
  "Access of a pointer to $@ after its lifetime has ended.", target, target.toString()
