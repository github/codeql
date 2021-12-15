/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package android.app;

import android.annotation.NonNull;
import android.annotation.Nullable;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.graphics.Bitmap;
import android.graphics.drawable.Icon;
import android.media.AudioAttributes;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

public class Notification implements Parcelable {
  public @interface NotificationFlags {
  }

  public @interface Priority {
  }

  public @interface Visibility {
  }

  public String getGroup() {
    return null;
  }

  public String getSortKey() {
    return null;
  }

  public Bundle extras = new Bundle();

  public @interface GroupAlertBehavior {
  }

  public static class Action implements Parcelable {
    public Action(int icon, CharSequence title, PendingIntent intent) {}

    public Icon getIcon() {
      return null;
    }

    public Bundle getExtras() {
      return null;
    }

    public boolean getAllowGeneratedReplies() {
      return false;
    }

    public @SemanticAction int getSemanticAction() {
      return 0;
    }

    public boolean isContextual() {
      return false;
    }

    public static final class Builder {
      public Builder(int icon, CharSequence title, PendingIntent intent) {}

      public Builder(Icon icon, CharSequence title, PendingIntent intent) {}

      public Builder(Action action) {}

      public Builder addExtras(Bundle extras) {
        return null;
      }

      public Bundle getExtras() {
        return null;
      }

      public Builder setAllowGeneratedReplies(boolean allowGeneratedReplies) {
        return null;
      }

      public Builder setSemanticAction(@SemanticAction int semanticAction) {
        return null;
      }

      public Builder setContextual(boolean isContextual) {
        return null;
      }

      public Builder extend(Extender extender) {
        return null;
      }

      public Action build() {
        return null;
      }

      public Builder addRemoteInput(Object object) {
        return null;
      }

      public Builder setAuthenticationRequired(boolean b) {
        return null;
      }

    }

    @Override
    public Action clone() {
      return null;
    }

    public int describeContents() {
      return 0;
    }

    @Override
    public void writeToParcel(Parcel out, int flags) {}

    public interface Extender {
      public Builder extend(Builder builder);

    }
    public static final class WearableExtender implements Extender {
      public WearableExtender() {}

      public WearableExtender(Action action) {}

      @Override
      public Action.Builder extend(Action.Builder builder) {
        return null;
      }

      @Override
      public WearableExtender clone() {
        return null;
      }

      public WearableExtender setAvailableOffline(boolean availableOffline) {
        return null;
      }

      public boolean isAvailableOffline() {
        return false;
      }

      public WearableExtender setInProgressLabel(CharSequence label) {
        return null;
      }

      public CharSequence getInProgressLabel() {
        return null;
      }

      public WearableExtender setConfirmLabel(CharSequence label) {
        return null;
      }

      public CharSequence getConfirmLabel() {
        return null;
      }

      public WearableExtender setCancelLabel(CharSequence label) {
        return null;
      }

      public CharSequence getCancelLabel() {
        return null;
      }

      public WearableExtender setHintLaunchesActivity(boolean hintLaunchesActivity) {
        return null;
      }

      public boolean getHintLaunchesActivity() {
        return false;
      }

      public WearableExtender setHintDisplayActionInline(boolean hintDisplayInline) {
        return null;
      }

      public boolean getHintDisplayActionInline() {
        return false;
      }

    }
    public @interface SemanticAction {
    }

  }

  public Notification() {}

  public Notification(Context context, int icon, CharSequence tickerText, long when,
      CharSequence contentTitle, CharSequence contentText, Intent contentIntent) {}

  public Notification(int icon, CharSequence tickerText, long when) {}

  public Notification(Parcel parcel) {}

  @Override
  public Notification clone() {
    return null;
  }

  public void cloneInto(Notification that, boolean heavy) {}

  public void visitUris(@NonNull Consumer<Uri> visitor) {}

  public final void lightenPayload() {}

