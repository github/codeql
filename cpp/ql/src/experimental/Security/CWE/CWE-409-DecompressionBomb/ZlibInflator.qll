/**
 * https://www.zlib.net/
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A `z_stream` Variable as a Flow source
 */
class ZStreamVar extends VariableAccess {
  ZStreamVar() { this.getType().hasName("z_stream") }
}

/**
 * The `inflate`/`inflateSync` functions are used in Flow sink
 *
 * `inflate(z_streamp strm, int flush)`
 *
 * `inflateSync(z_streamp strm)`
 */
class InflateFunction extends Function {
  InflateFunction() { this.hasGlobalName(["inflate", "inflateSync"]) }
}
