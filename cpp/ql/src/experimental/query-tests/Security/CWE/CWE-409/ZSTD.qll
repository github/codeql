/**
 * https://github.com/facebook/zstd/blob/dev/examples/streaming_decompression.c
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File

/**
 * A ZSTD_inBuffer Variable as a Flow source
 */
class ZSTDinBufferVar extends VariableAccess {
  ZSTDinBufferVar() { this.getType().hasName("ZSTD_inBuffer") }
}

/**
 * A ZSTD_inBuffer_s Variable as a Flow source
 */
class ZSTDinBufferSVar extends VariableAccess {
  ZSTDinBufferSVar() { this.getType().hasName("ZSTD_inBuffer_s") }
}

/**
 * The `ZSTD_decompress`  function is used in Flow sink
 */
class ZSTDDecompressFunction extends Function {
  ZSTDDecompressFunction() { this.hasGlobalName(["ZSTD_decompress"]) }
}

/**
 * The `ZSTD_decompressDCtx` function is used in Flow sink
 */
class ZSTDDecompressDCtxFunction extends Function {
  ZSTDDecompressDCtxFunction() { this.hasGlobalName(["ZSTD_decompressDCtx"]) }
}

/**
 * The `ZSTD_decompressStream` function is used in Flow sink
 */
class ZSTDDecompressStreamFunction extends Function {
  ZSTDDecompressStreamFunction() { this.hasGlobalName(["ZSTD_decompressStream"]) }
}

/**
 * The `ZSTD_decompress_usingDDict` function is used in Flow sink
 */
class ZSTDDecompressUsingDictFunction extends Function {
  ZSTDDecompressUsingDictFunction() { this.hasGlobalName(["ZSTD_decompress_usingDDict"]) }
}

/**
 * The `ZSTD_decompress_usingDDict` function is used in Flow sink
 */
class ZSTDDecompressUsingDDictFunction extends Function {
  ZSTDDecompressUsingDDictFunction() { this.hasGlobalName(["ZSTD_decompress_usingDDict"]) }
}