  public static CharSequence safeCharSequence(CharSequence cs) {
    return null;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel parcel, int flags) {}

  public static boolean areActionsVisiblyDifferent(Notification first, Notification second) {
    return false;
  }

  public static boolean areStyledNotificationsVisiblyDifferent(Builder first, Builder second) {
    return false;
  }

  public static boolean areRemoteViewsChanged(Builder first, Builder second) {
    return false;
  }

  public void setLatestEventInfo(Context context, CharSequence contentTitle,
      CharSequence contentText, PendingIntent contentIntent) {}

  public static void addFieldsFromContext(Context context, Notification notification) {}

  public static void addFieldsFromContext(ApplicationInfo ai, Notification notification) {}

  @Override
  public String toString() {
    return null;
  }

  public static String visibilityToString(int vis) {
    return null;
  }

  public static String priorityToString(@Priority int pri) {
    return null;
  }

  public boolean hasCompletedProgress() {
    return false;
  }

  public String getChannel() {
    return null;
  }

  public String getChannelId() {
    return null;
  }

  public long getTimeout() {
    return 0;
  }

  public long getTimeoutAfter() {
    return 0;
  }

  public int getBadgeIconType() {
    return 0;
  }

  public String getShortcutId() {
    return null;
  }

  public CharSequence getSettingsText() {
    return null;
  }

  public @GroupAlertBehavior int getGroupAlertBehavior() {
    return 0;
  }

  public BubbleMetadata getBubbleMetadata() {
    return null;
  }

  public void setBubbleMetadata(BubbleMetadata data) {}

  public boolean getAllowSystemGeneratedContextualActions() {
    return false;
  }

  public Icon getSmallIcon() {
    return null;
  }

  public void setSmallIcon(Icon icon) {}

  public Icon getLargeIcon() {
    return null;
  }

  public boolean isGroupSummary() {
    return false;
  }

  public boolean isGroupChild() {
    return false;
  }

  public boolean suppressAlertingDueToGrouping() {
    return false;
  }

  public @NonNull List<Notification.Action> getContextualActions() {
    return null;
  }

  public static class Builder {
    public Builder(Context context, String channelId) {}

    public Builder(Context context) {}

    public Builder(Context context, Notification toAdopt) {}

    public Builder setShortcutId(String shortcutId) {
      return null;
    }

    public Builder setBadgeIconType(int icon) {
      return null;
    }

    public Builder setGroupAlertBehavior(@GroupAlertBehavior int groupAlertBehavior) {
      return null;
    }

    public Builder setBubbleMetadata(@Nullable BubbleMetadata data) {
      return null;
    }

    public Builder setChannel(String channelId) {
      return null;
    }

    public Builder setChannelId(String channelId) {
      return null;
    }

    public Builder setTimeout(long durationMs) {
      return null;
    }

    public Builder setTimeoutAfter(long durationMs) {
      return null;
    }

    public Builder setWhen(long when) {
      return null;
    }

    public Builder setShowWhen(boolean show) {
      return null;
    }

    public Builder setUsesChronometer(boolean b) {
      return null;
    }

    public Builder setChronometerCountDown(boolean countDown) {
      return null;
    }

    public Builder setSmallIcon(Icon icon) {
      return null;
    }

    public Builder setContentTitle(CharSequence title) {
      return null;
    }

    public Builder setContentText(CharSequence text) {
      return null;
    }

    public Builder setSubText(CharSequence text) {
      return null;
    }

    public Builder setSettingsText(CharSequence text) {
      return null;
    }

    public Builder setRemoteInputHistory(CharSequence[] text) {
      return null;
    }

    public Builder setShowRemoteInputSpinner(boolean showSpinner) {
      return null;
    }

    public Builder setHideSmartReplies(boolean hideSmartReplies) {
      return null;
    }

    public Builder setNumber(int number) {
      return null;
    }

    public Builder setContentInfo(CharSequence info) {
      return null;
    }

