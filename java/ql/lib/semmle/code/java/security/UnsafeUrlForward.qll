import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.StringPrefixes
private import semmle.code.java.frameworks.javaee.ejb.EJBRestrictions

/** A sink for unsafe URL forward vulnerabilities. */
abstract class UnsafeUrlForwardSink extends DataFlow::Node { }

/** A sanitizer for unsafe URL forward vulnerabilities. */
abstract class UnsafeUrlForwardSanitizer extends DataFlow::Node { }

/** A default sink representing methods susceptible to unsafe URL forwarding. */
private class DefaultUnsafeUrlForwardSink extends UnsafeUrlForwardSink {
  DefaultUnsafeUrlForwardSink() { sinkNode(this, "url-forward") }
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
