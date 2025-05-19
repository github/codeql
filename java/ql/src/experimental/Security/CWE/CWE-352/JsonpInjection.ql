/**
 * @name JSONP Injection
 * @description User-controlled callback function names that are not verified are vulnerable
 *              to jsonp injection attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/jsonp-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-352
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.deadcode.WebEntryPoints
import semmle.code.java.security.XSS
deprecated import JsonpInjectionLib
deprecated import RequestResponseFlow::PathGraph

/** Taint-tracking configuration tracing flow from get method request sources to output jsonp data. */
deprecated module RequestResponseFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ActiveThreatModelSource and
    any(RequestGetMethod m).polyCalls*(source.getEnclosingCallable())
  }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof XssSink and
    any(RequestGetMethod m).polyCalls*(sink.getEnclosingCallable())
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodCall ma |
      isRequestGetParamMethod(ma) and pred.asExpr() = ma.getQualifier() and succ.asExpr() = ma
    )
  }
}

deprecated module RequestResponseFlow = TaintTracking::Global<RequestResponseFlowConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, RequestResponseFlow::PathNode source, RequestResponseFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  RequestResponseFlow::flowPath(source, sink) and
  JsonpInjectionFlow::flowTo(sink.getNode()) and
  sinkNode = sink.getNode() and
  message1 = "Jsonp response might include code from $@." and
  sourceNode = source.getNode() and
  message2 = "this user input"
}
