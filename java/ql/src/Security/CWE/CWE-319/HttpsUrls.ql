/**
 * @name Failure to use HTTPS URLs
 * @description Non-HTTPS connections can be intercepted by third parties.
 * @kind path-problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/non-https-url
 * @tags security
 *       external/cwe/cwe-319
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

class HTTPString extends StringLiteral {
  HTTPString() {
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

class URLConstructor extends ClassInstanceExpr {
  URLConstructor() { this.getConstructor().getDeclaringType().getQualifiedName() = "java.net.URL" }

  Expr protocolArg() {
    // In all cases except where the first parameter is a URL, the argument
    // containing the protocol is the first one, otherwise it is the second.
    if this.getConstructor().getParameter(0).getType().getName() = "URL"
    then result = this.getArgument(1)
    else result = this.getArgument(0)
  }
}

class URLOpenMethod extends Method {
  URLOpenMethod() {
    this.getDeclaringType().getQualifiedName() = "java.net.URL" and
    (
      this.getName() = "openConnection" or
      this.getName() = "openStream"
    )
  }
}

class HTTPStringToURLOpenMethodFlowConfig extends TaintTracking::Configuration {
  HTTPStringToURLOpenMethodFlowConfig() { this = "HttpsUrls::HTTPStringToURLOpenMethodFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src.asExpr() instanceof HTTPString }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess m |
      sink.asExpr() = m.getQualifier() and m.getMethod() instanceof URLOpenMethod
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(URLConstructor u |
      node1.asExpr() = u.protocolArg() and
      node2.asExpr() = u
    )
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, MethodAccess m, HTTPString s
where
  source.getNode().asExpr() = s and
  sink.getNode().asExpr() = m.getQualifier() and
  any(HTTPStringToURLOpenMethodFlowConfig c).hasFlowPath(source, sink)
select m, source, sink, "URL may have been constructed with HTTP protocol, using $@.", s,
  "this source"
