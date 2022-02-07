/**
 * @name Timing attack against headers value
 * @description A constant-time algorithm should be used for checking the value of headers. 
 *              In other words, the comparison time should not depend on the content of the input
 *              Otherwise, an attacker may be able to implement a timing attacks that may reveal the value of sensitive headers
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/timing-attack-against-headers-value
 * @tags security
 *       external/cwe/cwe-208
 */


import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

private class NonConstantTimeEqualsCall extends MethodAccess {
  NonConstantTimeEqualsCall() {
    this.getMethod().hasQualifiedName("java.lang", "String", ["equals", "contentEquals", "equalsIgnoreCase"]) or
    this.getMethod().hasQualifiedName("java.nio", "ByteBuffer", ["equals", "compareTo"])
  }
}

private predicate isNonConstantTimeEqualsCall(Expr firstObject, Expr secondObject) {
  exists(NonConstantTimeEqualsCall call |
    firstObject = call.getQualifier() and
    secondObject = call.getAnArgument()
    or
    firstObject = call.getAnArgument() and
    secondObject = call.getQualifier()
  )
}
class NonConstantTimeComparisonSink extends DataFlow::Node {
  Expr anotherParameter;
  NonConstantTimeComparisonSink() {
      isNonConstantTimeEqualsCall(this.asExpr(), anotherParameter)
  }    
} 
class ClientSuppliedIpTokenCheck extends DataFlow::Node {
  ClientSuppliedIpTokenCheck() {
    exists(MethodAccess ma |
      ma.getMethod().hasName("getHeader") and
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() in [
          "x-auth-token", "x-csrf-token", "http_x_csrf_token", "x-csrf-param", "x-csrf-header", 
           "http_x_csrf_token"
        ] and
      ma = this.asExpr()
    )
  }
}

class NonConstantTimeComparisonConfig extends TaintTracking::Configuration {
  NonConstantTimeComparisonConfig() { this = "NonConstantTimeCryptoComparisonConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof ClientSuppliedIpTokenCheck }

  override predicate isSink(DataFlow::Node sink) { sink instanceof NonConstantTimeComparisonSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NonConstantTimeComparisonConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Possible timing attack against $@ validation.", source,
  source.getNode()
