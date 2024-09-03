/**
 * https://github.com/zlib-ng/minizip-ng
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import DecompressionBomb

/**
 * The `mz_zip_entry` function is used in flow sink.
 * [docuemnt](https://github.com/zlib-ng/minizip-ng/blob/master/doc/mz_zip.md)
 */
class Mz_zip_entry extends DecompressionFunction {
  Mz_zip_entry() { this.hasGlobalName("mz_zip_entry_read") }

  override int getArchiveParameterIndex() { result = 1 }
}

/**
 * The `mz_zip_reader_entry_*` and `mz_zip_reader_save_all` functions are used in flow source.
 * [docuemnt](https://github.com/zlib-ng/minizip-ng/blob/master/doc/mz_zip_rw.md)
 */
class Mz_zip_reader_entry extends DecompressionFunction {
  Mz_zip_reader_entry() {
    this.hasGlobalName([
        "mz_zip_reader_entry_save", "mz_zip_reader_entry_read", "mz_zip_reader_entry_save_process",
        "mz_zip_reader_entry_save_file", "mz_zip_reader_entry_save_buffer", "mz_zip_reader_save_all"
      ])
  }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `UnzOpen*` functions are used in flow sink.
 */
class UnzOpenFunction extends DecompressionFunction {
  UnzOpenFunction() { this.hasGlobalName(["UnzOpen", "unzOpen64", "unzOpen2", "unzOpen2_64"]) }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `mz_zip_reader_open_file` and `mz_zip_reader_open_file_in_memory` functions as a flow source.
 */
class ReaderOpenFunction extends DecompressionFlowStep {
  ReaderOpenFunction() {
    this.hasGlobalName(["mz_zip_reader_open_file_in_memory", "mz_zip_reader_open_file"])
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget() = this |
      node1.asIndirectExpr() = fc.getArgument(1) and
      node2.asIndirectExpr() = fc.getArgument(0)
    )
  }
}
