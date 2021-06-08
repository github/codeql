/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.internal.TaintTrackingUtil::StringBuilderVarModule

module TaintTracking {
  import semmle.code.java.dataflow.internal.tainttracking1.TaintTrackingImpl
}
