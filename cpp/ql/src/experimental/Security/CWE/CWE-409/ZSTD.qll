/**
 * https://github.com/facebook/zstd/blob/dev/examples/streaming_decompression.c
 */

import cpp
import DecompressionBomb

/**
 * The `ZSTD_decompress`  function is used in flow sink.
 */
class ZstdDecompressFunction extends DecompressionFunction {
  ZstdDecompressFunction() { this.hasGlobalName("ZSTD_decompress") }

  override int getArchiveParameterIndex() { result = 2 }
}

/**
 * The `ZSTD_decompressDCtx` function is used in flow sink.
 */
class ZstdDecompressDctxFunction extends DecompressionFunction {
  ZstdDecompressDctxFunction() { this.hasGlobalName("ZSTD_decompressDCtx") }

  override int getArchiveParameterIndex() { result = 3 }
}

/**
 * The `ZSTD_decompressStream` function is used in flow sink.
 */
class ZstdDecompressStreamFunction extends DecompressionFunction {
  ZstdDecompressStreamFunction() { this.hasGlobalName("ZSTD_decompressStream") }

  override int getArchiveParameterIndex() { result = 2 }
}

/**
 * The `ZSTD_decompress_usingDDict` function is used in flow sink.
 */
class ZstdDecompressUsingDdictFunction extends DecompressionFunction {
  ZstdDecompressUsingDdictFunction() { this.hasGlobalName("ZSTD_decompress_usingDDict") }

  override int getArchiveParameterIndex() { result = 3 }
}

/**
 * The `fopen_orDie` function as a flow step.
 */
class FopenOrDieFunctionStep extends DecompressionFlowStep {
  FopenOrDieFunctionStep() { this = "FopenOrDieFunctionStep" }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget().hasGlobalName("fopen_orDie") |
      node1.asIndirectExpr() = fc.getArgument(0) and
      node2.asExpr() = fc
    )
  }
}

/**
 * The `fread_orDie` function as a flow step.
 */
class FreadOrDieFunctionStep extends DecompressionFlowStep {
  FreadOrDieFunctionStep() { this = "FreadOrDieFunctionStep" }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget().hasGlobalName("fread_orDie") |
      node1.asExpr() = fc.getArgument(2) and
      node2.asIndirectExpr() = fc.getArgument(0)
    )
  }
}

/**
 * The `src` member of a `ZSTD_inBuffer` variable is used in a flow steps.
 */
class SrcMember extends DecompressionFlowStep {
  SrcMember() { this = "SrcMember" }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(VariableAccess inBufferAccess, Field srcField, ClassAggregateLiteral c |
      inBufferAccess.getType().hasName("ZSTD_inBuffer") and
      srcField.hasName("src")
    |
      node2.asExpr() = inBufferAccess and
      inBufferAccess.getTarget().getInitializer().getExpr() = c and
      node1.asIndirectExpr() = c.getFieldExpr(srcField, _)
    )
  }
}
