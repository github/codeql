/** Provides classes and predicates for working with implicit `PendingIntent`s. */

import java
private import semmle.code.java.dataflow.ExternalFlow

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
        "android.app;NotificationManager;true;notifyAsUser;(String,int,Notification,UserHandle);;Argument[2];pending-intent-sent"
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

// TODO: Remove when https://github.com/github/codeql/pull/6823 gets merged
private class NotificationBuildersSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.app;Notification$Action;true;Action;(int,CharSequence,PendingIntent);;Argument[2];Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;Builder;(int,CharSequence,PendingIntent);;Argument[2];Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;Builder;(Icon,CharSequence,PendingIntent);;Argument[2];Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;Builder;(Action);;Argument[0];Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;addExtras;;;MapKey of Argument[0];MapKey of SyntheticField[android.app.NotificationActionBuilder.extras] of Argument[-1];value",
        "android.app;Notification$Action$Builder;true;addExtras;;;MapValue of Argument[0];MapValue of SyntheticField[android.app.NotificationActionBuilder.extras] of Argument[-1];value",
        "android.app;Notification$Action$Builder;true;build;;;Argument[-1];ReturnValue;taint",
        "android.app;Notification$Action$Builder;true;getExtras;;;SyntheticField[android.app.NotificationActionBuilder.extras] of Argument[-1];ReturnValue;value",
        "android.app;Notification$Builder;true;addAction;(int,CharSequence,PendingIntent);;Argument[2];Argument[-1];taint",
        "android.app;Notification$Builder;true;addAction;(Action);;Argument[0];Argument[-1];taint",
        "android.app;Notification$Builder;true;addExtras;;;MapKey of Argument[0];MapKey of SyntheticField[android.app.NotificationBuilder.extras] of Argument[-1];value",
        "android.app;Notification$Builder;true;addExtras;;;MapValue of Argument[0];MapValue of SyntheticField[android.app.NotificationBuilder.extras] of Argument[-1];value",
        "android.app;Notification$Builder;true;build;;;Argument[-1];ReturnValue;taint",
        "android.app;Notification$Builder;true;setContentIntent;;;Argument[0];Argument[-1];taint",
        "android.app;Notification$Builder;true;getExtras;;;SyntheticField[android.app.NotificationBuilder.extras] of Argument[-1];ReturnValue;value",
        "android.app;Notification$Builder;true;recoverBuilder;;;Argument[1];ReturnValue;taint",
        "android.app;Notification$Builder;true;setActions;;;ArrayElement of Argument[0];Argument[-1];taint",
        "android.app;Notification$Builder;true;setExtras;;;Argument[0];SyntheticField[android.app.NotificationBuilder.extras] of Argument[-1];value",
        "android.app;Notification$Builder;true;setDeleteIntent;;;Argument[0];Argument[-1];taint",
        "android.app;Notification$Builder;true;setPublicVersion;;;Argument[0];Argument[-1];taint",
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
