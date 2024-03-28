/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression-minizip
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * The `mz_zip_reader_create` function as a Flow source
 * create a `mz_zip_reader` instance
 */
private class Mz_zip_reader_create extends Function {
  Mz_zip_reader_create() { this.hasGlobalName("mz_zip_reader_create") }
}

/**
 * The `mz_zip_create` function as a Flow source
 * create a `mz_zip` instance
 */
private class Mz_zip_create extends Function {
  Mz_zip_create() { this.hasGlobalName("mz_zip_create") }
}

/**
 * The `mz_zip_entry` function is used in Flow source
 * [docuemnt](https://github.com/zlib-ng/minizip-ng/blob/master/doc/mz_zip.md)
 */
private class Mz_zip_entry extends Function {
  Mz_zip_entry() { this.hasGlobalName("mz_zip_entry_read") }
}

/**
 * The `mz_zip_reader_entry_*` and `mz_zip_reader_save_all` functions are used in Flow source
 * [docuemnt](https://github.com/zlib-ng/minizip-ng/blob/master/doc/mz_zip_rw.md)
 */
private class Mz_zip_reader_entry extends Function {
  Mz_zip_reader_entry() {
    this.hasGlobalName([
        "mz_zip_reader_entry_save", "mz_zip_reader_entry_read", "mz_zip_reader_entry_save_process",
        "mz_zip_reader_entry_save_file", "mz_zip_reader_entry_save_buffer", "mz_zip_reader_save_all"
      ])
  }
}

/**
 * A `unzFile` Variable as a Flow source
 */
private class UnzFileVar extends VariableAccess {
  UnzFileVar() { this.getType().hasName("unzFile") }
}

/**
 * The `UnzOpen` function as a Flow source
 */
private class UnzOpenFunction extends Function {
  UnzOpenFunction() { this.hasGlobalName(["UnzOpen", "unzOpen64", "unzOpen2", "unzOpen2_64"]) }
}

/**
 * The `unzReadCurrentFile` function is used in Flow sink
 */
private class UnzReadCurrentFileFunction extends Function {
  UnzReadCurrentFileFunction() { this.hasGlobalName(["unzReadCurrentFile"]) }
}

module MiniZipTaintConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof UnzOpenFunction |
      fc.getArgument(0) = source.asExpr() and
      state = "unzFile"
    )
    or
    source.asExpr() instanceof UnzFileVar and
    state = "unzFile"
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_reader_create |
      fc = source.asExpr() and
      state = "mz_zip_reader"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_create |
      fc = source.asExpr() and
      state = "mz_zip"
    )
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof UnzReadCurrentFileFunction |
      fc.getArgument(0) = sink.asExpr() and
      state = "unzFile"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_reader_entry |
      fc.getArgument(1) = sink.asExpr() and
      state = "mz_zip_reader"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_entry |
      fc.getArgument(1) = sink.asExpr() and
      state = "mz_zip"
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(FunctionCall fc | fc.getTarget() instanceof UnzOpenFunction |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc and
      state1 = "" and
      state2 = "unzFile"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_reader_entry |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc.getArgument(1) and
      state1 = "" and
      state2 = "mz_zip_reader"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof Mz_zip_entry |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc.getArgument(1) and
      state1 = "" and
      state2 = "mz_zip"
    )
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) { none() }
}

module MiniZipTaint = TaintTracking::GlobalWithState<MiniZipTaintConfig>;

import MiniZipTaint::PathGraph

from MiniZipTaint::PathNode source, MiniZipTaint::PathNode sink
where MiniZipTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompressiondepends on a $@.", source.getNode(),
  "potentially untrusted source"
