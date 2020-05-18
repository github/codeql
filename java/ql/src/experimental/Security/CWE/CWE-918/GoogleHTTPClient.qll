import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Networking

class TypeHttpRequestFactory extends RefType {
  TypeHttpRequestFactory() { hasQualifiedName("com.google.api.client.http", "HttpRequestFactory") }
}

class MethodAccessHttpRequestFactory extends MethodAccess {
  MethodAccessHttpRequestFactory() { this.getMethod().getDeclaringType() instanceof TypeHttpRequestFactory }
}

class TypeHttpRequest extends RefType {
  TypeHttpRequest() { hasQualifiedName("com.google.api.client.http", "HttpRequest") }
}

class MethodAccessHttpRequest extends MethodAccess {
  MethodAccessHttpRequest() { this.getMethod().getDeclaringType() instanceof TypeHttpRequest }
}

class TypeGenericUrl extends RefType {
  TypeGenericUrl() { hasQualifiedName("com.google.api.client.http", "GenericUrl") }
}

class MethodAccessGenericUrl extends MethodAccess {
  MethodAccessGenericUrl() { this.getMethod().getDeclaringType() instanceof TypeGenericUrl }
}

class GenericUrlConstructor extends ClassInstanceExpr {
  GenericUrlConstructor() { this.getConstructedType() instanceof TypeGenericUrl }

  private Expr getTargetArg() {
    // GenericUrl(_)
    this.getNumArgument() = 1 and
    result = this.getArgument(0)
    or
    // GenericUrl(_, boolean verbatim)
    this.getNumArgument() = 2 and
    this.getArgument(1).getType() instanceof BooleanType and
    result = this.getArgument(0)
  }

  Expr encodedUrlArg() {
    // GenericUrl(String encodedUrl)
    // GenericUrl(String encodedUrl, boolean verbatim)
    result = any(Expr e | this.getTargetArg() = e and e.getType() instanceof TypeString)
  }

  Expr urlArg() {
    // GenericUrl(URL url)
    // GenericUrl(URL url, boolean verbatim)
    result = any(Expr e | this.getTargetArg() = e and e.getType() instanceof TypeUrl)
  }

  Expr uriArg() {
    // GenericUrl(URI uri)
    // GenericUrl(URI uri, boolean verbatim)
    result = any(Expr e | this.getTargetArg() = e and e.getType() instanceof TypeUri)
  }
}

private predicate taintStepCommon(DataFlow::Node node1, DataFlow::Node node2) {
  exists(GenericUrlConstructor c |
    (
      node1.asExpr() = c.urlArg()
      or
      node1.asExpr() = c.uriArg()
    ) and
    node2.asExpr() = c
  )
  or
  exists(MethodAccessHttpRequestFactory m |
    m.getMethod().getName() in ["buildDeleteRequest", "buildGetRequest", "buildPostRequest",
          "buildPutRequest", "buildPatchRequest", "buildHeadRequest"] and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessHttpRequestFactory m |
    m.getMethod().getName() = "buildRequest" and
    node1.asExpr() = m.getArgument(1) and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessHttpRequest m |
    m.getMethod().getName() = "setUrl" and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m.getQualifier()
  )
}

predicate unsafeURLHostFlowTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  taintStepCommon(node1, node2)
  or
  exists(MethodAccessGenericUrl m |
    m.getMethod().getName() = "setHost" and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m.getQualifier()
  )
}

predicate unsafeURLSpecFlowTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  taintStepCommon(node1, node2)
  or
  exists(GenericUrlConstructor c |
    node1.asExpr() = c.encodedUrlArg() and
    node2.asExpr() = c
  )
}

predicate isUnsafeURLFlowSink(DataFlow::Node node) {
  exists(MethodAccessHttpRequest m |
    node.asExpr() = m.getQualifier() and
    m.getMethod().getName() in ["execute", "executeAsync"]
  )
}
