/**
 * @name Failure to use HTTPS URLs
 * @description Non-HTTPS connections can be intercepted by third parties.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 5.2
 * @precision medium
 * @id java/non-https-url
 * @tags security
 *       external/cwe/cwe-319
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.frameworks.Networking
import DataFlow::PathGraph
private import semmle.code.java.dataflow.ExternalFlow

class HttpString extends StringLiteral {
  HttpString() {
    // Avoid matching "https" here.
    exists(string s | this.getRepresentedString() = s |
      (
        // Either the literal "http", ...
        s = "http"
        or
        // ... or the beginning of a http URL.
        s.matches("http://%")
      ) and
      not s.matches("%/localhost%")
    )
  }
}

class HttpStringToUrlOpenMethodFlowConfig extends TaintTracking::Configuration {
  HttpStringToUrlOpenMethodFlowConfig() { this = "HttpsUrls::HttpStringToUrlOpenMethodFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof HttpString }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UrlOpenSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(UrlConstructorCall u |
      node1.asExpr() = u.protocolArg() and
      node2.asExpr() = u
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

/**
 * A sink that represents a URL opening method call, such as a call to `java.net.URL.openConnection()`.
 */
private class UrlOpenSink extends DataFlow::Node {
  UrlOpenSink() { sinkNode(this, "open-url") }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, MethodAccess m, HttpString s
where
  source.getNode().asExpr() = s and
  sink.getNode().asExpr() = m.getQualifier() and
  any(HttpStringToUrlOpenMethodFlowConfig c).hasFlowPath(source, sink)
select m, source, sink, "URL may have been constructed with HTTP protocol, using $@.", s,
  "this source"
