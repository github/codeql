/** Provides a remote flow source for Android's `Activity.onActivityResult` method. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.DataFlow5
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
    exists(ImplicitStartActivityForResultConf conf, DataFlow::Node sink |
      conf.hasFlowTo(sink) and
      DataFlow::getInstanceArgument(sink.asExpr().(Argument).getCall()).getType() =
        this.getEnclosingCallable().getDeclaringType()
    )
  }
}

/**
 * A data flow configuration for implicit intents being used in `startActivityForResult`.
 */
private class ImplicitStartActivityForResultConf extends DataFlow5::Configuration {
  ImplicitStartActivityForResultConf() { this = "ImplicitStartActivityForResultConf" }

  override predicate isSource(DataFlow::Node source) {
    exists(ClassInstanceExpr cc |
      cc.getConstructedType() instanceof TypeIntent and source.asExpr() = cc
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(ActivityOrFragment actOrFrag, MethodAccess startActivityForResult |
      startActivityForResult.getMethod().hasName("startActivityForResult") and
      startActivityForResult.getEnclosingCallable() = actOrFrag.getACallable() and
      sink.asExpr() = startActivityForResult.getArgument(0)
    )
  }

  override predicate isBarrier(DataFlow::Node barrier) {
    barrier instanceof ExplicitIntentSanitizer
  }
}

/** An Android Activity or Fragment. */
private class ActivityOrFragment extends Class {
  ActivityOrFragment() {
    this instanceof AndroidActivity or
    this instanceof AndroidFragment
  }
}
