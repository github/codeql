/**
 * https://www.zlib.net/
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import DecompressionBomb

/**
 * The `uncompress`/`uncompress2` function is used in flow sink.
 */
class UncompressFunction extends DecompressionFunction {
  UncompressFunction() { this.hasGlobalName(["uncompress", "uncompress2"]) }

  override int getArchiveParameterIndex() { result = 0 }
}
