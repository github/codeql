/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 *
 * We define _taint propagation_ informally to mean that a substantial part of
 * the information from the source is preserved at the sink. For example, taint
 * propagates from `x` to `x + 100`, but it does not propagate from `x` to `x >
 * 100` since we consider a single bit of information to be too little.
 */
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow2

import semmle.code.java.dataflow.internal.TaintTrackingUtil::StringBuilderVarModule

module TaintTracking {
  import semmle.code.java.dataflow.internal.tainttracking1.TaintTrackingImpl
  private import semmle.code.java.dataflow.TaintTracking2

  /**
   * DEPRECATED: Use TaintTracking2::Configuration instead.
   */
  deprecated
  class Configuration2 = TaintTracking2::Configuration;
}
