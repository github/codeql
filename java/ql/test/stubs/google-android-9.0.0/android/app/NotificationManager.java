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

import java.util.List;
import android.annotation.NonNull;
import android.annotation.Nullable;
import android.content.ComponentName;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.UserHandle;

public class NotificationManager {
  public @interface AutomaticZenRuleStatus {
  }

  public @interface InterruptionFilter {
  }

  public @interface Importance {
  }

  static public INotificationManager getService() {
    return null;
  }

  public static NotificationManager from(Context context) {
    return null;
  }

  public void notify(int id, Notification notification) {}

  public void notify(String tag, int id, Notification notification) {}

  public void notifyAsPackage(@NonNull String targetPackage, @Nullable String tag, int id,
      @NonNull Notification notification) {}

  public void notifyAsUser(String tag, int id, Notification notification, UserHandle user) {}

  public void cancel(int id) {}

  public void cancel(@Nullable String tag, int id) {}

  public void cancelAsPackage(@NonNull String targetPackage, @Nullable String tag, int id) {}

  public void cancelAsUser(String tag, int id, UserHandle user) {}

  public void cancelAll() {}

  public void setNotificationDelegate(@Nullable String delegate) {}

  public @Nullable String getNotificationDelegate() {
    return null;
  }

  public boolean canNotifyAsPackage(@NonNull String pkg) {
    return false;
  }

  public void createNotificationChannelGroup(@NonNull NotificationChannelGroup group) {}

  public void createNotificationChannelGroups(@NonNull List<NotificationChannelGroup> groups) {}

  public void createNotificationChannel(@NonNull NotificationChannel channel) {}

  public void createNotificationChannels(@NonNull List<NotificationChannel> channels) {}

  public NotificationChannel getNotificationChannel(String channelId) {
    return null;
  }

  public @Nullable NotificationChannel getNotificationChannel(@NonNull String channelId,
      @NonNull String conversationId) {
    return null;
  }

  public List<NotificationChannel> getNotificationChannels() {
    return null;
  }

  public void deleteNotificationChannel(String channelId) {}

  public NotificationChannelGroup getNotificationChannelGroup(String channelGroupId) {
    return null;
  }

  public List<NotificationChannelGroup> getNotificationChannelGroups() {
    return null;
  }

  public void deleteNotificationChannelGroup(String groupId) {}

  public ComponentName getEffectsSuppressor() {
    return null;
  }

  public boolean matchesCallFilter(Bundle extras) {
    return false;
  }

  public boolean isSystemConditionProviderEnabled(String path) {
    return false;
  }

  public void setZenMode(int mode, Uri conditionId, String reason) {}

  public int getZenMode() {
    return 0;
  }

  public @NonNull NotificationManager.Policy getConsolidatedNotificationPolicy() {
    return null;
  }

  public int getRuleInstanceCount(ComponentName owner) {
    return 0;
  }

  public boolean removeAutomaticZenRule(String id) {
    return false;
  }

  public boolean removeAutomaticZenRules(String packageName) {
    return false;
  }

  public @Importance int getImportance() {
    return 0;
  }

  public boolean areNotificationsEnabled() {
    return false;
  }

  public boolean areBubblesAllowed() {
    return false;
  }

  public void silenceNotificationSound() {}

  public boolean areNotificationsPaused() {
    return false;
  }

  public boolean isNotificationPolicyAccessGranted() {
    return false;
  }

  public boolean isNotificationListenerAccessGranted(ComponentName listener) {
    return false;
  }

  public boolean isNotificationAssistantAccessGranted(@NonNull ComponentName assistant) {
    return false;
  }

  public boolean shouldHideSilentStatusBarIcons() {
    return false;
  }

  public void allowAssistantAdjustment(String capability) {}

  public void disallowAssistantAdjustment(String capability) {}

  public boolean isNotificationPolicyAccessGrantedForPackage(String pkg) {
    return false;
  }

