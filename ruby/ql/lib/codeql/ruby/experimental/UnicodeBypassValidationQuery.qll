/**
 * Provides a taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 */

private import ruby
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.Concepts
private import codeql.ruby.TaintTracking
private import codeql.ruby.ApiGraphs
import UnicodeBypassValidationCustomizations::UnicodeBypassValidation

/**
 * A state signifying that a logical validation has not been performed.
 * DEPRECATED: Use `PreValidationState()`
 */
deprecated class PreValidation extends DataFlow::FlowState {
  PreValidation() { this = "PreValidation" }
}

/**
 * A state signifying that a logical validation has been performed.
 * DEPRECATED: Use `PostValidationState()`
 */
deprecated class PostValidation extends DataFlow::FlowState {
  PostValidation() { this = "PostValidation" }
}

/**
 * A state signifying if a logical validation has been performed or not.
 */
private newtype ValidationState =
  // A state signifying that a logical validation has not been performed.
  PreValidationState() or
  // A state signifying that a logical validation has been performed.
  PostValidationState()

/**
 * A taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 *
 * This configuration uses two flow states, `PreValidation` and `PostValidation`,
 * to track the requirement that a logical validation has been performed before the Unicode Transformation.
 * DEPRECATED: Use `UnicodeBypassValidationFlow`
 */
deprecated class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "UnicodeBypassValidation" }

  private ValidationState convertState(DataFlow::FlowState state) {
    state instanceof PreValidation and result = PreValidationState()
    or
    state instanceof PostValidation and result = PostValidationState()
  }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowState state) {
    UnicodeBypassValidationConfig::isSource(source, this.convertState(state))
  }

  override predicate isAdditionalTaintStep(
    DataFlow::Node nodeFrom, DataFlow::FlowState stateFrom, DataFlow::Node nodeTo,
    DataFlow::FlowState stateTo
  ) {
    UnicodeBypassValidationConfig::isAdditionalFlowStep(nodeFrom, this.convertState(stateFrom),
      nodeTo, this.convertState(stateTo))
  }

  /* A Unicode Tranformation (Unicode tranformation) is considered a sink when the algorithm used is either NFC or NFKC.  */
  override predicate isSink(DataFlow::Node sink, DataFlow::FlowState state) {
    UnicodeBypassValidationConfig::isSink(sink, this.convertState(state))
  }
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
    source instanceof RemoteFlowSource and state = PreValidationState()
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    (
      exists(Escaping escaping | nodeFrom = escaping.getAnInput() and nodeTo = escaping.getOutput())
      or
      exists(RegexExecution re | nodeFrom = re.getString() and nodeTo = re)
      or
      // String Manipulation Method Calls
      // https://ruby-doc.org/core-2.7.0/String.html
      exists(DataFlow::CallNode cn |
        cn.getMethodName() =
          [
            [
                "ljust", "lstrip", "succ", "next", "rjust", "capitalize", "chomp", "gsub", "chop",
                "downcase", "swapcase", "uprcase", "scrub", "slice", "squeeze", "strip", "sub",
                "tr", "tr_s", "reverse"
              ] + ["", "!"], "concat", "dump", "each_line", "replace", "insert", "inspect", "lines",
            "partition", "prepend", "replace", "rpartition", "scan", "split", "undump",
            "unpack" + ["", "1"]
          ] and
        nodeFrom = cn.getReceiver() and
        nodeTo = cn
      )
      or
      exists(DataFlow::CallNode cn |
        cn.getMethodName() =
          [
            "casecmp" + ["", "?"], "center", "count", "each_char", "index", "rindex", "sum",
            ["delete", "delete_prefix", "delete_suffix"] + ["", "!"],
            ["start_with", "end_with" + "eql", "include"] + ["?", "!"], "match" + ["", "?"],
          ] and
        nodeFrom = cn.getReceiver() and
        nodeTo = nodeFrom
      )
      or
      exists(DataFlow::CallNode cn |
        cn = API::getTopLevelMember("CGI").getAMethodCall("escapeHTML") and
        nodeFrom = cn.getArgument(0) and
        nodeTo = cn
      )
    ) and
    stateFrom = PreValidationState() and
    stateTo = PostValidationState()
  }

  /* A Unicode Tranformation (Unicode tranformation) is considered a sink when the algorithm used is either NFC or NFKC.  */
  predicate isSink(DataFlow::Node sink, FlowState state) {
    (
      exists(DataFlow::CallNode cn |
        cn.getMethodName() = "unicode_normalize" and
        cn.getArgument(0).getConstantValue().getSymbol() = ["nfkc", "nfc", "nfkd", "nfd"] and
        sink = cn.getReceiver()
      )
      or
      // unicode_utils
      exists(API::MethodAccessNode mac |
        mac = API::getTopLevelMember("UnicodeUtils").getMethod(["nfkd", "nfc", "nfd", "nfkc"]) and
        sink = mac.getArgument(0).asSink()
      )
      or
      // eprun
      exists(API::MethodAccessNode mac |
        mac = API::getTopLevelMember("Eprun").getMethod("normalize") and
        sink = mac.getArgument(0).asSink()
      )
      or
      // unf
      exists(API::MethodAccessNode mac |
        mac = API::getTopLevelMember("UNF").getMember("Normalizer").getMethod("normalize") and
        sink = mac.getArgument(0).asSink()
      )
      or
      // ActiveSupport::Multibyte::Chars
      exists(DataFlow::CallNode cn, DataFlow::CallNode n |
        cn =
          API::getTopLevelMember("ActiveSupport")
              .getMember("Multibyte")
              .getMember("Chars")
              .getMethod("new")
              .asCall() and
        n = cn.getAMethodCall("normalize") and
        sink = cn.getArgument(0)
      )
    ) and
    state = PostValidationState()
  }
}

/**
 * Taint-tracking configuration for detecting "Unicode transformation mishandling" vulnerabilities.
 */
module UnicodeBypassValidationFlow = TaintTracking::GlobalWithState<UnicodeBypassValidationConfig>;
