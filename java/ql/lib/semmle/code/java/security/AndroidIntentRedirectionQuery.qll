/** Provides taint tracking configurations to be used in Android Intent redirection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.security.AndroidIntentRedirection

/**
 * Holds if taint may flow from `source` to `sink` for `IntentRedirectionConfiguration`.
 *
 * It ensures that `ChangeIntentComponent` is an intermediate step in the flow.
 */
predicate hasIntentRedirectionFlowPath(DataFlow::PathNode source, DataFlow::PathNode sink) {
  exists(IntentRedirectionConfiguration conf, DataFlow::PathNode intermediate |
    intermediate.getNode().(ChangeIntentComponent).hasFlowFrom(source.getNode()) and
    conf.hasFlowPath(intermediate, sink)
  )
}

/**
 * A taint tracking configuration for tainted Intents being used to start Android components.
 */
private class IntentRedirectionConfiguration extends TaintTracking::Configuration {
  IntentRedirectionConfiguration() { this = "IntentRedirectionConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    exists(ChangeIntentComponent c |
      c = source
      or
      // This is needed for PathGraph to be able to build the full flow
      c.hasFlowFrom(source)
    )
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof IntentRedirectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof IntentRedirectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(IntentRedirectionAdditionalTaintStep c).step(node1, node2)
  }
}

/** An expression modifying an `Intent` component with tainted data. */
private class ChangeIntentComponent extends DataFlow::Node {
  DataFlow::Node src;

  ChangeIntentComponent() {
    changesIntentComponent(this.asExpr()) and
    exists(TaintedIntentComponentConf conf | conf.hasFlow(src, this))
  }

  /** Holds if `source` flows to `this`. */
  predicate hasFlowFrom(DataFlow::Node source) { source = src }
}

/**
 * A taint tracking configuration for tainted data flowing to an `Intent`'s component.
 */
private class TaintedIntentComponentConf extends TaintTracking2::Configuration {
  TaintedIntentComponentConf() { this = "TaintedIntentComponentConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { changesIntentComponent(sink.asExpr()) }
}

/** Holds if `expr` modifies the component of an `Intent`. */
private predicate changesIntentComponent(Expr expr) {
  any(IntentGetParcelableExtra igpe) = expr or
  any(IntentSetComponent isc).getSink() = expr
}

/** A call to the method `Intent.getParcelableExtra`. */
private class IntentGetParcelableExtra extends MethodAccess {
  IntentGetParcelableExtra() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() instanceof TypeIntent and
      m.hasName("getParcelableExtra")
    )
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
