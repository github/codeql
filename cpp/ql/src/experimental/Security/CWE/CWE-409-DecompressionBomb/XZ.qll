/**
 * https://github.com/tukaani-project/xz
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A `lzma_stream` Variable as a Flow source
 */
class LzmaStreamVar extends VariableAccess {
  LzmaStreamVar() { this.getType().hasName("lzma_stream") }
}

/**
 * The `lzma_*_decoder` function is used as a required condition for decompression
 */
class LzmaDecoderFunction extends Function {
  LzmaDecoderFunction() {
    this.hasGlobalName(["lzma_stream_decoder", "lzma_auto_decoder", "lzma_alone_decoder"])
  }
}

/**
 * The `lzma_code` function is used in Flow sink
 */
class LzmaCodeFunction extends Function {
  LzmaCodeFunction() { this.hasGlobalName(["lzma_code"]) }
}

/**
 * The `lzma_stream_buffer_decode` function is used in Flow sink
 */
class LzmaStreamBufferDecodeFunction extends Function {
  LzmaStreamBufferDecodeFunction() { this.hasGlobalName(["lzma_stream_buffer_decode"]) }
}
