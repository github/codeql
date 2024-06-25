/**
 * https://www.sourceware.org/bzip2/manual/manual.html
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.commons.File
import DecompressionBomb

/**
 * The `BZ2_bzDecompress` function as a Flow source
 */
class BZ2BzDecompressFunction extends DecompressionFunction {
  BZ2BzDecompressFunction() { this.hasGlobalName(["BZ2_bzDecompress"]) }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `BZ2_bzReadOpen` function
 */
class BZ2BzReadOpenFunction extends DecompressionFunction {
  BZ2BzReadOpenFunction() { this.hasGlobalName(["BZ2_bzReadOpen"]) }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `BZ2_bzRead` function is used in flow sink.
 */
class BZ2BzReadFunction extends DecompressionFunction {
  BZ2BzReadFunction() { this.hasGlobalName("BZ2_bzRead") }

  override int getArchiveParameterIndex() { result = 1 }
}

/**
 * The `BZ2_bzBuffToBuffDecompress` function is used in flow sink.
 */
class BZ2BzBuffToBuffDecompressFunction extends DecompressionFunction {
  BZ2BzBuffToBuffDecompressFunction() { this.hasGlobalName("BZ2_bzBuffToBuffDecompress") }

  override int getArchiveParameterIndex() { result = 2 }
}
