import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Networking

class TypeClient extends Interface {
  TypeClient() { hasQualifiedName("javax.ws.rs.client", "Client") }
}

class MethodAccessClient extends MethodAccess {
  MethodAccessClient() { getMethod().getDeclaringType() instanceof TypeClient }
}

class TypeUriBuilder extends Class {
  TypeUriBuilder() { hasQualifiedName("javax.ws.rs.core", "UriBuilder") }
}

class MethodAccessUriBuilder extends MethodAccess {
  MethodAccessUriBuilder() { getMethod().getDeclaringType() instanceof TypeUriBuilder }
}

class TypeLink extends Class {
  TypeLink() { hasQualifiedName("javax.ws.rs.core", "Link") }
}

class MethodAccessLink extends MethodAccess {
  MethodAccessLink() { getMethod().getDeclaringType() instanceof TypeLink }
}

class TypeLinkBuilder extends Interface {
  TypeLinkBuilder() { hasQualifiedName("javax.ws.rs.core", "Link$Builder") }
}

class MethodAccessLinkBuilder extends MethodAccess {
  MethodAccessLinkBuilder() { getMethod().getDeclaringType() instanceof TypeLinkBuilder }
}

class TypeWebTarget extends Interface {
  TypeWebTarget() { hasQualifiedName("javax.ws.rs.client", "WebTarget") }
}

class MethodAccessWebTarget extends MethodAccess {
  MethodAccessWebTarget() { getMethod().getDeclaringType() instanceof TypeWebTarget }
}

class TypeInvocationBuilder extends Interface {
  TypeInvocationBuilder() { hasQualifiedName("javax.ws.rs.client", "Invocation$Builder") }
}

class MethodAccessInvocationBuilder extends MethodAccess {
  MethodAccessInvocationBuilder() {
    getMethod().getDeclaringType() instanceof TypeInvocationBuilder
  }
}

class TypeInvocation extends Interface {
  TypeInvocation() { hasQualifiedName("javax.ws.rs.client", "Invocation") }
}

class MethodAccessInvocation extends MethodAccess {
  MethodAccessInvocation() { getMethod().getDeclaringType() instanceof TypeInvocation }
}

class TypeSyncInvoker extends Interface {
  TypeSyncInvoker() { hasQualifiedName("javax.ws.rs.client", "SyncInvoker") }
}

class TypeAsyncInvoker extends Interface {
  TypeAsyncInvoker() { hasQualifiedName("javax.ws.rs.client", "AsyncInvoker") }
}

class TypeRxInvoker extends ParameterizedInterface {
  TypeRxInvoker() { hasQualifiedName("javax.ws.rs.client", "RxInvoker") }
}

predicate taintStepCommon(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccessClient m, Expr arg |
    m.getMethod().getName() = "target" and
    m.getArgument(0) = arg and
    (
      // taints webTarget where `webTarget = client.target(taintedUri)`
      arg.getType() instanceof TypeUri
      or
      // taints webTarget where `webTarget = client.target(taintedUriBuilder)`
      arg.getType() instanceof TypeUriBuilder
      or
      // taints webTarget where `webTarget = client.target(taintedLink)`
      arg.getType() instanceof TypeLink
    ) and
    node1.asExpr() = arg and
    node2.asExpr() = m
  )
  or
  // taints webTarget where `webTarget = client.invocation(taintedLink)`
  exists(MethodAccessClient m |
    m.getMethod().getName() = "invocation" and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m
  )
  or
  // taints uriBuilder where `uriBuilder = UriBuilder.fromUri(taintedUri)`
  // taints uriBuilder where `uriBuilder = UriBuilder.fromLink(taintedLink)`
  exists(MethodAccessUriBuilder m, Expr arg |
    m.getMethod().getName() in ["fromUri", "fromLink"] and
    m.getArgument(0) = arg and
    not arg.getType() instanceof TypeString and
    node1.asExpr() = arg and
    node2.asExpr() = m
  )
  or
  // taints uriBuilder where `uriBuilder = taintedUriBuilder.methodName(...)`
  // if return type of method UriBuilder::methodName is UriBuilder
  // or methodName is any of {"build", "buildFromEncoded", "buildFromEncodedMap", "buildFromMap"}
  exists(MethodAccessUriBuilder m |
    (
      m.getMethod().getReturnType() instanceof TypeUriBuilder or
      m.getMethod().getName() in ["build", "buildFromEncoded", "buildFromEncodedMap", "buildFromMap"]
    ) and
    node1.asExpr() = m.getQualifier() and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessUriBuilder m |
    m.getMethod().getName() = "uri" and
    m.getArgument(0).getType() instanceof TypeUri and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessLink m, Expr arg |
    m.getMethod().getName() in ["fromLink", "fromUriBuilder", "fromUri"] and
    m.getArgument(0) = arg and
    not arg.getType() instanceof TypeString and
    node1.asExpr() = arg and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessLinkBuilder m |
    (
      m.getMethod().getReturnType() instanceof TypeLinkBuilder or
      m.getMethod().getName() in ["build", "buildRelativized"]
    ) and
    node1.asExpr() = m.getQualifier() and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessLinkBuilder m |
    m.getMethod().getName() = "buildRelativized" and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessLinkBuilder m, Expr arg |
    m.getMethod().getName() in ["link", "uri", "baseUri", "uriBuilder"] and
    m.getArgument(0) = arg and
    not arg.getType() instanceof TypeString and
    node1.asExpr() = arg and
    node2.asExpr() = m
  )
  or
  // taints invocationBuilder where `invocationBuilder = taintedWebTarget.request(...)`
  exists(MethodAccessWebTarget m |
    m.getMethod().getName() = "request" and
    node1.asExpr() = m.getQualifier() and
    node2.asExpr() = m
  )
  or
  // taints webTarget where `webTarget = taintedWebTarget.methodName(...)`
  // if return type of method WebTarget::methodName is WebTarget
  exists(MethodAccessWebTarget m |
    m.getMethod().getReturnType() instanceof TypeWebTarget and
    node1.asExpr() = m.getQualifier() and
    node2.asExpr() = m
  )
  or
  // taints uri where `uri = taintedWebTarget.getUri()` or
  // taints uriBuilder where `uriBuilder = taintedWebTarget.getUriBuilder()`
  exists(MethodAccessWebTarget m |
    m.getMethod().getName() in ["getUri", "getUriBuilder"] and
    node1.asExpr() = m.getQualifier() and
    node2.asExpr() = m
  )
  or
  // taints invocation where `invocation = taintedInvocationBuilder.methodName(...)`
  // methodName should be a value in set {build, buildGet, buildDelete, buildPost, buildPut}
  exists(MethodAccessInvocationBuilder m |
    m.getMethod().getName() in ["build", "buildGet", "buildDelete", "buildPost", "buildPut"] and
    node1.asExpr() = m.getQualifier() and
    node2.asExpr() = m
  )
  or
  // taints asyncInvoker where `asyncInvoker = taintedInvocationBuilder.async()` or
  // taints rxInvoker where `rxInvoker = taintedInvocationBuilder.rx(...)`
  exists(MethodAccessInvocationBuilder m |
    m.getMethod().getName() in ["async", "rx"] and
    node1.asExpr() = m.getQualifier() and
    node2.asExpr() = m
  )
  or
  // taints invocationBuilder where `invocationBuilder = taintedInvocationBuilder.methodName(...)`
  // if return type of emthod Invocation.Builder::methodName is Invocation.Builder
  exists(MethodAccessInvocationBuilder m |
    m.getMethod().getReturnType() instanceof TypeInvocationBuilder and
    node1.asExpr() = m.getQualifier()
  )
}

