/** Provides classes and predicates for working with implicit `PendingIntent`s. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class PendingIntentCreationModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.app;PendingIntent;false;getActivity;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getActivities;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getBroadcast;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getService;;;Argument[2];pending-intent"
      ]
  }
}

private class PendingIntentSentSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "androidx.slice;SliceProvider;true;onBindSlice;;;ReturnValue;pending-intent-sent",
        "androidx.slice;SliceProvider;true;onCreatePermissionRequest;;;ReturnValue;pending-intent-sent"
      ]
  }
}

// TODO: Remove when https://github.com/github/codeql/pull/6397 gets merged
private class DefaultIntentRedirectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
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
