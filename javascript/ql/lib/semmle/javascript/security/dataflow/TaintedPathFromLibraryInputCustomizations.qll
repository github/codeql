/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * tainted-path vulnerabilities that come from library inputs.
 */

import TaintedPathCustomizations
import semmle.javascript.PackageExports

/**
 * An input to a library is considered a flow source, unless
 * it is a parameter with a name that hints at it being
 * intended to be a path.
 */
class LibInputAsSource extends TaintedPath::Source {
  LibInputAsSource() { this = getALibraryInputParameter() }
}
