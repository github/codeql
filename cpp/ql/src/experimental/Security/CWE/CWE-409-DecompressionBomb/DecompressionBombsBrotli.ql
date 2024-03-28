/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression-brotli
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

// https://github.com/google/brotli
import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File

/**
 * A Pointer Variable is used in Flow source
 */
private class PointerVar extends VariableAccess {
  PointerVar() { this.getType() instanceof PointerType }
}

/**
 * A Pointer Variable is used in Flow source
 */
private class Uint8Var extends VariableAccess {
  Uint8Var() { this.getType() instanceof UInt8_t }
}

/**
 * A ZSTD_inBuffer Variable is used in Flow source
 */
private class ZSTDinBufferVar extends VariableAccess {
  ZSTDinBufferVar() { this.getType().hasName("ZSTD_inBuffer") }
}

/**
 * The `ZSTD_decompress_usingDDict` function is used in Flow sink
 * Ref: https://www.brotli.org/decode.html#af68
 */
private class BrotliDecoderDecompressFunction extends Function {
  BrotliDecoderDecompressFunction() { this.hasGlobalName(["BrotliDecoderDecompress"]) }
}

/**
 * The `BrotliDecoderDecompressStream` function is used in Flow sink
 * Ref: https://www.brotli.org/decode.html#a234
 */
private class BrotliDecoderDecompressStreamFunction extends Function {
  BrotliDecoderDecompressStreamFunction() { this.hasGlobalName(["BrotliDecoderDecompressStream"]) }
}

module BrotliTaintConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof AllocationFunction |
      fc = source.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fopenCall(fc) |
      fc = source.asExpr() and
      state = ""
    )
    or
    source.asExpr() instanceof PointerVar and
    state = ""
    or
    source.asExpr() instanceof Uint8Var and
    state = ""
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof BrotliDecoderDecompressStreamFunction |
      fc.getArgument(2) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof BrotliDecoderDecompressFunction |
      fc.getArgument(1) = sink.asExpr() and
      state = ""
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    none()
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) { none() }
}

module BrotliTaint = TaintTracking::GlobalWithState<BrotliTaintConfig>;

import BrotliTaint::PathGraph

from BrotliTaint::PathNode source, BrotliTaint::PathNode sink
where BrotliTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression depends on a $@.", source.getNode(),
  "potentially untrusted source"
