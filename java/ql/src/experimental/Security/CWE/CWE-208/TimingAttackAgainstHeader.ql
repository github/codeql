/**
 * @name Timing attack against header value
 * @description Use of a non-constant-time verification routine to check the value of an HTTP header,
 *              possibly allowing a timing attack to infer the header's expected value.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/timing-attack-against-headers-value
 * @tags security
 *       experimental
 *       external/cwe/cwe-208
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import NonConstantTimeComparisonFlow::PathGraph

/** A static method that uses a non-constant-time algorithm for comparing inputs. */
private class NonConstantTimeComparisonCall extends StaticMethodCall {
  NonConstantTimeComparisonCall() {
    this.getMethod()
        .hasQualifiedName("org.apache.commons.lang3", "StringUtils",
          ["equals", "equalsAny", "equalsAnyIgnoreCase", "equalsIgnoreCase"])
  }
}

/** Methods that use a non-constant-time algorithm for comparing inputs. */
private class NonConstantTimeEqualsCall extends MethodCall {
  NonConstantTimeEqualsCall() {
    this.getMethod()
        .hasQualifiedName("java.lang", "String", ["equals", "contentEquals", "equalsIgnoreCase"])
  }
}

private predicate isNonConstantEqualsCallArgument(Expr e) {
  exists(NonConstantTimeEqualsCall call | e = [call.getQualifier(), call.getArgument(0)])
}

private predicate isNonConstantComparisonCallArgument(Expr p) {
  exists(NonConstantTimeComparisonCall call | p = [call.getArgument(0), call.getArgument(1)])
}

class ClientSuppliedIpTokenCheck extends DataFlow::Node {
  ClientSuppliedIpTokenCheck() {
    exists(MethodCall ma |
      ma.getMethod().hasName("getHeader") and
      ma.getArgument(0).(CompileTimeConstantExpr).getStringValue().toLowerCase() in [
          "x-auth-token", "x-csrf-token", "http_x_csrf_token", "x-csrf-param", "x-csrf-header",
          "http_x_csrf_token", "x-api-key", "authorization", "proxy-authorization"
        ] and
      ma = this.asExpr()
    )
  }
}

module NonConstantTimeComparisonConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ClientSuppliedIpTokenCheck }

  predicate isSink(DataFlow::Node sink) {
    isNonConstantEqualsCallArgument(sink.asExpr()) or
    isNonConstantComparisonCallArgument(sink.asExpr())
  }
}

module NonConstantTimeComparisonFlow = TaintTracking::Global<NonConstantTimeComparisonConfig>;

deprecated query predicate problems(
  DataFlow::Node sinkNode, NonConstantTimeComparisonFlow::PathNode source,
  NonConstantTimeComparisonFlow::PathNode sink, string message1, DataFlow::Node sourceNode,
  string message2
) {
  NonConstantTimeComparisonFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Possible timing attack against $@ validation." and
  sourceNode = source.getNode() and
  message2 = "client-supplied token"
}
