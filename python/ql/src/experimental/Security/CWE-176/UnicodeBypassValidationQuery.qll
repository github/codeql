/**
 * Provides a taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 */

private import python
import semmle.python.ApiGraphs
import semmle.python.Concepts
import semmle.python.dataflow.new.internal.DataFlowPublic
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.TaintTrackingPrivate
import semmle.python.dataflow.new.RemoteFlowSources
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
    source instanceof RemoteFlowSource and state instanceof PreValidation
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
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
  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
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
