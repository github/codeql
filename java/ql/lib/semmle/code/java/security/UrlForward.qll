/** Provides classes to reason about URL forward attacks. */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.StringPrefixes
private import semmle.code.java.security.PathSanitizer
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.security.Sanitizers

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

private class PrimitiveBarrier extends UrlForwardBarrier instanceof SimpleTypeSanitizer { }

// TODO: should this also take URL encoding/decoding into account?
// TODO: and PathSanitization in general?
private class FollowsBarrierPrefix extends UrlForwardBarrier {
  FollowsBarrierPrefix() { this.asExpr() = any(BarrierPrefix fp).getAnAppendedExpression() }
}

private class BarrierPrefix extends InterestingPrefix {
  BarrierPrefix() {
    not this.getStringValue().matches("/WEB-INF/%") and
    not this.getStringValue() = "forward:"
  }

  override int getOffset() { result = 0 }
}

private class UrlPathBarrier extends UrlForwardBarrier {
  UrlPathBarrier() {
    this instanceof PathInjectionSanitizer and
    (
      this instanceof ExactPathMatchSanitizer //TODO: still need a better solution for this edge case...
      or
      // TODO: these don't enforce order of checks and PathSanitization... make bypass test cases.
      this instanceof NoEncodingBarrier
      or
      this instanceof FullyDecodesBarrier
    )
  }
}

abstract class UrlDecodeCall extends MethodCall { }

private class DefaultUrlDecodeCall extends UrlDecodeCall {
  DefaultUrlDecodeCall() {
    this.getMethod().hasQualifiedName("java.net", "URLDecoder", "decode") or // TODO: reuse existing class? Or make this a class?
    this.getMethod().hasQualifiedName("org.eclipse.jetty.util.URIUtil", "URIUtil", "decodePath")
  }
}

// TODO: this can probably be named/designed better...
abstract class RepeatedStmt extends Stmt { }

private class DefaultRepeatedStmt extends RepeatedStmt instanceof LoopStmt { }

abstract class CheckEncodingCall extends MethodCall { }

private class DefaultCheckEncodingCall extends CheckEncodingCall {
  DefaultCheckEncodingCall() {
    // TODO: indexOf?, etc.
    this.getMethod().hasQualifiedName("java.lang", "String", "contains") and // TODO: reuse existing class? Or make this a class?
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() = "%"
  }
}

// TODO: better naming?
// TODO: check if any URL decoding implementations _fully_ decode... or if all need to be called in a loop?
// TODO: make this extendable instead of `RepeatedStmt`?
private class RepeatedUrlDecodeCall extends MethodCall {
  RepeatedUrlDecodeCall() {
    this instanceof UrlDecodeCall and
    this.getAnEnclosingStmt() instanceof RepeatedStmt
  }
}

private class CheckEncodingGuard extends Guard instanceof MethodCall, CheckEncodingCall {
  Expr getCheckedExpr() { result = this.(MethodCall).getQualifier() }
}

private predicate noEncodingGuard(Guard g, Expr e, boolean branch) {
  g instanceof CheckEncodingGuard and
  e = g.(CheckEncodingGuard).getCheckedExpr() and
  branch = false
  or
  // branch = false and
  // g instanceof AssignExpr and // AssignExpr
  // exists(CheckEncodingCall call | g.(AssignExpr).getSource() = call | e = call.getQualifier())
  branch = false and
  g.(Expr).getType() instanceof BooleanType and // AssignExpr
  (
    exists(CheckEncodingCall call, AssignExpr ae |
      ae.getSource() = call and
      e = call.getQualifier() and
      g = ae.getDest()
    )
    or
    exists(CheckEncodingCall call, LocalVariableDeclExpr vde |
      vde.getInitOrPatternSource() = call and
      e = call.getQualifier() and
      g = vde.getAnAccess() //and
      //vde.getVariable() = g
    )
  )
}

// TODO: check edge case of !contains(%), make sure that behaves as expected at least.
private class NoEncodingBarrier extends DataFlow::Node {
  NoEncodingBarrier() { this = DataFlow::BarrierGuard<noEncodingGuard/3>::getABarrierNode() }
}

private predicate fullyDecodesGuard(Expr e) {
  exists(CheckEncodingGuard g, RepeatedUrlDecodeCall decodeCall |
    e = g.getCheckedExpr() and
    g.controls(decodeCall.getBasicBlock(), true)
  )
}

private class FullyDecodesBarrier extends DataFlow::Node {
  FullyDecodesBarrier() {
    exists(Variable v, Expr e | this.asExpr() = v.getAnAccess() |
      fullyDecodesGuard(e) and
      e = v.getAnAccess() and
      e.getBasicBlock().bbDominates(this.asExpr().getBasicBlock())
    )
  }
}
