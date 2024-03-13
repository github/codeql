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
import JsonpInjectionLib
import RequestResponseFlow::PathGraph

/** Taint-tracking configuration tracing flow from get method request sources to output jsonp data. */
module RequestResponseFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof ThreatModelFlowSource and
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

module RequestResponseFlow = TaintTracking::Global<RequestResponseFlowConfig>;

from RequestResponseFlow::PathNode source, RequestResponseFlow::PathNode sink
where
  RequestResponseFlow::flowPath(source, sink) and
  JsonpInjectionFlow::flowTo(sink.getNode())
select sink.getNode(), source, sink, "Jsonp response might include code from $@.", source.getNode(),
  "this user input"
