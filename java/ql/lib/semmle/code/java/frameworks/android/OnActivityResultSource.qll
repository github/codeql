/** Provides a remote flow source for Android's `Activity.onActivityResult` method. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.frameworks.android.Android
private import semmle.code.java.frameworks.android.Fragment
private import semmle.code.java.frameworks.android.Intent

/**
 * The data Intent parameter in the `onActivityResult` method.
 */
class OnActivityResultIncomingIntent extends DataFlow::Node {
  OnActivityResultIncomingIntent() {
    exists(Method onActivityResult |
      onActivityResult.getDeclaringType() instanceof ActivityOrFragment and
      onActivityResult.hasName("onActivityResult") and
      this.asParameter() = onActivityResult.getParameter(2)
    )
  }

  /**
   * Holds if this node is a remote flow source.
   *
   * This is only a source when the Activity or Fragment that implements `onActivityResult` is
   * also using an implicit Intent to start another Activity with `startActivityForResult`. This
   * means that a malicious application can intercept it to start itself and return an arbitrary
   * Intent to `onActivityResult`.
   */
  predicate isRemoteSource() {
    exists(RefType startingType, Expr startActivityForResultArg |
      ImplicitStartActivityForResult::flowToExpr(startActivityForResultArg) and
      // startingType is the class enclosing the method that calls `startActivityForResult`.
      startingType = startActivityForResultArg.getEnclosingCallable().getDeclaringType()
    |
      // startingType itself defines an `onActivityResult` method:
      startingType = this.getEnclosingCallable().getDeclaringType()
      or
      // A fragment calls `startActivityForResult`
      // and the activity it belongs to defines `onActivityResult`.
      exists(MethodCall ma |
        ma.getMethod().hasName(["add", "attach", "replace"]) and
        ma.getMethod()
            .getDeclaringType()
            .hasQualifiedName(["android.app", "android.support.v4.app", "androidx.fragment.app"],
              "FragmentTransaction") and
        ma.getAnArgument().getType() = startingType
        or
        ma.getMethod().hasName("show") and
        ma.getMethod()
            .getDeclaringType()
            .getAnAncestor()
            .hasQualifiedName(["android.app", "android.support.v4.app", "androidx.fragment.app"],
              "DialogFragment") and
        startingType = ma.getQualifier().getType()
      |
        ma.getEnclosingCallable().getDeclaringType() =
          this.getEnclosingCallable().getDeclaringType()
      )
    )
  }
}

/**
 * A data flow configuration for implicit intents being used in `startActivityForResult`.
 */
private module ImplicitStartActivityForResultConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(ClassInstanceExpr cc |
      cc.getConstructedType() instanceof TypeIntent and source.asExpr() = cc
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall startActivityForResult |
      startActivityForResult.getMethod().hasName("startActivityForResult") and
      startActivityForResult.getMethod().getDeclaringType().getAnAncestor() instanceof
        ActivityOrFragment and
      sink.asExpr() = startActivityForResult.getArgument(0)
    )
  }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof ExplicitIntentSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Wrapping the Intent in a chooser
    exists(MethodCall ma, Method m |
      ma.getMethod() = m and
      m.hasName("createChooser") and
      m.getDeclaringType() instanceof TypeIntent
    |
      node1.asExpr() = ma.getArgument(0) and
      node2.asExpr() = ma
    )
    or
    // Using the copy constructor
    exists(ClassInstanceExpr cie |
      cie.getConstructedType() instanceof TypeIntent and
      cie.getArgument(0).getType() instanceof TypeIntent
    |
      node1.asExpr() = cie.getArgument(0) and
      node2.asExpr() = cie
    )
  }
}

private module ImplicitStartActivityForResult =
  DataFlow::Global<ImplicitStartActivityForResultConfig>;

/** An Android Activity or Fragment. */
private class ActivityOrFragment extends Class {
  ActivityOrFragment() {
    this instanceof AndroidActivity or
    this instanceof AndroidFragment
  }
}