    public Builder setProgress(int max, int progress, boolean indeterminate) {
      return null;
    }

    public Builder setContentIntent(PendingIntent intent) {
      return null;
    }

    public Builder setDeleteIntent(PendingIntent intent) {
      return null;
    }

    public Builder setFullScreenIntent(PendingIntent intent, boolean highPriority) {
      return null;
    }

    public Builder setTicker(CharSequence tickerText) {
      return null;
    }

    public Builder setLargeIcon(Bitmap bitmap) {
      return null;
    }

    public Builder setSound(Uri sound) {
      return null;
    }

    public Builder setSound(Uri sound, int streamType) {
      return null;
    }

    public Builder setVibrate(long[] pattern) {
      return null;
    }

    public Builder setLights(int argb, int onMs, int offMs) {
      return null;
    }

    public Builder setOngoing(boolean ongoing) {
      return null;
    }

    public Builder setColorized(boolean colorize) {
      return null;
    }

    public Builder setOnlyAlertOnce(boolean onlyAlertOnce) {
      return null;
    }

    public Builder setAutoCancel(boolean autoCancel) {
      return null;
    }

    public Builder setLocalOnly(boolean localOnly) {
      return null;
    }

    public Builder setDefaults(int defaults) {
      return null;
    }

    public Builder setPriority(@Priority int pri) {
      return null;
    }

    public Builder setCategory(String category) {
      return null;
    }

    public Builder addPerson(String uri) {
      return null;
    }

    public Builder setGroup(String groupKey) {
      return null;
    }

    public Builder setGroupSummary(boolean isGroupSummary) {
      return null;
    }

    public Builder setSortKey(String sortKey) {
      return null;
    }

    public Builder addExtras(Bundle extras) {
      return null;
    }

    public Builder setExtras(Bundle extras) {
      return null;
    }

    public Bundle getExtras() {
      return null;
    }

    public Builder addAction(int icon, CharSequence title, PendingIntent intent) {
      return null;
    }

    public Builder addAction(Action action) {
      return null;
    }

    public Builder setActions(Action... actions) {
      return null;
    }

    public Builder setStyle(Style style) {
      return null;
    }

    public Style getStyle() {
      return null;
    }

    public Builder setVisibility(@Visibility int visibility) {
      return null;
    }

    public Builder setPublicVersion(Notification n) {
      return null;
    }

    public Builder extend(Extender extender) {
      return null;
    }

    public Builder setFlag(@NotificationFlags int mask, boolean value) {
      return null;
    }

    public Builder setColor(int argb) {
      return null;
    }

    public boolean usesStandardHeader() {
      return false;
    }

    public int getPrimaryTextColor() {
      return 0;
    }

    public int getSecondaryTextColor() {
      return 0;
    }

    public String loadHeaderAppName() {
      return null;
    }

    public Notification buildUnstyled() {
      return null;
    }

    public static Notification.Builder recoverBuilder(Context context, Notification n) {
      return null;
    }

    public Builder setAllowSystemGeneratedContextualActions(boolean allowed) {
      return null;
    }

    public Notification getNotification() {
      return null;
    }

    public Notification build() {
      return null;
    }

    public Notification buildInto(@NonNull Notification n) {
      return null;
    }

    public static Notification maybeCloneStrippedForDelivery(Notification n) {
      return null;
    }

    public void setColorPalette(int backgroundColor, int foregroundColor) {}

    public void setRebuildStyledRemoteViews(boolean rebuild) {}

    public CharSequence getHeadsUpStatusBarText(boolean publicMode) {
      return null;
    }

    public boolean usesTemplate() {
      return false;
    }

    public Builder addPerson(Person person) {
      return null;
    }

    public Builder setCustomBigContentView(Object object) {
      return null;
    }

    public Builder setCustomHeadsUpContentView(Object object) {
      return null;
    }

