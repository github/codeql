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

private predicate untrustedUnicodeCharCheckGuard(DataFlow::Node cn, Expr e, boolean outcome) {
  cn.(DataFlow::CallNode)
      .getTarget()
      .hasQualifiedName("strings",
        [
          "Contains", "ContainsAny", "ContainsRune", "Count", "EqualFold", "HasPrefix", "HasSuffix",
          "Index", "IndexAny", "IndexByte", "IndexFunc", "IndexRune", "LastIndex", "LastIndexAny",
          "LastIndexByte", "LastIndexFunc",
        ]) and
  cn.(DataFlow::CallNode).getArgument(0).asExpr() = e and
  outcome = true
}

/**
 * A call to a function called `Index`, `ContainsAny`, or similar, which may be
 * considered a barrier guard for eliminating untrusted Unicode characters.
 */
class UntrustedUnicodeCharCheckBarrier extends DataFlow::Node {
  UntrustedUnicodeCharCheckBarrier() {
    this = DataFlow::BarrierGuard<untrustedUnicodeCharCheckGuard/3>::getABarrierNode()
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
    (
      sanitizer instanceof UntrustedUnicodeCharCheckBarrier or
      sanitizer instanceof Sanitizer
    ) and
    state instanceof PreValidation
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
        (
          cn.getACalleeIncludingExternals().asFunction() instanceof RegexpMatchFunction or
          cn.getACalleeIncludingExternals().asFunction() instanceof RegexpReplaceFunction
        ) and
        nodeFrom = cn.getAnArgument() and
        nodeTo = cn.getResult()
      )
      or
      exists(DataFlow::CallNode cn |
        cn.getTarget().hasQualifiedName("strings", "Compare") and
        nodeFrom = cn.getAnArgument() and
        nodeTo = nodeFrom
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

  /* A Unicode Tranformation (Unicode tranformation) is considered a sink when the algorithm used is either NFC or NFKC.  */
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
    state instanceof PostValidation
  }
}
