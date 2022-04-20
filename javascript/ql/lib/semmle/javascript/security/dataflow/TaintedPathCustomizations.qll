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

  /**
   * A barrier guard for tainted-path vulnerabilities.
   */
  abstract class BarrierGuardNode extends DataFlow::LabeledBarrierGuardNode { }

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
      exists(RegExpLiteral literal, RegExpTerm term |
        this.getRegExp().asExpr() = literal and
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
      exists(Label::PosixPath posixPath | posixPath = label |
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
  class ContainsDotDotSanitizer extends BarrierGuardNode instanceof StringOps::Includes {
    ContainsDotDotSanitizer() { isDotDotSlashPrefix(super.getSubstring()) }

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      e = super.getBaseString().asExpr() and
      outcome = super.getPolarity().booleanNot() and
      label.(Label::PosixPath).canContainDotDotSlash() // can still be bypassed by normalized absolute path
    }
  }

  /**
   * An expression of form `x.matches(/\.\./)` or similar.
   */
  class ContainsDotDotRegExpSanitizer extends BarrierGuardNode instanceof StringOps::RegExpTest {
    ContainsDotDotRegExpSanitizer() { super.getRegExp().getAMatchedString() = [".", "..", "../"] }

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel label) {
      e = super.getStringOperand().asExpr() and
      outcome = super.getPolarity().booleanNot() and
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

    override predicate blocks(boolean outcome, Expr e) {
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
    isPosixPathStep(src, dst, srclabel, dstlabel)
    or
    // Ignore all preliminary sanitization after decoding URI components
    srclabel instanceof Label::PosixPath and
    dstlabel instanceof Label::PosixPath and
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
        srclabel.(Label::PosixPath).canContainDotDotSlash() and
        dstlabel instanceof Label::SplitPath
      else srclabel = dstlabel
    )
    or
    // array method calls of interest
    exists(DataFlow::MethodCallNode mcn, string name | dst = mcn and mcn.calls(src, name) |
      (
        name = "pop" or
        name = "shift"
      ) and
      srclabel instanceof Label::SplitPath and
      dstlabel.(Label::PosixPath).canContainDotDotSlash()
      or
      (
        name = "slice" or
        name = "splice" or
        name = "concat"
      ) and
      dstlabel instanceof Label::SplitPath and
      srclabel instanceof Label::SplitPath
      or
      name = "join" and
      mcn.getArgument(0).mayHaveStringValue("/") and
      srclabel instanceof Label::SplitPath and
      dstlabel.(Label::PosixPath).canContainDotDotSlash()
    )
    or
    // prefix.concat(path)
    exists(DataFlow::MethodCallNode mcn |
      mcn.getMethodName() = "concat" and mcn.getAnArgument() = src
    |
      dst = mcn and
      dstlabel instanceof Label::SplitPath and
      srclabel instanceof Label::SplitPath
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
      srclabel instanceof Label::SplitPath and
      dstlabel.(Label::PosixPath).canContainDotDotSlash()
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
  private predicate isPosixPathStep(
    DataFlow::Node src, DataFlow::Node dst, Label::PosixPath srclabel, Label::PosixPath dstlabel
  ) {
    // path.normalize() and similar
    exists(NormalizingPathCall call |
      src = call.getInput() and
      dst = call.getOutput() and
      dstlabel = srclabel.toNormalized()
    )
    or
    // path.resolve() and similar
    exists(ResolvingPathCall call |
      src = call.getInput() and
      dst = call.getOutput() and
      dstlabel.isAbsolute() and
      dstlabel.isNormalized()
    )
    or
    // path.relative() and similar
    exists(NormalizingRelativePathCall call |
      src = call.getInput() and
      dst = call.getOutput() and
      dstlabel.isRelative() and
      dstlabel.isNormalized()
    )
    or
    // path.dirname() and similar
    exists(PreservingPathCall call |
      src = call.getInput() and
      dst = call.getOutput() and
      srclabel = dstlabel
    )
    or
    // foo.replace(/\./, "") and similar
    exists(DotRemovingReplaceCall call |
      src = call.getInput() and
      dst = call.getOutput() and
      srclabel.isAbsolute() and
      dstlabel.isAbsolute() and
      dstlabel.isNormalized()
    )
    or
    // foo.replace(/(\.\.\/)*/, "") and similar
    exists(DotDotSlashPrefixRemovingReplace call |
      src = call.getInput() and
      dst = call.getOutput()
    |
      // the 4 possible combinations of normalized + relative for `srclabel`, and the possible values for `dstlabel` in each case.
      srclabel.isNonNormalized() and srclabel.isRelative() // raw + relative -> any()
      or
      srclabel.isNormalized() and srclabel.isAbsolute() and srclabel = dstlabel // normalized + absolute -> normalized + absolute
      or
      srclabel.isNonNormalized() and srclabel.isAbsolute() and dstlabel.isAbsolute() // raw + absolute -> raw/normalized + absolute
      // normalized + relative -> none()
    )
    or
    // path.join()
    exists(DataFlow::CallNode join, int n |
      join = NodeJSLib::Path::moduleMember("join").getACall()
    |
      src = join.getArgument(n) and
      dst = join and
      (
        // If the initial argument is tainted, just normalize it. It can be relative or absolute.
        n = 0 and
        dstlabel = srclabel.toNormalized()
        or
        // For later arguments, the flow label depends on whether the first argument is absolute or relative.
        // If in doubt, we assume it is absolute.
        n > 0 and
        srclabel.canContainDotDotSlash() and
        dstlabel.isNormalized() and
        if isRelative(join.getArgument(0).getStringValue())
        then dstlabel.isRelative()
        else dstlabel.isAbsolute()
      )
    )
    or
    // String concatenation - behaves like path.join() except without normalization
    exists(DataFlow::Node operator, int n | StringConcatenation::taintStep(src, dst, operator, n) |
      // use ordinary taint flow for the first operand
      n = 0 and
      srclabel = dstlabel
      or
      n > 0 and
      srclabel.canContainDotDotSlash() and
      dstlabel.isNonNormalized() and // The ../ is no longer at the beginning of the string.
      (
        if isRelative(StringConcatenation::getOperand(operator, 0).getStringValue())
        then dstlabel.isRelative()
        else dstlabel.isAbsolute()
      )
    )
  }
}