    public Builder setContent(Object object) {
      return null;
    }

    public Builder setForegroundServiceBehavior(int i) {
      return null;
    }

    public Builder setLocusId(Object object) {
      return null;
    }

    public Builder setSmallIcon(int i, int j) {
      return null;
    }

    public Builder setSmallIcon(int i) {
      return null;
    }

    public Builder setSound(Uri sound, AudioAttributes audioAttributes) {
      return null;
    }

    public Builder setTicker(Object object, Object object2) {
      return null;
    }

    public Builder setLargeIcon(Icon icon) {
      return null;
    }

  }

  public boolean isForegroundService() {
    return false;
  }

  public boolean hasMediaSession() {
    return false;
  }

  public Class<? extends Notification.Style> getNotificationStyle() {
    return null;
  }

  public boolean isColorized() {
    return false;
  }

  public boolean isColorizedMedia() {
    return false;
  }

  public boolean isMediaNotification() {
    return false;
  }

  public boolean isBubbleNotification() {
    return false;
  }

  public boolean showsTime() {
    return false;
  }

  public boolean showsChronometer() {
    return false;
  }

  public static Class<? extends Style> getNotificationStyleClass(String templateClass) {
    return null;
  }

  public static abstract class Style {
    public void setBuilder(Builder builder) {}

    public void addExtras(Bundle extras) {}

    public Notification buildStyled(Notification wip) {
      return null;
    }

    public void purgeResources() {}

    public Notification build() {
      return null;
    }

    public boolean hasSummaryInHeader() {
      return false;
    }

    public boolean displayCustomViewInline() {
      return false;
    }

    public void reduceImageSizes(Context context) {}

    public void validate(Context context) {}

    public abstract boolean areNotificationsVisiblyDifferent(Style other);

    public CharSequence getHeadsUpStatusBarText() {
      return null;
    }

  }
  public static class BigPictureStyle extends Style {
    public BigPictureStyle() {}

    public BigPictureStyle(Builder builder) {}

    public BigPictureStyle setBigContentTitle(CharSequence title) {
      return null;
    }

    public BigPictureStyle setSummaryText(CharSequence cs) {
      return null;
    }


    public BigPictureStyle bigLargeIcon(Icon icon) {
      return null;
    }

    public static final int MIN_ASHMEM_BITMAP_SIZE = 128 * (1 << 10);

    @Override
    public void purgeResources() {}

    @Override
    public void reduceImageSizes(Context context) {}

    public void addExtras(Bundle extras) {}

    @Override
    public boolean hasSummaryInHeader() {
      return false;
    }

    @Override
    public boolean areNotificationsVisiblyDifferent(Style other) {
      return false;
    }

  }
  public static class BigTextStyle extends Style {
    public BigTextStyle() {}

    public BigTextStyle(Builder builder) {}

    public BigTextStyle setBigContentTitle(CharSequence title) {
      return null;
    }

    public BigTextStyle setSummaryText(CharSequence cs) {
      return null;
    }

    public BigTextStyle bigText(CharSequence cs) {
      return null;
    }

    public CharSequence getBigText() {
      return null;
    }

    public void addExtras(Bundle extras) {}

    @Override
    public boolean areNotificationsVisiblyDifferent(Style other) {
      return false;
    }

  }
  public static class MessagingStyle extends Style {
    public @interface ConversationType {
    }

    public MessagingStyle(@NonNull CharSequence userDisplayName) {}

    @Override
    public void validate(Context context) {}

    @Override
    public CharSequence getHeadsUpStatusBarText() {
      return null;
    }

    public CharSequence getUserDisplayName() {
      return null;
    }

    public MessagingStyle setConversationTitle(@Nullable CharSequence conversationTitle) {
      return null;
    }

    public CharSequence getConversationTitle() {
      return null;
    }

    public MessagingStyle setShortcutIcon(@Nullable Icon conversationIcon) {
      return null;
    }

