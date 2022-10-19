import java
private import experimental.semmle.code.java.frameworks.Jsf
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.StringPrefixes
private import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions
private import experimental.semmle.code.java.frameworks.SpringResource

/** A sink for unsafe URL forward vulnerabilities. */
abstract class UnsafeUrlForwardSink extends DataFlow::Node { }

/** A sanitizer for unsafe URL forward vulnerabilities. */
abstract class UnsafeUrlForwardSanitizer extends DataFlow::Node { }

/** An argument to `getRequestDispatcher`. */
private class RequestDispatcherSink extends UnsafeUrlForwardSink {
  RequestDispatcherSink() {
    exists(MethodAccess ma |
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
    sinkNode(this, "open-url")
    or
    sinkNode(this, "get-resource")
    or
    exists(MethodAccess ma |
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
    exists(MethodAccess ma |
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

/** Source model of remote flow source from `getServletPath`. */
private class ServletGetPathSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.servlet.http;HttpServletRequest;true;getServletPath;;;ReturnValue;remote;manual",
        "jakarta.servlet.http;HttpServletRequest;true;getServletPath;;;ReturnValue;remote;manual"
      ]
  }
}

/** Taint model related to `java.nio.file.Path` and `io.undertow.server.handlers.resource.Resource`. */
private class FilePathFlowStep extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.nio.file;Paths;true;get;;;Argument[0..1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;resolve;;;Argument[-1..0];ReturnValue;taint;manual",
        "java.nio.file;Path;true;normalize;;;Argument[-1];ReturnValue;taint;manual",
        "java.nio.file;Path;true;toString;;;Argument[-1];ReturnValue;taint;manual",
        "io.undertow.server.handlers.resource;Resource;true;getFile;;;Argument[-1];ReturnValue;taint;manual",
        "io.undertow.server.handlers.resource;Resource;true;getFilePath;;;Argument[-1];ReturnValue;taint;manual",
        "io.undertow.server.handlers.resource;Resource;true;getPath;;;Argument[-1];ReturnValue;taint;manual"
      ]
  }
}

/** Taint models related to resource loading in Spring. */
private class LoadSpringResourceFlowStep extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.core.io;ClassPathResource;false;ClassPathResource;;;Argument[0];Argument[-1];taint;manual",
        "org.springframework.core.io;ResourceLoader;true;getResource;;;Argument[0];ReturnValue;taint;manual",
        "org.springframework.core.io;Resource;true;createRelative;;;Argument[0];ReturnValue;taint;manual"
      ]
  }
}

/** Sink models for methods that load Spring resources. */
private class SpringResourceCsvSink extends SinkModelCsv {
  override predicate row(string row) {
    row =
      // Get spring resource
      "org.springframework.core.io;ClassPathResource;true;" +
        ["getFilename", "getPath", "getURL", "resolveURL"] + ";;;Argument[-1];get-resource;manual"
  }
}
