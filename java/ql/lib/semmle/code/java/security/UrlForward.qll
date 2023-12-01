/** Provides classes to reason about URL forward attacks. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.StringPrefixes

/** A URL forward sink. */
abstract class UrlForwardSink extends DataFlow::Node { }

/** A default sink representing methods susceptible to URL forwarding attacks. */
private class DefaultUrlForwardSink extends UrlForwardSink {
  DefaultUrlForwardSink() { sinkNode(this, "url-forward") }
}

/**
 * An expression appended (perhaps indirectly) to `"forward:"`, and which
 * is reachable from a Spring entry point.
 */
private class SpringUrlForwardSink extends UrlForwardSink {
  SpringUrlForwardSink() {
    // TODO: check if can use MaD "Annotated" for `SpringRequestMappingMethod` or if too complicated for MaD (probably too complicated).
    any(SpringRequestMappingMethod sqmm).polyCalls*(this.getEnclosingCallable()) and
    this.asExpr() = any(ForwardPrefix fp).getAnAppendedExpression()
  }
}

// TODO: should this potentially be "include:" as well? Or does that not work similarly?
private class ForwardPrefix extends InterestingPrefix {
  ForwardPrefix() { this.getStringValue() = "forward:" }

  override int getOffset() { result = 0 }
}

/** A URL forward sanitizer. */
abstract class UrlForwardSanitizer extends DataFlow::Node { }

private class PrimitiveSanitizer extends UrlForwardSanitizer {
  PrimitiveSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType
  }
}

// TODO: double-check this sanitizer (and should I switch all "sanitizer" naming to "barrier" instead?)
private class FollowsSanitizingPrefix extends UrlForwardSanitizer {
  FollowsSanitizingPrefix() { this.asExpr() = any(SanitizingPrefix fp).getAnAppendedExpression() }
}

private class SanitizingPrefix extends InterestingPrefix {
  SanitizingPrefix() {
    not this.getStringValue().matches("/WEB-INF/%") and
    not this.getStringValue() = "forward:"
  }

  override int getOffset() { result = 0 }
}
