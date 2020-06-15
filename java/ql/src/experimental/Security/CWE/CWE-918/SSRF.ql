/**
 * @name Open URLs created from remote source
 * @description Mishandling of malicious URLs makes an application to interact with the internal/external network or the machine itself, which discloses sensitive information or enables further attacks.
 * @kind path-problem
 * @tags security
 *       external/cwe/cwe-918
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class URLConstructor extends ClassInstanceExpr {
  URLConstructor() { this.getConstructor().getDeclaringType() instanceof TypeUrl }

  Expr stringArg() {
    // Query only in URL's that were constructed by calling the single parameter string constructor.
    this.getConstructor().getNumberOfParameters() = 1 and
    this.getConstructor().getParameter(0).getType() instanceof TypeString and
    result = this.getArgument(0)
  }
}

/** The type `org.apache.http.message.BasicHttpEntityEnclosingRequest` and "org.apache.http.message.BasicHttpRequest". */
class TypeApacheHttpRequest extends RefType {
  TypeApacheHttpRequest() {
    hasQualifiedName("org.apache.http.message", "BasicHttpEntityEnclosingRequest") or
    hasQualifiedName("org.apache.http.message", "BasicHttpRequest")
  }
}

/** Constructor call of Apache HttpRequest */
class ApacheHttpRequestConstructor extends ClassInstanceExpr {
  ApacheHttpRequestConstructor() {
    this.getConstructor().getDeclaringType() instanceof TypeApacheHttpRequest
  }
}

/** Open URL methods of `java.net.URL` */
class URLOpenMethod extends Method {
  URLOpenMethod() {
    this.getDeclaringType() instanceof TypeUrl and
    (
      this.getName() = "openConnection" or
      this.getName() = "openStream"
    )
  }
}

class RemoteInputToURLOpenMethodFlowConfig extends TaintTracking::Configuration {
  RemoteInputToURLOpenMethodFlowConfig() { this = "SSRF::RemoteInputToURLOpenMethodFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      sink.asExpr() = ma.getQualifier() and
      ma.getMethod() instanceof URLOpenMethod
    )
    or
    exists(ApacheHttpRequestConstructor cc | sink.asExpr() = cc.getAnArgument())
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(URLConstructor u |
      node1.asExpr() = u.stringArg() and
      node2.asExpr() = u
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, RemoteInputToURLOpenMethodFlowConfig c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "URL constructed from remote source $@ ", source.getNode(),
  "could be vulnerable to SSRF attack"