    public Icon getShortcutIcon() {
      return null;
    }

    public MessagingStyle setConversationType(@ConversationType int conversationType) {
      return null;
    }

    public int getConversationType() {
      return 0;
    }

    public int getUnreadMessageCount() {
      return 0;
    }

    public MessagingStyle setUnreadMessageCount(int unreadMessageCount) {
      return null;
    }

    public MessagingStyle addMessage(CharSequence text, long timestamp, CharSequence sender) {
      return null;
    }

    public MessagingStyle addMessage(Message message) {
      return null;
    }

    public MessagingStyle addHistoricMessage(Message message) {
      return null;
    }

    public List<Message> getMessages() {
      return null;
    }

    public List<Message> getHistoricMessages() {
      return null;
    }

    public MessagingStyle setGroupConversation(boolean isGroupConversation) {
      return null;
    }

    public boolean isGroupConversation() {
      return false;
    }

    @Override
    public void addExtras(Bundle extras) {}

    @Override
    public boolean areNotificationsVisiblyDifferent(Style other) {
      return false;
    }

    public static Message findLatestIncomingMessage(List<Message> messages) {
      return null;
    }


    public static final class Message {
      public Message(CharSequence text, long timestamp, CharSequence sender) {}

      public Message setData(String dataMimeType, Uri dataUri) {
        return null;
      }

      public CharSequence getText() {
        return null;
      }

      public long getTimestamp() {
        return 0;
      }

      public Bundle getExtras() {
        return null;
      }

      public CharSequence getSender() {
        return null;
      }

      public String getDataMimeType() {
        return null;
      }

      public Uri getDataUri() {
        return null;
      }

      public boolean isRemoteInputHistory() {
        return false;
      }

      public Bundle toBundle() {
        return null;
      }

      public static List<Message> getMessagesFromBundleArray(@Nullable Parcelable[] bundles) {
        return null;
      }

      public static Message getMessageFromBundle(@NonNull Bundle bundle) {
        return null;
      }

    }
  }
  public static class InboxStyle extends Style {
    public InboxStyle() {}

    public InboxStyle(Builder builder) {}

    public InboxStyle setBigContentTitle(CharSequence title) {
      return null;
    }

    public InboxStyle setSummaryText(CharSequence cs) {
      return null;
    }

    public InboxStyle addLine(CharSequence cs) {
      return null;
    }

    public ArrayList<CharSequence> getLines() {
      return null;
    }

    public void addExtras(Bundle extras) {}

    @Override
    public boolean areNotificationsVisiblyDifferent(Style other) {
      return false;
    }

  }
  public static class MediaStyle extends Style {
    public MediaStyle() {}

    public MediaStyle(Builder builder) {}

    public MediaStyle setShowActionsInCompactView(int... actions) {
      return null;
    }

    @Override
    public Notification buildStyled(Notification wip) {
      return null;
    }

    @Override
    public void addExtras(Bundle extras) {}

    @Override
    public boolean areNotificationsVisiblyDifferent(Style other) {
      return false;
    }

  }
  public static class DecoratedCustomViewStyle extends Style {
    public DecoratedCustomViewStyle() {}

    public boolean displayCustomViewInline() {
      return false;
    }

    @Override
    public boolean areNotificationsVisiblyDifferent(Style other) {
      return false;
    }

  }
  public static class DecoratedMediaCustomViewStyle extends MediaStyle {
    public DecoratedMediaCustomViewStyle() {}

    public boolean displayCustomViewInline() {
      return false;
    }

    @Override
    public boolean areNotificationsVisiblyDifferent(Style other) {
      return false;
    }

  }
  public static final class BubbleMetadata implements Parcelable {
    public String getShortcutId() {
      return null;
    }

    public PendingIntent getIntent() {
      return null;
    }

    public PendingIntent getBubbleIntent() {
      return null;
    }

    public PendingIntent getDeleteIntent() {
      return null;
    }

