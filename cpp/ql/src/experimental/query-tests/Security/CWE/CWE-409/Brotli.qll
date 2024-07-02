/**
 * https://github.com/google/brotli
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File
import DecompressionBomb

/**
 * The `BrotliDecoderDecompress` function is used in flow sink. * Ref: https://www.brotli.org/decode.html#af68
 */
class BrotliDecoderDecompressFunction extends DecompressionFunction {
  BrotliDecoderDecompressFunction() { this.hasGlobalName(["BrotliDecoderDecompress"]) }

  override int getArchiveParameterIndex() { result = 1 }
}

/**
 * The `BrotliDecoderDecompressStream` function is used in flow sink. * Ref: https://www.brotli.org/decode.html#a234
 */
class BrotliDecoderDecompressStreamFunction extends DecompressionFunction {
  BrotliDecoderDecompressStreamFunction() { this.hasGlobalName(["BrotliDecoderDecompressStream"]) }

  override int getArchiveParameterIndex() { result = 2 }
}
