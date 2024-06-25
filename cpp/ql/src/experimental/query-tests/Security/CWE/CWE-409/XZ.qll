/**
 * https://github.com/tukaani-project/xz
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import DecompressionBomb

/**
 * The `lzma_code` function is used in flow sink.
 */
class LzmaCodeFunction extends DecompressionFunction {
  LzmaCodeFunction() { this.hasGlobalName(["lzma_code"]) }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `lzma_stream_buffer_decode` function is used in flow sink.
 */
class LzmaStreamBufferDecodeFunction extends DecompressionFunction {
  LzmaStreamBufferDecodeFunction() { this.hasGlobalName(["lzma_stream_buffer_decode"]) }

  override int getArchiveParameterIndex() { result = 1 }
}
