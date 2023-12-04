/** Provides classes to reason about URL forward attacks. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.StringPrefixes

/** A URL forward sink. */
abstract class UrlForwardSink extends DataFlow::Node { }

/**
 * A default sink representing methods susceptible to URL
 * forwarding attacks.
 */
private class DefaultUrlForwardSink extends UrlForwardSink {
  DefaultUrlForwardSink() { sinkNode(this, "url-forward") }
}

/**
 * An expression appended (perhaps indirectly) to `"forward:"`
 * and reachable from a Spring entry point.
 */
private class SpringUrlForwardSink extends UrlForwardSink {
  SpringUrlForwardSink() {
    any(SpringRequestMappingMethod srmm).polyCalls*(this.getEnclosingCallable()) and
    this.asExpr() = any(ForwardPrefix fp).getAnAppendedExpression()
  }
}

private class ForwardPrefix extends InterestingPrefix {
  ForwardPrefix() { this.getStringValue() = "forward:" }

  override int getOffset() { result = 0 }
}

/** A URL forward barrier. */
abstract class UrlForwardBarrier extends DataFlow::Node { }

private class PrimitiveBarrier extends UrlForwardBarrier {
  PrimitiveBarrier() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType
  }
}

private class FollowsBarrierPrefix extends UrlForwardBarrier {
  FollowsBarrierPrefix() { this.asExpr() = any(BarrierPrefix fp).getAnAppendedExpression() }
}

private class BarrierPrefix extends InterestingPrefix {
  BarrierPrefix() {
    // TODO: why not META-INF here as well? (and are `/` correct?)
    not this.getStringValue().matches("/WEB-INF/%") and
    not this.getStringValue() = "forward:"
  }

  override int getOffset() { result = 0 }
}
