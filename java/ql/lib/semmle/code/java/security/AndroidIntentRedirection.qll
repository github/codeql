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

private class DefaultIntentRedirectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.app;Activity;true;bindService;;;Argument[0];intent-start",
        "android.app;Activity;true;bindServiceAsUser;;;Argument[0];intent-start",
        "android.app;Activity;true;startActivityAsCaller;;;Argument[0];intent-start",
        "android.app;Activity;true;startActivityForResult;(Intent,int);;Argument[0];intent-start",
        "android.app;Activity;true;startActivityForResult;(Intent,int,Bundle);;Argument[0];intent-start",
        "android.app;Activity;true;startActivityForResult;(String,Intent,int,Bundle);;Argument[1];intent-start",
        "android.app;Activity;true;startActivityForResultAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;startActivities;;;Argument[0];intent-start",
        "android.content;Context;true;startActivity;;;Argument[0];intent-start",
        "android.content;Context;true;startActivityAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;startActivityFromChild;;;Argument[1];intent-start",
        "android.content;Context;true;startActivityFromFragment;;;Argument[1];intent-start",
        "android.content;Context;true;startActivityIfNeeded;;;Argument[0];intent-start",
        "android.content;Context;true;startForegroundService;;;Argument[0];intent-start",
        "android.content;Context;true;startService;;;Argument[0];intent-start",
        "android.content;Context;true;startServiceAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;sendBroadcast;;;Argument[0];intent-start",
        "android.content;Context;true;sendBroadcastAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;sendBroadcastWithMultiplePermissions;;;Argument[0];intent-start",
        "android.content;Context;true;sendStickyBroadcast;;;Argument[0];intent-start",
        "android.content;Context;true;sendStickyBroadcastAsUser;;;Argument[0];intent-start",
        "android.content;Context;true;sendStickyOrderedBroadcast;;;Argument[0];intent-start",
        "android.content;Context;true;sendStickyOrderedBroadcastAsUser;;;Argument[0];intent-start"
      ]
  }
}

/** Default sink for Intent redirection vulnerabilities. */
private class DefaultIntentRedirectionSink extends IntentRedirectionSink {
  DefaultIntentRedirectionSink() { sinkNode(this, "intent-start") }
}

/**
 * A default sanitizer for nodes dominated by calls to `ComponentName.getPackageName`
 * or `ComponentName.getClassName`. These are used to check whether the origin or destination
 * components are trusted.
 */
private class DefaultIntentRedirectionSanitizer extends IntentRedirectionSanitizer {
  DefaultIntentRedirectionSanitizer() {
    exists(MethodAccess ma, Method m, Guard g, boolean branch |
      ma.getMethod() = m and
      m.getDeclaringType() instanceof TypeComponentName and
      m.hasName(["getPackageName", "getClassName"]) and
      g.isEquality(ma, _, branch) and
      g.controls(this.asExpr().getBasicBlock(), branch)
    )
  }
}
