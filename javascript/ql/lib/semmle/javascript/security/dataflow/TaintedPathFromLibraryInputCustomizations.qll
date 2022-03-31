/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * tainted-path vulnerabilities that come from library inputs.
 */

import TaintedPathCustomizations
import semmle.javascript.PackageExports

/** Holds if `name` suggests it is intended to refer to a path. */
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
 * Gets the `JSDocParamTag` for a parameter, if any.
 */
private JSDocParamTag getTagForParameter(DataFlow::ParameterNode p) {
  result.getName() = p.getName() and
  result = p.asExpr().getEnclosingFunction().getDocumentation().getATag()
}

/**
 * Holds if the JSDoc of a parameter mentions that it is, eg., a path.
 *
 * In this case, we don't want to use it as a source, because we'd expect
 * the library user to have sanitized the path.
 */
private predicate parameterJSDocMentionsRisk(DataFlow::ParameterNode p) {
  getTagForParameter(p)
      .getDescription()
      .regexpMatch("(?i).*" +
          [
            "file", //
            "path", //
            "directory", //
            "root", //
            "location" //
          ] + ".*")
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
    then
      not parameterJSDocMentionsRisk(this) and
      not isSafeName(this.(DataFlow::ParameterNode).getName())
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
