/**
 * @name HTML template escaping bypass cross-site scripting
 * @description Converting user input to a special type that avoids escaping
 *              when fed into an HTML template allows for a cross-site
 *              scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @id go/html-template-escaping-bypass-xss
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import go

/**
 * A type that will not be escaped when passed to a `html/template` template.
 */
class UnescapedType extends Type {
  UnescapedType() {
    this.hasQualifiedName("html/template",
      ["CSS", "HTML", "HTMLAttr", "JS", "JSStr", "Srcset", "URL"])
  }
}

/**
 * Holds if the sink is a data value argument of a template execution call.
 *
 * Note that this is slightly more general than
 * `SharedXss::HtmlTemplateSanitizer` because it uses `Function.getACall()`,
 * which finds calls through interfaces which the receiver implements. This
 * finds more results in practice.
 */
predicate isSinkToTemplateExec(DataFlow::Node sink) {
  exists(Method fn, string methodName, DataFlow::CallNode call |
    fn.hasQualifiedName("html/template", "Template", methodName) and
    call = fn.getACall()
  |
    methodName = "Execute" and sink = call.getArgument(1)
    or
    methodName = "ExecuteTemplate" and sink = call.getArgument(2)
  )
}

/**
 * Data flow configuration that tracks flows from untrusted sources to template execution calls
 * which go through a conversion to an unescaped type.
 */
module UntrustedToTemplateExecWithConversionConfig implements DataFlow::StateConfigSig {
  private newtype TConversionState =
    TUnconverted() or
    TConverted(UnescapedType unescapedType)

  /**
   * Flow state for tracking whether a conversion to an unescaped type has occurred.
   */
  class FlowState extends TConversionState {
    predicate isBeforeConversion() { this instanceof TUnconverted }

    predicate isAfterConversion(UnescapedType unescapedType) { this = TConverted(unescapedType) }

    /** Gets a textual representation of this element. */
    string toString() {
      this.isBeforeConversion() and result = "Unconverted"
      or
      exists(UnescapedType unescapedType | this.isAfterConversion(unescapedType) |
        result = "Converted to " + unescapedType.getQualifiedName()
      )
    }
  }

  predicate isSource(DataFlow::Node source, FlowState state) {
    state.isBeforeConversion() and source instanceof ActiveThreatModelSource
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    state.isAfterConversion(_) and isSinkToTemplateExec(sink)
  }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof SharedXss::Sanitizer and not node instanceof SharedXss::HtmlTemplateSanitizer
    or
    node.getType() instanceof NumericType
  }

  /**
   * When a conversion to a passthrough type is encountered, transition the flow state.
   */
  predicate isAdditionalFlowStep(
    DataFlow::Node pred, FlowState predState, DataFlow::Node succ, FlowState succState
  ) {
    exists(ConversionExpr conversion, UnescapedType unescapedType |
      // If not yet converted, look for a conversion to a passthrough type
      predState.isBeforeConversion() and
      succState.isAfterConversion(unescapedType) and
      succ.(DataFlow::TypeCastNode).getExpr() = conversion and
      pred.asExpr() = conversion.getOperand() and
      conversion.getType().getUnderlyingType*() = unescapedType
    )
  }
}

module UntrustedToTemplateExecWithConversionFlow =
  TaintTracking::GlobalWithState<UntrustedToTemplateExecWithConversionConfig>;

import UntrustedToTemplateExecWithConversionFlow::PathGraph

from
  UntrustedToTemplateExecWithConversionFlow::PathNode untrustedSource,
  UntrustedToTemplateExecWithConversionFlow::PathNode templateExecCall, UnescapedType unescapedType
where
  UntrustedToTemplateExecWithConversionFlow::flowPath(untrustedSource, templateExecCall) and
  templateExecCall.getState().isAfterConversion(unescapedType)
select templateExecCall.getNode(), untrustedSource, templateExecCall,
  "Data from an $@ will not be auto-escaped because it was converted to template." +
    unescapedType.getName(), untrustedSource.getNode(), "untrusted source"
