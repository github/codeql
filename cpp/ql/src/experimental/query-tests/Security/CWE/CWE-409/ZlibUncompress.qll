/**
 * https://www.zlib.net/
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A Bytef Variable as a Flow source
 */
class BytefVar extends VariableAccess {
  BytefVar() { this.getType().hasName("Bytef") }
}

/**
 * The `uncompress`/`uncompress2` function is used in Flow sink
 */
class UncompressFunction extends Function {
  UncompressFunction() { this.hasGlobalName(["uncompress", "uncompress2"]) }
}
