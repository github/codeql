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

  DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureEscapesSourceCallContextOrEqualSourceSinkCallContext
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

from
  AccessAfterLifetimeFlow::PathNode sourceNode, AccessAfterLifetimeFlow::PathNode sinkNode,
  Source source, Sink sink, Variable target
where
  // flow from a pointer or reference to the dereference
  AccessAfterLifetimeFlow::flowPath(sourceNode, sinkNode) and
  source = sourceNode.getNode() and
  sink = sinkNode.getNode() and
  sourceValueScope(source, target, _) and
  // check that the dereference is outside the lifetime of the target, when the source
  // and the sink are in the same callable
  // (`FeatureEscapesSourceCallContextOrEqualSourceSinkCallContext` handles the case when
  // they are not)
  not exists(BlockExpr be |
    sourceBlock(source, target, be) and
    sinkBlock(sink, be)
  )
select sinkNode.getNode(), sourceNode, sinkNode,
  "Access of a pointer to $@ after its lifetime has ended.", target, target.toString()
