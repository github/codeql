/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * tainted-path vulnerabilities that come from library inputs.
 */

import TaintedPathCustomizations
import semmle.javascript.PackageExports

/** Holds if the name suggests it is intended to refer to a path. */
bindingset[name]
private predicate isSafeName(string name) {
  name.regexpMatch("(?i).*" +
      [
        "cwd", //
        "dir", //
        "directory", //
        "file", //
        "filename", //
        "loc", //
        "location", //
        "path", //
        "root", //
      ])
}

/**
 * An input to a library is considered a flow source, unless
 * it is a parameter with a name that hints at it being
 * intended to be a path.
 */
class LibInputAsSource extends TaintedPath::Source {
  LibInputAsSource() {
    this = getALibraryInputParameter() and
    if this instanceof DataFlow::ParameterNode
    then not isSafeName(this.(DataFlow::ParameterNode).getName())
    else any()
  }
}

/**
 * A sanitizer from reading a property with a name that suggests
 * the property is intended to be a path.
 */
class SafeNameSanitizer extends TaintedPath::Sanitizer {
  SafeNameSanitizer() { isSafeName(this.(DataFlow::PropRead).getPropertyName()) }
}
