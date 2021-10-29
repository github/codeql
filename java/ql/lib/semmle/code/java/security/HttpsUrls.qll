/** Provides classes and predicates to reason about plaintext HTTP vulnerabilities. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.frameworks.ApacheHttp
private import semmle.code.java.frameworks.Networking

/**
 * String of HTTP URLs not in private domains.
 */
class HttpStringLiteral extends StringLiteral {
  HttpStringLiteral() {
    exists(string s | this.getValue() = s |
      s = "http"
      or
      s.matches("http://%") and
      not s.substring(7, s.length()) instanceof PrivateHostName and
      not TaintTracking::localExprTaint(any(StringLiteral p |
          p.getValue() instanceof PrivateHostName
        ), this.getParent*())
    )
  }
}

/**
 * A sink that represents a URL opening method call, such as a call to `java.net.URL.openConnection()`.
 */
abstract class UrlOpenSink extends DataFlow::Node { }

private class DefaultUrlOpenSink extends UrlOpenSink {
  DefaultUrlOpenSink() { sinkNode(this, "open-url") }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply
 * to configurations working with HTTP URLs.
 */
class HttpUrlsAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for taint tracking configurations working with HTTP URLs.
   */
  abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
}

private class DefaultHttpUrlAdditionalTaintStep extends HttpUrlsAdditionalTaintStep {
  override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
    apacheHttpRequestStep(n1, n2) or
    createUriStep(n1, n2) or
    createUrlStep(n1, n2) or
    urlOpenStep(n1, n2)
  }
}

/** Constructor of `ApacheHttpRequest` */
private predicate apacheHttpRequestStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof ApacheHttpRequest and
    node2.asExpr() = cc and
    cc.getAnArgument() = node1.asExpr()
  )
}

/** `URI` methods */
private predicate createUriStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(UriConstructorCall cc |
    cc.getSchemeArg() = node1.asExpr() and
    node2.asExpr() = cc
  )
}

/** Constructors of `URL` */
private predicate createUrlStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(UrlConstructorCall cc |
    cc.getProtocolArg() = node1.asExpr() and
    node2.asExpr() = cc
  )
}

/** Method call of `HttpURLOpenMethod` */
private predicate urlOpenStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma |
    ma.getMethod() instanceof UrlOpenConnectionMethod and
    node1.asExpr() = ma.getQualifier() and
    ma = node2.asExpr()
  )
}