    public Icon getIcon() {
      return null;
    }

    public Icon getBubbleIcon() {
      return null;
    }

    public int getDesiredHeight() {
      return 0;
    }

    public int getDesiredHeightResId() {
      return 0;
    }

    public boolean getAutoExpandBubble() {
      return false;
    }

    public boolean isNotificationSuppressed() {
      return false;
    }

    @Override
    public void writeToParcel(Parcel out, int flags) {}

    public void setFlags(int flags) {}

    public int getFlags() {
      return 0;
    }

    public static final class Builder {
      public Builder() {}

      public Builder(@NonNull String shortcutId) {}

      public Builder(@NonNull PendingIntent intent, @NonNull Icon icon) {}

      public BubbleMetadata.Builder createShortcutBubble(@NonNull String shortcutId) {
        return null;
      }

      public BubbleMetadata.Builder createIntentBubble(@NonNull PendingIntent intent,
          @NonNull Icon icon) {
        return null;
      }

      public BubbleMetadata.Builder setIntent(@NonNull PendingIntent intent) {
        return null;
      }

      public BubbleMetadata.Builder setIcon(@NonNull Icon icon) {
        return null;
      }

      public BubbleMetadata.Builder setDesiredHeight(int height) {
        return null;
      }

      public BubbleMetadata.Builder setDesiredHeightResId(int heightResId) {
        return null;
      }

      public BubbleMetadata.Builder setAutoExpandBubble(boolean shouldExpand) {
        return null;
      }

      public BubbleMetadata.Builder setSuppressNotification(boolean shouldSuppressNotif) {
        return null;
      }

      public BubbleMetadata.Builder setDeleteIntent(@Nullable PendingIntent deleteIntent) {
        return null;
      }

      public BubbleMetadata build() {
        return null;
      }

      public BubbleMetadata.Builder setFlag(int mask, boolean value) {
        return null;
      }

    }

    @Override
    public int describeContents() {
      return 0;
    }
  }
  public interface Extender {
    public Builder extend(Builder builder);

  }
  public static final class WearableExtender implements Extender {
    public WearableExtender() {}

    public WearableExtender(Notification notif) {}

    @Override
    public Notification.Builder extend(Notification.Builder builder) {
      return null;
    }

    @Override
    public WearableExtender clone() {
      return null;
    }

    public WearableExtender addAction(Action action) {
      return null;
    }

    public WearableExtender addActions(List<Action> actions) {
      return null;
    }

    public WearableExtender clearActions() {
      return null;
    }

    public List<Action> getActions() {
      return null;
    }

    public WearableExtender setDisplayIntent(PendingIntent intent) {
      return null;
    }

    public PendingIntent getDisplayIntent() {
      return null;
    }

    public WearableExtender addPage(Notification page) {
      return null;
    }

    public WearableExtender addPages(List<Notification> pages) {
      return null;
    }

    public WearableExtender clearPages() {
      return null;
    }

    public List<Notification> getPages() {
      return null;
    }

    public WearableExtender setContentIcon(int icon) {
      return null;
    }

    public int getContentIcon() {
      return 0;
    }

    public WearableExtender setContentIconGravity(int contentIconGravity) {
      return null;
    }

    public int getContentIconGravity() {
      return 0;
    }

    public WearableExtender setContentAction(int actionIndex) {
      return null;
    }

    public int getContentAction() {
      return 0;
    }

    public WearableExtender setGravity(int gravity) {
      return null;
    }

    public int getGravity() {
      return 0;
    }

    public WearableExtender setCustomSizePreset(int sizePreset) {
      return null;
    }

    public int getCustomSizePreset() {
      return 0;
    }

    public WearableExtender setCustomContentHeight(int height) {
      return null;
    }

    public int getCustomContentHeight() {
      return 0;
    }

    public WearableExtender setStartScrollBottom(boolean startScrollBottom) {
      return null;
    }

