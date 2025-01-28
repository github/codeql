/**
 * @name Unbounded write
 * @description Buffer write operations that do not control the length
 *              of data written may overflow.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision medium
 * @id cpp/unbounded-write
 * @tags reliability
 *       security
 *       external/cwe/cwe-120
 *       external/cwe/cwe-787
 *       external/cwe/cwe-805
 */

import semmle.code.cpp.security.BufferWrite
import semmle.code.cpp.security.FlowSources as FS
import semmle.code.cpp.dataflow.new.TaintTracking
import semmle.code.cpp.controlflow.IRGuards
import Flow::PathGraph

/*
 * --- Summary of CWE-120 alerts ---
 *
 * The essence of CWE-120 is that string / buffer copies that are
 * potentially unbounded, e.g. null terminated string copy,
 * should be controlled e.g. by using strncpy instead of strcpy.
 * In practice this is divided into several queries that
 * handle slightly different sub-cases, exclude some acceptable uses,
 * and produce reasonable messages to fit each issue.
 *
 * cases:
 *    hasExplicitLimit()    exists(getMaxData())  exists(getBufferSize(bw.getDest(), _))) handled by
 *    NO                    NO                    either                                  UnboundedWrite.ql isUnboundedWrite()
 *    NO                    YES                   NO                                      UnboundedWrite.ql isMaybeUnboundedWrite()
 *    NO                    YES                   YES                                     VeryLikelyOverrunWrite.ql, OverrunWrite.ql, OverrunWriteFloat.ql
 *    YES                   either                YES                                     BadlyBoundedWrite.ql
 *    YES                   either                NO                                      (assumed OK)
 */

/*
 * --- CWE-120/UnboundedWrite ---
 */

predicate isUnboundedWrite(BufferWrite bw) {
  not bw.hasExplicitLimit() and // has no explicit size limit
  not exists(bw.getMaxData(_)) // and we can't deduce an upper bound to the amount copied
}

/**
 * Holds if `e` is a source buffer going into an unbounded write `bw` or a
 * qualifier of (a qualifier of ...) such a source.
 */
predicate unboundedWriteSource(Expr e, BufferWrite bw, boolean qualifier) {
  isUnboundedWrite(bw) and e = bw.getASource() and qualifier = false
  or
  exists(FieldAccess fa | unboundedWriteSource(fa, bw, _) and e = fa.getQualifier()) and
  qualifier = true
}

predicate isSource(FS::FlowSource source, string sourceType) { source.getSourceType() = sourceType }

predicate isSink(DataFlow::Node sink, BufferWrite bw, boolean qualifier) {
  unboundedWriteSource(sink.asIndirectExpr(), bw, qualifier)
  or
  // `gets` and `scanf` reads from stdin so there's no real input.
  // The `BufferWrite` library models this as the call itself being
  // the source. In this case we mark the output argument as being
  // the sink so that we report a path where source = sink (because
  // the same output argument is also included in `isSource`).
  bw.getASource() = bw and
  unboundedWriteSource(sink.asDefiningArgument(), bw, qualifier)
}

/**
 * A configuration that specifies flow from a `FlowSource` to a relational
 * comparison.
 *
 * This configuration is used to speed up the barrier computations in Config.
 */
module BarrierConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSource(source, _) }

  predicate isSink(DataFlow::Node sink) {
    comparesEq(sink.asOperand(), _, _, true, _) or
    comparesLt(sink.asOperand(), _, _, true, _)
  }
}

module BarrierFlow = TaintTracking::Global<BarrierConfig>;

import semmle.code.cpp.ir.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon

/**
 * Holds if `left` is a left operand of some relational comparison that may
 * depend on user input.
 */
predicate interestingLessThanOrEqual(Operand left) {
  exists(DataFlowImplCommon::NodeEx node |
    node.asNode().asOperand() = left and
    BarrierFlow::Stages::Stage1::sinkNode(node, _)
  )
}

predicate lessThanOrEqual(IRGuardCondition g, Expr e, boolean branch) {
  exists(Operand left |
    g.comparesLt(left, _, _, true, branch) or
    g.comparesEq(left, _, _, true, branch)
  |
    interestingLessThanOrEqual(left) and
    left.getDef().getUnconvertedResultExpression() = e
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSource(source, _) }

  predicate isSink(DataFlow::Node sink) { isSink(sink, _, _) }

  predicate isBarrierOut(DataFlow::Node node) { isSink(node, _, false) }

  predicate isBarrier(DataFlow::Node node) {
    // Block flow if the node is guarded by any <, <= or = operations.
    node = DataFlow::BarrierGuard<lessThanOrEqual/3>::getABarrierNode()
  }
}

module Flow = TaintTracking::Global<Config>;

/*
 * An unbounded write is, for example `strcpy(..., tainted)`. We're looking
 * for a tainted source buffer of an unbounded write, where this source buffer
 * is a sink in the taint-tracking analysis.
 *
 * In the case of `gets` and `scanf`, where the source buffer is implicit, the
 * `BufferWrite` library reports the source buffer to be the same as the
 * destination buffer. So to report an alert on a pattern like:
 * ```
 * char s[32];
 * gets(s);
 * ```
 * we define the sink as the node corresponding to the output argument of `gets`.
 * This gives us a path where the source is equal to the sink.
 */

from BufferWrite bw, Flow::PathNode source, Flow::PathNode sink, string sourceType
where
  Flow::flowPath(source, sink) and
  isSource(source.getNode(), sourceType) and
  isSink(sink.getNode(), bw, _)
select bw, source, sink,
  "This '" + bw.getBWDesc() + "' with input from $@ may overflow the destination.",
  source.getNode(), sourceType
