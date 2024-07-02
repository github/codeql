/**
 * https://www.zlib.net/
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import DecompressionBomb

/**
 * The `inflate` and `inflateSync` functions are used in flow sink.
 *
 * `inflate(z_streamp strm, int flush)`
 *
 * `inflateSync(z_streamp strm)`
 */
class InflateFunction extends DecompressionFunction {
  InflateFunction() { this.hasGlobalName(["inflate", "inflateSync"]) }

  override int getArchiveParameterIndex() { result = 0 }
}
