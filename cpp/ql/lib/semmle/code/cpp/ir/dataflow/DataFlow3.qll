/**
 * Provides a `DataFlow3` module, which is a copy of the `DataFlow` module. Use
 * this class when data-flow configurations must depend on each other. Two
 * classes extending `DataFlow::Configuration` should never depend on each
 * other, but one of them should instead depend on a
 * `DataFlow2::Configuration`, a `DataFlow3::Configuration`, or a
 * `DataFlow4::Configuration`.
 *
 * See `semmle.code.cpp.ir.dataflow.DataFlow` for the full documentation.
 */

import cpp

module DataFlow3 {
  import semmle.code.cpp.ir.dataflow.internal.DataFlowImpl3
}
