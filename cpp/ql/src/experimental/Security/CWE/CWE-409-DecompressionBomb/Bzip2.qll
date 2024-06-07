/**
 * https://www.sourceware.org/bzip2/manual/manual.html
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File

/**
 * A `bz_stream` Variable as a Flow source
 */
class BzStreamVar extends VariableAccess {
  BzStreamVar() { this.getType().hasName("bz_stream") }
}

/**
 * A `BZFILE` Variable as a Flow source
 */
class BzFileVar extends VariableAccess {
  BzFileVar() { this.getType().hasName("BZFILE") }
}

/**
 * The `BZ2_bzDecompress` function as a Flow source
 */
class BZ2BzDecompressFunction extends Function {
  BZ2BzDecompressFunction() { this.hasGlobalName(["BZ2_bzDecompress"]) }
}

/**
 * The `BZ2_bzReadOpen` function
 */
class BZ2BzReadOpenFunction extends Function {
  BZ2BzReadOpenFunction() { this.hasGlobalName(["BZ2_bzReadOpen"]) }
}

/**
 * The `BZ2_bzRead` function is used in Flow sink
 */
class BZ2BzReadFunction extends Function {
  BZ2BzReadFunction() { this.hasGlobalName("BZ2_bzRead") }
}

/**
 * The `BZ2_bzBuffToBuffDecompress` function is used in Flow sink
 */
class BZ2BzBuffToBuffDecompressFunction extends Function {
  BZ2BzBuffToBuffDecompressFunction() { this.hasGlobalName("BZ2_bzBuffToBuffDecompress") }
}
