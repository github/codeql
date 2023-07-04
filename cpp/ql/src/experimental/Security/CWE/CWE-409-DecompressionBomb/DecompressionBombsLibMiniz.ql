/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression-miniz
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A Pointer Variable is used in Flow source
 */
private class PointerVar extends VariableAccess {
  PointerVar() { this.getType() instanceof PointerType }
}

/**
 * A unsigned char Variable is used in Flow source
 */
private class Uint8Var extends VariableAccess {
  Uint8Var() { this.getType().stripType().resolveTypedefs*() instanceof UnsignedCharType }
}

/**
 * The `mz_streamp`, `z_stream` Variables are used in Flow source
 */
private class MzStreampVar extends VariableAccess {
  MzStreampVar() { this.getType().hasName(["mz_streamp", "z_stream"]) }
}

/**
 * A Char Variable is used in Flow source
 */
private class CharVar extends VariableAccess {
  CharVar() { this.getType().stripType().resolveTypedefs*() instanceof CharType }
}

/**
 * A `mz_zip_archive` Variable is used in Flow source
 */
private class MzZipArchiveVar extends VariableAccess {
  MzZipArchiveVar() { this.getType().hasName("mz_zip_archive") }
}

/**
 * The `mz_uncompress` functions are used in Flow Sink
 */
private class MzUncompress extends Function {
  MzUncompress() { this.hasGlobalName(["uncompress", "mz_uncompress", "mz_uncompress2"]) }
}

/**
 * A `zip handle` is used in Flow source
 */
private class MzZip extends Function {
  MzZip() {
    this.hasGlobalName([
        "mz_zip_reader_open", "mz_zip_reader_open_file", "mz_zip_reader_open_file_in_memory",
        "mz_zip_reader_open_buffer", "mz_zip_reader_entry_open"
      ])
  }
}

/**
 * The `mz_inflate` functions are used in Flow Sink
 */
private class MzInflate extends Function {
  MzInflate() { this.hasGlobalName(["mz_inflate", "inflate"]) }
}

/**
 * The `mz_inflateInit` functions are used in Flow Sink
 */
private class MzInflateInit extends Function {
  MzInflateInit() { this.hasGlobalName(["inflateInit", "mz_inflateInit"]) }
}

/**
 * The `mz_zip_reader_extract_*` functions are used in Flow Sink
 */
private class MzZipReaderExtract extends Function {
  MzZipReaderExtract() {
    this.hasGlobalName([
        "mz_zip_reader_extract_file_to_heap", "mz_zip_reader_extract_to_heap",
        "mz_zip_reader_extract_to_callback", "mz_zip_reader_extract_file_to_callback",
        "mz_zip_reader_extract_to_mem", "mz_zip_reader_extract_file_to_mem",
        "mz_zip_reader_extract_iter_read", "mz_zip_reader_extract_to_file",
        "mz_zip_reader_extract_file_to_file"
      ])
  }
}

/**
 * The `mz_zip_reader_locate_file_*` functions are used in Flow Sink
 */
private class MzZipReaderLocateFile extends Function {
  MzZipReaderLocateFile() {
    this.hasGlobalName(["mz_zip_reader_locate_file", "mz_zip_reader_locate_file_v2"])
  }
}

/**
 * The `tinfl_decompress_mem_*` functions are used in Flow Sink
 */
private class TinflDecompressMem extends Function {
  TinflDecompressMem() {
    this.hasGlobalName([
        "tinfl_decompress_mem_to_callback", "tinfl_decompress_mem_to_mem",
        "tinfl_decompress_mem_to_heap"
      ])
  }
}

/**
 * The `tinfl_decompress_*` functions are used in Flow Sink
 */
private class TinflDecompress extends Function {
  TinflDecompress() { this.hasGlobalName(["tinfl_decompress"]) }
}

module MinizTaintConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.asExpr() instanceof Uint8Var and
    state = ""
    or
    source.asExpr() instanceof PointerVar and
    state = ""
    or
    source.asExpr() instanceof CharVar and
    state = ""
    or
    source.asExpr() instanceof MzZipArchiveVar and
    state = ""
    or
    source.asExpr() instanceof MzStreampVar and
    state = ""
    or
    // source of inflate(&arg0) is OK
    // but the sink which is a call to MzInflate Function first arg can not be determined
    // if I debug the query we'll reach to the first arg, it is weird I think.
    source.asDefiningArgument() =
      any(Call call | call.getTarget() instanceof MzInflateInit).getArgument(0) and
    state = "inflate"
    or
    source.asDefiningArgument() = any(Call call | call.getTarget() instanceof MzZip).getArgument(0) and
    state = ""
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof MzUncompress |
      fc.getArgument(2) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof MzZipReaderExtract |
      fc.getArgument(1) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof MzInflate |
      fc.getArgument(0) = sink.asExpr() and
      state = "inflate"
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof TinflDecompress |
      fc.getArgument(1) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof TinflDecompressMem |
      fc.getArgument(0) = sink.asExpr() and
      state = ""
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    exists(FunctionCall fc | fc.getTarget() instanceof MzUncompress |
      node1.asExpr() = fc.getArgument(2) and
      node2.asExpr() = fc.getArgument(0) and
      state1 = "" and
      state2 = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof MzZipReaderLocateFile |
      node1.asExpr() = fc.getArgument(1) and
      node2.asExpr() = fc.getArgument(3) and
      state1 = "" and
      state2 = ""
    )
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) { none() }
}

module MinizTaint = TaintTracking::GlobalWithState<MinizTaintConfig>;

import MinizTaint::PathGraph

from MinizTaint::PathNode source, MinizTaint::PathNode sink
where MinizTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompressiondepends on a $@.", source.getNode(),
  "potentially untrusted source"
