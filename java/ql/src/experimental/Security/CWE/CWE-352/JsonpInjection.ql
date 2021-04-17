/**
 * @name JSONP Injection
 * @description User-controlled callback function names that are not verified are vulnerable
 *              to jsonp injection attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/jsonp-injection
 * @tags security
 *       external/cwe/cwe-352
 */

import java
import JsonpInjectionLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.deadcode.WebEntryPoints
import DataFlow::PathGraph

/** Taint-tracking configuration tracing flow from get method request sources to output jsonp data. */
class RequestResponseFlowConfig extends TaintTracking::Configuration {
  RequestResponseFlowConfig() { this = "RequestResponseFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    any(RequestGetMethod m).polyCalls*(source.getEnclosingCallable())
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof XssSink and
    any(RequestGetMethod m).polyCalls*(sink.getEnclosingCallable())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess ma |
      isRequestGetParamMethod(ma) and pred.asExpr() = ma.getQualifier() and succ.asExpr() = ma
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, RequestResponseFlowConfig conf
where
  conf.hasFlowPath(source, sink) and
  exists(JsonpInjectionFlowConfig jhfc | jhfc.hasFlowTo(sink.getNode()))
select sink.getNode(), source, sink, "Jsonp response might include code from $@.", source.getNode(),
  "this user input"
