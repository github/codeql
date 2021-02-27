/**
 * @name JSONP Injection
 * @description User-controlled callback function names that are not verified are vulnerable
 *              to json hijacking attacks.
 * @kind path-problem
 */

import java
import DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import DataFlow::PathGraph

class FilterVerifAuth extends DataFlow::BarrierGuard {
  FilterVerifAuth() {
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
      node instanceof DoFilterMethodSink and
      e = node.asExpr() and
      branch = true
    )
  }
}

/** A data flow source for `Filter.doFilter` method paramters. */
private class DoFilterMethodSource extends DataFlow::Node {
  DoFilterMethodSource() {
    exists(Method m |
      isDoFilterMethod(m) and
      m.getAParameter().getAnAccess() = this.asExpr()
    )
  }
}

/** A data flow sink for `FilterChain.doFilter` method qualifying expression. */
private class DoFilterMethodSink extends DataFlow::Node {
  DoFilterMethodSink() {
    exists(MethodAccess ma, Method m | ma.getMethod() = m |
      m.hasName("doFilter") and
      m.getDeclaringType*().hasQualifiedName("javax.servlet", "FilterChain") and
      ma.getQualifier() = this.asExpr()
    )
  }
}

/** Taint-tracking configuration tracing flow from `doFilter` method paramter source to output 
 * `FilterChain.doFilter` method qualifying expression. 
 * */
class DoFilterMethodConfig extends TaintTracking::Configuration {
  DoFilterMethodConfig() { this = "DoFilterMethodConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof DoFilterMethodSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof DoFilterMethodSink }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof FilterVerifAuth
  }
}

/** Implement class modeling verification for `Filter.doFilter`, return false if it fails. */
boolean checks() {
  exists(DataFlow::PathNode source, DataFlow::PathNode sink, DoFilterMethodConfig conf |
    conf.hasFlowPath(source, sink) and
    result = false
  )
}
