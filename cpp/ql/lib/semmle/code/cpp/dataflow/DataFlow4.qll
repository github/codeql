/**
 * Provides a `DataFlow4` module, which is a copy of the `DataFlow` module. Use
 * this class when data-flow configurations must depend on each other. Two
 * classes extending `DataFlow::Configuration` should never depend on each
 * other, but one of them should instead depend on a
 * `DataFlow2::Configuration`, a `DataFlow3::Configuration`, or a
 * `DataFlow4::Configuration`.
 *
 * See `semmle.code.cpp.dataflow.DataFlow` for the full documentation.
 */

import cpp

module DataFlow4 {
  import semmle.code.cpp.dataflow.internal.DataFlowImpl4
}
