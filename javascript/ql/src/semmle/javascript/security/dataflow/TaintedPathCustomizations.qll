/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * tainted-path vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript

module TaintedPath {
  /**
   * A data flow source for tainted-path vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a flow label denoting the type of value for which this is a source. */
    DataFlow::FlowLabel getAFlowLabel() { result instanceof Label::PosixPath }
  }

  /**
   * A data flow sink for tainted-path vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets a flow label denoting the type of value for which this is a sink. */
    DataFlow::FlowLabel getAFlowLabel() { result instanceof Label::PosixPath }
  }

  /**
   * A sanitizer for tainted-path vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  module Label {
    /**
     * A string indicating if a path is normalized, that is, whether internal `../` components
     * have been removed.
     */
    class Normalization extends string {
      Normalization() { this = "normalized" or this = "raw" }
    }

    /**
     * A string indicating if a path is relative or absolute.
     */
    class Relativeness extends string {
      Relativeness() { this = "relative" or this = "absolute" }
    }

    /**
     * A flow label representing a Posix path.
     *
     * There are currently four flow labels, representing the different combinations of
     * normalization and absoluteness.
     */
    class PosixPath extends DataFlow::FlowLabel {
      Normalization normalization;
      Relativeness relativeness;

      PosixPath() { this = normalization + "-" + relativeness + "-posix-path" }

      /** Gets a string indicating whether this path is normalized. */
      Normalization getNormalization() { result = normalization }

      /** Gets a string indicating whether this path is relative. */
      Relativeness getRelativeness() { result = relativeness }

      /** Holds if this path is normalized. */
      predicate isNormalized() { normalization = "normalized" }

      /** Holds if this path is not normalized. */
      predicate isNonNormalized() { normalization = "raw" }

      /** Holds if this path is relative. */
      predicate isRelative() { relativeness = "relative" }

      /** Holds if this path is relative. */
      predicate isAbsolute() { relativeness = "absolute" }

      /** Gets the path label with normalized flag set to true. */
      PosixPath toNormalized() {
        result.isNormalized() and
        result.getRelativeness() = this.getRelativeness()
      }

      /** Gets the path label with normalized flag set to true. */
      PosixPath toNonNormalized() {
        result.isNonNormalized() and
        result.getRelativeness() = this.getRelativeness()
      }

      /** Gets the path label with absolute flag set to true. */
      PosixPath toAbsolute() {
        result.isAbsolute() and
        result.getNormalization() = this.getNormalization()
      }

      /** Gets the path label with absolute flag set to true. */
      PosixPath toRelative() {
        result.isRelative() and
        result.getNormalization() = this.getNormalization()
      }

      /** Holds if this path may contain `../` components. */
      predicate canContainDotDotSlash() {
        // Absolute normalized path is the only combination that cannot contain `../`.
        not (isNormalized() and isAbsolute())
      }
    }

    /**
     * A flow label representing an array of path elements that may include "..".
     */
    class SplitPath extends DataFlow::FlowLabel {
      SplitPath() { this = "splitPath" }
    }
  }

  /**
   * Holds if `s` is a relative path.
   */
  bindingset[s]
  predicate isRelative(string s) { not s.charAt(0) = "/" }

  /**
   * A call that normalizes a path.
   */
  class NormalizingPathCall extends DataFlow::CallNode {
    DataFlow::Node input;
    DataFlow::Node output;

    NormalizingPathCall() {
      this = NodeJSLib::Path::moduleMember("normalize").getACall() and
      input = getArgument(0) and
      output = this
    }

    /**
     * Gets the input path to be normalized.
     */
    DataFlow::Node getInput() { result = input }

    /**
     * Gets the normalized path.
     */
    DataFlow::Node getOutput() { result = output }
  }

  /**
   * A call that converts a path to an absolute normalized path.
   */
  class ResolvingPathCall extends DataFlow::CallNode {
    DataFlow::Node input;
    DataFlow::Node output;

    ResolvingPathCall() {
      this = NodeJSLib::Path::moduleMember("resolve").getACall() and
      input = getAnArgument() and
      output = this
      or
      this = DataFlow::moduleMember("fs", "realpathSync").getACall() and
      input = getArgument(0) and
      output = this
      or
      this = DataFlow::moduleMember("fs", "realpath").getACall() and
      input = getArgument(0) and
      output = getCallback(1).getParameter(1)
    }

    /**
     * Gets the input path to be normalized.
     */
    DataFlow::Node getInput() { result = input }

    /**
     * Gets the normalized path.
     */
    DataFlow::Node getOutput() { result = output }
  }

  /**
   * A call that normalizes a path and converts it to a relative path.
   */
  class NormalizingRelativePathCall extends DataFlow::CallNode {
    DataFlow::Node input;
    DataFlow::Node output;

    NormalizingRelativePathCall() {
      this = NodeJSLib::Path::moduleMember("relative").getACall() and
      input = getAnArgument() and
      output = this
    }

    /**
     * Gets the input path to be normalized.
     */
    DataFlow::Node getInput() { result = input }

    /**
     * Gets the normalized path.
     */
    DataFlow::Node getOutput() { result = output }
  }

  /**
   * A call that preserves taint without changing the flow label.
   */
  class PreservingPathCall extends DataFlow::CallNode {
    DataFlow::Node input;
    DataFlow::Node output;

    PreservingPathCall() {
      exists(string name | name = "dirname" or name = "toNamespacedPath" |
        this = NodeJSLib::Path::moduleMember(name).getACall() and
        input = getAnArgument() and
        output = this
      )
      or
      // non-global replace or replace of something other than /\.\./g, /[/]/g, or /[\.]/g.
      this.getCalleeName() = "replace" and
      input = getReceiver() and
      output = this and
      not exists(RegExpLiteral literal, RegExpTerm term |
        getArgument(0).getALocalSource().asExpr() = literal and
        literal.isGlobal() and
        literal.getRoot() = term
      |
        term.getAMatchedString() = "/" or
        term.getAMatchedString() = "." or
        term.getAMatchedString() = ".."
      )
    }

    /**
     * Gets the input path to be normalized.
     */
    DataFlow::Node getInput() { result = input }

    /**
     * Gets the normalized path.
     */
    DataFlow::Node getOutput() { result = output }
  }

  /**
   * A call that removes all "." or ".." from a path, without also removing all forward slashes.
   */
  class DotRemovingReplaceCall extends DataFlow::CallNode {
    DataFlow::Node input;
    DataFlow::Node output;

    DotRemovingReplaceCall() {
      this.getCalleeName() = "replace" and
      input = getReceiver() and
      output = this and
      exists(RegExpLiteral literal, RegExpTerm term |
        getArgument(0).getALocalSource().asExpr() = literal and
        literal.isGlobal() and
        literal.getRoot() = term and
        not term.getAMatchedString() = "/"
      |
        term.getAMatchedString() = "." or
        term.getAMatchedString() = ".."
      )
    }

    /**
     * Gets the input path to be normalized.
     */
    DataFlow::Node getInput() { result = input }

    /**
     * Gets the normalized path.
     */
    DataFlow::Node getOutput() { result = output }
  }

  /**
   * Holds if `node` is a prefix of the string `../`.
   */
  private predicate isDotDotSlashPrefix(DataFlow::Node node) {
    node.getStringValue() + any(string s) = "../"
    or
    // ".." + path.sep
    exists(StringOps::Concatenation conc | node = conc |
      conc.getOperand(0).getStringValue() = ".." and
      conc.getOperand(1).getALocalSource() = NodeJSLib::Path::moduleMember("sep") and
      conc.getNumOperand() = 2
    )
  }

  /**
   * A check of form `x.startsWith("../")` or similar.
   *
   * This is relevant for paths that are known to be normalized.
   */
  class StartsWithDotDotSanitizer extends DataFlow::LabeledBarrierGuardNode {
    StringOps::StartsWith startsWith;

    StartsWithDotDotSanitizer() {
      this = startsWith and
      isDotDotSlashPrefix(startsWith.getSubstring())
    }

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      // Sanitize in the false case for:
      //   .startsWith(".")
      //   .startsWith("..")
      //   .startsWith("../")
      outcome = startsWith.getPolarity().booleanNot() and
      e = startsWith.getBaseString().asExpr() and
      exists(Label::PosixPath posixPath | posixPath = label |
        posixPath.isNormalized() and
        posixPath.isRelative()
      )
    }
  }

  /**
   * A check of form `x.startsWith(dir)` that sanitizes normalized absolute paths, since it is then
   * known to be in a subdirectory of `dir`.
   */
  class StartsWithDirSanitizer extends DataFlow::LabeledBarrierGuardNode {
    StringOps::StartsWith startsWith;

    StartsWithDirSanitizer() {
      this = startsWith and
      not isDotDotSlashPrefix(startsWith.getSubstring()) and
      // do not confuse this with a simple isAbsolute() check
      not startsWith.getSubstring().getStringValue() = "/"
    }

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      outcome = startsWith.getPolarity() and
      e = startsWith.getBaseString().asExpr() and
      exists(Label::PosixPath posixPath | posixPath = label |
        posixPath.isAbsolute() and
        posixPath.isNormalized()
      )
    }
  }

  /**
   * A call to `path.isAbsolute` as a sanitizer for relative paths in true branch,
   * and a sanitizer for absolute paths in the false branch.
   */
  class IsAbsoluteSanitizer extends DataFlow::LabeledBarrierGuardNode {
    DataFlow::Node operand;
    boolean polarity;
    boolean negatable;

    IsAbsoluteSanitizer() {
      exists(DataFlow::CallNode call | this = call |
        call = NodeJSLib::Path::moduleMember("isAbsolute").getACall() and
        operand = call.getArgument(0) and
        polarity = true and
        negatable = true
      )
      or
      exists(StringOps::StartsWith startsWith, string substring | this = startsWith |
        startsWith.getSubstring().getStringValue() = "/" + substring and
        operand = startsWith.getBaseString() and
        polarity = startsWith.getPolarity() and
        if substring = "" then negatable = true else negatable = false
      ) // !x.startsWith("/home") does not guarantee that x is not absolute
    }

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      e = operand.asExpr() and
      exists(Label::PosixPath posixPath | posixPath = label |
        outcome = polarity and posixPath.isRelative()
        or
        negatable = true and
        outcome = polarity.booleanNot() and
        posixPath.isAbsolute()
      )
    }
  }

  /**
   * An expression of form `x.includes("..")` or similar.
   */
  class ContainsDotDotSanitizer extends DataFlow::LabeledBarrierGuardNode {
    StringOps::Includes contains;

    ContainsDotDotSanitizer() {
      this = contains and
      isDotDotSlashPrefix(contains.getSubstring())
    }

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      e = contains.getBaseString().asExpr() and
      outcome = contains.getPolarity().booleanNot() and
      label.(Label::PosixPath).canContainDotDotSlash() // can still be bypassed by normalized absolute path
    }
  }

  /**
   * A sanitizer that recognizes the following pattern:
   * ```
   * var relative = path.relative(webroot, pathname);
   * if(relative.startsWith(".." + path.sep) || relative == "..") {
   *   // pathname is unsafe
   * } else {
   *   // pathname is safe
   * }
   * ```
   *
   * or
   * ```
   * var relative = path.resolve(pathname); // or path.normalize
   * if(relative.startsWith(webroot) {
   *   // pathname is safe
   * } else {
   *   // pathname is unsafe
   * }
   * ```
   */
  class RelativePathStartsWithSanitizer extends DataFlow::BarrierGuardNode {
    StringOps::StartsWith startsWith;
    DataFlow::CallNode pathCall;
    string member;

    RelativePathStartsWithSanitizer() {
      (member = "relative" or member = "resolve" or member = "normalize") and
      this = startsWith and
      pathCall = NodeJSLib::Path::moduleMember(member).getACall() and
      (
        startsWith.getBaseString().getALocalSource() = pathCall
        or
        startsWith
            .getBaseString()
            .getALocalSource()
            .(NormalizingPathCall)
            .getInput()
            .getALocalSource() = pathCall
      ) and
      (not member = "relative" or isDotDotSlashPrefix(startsWith.getSubstring()))
    }

    override predicate blocks(boolean outcome, Expr e) {
      member = "relative" and
      e = pathCall.getArgument(1).asExpr() and
      outcome = startsWith.getPolarity().booleanNot()
      or
      not member = "relative" and
      e = pathCall.getArgument(0).asExpr() and
      outcome = startsWith.getPolarity()
    }
  }

  /**
   * A guard node for a variable in a negative condition, such as `x` in `if(!x)`.
   */
  private class VarAccessBarrier extends Sanitizer, DataFlow::VarAccessBarrier { }

  /**
   * An expression of form `isInside(x, y)` or similar, where `isInside` is
   * a library check for the relation between `x` and `y`.
   */
  class IsInsideCheckSanitizer extends DataFlow::LabeledBarrierGuardNode {
    DataFlow::Node checked;
    boolean onlyNormalizedAbsolutePaths;

    IsInsideCheckSanitizer() {
      exists(string name, DataFlow::CallNode check |
        name = "path-is-inside" and onlyNormalizedAbsolutePaths = true
        or
        name = "is-path-inside" and onlyNormalizedAbsolutePaths = false
      |
        check = DataFlow::moduleImport(name).getACall() and
        checked = check.getArgument(0) and
        check = this
      )
    }

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      (
        onlyNormalizedAbsolutePaths = true and
        label.(Label::PosixPath).isNormalized() and
        label.(Label::PosixPath).isAbsolute()
        or
        onlyNormalizedAbsolutePaths = false
      ) and
      e = checked.asExpr() and
      outcome = true
    }
  }

  /**
   * A source of remote user input, considered as a flow source for
   * tainted-path vulnerabilities.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
  }

  /**
   * An expression whose value is interpreted as a path to a module, making it
   * a data flow sink for tainted-path vulnerabilities.
   */
  class ModulePathSink extends Sink, DataFlow::ValueNode {
    ModulePathSink() {
      astNode = any(Require rq).getArgument(0) or
      astNode = any(ExternalModuleReference rq).getExpression() or
      astNode = any(AmdModuleDefinition amd).getDependencies()
    }
  }

  /**
   * A path argument to a file system access.
   */
  class FsPathSink extends Sink, DataFlow::ValueNode {
    FileSystemAccess fileSystemAccess;

    FsPathSink() {
      (
        this = fileSystemAccess.getAPathArgument() and
        not exists(fileSystemAccess.getRootPathArgument())
        or
        this = fileSystemAccess.getRootPathArgument()
      ) and
      not this = any(ResolvingPathCall call).getInput()
    }
  }

  /**
   * A path argument to a file system access, which disallows upward navigation.
   */
  private class FsPathSinkWithoutUpwardNavigation extends FsPathSink {
    FsPathSinkWithoutUpwardNavigation() { fileSystemAccess.isUpwardNavigationRejected(this) }

    override DataFlow::FlowLabel getAFlowLabel() {
      // The protection is ineffective if the ../ segments have already
      // cancelled out against the intended root dir using path.join or similar.
      // Only flag normalized paths, as this corresponds to the output
      // of a normalizing call that had a malicious input.
      result.(Label::PosixPath).isNormalized()
    }
  }

  /**
   * A path argument to the Express `res.render` method.
   */
  class ExpressRenderSink extends Sink, DataFlow::ValueNode {
    ExpressRenderSink() {
      exists(MethodCallExpr mce |
        Express::isResponse(mce.getReceiver()) and
        mce.getMethodName() = "render" and
        astNode = mce.getArgument(0)
      )
    }
  }

  /**
   * A `templateUrl` member of an AngularJS directive.
   */
  class AngularJSTemplateUrlSink extends Sink, DataFlow::ValueNode {
    AngularJSTemplateUrlSink() { this = any(AngularJS::CustomDirective d).getMember("templateUrl") }
  }

  /**
   * The path argument of a [send](https://www.npmjs.com/package/send) call, viewed as a sink.
   */
  class SendPathSink extends Sink, DataFlow::ValueNode {
    SendPathSink() { this = DataFlow::moduleImport("send").getACall().getArgument(1) }
  }
}
