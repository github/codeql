/**
 * https://github.com/libarchive/libarchive/wiki
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * The `archive_read_new` function as a Flow source
 * create a `archive` instance
 */
class Archive_read_new extends Function {
  Archive_read_new() { this.hasGlobalName("archive_read_new") }
}

/**
 * The `archive_read_data*` functions are used in Flow Sink
 * [Examples](https://github.com/libarchive/libarchive/wiki/Examples)
 */
class Archive_read_data_block extends Function {
  Archive_read_data_block() {
    this.hasGlobalName(["archive_read_data_block", "archive_read_data", "archive_read_data_into_fd"])
  }
}
