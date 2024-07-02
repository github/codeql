/**
 * https://github.com/facebook/zstd/blob/dev/examples/streaming_decompression.c
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File
import DecompressionBomb

/**
 * The `ZSTD_decompress`  function is used in flow sink.
 */
class ZSTDDecompressFunction extends DecompressionFunction {
  ZSTDDecompressFunction() { this.hasGlobalName(["ZSTD_decompress"]) }

  override int getArchiveParameterIndex() { result = 2 }
}

/**
 * The `ZSTD_decompressDCtx` function is used in flow sink.
 */
class ZSTDDecompressDCtxFunction extends DecompressionFunction {
  ZSTDDecompressDCtxFunction() { this.hasGlobalName(["ZSTD_decompressDCtx"]) }

  override int getArchiveParameterIndex() { result = 3 }
}

/**
 * The `ZSTD_decompressStream` function is used in flow sink.
 */
class ZSTDDecompressStreamFunction extends DecompressionFunction {
  ZSTDDecompressStreamFunction() { this.hasGlobalName(["ZSTD_decompressStream"]) }

  override int getArchiveParameterIndex() { result = 2 }
}

/**
 * The `ZSTD_decompress_usingDDict` function is used in flow sink.
 */
class ZSTDDecompressUsingDictFunction extends DecompressionFunction {
  ZSTDDecompressUsingDictFunction() { this.hasGlobalName(["ZSTD_decompress_usingDDict"]) }

  override int getArchiveParameterIndex() { result = 3 }
}

/**
 * The `ZSTD_decompress_usingDDict` function is used in flow sink.
 */
class ZSTDDecompressUsingDDictFunction extends DecompressionFunction {
  ZSTDDecompressUsingDDictFunction() { this.hasGlobalName(["ZSTD_decompress_usingDDict"]) }

  override int getArchiveParameterIndex() { result = 3 }
}
