/** Provides summary models relating to file content inputs of Android. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.frameworks.android.Android

/** The `startActivityForResult` method of Android's `Activity` class. */
class StartActivityForResultMethod extends Method {
  StartActivityForResultMethod() {
    this.getDeclaringType().getAnAncestor() instanceof AndroidActivity and
    this.getName() = "startActivityForResult"
  }
}

/** An instance of `android.content.Intent` constructed passing `GET_CONTENT` to the constructor. */
class GetContentIntent extends ClassInstanceExpr {
  GetContentIntent() {
    this.getConstructedType() instanceof TypeIntent and
    this.getArgument(0).(CompileTimeConstantExpr).getStringValue() =
      "android.intent.action.GET_CONTENT"
    or
    exists(Field f |
      this.getArgument(0) = f.getAnAccess() and
      f.hasName("ACTION_GET_CONTENT") and
      f.getDeclaringType() instanceof TypeIntent
    )
  }
}

/** Taint configuration that identifies `GET_CONTENT` `Intent` instances passed to `startActivityForResult`. */
class GetContentIntentConfig extends TaintTracking2::Configuration {
  GetContentIntentConfig() { this = "GetContentIntentConfig" }

  override predicate isSource(DataFlow2::Node src) { src.asExpr() instanceof GetContentIntent }

  override predicate isSink(DataFlow2::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof StartActivityForResultMethod and sink.asExpr() = ma.getArgument(0)
    )
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet content) {
    super.allowImplicitRead(node, content)
    or
    // Allow the wrapped intent created by Intent.getChooser to be consumed
    // by at the sink:
    this.isSink(node) and
    allowIntentExtrasImplicitRead(node, content)
  }
}

/** A `GET_CONTENT` `Intent` instances that is passed to `startActivityForResult`. */
class AndroidFileIntentInput extends DataFlow::Node {
  MethodAccess ma;

  AndroidFileIntentInput() {
    this.asExpr() = ma.getArgument(0) and
    ma.getMethod() instanceof StartActivityForResultMethod and
    exists(GetContentIntentConfig cc, GetContentIntent gi |
      cc.hasFlow(DataFlow::exprNode(gi), DataFlow::exprNode(ma.getArgument(0)))
    )
  }

  /** The request code passed to `startActivityForResult`, which is to be matched in `onActivityResult()`. */
  int getRequestCode() { result = ma.getArgument(1).(CompileTimeConstantExpr).getIntValue() }
}

/** The `onActivityForResult` method of Android `Activity` */
class OnActivityForResultMethod extends Method {
  OnActivityForResultMethod() {
    this.getDeclaringType().getAnAncestor() instanceof AndroidActivity and
    this.getName() = "onActivityResult"
  }
}
