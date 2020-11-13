import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.javase.Http
import semmle.code.java.dataflow.DataFlow

module RequestForgery {
  import RequestForgeryCustomizations::RequestForgery

  /**
   * A taint-tracking configuration for reasoning about request forgery.
   */
  class RequestForgeryRemoteConfiguration extends TaintTracking::Configuration {
    RequestForgeryRemoteConfiguration() { this = "Server Side Request Forgery" }

    override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      additionalStep(pred, succ)
    }
  }
}

predicate additionalStep(DataFlow::Node pred, DataFlow::Node succ) {
  // propagate to a URI when its host is assigned to
  exists(UriCreation c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
  or
  // propagate to a URL when its host is assigned to
  exists(UrlConstructor c | c.getHostArg() = pred.asExpr() | succ.asExpr() = c)
  or
  // propagate to a RequestEntity when its url is assigned to
  exists(MethodAccess m |
    m.getMethod().getDeclaringType() instanceof SpringRequestEntity and
    (
      m.getMethod().hasName(["get", "post", "head", "delete", "options", "patch", "put"]) and
      m.getArgument(0) = pred.asExpr() and
      m = succ.asExpr()
    )
    or
    m.getMethod().hasName("method") and
    m.getArgument(1) = pred.asExpr() and
    m = succ.asExpr()
  )
  or
  // propagate from a `RequestEntity<>$BodyBuilder` to a `RequestEntity`
  // when the builder is tainted
  exists(MethodAccess m, RefType t |
    m.getMethod().getDeclaringType() = t and
    t.hasQualifiedName("org.springframework.http", "RequestEntity<>$BodyBuilder") and
    m.getMethod().hasName("body") and
    m.getQualifier() = pred.asExpr() and
    m = succ.asExpr()
  )
}
