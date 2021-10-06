/** Provides classes and predicates related to Android notifications. */

import java
private import semmle.code.java.dataflow.ExternalFlow

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
