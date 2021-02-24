/**
 * @name JSON Hijacking
 * @description User-controlled callback function names that are not verified are vulnerable
 *              to json hijacking attacks.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/Json-hijacking
 * @tags security
 *       external/cwe/cwe-352
 */

import java
import JsonpInjectionLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.deadcode.WebEntryPoints
import DataFlow::PathGraph

class VerifAuth extends DataFlow::BarrierGuard {
  VerifAuth() {
    exists(MethodAccess ma, Node prod, Node succ |
      this = ma and
      ma.getMethod().getName().regexpMatch("(?i).*(token|auth|referer).*") and
      prod instanceof RemoteFlowSource and
      succ.asExpr() = ma.getAnArgument() and
      ma.getMethod().getAParameter().getName().regexpMatch("(?i).*(token|auth|referer).*") and
      localFlowStep*(prod, succ)
    )
  }

  override predicate checks(Expr e, boolean branch) {
    exists(ReturnStmt rs |
      e = rs.getResult() and
      branch = true
    )
  }
}

/** Taint-tracking configuration tracing flow from remote sources to output jsonp data. */
class JsonpInjectionConfig extends TaintTracking::Configuration {
  JsonpInjectionConfig() { this = "JsonpInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JsonpInjectionSink }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) { guard instanceof VerifAuth }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, JsonpInjectionConfig conf
where
  conf.hasFlowPath(source, sink) and
  exists(JsonpInjectionFlowConfig jhfc | jhfc.hasFlowTo(sink.getNode()))
select sink.getNode(), source, sink, "Json Hijacking query might include code from $@.",
  source.getNode(), "this user input"