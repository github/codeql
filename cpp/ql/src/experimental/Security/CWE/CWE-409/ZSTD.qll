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
class FopenOrDieFunction extends DecompressionFlowStep {
  FopenOrDieFunction() { this.hasGlobalName("fopen_orDie") }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget() = this |
      node1.asIndirectExpr() = fc.getArgument(0) and
      node2.asExpr() = fc
    )
  }
}

/**
 * The `fread_orDie` function as a flow step.
 */
class FreadOrDieFunction extends DecompressionFlowStep {
  FreadOrDieFunction() { this.hasGlobalName("fread_orDie") }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget() = this |
      node1.asIndirectExpr() = fc.getArgument(2) and
      node2.asIndirectExpr() = fc.getArgument(0)
    )
  }
}
