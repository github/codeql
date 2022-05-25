/**
 * @name HTML template escaping passthrough
 * @description If a user-provided value is converted to a special type that avoids escaping when fed into a HTML
 *              template, it may result in XSS.
 * @kind path-problem
 * @problem.severity warning
 * @id go/html-template-escaping-passthrough
 * @tags security
 *       external/cwe/cwe-79
 */

import go
import DataFlow::PathGraph

/**
 * Holds if the provided `untrusted` node flows into a conversion to a PassthroughType.
 * The `targetType` parameter gets populated with the name of the PassthroughType,
 * and `conversionSink` gets populated with the node where the conversion happens.
 */
predicate flowsFromUntrustedToConversion(
  DataFlow::Node untrusted, PassthroughTypeName targetType, DataFlow::Node conversionSink
) {
  exists(FlowConfFromUntrustedToPassthroughTypeConversion cfg, DataFlow::Node source |
    cfg.hasFlow(source, conversionSink) and
    source = untrusted and
    targetType = cfg.getDstTypeName()
  )
}

/**
 * Provides the names of the types that will not be escaped when passed to
 * a `html/template` template.
 */
class PassthroughTypeName extends string {
  PassthroughTypeName() { this = ["HTML", "HTMLAttr", "JS", "JSStr", "CSS", "Srcset", "URL"] }
}

/**
 * A taint-tracking configuration for reasoning about when an UntrustedFlowSource
 * is converted into a special "passthrough" type which will not be escaped by the template generator;
 * this allows the injection of arbitrary content (html, css, js) into the generated
 * output of the templates.
 */
class FlowConfFromUntrustedToPassthroughTypeConversion extends TaintTracking::Configuration {
  PassthroughTypeName dstTypeName;

  FlowConfFromUntrustedToPassthroughTypeConversion() {
    this = "UntrustedToConversion" + dstTypeName
  }

  /**
   * Gets the name of conversion's destination type.
   */
  PassthroughTypeName getDstTypeName() { result = dstTypeName }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  private predicate isSinkToPassthroughType(DataFlow::TypeCastNode sink, PassthroughTypeName name) {
    exists(Type typ |
      typ = sink.getResultType() and
      typ.getUnderlyingType*().hasQualifiedName("html/template", name)
    )
  }

  override predicate isSink(DataFlow::Node sink) { isSinkToPassthroughType(sink, dstTypeName) }
}

/**
 * Holds if the provided `conversion` node flows into the provided `execSink`.
 */
predicate flowsFromConversionToExec(
  DataFlow::Node conversion, PassthroughTypeName targetType, DataFlow::Node execSink
) {
  exists(
    FlowConfPassthroughTypeConversionToTemplateExecutionCall cfg, DataFlow::Node source,
    DataFlow::Node execSinkLocal
  |
    cfg.hasFlow(source, execSinkLocal) and
    source = conversion and
    execSink = execSinkLocal and
    targetType = cfg.getDstTypeName()
  )
}

/**
 * A taint-tracking configuration for reasoning about when the result of a conversion
 * to a PassthroughType flows to a template execution call.
 */
class FlowConfPassthroughTypeConversionToTemplateExecutionCall extends TaintTracking::Configuration {
  PassthroughTypeName dstTypeName;

  FlowConfPassthroughTypeConversionToTemplateExecutionCall() {
    this = "ConversionToExec" + dstTypeName
  }

  /**
   * Gets the name of conversion's destination type.
   */
  PassthroughTypeName getDstTypeName() { result = dstTypeName }

  override predicate isSource(DataFlow::Node source) {
    isSourceConversionToPassthroughType(source, _)
  }

  private predicate isSourceConversionToPassthroughType(
    DataFlow::TypeCastNode source, PassthroughTypeName name
  ) {
    exists(Type typ |
      typ = source.getResultType() and
      typ.getUnderlyingType*().hasQualifiedName("html/template", name)
    )
  }

  override predicate isSink(DataFlow::Node sink) { isSinkToTemplateExec(sink, _) }
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
 * A taint-tracking configuration for reasoning about when an UntrustedFlowSource
 * flows into a template executor call.
 */
class FlowConfFromUntrustedToTemplateExecutionCall extends TaintTracking::Configuration {
  FlowConfFromUntrustedToTemplateExecutionCall() {
    this = "FlowConfFromUntrustedToTemplateExecutionCall"
  }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { isSinkToTemplateExec(sink, _) }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof SharedXss::Sanitizer or sanitizer.getType() instanceof NumericType
  }
}

/**
 * Holds if the provided `untrusted` node flows into the provided `execSink`.
 */
predicate flowsFromUntrustedToExec(DataFlow::PathNode untrusted, DataFlow::PathNode execSink) {
  exists(FlowConfFromUntrustedToTemplateExecutionCall cfg | cfg.hasFlowPath(untrusted, execSink))
}

from
  DataFlow::PathNode untrustedSource, DataFlow::PathNode templateExecCall,
  PassthroughTypeName targetTypeName, DataFlow::PathNode conversion
where
  // A = untrusted remote flow source
  // B = conversion to PassthroughType
  // C = template execution call
  // Flows:
  // A -> B
  flowsFromUntrustedToConversion(untrustedSource.getNode(), targetTypeName, conversion.getNode()) and
  // B -> C
  flowsFromConversionToExec(conversion.getNode(), targetTypeName, templateExecCall.getNode()) and
  // A -> C
  flowsFromUntrustedToExec(untrustedSource, templateExecCall)
select templateExecCall.getNode(), untrustedSource, templateExecCall,
  "Data from an $@ will not be auto-escaped because it was $@ to template." + targetTypeName,
  untrustedSource.getNode(), "untrusted source", conversion.getNode(), "converted"
