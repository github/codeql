/**
 * Provides the module `TaintTracking` for performing local (intra-procedural)
 * and global (inter-procedural) taint-tracking analyses.
 */

private import rust

/**
 * Provides a library for performing local (intra-procedural) and global
 * (inter-procedural) taint-tracking analyses.
 */
module TaintTracking {
  private import codeql.dataflow.TaintTracking
  private import internal.DataFlowImpl
  private import internal.TaintTrackingImpl
  import TaintFlowMake<Location, RustDataFlow, RustTaintTracking>
}
