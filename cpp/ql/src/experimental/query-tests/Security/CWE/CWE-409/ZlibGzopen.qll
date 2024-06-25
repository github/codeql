/**
 * https://www.zlib.net/
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources

/**
 * A `gzFile` Variable as a Flow source
 */
class GzFileVar extends VariableAccess {
  GzFileVar() { this.getType().hasName("gzFile") }
}

/**
 * The `gzopen` function as a Flow source
 *
 * `gzopen(const char *path, const char *mode)`
 */
class GzopenFunction extends Function {
  GzopenFunction() { this.hasGlobalName("gzopen") }
}

/**
 * The `gzdopen` function as a Flow source
 *
 * `gzdopen(int fd, const char *mode)`
 */
class GzdopenFunction extends Function {
  GzdopenFunction() { this.hasGlobalName("gzdopen") }
}

/**
 * The `gzfread` function is used in Flow sink
 *
 * `gzfread(voidp buf, z_size_t size, z_size_t nitems, gzFile file)`
 */
class GzFreadFunction extends Function {
  GzFreadFunction() { this.hasGlobalName("gzfread") }
}

/**
 * The `gzgets` function is used in Flow sink.
 *
 * `gzgets(gzFile file, char *buf, int len)`
 */
class GzGetsFunction extends Function {
  GzGetsFunction() { this.hasGlobalName("gzgets") }
}

/**
 * The `gzread` function is used in Flow sink
 *
 * `gzread(gzFile file, voidp buf, unsigned len)`
 */
class GzReadFunction extends Function {
  GzReadFunction() { this.hasGlobalName("gzread") }
}

predicate isSource(DataFlow::Node source) {
  exists(FunctionCall fc | fc.getTarget() instanceof GzopenFunction |
    fc.getArgument(0) = source.asExpr() and
    // arg 0 can be a path string whichwe must do following check
    not fc.getArgument(0).isConstant()
  )
  or
  // IDK whether it is good to use all file decriptors function returns as source or not
  // because we can do more sanitization from fd function sources
  exists(FunctionCall fc | fc.getTarget() instanceof GzdopenFunction |
    fc.getArgument(0) = source.asExpr()
  )
  or
  source.asExpr() instanceof GzFileVar
}
