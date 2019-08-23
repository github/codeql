/**
 * Provides a taint-tracking configuration for reasoning about uncontrolled data in path expression
 * vulnerabilities.
 */

import csharp

module TaintedPath {
  import semmle.code.csharp.controlflow.Guards
  import semmle.code.csharp.dataflow.flowsources.Remote
  import semmle.code.csharp.frameworks.system.IO
  import semmle.code.csharp.frameworks.system.Web
  import semmle.code.csharp.security.Sanitizers

  /**
   * A data flow source for uncontrolled data in path expression vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for uncontrolled data in path expression vulnerabilities.
   */
  abstract class Sink extends DataFlow::ExprNode { }

  /**
   * A sanitizer for uncontrolled data in path expression vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::ExprNode { }

  /**
   * A guard for uncontrolled data in path expression vulnerabilities.
   */
  abstract class BarrierGuard extends DataFlow::BarrierGuard { }

  /**
   * A taint-tracking configuration for uncontrolled data in path expression vulnerabilities.
   */
  class TaintTrackingConfiguration extends TaintTracking::Configuration {
    TaintTrackingConfiguration() { this = "TaintedPath" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof BarrierGuard
    }
  }

  /** A source of remote user input. */
  class RemoteSource extends Source {
    RemoteSource() { this instanceof RemoteFlowSource }
  }

  /**
   * A path argument to a `File` method call.
   */
  class FileCreateSink extends Sink {
    FileCreateSink() {
      exists(Method create | create = any(SystemIOFileClass f).getAMethod() |
        this.getExpr() = create.getACall().getArgumentForName("path")
      )
    }
  }

  /**
   * A path argument to a `Directory` method call.
   */
  class DirectorySink extends Sink {
    DirectorySink() {
      exists(Method create | create = any(SystemIODirectoryClass f).getAMethod() |
        this.getExpr() = create.getACall().getArgumentForName("path")
      )
    }
  }

  /**
   * A path argument to a `FileStream` constructor call.
   */
  class FileStreamSink extends Sink {
    FileStreamSink() {
      exists(ObjectCreation oc |
        oc.getTarget().getDeclaringType() = any(SystemIOFileStreamClass f)
      |
        this.getExpr() = oc.getArgumentForName("path")
      )
    }
  }

  /**
   * A path argument to a `StreamWriter` constructor call.
   */
  class StreamWriterTaintedPathSink extends Sink {
    StreamWriterTaintedPathSink() {
      exists(ObjectCreation oc |
        oc.getTarget().getDeclaringType() = any(SystemIOStreamWriterClass f)
      |
        this.getExpr() = oc.getArgumentForName("path")
      )
    }
  }

  /**
   * A conditional involving the path, that is not considered to be a weak check.
   *
   * A weak check is one that is insufficient to prevent path tampering.
   */
  class PathCheck extends BarrierGuard {
    PathCheck() {
      // None of these are sufficient to guarantee that a string is safe.
      not this.(MethodCall).getTarget() = any(Method m |
          m.getName() = "StartsWith" or
          m.getName() = "EndsWith" or
          m.getName() = "IsNullOrEmpty" or
          m.getName() = "IsNullOrWhitespace" or
          m = any(SystemIOFileClass f).getAMethod("Exists") or
          m = any(SystemIODirectoryClass f).getAMethod("Exists")
        ) and
      // Checking against `null` has no bearing on path traversal.
      not this instanceof DataFlow::BarrierGuards::NullGuard and
      not this instanceof DataFlow::BarrierGuards::AntiNullGuard
    }

    override predicate checks(Expr e, AbstractValue v) { this.controlsNode(_, e, v) }
  }

  /**
   * A call to `HttpRequest.MapPath` that is considered to sanitize the input.
   */
  class RequestMapPathSanitizer extends Sanitizer {
    RequestMapPathSanitizer() {
      exists(Method m |
        m = any(SystemWebHttpRequestClass request).getAMethod() and
        m.hasName("MapPath")
      |
        this.getExpr() = m.getACall()
      )
    }
  }

  private class SimpleTypeSanitizer extends Sanitizer, SimpleTypeSanitizedExpr { }

  private class GuidSanitizer extends Sanitizer, GuidSanitizedExpr { }
}
