/**
 * Provides a taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.Concepts
import semmle.python.dataflow.new.internal.DataFlowPublic
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.TaintTrackingPrivate
import semmle.python.dataflow.new.RemoteFlowSources
import UnicodeBypassValidationCustomizations::UnicodeBypassValidation

abstract private class ValidationState extends string {
  bindingset[this]
  ValidationState() { any() }
}

/** A state signifying that a logical validation has not been performed. */
class PreValidation extends ValidationState {
  PreValidation() { this = "PreValidation" }
}

/** A state signifying that a logical validation has been performed. */
class PostValidation extends ValidationState {
  PostValidation() { this = "PostValidation" }
}

/**
 * A taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 *
 * This configuration uses two flow states, `PreValidation` and `PostValidation`,
 * to track the requirement that a logical validation has been performed before the Unicode Transformation.
 */
private module UnicodeBypassValidationConfig implements DataFlow::StateConfigSig {
  class FlowState = ValidationState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof RemoteFlowSource and state instanceof PreValidation
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    (
      exists(Escaping escaping | nodeFrom = escaping.getAnInput() and nodeTo = escaping.getOutput())
      or
      exists(RegexExecution re | nodeFrom = re.getString() and nodeTo = re)
      or
      stringManipulation(nodeFrom, nodeTo) and
      not nodeTo.(DataFlow::MethodCallNode).getMethodName() in ["encode", "decode"]
    ) and
    stateFrom instanceof PreValidation and
    stateTo instanceof PostValidation
  }

  /* A Unicode Tranformation (Unicode tranformation) is considered a sink when the algorithm used is either NFC or NFKC.  */
  predicate isSink(DataFlow::Node sink, FlowState state) {
    exists(API::CallNode cn |
      cn = API::moduleImport("unicodedata").getMember("normalize").getACall() and
      sink = cn.getArg(1)
      or
      cn = API::moduleImport("unidecode").getMember("unidecode").getACall() and
      sink = cn.getArg(0)
      or
      cn = API::moduleImport("pyunormalize").getMember(["NFC", "NFD", "NFKC", "NFKD"]).getACall() and
      sink = cn.getArg(0)
      or
      cn = API::moduleImport("pyunormalize").getMember("normalize").getACall() and
      sink = cn.getArg(1)
      or
      cn = API::moduleImport("textnorm").getMember("normalize_unicode").getACall() and
      sink = cn.getArg(0)
    ) and
    state instanceof PostValidation
  }
}

/** Global taint-tracking for detecting "Unicode transformation mishandling" vulnerabilities. */
module UnicodeBypassValidationFlow = TaintTracking::GlobalWithState<UnicodeBypassValidationConfig>;
