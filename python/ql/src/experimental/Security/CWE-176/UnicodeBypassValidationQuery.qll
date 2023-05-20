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
      // String methods
      exists(MethodCallNode call, string method_name |
        nodeTo = call and call.getMethodName() = method_name
      |
        call.calls(nodeFrom, method_name) and
        method_name in [
            "capitalize", "casefold", "center", "expandtabs", "format", "format_map", "join",
            "ljust", "lstrip", "lower", "replace", "rjust", "rstrip", "strip", "swapcase", "title",
            "upper", "zfill", "encode", "decode"
          ]
        or
        method_name = "replace" and
        nodeFrom = call.getArg(1)
        or
        method_name = "format" and
        nodeFrom = call.getArg(_)
        or
        // str -> List[str]
        call.calls(nodeFrom, method_name) and
        method_name in ["partition", "rpartition", "rsplit", "split", "splitlines"]
        or
        // Iterable[str] -> str
        method_name = "join" and
        nodeFrom = call.getArg(0)
        or
        // Mapping[str, Any] -> str
        method_name = "format_map" and
        nodeFrom = call.getArg(0)
      )
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
