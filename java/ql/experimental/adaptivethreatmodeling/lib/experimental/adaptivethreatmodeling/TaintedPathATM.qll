/**
 * For internal use only.
 *
 * A taint-tracking configuration for reasoning about path injection vulnerabilities.
 * Defines shared code used by the path injection boosted query.
 * Largely copied from java/ql/src/Security/CWE/CWE-022/TaintedPath.ql.
 */

import java
import semmle.code.java.security.PathSanitizer
import ATMConfig
import semmle.code.java.dataflow.FlowSources

class TaintedPathAtmConfig extends AtmConfig {
  TaintedPathAtmConfig() { this = "TaintedPathAtmConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override EndpointType getASinkEndpointType() { result instanceof TaintedPathSinkType }

  /*
   * This is largely a copy of the taint tracking configuration for the standard path injection
   * query, except additional ATM sinks have been added to the `isSink` predicate.
   */

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer.getType() instanceof BoxedType or
    sanitizer.getType() instanceof PrimitiveType or
    sanitizer.getType() instanceof NumberType or
    sanitizer instanceof PathInjectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(TaintedPathAdditionalTaintStep s).step(n1, n2)
  }
}

/*
 * Models a very basic guard for the tainted path queries.
 * TODO: Copied from java/ql/src/Security/CWE/CWE-022/TaintedPathCommon.qll because I couldn't figure out how to import it.
 */

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
