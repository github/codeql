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
import codeql.rust.security.AccessAfterLifetimeExtensions::AccessAfterLifetime
import AccessAfterLifetimeFlow::PathGraph

/**
 * A data flow configuration for detecting accesses to a pointer after its
 * lifetime has ended.
 */
module AccessAfterLifetimeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node instanceof Source and
    // exclude cases with sources in macros, since these results are difficult to interpret
    not node.asExpr().isFromMacroExpansion() and
    sourceValueScope(node, _, _)
  }

  predicate isSink(DataFlow::Node node) {
    node instanceof Sink and
    // Exclude cases with sinks in macros, since these results are difficult to interpret
    not node.asExpr().isFromMacroExpansion() and
    // TODO: Remove this condition if it can be done without negatively
    // impacting performance. This condition only include nodes with
    // corresponding to an expression. This excludes sinks from models-as-data.
    exists(node.asExpr())
  }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) {
    exists(Variable target |
      sourceValueScope(source, target, _) and
      result = [target.getLocation(), source.getLocation()]
    )
  }
}

module AccessAfterLifetimeFlow = TaintTracking::Global<AccessAfterLifetimeConfig>;

predicate sourceBlock(Source s, Variable target, BlockExpr be) {
  AccessAfterLifetimeFlow::flow(s, _) and
  sourceValueScope(s, target, be.getEnclosingBlock*())
}

predicate sinkBlock(Sink s, BlockExpr be) {
  AccessAfterLifetimeFlow::flow(_, s) and
  be = s.asExpr().getEnclosingBlock()
}

private predicate tcStep(BlockExpr a, BlockExpr b) {
  // propagate through function calls
  exists(Call call |
    a = call.getEnclosingBlock() and
    call.getARuntimeTarget() = b.getEnclosingCallable()
  )
}

private predicate isTcSource(BlockExpr be) { sourceBlock(_, _, be) }

private predicate isTcSink(BlockExpr be) { sinkBlock(_, be) }

/**
 * Holds if block `a` contains block `b`, in the sense that a stack allocated variable in
 * `a` may still be on the stack during execution of `b`. This is interprocedural,
 * but is an overapproximation that doesn't accurately track call contexts
 * (for example if `f` and `g` both call `b`, then depending on the
 * caller a variable in `f` or `g` may or may-not be on the stack during `b`).
 */
private predicate mayEncloseOnStack(BlockExpr a, BlockExpr b) =
  doublyBoundedFastTC(tcStep/2, isTcSource/1, isTcSink/1)(a, b)

/**
 * Holds if the pair `(source, sink)`, that represents a flow from a
 * pointer or reference to a dereference, has its dereference outside the
 * lifetime of the target variable `target`.
 */
predicate dereferenceAfterLifetime(Source source, Sink sink, Variable target) {
  AccessAfterLifetimeFlow::flow(source, sink) and
  sourceValueScope(source, target, _) and
  not exists(BlockExpr beSource, BlockExpr beSink |
    sourceBlock(source, target, beSource) and
    sinkBlock(sink, beSink)
  |
    beSource = beSink
    or
    mayEncloseOnStack(beSource, beSink)
  )
}

from
  AccessAfterLifetimeFlow::PathNode sourceNode, AccessAfterLifetimeFlow::PathNode sinkNode,
  Variable target
where
  // flow from a pointer or reference to the dereference
  AccessAfterLifetimeFlow::flowPath(sourceNode, sinkNode) and
  // check that the dereference is outside the lifetime of the target
  dereferenceAfterLifetime(sourceNode.getNode(), sinkNode.getNode(), target)
select sinkNode.getNode(), sourceNode, sinkNode,
  "Access of a pointer to $@ after its lifetime has ended.", target, target.toString()
