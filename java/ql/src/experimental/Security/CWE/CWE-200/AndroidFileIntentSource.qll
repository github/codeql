/** Provides summary models relating to file content inputs of Android. */
deprecated module;

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
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
module GetContentIntentConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src.asExpr() instanceof GetContentIntent }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      ma.getMethod() instanceof StartActivityForResultMethod and sink.asExpr() = ma.getArgument(0)
    )
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet content) {
    // Allow the wrapped intent created by Intent.getChooser to be consumed
    // by at the sink:
    isSink(node) and
    allowIntentExtrasImplicitRead(node, content)
  }
}

module GetContentsIntentFlow = TaintTracking::Global<GetContentIntentConfig>;

/** A `GET_CONTENT` `Intent` instances that is passed to `startActivityForResult`. */
class AndroidFileIntentInput extends DataFlow::Node {
  MethodCall ma;

  AndroidFileIntentInput() {
    this.asExpr() = ma.getArgument(0) and
    ma.getMethod() instanceof StartActivityForResultMethod and
    exists(GetContentIntent gi |
      GetContentsIntentFlow::flow(DataFlow::exprNode(gi), DataFlow::exprNode(ma.getArgument(0)))
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
