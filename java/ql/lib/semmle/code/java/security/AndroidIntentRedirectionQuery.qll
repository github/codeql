/** Provides taint tracking configurations to be used in Android Intent redirection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking3
import semmle.code.java.security.AndroidIntentRedirection

/**
 * A taint tracking configuration for tainted Intents being used to start Android components.
 */
class IntentRedirectionConfiguration extends TaintTracking::Configuration {
  IntentRedirectionConfiguration() { this = "IntentRedirectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof IntentRedirectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof IntentRedirectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(IntentRedirectionAdditionalTaintStep c).step(node1, node2)
  }
}

/**
 * A sanitizer for sinks that receive the original incoming Intent,
 * since its component cannot be arbitrarily set.
 */
private class OriginalIntentSanitizer extends IntentRedirectionSanitizer {
  OriginalIntentSanitizer() { any(SameIntentBeingRelaunchedConfiguration c).hasFlowTo(this) }
}

/**
 * Data flow configuration used to discard incoming Intents
 * flowing directly to sinks that start Android components.
 */
private class SameIntentBeingRelaunchedConfiguration extends DataFlow2::Configuration {
  SameIntentBeingRelaunchedConfiguration() { this = "SameIntentBeingRelaunchedConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof IntentRedirectionSink }

  override predicate isBarrier(DataFlow::Node barrier) {
    // Don't discard the Intent if its original component is tainted
    barrier instanceof IntentWithTaintedComponent
  }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Intents being built with the copy constructor from the original Intent are discarded too
    exists(ClassInstanceExpr cie |
      cie.getConstructedType() instanceof TypeIntent and
      node1.asExpr() = cie.getArgument(0) and
      node1.asExpr().getType() instanceof TypeIntent and
      node2.asExpr() = cie
    )
  }
}

/** An `Intent` with a tainted component. */
private class IntentWithTaintedComponent extends DataFlow::Node {
  IntentWithTaintedComponent() {
    exists(IntentSetComponent setExpr, TaintedIntentComponentConf conf |
      setExpr.getQualifier() = this.asExpr() and
      conf.hasFlowTo(DataFlow::exprNode(setExpr.getSink()))
    )
  }
}

/**
 * A taint tracking configuration for tainted data flowing to an `Intent`'s component.
 */
private class TaintedIntentComponentConf extends TaintTracking3::Configuration {
  TaintedIntentComponentConf() { this = "TaintedIntentComponentConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    any(IntentSetComponent setComponent).getSink() = sink.asExpr()
  }
}

/** A call to a method that changes the component of an `Intent`. */
private class IntentSetComponent extends MethodAccess {
  int sinkArg;

  IntentSetComponent() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof TypeIntent
    |
      m.hasName("setClass") and
      sinkArg = 1
      or
      m.hasName("setClassName") and
      exists(Parameter p |
        p = m.getAParameter() and
        p.getType() instanceof TypeString and
        sinkArg = p.getPosition()
      )
      or
      m.hasName("setComponent") and
      sinkArg = 0
      or
      m.hasName("setPackage") and
      sinkArg = 0
    )
  }

  Expr getSink() { result = this.getArgument(sinkArg) }
}
