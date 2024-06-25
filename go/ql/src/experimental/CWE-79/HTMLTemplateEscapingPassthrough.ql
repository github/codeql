/**
 * @name HTML template escaping passthrough
 * @description If a user-provided value is converted to a special type that avoids escaping when fed into a HTML
 *              template, it may result in XSS.
 * @kind path-problem
 * @problem.severity warning
 * @id go/html-template-escaping-passthrough
 * @tags security
 *       experimental
 *       external/cwe/cwe-79
 */

import go

/**
 * Holds if the provided `untrusted` node flows into a conversion to a PassthroughType.
 * The `targetType` parameter gets populated with the name of the PassthroughType,
 * and `conversionSink` gets populated with the node where the conversion happens.
 */
predicate flowsFromUntrustedToConversion(
  DataFlow::Node untrusted, PassthroughTypeName targetType, DataFlow::Node conversionSink
) {
  exists(DataFlow::Node source |
    UntrustedToPassthroughTypeConversionFlow::flow(source, conversionSink) and
    source = untrusted and
    UntrustedToPassthroughTypeConversionConfig::isSinkToPassthroughType(conversionSink, targetType)
  )
}

/**
 * A name of a type that will not be escaped when passed to
 * a `html/template` template.
 */
class PassthroughTypeName extends string {
  PassthroughTypeName() { this = ["HTML", "HTMLAttr", "JS", "JSStr", "CSS", "Srcset", "URL"] }
}

module UntrustedToPassthroughTypeConversionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  additional predicate isSinkToPassthroughType(DataFlow::TypeCastNode sink, PassthroughTypeName name) {
    exists(Type typ |
      typ = sink.getResultType() and
      typ.getUnderlyingType*().hasQualifiedName("html/template", name)
    )
  }

  predicate isSink(DataFlow::Node sink) { isSinkToPassthroughType(sink, _) }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof SharedXss::Sanitizer or node.getType() instanceof NumericType
  }
}

/**
 * Tracks taint flow for reasoning about when a `ThreatModelFlowSource` is
 * converted into a special "passthrough" type which will not be escaped by the
 * template generator; this allows the injection of arbitrary content (html,
 * css, js) into the generated output of the templates.
 */
module UntrustedToPassthroughTypeConversionFlow =
  TaintTracking::Global<UntrustedToPassthroughTypeConversionConfig>;

/**
 * Holds if the provided `conversion` node flows into the provided `execSink`.
 */
predicate flowsFromConversionToExec(
  DataFlow::Node conversion, PassthroughTypeName targetType, DataFlow::Node execSink
) {
  PassthroughTypeConversionToTemplateExecutionCallFlow::flow(conversion, execSink) and
  PassthroughTypeConversionToTemplateExecutionCallConfig::isSourceConversionToPassthroughType(conversion,
    targetType)
}

module PassthroughTypeConversionToTemplateExecutionCallConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { isSourceConversionToPassthroughType(source, _) }

  additional predicate isSourceConversionToPassthroughType(
    DataFlow::TypeCastNode source, PassthroughTypeName name
  ) {
    exists(Type typ |
      typ = source.getResultType() and
      typ.getUnderlyingType*().hasQualifiedName("html/template", name)
    )
  }

  predicate isSink(DataFlow::Node sink) { isSinkToTemplateExec(sink, _) }
}

/**
 * Tracks taint flow for reasoning about when the result of a conversion to a
 * PassthroughType flows to a template execution call.
 */
module PassthroughTypeConversionToTemplateExecutionCallFlow =
  TaintTracking::Global<PassthroughTypeConversionToTemplateExecutionCallConfig>;

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

module FromUntrustedToTemplateExecutionCallConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) { isSinkToTemplateExec(sink, _) }
}

/**
 * Tracks taint flow from a `ThreatModelFlowSource` into a template executor
 * call.
 */
module FromUntrustedToTemplateExecutionCallFlow =
  TaintTracking::Global<FromUntrustedToTemplateExecutionCallConfig>;

import FromUntrustedToTemplateExecutionCallFlow::PathGraph

/**
 * Holds if the provided `untrusted` node flows into the provided `execSink`.
 */
predicate flowsFromUntrustedToExec(
  FromUntrustedToTemplateExecutionCallFlow::PathNode untrusted,
  FromUntrustedToTemplateExecutionCallFlow::PathNode execSink
) {
  FromUntrustedToTemplateExecutionCallFlow::flowPath(untrusted, execSink)
}

from
  FromUntrustedToTemplateExecutionCallFlow::PathNode untrustedSource,
  FromUntrustedToTemplateExecutionCallFlow::PathNode templateExecCall,
  PassthroughTypeName targetTypeName, DataFlow::Node conversion
where
  // A = untrusted remote flow source
  // B = conversion to PassthroughType
  // C = template execution call
  // Flows:
  // A -> B
  flowsFromUntrustedToConversion(untrustedSource.getNode(), targetTypeName, conversion) and
  // B -> C
  flowsFromConversionToExec(conversion, targetTypeName, templateExecCall.getNode()) and
  // A -> C
  flowsFromUntrustedToExec(untrustedSource, templateExecCall)
select templateExecCall.getNode(), untrustedSource, templateExecCall,
  "Data from an $@ will not be auto-escaped because it was $@ to template." + targetTypeName,
  untrustedSource.getNode(), "untrusted source", conversion, "converted"