  public List<String> getEnabledNotificationListenerPackages() {
    return null;
  }

  public Policy getNotificationPolicy() {
    return null;
  }

  public void setNotificationPolicy(@NonNull Policy policy) {}

  public void setNotificationPolicyAccessGranted(String pkg, boolean granted) {}

  public void setNotificationListenerAccessGranted(ComponentName listener, boolean granted) {}

  public void setNotificationListenerAccessGrantedForUser(ComponentName listener, int userId,
      boolean granted) {}

  public void setNotificationAssistantAccessGranted(@Nullable ComponentName assistant,
      boolean granted) {}

  public List<ComponentName> getEnabledNotificationListeners(int userId) {
    return null;
  }

  public @Nullable ComponentName getAllowedNotificationAssistant() {
    return null;
  }

  public static class Policy implements android.os.Parcelable {
    public static final int[] ALL_PRIORITY_CATEGORIES = new int[] {};

    public @interface PrioritySenders {
    }

    public @interface ConversationSenders {
    }

    public Policy(int priorityCategories, int priorityCallSenders, int priorityMessageSenders) {}

    public Policy(int priorityCategories, int priorityCallSenders, int priorityMessageSenders,
        int suppressedVisualEffects) {}

    public Policy(int priorityCategories, @PrioritySenders int priorityCallSenders,
        @PrioritySenders int priorityMessageSenders, int suppressedVisualEffects,
        @ConversationSenders int priorityConversationSenders) {}

    public Policy(int priorityCategories, int priorityCallSenders, int priorityMessageSenders,
        int suppressedVisualEffects, int state, int priorityConversationSenders) {}

    public Policy(Parcel source) {}

    @Override
    public void writeToParcel(Parcel dest, int flags) {}

    public int describeContents() {
      return 0;
    }

    @Override
    public int hashCode() {
      return 0;
    }

    @Override
    public boolean equals(Object o) {
      return false;
    }

    @Override
    public String toString() {
      return null;
    }

    public static int getAllSuppressedVisualEffects() {
      return 0;
    }

    public static boolean areAllVisualEffectsSuppressed(int effects) {
      return false;
    }

    public static String suppressedEffectsToString(int effects) {
      return null;
    }

    public static String priorityCategoriesToString(int priorityCategories) {
      return null;
    }

    public static String prioritySendersToString(int prioritySenders) {
      return null;
    }

    public static @NonNull String conversationSendersToString(int priorityConversationSenders) {
      return null;
    }

    public boolean allowAlarms() {
      return false;
    }

    public boolean allowMedia() {
      return false;
    }

    public boolean allowSystem() {
      return false;
    }

    public boolean allowRepeatCallers() {
      return false;
    }

    public boolean allowCalls() {
      return false;
    }

    public boolean allowConversations() {
      return false;
    }

    public boolean allowMessages() {
      return false;
    }

    public boolean allowEvents() {
      return false;
    }

    public boolean allowReminders() {
      return false;
    }

    public int allowCallsFrom() {
      return 0;
    }

    public int allowMessagesFrom() {
      return 0;
    }

    public int allowConversationsFrom() {
      return 0;
    }

    public boolean showFullScreenIntents() {
      return false;
    }

    public boolean showLights() {
      return false;
    }

    public boolean showPeeking() {
      return false;
    }

    public boolean showStatusBarIcons() {
      return false;
    }

    public boolean showAmbient() {
      return false;
    }

    public boolean showBadges() {
      return false;
    }

    public boolean showInNotificationList() {
      return false;
    }

    public Policy copy() {
      return null;
    }

  }

  public final @InterruptionFilter int getCurrentInterruptionFilter() {
    return 0;
  }

  public final void setInterruptionFilter(@InterruptionFilter int interruptionFilter) {}

  public static int zenModeToInterruptionFilter(int zen) {
    return 0;
  }

  public static int zenModeFromInterruptionFilter(int interruptionFilter, int defValue) {
    return 0;
  }

}
