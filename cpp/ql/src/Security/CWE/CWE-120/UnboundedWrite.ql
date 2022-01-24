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
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

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

/*
 * predicate isMaybeUnboundedWrite(BufferWrite bw)
 * {
 *   not bw.hasExplicitLimit()                           // has no explicit size limit
 *   and exists(bw.getMaxData())                         // and we can deduce an upper bound to the amount copied
 *   and (not exists(getBufferSize(bw.getDest(), _)))    // but we can't work out the size of the destination to be sure
 * }
 */

/**
 * Holds if `e` is a source buffer going into an unbounded write `bw` or a
 * qualifier of (a qualifier of ...) such a source.
 */
predicate unboundedWriteSource(Expr e, BufferWrite bw) {
  isUnboundedWrite(bw) and e = bw.getASource()
  or
  exists(FieldAccess fa | unboundedWriteSource(fa, bw) and e = fa.getQualifier())
}

/*
 * --- user input reach ---
 */

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element tainted) { unboundedWriteSource(tainted, _) }

  override predicate taintThroughGlobals() { any() }
}

/*
 * --- put it together ---
 */

/*
 * An unbounded write is, for example `strcpy(..., tainted)`. We're looking
 * for a tainted source buffer of an unbounded write, where this source buffer
 * is a sink in the taint-tracking analysis.
 *
 * In the case of `gets` and `scanf`, where the source buffer is implicit, the
 * `BufferWrite` library reports the source buffer to be the same as the
 * destination buffer. Since those destination-buffer arguments are also
 * modeled in the taint-tracking library as being _sources_ of taint, they are
 * in practice reported as being tainted because the `security.TaintTracking`
 * library does not distinguish between taint going into an argument and out of
 * an argument. Thus, we get the desired alerts.
 */

from BufferWrite bw, Expr inputSource, Expr tainted, PathNode sourceNode, PathNode sinkNode
where
  taintedWithPath(inputSource, tainted, sourceNode, sinkNode) and
  unboundedWriteSource(tainted, bw)
select bw, sourceNode, sinkNode,
  "This '" + bw.getBWDesc() + "' with input from $@ may overflow the destination.", inputSource,
  inputSource.toString()
