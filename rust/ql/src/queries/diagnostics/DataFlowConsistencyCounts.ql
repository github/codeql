/**
 * @name Data flow inconsistency counts
 * @description Counts the number of data flow inconsistencies of each type.  This query is intended for internal use.
 * @kind diagnostic
 * @id rust/diagnostics/data-flow-consistency-counts
 */

private import rust
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.internal.TaintTrackingImpl
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, RustDataFlow> { }

// see also `rust/diagnostics/data-flow-consistency`, which lists the
// individual inconsistency results.
from string type, int num
where
  num =
    MakeConsistency<Location, RustDataFlow, RustTaintTracking, Input>::getInconsistencyCounts(type)
select type, num