    public boolean getStartScrollBottom() {
      return false;
    }

    public WearableExtender setContentIntentAvailableOffline(
        boolean contentIntentAvailableOffline) {
      return null;
    }

    public boolean getContentIntentAvailableOffline() {
      return false;
    }

    public WearableExtender setHintHideIcon(boolean hintHideIcon) {
      return null;
    }

    public boolean getHintHideIcon() {
      return false;
    }

    public WearableExtender setHintShowBackgroundOnly(boolean hintShowBackgroundOnly) {
      return null;
    }

    public boolean getHintShowBackgroundOnly() {
      return false;
    }

    public WearableExtender setHintAvoidBackgroundClipping(boolean hintAvoidBackgroundClipping) {
      return null;
    }

    public boolean getHintAvoidBackgroundClipping() {
      return false;
    }

    public WearableExtender setHintScreenTimeout(int timeout) {
      return null;
    }

    public int getHintScreenTimeout() {
      return 0;
    }

    public WearableExtender setHintAmbientBigPicture(boolean hintAmbientBigPicture) {
      return null;
    }

    public boolean getHintAmbientBigPicture() {
      return false;
    }

    public WearableExtender setHintContentIntentLaunchesActivity(
        boolean hintContentIntentLaunchesActivity) {
      return null;
    }

    public boolean getHintContentIntentLaunchesActivity() {
      return false;
    }

    public WearableExtender setDismissalId(String dismissalId) {
      return null;
    }

    public String getDismissalId() {
      return null;
    }

    public WearableExtender setBridgeTag(String bridgeTag) {
      return null;
    }

    public String getBridgeTag() {
      return null;
    }

  }
  public static final class CarExtender implements Extender {
    public CarExtender() {}

    public CarExtender(Notification notif) {}

    @Override
    public Notification.Builder extend(Notification.Builder builder) {
      return null;
    }

    public CarExtender setColor(int color) {
      return null;
    }

    public int getColor() {
      return 0;
    }

    public CarExtender setUnreadConversation(UnreadConversation unreadConversation) {
      return null;
    }

    public UnreadConversation getUnreadConversation() {
      return null;
    }

    public static class UnreadConversation {
      public String[] getMessages() {
        return null;
      }

      public PendingIntent getReplyPendingIntent() {
        return null;
      }

      public PendingIntent getReadPendingIntent() {
        return null;
      }

      public String[] getParticipants() {
        return null;
      }

      public String getParticipant() {
        return null;
      }

      public long getLatestTimestamp() {
        return 0;
      }

    }
    public static class Builder {
      public Builder(String name) {}

      public Builder addMessage(String message) {
        return null;
      }

      public Builder setReadPendingIntent(PendingIntent pendingIntent) {
        return null;
      }

      public Builder setLatestTimestamp(long timestamp) {
        return null;
      }

      public UnreadConversation build() {
        return null;
      }

    }
  }
  public static final class TvExtender implements Extender {
    public TvExtender() {}

    public TvExtender(Notification notif) {}

    @Override
    public Notification.Builder extend(Notification.Builder builder) {
      return null;
    }

    public boolean isAvailableOnTv() {
      return false;
    }

    public TvExtender setChannel(String channelId) {
      return null;
    }

    public TvExtender setChannelId(String channelId) {
      return null;
    }

    public String getChannel() {
      return null;
    }

    public String getChannelId() {
      return null;
    }

    public TvExtender setContentIntent(PendingIntent intent) {
      return null;
    }

    public PendingIntent getContentIntent() {
      return null;
    }

    public TvExtender setDeleteIntent(PendingIntent intent) {
      return null;
    }

    public PendingIntent getDeleteIntent() {
      return null;
    }

    public TvExtender setSuppressShowOverApps(boolean suppress) {
      return null;
    }

    public boolean getSuppressShowOverApps() {
      return false;
    }

  }
}
