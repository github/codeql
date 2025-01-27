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
    /** Gets a flow state denoting the type of value for which this is a source. */
    FlowState getAFlowState() { result instanceof FlowState::PosixPath }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getAFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A data flow sink for tainted-path vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets a flow state denoting the type of value for which this is a sink. */
    FlowState getAFlowState() { result instanceof FlowState::PosixPath }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getAFlowLabel() { result = this.getAFlowState().toFlowLabel() }
  }

  /**
   * A sanitizer for tainted-path vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A barrier guard for tainted-path vulnerabilities.
   */
  abstract class BarrierGuard extends DataFlow::Node {
    /**
     * Holds if this node acts as a barrier for data flow, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e) { none() }

    /**
     * Holds if this node acts as a barrier for `state`, blocking further flow from `e` if `this` evaluates to `outcome`.
     */
    predicate blocksExpr(boolean outcome, Expr e, FlowState state) { none() }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e) { this.blocksExpr(outcome, e) }

    /** DEPRECATED. Use `blocksExpr` instead. */
    deprecated predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      this.blocksExpr(outcome, e, FlowState::fromFlowLabel(label))
    }
  }

  /** A subclass of `BarrierGuard` that is used for backward compatibility with the old data flow library. */
  deprecated final private class BarrierGuardLegacy extends TaintTracking::SanitizerGuardNode instanceof BarrierGuard
  {
    override predicate sanitizes(boolean outcome, Expr e) {
      BarrierGuard.super.sanitizes(outcome, e)
    }

    override predicate sanitizes(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      BarrierGuard.super.sanitizes(outcome, e, label)
    }
  }

  deprecated class BarrierGuardNode = BarrierGuard;

  private newtype TFlowState =
    TPosixPath(FlowState::Normalization normalization, FlowState::Relativeness relativeness) or
    TSplitPath()

  private class FlowStateImpl extends TFlowState {
    /** Gets a string representation of this flow state. */
    abstract string toString();

    /** DEPRECATED. Gets the corresponding flow label, for backwards compatibility. */
    abstract deprecated DataFlow::FlowLabel toFlowLabel();
  }

  /** The flow state to associate with a tainted value. See also `FlowState::PosixPath`. */
  final class FlowState = FlowStateImpl;

  /** Module containing details of individual flow states. */
  module FlowState {
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
     * A flow state representing a Posix path.
     *
     * There are currently four flow states, representing the different combinations of
     * normalization and absoluteness.
     */
    class PosixPath extends FlowStateImpl, TPosixPath {
      Normalization normalization;
      Relativeness relativeness;

      PosixPath() { this = TPosixPath(normalization, relativeness) }

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
        not (this.isNormalized() and this.isAbsolute())
      }

      override string toString() { result = normalization + "-" + relativeness + "-posix-path" }

      deprecated override Label::PosixPath toFlowLabel() {
        result.getNormalization() = normalization and result.getRelativeness() = relativeness
      }
    }

    /**
     * A flow label representing an array of path elements that may include "..".
     */
    class SplitPath extends FlowStateImpl, TSplitPath {
      override string toString() { result = "splitPath" }

      deprecated override Label::SplitPath toFlowLabel() { any() }
    }

    /** Convert the given flow label to the corresponding flow state. */
    deprecated FlowState fromFlowLabel(DataFlow::FlowLabel label) { result.toFlowLabel() = label }
  }

  deprecated module Label {
    class Normalization = FlowState::Normalization;

    class Relativeness = FlowState::Relativeness;

    /**
     * A flow label representing a Posix path.
     *
     * There are currently four flow labels, representing the different combinations of
     * normalization and absoluteness.
     */
    abstract class PosixPath extends DataFlow::FlowLabel {
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
        not (this.isNormalized() and this.isAbsolute())
      }
    }

    /**
     * A flow label representing an array of path elements that may include "..".
     */
    abstract class SplitPath extends DataFlow::FlowLabel {
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
      input = this.getArgument(0) and
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
      input = this.getAnArgument() and
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
      this =
        NodeJSLib::Path::moduleMember(["dirname", "toNamespacedPath", "parse", "format"]).getACall() and
      input = this.getAnArgument() and
      output = this
      or
      // non-global replace or replace of something other than /\.\./g, /[/]/g, or /[\.]/g.
      this instanceof StringReplaceCall and
      input = this.getReceiver() and
      output = this and
      not exists(DataFlow::RegExpCreationNode regexp, RegExpTerm term |
        this.(StringReplaceCall).getRegExp() = regexp and
        this.(StringReplaceCall).maybeGlobal() and
        regexp.getRoot() = term
      |
        term.getAMatchedString() = "/" or
        term.getAMatchedString() = "." or
        term.getAMatchedString() = ".."
      ) and
      not this instanceof DotDotSlashPrefixRemovingReplace
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
   * A call that removes all instances of "../" in the prefix of the string.
   */
  class DotDotSlashPrefixRemovingReplace extends StringReplaceCall {
    DataFlow::Node input;
    DataFlow::Node output;

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

    /**
     * Gets the input path to be sanitized.
     */
    DataFlow::Node getInput() { result = input }

    /**
     * Gets the path where prefix "../" has been removed.
     */
    DataFlow::Node getOutput() { result = output }
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
  class DotRemovingReplaceCall extends StringReplaceCall {
    DataFlow::Node input;
    DataFlow::Node output;

    DotRemovingReplaceCall() {
      input = this.getReceiver() and
      output = this and
      this.isGlobal() and
      exists(DataFlow::RegExpCreationNode regexp, RegExpTerm term |
        this.getRegExp() = regexp and
        regexp.getRoot() = term and
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
  class StartsWithDotDotSanitizer extends BarrierGuard instanceof StringOps::StartsWith {
    StartsWithDotDotSanitizer() { isDotDotSlashPrefix(super.getSubstring()) }

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      // Sanitize in the false case for:
      //   .startsWith(".")
      //   .startsWith("..")
      //   .startsWith("../")
      outcome = super.getPolarity().booleanNot() and
      e = super.getBaseString().asExpr() and
      exists(FlowState::PosixPath posixPath | posixPath = state |
        posixPath.isNormalized() and
        posixPath.isRelative()
      )
    }
  }

  /**
   * A check of the form `whitelist.includes(x)` or equivalent, which sanitizes `x` in its "then" branch.
   */
  class MembershipTestBarrierGuard extends BarrierGuard {
    MembershipCandidate candidate;

    MembershipTestBarrierGuard() { this = candidate.getTest() }

    override predicate blocksExpr(boolean outcome, Expr e) {
      candidate = e.flow() and
      candidate.getTestPolarity() = outcome
    }
  }

  /**
   * A check of form `x.startsWith(dir)` that sanitizes normalized absolute paths, since it is then
   * known to be in a subdirectory of `dir`.
   */
  class StartsWithDirSanitizer extends BarrierGuard {
    StringOps::StartsWith startsWith;

    StartsWithDirSanitizer() {
      this = startsWith and
      not isDotDotSlashPrefix(startsWith.getSubstring()) and
      // do not confuse this with a simple isAbsolute() check
      not startsWith.getSubstring().getStringValue() = "/"
    }

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      outcome = startsWith.getPolarity() and
      e = startsWith.getBaseString().asExpr() and
      exists(FlowState::PosixPath posixPath | posixPath = state |
        posixPath.isAbsolute() and
        posixPath.isNormalized()
      )
    }
  }

  /**
   * A call to `path.isAbsolute` as a sanitizer for relative paths in true branch,
   * and a sanitizer for absolute paths in the false branch.
   */
  class IsAbsoluteSanitizer extends BarrierGuard {
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

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      e = operand.asExpr() and
      exists(FlowState::PosixPath posixPath | posixPath = state |
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
  class ContainsDotDotSanitizer extends BarrierGuard instanceof StringOps::Includes {
    ContainsDotDotSanitizer() { isDotDotSlashPrefix(super.getSubstring()) }

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      e = super.getBaseString().asExpr() and
      outcome = super.getPolarity().booleanNot() and
      state.(FlowState::PosixPath).canContainDotDotSlash() // can still be bypassed by normalized absolute path
    }
  }

  /**
   * An expression of form `x.matches(/\.\./)` or similar.
   */
  class ContainsDotDotRegExpSanitizer extends BarrierGuard instanceof StringOps::RegExpTest {
    ContainsDotDotRegExpSanitizer() { super.getRegExp().getAMatchedString() = [".", "..", "../"] }

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      e = super.getStringOperand().asExpr() and
      outcome = super.getPolarity().booleanNot() and
      state.(FlowState::PosixPath).canContainDotDotSlash() // can still be bypassed by normalized absolute path
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
  class RelativePathStartsWithSanitizer extends BarrierGuard {
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

    override predicate blocksExpr(boolean outcome, Expr e) {
      member = "relative" and
      e = this.maybeGetPathSuffix(pathCall.getArgument(1)).asExpr() and
      outcome = startsWith.getPolarity().booleanNot()
      or
      not member = "relative" and
      e = this.maybeGetPathSuffix(pathCall.getArgument(0)).asExpr() and
      outcome = startsWith.getPolarity()
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
  class IsInsideCheckSanitizer extends BarrierGuard {
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

    override predicate blocksExpr(boolean outcome, Expr e, FlowState state) {
      (
        onlyNormalizedAbsolutePaths = true and
        state.(FlowState::PosixPath).isNormalized() and
        state.(FlowState::PosixPath).isAbsolute()
        or
        onlyNormalizedAbsolutePaths = false
      ) and
      e = checked.asExpr() and
      outcome = true
    }
  }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` from Concepts instead!
   */
  deprecated class RemoteFlowSourceAsSource = ActiveThreatModelSourceAsSource;

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source instanceof ActiveThreatModelSource {
    ActiveThreatModelSourceAsSource() { not this.isClientSideSource() }
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

    override FlowState getAFlowState() {
      // The protection is ineffective if the ../ segments have already
      // cancelled out against the intended root dir using path.join or similar.
      // Only flag normalized paths, as this corresponds to the output
      // of a normalizing call that had a malicious input.
      result.(FlowState::PosixPath).isNormalized()
    }
  }

  /**
   * A path argument to the Express `res.render` method.
   */
  class ExpressRenderSink extends Sink {
    ExpressRenderSink() {
      exists(DataFlow::MethodCallNode mce |
        Express::isResponse(mce.getReceiver()) and
        mce.getMethodName() = "render" and
        this = mce.getArgument(0)
      )
    }
  }

  /**
   * DEPRECATED. This is no longer seen as a path-injection sink. It is tentatively handled
   * by the client-side URL redirection query for now.
   */
  deprecated class AngularJSTemplateUrlSink extends DataFlow::ValueNode instanceof Sink {
    AngularJSTemplateUrlSink() { none() }
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
            .asSink()
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
            .asSink()
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
            .asSink()
    }
  }

  /**
   * The `cwd` option to a shell execution.
   */
  private class ShellCwdSink extends TaintedPath::Sink {
    ShellCwdSink() {
      exists(SystemCommandExecution sys, API::Node opts |
        opts.asSink() = sys.getOptionsArg() and // assuming that an API::Node exists here.
        this = opts.getMember("cwd").asSink()
      )
    }
  }

  /**
   * DEPRECATED. Use `isAdditionalFlowStep` instead.
   */
  deprecated predicate isAdditionalTaintedPathFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    isAdditionalFlowStep(src, FlowState::fromFlowLabel(srclabel), dst,
      FlowState::fromFlowLabel(dstlabel))
  }

  /**
   * Holds if there is a step `node1 -> node2` mapping `state1` to `state2` relevant for path traversal vulnerabilities.
   */
  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    isPosixPathStep(node1, state1, node2, state2)
    or
    // Ignore all preliminary sanitization after decoding URI components
    state1 instanceof FlowState::PosixPath and
    state2 instanceof FlowState::PosixPath and
    (
      TaintTracking::uriStep(node1, node2)
      or
      exists(DataFlow::CallNode decode |
        decode.getCalleeName() = "decodeURIComponent" or decode.getCalleeName() = "decodeURI"
      |
        node1 = decode.getArgument(0) and
        node2 = decode
      )
    )
    or
    TaintTracking::persistentStorageStep(node1, node2) and state1 = state2
    or
    exists(DataFlow::PropRead read | read = node2 |
      node1 = read.getBase() and
      read.getPropertyName() != "length" and
      state1 = state2 and
      not AccessPath::DominatingPaths::hasDominatingWrite(read)
    )
    or
    // string method calls of interest
    exists(DataFlow::MethodCallNode mcn, string name |
      state1 = state2 and node2 = mcn and mcn.calls(node1, name)
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
    exists(StringSplitCall mcn | node2 = mcn and mcn.getBaseString() = node1 |
      if mcn.getSeparator() = "/"
      then
        state1.(FlowState::PosixPath).canContainDotDotSlash() and
        state2 instanceof FlowState::SplitPath
      else state1 = state2
    )
    or
    // array method calls of interest
    exists(DataFlow::MethodCallNode mcn, string name | node2 = mcn and mcn.calls(node1, name) |
      (
        name = "pop" or
        name = "shift"
      ) and
      state1 instanceof FlowState::SplitPath and
      state2.(FlowState::PosixPath).canContainDotDotSlash()
      or
      (
        name = "slice" or
        name = "splice" or
        name = "concat"
      ) and
      state2 instanceof FlowState::SplitPath and
      state1 instanceof FlowState::SplitPath
      or
      name = "join" and
      mcn.getArgument(0).mayHaveStringValue("/") and
      state1 instanceof FlowState::SplitPath and
      state2.(FlowState::PosixPath).canContainDotDotSlash()
    )
    or
    // prefix.concat(path)
    exists(DataFlow::MethodCallNode mcn |
      mcn.getMethodName() = "concat" and mcn.getAnArgument() = node1
    |
      node2 = mcn and
      state2 instanceof FlowState::SplitPath and
      state1 instanceof FlowState::SplitPath
    )
    or
    // reading unknown property of split path
    exists(DataFlow::PropRead read | read = node2 |
      node1 = read.getBase() and
      not read.getPropertyName() = "length" and
      not exists(read.getPropertyNameExpr().getIntValue()) and
      // split[split.length - 1]
      not exists(BinaryExpr binop |
        read.getPropertyNameExpr() = binop and
        binop.getAnOperand().getIntValue() = 1 and
        binop.getAnOperand().(PropAccess).getPropertyName() = "length"
      ) and
      state1 instanceof FlowState::SplitPath and
      state2.(FlowState::PosixPath).canContainDotDotSlash()
    )
    or
    exists(API::CallNode call | call = API::moduleImport("slash").getACall() |
      node1 = call.getArgument(0) and
      node2 = call and
      state1 = state2
    )
    or
    exists(HtmlSanitizerCall call |
      node1 = call.getInput() and
      node2 = call and
      state1 = state2
    )
    or
    exists(DataFlow::CallNode join |
      // path.join() with spread argument
      join = NodeJSLib::Path::moduleMember("join").getACall() and
      node1 = join.getASpreadArgument() and
      node2 = join and
      (
        state1.(FlowState::PosixPath).canContainDotDotSlash()
        or
        state1 instanceof FlowState::SplitPath
      ) and
      state2.(FlowState::PosixPath).isNormalized() and
      if isRelative(join.getArgument(0).getStringValue())
      then state2.(FlowState::PosixPath).isRelative()
      else state2.(FlowState::PosixPath).isAbsolute()
    )
  }

  /**
   * Holds if we should include a step from `node1 -> node2` with labels `state1 -> state2`, and the
   * standard taint step `node1 -> node2` should be suppressed.
   */
  private predicate isPosixPathStep(
    DataFlow::Node node1, FlowState::PosixPath state1, DataFlow::Node node2,
    FlowState::PosixPath state2
  ) {
    // path.normalize() and similar
    exists(NormalizingPathCall call |
      node1 = call.getInput() and
      node2 = call.getOutput() and
      state2 = state1.toNormalized()
    )
    or
    // path.resolve() and similar
    exists(ResolvingPathCall call |
      node1 = call.getInput() and
      node2 = call.getOutput() and
      state2.isAbsolute() and
      state2.isNormalized()
    )
    or
    // path.relative() and similar
    exists(NormalizingRelativePathCall call |
      node1 = call.getInput() and
      node2 = call.getOutput() and
      state2.isRelative() and
      state2.isNormalized()
    )
    or
    // path.dirname() and similar
    exists(PreservingPathCall call |
      node1 = call.getInput() and
      node2 = call.getOutput() and
      state1 = state2
    )
    or
    // foo.replace(/\./, "") and similar
    exists(DotRemovingReplaceCall call |
      node1 = call.getInput() and
      node2 = call.getOutput() and
      state1.isAbsolute() and
      state2.isAbsolute() and
      state2.isNormalized()
    )
    or
    // foo.replace(/(\.\.\/)*/, "") and similar
    exists(DotDotSlashPrefixRemovingReplace call |
      node1 = call.getInput() and
      node2 = call.getOutput()
    |
      // the 4 possible combinations of normalized + relative for `state1`, and the possible values for `state2` in each case.
      state1.isNonNormalized() and state1.isRelative() // raw + relative -> any()
      or
      state1.isNormalized() and state1.isAbsolute() and state1 = state2 // normalized + absolute -> normalized + absolute
      or
      state1.isNonNormalized() and state1.isAbsolute() and state2.isAbsolute() // raw + absolute -> raw/normalized + absolute
      // normalized + relative -> none()
    )
    or
    // path.join()
    exists(DataFlow::CallNode join, int n |
      join = NodeJSLib::Path::moduleMember("join").getACall()
    |
      node1 = join.getArgument(n) and
      node2 = join and
      (
        // If the initial argument is tainted, just normalize it. It can be relative or absolute.
        n = 0 and
        state2 = state1.toNormalized()
        or
        // For later arguments, the flow label depends on whether the first argument is absolute or relative.
        // If in doubt, we assume it is absolute.
        n > 0 and
        state1.canContainDotDotSlash() and
        state2.isNormalized() and
        if isRelative(join.getArgument(0).getStringValue())
        then state2.isRelative()
        else state2.isAbsolute()
      )
    )
    or
    // String concatenation - behaves like path.join() except without normalization
    exists(DataFlow::Node operator, int n |
      StringConcatenation::taintStep(node1, node2, operator, n)
    |
      // use ordinary taint flow for the first operand
      n = 0 and
      state1 = state2
      or
      n > 0 and
      state1.canContainDotDotSlash() and
      state2.isNonNormalized() and // The ../ is no longer at the beginning of the string.
      (
        if isRelative(StringConcatenation::getOperand(operator, 0).getStringValue())
        then state2.isRelative()
        else state2.isAbsolute()
      )
    )
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("path-injection").asSink() }
  }
}
