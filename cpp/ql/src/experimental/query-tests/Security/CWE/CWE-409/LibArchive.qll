/**
 * https://github.com/libarchive/libarchive/wiki
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import DecompressionBomb

/**
 * The `archive_read_data*` functions are used in flow sink.
 * [Examples](https://github.com/libarchive/libarchive/wiki/Examples)
 */
class Archive_read_data_block extends DecompressionFunction {
  Archive_read_data_block() {
    this.hasGlobalName(["archive_read_data_block", "archive_read_data", "archive_read_data_into_fd"])
  }

  override int getArchiveParameterIndex() { result = 0 }
}
