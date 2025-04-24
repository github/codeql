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
 * Flow state for tracking whether a conversion to a passthrough type has occurred.
 */
class FlowState extends int {
  FlowState() { this = 0 or this = 1 }

  predicate isBeforeConversion() { this = 0 }

  predicate isAfterConversion() { this = 1 }
}

/**
 * Data flow configuration that tracks flows from untrusted sources (A) to template execution calls (C),
 * and tracks whether a conversion to a passthrough type (B) has occurred.
 */
module UntrustedToTemplateExecWithConversionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source, FlowState state) {
    state.isBeforeConversion() and source instanceof ActiveThreatModelSource
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    state.isAfterConversion() and isSinkToTemplateExec(sink, _)
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    node instanceof SharedXss::Sanitizer or node.getType() instanceof NumericType
  }

  /**
   * When a conversion to a passthrough type is encountered, transition the flow state.
   */
  predicate step(DataFlow::Node pred, FlowState predState, DataFlow::Node succ, FlowState succState) {
    // If not yet converted, look for a conversion to a passthrough type
    predState.isBeforeConversion() and
    succState.isAfterConversion() and
    pred = succ and
    exists(Type typ, PassthroughTypeName name |
      typ = pred.getType() and
      typ.getUnderlyingType*().hasQualifiedName("html/template", name)
    )
    or
    // Otherwise, normal flow with unchanged state
    predState = succState
  }
}

module UntrustedToTemplateExecWithConversionFlow =
  DataFlow::PathGraph<UntrustedToTemplateExecWithConversionConfig>;

from
  UntrustedToTemplateExecWithConversionFlow::PathNode untrustedSource,
  UntrustedToTemplateExecWithConversionFlow::PathNode templateExecCall, DataFlow::Node conversion,
  PassthroughTypeName targetTypeName
where
  UntrustedToTemplateExecWithConversionFlow::flowPath(untrustedSource, templateExecCall) and
  // Find the conversion node in the path
  exists(int i |
    i = templateExecCall.getPathIndex() - 1 and
    conversion = templateExecCall.getPathNode(i).getNode() and
    exists(Type typ |
      typ = conversion.getType() and
      typ.getUnderlyingType*().hasQualifiedName("html/template", targetTypeName)
    )
  )
select templateExecCall.getNode(), untrustedSource, templateExecCall,
  "Data from an $@ will not be auto-escaped because it was $@ to template." + targetTypeName,
  untrustedSource.getNode(), "untrusted source", conversion, "converted"
