/**
 * For internal use only.
 *
 * Collects the query configurations to boost with ATM. Imports the configurations of supported Java queries where
 * possible. Java queries that are defined in a `.ql` file get copied into this file.
 */

private import java as java
private import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.RequestForgeryConfig
import semmle.code.java.security.SqlInjectionQuery
import EndpointTypes
import EndpointCharacteristics as EndpointCharacteristics
/* Copied from java/ql/src/Security/CWE/CWE-022/TaintedPath.ql */
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.security.PathCreation
private import semmle.code.java.security.PathSanitizer

/*
 * Configurations that are copied from Java queries because they can't be directly imported.
 */

/* TaintedPathConfig cannot be imported directly since it is defined in a .ql file. It is therefore copied here. */
/* Copied from java/ql/src/Security/CWE/CWE-022/TaintedPath.ql */
class TaintedPathConfig extends TaintTracking::Configuration {
  TaintedPathConfig() { this = "TaintedPathConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(PathCreation p).getAnInput()
    or
    sinkNode(sink, "create-file")
  }

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

/* TaintedPathCommon cannot be imported directly due to the hyphen in `CWE-022`. It is therefore copied here. */
/* Copied from java/ql/src/Security/CWE/CWE-022/TaintedPathCommon.qll */
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