predicate unsafeURLHostFlowTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  taintStepCommon(node1, node2)
  or
  // taints uriBuilder where `uriBuilder = uriBuilder.host(taintedString)`
  exists(MethodAccessUriBuilder m |
    m.getMethod().getName() = "host" and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m
  )
}

predicate unsafeURLSpecFlowTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  taintStepCommon(node1, node2)
  or
  // taints webTarget where `webTarget = client.target(taintedString)`
  exists(MethodAccessClient m, Expr arg |
    m.getMethod().getName() = "target" and
    m.getArgument(0) = arg and
    arg.getType() instanceof TypeString and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m
  )
  or
  // taints uriBuilder where `uriBuilder = UriBuilder.fromPath(taintedString)`
  // taints uriBuilder where `uriBuilder = UriBuilder.fromUri(taintedString)`
  exists(MethodAccessUriBuilder m, Expr arg |
    m.getMethod().getName() in ["fromPath", "fromUri"] and
    arg = m.getArgument(0) and
    arg.getType() instanceof TypeString and
    node1.asExpr() = arg and
    node2.asExpr() = m
  )
  or
  // taints uriBuilder where `uriBuilder = uriBuilder.schemeSpecificPart(taintedString)`
  exists(MethodAccessUriBuilder m |
    m.getMethod().getName() = "schemeSpecificPart" and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessUriBuilder m |
    m.getMethod().getName() = "uri" and
    m.getArgument(0).getType() instanceof TypeString and
    node1.asExpr() = m.getArgument(0) and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessLink m, Expr arg |
    m.getMethod().getName() in ["fromPath", "fromUri"] and
    arg = m.getArgument(0) and
    arg.getType() instanceof TypeString and
    node1.asExpr() = arg and
    node2.asExpr() = m
  )
  or
  exists(MethodAccessLinkBuilder m, Expr arg |
    m.getMethod().getName() in ["link", "uri", "baseUri"] and
    m.getArgument(0) = arg and
    arg.getType() instanceof TypeString and
    node1.asExpr() = arg and
    node2.asExpr() = m
  )
}

predicate isUnsafeURLFlowSink(DataFlow::Node node) {
  exists(MethodAccess m, TypeSyncInvoker syncInvoker, TypeAsyncInvoker asyncInvoker |
    (
      // all methods defined in `javax.ws.rs.client.SyncInvoker`
      syncInvoker.hasMethod(m.getMethod(), syncInvoker)
      or
      // all methods defined in `javax.ws.rs.client.AsyncInvoker`
      asyncInvoker.hasMethod(m.getMethod(), asyncInvoker)
    ) and
    node.asExpr() = m.getQualifier()
  )
  or
  // all methods defined in `javax.ws.rs.client.RxInvoker`
  exists(MethodAccess m, Method override, TypeRxInvoker rxInvoker |
    m.getMethod().getSourceDeclaration().overrides*(override) and
    rxInvoker.getAMethod() = override.getSourceDeclaration() and
    node.asExpr() = m.getQualifier()
  )
  or
  // `invocation.invoke(...)` and `invocation.submit(...)`
  exists(MethodAccessInvocation m |
    m.getMethod().getName() in ["invoke", "submit"] and
    node.asExpr() = m.getQualifier()
  )
}
