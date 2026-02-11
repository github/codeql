/**
 * https://github.com/libarchive/libarchive/wiki
 */

import cpp
import DecompressionBomb

/**
 * The `archive_read_data*` functions are used in flow sink.
 * See https://github.com/libarchive/libarchive/wiki/Examples.
 */
class Archive_read_data_block extends DecompressionFunction {
  Archive_read_data_block() {
    this.hasGlobalName(["archive_read_data_block", "archive_read_data", "archive_read_data_into_fd"])
  }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `archive_read_open_filename` function as a flow step.
 */
class ReadOpenFunctionStep extends DecompressionFlowStep {
  ReadOpenFunctionStep() { this = "ReadOpenFunction" }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget().hasGlobalName("archive_read_open_filename") |
      node1.asIndirectExpr() = fc.getArgument(1) and
      node2.asIndirectExpr() = fc.getArgument(0)
    )
  }
}
