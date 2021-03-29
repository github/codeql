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
import DataFlow::PathGraph

/** Determine whether there is a verification method for the remote streaming source data flow path method. */
predicate existsFilterVerificationMethod() {
  exists(DataFlow::Node source, DataFlow::Node sink, VerificationMethodFlowConfig vmfc, Method m |
    vmfc.hasFlow(source, sink) and
    m = getACallingCallableOrSelf(source.getEnclosingCallable()) and
    isDoFilterMethod(m)
  )
}

/** Determine whether there is a verification method for the remote streaming source data flow path method. */
predicate existsServletVerificationMethod(Node checkNode) {
  exists(DataFlow::Node source, DataFlow::Node sink, VerificationMethodFlowConfig vmfc |
    vmfc.hasFlow(source, sink) and
    getACallingCallableOrSelf(source.getEnclosingCallable()) =
      getACallingCallableOrSelf(checkNode.getEnclosingCallable())
  )
}

/** Taint-tracking configuration tracing flow from get method request sources to output jsonp data. */
class RequestResponseFlowConfig extends TaintTracking::Configuration {
  RequestResponseFlowConfig() { this = "RequestResponseFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    getACallingCallableOrSelf(source.getEnclosingCallable()) instanceof RequestGetMethod
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof XssSink and
    getACallingCallableOrSelf(sink.getEnclosingCallable()) instanceof RequestGetMethod
  }

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
select sink.getNode(), source, sink, "Jsonp response might include code from $@.", source.getNode(),
  "this user input"
