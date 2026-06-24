/**
 * Provides a taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 */

private import go
import semmle.go.Concepts
import semmle.go.dataflow.DataFlow
import semmle.go.dataflow.TaintTracking
import UnicodeBypassValidationCustomizations::UnicodeBypassValidation

/** A state signifying that a logical validation has not been performed. */
class PreValidation extends DataFlow::FlowState {
  PreValidation() { this = "PreValidation" }
}

/** A state signifying that a logical validation has been performed. */
class PostValidation extends DataFlow::FlowState {
  PostValidation() { this = "PostValidation" }
}

private predicate indexCheck(DataFlow::Node g, Expr e, boolean outcome) {
  exists(DataFlow::CallNode cn, DataFlow::EqualityTestNode etn |
    g = etn and
    DataFlow::localFlow(cn.getResult(), etn.getAnOperand()) and
    cn.getTarget()
        .hasQualifiedName("strings",
          [
            "Index", "IndexAny", "IndexByte", "IndexFunc", "IndexRune", "LastIndex", "LastIndexAny",
            "LastIndexByte", "LastIndexFunc",
          ]) and
    cn.getArgument(0).asExpr() = e and
    etn.getAnOperand().getIntValue() = -1 and
    outcome = etn.getPolarity()
  )
}

private predicate countCheck(DataFlow::Node g, Expr e, boolean outcome) {
  exists(
    DataFlow::RelationalComparisonNode cmp, DataFlow::CallNode cn, DataFlow::Node zero,
    DataFlow::Node r
  |
    g = cmp and
    DataFlow::localFlow(cn.getResult(), r) and
    cn.getTarget().hasQualifiedName("strings", "Count") and
    cn.getArgument(1).asExpr() = e and
    zero.getNumericValue() = 0 and
    cmp.leq(outcome, r, zero, 0)
  )
}

private predicate boolCheck(DataFlow::Node cn, Expr e, boolean outcome) {
  cn.(DataFlow::CallNode)
      .getTarget()
      .hasQualifiedName("strings",
        ["Contains", "ContainsAny", "ContainsRune", "HasPrefix", "HasSuffix", "EqualFold"]) and
  cn.(DataFlow::CallNode).getArgument(0).asExpr() = e and
  outcome = false
}

private predicate compareCheck(DataFlow::Node cn, Expr e, boolean outcome) {
  cn.(DataFlow::CallNode)
      .getTarget()
      .hasQualifiedName("strings", ["Compare", "CompareFold", "ComparePrefix", "CompareSuffix"]) and
  cn.(DataFlow::CallNode).getArgument(0).asExpr() = e and
  outcome = false
}

private predicate regexMatchCheck(DataFlow::Node cn, Expr e, boolean outcome) {
  cn.(DataFlow::CallNode).getTarget() instanceof RegexpMatchFunction and
  cn.(DataFlow::CallNode).getArgument(0).asExpr() = e and
  outcome = false
}

/**
 * A use of a variable guarded by a call to `Index`, `ContainsAny`, Regex match functions
 * or similar, in a context suggesting it has been validated to not contain a particular character.
 */
class UntrustedUnicodeCharChecks extends DataFlow::Node {
  UntrustedUnicodeCharChecks() {
    this = DataFlow::BarrierGuard<indexCheck/3>::getABarrierNode()
    or
    this = DataFlow::BarrierGuard<countCheck/3>::getABarrierNode()
    or
    this = DataFlow::BarrierGuard<boolCheck/3>::getABarrierNode()
    or
    this = DataFlow::BarrierGuard<regexMatchCheck/3>::getABarrierNode()
    or
    this = DataFlow::BarrierGuard<compareCheck/3>::getABarrierNode()
  }
}

/**
 * A taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 *
 * This configuration uses two flow states, `PreValidation` and `PostValidation`,
 * to track the requirement that a logical validation has been performed before the Unicode Transformation.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnicodeBypassValidation" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    (source instanceof UntrustedFlowSource or source instanceof Source) and
    state instanceof PreValidation
  }

  override predicate isSanitizer(DataFlow::Node sanitizer, DataFlow::FlowState state) {
    sanitizer instanceof Sanitizer and
    state instanceof PostValidation
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    (
      exists(DataFlow::CallNode cn |
        cn.getACalleeIncludingExternals().asFunction() instanceof EscapeFunction and
        nodeFrom = cn.getAnArgument() and
        nodeTo = cn.getResult()
      )
      or
      exists(DataFlow::CallNode cn |
        cn.getACalleeIncludingExternals().asFunction() instanceof RegexpReplaceFunction and
        nodeFrom = cn.getAnArgument() and
        nodeTo = cn.getResult()
      )
      or
      exists(DataFlow::CallNode cn |
        cn.getTarget().hasQualifiedName("strings", "Cut") and
        nodeFrom = cn.getArgument(0) and
        nodeTo = cn.getResult([0, 1])
      )
      or
      exists(DataFlow::CallNode cn |
        cn.getTarget().hasQualifiedName("strings", ["CutPrefix", "CutSuffix"]) and
        nodeFrom = cn.getArgument(0) and
        nodeTo = cn.getResult(0)
      )
      or
      exists(DataFlow::CallNode cn |
        cn.getTarget()
            .hasQualifiedName("strings",
              [
                "Fields", "FieldsFunc", "Replace", "ReplaceAll", "Split", "SplitAfter",
                "SplitAfterN", "SplitN", "ToLower", "ToLowerSpecial", "ToTitle", "ToTitleSpecial",
                "ToUpper", "ToUpperSpecial", "Trim", "TrimFunc", "TrimLeft", "TrimLeftFunc",
                "TrimPrefix", "TrimRight", "TrimRightFunc", "TrimSpace", "TrimSuffix",
              ]) and
        nodeFrom = cn.getArgument(0) and
        nodeTo = cn.getAResult()
      )
    ) and
    stateFrom instanceof PreValidation and
    stateTo instanceof PostValidation
  }

  /*
   * A Unicode Tranformation is considered a sink when the form algorithm used is for Unicode normalization (NFC, NFKC, etc) and one of the two scenarios happens:
   *  - The flow went through a call to an Escape function, Regex Replace function, or a String manipulation function.
   *  - The Unicode normalisation was guarded by a check that the input does not contain a particular character either using Regex match functions or String checks functions like Index/Contains functions.
   */

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    (
      exists(string unicodeNorm, DataFlow::MethodCallNode cn |
        unicodeNorm = package("golang.org/x/text", "unicode/norm") and
        cn.getTarget().hasQualifiedName(unicodeNorm, "Form", "String") and
        sink = cn.getArgument(0)
      )
      or
      sink instanceof Sink
    ) and
    (
      state instanceof PostValidation
      or
      sink instanceof UntrustedUnicodeCharChecks and state instanceof PreValidation
    )
  }
}
