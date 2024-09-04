/**
 * https://www.zlib.net/
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import DecompressionBomb

/**
 * The `gzfread` function is used in flow sink.
 *
 * `gzfread(voidp buf, z_size_t size, z_size_t nitems, gzFile file)`
 */
class GzFreadFunction extends DecompressionFunction {
  GzFreadFunction() { this.hasGlobalName("gzfread") }

  override int getArchiveParameterIndex() { result = 3 }
}

/**
 * The `gzgets` function is used in flow sink.
 *
 * `gzgets(gzFile file, char *buf, int len)`
 */
class GzGetsFunction extends DecompressionFunction {
  GzGetsFunction() { this.hasGlobalName("gzgets") }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `gzread` function is used in flow sink.
 *
 * `gzread(gzFile file, voidp buf, unsigned len)`
 */
class GzReadFunction extends DecompressionFunction {
  GzReadFunction() { this.hasGlobalName("gzread") }

  override int getArchiveParameterIndex() { result = 0 }
}

/**
 * The `gzdopen` function is used in flow steps.
 *
 * `gzdopen(int fd, const char *mode)`
 */
class GzdopenFunction extends DecompressionFlowStep {
  GzdopenFunction() { this.hasGlobalName("gzdopen") }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget() = this |
      node1.asExpr() = fc.getArgument(0) and
      node2.asExpr() = fc
    )
  }
}

/**
 * The `gzopen` function is used in flow steps.
 *
 * `gzopen(const char *path, const char *mode)`
 */
class GzopenFunction extends DecompressionFlowStep {
  GzopenFunction() { this.hasGlobalName("gzopen") }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(FunctionCall fc | fc.getTarget() = this |
      node1.asIndirectExpr() = fc.getArgument(0) and
      node2.asExpr() = fc
    )
  }
}
