/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cpp/user-controlled-file-decompression-xz
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A Pointer Variable as a Flow source
 */
private class Uint8Var extends VariableAccess {
  Uint8Var() { this.getType() instanceof UInt8_t }
}

/**
 * A `lzma_stream` Variable as a Flow source
 */
private class LzmaStreamVar extends VariableAccess {
  LzmaStreamVar() { this.getType().hasName("lzma_stream") }
}

/**
 * The `lzma_*_decoder` function is used as a required condition for decompression
 */
private class LzmaDecoderFunction extends Function {
  LzmaDecoderFunction() {
    this.hasGlobalName(["lzma_stream_decoder", "lzma_auto_decoder", "lzma_alone_decoder"])
  }
}

/**
 * The `lzma_code` function is used in Flow sink
 */
private class LzmaCodeFunction extends Function {
  LzmaCodeFunction() { this.hasGlobalName(["lzma_code"]) }
}

/**
 * The `lzma_stream_buffer_decode` function is used in Flow sink
 */
private class LzmaStreamBufferDecodeFunction extends Function {
  LzmaStreamBufferDecodeFunction() { this.hasGlobalName(["lzma_stream_buffer_decode"]) }
}

/**
 * https://github.com/tukaani-project/xz
 */
module XzTaintConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source.asExpr() instanceof LzmaStreamVar and
    state = ""
    or
    source.asExpr() instanceof Uint8Var and
    state = ""
    // and not exists(FunctionCall fc | fc.getTarget() instanceof LzmaStreamDecoderFunction)
  }

  predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(FunctionCall fc | fc.getTarget() instanceof LzmaStreamBufferDecodeFunction |
      fc.getArgument(1) = sink.asExpr() and
      state = ""
    )
    or
    exists(FunctionCall fc | fc.getTarget() instanceof LzmaCodeFunction |
      fc.getArgument(0) = sink.asExpr() and
      state = ""
    ) and
    exists(FunctionCall fc2 | fc2.getTarget() instanceof LzmaDecoderFunction)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowState state1, DataFlow::Node node2,
    DataFlow::FlowState state2
  ) {
    none()
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowState state) { none() }
}

module XzTaint = TaintTracking::GlobalWithState<XzTaintConfig>;

import XzTaint::PathGraph

from XzTaint::PathNode source, XzTaint::PathNode sink
where XzTaint::flowPath(source, sink)
select sink.getNode(), source, sink, "This Decompressiondepends on a $@.", source.getNode(),
  "potentially untrusted source"
