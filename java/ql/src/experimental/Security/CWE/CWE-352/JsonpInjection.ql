/**
 * @name JSONP Injection
 * @description User-controlled callback function names that are not verified are vulnerable
 *              to jsonp injection attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/JSONP-Injection
 * @tags security
 *       external/cwe/cwe-352
 */

import java
import JsonpInjectionLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.deadcode.WebEntryPoints
import semmle.code.java.security.XSS
import DataFlow::PathGraph

/** Determine whether there is a verification method for the remote streaming source data flow path method. */
predicate existsFilterVerificationMethod() {
  exists(MethodAccess ma,Node existsNode, Method m|
    ma.getMethod() instanceof VerificationMethodClass and
    existsNode.asExpr() = ma and
    m = getAnMethod(existsNode.getEnclosingCallable()) and
    isDoFilterMethod(m)
  )
}

/** Determine whether there is a verification method for the remote streaming source data flow path method. */
predicate existsServletVerificationMethod(Node checkNode) {
  exists(MethodAccess ma,Node existsNode|
    ma.getMethod() instanceof VerificationMethodClass and
    existsNode.asExpr() = ma and
    getAnMethod(existsNode.getEnclosingCallable()) = getAnMethod(checkNode.getEnclosingCallable())
  )
}

/** Taint-tracking configuration tracing flow from get method request sources to output jsonp data. */
class RequestResponseFlowConfig extends TaintTracking::Configuration {
  RequestResponseFlowConfig() { this = "RequestResponseFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    getAnMethod(source.getEnclosingCallable()) instanceof RequestGetMethod
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XssSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess ma |
      isRequestGetParamMethod(ma) and pred.asExpr() = ma.getQualifier() and succ.asExpr() = ma
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, RequestResponseFlowConfig conf
where
  not existsServletVerificationMethod(source.getNode()) and
  not existsFilterVerificationMethod() and
  conf.hasFlowPath(source, sink) and
  exists(JsonpInjectionFlowConfig jhfc | jhfc.hasFlowTo(sink.getNode()))
select sink.getNode(), source, sink, "Jsonp Injection query might include code from $@.",
  source.getNode(), "this user input"