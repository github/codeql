/**
 * Provides a taint-tracking configuration for reasoning about uncontrolled data in path expression
 * vulnerabilities.
 */

import csharp
private import codeql.util.Unit
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.security.dataflow.flowsinks.FlowSinks
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources
private import semmle.code.csharp.frameworks.system.IO
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.security.Sanitizers

/**
 * A data flow source for uncontrolled data in path expression vulnerabilities.
 */
abstract class Source extends DataFlow::Node { }

/**
 * A data flow sink for uncontrolled data in path expression vulnerabilities.
 */
abstract class Sink extends ApiSinkExprNode { }

/**
 * A sanitizer for uncontrolled data in path expression vulnerabilities.
 */
abstract class Sanitizer extends DataFlow::ExprNode {
  /** Holds if this is a sanitizer when the flow state is `state`. */
  predicate isBarrier(TaintedPathConfig::FlowState state) { any() }
}

/** A path normalization step. */
private class PathNormalizationStep extends Unit {
  /**
   * Holds if the flow step from `n1` to `n2` transforms the path into an
   * absolute path.
   *
   * For example, the argument-to-return-value step through a call
   * to `System.IO.Path.GetFullPath` is a normalization step.
   */
  abstract predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2);
}

private class GetFullPathStep extends PathNormalizationStep {
  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      call.getARuntimeTarget().hasFullyQualifiedName("System.IO.Path", "GetFullPath") and
      n1.asExpr() = call.getArgument(0) and
      n2.asExpr() = call
    )
  }
}

/** Holds if `e` may evaluate to an absolute path. */
bindingset[e]
pragma[inline_late]
private predicate isAbsolute(Expr e) {
  exists(Expr absolute | DataFlow::localExprFlow(absolute, e) |
    exists(Call call | absolute = call |
      call.getARuntimeTarget()
          .hasFullyQualifiedName(["System.Web.HttpServerUtilityBase", "System.Web.HttpRequest"],
            "MapPath")
      or
      call.getARuntimeTarget().hasFullyQualifiedName("System.IO.Path", "GetFullPath")
      or
      call.getARuntimeTarget().hasFullyQualifiedName("System.IO.Directory", "GetCurrentDirectory")
    )
    or
    exists(PropertyRead read | absolute = read |
      read.getTarget().hasFullyQualifiedName("System", "Environment", "CurrentDirectory")
    )
  )
}

private class PathCombineStep extends PathNormalizationStep {
  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      // The result of `Path.Combine(x, y)` is an absolute path when `x` is an
      // absolute path.
      call.getARuntimeTarget().hasFullyQualifiedName("System.IO.Path", "Combine") and
      isAbsolute(call.getArgument(0)) and
      n1.asExpr() = call.getArgument(1) and
      n2.asExpr() = call
    )
  }
}

/**
 * A taint-tracking configuration for uncontrolled data in path expression vulnerabilities.
 */
private module TaintedPathConfig implements DataFlow::StateConfigSig {
  newtype FlowState =
    additional NotNormalized() or
    additional Normalized()

  predicate isSource(DataFlow::Node source, FlowState state) {
    source instanceof Source and state = NotNormalized()
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  predicate isSink(DataFlow::Node sink, FlowState state) { none() }

  predicate isAdditionalFlowStep(DataFlow::Node n1, FlowState s1, DataFlow::Node n2, FlowState s2) {
    any(PathNormalizationStep step).isAdditionalFlowStep(n1, n2) and
    s1 = NotNormalized() and
    s2 = Normalized()
  }

  predicate isBarrierOut(DataFlow::Node node, FlowState state) {
    isAdditionalFlowStep(_, state, node, _)
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * A taint-tracking module for uncontrolled data in path expression vulnerabilities.
 */
module TaintedPath = TaintTracking::GlobalWithState<TaintedPathConfig>;

/**
 * DEPRECATED: Use `ThreatModelSource` instead.
 *
 * A source of remote user input.
 */
deprecated class RemoteSource extends DataFlow::Node instanceof RemoteFlowSource { }

/** A source supported by the current threat model. */
class ThreatModelSource extends Source instanceof ActiveThreatModelSource { }

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
    exists(ObjectCreation oc | oc.getTarget().getDeclaringType() = any(SystemIOFileStreamClass f) |
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
 * A weak guard that may be insufficient to prevent path tampering.
 */
private class WeakGuard extends Guard {
  WeakGuard() {
    // None of these are sufficient to guarantee that a string is safe.
    exists(MethodCall mc, Method m | this = mc and mc.getTarget() = m |
      m.getName() = "StartsWith" or
      m.getName() = "EndsWith" or
      m.getName() = "IsNullOrEmpty" or
      m.getName() = "IsNullOrWhitespace" or
      m = any(SystemIOFileClass f).getAMethod("Exists") or
      m = any(SystemIODirectoryClass f).getAMethod("Exists")
    )
    or
    // Checking against `null` has no bearing on path traversal.
    this.controlsNode(_, _, any(AbstractValues::NullValue nv))
    or
    this.(LogicalOperation).getAnOperand() instanceof WeakGuard
  }

  predicate isBarrier(TaintedPathConfig::FlowState state) {
    state = TaintedPathConfig::Normalized() and
    exists(Method m | this.(MethodCall).getTarget() = m |
      m.getName() = "StartsWith" or
      m.getName() = "EndsWith"
    )
  }
}

/**
 * A conditional involving the path, that is not considered to be a weak check.
 *
 * A weak check is one that is insufficient to prevent path tampering.
 */
class PathCheck extends Sanitizer {
  Guard g;

  PathCheck() {
    // This expression is structurally replicated in a dominating guard
    exists(AbstractValues::BooleanValue v | g = this.(GuardedDataFlowNode).getAGuard(_, v))
  }

  override predicate isBarrier(TaintedPathConfig::FlowState state) {
    g.(WeakGuard).isBarrier(state)
    or
    not g instanceof WeakGuard
  }
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
