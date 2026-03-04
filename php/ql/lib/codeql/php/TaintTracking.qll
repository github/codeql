/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses for PHP.
 */
module TaintTracking {
  import codeql.php.dataflow.internal.TaintTrackingPublic
  private import codeql.php.dataflow.internal.DataFlowImplSpecific
  private import codeql.php.dataflow.internal.TaintTrackingImplSpecific
  private import codeql.dataflow.TaintTracking
  private import codeql.Locations
  import TaintFlowMake<Location, PhpDataFlow, PhpTaintTracking>
}
