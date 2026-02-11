/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import csharp

module TaintTracking {
  import semmle.code.csharp.dataflow.internal.TaintTrackingPublic
  private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
  private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  import TaintFlowMake<Location, CsharpDataFlow, CsharpTaintTracking>
}
