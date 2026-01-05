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

private newtype TTcNode =
  TSource(Source s, Variable target) {
    AccessAfterLifetimeFlow::flow(s, _) and sourceValueScope(s, target, _)
  } or
  TBlockExpr(BlockExpr be) or
  TSink(Sink s) { AccessAfterLifetimeFlow::flow(_, s) }

private class TcNode extends TTcNode {
  Source asSource(Variable target) { this = TSource(result, target) }

  BlockExpr asBlockExpr() { this = TBlockExpr(result) }

  Sink asSink() { this = TSink(result) }

  string toString() {
    result = this.asSource(_).toString()
    or
    result = this.asBlockExpr().toString()
    or
    result = this.asSink().toString()
  }

  Location getLocation() {
    result = this.asSource(_).getLocation()
    or
    result = this.asBlockExpr().getLocation()
    or
    result = this.asSink().getLocation()
  }
}

pragma[nomagic]
private predicate tcStep(TcNode a, TcNode b) {
  // `b` is a child of `a`
  exists(Source source, Variable target, BlockExpr be |
    source = a.asSource(target) and
    be = b.asBlockExpr().getEnclosingBlock*() and
    sourceValueScope(source, target, be) and
    AccessAfterLifetimeFlow::flow(source, _)
  )
  or
  // propagate through function calls
  exists(Call call |
    a.asBlockExpr() = call.getEnclosingBlock() and
    call.getARuntimeTarget() = b.asBlockExpr().getEnclosingCallable()
  )
  or
  a.asBlockExpr() = b.asSink().asExpr().getEnclosingBlock()
}

private predicate isTcSource(TcNode n) { n instanceof TSource }

private predicate isTcSink(TcNode n) { n instanceof TSink }

/**
 * Holds if block `a` contains block `b`, in the sense that a stack allocated variable in
 * `a` may still be on the stack during execution of `b`. This is interprocedural,
 * but is an overapproximation that doesn't accurately track call contexts
 * (for example if `f` and `g` both call `b`, then then depending on the
 * caller a variable in `f` or `g` may or may-not be on the stack during `b`).
 */
private predicate mayEncloseOnStack(TcNode a, TcNode b) =
  doublyBoundedFastTC(tcStep/2, isTcSource/1, isTcSink/1)(a, b)

/**
 * Holds if the pair `(source, sink)`, that represents a flow from a
 * pointer or reference to a dereference, has its dereference outside the
 * lifetime of the target variable `target`.
 */
predicate dereferenceAfterLifetime(Source source, Sink sink, Variable target) {
  AccessAfterLifetimeFlow::flow(source, sink) and
  sourceValueScope(source, target, _) and
  not mayEncloseOnStack(TSource(source, target), TSink(sink))
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
