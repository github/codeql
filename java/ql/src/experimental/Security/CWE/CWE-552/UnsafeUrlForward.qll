import java
private import experimental.semmle.code.java.frameworks.Jsf
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.StringPrefixes
private import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions
private import experimental.semmle.code.java.frameworks.SpringResource

private class ActiveModels extends ActiveExperimentalModels {
  ActiveModels() { this = "unsafe-url-forward" }
}

/** A sink for unsafe URL forward vulnerabilities. */
abstract class UnsafeUrlForwardSink extends DataFlow::Node { }

/** A sanitizer for unsafe URL forward vulnerabilities. */
abstract class UnsafeUrlForwardSanitizer extends DataFlow::Node { }

/** An argument to `getRequestDispatcher`. */
private class RequestDispatcherSink extends UnsafeUrlForwardSink {
  RequestDispatcherSink() {
    exists(MethodCall ma |
      ma.getMethod() instanceof GetRequestDispatcherMethod and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/** The `getResource` method of `Class`. */
class GetClassResourceMethod extends Method {
  GetClassResourceMethod() {
    this.getDeclaringType() instanceof TypeClass and
    this.hasName("getResource")
  }
}

/** The `getResourceAsStream` method of `Class`. */
class GetClassResourceAsStreamMethod extends Method {
  GetClassResourceAsStreamMethod() {
    this.getDeclaringType() instanceof TypeClass and
    this.hasName("getResourceAsStream")
  }
}

/** The `getResource` method of `ClassLoader`. */
class GetClassLoaderResourceMethod extends Method {
  GetClassLoaderResourceMethod() {
    this.getDeclaringType() instanceof ClassLoaderClass and
    this.hasName("getResource")
  }
}

/** The `getResourceAsStream` method of `ClassLoader`. */
class GetClassLoaderResourceAsStreamMethod extends Method {
  GetClassLoaderResourceAsStreamMethod() {
    this.getDeclaringType() instanceof ClassLoaderClass and
    this.hasName("getResourceAsStream")
  }
}

/** The JBoss class `FileResourceManager`. */
class FileResourceManager extends RefType {
  FileResourceManager() {
    this.hasQualifiedName("io.undertow.server.handlers.resource", "FileResourceManager")
  }
}

/** The JBoss method `getResource` of `FileResourceManager`. */
class GetWildflyResourceMethod extends Method {
  GetWildflyResourceMethod() {
    this.getDeclaringType().getASupertype*() instanceof FileResourceManager and
    this.hasName("getResource")
  }
}

/** The JBoss class `VirtualFile`. */
class VirtualFile extends RefType {
  VirtualFile() { this.hasQualifiedName("org.jboss.vfs", "VirtualFile") }
}

/** The JBoss method `getChild` of `FileResourceManager`. */
class GetVirtualFileChildMethod extends Method {
  GetVirtualFileChildMethod() {
    this.getDeclaringType().getASupertype*() instanceof VirtualFile and
    this.hasName("getChild")
  }
}

/** An argument to `getResource()` or `getResourceAsStream()`. */
private class GetResourceSink extends UnsafeUrlForwardSink {
  GetResourceSink() {
    sinkNode(this, "request-forgery")
    or
    sinkNode(this, "get-resource")
    or
    exists(MethodCall ma |
      (
        ma.getMethod() instanceof GetServletResourceAsStreamMethod or
        ma.getMethod() instanceof GetFacesResourceAsStreamMethod or
        ma.getMethod() instanceof GetClassResourceAsStreamMethod or
        ma.getMethod() instanceof GetClassLoaderResourceAsStreamMethod or
        ma.getMethod() instanceof GetVirtualFileChildMethod
      ) and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/** A sink for methods that load Spring resources. */
private class SpringResourceSink extends UnsafeUrlForwardSink {
  SpringResourceSink() {
    exists(MethodCall ma |
      ma.getMethod() instanceof GetResourceUtilsMethod and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/** An argument to `new ModelAndView` or `ModelAndView.setViewName`. */
private class SpringModelAndViewSink extends UnsafeUrlForwardSink {
  SpringModelAndViewSink() {
    exists(ClassInstanceExpr cie |
      cie.getConstructedType() instanceof ModelAndView and
      cie.getArgument(0) = this.asExpr()
    )
    or
    exists(SpringModelAndViewSetViewNameCall smavsvnc | smavsvnc.getArgument(0) = this.asExpr())
  }
}

private class PrimitiveSanitizer extends UnsafeUrlForwardSanitizer {
  PrimitiveSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType
  }
}

private class SanitizingPrefix extends InterestingPrefix {
  SanitizingPrefix() {
    not this.getStringValue().matches("/WEB-INF/%") and
    not this.getStringValue() = "forward:"
  }

  override int getOffset() { result = 0 }
}

private class FollowsSanitizingPrefix extends UnsafeUrlForwardSanitizer {
  FollowsSanitizingPrefix() { this.asExpr() = any(SanitizingPrefix fp).getAnAppendedExpression() }
}

private class ForwardPrefix extends InterestingPrefix {
  ForwardPrefix() { this.getStringValue() = "forward:" }

  override int getOffset() { result = 0 }
}

/**
 * An expression appended (perhaps indirectly) to `"forward:"`, and which
 * is reachable from a Spring entry point.
 */
private class SpringUrlForwardSink extends UnsafeUrlForwardSink {
  SpringUrlForwardSink() {
    any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable()) and
    this.asExpr() = any(ForwardPrefix fp).getAnAppendedExpression()
  }
}
