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

/**
 * A taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 *
 * This configuration uses two flow states, `PreValidation` and `PostValidation`,
 * to track the requirement that a logical validation has been performed before the Unicode Transformation.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnicodeBypassValidation" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    source instanceof UntrustedFlowSource and
    state instanceof PreValidation
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    (
      exists(DataFlow::CallNode cn | 
        cn.getACalleeIncludingExternals() instanceof EscapeFunction |
        nodeFrom = cn.getAnArgument() and
        nodeTo = cn.getResult()
      )
      or
      exists(RegexpMatchFunction re |
        nodeFrom = re.getACall().getAnArgument() and nodeTo = re.getACall()
      )
      //or
      //stringManipulation(nodeFrom, nodeTo)
    ) and
    stateFrom instanceof PreValidation and
    stateTo instanceof PostValidation
  }

  /* A Unicode Tranformation (Unicode tranformation) is considered a sink when the algorithm used is either NFC or NFKC.  */
  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    exists(CallExpr ce, SelectorExpr e, Package p |
      ce.getCalleeName() = "String" and
      e = ce.getCalleeExpr() and
      p.getName() = e.getBase().(SelectorExpr).getBase().toString() and
      p.getPath() = package("vendor/golang.org/x/text/unicode", "norm") and
      e.getBase().(SelectorExpr).getSelector().toString() = ["NFKC", "NFC"] and
      sink.asExpr() = ce.getArgument(0)
    ) and
    state instanceof PostValidation
  }
}
