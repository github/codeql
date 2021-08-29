/** Provides summary models relating to file content inputs of Android. */

import java
import semmle.code.java.dataflow.FlowSources
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
    this.getConstructedType().getASupertype*() instanceof TypeIntent and
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

/** Android intent data model in the new CSV format. */
private class AndroidIntentDataModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.content;Intent;true;addCategory;;;Argument[-1];ReturnValue;taint",
        "android.content;Intent;true;addFlags;;;Argument[-1];ReturnValue;taint",
        "android.content;Intent;true;createChooser;;;Argument[0];ReturnValue;taint",
        "android.content;Intent;true;getData;;;Argument[-1];ReturnValue;taint",
        "android.content;Intent;true;getDataString;;;Argument[-1];ReturnValue;taint",
        "android.content;Intent;true;getExtras;;;Argument[-1];ReturnValue;taint",
        "android.content;Intent;true;getIntent;;;Argument[-1];ReturnValue;taint",
        "android.content;Intent;true;get" +
          [
            "ParcelableArray", "ParcelableArrayList", "Parcelable", "Serializable", "StringArray",
            "StringArrayList", "String"
          ] + "Extra;;;Argument[-1..1];ReturnValue;taint",
        "android.content;Intent;true;put" +
          [
            "", "CharSequenceArrayList", "IntegerArrayList", "ParcelableArrayList",
            "StringArrayList"
          ] + "Extra;;;Argument[1];Argument[-1];taint",
        "android.content;Intent;true;putExtras;;;Argument[1];Argument[-1];taint",
        "android.content;Intent;true;setData;;;Argument[0];ReturnValue;taint",
        "android.content;Intent;true;setDataAndType;;;Argument[-1];ReturnValue;taint",
        "android.content;Intent;true;setFlags;;;Argument[-1];ReturnValue;taint",
        "android.content;Intent;true;setType;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getEncodedPath;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getEncodedQuery;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getLastPathSegment;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getPath;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getPathSegments;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getQuery;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getQueryParameter;;;Argument[-1];ReturnValue;taint",
        "android.net;Uri;true;getQueryParameters;;;Argument[-1];ReturnValue;taint",
        "android.os;AsyncTask;true;execute;;;Argument[0];ReturnValue;taint",
        "android.os;AsyncTask;true;doInBackground;;;Argument[0];ReturnValue;taint"
      ]
  }
}

/** Taint configuration for getting content intent. */
class GetContentIntentConfig extends TaintTracking::Configuration {
  GetContentIntentConfig() { this = "GetContentIntentConfig" }

  override predicate isSource(DataFlow::Node src) {
    exists(GetContentIntent gi | src.asExpr() = gi)
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof StartActivityForResultMethod and sink.asExpr() = ma.getArgument(0)
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
