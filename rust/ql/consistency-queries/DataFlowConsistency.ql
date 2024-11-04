/**
 * @name Data flow inconsistencies
 * @description Lists the data flow inconsistencies in the database.  This query is intended for internal use.
 * @kind table
 * @id rust/diagnostics/data-flow-consistency
 */

import codeql.rust.dataflow.DataFlow::DataFlow as DataFlow
private import rust
private import codeql.rust.dataflow.internal.DataFlowImpl
private import codeql.rust.dataflow.internal.TaintTrackingImpl
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, RustDataFlow> { }

import MakeConsistency<Location, RustDataFlow, RustTaintTracking, Input>
