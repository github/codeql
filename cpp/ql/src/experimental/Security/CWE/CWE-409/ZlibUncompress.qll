/**
 * https://www.zlib.net/
 */

import cpp
import DecompressionBomb

/**
 * The `uncompress`/`uncompress2` function is used in flow sink.
 */
class UncompressFunction extends DecompressionFunction {
  UncompressFunction() { this.hasGlobalName(["uncompress", "uncompress2"]) }

  override int getArchiveParameterIndex() { result = 2 }
}
