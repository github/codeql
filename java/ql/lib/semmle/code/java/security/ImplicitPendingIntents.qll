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

// TODO: Remove when https://github.com/github/codeql/pull/6823 gets merged
private class NotificationBuildersSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.app;Notification$Action;true;Action;(int,CharSequence,PendingIntent);;Argument[2];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;Builder;(int,CharSequence,PendingIntent);;Argument[2];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;Builder;(Icon,CharSequence,PendingIntent);;Argument[2];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;Builder;(Action);;SyntheticField[android.app.Notification.action] of Argument[0];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;addExtras;;;MapKey of Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.app;Notification$Action$Builder;true;addExtras;;;MapValue of Argument[0];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.app;Notification$Action$Builder;true;build;;;SyntheticField[android.app.Notification.action] of Argument[-1];SyntheticField[android.app.Notification.action] of ReturnValue;taint",
        "android.app;Notification$Action$Builder;true;getExtras;;;SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.app;Notification$Builder;true;addAction;(int,CharSequence,PendingIntent);;Argument[2];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        "android.app;Notification$Builder;true;addAction;(Action);;SyntheticField[android.app.Notification.action] of Argument[0];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        "android.app;Notification$Builder;true;addExtras;;;MapKey of Argument[0];MapKey of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.app;Notification$Builder;true;addExtras;;;MapValue of Argument[0];MapValue of SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.app;Notification$Builder;true;build;;;SyntheticField[android.app.Notification.action] of Argument[-1];SyntheticField[android.app.Notification.action] of ReturnValue;taint",
        "android.app;Notification$Builder;true;setContentIntent;;;Argument[0];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        "android.app;Notification$Builder;true;getExtras;;;SyntheticField[android.content.Intent.extras] of Argument[-1];ReturnValue;value",
        "android.app;Notification$Builder;true;recoverBuilder;;;SyntheticField[android.app.Notification.action] of Argument[1];SyntheticField[android.app.Notification.action] of ReturnValue;taint",
        "android.app;Notification$Builder;true;setActions;;;SyntheticField[android.app.Notification.action] of ArrayElement of Argument[0];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        "android.app;Notification$Builder;true;setExtras;;;Argument[0];SyntheticField[android.content.Intent.extras] of Argument[-1];value",
        "android.app;Notification$Builder;true;setDeleteIntent;;;Argument[0];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        "android.app;Notification$Builder;true;setPublicVersion;;;SyntheticField[android.app.Notification.action] of Argument[0];SyntheticField[android.app.Notification.action] of Argument[-1];taint",
        // Fluent models
        "android.app;Notification$Action$Builder;true;" +
          [
            "addExtras", "addRemoteInput", "extend", "setAllowGeneratedReplies",
            "setAuthenticationRequired", "setContextual", "setSemanticAction"
          ] + ";;;Argument[-1];ReturnValue;value",
        "android.app;Notification$Builder;true;" +
          [
            "addAction", "addExtras", "addPerson", "extend", "setActions", "setAutoCancel",
            "setBadgeIconType", "setBubbleMetadata", "setCategory", "setChannelId",
            "setChronometerCountDown", "setColor", "setColorized", "setContent", "setContentInfo",
            "setContentIntent", "setContentText", "setContentTitle", "setCustomBigContentView",
            "setCustomHeadsUpContentView", "setDefaults", "setDeleteIntent", "setExtras", "setFlag",
            "setForegroundServiceBehavior", "setFullScreenIntent", "setGroup",
            "setGroupAlertBehavior", "setGroupSummary", "setLargeIcon", "setLights", "setLocalOnly",
            "setLocusId", "setNumber", "setOngoing", "setOnlyAlertOnce", "setPriority",
            "setProgress", "setPublicVersion", "setRemoteInputHistory", "setSettingsText",
            "setShortcutId", "setShowWhen", "setSmallIcon", "setSortKey", "setSound", "setStyle",
            "setSubText", "setTicker", "setTimeoutAfter", "setUsesChronometer", "setVibrate",
            "setVisibility", "setWhen"
          ] + ";;;Argument[-1];ReturnValue;value"
      ]
  }
}

