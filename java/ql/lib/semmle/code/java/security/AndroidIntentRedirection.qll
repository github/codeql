/** Provides classes to reason about Android Intent redirect vulnerabilities. */

import java
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.frameworks.android.Intent

/**
 * A sink for Intent redirection vulnerabilities in Android,
 * that is, method calls that start Android components (like activities or services).
 */
abstract class IntentRedirectionSink extends DataFlow::Node { }

/** A sanitizer for data used to start an Android component. */
abstract class IntentRedirectionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to `IntentRedirectionConfiguration`.
 */
class IntentRedirectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `IntentRedirectionConfiguration` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** Default sink for Intent redirection vulnerabilities. */
private class DefaultIntentRedirectionSink extends IntentRedirectionSink {
  DefaultIntentRedirectionSink() { sinkNode(this, "intent-redirection") }
}

/**
 * A default sanitizer for `Intent` nodes dominated by calls to `ComponentName.getPackageName`
 * and `ComponentName.getClassName`. These are used to check whether the origin or destination
 * components are trusted.
 */
private class DefaultIntentRedirectionSanitizer extends IntentRedirectionSanitizer {
  DefaultIntentRedirectionSanitizer() {
    this.getType() instanceof TypeIntent and
    exists(MethodCall ma, Method m, Guard g, boolean branch |
      ma.getMethod() = m and
      m.getDeclaringType() instanceof TypeComponentName and
      m.hasName("getPackageName") and
      g.isEquality(ma, _, branch) and
      g.controls(this.asExpr().getBasicBlock(), branch)
    ) and
    exists(MethodCall ma, Method m, Guard g, boolean branch |
      ma.getMethod() = m and
      m.getDeclaringType() instanceof TypeComponentName and
      m.hasName("getClassName") and
      g.isEquality(ma, _, branch) and
      g.controls(this.asExpr().getBasicBlock(), branch)
    )
  }
}
