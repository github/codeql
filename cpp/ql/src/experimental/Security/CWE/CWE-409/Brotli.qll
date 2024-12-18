/**
 * https://github.com/google/brotli
 */

import cpp
import DecompressionBomb

/**
 * The `BrotliDecoderDecompress` function is used in flow sink.
 * See https://www.brotli.org/decode.html.
 */
class BrotliDecoderDecompressFunction extends DecompressionFunction {
  BrotliDecoderDecompressFunction() { this.hasGlobalName("BrotliDecoderDecompress") }

  override int getArchiveParameterIndex() { result = 1 }
}

/**
 * The `BrotliDecoderDecompressStream` function is used in flow sink.
 * See https://www.brotli.org/decode.html.
 */
class BrotliDecoderDecompressStreamFunction extends DecompressionFunction {
  BrotliDecoderDecompressStreamFunction() { this.hasGlobalName("BrotliDecoderDecompressStream") }

  override int getArchiveParameterIndex() { result = 2 }
}
