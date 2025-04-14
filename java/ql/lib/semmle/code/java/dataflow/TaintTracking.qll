/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.internal.TaintTrackingUtil::StringBuilderVarModule

module TaintTracking {
  import semmle.code.java.dataflow.internal.TaintTrackingUtil
  private import semmle.code.java.dataflow.internal.DataFlowImplSpecific
  private import semmle.code.java.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  import TaintFlowMake<Location, JavaDataFlow, JavaTaintTracking>
}
