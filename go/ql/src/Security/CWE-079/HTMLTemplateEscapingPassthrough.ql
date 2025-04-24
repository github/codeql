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
 * A name of a type that will not be escaped when passed to
 * a `html/template` template.
 */
class PassthroughTypeName extends string {
  PassthroughTypeName() { this = ["HTML", "HTMLAttr", "JS", "JSStr", "CSS", "Srcset", "URL"] }
}

/**
 * Holds if the sink is a data value argument of a template execution call.
 */
predicate isSinkToTemplateExec(DataFlow::Node sink, DataFlow::CallNode call) {
  exists(Method fn, string methodName |
    fn.hasQualifiedName("html/template", "Template", methodName) and
    call = fn.getACall()
  |
    methodName = "Execute" and sink = call.getArgument(1)
    or
    methodName = "ExecuteTemplate" and sink = call.getArgument(2)
  )
}

/**
 * Data flow configuration that tracks flows from untrusted sources (A) to template execution calls (C),
 * and tracks whether a conversion to a passthrough type (B) has occurred.
 */
module UntrustedToTemplateExecWithConversionConfig implements DataFlow::StateConfigSig {
  private newtype TConversionState =
    TUnconverted() or
    TConverted(PassthroughTypeName x)

  /**
   * Flow state for tracking whether a conversion to a passthrough type has occurred.
   */
  class FlowState extends TConversionState {
    predicate isBeforeConversion() { this instanceof TUnconverted }

    predicate isAfterConversion(PassthroughTypeName x) { this = TConverted(x) }

    /** Gets a textual representation of this element. */
    string toString() {
      this.isBeforeConversion() and result = "Unconverted"
      or
      exists(PassthroughTypeName x | this.isAfterConversion(x) |
        result = "Converted to template." + x
      )
    }
  }

  predicate isSource(DataFlow::Node source, FlowState state) {
    state.isBeforeConversion() and source instanceof ActiveThreatModelSource
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    state.isAfterConversion(_) and isSinkToTemplateExec(sink, _)
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
    exists(ConversionExpr conversion, PassthroughTypeName name |
      // If not yet converted, look for a conversion to a passthrough type
      predState.isBeforeConversion() and
      succState.isAfterConversion(name) and
      succ.(DataFlow::TypeCastNode).getExpr() = conversion and
      pred.asExpr() = conversion.getOperand() and
      conversion.getType().getUnderlyingType*().hasQualifiedName("html/template", name)
    )
  }
}

module UntrustedToTemplateExecWithConversionFlow =
  TaintTracking::GlobalWithState<UntrustedToTemplateExecWithConversionConfig>;

import UntrustedToTemplateExecWithConversionFlow::PathGraph

from
  UntrustedToTemplateExecWithConversionFlow::PathNode untrustedSource,
  UntrustedToTemplateExecWithConversionFlow::PathNode templateExecCall,
  PassthroughTypeName targetTypeName
where
  UntrustedToTemplateExecWithConversionFlow::flowPath(untrustedSource, templateExecCall) and
  templateExecCall.getState().isAfterConversion(targetTypeName)
select templateExecCall.getNode(), untrustedSource, templateExecCall,
  "Data from an $@ will not be auto-escaped because it was converted to template." + targetTypeName,
  untrustedSource.getNode(), "untrusted source"
