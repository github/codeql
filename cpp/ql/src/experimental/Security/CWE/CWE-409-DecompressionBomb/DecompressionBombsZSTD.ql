/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression-zstd
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

// https://github.com/facebook/zstd/blob/dev/examples/streaming_decompression.c
import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File

// /**
//  * A Pointer Variable as a Flow source
//  */
// private class PointerVar extends VariableAccess {
//   PointerVar() { this.getType() instanceof PointerType }
// }
/**
 * A ZSTD_inBuffer Variable as a Flow source
 */
private class ZSTDinBufferVar extends VariableAccess {
  ZSTDinBufferVar() { this.getType().hasName("ZSTD_inBuffer") }
}

/**
 * A ZSTD_inBuffer_s Variable as a Flow source
 */
private class ZSTDinBufferSVar extends VariableAccess {
  ZSTDinBufferSVar() { this.getType().hasName("ZSTD_inBuffer_s") }
}

/**
 * The `ZSTD_decompress`  function is used in Flow sink
 */
private class ZSTDDecompressFunction extends Function {
  ZSTDDecompressFunction() { this.hasGlobalName(["ZSTD_decompress"]) }
}

/**
 * The `ZSTD_decompressDCtx` function is used in Flow sink
 */
private class ZSTDDecompressDCtxFunction extends Function {
  ZSTDDecompressDCtxFunction() { this.hasGlobalName(["ZSTD_decompressDCtx"]) }
}

/**
 * The `ZSTD_decompressStream` function is used in Flow sink
 */
private class ZSTDDecompressStreamFunction extends Function {
  ZSTDDecompressStreamFunction() { this.hasGlobalName(["ZSTD_decompressStream"]) }
}

/**
 * The `ZSTD_decompress_usingDDict` function is used in Flow sink
 */
private class ZSTDDecompressUsingDictFunction extends Function {
  ZSTDDecompressUsingDictFunction() { this.hasGlobalName(["ZSTD_decompress_usingDDict"]) }
}

/**
 * The `ZSTD_decompress_usingDDict` function is used in Flow sink
 */
private class ZSTDDecompressUsingDDictFunction extends Function {
  ZSTDDecompressUsingDDictFunction() { this.hasGlobalName(["ZSTD_decompress_usingDDict"]) }
}

module ZstdTaintConfig implements DataFlow::StateConfigSig {
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
    source.asExpr() instanceof ZSTDinBufferSVar and
    state = ""
    or
    source.asExpr() instanceof ZSTDinBufferVar and
    state = ""
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressFunction |
      fc.getArgument(2) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressDCtxFunction |
      fc.getArgument(3) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressStreamFunction |
      fc.getArgument(2) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressUsingDictFunction |
      fc.getArgument(3) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof ZSTDDecompressUsingDDictFunction |
      fc.getArgument(3) = sink.asExpr() and
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

module ZstdTaint = TaintTracking::GlobalWithState<ZstdTaintConfig>;

import ZstdTaint::PathGraph

from ZstdTaint::PathNode source, ZstdTaint::PathNode sink
where ZstdTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression depends on a $@.", source.getNode(),
  "potentially untrusted source"