// TODO: Remove when https://github.com/github/codeql/pull/6801 gets merged
private class SliceBuildersSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "androidx.slice.builders;ListBuilder;true;addAction;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;addGridRow;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;addInputRange;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;addRange;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;addRating;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;addRow;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;addSelection;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;setHeader;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;setSeeMoreAction;(PendingIntent);;Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;setSeeMoreRow;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder;true;build;;;SyntheticField[androidx.slice.Slice.action] of Argument[-1];SyntheticField[androidx.slice.Slice.action] of ReturnValue;taint",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;true;setPrimaryAction;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;true;addEndItem;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;true;setInputAction;(PendingIntent);;Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;true;setPrimaryAction;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RangeBuilder;true;setPrimaryAction;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RatingBuilder;true;setInputAction;(PendingIntent);;Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RatingBuilder;true;setPrimaryAction;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;addEndItem;(SliceAction,boolean);;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;addEndItem;(SliceAction);;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;setPrimaryAction;;;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;setTitleItem;(SliceAction,boolean);;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;setTitleItem;(SliceAction);;SyntheticField[androidx.slice.Slice.action] of Argument[0];SyntheticField[androidx.slice.Slice.action] of Argument[-1];taint",
        "androidx.slice.builders;SliceAction;true;create;(PendingIntent,IconCompat,int,CharSequence);;Argument[0];SyntheticField[androidx.slice.Slice.action] of ReturnValue;taint",
        "androidx.slice.builders;SliceAction;true;createDeeplink;(PendingIntent,IconCompat,int,CharSequence);;Argument[0];SyntheticField[androidx.slice.Slice.action] of ReturnValue;taint",
        "androidx.slice.builders;SliceAction;true;createToggle;(PendingIntent,CharSequence,boolean);;Argument[0];SyntheticField[androidx.slice.Slice.action] of ReturnValue;taint",
        "androidx.slice.builders;SliceAction;true;getAction;;;SyntheticField[androidx.slice.Slice.action] of Argument[-1];ReturnValue;taint",
        // Fluent models
        "androidx.slice.builders;ListBuilder;true;" +
          [
            "addAction", "addGridRow", "addInputRange", "addRange", "addRating", "addRow",
            "addSelection", "setAccentColor", "setHeader", "setHostExtras", "setIsError",
            "setKeywords", "setLayoutDirection", "setSeeMoreAction", "setSeeMoreRow"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$HeaderBuilder;true;" +
          [
            "setContentDescription", "setLayoutDirection", "setPrimaryAction", "setSubtitle",
            "setSummary", "setTitle"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$InputRangeBuilder;true;" +
          [
            "addEndItem", "setContentDescription", "setInputAction", "setLayoutDirection", "setMax",
            "setMin", "setPrimaryAction", "setSubtitle", "setThumb", "setTitle", "setTitleItem",
            "setValue"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RangeBuilder;true;" +
          [
            "setContentDescription", "setMax", "setMode", "setPrimaryAction", "setSubtitle",
            "setTitle", "setTitleItem", "setValue"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RatingBuilder;true;" +
          [
            "setContentDescription", "setInputAction", "setMax", "setMin", "setPrimaryAction",
            "setSubtitle", "setTitle", "setTitleItem", "setValue"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;ListBuilder$RowBuilder;true;" +
          [
            "addEndItem", "setContentDescription", "setEndOfSection", "setLayoutDirection",
            "setPrimaryAction", "setSubtitle", "setTitle", "setTitleItem"
          ] + ";;;Argument[-1];ReturnValue;value",
        "androidx.slice.builders;SliceAction;true;" +
          ["setChecked", "setContentDescription", "setPriority"] +
          ";;;Argument[-1];ReturnValue;value"
      ]
  }
}
