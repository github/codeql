/** Provides summary models relating to file content inputs of Android. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.frameworks.android.Android

/** The `startActivityForResult` method of Android `Activity`. */
class StartActivityForResultMethod extends Method {
  StartActivityForResultMethod() {
    this.getDeclaringType().getASupertype*() instanceof AndroidActivity and
    this.getName() = "startActivityForResult"
  }
}

/** Android class instance of `GET_CONTENT` intent. */
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

/** Taint configuration for getting content intent. */
class GetContentIntentConfig extends TaintTracking2::Configuration {
  GetContentIntentConfig() { this = "GetContentIntentConfig" }

  override predicate isSource(DataFlow2::Node src) {
    exists(GetContentIntent gi | src.asExpr() = gi)
  }

  override predicate isSink(DataFlow2::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof StartActivityForResultMethod and sink.asExpr() = ma.getArgument(0)
    )
  }

  override predicate allowImplicitRead(DataFlow::Node node, DataFlow::Content content) {
    super.allowImplicitRead(node, content)
    or
    // Allow the wrapped intent created by Intent.getChooser to be consumed
    // by at the sink:
    isSink(node) and
    (
      content.(DataFlow::SyntheticFieldContent).getField() = "android.content.Intent.extras"
      or
      content instanceof DataFlow::MapValueContent
    )
  }
}

/** Android `Intent` input to request file loading. */
class AndroidFileIntentInput extends LocalUserInput {
  MethodAccess ma;

  AndroidFileIntentInput() {
    this.asExpr() = ma.getArgument(0) and
    ma.getMethod() instanceof StartActivityForResultMethod and
    exists(GetContentIntentConfig cc, GetContentIntent gi |
      cc.hasFlow(DataFlow::exprNode(gi), DataFlow::exprNode(ma.getArgument(0)))
    )
  }

  /** The request code identifying a specific intent, which is to be matched in `onActivityResult()`. */
  int getRequestCode() { result = ma.getArgument(1).(CompileTimeConstantExpr).getIntValue() }
}

/** The `onActivityForResult` method of Android `Activity` */
class OnActivityForResultMethod extends Method {
  OnActivityForResultMethod() {
    this.getDeclaringType().getASupertype*() instanceof AndroidActivity and
    this.getName() = "onActivityResult"
  }
}

/** Input of Android activity result from the same application or another application. */
class AndroidActivityResultInput extends DataFlow::Node {
  OnActivityForResultMethod m;

  AndroidActivityResultInput() { this.asExpr() = m.getParameter(2).getAnAccess() }

  /** The request code matching a specific intent request. */
  VarAccess getRequestCodeVar() { result = m.getParameter(0).getAnAccess() }
}
