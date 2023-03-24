/**
 * Models a very basic guard for the tainted path queries.
 */

import java
import semmle.code.java.frameworks.Networking
import semmle.code.java.dataflow.DataFlow

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to tainted path flow configurations.
 */
class TaintedPathAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

private class DefaultTaintedPathAdditionalTaintStep extends TaintedPathAdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Argument a |
      a = n1.asExpr() and
      a.getCall() = n2.asExpr() and
      a = any(TaintPreservingUriCtorParam tpp).getAnArgument()
    )
  }
}

private class TaintPreservingUriCtorParam extends Parameter {
  TaintPreservingUriCtorParam() {
    exists(Constructor ctor, int idx, int nParams |
      ctor.getDeclaringType() instanceof TypeUri and
      this = ctor.getParameter(idx) and
      nParams = ctor.getNumberOfParameters()
    |
      // URI(String scheme, String ssp, String fragment)
      idx = 1 and nParams = 3
      or
      // URI(String scheme, String host, String path, String fragment)
      idx = [1, 2] and nParams = 4
      or
      // URI(String scheme, String authority, String path, String query, String fragment)
      idx = 2 and nParams = 5
      or
      // URI(String scheme, String userInfo, String host, int port, String path, String query, String fragment)
      idx = 4 and nParams = 7
    )
  }
}
