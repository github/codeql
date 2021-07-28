/** Provides classes to reason about Androind Intent redirect vulnerabilities. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.frameworks.android.Intent

/**
 * A sink for Intent redirect vulnerabilities in Android,
 * that is, method calls that start Android components (like activities or services).
 */
abstract class IntentRedirectSink extends DataFlow::Node { }

/** A sanitizer for data used to start an Android component. */
abstract class IntentRedirectSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to `IntentRedirectConfiguration`.
 */
class IntentRedirectAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** Default sink for Intent redirect vulnerabilities. */
private class DefaultIntentRedirectSink extends IntentRedirectSink {
  DefaultIntentRedirectSink() {
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      this.asExpr() = ma.getAnArgument() and
      (
        this.asExpr().getType() instanceof TypeIntent
        or
        this.asExpr().getType().(Array).getComponentType() instanceof TypeIntent
      )
    |
      m instanceof StartActivityMethod or
      m instanceof StartServiceMethod or
      m instanceof SendBroadcastMethod
    )
  }
}
