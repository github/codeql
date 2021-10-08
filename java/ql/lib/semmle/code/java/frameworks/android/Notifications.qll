/** Provides classes and predicates related to Android notifications. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSteps

private class NotificationActionsInheritTaint extends DataFlow::SyntheticFieldContent,
  TaintInheritingContent {
  NotificationActionsInheritTaint() { this.getField().matches("android.app.Notification.action") }
}

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
