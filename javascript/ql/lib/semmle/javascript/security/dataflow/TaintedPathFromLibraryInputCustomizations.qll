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
        "folder", //
        "host", //
        "loc", //
        "location", //
        "path", //
        "root", //
        "src", //
        "source", //
      ] + ["", "name"])
}

/** Gets the `JSDocParamTag` for a parameter, if any. */
private JSDocParamTag getTagForParameter(DataFlow::ParameterNode p) {
  result = getNamedTag(p.asExpr().getEnclosingFunction(), p.getName())
}

pragma[noinline]
private JSDocParamTag getNamedTag(Function f, string name) {
  result = f.getDocumentation().getATag() and
  result.getName() = name
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
class LibInputAsSource extends TaintedPath::Source instanceof DataFlow::ParameterNode {
  LibInputAsSource() {
    this = getALibraryInputParameter() and
    not parameterJSDocMentionsRisk(this) and
    not isSafeName(this.(DataFlow::ParameterNode).getName())
  }
}

/** Gets a `DataFlow::Node` that flows to a tainted-path sink. */
private DataFlow::Node isFlowingToTaintedPathSink() {
  result = isFlowingToTaintedPathSink(DataFlow::TypeBackTracker::end())
}

private DataFlow::Node isFlowingToTaintedPathSink(DataFlow::TypeBackTracker t) {
  t.start() and result instanceof TaintedPath::Sink
  or
  exists(DataFlow::TypeBackTracker t2 | t2 = t.smallstep(result, isFlowingToTaintedPathSink(t2)))
}

/**
 * A leaf of a string concatenation that ends up in a tainted-path-sink. We will use such leaves
 * as sinks. This reduces false positives, as paths that directly flow from a library input to
 * a sink often do so intentionally.
 */
class StringConcatLeafEndingInSink extends StringOps::ConcatenationLeaf {
  StringConcatLeafEndingInSink() {
    exists(StringOps::ConcatenationRoot root |
      this = root.getALeaf() and
      root = isFlowingToTaintedPathSink()
    )
  }
}

/** A value that can be tracked from a library input. Used for sanitization
 * (a library input property with a 'safe' name is considered a sanitizer).
 */
private DataFlow::SourceNode isFlowingFromLibInput() {
  result = isFlowingFromLibInput(DataFlow::TypeTracker::end())
}

private DataFlow::SourceNode isFlowingFromLibInput(DataFlow::TypeTracker t) {
  t.start() and result instanceof LibInputAsSource
  or
  exists(DataFlow::TypeTracker t2 | result = isFlowingFromLibInput(t2).track(t2, t))
}

/**
 * A sanitizer from reading a property with a name that suggests
 * the property is intended to be a path.
 */
class SafeNameSanitizer extends TaintedPath::Sanitizer instanceof DataFlow::PropRead {
  SafeNameSanitizer() {
    this = isFlowingFromLibInput().getAPropertyRead*() and
    isSafeName(this.getPropertyName())
  }
}
