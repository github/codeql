/**
 * Provides a `TaintTracking3` module, which is a copy of the `TaintTracking`
 * module. Use this class when data-flow configurations or taint-tracking
 * configurations must depend on each other. Two classes extending
 * `DataFlow::Configuration` should never depend on each other, but one of them
 * should instead depend on a `DataFlow2::Configuration`, a
 * `DataFlow3::Configuration`, or a `DataFlow4::Configuration`. The
 * `TaintTracking::Configuration` class extends `DataFlow::Configuration`, and
 * `TaintTracking2::Configuration` extends `DataFlow2::Configuration`.
 *
 * See `semmle.code.cpp.ir.dataflow.TaintTracking` for the full documentation.
 */
module TaintTracking3 {
  import semmle.code.cpp.ir.dataflow.internal.tainttracking3.TaintTrackingImpl
}
