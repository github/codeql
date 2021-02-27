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
import JsonpInjectionFilterLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.deadcode.WebEntryPoints
import DataFlow::PathGraph


/** If there is a method to verify `token`, `auth`, `referer`, and `origin`, it will not pass. */
class ServletVerifAuth extends DataFlow::BarrierGuard {
  ServletVerifAuth() {
    exists(MethodAccess ma, Node prod, Node succ |
      ma.getMethod().getName().regexpMatch("(?i).*(token|auth|referer|origin).*") and
      prod instanceof RemoteFlowSource and
      succ.asExpr() = ma.getAnArgument() and
      ma.getMethod().getAParameter().getName().regexpMatch("(?i).*(token|auth|referer|origin).*") and
      localFlowStep*(prod, succ) and
      this = ma
    )
  }

  override predicate checks(Expr e, boolean branch) {
    exists(Node node |
      node instanceof JsonpInjectionSink and
      e = node.asExpr() and
      branch = true
    )
  }
}

/** Taint-tracking configuration tracing flow from get method request sources to output jsonp data. */
class JsonpInjectionConfig extends TaintTracking::Configuration {
  JsonpInjectionConfig() { this = "JsonpInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof GetHttpRequestSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JsonpInjectionSink }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof ServletVerifAuth
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodAccess ma |
      isRequestGetParamMethod(ma) and pred.asExpr() = ma.getQualifier() and succ.asExpr() = ma
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, JsonpInjectionConfig conf
where
  not checks() = false and
  conf.hasFlowPath(source, sink) and
  exists(JsonpInjectionFlowConfig jhfc | jhfc.hasFlowTo(sink.getNode()))
select sink.getNode(), source, sink, "Jsonp Injection query might include code from $@.",
  source.getNode(), "this user input"
