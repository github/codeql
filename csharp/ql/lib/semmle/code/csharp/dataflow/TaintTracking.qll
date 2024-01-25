/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import csharp

module TaintTracking {
  import semmle.code.csharp.dataflow.internal.tainttracking1.TaintTrackingParameter::Public
  private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
  private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  import TaintFlowMake<CsharpDataFlow, CsharpTaintTracking>
  import semmle.code.csharp.dataflow.internal.tainttracking1.TaintTrackingImpl
}
