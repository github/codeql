/** Provides classes and predicates for working with implicit `PendingIntent`s. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSteps

private class PendingIntentCreationModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.app;PendingIntent;false;getActivity;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getActivityAsUser;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getActivities;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getActivitiesAsUser;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getBroadcast;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getBroadcastAsUser;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getService;;;Argument[2];pending-intent",
        "android.app;PendingIntent;false;getForegroundService;;;Argument[2];pending-intent"
      ]
  }
}

private class PendingIntentSentSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "androidx.slice;SliceProvider;true;onBindSlice;;;ReturnValue;pending-intent-sent",
        "androidx.slice;SliceProvider;true;onCreatePermissionRequest;;;ReturnValue;pending-intent-sent",
        "android.app;NotificationManager;true;notify;(int,Notification);;Argument[1];pending-intent-sent",
        "android.app;NotificationManager;true;notify;(String,int,Notification);;Argument[2];pending-intent-sent",
        "android.app;NotificationManager;true;notifyAsPackage;(String,String,int,Notification);;Argument[3];pending-intent-sent",
        "android.app;NotificationManager;true;notifyAsUser;(String,int,Notification,UserHandle);;Argument[2];pending-intent-sent",
        "android.app;PendingIntent;false;send;(Context,int,Intent,OnFinished,Handler,String,Bundle);;Argument[2];pending-intent-sent",
        "android.app;PendingIntent;false;send;(Context,int,Intent,OnFinished,Handler,String);;Argument[2];pending-intent-sent",
        "android.app;PendingIntent;false;send;(Context,int,Intent,OnFinished,Handler);;Argument[2];pending-intent-sent",
        "android.app;PendingIntent;false;send;(Context,int,Intent);;Argument[2];pending-intent-sent",
        "android.app;Activity;true;setResult;(int,Intent);;Argument[1];pending-intent-sent"
      ]
  }
}
