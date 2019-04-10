/**
 * Provides a taint tracking configuration for reasoning about tainted-path
 * vulnerabilities.
 */

import javascript

module TaintedPath {
  /**
   * A data flow source for tainted-path vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for tainted-path vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

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
  }

  /**
   * A taint-tracking configuration for reasoning about tainted-path vulnerabilities.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() { this = "TaintedPath" }

    override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
      source instanceof Source and
      label instanceof Label::PosixPath
    }

    override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
      sink instanceof Sink and
      label instanceof Label::PosixPath
    }

    override predicate isBarrier(DataFlow::Node node) {
      super.isBarrier(node) or
      node instanceof Sanitizer
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
      guard instanceof StartsWithDotDotSanitizer or
      guard instanceof StartsWithDirSanitizer or
      guard instanceof IsAbsoluteSanitizer or
      guard instanceof ContainsDotDotSanitizer
    }

    override predicate isAdditionalFlowStep(
      DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
      DataFlow::FlowLabel dstlabel
    ) {
      isTaintedPathStep(src, dst, srclabel, dstlabel)
      or
      // Introduce the specialized flow labels when approaching a specialized sanitizer guard.
      exists(TaintTracking::LabeledSanitizerGuardNode guard, Expr e |
        guard.sanitizes(_, e, any(Label::PosixPath label)) and
        src.(DataFlow::SourceNode).flowsToExpr(e) and
        dst = src and
        srclabel instanceof DataFlow::StandardFlowLabel and
        dstlabel instanceof Label::PosixPath
      )
      or
      // Ignore all preliminary sanitization after decoding URI components
      srclabel instanceof Label::PosixPath and
      dstlabel instanceof Label::PosixPath and
      (
        any(UriLibraryStep step).step(src, dst)
        or
        exists(DataFlow::CallNode decode |
          decode.getCalleeName() = "decodeURIComponent" or decode.getCalleeName() = "decodeURI"
        |
          src = decode.getArgument(0) and
          dst = decode
        )
      )
      or
      promiseTaintStep(src, dst) and srclabel = dstlabel
      or
      any(TaintTracking::PersistentStorageTaintStep st).step(src, dst) and srclabel = dstlabel
      or
      exists(DataFlow::PropRead read | read = dst |
        src = read.getBase() and
        read.getPropertyName() != "length" and
        srclabel = dstlabel
      )
    }

    /**
     * Holds if we should include a step from `src -> dst` with labels `srclabel -> dstlabel`, and the
     * standard taint step `src -> dst` should be suppresesd.
     */
    predicate isTaintedPathStep(
      DataFlow::Node src, DataFlow::Node dst, Label::PosixPath srclabel,
      Label::PosixPath dstlabel
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
      // path.join()
      exists(DataFlow::CallNode join, int n |
        join = DataFlow::moduleMember("path", "join").getACall()
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
          dstlabel.(Label::PosixPath).isNormalized() and
          if isRelative(join.getArgument(0).getStringValue())
          then dstlabel.(Label::PosixPath).isRelative()
          else dstlabel.(Label::PosixPath).isAbsolute()
        )
      )
      or
      // String concatenation - behaves like path.join() except without normalization
      exists(DataFlow::Node operator, int n |
        StringConcatenation::taintStep(src, dst, operator, n)
      |
        // use ordinary taint flow for the first operand
        n = 0 and
        srclabel = dstlabel
        or
        n > 0 and
        srclabel.canContainDotDotSlash() and
        dstlabel.(Label::PosixPath).isNonNormalized() and // The ../ is no longer at the beginning of the string.
        (
          if isRelative(StringConcatenation::getOperand(operator, 0).getStringValue())
          then dstlabel.(Label::PosixPath).isRelative()
          else dstlabel.(Label::PosixPath).isAbsolute()
        )
      )
    }
  }

  /**
   * Holds if `s` is a relative path.
   */
  bindingset[s]
  private predicate isRelative(string s) { not s.charAt(0) = "/" }

  /**
   * A call that normalizes a path.
   */
  class NormalizingPathCall extends DataFlow::CallNode {
    DataFlow::Node input;

    DataFlow::Node output;

    NormalizingPathCall() {
      this = DataFlow::moduleMember("path", "normalize").getACall() and
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
      this = DataFlow::moduleMember("path", "resolve").getACall() and
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
      this = DataFlow::moduleMember("path", "relative").getACall() and
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
        this = DataFlow::moduleMember("path", name).getACall() and
        input = getAnArgument() and
        output = this
      )
      or
      // non-global replace or replace of something other than /\.\./g
      this.getCalleeName() = "replace" and
      input = getReceiver() and
      output = this and
      not exists(RegExpLiteral literal, RegExpSequence seq |
        getArgument(0).getALocalSource().asExpr() = literal and
        literal.isGlobal() and
        literal.getRoot() = seq and
        seq.getChild(0).(RegExpConstant).getValue() = "." and
        seq.getChild(1).(RegExpConstant).getValue() = "." and
        seq.getNumChild() = 2
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
    node.asExpr().getStringValue() + any(string s) = "../"
    or
    // ".." + path.sep
    exists(StringOps::Concatenation conc | node = conc |
      conc.getOperand(0).asExpr().getStringValue() = ".." and
      conc.getOperand(1).getALocalSource() = DataFlow::moduleMember("path", "sep") and
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
      not startsWith.getSubstring().asExpr().getStringValue() = "/"
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
        call = DataFlow::moduleMember("path", "isAbsolute").getACall() and
        operand = call.getArgument(0) and
        polarity = true and
        negatable = true
      )
      or
      exists(StringOps::StartsWith startsWith, string substring | this = startsWith |
        startsWith.getSubstring().asExpr().getStringValue() = "/" + substring and
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
    FsPathSink() {
      exists(FileSystemAccess fs |
        this = fs.getAPathArgument() and
        not exists(fs.getRootPathArgument())
        or
        this = fs.getRootPathArgument()
      ) and
      not this = any(ResolvingPathCall call).getInput()
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
}
