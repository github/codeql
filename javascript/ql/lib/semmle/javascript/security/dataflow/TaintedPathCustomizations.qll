/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * tainted-path vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript

/**
 * Provides logic for tracking of tainted paths.
 */
module TaintedPath {
  /**
   * A data flow source for tainted-path vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a flow label denoting the type of value for which this is a source. */
    DataFlow::FlowLabel getAFlowLabel() { result instanceof Path::PathLabel }
  }

  /**
   * A data flow sink for tainted-path vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets a flow label denoting the type of value for which this is a sink. */
    DataFlow::FlowLabel getAFlowLabel() { result instanceof Path::PathLabel }
  }

  /**
   * A sanitizer for tainted-path vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A barrier guard for tainted-path vulnerabilities.
   */
  abstract class BarrierGuardNode extends DataFlow::LabeledBarrierGuardNode { }

  /**
   * Provides implementations of path labels used in tainted path analysis.
   */
  module Path {
    /**
     * A flow label representing an array of path elements that may include "..".
     */
    abstract class SplitPath extends DataFlow::FlowLabel {
      SplitPath() { this = "splitPath" }
    }

    string platformPosix() { result = "posix" }

    string platformWin32() { result = "win32" }

    abstract class Platform extends string {
      Platform() { this = [platformPosix(), platformWin32()] }

      abstract string getSep();

      DataFlow::SourceNode getExplicitImport() { result = DataFlow::moduleMember("path", this) }
    }

    class PosixPlatform extends Platform {
      PosixPlatform() { this = platformPosix() }

      override string getSep() { result = "/" }
    }

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
     * Holds if `s` is a relative path.
     */
    bindingset[s]
    predicate isRelative(string s) {
      forall(Platform p | not s.substring(0, p.getSep().length()) = p.getSep())
    }

    /**
     * Holds if `s` is a drive path, eg.: `C:\\test.txt`.
     */
    bindingset[s]
    predicate isDrivePath(string s) { s.regexpMatch("^[a-zA-Z]:\\\\*") }

    /**
     * A flow label representing a file path.
     *
     * By default, there are four flow labels, representing the different combinations of
     * normalization and absoluteness.
     */
    abstract class PathLabel extends DataFlow::FlowLabel {
      Normalization normalization;
      Relativeness relativeness;
      Platform platform;

      PathLabel() { this = normalization + "-" + relativeness + "-" + platform + "-path" }

      /** Gets a string indicating whether this path is normalized. */
      Normalization getNormalization() { result = normalization }

      /** Gets a string indicating whether this path is relative. */
      Relativeness getRelativeness() { result = relativeness }

      /** Gets the platform this path is for */
      Platform getPlatform() { result = platform }

      /** Holds if this path is normalized. */
      predicate isNormalized() { normalization = "normalized" }

      /** Holds if this path is not normalized. */
      predicate isNonNormalized() { normalization = "raw" }

      /** Holds if this path is relative. */
      predicate isRelative() { relativeness = "relative" }

      /** Holds if this path is relative. */
      predicate isAbsolute() { relativeness = "absolute" }

      /** Gets the path label with normalized flag set to true. */
      PathLabel toNormalized() {
        result.isNormalized() and
        result.getRelativeness() = this.getRelativeness()
      }

      /** Gets the path label with normalized flag set to true. */
      PathLabel toNonNormalized() {
        result.isNonNormalized() and
        result.getRelativeness() = this.getRelativeness()
      }

      /** Gets the path label with absolute flag set to true. */
      PathLabel toAbsolute() {
        result.isAbsolute() and
        result.getNormalization() = this.getNormalization()
      }

      /** Gets the path label with absolute flag set to true. */
      PathLabel toRelative() {
        result.isRelative() and
        result.getNormalization() = this.getNormalization()
      }

      /** Holds if this path may contain `../` components. */
      predicate canContainDotDotSep() {
        // Absolute normalized path is the only combination that cannot contain `../`.
        not (this.isNormalized() and this.isAbsolute())
      }
    }
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
   * Provides logic for tracking taint flow through `DataFlow::CallNode`s
   * that return paths.
   */
  module PathTransformations {
    /** An abstract description of what kind of paths a call may return. */
    abstract class PathTransformationNode extends DataFlow::CallNode {
      DataFlow::Node input;
      DataFlow::Node output;

      PathTransformationNode() { this = this }

      abstract predicate step(
        Path::PathLabel inputLabel, DataFlow::Node inputNode, Path::PathLabel outputLabel,
        DataFlow::Node outputNode
      );

      DataFlow::Node getInput() { result = input }

      DataFlow::Node getOutput() { result = output }
    }

    /**
     * A call that converts a path to an absolute normalized path.
     */
    class ResolvingPathCall extends PathTransformationNode {
      ResolvingPathCall() {
        this = NodeJSLib::Path::moduleMember("resolve").getACall() and
        input = this.getAnArgument() and
        output = this
        or
        this = NodeJSLib::FS::moduleMember("realpathSync").getACall() and
        input = this.getArgument(0) and
        output = this
        or
        this = NodeJSLib::FS::moduleMember("realpath").getACall() and
        input = this.getArgument(0) and
        output = this.getCallback(1).getParameter(1)
      }

      override predicate step(
        Path::PathLabel inputLabel, DataFlow::Node inputNode, Path::PathLabel outputLabel,
        DataFlow::Node outputNode
      ) {
        input = inputNode and
        output = outputNode and
        outputLabel.getPlatform() = inputLabel.getPlatform() and
        outputLabel.isAbsolute() and
        outputLabel.isNormalized()
      }
    }

    /**
     * A call to the path.relative method.
     */
    class RelativePathCall extends PathTransformationNode {
      RelativePathCall() {
        this = NodeJSLib::Path::moduleMember("relative").getACall() and
        input = this.getAnArgument() and
        output = this
      }

      override predicate step(
        Path::PathLabel inputLabel, DataFlow::Node inputNode, Path::PathLabel outputLabel,
        DataFlow::Node outputNode
      ) {
        input = inputNode and
        output = outputNode and
        outputLabel.getPlatform() = inputLabel.getPlatform() and
        (
          inputLabel.getPlatform() = Path::platformPosix() and
          outputLabel = inputLabel.toRelative().toNormalized()
          or
          // relative, on win32, does not always return a normalized path, eg.,
          // when both arguments are equal, relative will return ''
          // (normalized would be '.').
          // It also does not always return a relative path, eg.,
          // relative('C:\\', 'A:\\') returns 'A:\\'.
          inputLabel.getPlatform() = Path::platformWin32() and
          outputLabel = inputLabel
        )
      }
    }

    /**
     * A call that preserves taint without changing the flow label.
     */
    class PreservingPathCall extends PathTransformationNode {
      PreservingPathCall() {
        this = NodeJSLib::Path::moduleMember(["dirname", "parse", "format"]).getACall() and
        input = this.getAnArgument() and
        output = this
        or
        // non-global replace or replace of something other than /\.\./g, /[/]/g, or /[\.]/g.
        this instanceof StringReplaceCall and
        input = this.getReceiver() and
        output = this and
        not exists(RegExpLiteral literal, RegExpTerm term |
          this.(StringReplaceCall).getRegExp().asExpr() = literal and
          this.(StringReplaceCall).isGlobal() and
          literal.getRoot() = term
        |
          term.getAMatchedString() = "/" or
          term.getAMatchedString() = "." or
          term.getAMatchedString() = ".."
        ) and
        not this instanceof DotDotSlashPrefixRemovingReplace
      }

      override predicate step(
        Path::PathLabel inputLabel, DataFlow::Node inputNode, Path::PathLabel outputLabel,
        DataFlow::Node outputNode
      ) {
        inputNode = input and
        outputNode = output and
        outputLabel = inputLabel
      }
    }

    /** A call to the path.join method. */
    class JoinPathCall extends PathTransformationNode {
      JoinPathCall() {
        this = NodeJSLib::Path::moduleMember("join").getACall() and
        input = this.getAnArgument() and
        output = this
      }

      override predicate step(
        Path::PathLabel inputLabel, DataFlow::Node inputNode, Path::PathLabel outputLabel,
        DataFlow::Node outputNode
      ) {
        outputNode = this and
        inputNode = input and
        (
          inputLabel.getPlatform() = Path::platformPosix() and
          exists(int n | inputNode = this.getArgument(n) |
            // If the initial argument is tainted, just normalize it. It can be relative or absolute.
            n = 0 and outputLabel = inputLabel.toNormalized()
            or
            n > 0 and
            // For later arguments, the flow label depends on whether the first argument is absolute or relative.
            // If in doubt, we assume it is absolute.
            inputLabel.canContainDotDotSep() and
            outputLabel.isNormalized() and
            if Path::isRelative(this.getArgument(0).getStringValue())
            then outputLabel.isRelative()
            else outputLabel.isAbsolute()
          )
          or
          inputLabel.getPlatform() = Path::platformWin32() and
          // on windows, when one input is absolute, the output may also be
          // absolute, no matter the position. This is due to drive paths:
          // path.win32.join('foo\\bar', 'D:\\fnord') => absolute ('D:\\test.txt')
          // path.win32.join('D:\\fnord', 'foo\\bar') => absolute ('D:\\fnord\\foo\\bar')
          if
            inputLabel.isAbsolute() or
            exists(int n | Path::isDrivePath(this.getArgument(n).getStringValue()))
          then outputLabel = inputLabel.toAbsolute().toNormalized()
          else outputLabel = inputLabel
        )
      }
    }

    /**
     * A call to the path.toNamespacedPath method.
     */
    class ToNamespacedPathCall extends PathTransformationNode {
      ToNamespacedPathCall() {
        this = NodeJSLib::Path::moduleMember("toNamespacedPath").getACall() and
        input = this.getAnArgument() and
        output = this
      }

      override predicate step(
        Path::PathLabel inputLabel, DataFlow::Node inputNode, Path::PathLabel outputLabel,
        DataFlow::Node outputNode
      ) {
        input = inputNode and
        output = outputNode and
        (
          inputLabel.getPlatform() = Path::platformWin32() and
          outputLabel = inputLabel.toAbsolute().toNormalized()
          or
          // On posix platforms, this is a no-op.
          inputLabel.getPlatform() = Path::platformPosix() and
          outputLabel = inputLabel
        )
      }
    }

    // /**
    //  * A call that normalizes a path.
    //  */
    class NormalizingPathCall extends PathTransformationNode {
      NormalizingPathCall() {
        this = NodeJSLib::Path::moduleMember("normalize").getACall() and
        input = this.getArgument(0) and
        output = this
      }

      override predicate step(
        Path::PathLabel inputLabel, DataFlow::Node inputNode, Path::PathLabel outputLabel,
        DataFlow::Node outputNode
      ) {
        input = inputNode and
        output = outputNode and
        outputLabel = inputLabel.toNormalized()
      }
    }

    /**
     * A call that removes all instances of "../" in the prefix of the string.
     */
    class DotDotSlashPrefixRemovingReplace extends StringReplaceCall, PathTransformationNode {
      DotDotSlashPrefixRemovingReplace() {
        input = this.getReceiver() and
        output = this and
        exists(RegExpLiteral literal, RegExpTerm term |
          this.getRegExp().asExpr() = literal and
          (term instanceof RegExpStar or term instanceof RegExpPlus) and
          term.getChild(0) = getADotDotSlashMatcher()
        |
          literal.getRoot() = term
          or
          exists(RegExpSequence seq | seq.getNumChild() = 2 and literal.getRoot() = seq |
            seq.getChild(0) instanceof RegExpCaret and
            seq.getChild(1) = term
          )
        )
      }

      override predicate step(
        Path::PathLabel inputLabel, DataFlow::Node inputNode, Path::PathLabel outputLabel,
        DataFlow::Node outputNode
      ) {
        exists(DotDotSlashPrefixRemovingReplace call |
          inputNode = call.getInput() and
          outputNode = call.getOutput()
        |
          (
            inputLabel.getPlatform() = Path::platformPosix() and
            // the 4 possible combinations of normalized + relative for `inputLabel`, and the possible values for `dstlabel` in each case.
            inputLabel.isNonNormalized() and
            inputLabel.isRelative() // raw + relative -> any()
            or
            inputLabel.isNormalized() and inputLabel.isAbsolute() and outputLabel = inputLabel // normalized + absolute -> normalized + absolute
            or
            inputLabel.isNonNormalized() and inputLabel.isAbsolute() and outputLabel.isAbsolute() // raw + absolute -> raw/normalized + absolute
            // normalized + relative -> none()
          )
          or
          // The input path might contain '..\\', and removing '../' will not do anything
          inputLabel.getPlatform() = Path::platformWin32() and inputLabel = outputLabel
        )
      }
    }

    /**
     * Gets a RegExpTerm that matches a variation of "../".
     */
    private RegExpTerm getADotDotSlashMatcher() {
      result.getAMatchedString() = "../"
      or
      exists(RegExpSequence seq | seq = result |
        seq.getChild(0).getConstantValue() = "." and
        seq.getChild(1).getConstantValue() = "." and
        seq.getChild(2).getAMatchedString() = "/"
      )
      or
      exists(RegExpGroup group | result = group | group.getChild(0) = getADotDotSlashMatcher())
    }

    /**
     * A call that removes all "." or ".." from a path, without also removing all forward slashes.
     */
    class DotRemovingReplaceCall extends StringReplaceCall, PathTransformationNode {
      DotRemovingReplaceCall() {
        input = this.getReceiver() and
        output = this and
        this.isGlobal() and
        exists(RegExpLiteral literal, RegExpTerm term |
          this.getRegExp().asExpr() = literal and
          literal.getRoot() = term and
          not term.getAMatchedString() = "/"
        |
          term.getAMatchedString() = "." or
          term.getAMatchedString() = ".."
        )
      }

      override predicate step(
        Path::PathLabel inputLabel, DataFlow::Node inputNode, Path::PathLabel outputLabel,
        DataFlow::Node outputNode
      ) {
        input = inputNode and
        output = outputNode and
        inputLabel.isAbsolute() and
        outputLabel.isAbsolute() and
        outputLabel.isNormalized() and
        inputLabel.getPlatform() = outputLabel.getPlatform()
      }
    }
  }

  import PathTransformations

  /**
   * Provides implementations of guards usd in tainted path analysis.
   */
  module Guards {
    /**
     * A check of form `x.startsWith("../")` or similar.
     *
     * This is relevant for paths that are known to be normalized.
     */
    class StartsWithDotDotSanitizer extends BarrierGuardNode {
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
        exists(Path::PathLabel posixPath | posixPath = label |
          posixPath.isNormalized() and
          posixPath.isRelative()
        )
      }
    }

    /**
     * A check of the form `whitelist.includes(x)` or equivalent, which sanitizes `x` in its "then" branch.
     */
    class MembershipTestBarrierGuard extends BarrierGuardNode {
      MembershipCandidate candidate;

      MembershipTestBarrierGuard() { this = candidate.getTest() }

      override predicate blocks(boolean outcome, Expr e) {
        candidate = e.flow() and
        candidate.getTestPolarity() = outcome
      }
    }

    /**
     * A check of form `x.startsWith(dir)` that sanitizes normalized absolute paths, since it is then
     * known to be in a subdirectory of `dir`.
     */
    class StartsWithDirSanitizer extends BarrierGuardNode {
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
        exists(Path::PathLabel posixPath |
          // can easily be bypassed on windows, because of paths like \\\\LOCALHOST\\c$\\temp\\
          posixPath = label and posixPath.getPlatform() = Path::platformPosix()
        |
          posixPath.isAbsolute() and
          posixPath.isNormalized()
        )
      }
    }

    /**
     * A call to `path.isAbsolute` as a sanitizer for relative paths in true branch,
     * and a sanitizer for absolute paths in the false branch.
     */
    class IsAbsoluteSanitizer extends BarrierGuardNode {
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
        exists(Path::PathLabel pathLabel | pathLabel = label |
          outcome = polarity and pathLabel.isRelative()
          or
          negatable = true and
          outcome = polarity.booleanNot() and
          pathLabel.isAbsolute()
        )
      }
    }

    /**
     * An expression of form `x.includes("..")` or similar.
     */
    class ContainsDotDotSanitizer extends BarrierGuardNode instanceof StringOps::Includes {
      ContainsDotDotSanitizer() { isDotDotSlashPrefix(super.getSubstring()) }

      override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
        e = super.getBaseString().asExpr() and
        outcome = super.getPolarity().booleanNot() and
        label.(Path::PathLabel).canContainDotDotSep() // can still be bypassed by normalized absolute path
      }
    }

    /**
     * An expression of form `x.matches(/\.\./)` or similar.
     */
    class ContainsDotDotRegExpSanitizer extends BarrierGuardNode instanceof StringOps::RegExpTest {
      ContainsDotDotRegExpSanitizer() { super.getRegExp().getAMatchedString() = [".", "..", "../"] }

      override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
        label.(Path::PathLabel).getPlatform() = Path::platformPosix() and
        e = super.getStringOperand().asExpr() and
        outcome = super.getPolarity().booleanNot() and
        label.(Path::PathLabel).canContainDotDotSep() // can still be bypassed by normalized absolute path
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
    class RelativePathStartsWithSanitizer extends BarrierGuardNode {
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

      override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
        // path.relative on windows may return absolute paths, eg.,
        // path.relative("C:\\foo", "C:\\bar") is "C:\\bar".
        label.(Path::PathLabel).getPlatform() = Path::platformPosix() and
        (
          member = "relative" and
          e = this.maybeGetPathSuffix(pathCall.getArgument(1)).asExpr() and
          outcome = startsWith.getPolarity().booleanNot()
          or
          not member = "relative" and
          e = this.maybeGetPathSuffix(pathCall.getArgument(0)).asExpr() and
          outcome = startsWith.getPolarity()
        )
      }

      /**
       * Gets the last argument to the given `path.join()` call,
       * or the node itself if it is not a join call.
       * Is used to get the suffix of the path.
       */
      bindingset[e]
      private DataFlow::Node maybeGetPathSuffix(DataFlow::Node e) {
        exists(DataFlow::CallNode call |
          call = NodeJSLib::Path::moduleMember("join").getACall() and e = call
        |
          result = call.getLastArgument()
        )
        or
        result = e
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
    class IsInsideCheckSanitizer extends BarrierGuardNode {
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
          label.(Path::PathLabel).isNormalized() and
          label.(Path::PathLabel).isAbsolute()
          or
          onlyNormalizedAbsolutePaths = false
        ) and
        e = checked.asExpr() and
        outcome = true
      }
    }
  }

  /**
   * A source of remote user input, considered as a flow source for
   * tainted-path vulnerabilities.
   */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() {
      exists(RemoteFlowSource src |
        this = src and
        not src instanceof ClientSideRemoteFlowSource
      )
    }
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
   * An expression whose value is resolved to a module using the [resolve](http://npmjs.com/package/resolve) library.
   */
  class ResolveModuleSink extends Sink {
    ResolveModuleSink() {
      this = API::moduleImport("resolve").getACall().getArgument(0)
      or
      this = API::moduleImport("resolve").getMember("sync").getACall().getArgument(0)
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
      result.(Path::PathLabel).isNormalized()
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

  /**
   * A path argument given to a `Page` in puppeteer, specifying where a pdf/screenshot should be saved.
   */
  private class PuppeteerPath extends TaintedPath::Sink {
    PuppeteerPath() {
      this =
        Puppeteer::page()
            .getMember(["pdf", "screenshot"])
            .getParameter(0)
            .getMember("path")
            .getARhs()
    }
  }

  /**
   * An argument given to the `prettier` library specifying the location of a config file.
   */
  private class PrettierFileSink extends TaintedPath::Sink {
    PrettierFileSink() {
      this =
        API::moduleImport("prettier")
            .getMember(["resolveConfig", "resolveConfigFile", "getFileInfo"])
            .getACall()
            .getArgument(0)
      or
      this =
        API::moduleImport("prettier")
            .getMember("resolveConfig")
            .getACall()
            .getParameter(1)
            .getMember("config")
            .getARhs()
    }
  }

  /**
   * The `cwd` option for the `read-pkg` library.
   */
  private class ReadPkgCwdSink extends TaintedPath::Sink {
    ReadPkgCwdSink() {
      this =
        API::moduleImport("read-pkg")
            .getMember(["readPackageAsync", "readPackageSync"])
            .getParameter(0)
            .getMember("cwd")
            .getARhs()
    }
  }

  /**
   * The `cwd` option to a shell execution.
   */
  private class ShellCwdSink extends TaintedPath::Sink {
    ShellCwdSink() {
      exists(SystemCommandExecution sys, API::Node opts |
        opts.getARhs() = sys.getOptionsArg() and // assuming that an API::Node exists here.
        this = opts.getMember("cwd").getARhs()
      )
    }
  }

  /**
   * Holds if there is a step `src -> dst` mapping `srclabel` to `dstlabel` relevant for path traversal vulnerabilities.
   */
  predicate isAdditionalTaintedPathFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    isPathStep(src, dst, srclabel, dstlabel)
    or
    isStringOperationPathStep(src, dst, srclabel, dstlabel)
    or
    // Ignore all preliminary sanitization after decoding URI components
    srclabel instanceof Path::PathLabel and
    dstlabel instanceof Path::PathLabel and
    (
      TaintTracking::uriStep(src, dst)
      or
      exists(DataFlow::CallNode decode |
        decode.getCalleeName() = "decodeURIComponent" or decode.getCalleeName() = "decodeURI"
      |
        src = decode.getArgument(0) and
        dst = decode
      )
    )
    or
    TaintTracking::promiseStep(src, dst) and srclabel = dstlabel
    or
    TaintTracking::persistentStorageStep(src, dst) and srclabel = dstlabel
    or
    exists(DataFlow::PropRead read | read = dst |
      src = read.getBase() and
      read.getPropertyName() != "length" and
      srclabel = dstlabel and
      not AccessPath::DominatingPaths::hasDominatingWrite(read)
    )
    or
    // string method calls of interest
    exists(DataFlow::MethodCallNode mcn, string name |
      srclabel = dstlabel and dst = mcn and mcn.calls(src, name)
    |
      name = StringOps::substringMethodName() and
      // to avoid very dynamic transformations, require at least one fixed index
      exists(mcn.getAnArgument().asExpr().getIntValue())
      or
      exists(string argumentlessMethodName |
        argumentlessMethodName =
          [
            "toLocaleLowerCase", "toLocaleUpperCase", "toLowerCase", "toUpperCase", "trim",
            "trimLeft", "trimRight"
          ]
      |
        name = argumentlessMethodName
      )
    )
    or
    // A `str.split()` call can either split into path elements (`str.split("/")`) or split by some other string.
    exists(StringSplitCall mcn | dst = mcn and mcn.getBaseString() = src |
      if mcn.getSeparator() = "/"
      then
        srclabel.(Path::PathLabel).canContainDotDotSep() and
        dstlabel instanceof Path::SplitPath
      else srclabel = dstlabel
    )
    or
    // array method calls of interest
    exists(DataFlow::MethodCallNode mcn, string name | dst = mcn and mcn.calls(src, name) |
      (
        name = "pop" or
        name = "shift"
      ) and
      srclabel instanceof Path::SplitPath and
      dstlabel.(Path::PathLabel).canContainDotDotSep()
      or
      (
        name = "slice" or
        name = "splice" or
        name = "concat"
      ) and
      dstlabel instanceof Path::SplitPath and
      srclabel instanceof Path::SplitPath
      or
      name = "join" and
      mcn.getArgument(0).mayHaveStringValue("/") and
      srclabel instanceof Path::SplitPath and
      dstlabel.(Path::PathLabel).canContainDotDotSep()
    )
    or
    // prefix.concat(path)
    exists(DataFlow::MethodCallNode mcn |
      mcn.getMethodName() = "concat" and mcn.getAnArgument() = src
    |
      dst = mcn and
      dstlabel instanceof Path::SplitPath and
      srclabel instanceof Path::SplitPath
    )
    or
    // reading unknown property of split path
    exists(DataFlow::PropRead read | read = dst |
      src = read.getBase() and
      not read.getPropertyName() = "length" and
      not exists(read.getPropertyNameExpr().getIntValue()) and
      // split[split.length - 1]
      not exists(BinaryExpr binop |
        read.getPropertyNameExpr() = binop and
        binop.getAnOperand().getIntValue() = 1 and
        binop.getAnOperand().(PropAccess).getPropertyName() = "length"
      ) and
      srclabel instanceof Path::SplitPath and
      dstlabel.(Path::PathLabel).canContainDotDotSep()
    )
    or
    exists(API::CallNode call | call = API::moduleImport("slash").getACall() |
      src = call.getArgument(0) and
      dst = call and
      srclabel = dstlabel
    )
  }

  /**
   * Holds if we should include a step from `src -> dst` with labels `srclabel -> dstlabel`, and the
   * standard taint step `src -> dst` should be suppressed.
   */
  predicate isPathStep(
    DataFlow::Node src, DataFlow::Node dst, Path::PathLabel srclabel, Path::PathLabel dstlabel
  ) {
    exists(PathTransformationNode ppn | ppn.getOutput() = dst and ppn.getInput() = src |
      ppn.step(srclabel, src, dstlabel, dst)
    )
  }

  /**
   * Holds if we should include a step from `src -> dst` with labels `srclabel -> dstlabel`, and the
   * standard taint step `src -> dst` should be suppressed.
   */
  private predicate isStringOperationPathStep(
    DataFlow::Node src, DataFlow::Node dst, Path::PathLabel srclabel, Path::PathLabel dstlabel
  ) {
    // String concatenation - behaves like path.join() except without normalization
    exists(DataFlow::Node operator, int n | StringConcatenation::taintStep(src, dst, operator, n) |
      // use ordinary taint flow for the first operand
      n = 0 and
      srclabel = dstlabel
      or
      n > 0 and
      srclabel.canContainDotDotSep() and
      dstlabel.isNonNormalized() and // The ../ is no longer at the beginning of the string.
      (
        if Path::isRelative(StringConcatenation::getOperand(operator, 0).getStringValue())
        then dstlabel.isRelative()
        else dstlabel.isAbsolute()
      )
    )
  }
}
