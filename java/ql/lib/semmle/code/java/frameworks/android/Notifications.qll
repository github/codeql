/** Provides classes and predicates related to Android notifications. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSteps

private class NotificationBuildersSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "android.app;Notification$Action;true;Action;(int,CharSequence,PendingIntent);;Argument[2];Argument[-1];taint",
        "android.app;Notification$Action;true;getExtras;;;Argument[-1].SyntheticField[android.content.Intent.extras];ReturnValue;value",
        "android.app;Notification$Action$Builder;true;Builder;(int,CharSequence,PendingIntent);;Argument[2];Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;Builder;(Icon,CharSequence,PendingIntent);;Argument[2];Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;Builder;(Action);;Argument[0];Argument[-1];taint",
        "android.app;Notification$Action$Builder;true;addExtras;;;Argument[0].MapKey;Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value",
        "android.app;Notification$Action$Builder;true;addExtras;;;Argument[0].MapValue;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value",
        "android.app;Notification$Action$Builder;true;build;;;Argument[-1];ReturnValue;taint",
        "android.app;Notification$Action$Builder;true;build;;;Argument[-1].SyntheticField[android.content.Intent.extras];ReturnValue.SyntheticField[android.content.Intent.extras];value",
        "android.app;Notification$Action$Builder;true;getExtras;;;Argument[-1].SyntheticField[android.content.Intent.extras];ReturnValue;value",
        "android.app;Notification$Builder;true;addAction;(int,CharSequence,PendingIntent);;Argument[2];Argument[-1];taint",
        "android.app;Notification$Builder;true;addAction;(Action);;Argument[0];Argument[-1];taint",
        "android.app;Notification$Builder;true;addExtras;;;Argument[0].MapKey;Argument[-1].SyntheticField[android.content.Intent.extras].MapKey;value",
        "android.app;Notification$Builder;true;addExtras;;;Argument[0].MapValue;Argument[-1].SyntheticField[android.content.Intent.extras].MapValue;value",
        "android.app;Notification$Builder;true;build;;;Argument[-1];ReturnValue;taint",
        "android.app;Notification$Builder;true;build;;;Argument[-1].SyntheticField[android.content.Intent.extras];ReturnValue.Field[android.app.Notification.extras];value",
        "android.app;Notification$Builder;true;setContentIntent;;;Argument[0];Argument[-1];taint",
        "android.app;Notification$Builder;true;getExtras;;;Argument[-1].SyntheticField[android.content.Intent.extras];ReturnValue;value",
        "android.app;Notification$Builder;true;recoverBuilder;;;Argument[1];ReturnValue;taint",
        "android.app;Notification$Builder;true;setActions;;;Argument[0].ArrayElement;Argument[-1];taint",
        "android.app;Notification$Builder;true;setExtras;;;Argument[0];Argument[-1].SyntheticField[android.content.Intent.extras];value",
        "android.app;Notification$Builder;true;setDeleteIntent;;;Argument[0];Argument[-1];taint",
        "android.app;Notification$Builder;true;setPublicVersion;;;Argument[0];Argument[-1];taint",
        "android.app;Notification$Style;true;build;;;Argument[-1];ReturnValue;taint",
        "android.app;Notification$BigPictureStyle;true;BigPictureStyle;(Builder);;Argument[0];Argument[-1];taint",
        "android.app;Notification$BigTextStyle;true;BigTextStyle;(Builder);;Argument[0];Argument[-1];taint",
        "android.app;Notification$InboxStyle;true;InboxStyle;(Builder);;Argument[0];Argument[-1];taint",
        "android.app;Notification$MediaStyle;true;MediaStyle;(Builder);;Argument[0];Argument[-1];taint",
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
          ] + ";;;Argument[-1];ReturnValue;value",
        "android.app;Notification$BigPictureStyle;true;" +
          [
            "bigLargeIcon", "bigPicture", "setBigContentTitle", "setContentDescription",
            "setSummaryText", "showBigPictureWhenCollapsed"
          ] + ";;;Argument[-1];ReturnValue;value",
        "android.app;Notification$BigTextStyle;true;" +
          ["bigText", "setBigContentTitle", "setSummaryText"] + ";;;Argument[-1];ReturnValue;value",
        "android.app;Notification$InboxStyle;true;" +
          ["addLine", "setBigContentTitle", "setSummaryText"] + ";;;Argument[-1];ReturnValue;value",
        "android.app;Notification$MediaStyle;true;" +
          ["setMediaSession", "setShowActionsInCompactView"] + ";;;Argument[-1];ReturnValue;value"
      ]
  }
}
