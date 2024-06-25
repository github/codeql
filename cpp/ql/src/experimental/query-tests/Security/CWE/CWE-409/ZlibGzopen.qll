/**
 * https://www.zlib.net/
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.security.FlowSources
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

  override int getArchiveParameterIndex() { result = 1 }
}

/**
 * The `gzdopen` function.
 *
 * `gzdopen(int fd, const char *mode)`
 */
class GzdopenFunction extends Function {
  GzdopenFunction() { this.hasGlobalName("gzdopen") }
}

/**
 * The `gzopen` function.
 *
 * `gzopen(const char *path, const char *mode)`
 */
class GzopenFunction extends Function {
  GzopenFunction() { this.hasGlobalName("gzopen") }
}
