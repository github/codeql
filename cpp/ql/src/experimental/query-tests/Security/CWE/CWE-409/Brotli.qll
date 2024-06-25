/**
 * https://github.com/google/brotli
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File

/**
 * A Pointer Variable is used in Flow source
 */
class PointerVar extends VariableAccess {
  PointerVar() { this.getType() instanceof PointerType }
}

/**
 * A Pointer Variable is used in Flow source
 */
class Uint8Var extends VariableAccess {
  Uint8Var() { this.getType() instanceof UInt8_t }
}

/**
 * The `BrotliDecoderDecompress` function is used in Flow sink
 * Ref: https://www.brotli.org/decode.html#af68
 */
class BrotliDecoderDecompressFunction extends Function {
  BrotliDecoderDecompressFunction() { this.hasGlobalName(["BrotliDecoderDecompress"]) }
}

/**
 * The `BrotliDecoderDecompressStream` function is used in Flow sink
 * Ref: https://www.brotli.org/decode.html#a234
 */
class BrotliDecoderDecompressStreamFunction extends Function {
  BrotliDecoderDecompressStreamFunction() { this.hasGlobalName(["BrotliDecoderDecompressStream"]) }
}
