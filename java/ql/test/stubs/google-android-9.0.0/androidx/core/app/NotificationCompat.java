// Generated automatically from androidx.core.app.NotificationCompat for testing purposes

package androidx.core.app;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.widget.RemoteViews;
import androidx.core.app.NotificationBuilderWithBuilderAccessor;
import androidx.core.app.RemoteInput;
import androidx.core.graphics.drawable.IconCompat;
import java.util.ArrayList;
import java.util.List;

public class NotificationCompat {
    abstract static public class Style {
        protected NotificationCompat.Builder mBuilder = null;

        protected void restoreFromCompatExtras(Bundle p0) {}

        public Bitmap createColoredBitmap(int p0, int p1) {
            return null;
        }

        public Notification build() {
            return null;
        }

        public RemoteViews applyStandardTemplate(boolean p0, int p1, boolean p2) {
            return null;
        }

        public RemoteViews makeBigContentView(NotificationBuilderWithBuilderAccessor p0) {
            return null;
        }

        public RemoteViews makeContentView(NotificationBuilderWithBuilderAccessor p0) {
            return null;
        }

        public RemoteViews makeHeadsUpContentView(NotificationBuilderWithBuilderAccessor p0) {
            return null;
        }

        public Style() {}

        public void addCompatExtras(Bundle p0) {}

        public void apply(NotificationBuilderWithBuilderAccessor p0) {}

        public void buildIntoRemoteViews(RemoteViews p0, RemoteViews p1) {}

        public void setBuilder(NotificationCompat.Builder p0) {}
    }

    public NotificationCompat() {}

    public static Bundle getExtras(Notification p0) {
        return null;
    }

    public static CharSequence getContentTitle(Notification p0) {
        return null;
    }

    public static List<NotificationCompat.Action> getInvisibleActions(Notification p0) {
        return null;
    }

    public static NotificationCompat.Action getAction(Notification p0, int p1) {
        return null;
    }

    public static NotificationCompat.BubbleMetadata getBubbleMetadata(Notification p0) {
        return null;
    }

    public static String CATEGORY_ALARM = null;
    public static String CATEGORY_CALL = null;
    public static String CATEGORY_EMAIL = null;
    public static String CATEGORY_ERROR = null;
    public static String CATEGORY_EVENT = null;
    public static String CATEGORY_MESSAGE = null;
    public static String CATEGORY_NAVIGATION = null;
    public static String CATEGORY_PROGRESS = null;
    public static String CATEGORY_PROMO = null;
    public static String CATEGORY_RECOMMENDATION = null;
    public static String CATEGORY_REMINDER = null;
    public static String CATEGORY_SERVICE = null;
    public static String CATEGORY_SOCIAL = null;
    public static String CATEGORY_STATUS = null;
    public static String CATEGORY_SYSTEM = null;
    public static String CATEGORY_TRANSPORT = null;
    public static String EXTRA_AUDIO_CONTENTS_URI = null;
    public static String EXTRA_BACKGROUND_IMAGE_URI = null;
    public static String EXTRA_BIG_TEXT = null;
    public static String EXTRA_CHRONOMETER_COUNT_DOWN = null;
    public static String EXTRA_COMPACT_ACTIONS = null;
    public static String EXTRA_CONVERSATION_TITLE = null;
    public static String EXTRA_HIDDEN_CONVERSATION_TITLE = null;
    public static String EXTRA_INFO_TEXT = null;
    public static String EXTRA_IS_GROUP_CONVERSATION = null;
    public static String EXTRA_LARGE_ICON = null;
    public static String EXTRA_LARGE_ICON_BIG = null;
    public static String EXTRA_MEDIA_SESSION = null;
    public static String EXTRA_MESSAGES = null;
    public static String EXTRA_MESSAGING_STYLE_USER = null;
    public static String EXTRA_PEOPLE = null;
    public static String EXTRA_PICTURE = null;
    public static String EXTRA_PROGRESS = null;
    public static String EXTRA_PROGRESS_INDETERMINATE = null;
    public static String EXTRA_PROGRESS_MAX = null;
    public static String EXTRA_REMOTE_INPUT_HISTORY = null;
    public static String EXTRA_SELF_DISPLAY_NAME = null;
    public static String EXTRA_SHOW_CHRONOMETER = null;
    public static String EXTRA_SHOW_WHEN = null;
    public static String EXTRA_SMALL_ICON = null;
    public static String EXTRA_SUB_TEXT = null;
    public static String EXTRA_SUMMARY_TEXT = null;
    public static String EXTRA_TEMPLATE = null;
    public static String EXTRA_TEXT = null;
    public static String EXTRA_TEXT_LINES = null;
    public static String EXTRA_TITLE = null;
    public static String EXTRA_TITLE_BIG = null;
    public static String GROUP_KEY_SILENT = null;

    public static String getCategory(Notification p0) {
        return null;
    }

    public static String getChannelId(Notification p0) {
        return null;
    }

    public static String getGroup(Notification p0) {
        return null;
    }

    public static String getShortcutId(Notification p0) {
        return null;
    }

    public static String getSortKey(Notification p0) {
        return null;
    }

    public static boolean getAllowSystemGeneratedContextualActions(Notification p0) {
        return false;
    }

    public static boolean getLocalOnly(Notification p0) {
        return false;
    }

    public static boolean isGroupSummary(Notification p0) {
        return false;
    }

    public static int BADGE_ICON_LARGE = 0;
    public static int BADGE_ICON_NONE = 0;
    public static int BADGE_ICON_SMALL = 0;
    public static int COLOR_DEFAULT = 0;
    public static int DEFAULT_ALL = 0;
    public static int DEFAULT_LIGHTS = 0;
    public static int DEFAULT_SOUND = 0;
    public static int DEFAULT_VIBRATE = 0;
    public static int FLAG_AUTO_CANCEL = 0;
    public static int FLAG_BUBBLE = 0;
    public static int FLAG_FOREGROUND_SERVICE = 0;
    public static int FLAG_GROUP_SUMMARY = 0;
    public static int FLAG_HIGH_PRIORITY = 0;
    public static int FLAG_INSISTENT = 0;
    public static int FLAG_LOCAL_ONLY = 0;
    public static int FLAG_NO_CLEAR = 0;
    public static int FLAG_ONGOING_EVENT = 0;
    public static int FLAG_ONLY_ALERT_ONCE = 0;
    public static int FLAG_SHOW_LIGHTS = 0;
    public static int GROUP_ALERT_ALL = 0;
    public static int GROUP_ALERT_CHILDREN = 0;
    public static int GROUP_ALERT_SUMMARY = 0;
    public static int PRIORITY_DEFAULT = 0;
    public static int PRIORITY_HIGH = 0;
    public static int PRIORITY_LOW = 0;
    public static int PRIORITY_MAX = 0;
    public static int PRIORITY_MIN = 0;
    public static int STREAM_DEFAULT = 0;
    public static int VISIBILITY_PRIVATE = 0;
    public static int VISIBILITY_PUBLIC = 0;
    public static int VISIBILITY_SECRET = 0;

    public static int getActionCount(Notification p0) {
        return 0;
    }

    public static int getBadgeIconType(Notification p0) {
        return 0;
    }

    public static int getGroupAlertBehavior(Notification p0) {
        return 0;
    }

    public static long getTimeoutAfter(Notification p0) {
        return 0;
    }

    static public class Action {
        protected Action() {}

        public Action(IconCompat p0, CharSequence p1, PendingIntent p2) {}

        public Action(int p0, CharSequence p1, PendingIntent p2) {}

        public Bundle getExtras() {
            return null;
        }

        public CharSequence getTitle() {
            return null;
        }

        public CharSequence title = null;

        public IconCompat getIconCompat() {
            return null;
        }

        public PendingIntent actionIntent = null;

        public PendingIntent getActionIntent() {
            return null;
        }

        public RemoteInput[] getDataOnlyRemoteInputs() {
            return null;
        }

        public RemoteInput[] getRemoteInputs() {
            return null;
        }

        public boolean getAllowGeneratedReplies() {
            return false;
        }

        public boolean getShowsUserInterface() {
            return false;
        }

        public boolean isContextual() {
            return false;
        }

        public int getIcon() {
            return 0;
        }

        public int getSemanticAction() {
            return 0;
        }

        public int icon = 0;
        public static int SEMANTIC_ACTION_ARCHIVE = 0;
        public static int SEMANTIC_ACTION_CALL = 0;
        public static int SEMANTIC_ACTION_DELETE = 0;
        public static int SEMANTIC_ACTION_MARK_AS_READ = 0;
        public static int SEMANTIC_ACTION_MARK_AS_UNREAD = 0;
        public static int SEMANTIC_ACTION_MUTE = 0;
        public static int SEMANTIC_ACTION_NONE = 0;
        public static int SEMANTIC_ACTION_REPLY = 0;
        public static int SEMANTIC_ACTION_THUMBS_DOWN = 0;
        public static int SEMANTIC_ACTION_THUMBS_UP = 0;
        public static int SEMANTIC_ACTION_UNMUTE = 0;

        static public class Builder {
            protected Builder() {}

            public Builder(IconCompat p0, CharSequence p1, PendingIntent p2) {}

            public Builder(NotificationCompat.Action p0) {}

            public Builder(int p0, CharSequence p1, PendingIntent p2) {}

            public Bundle getExtras() {
                return null;
            }

            public NotificationCompat.Action build() {
                return null;
            }

            public NotificationCompat.Action.Builder addExtras(Bundle p0) {
                return null;
            }

            public NotificationCompat.Action.Builder addRemoteInput(RemoteInput p0) {
                return null;
            }

            public NotificationCompat.Action.Builder extend(NotificationCompat.Action.Extender p0) {
                return null;
            }

            public NotificationCompat.Action.Builder setAllowGeneratedReplies(boolean p0) {
                return null;
            }

            public NotificationCompat.Action.Builder setContextual(boolean p0) {
                return null;
            }

            public NotificationCompat.Action.Builder setSemanticAction(int p0) {
                return null;
            }

            public NotificationCompat.Action.Builder setShowsUserInterface(boolean p0) {
                return null;
            }
        }
        static public interface Extender {
            NotificationCompat.Action.Builder extend(NotificationCompat.Action.Builder p0);
        }
    }
    static public class BigPictureStyle extends NotificationCompat.Style {
        public BigPictureStyle() {}

        public BigPictureStyle(NotificationCompat.Builder p0) {}

        public NotificationCompat.BigPictureStyle bigLargeIcon(Bitmap p0) {
            return null;
        }

        public NotificationCompat.BigPictureStyle bigPicture(Bitmap p0) {
            return null;
        }

        public NotificationCompat.BigPictureStyle setBigContentTitle(CharSequence p0) {
            return null;
        }

        public NotificationCompat.BigPictureStyle setSummaryText(CharSequence p0) {
            return null;
        }

        public void apply(NotificationBuilderWithBuilderAccessor p0) {}
    }
    static public class BigTextStyle extends NotificationCompat.Style {
        public BigTextStyle() {}

        public BigTextStyle(NotificationCompat.Builder p0) {}

        public NotificationCompat.BigTextStyle bigText(CharSequence p0) {
            return null;
        }

        public NotificationCompat.BigTextStyle setBigContentTitle(CharSequence p0) {
            return null;
        }

        public NotificationCompat.BigTextStyle setSummaryText(CharSequence p0) {
            return null;
        }

        public void apply(NotificationBuilderWithBuilderAccessor p0) {}
    }
    static public class BubbleMetadata {
        protected BubbleMetadata() {}

        public IconCompat getIcon() {
            return null;
        }

        public PendingIntent getDeleteIntent() {
            return null;
        }

        public PendingIntent getIntent() {
            return null;
        }

        public boolean getAutoExpandBubble() {
            return false;
        }

        public boolean isNotificationSuppressed() {
            return false;
        }

        public int getDesiredHeight() {
            return 0;
        }

        public int getDesiredHeightResId() {
            return 0;
        }

        public static Notification.BubbleMetadata toPlatform(NotificationCompat.BubbleMetadata p0) {
            return null;
        }

        public static NotificationCompat.BubbleMetadata fromPlatform(
                Notification.BubbleMetadata p0) {
            return null;
        }
    }
    static public class Builder {
        protected Builder() {}

        protected static CharSequence limitCharSequenceLength(CharSequence p0) {
            return null;
        }

        public ArrayList<NotificationCompat.Action> mActions = null;
        public ArrayList<String> mPeople = null;

        public Builder(Context p0) {}

        public Builder(Context p0, String p1) {}

        public Bundle getExtras() {
            return null;
        }

        public Context mContext = null;

        public Notification build() {
            return null;
        }

        public Notification getNotification() {
            return null;
        }

        public NotificationCompat.BubbleMetadata getBubbleMetadata() {
            return null;
        }

        public NotificationCompat.Builder addAction(NotificationCompat.Action p0) {
            return null;
        }

        public NotificationCompat.Builder addAction(int p0, CharSequence p1, PendingIntent p2) {
            return null;
        }

        public NotificationCompat.Builder addExtras(Bundle p0) {
            return null;
        }

        public NotificationCompat.Builder addInvisibleAction(NotificationCompat.Action p0) {
            return null;
        }

        public NotificationCompat.Builder addInvisibleAction(int p0, CharSequence p1,
                PendingIntent p2) {
            return null;
        }

        public NotificationCompat.Builder addPerson(String p0) {
            return null;
        }

        public NotificationCompat.Builder extend(NotificationCompat.Extender p0) {
            return null;
        }

        public NotificationCompat.Builder setAllowSystemGeneratedContextualActions(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setAutoCancel(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setBadgeIconType(int p0) {
            return null;
        }

        public NotificationCompat.Builder setBubbleMetadata(NotificationCompat.BubbleMetadata p0) {
            return null;
        }

        public NotificationCompat.Builder setCategory(String p0) {
            return null;
        }

        public NotificationCompat.Builder setChannelId(String p0) {
            return null;
        }

        public NotificationCompat.Builder setChronometerCountDown(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setColor(int p0) {
            return null;
        }

        public NotificationCompat.Builder setColorized(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setContent(RemoteViews p0) {
            return null;
        }

        public NotificationCompat.Builder setContentInfo(CharSequence p0) {
            return null;
        }

        public NotificationCompat.Builder setContentIntent(PendingIntent p0) {
            return null;
        }

        public NotificationCompat.Builder setContentText(CharSequence p0) {
            return null;
        }

        public NotificationCompat.Builder setContentTitle(CharSequence p0) {
            return null;
        }

        public NotificationCompat.Builder setCustomBigContentView(RemoteViews p0) {
            return null;
        }

        public NotificationCompat.Builder setCustomContentView(RemoteViews p0) {
            return null;
        }

        public NotificationCompat.Builder setCustomHeadsUpContentView(RemoteViews p0) {
            return null;
        }

        public NotificationCompat.Builder setDefaults(int p0) {
            return null;
        }

        public NotificationCompat.Builder setDeleteIntent(PendingIntent p0) {
            return null;
        }

        public NotificationCompat.Builder setExtras(Bundle p0) {
            return null;
        }

        public NotificationCompat.Builder setFullScreenIntent(PendingIntent p0, boolean p1) {
            return null;
        }

        public NotificationCompat.Builder setGroup(String p0) {
            return null;
        }

        public NotificationCompat.Builder setGroupAlertBehavior(int p0) {
            return null;
        }

        public NotificationCompat.Builder setGroupSummary(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setLargeIcon(Bitmap p0) {
            return null;
        }

        public NotificationCompat.Builder setLights(int p0, int p1, int p2) {
            return null;
        }

        public NotificationCompat.Builder setLocalOnly(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setNotificationSilent() {
            return null;
        }

        public NotificationCompat.Builder setNumber(int p0) {
            return null;
        }

        public NotificationCompat.Builder setOngoing(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setOnlyAlertOnce(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setPriority(int p0) {
            return null;
        }

        public NotificationCompat.Builder setProgress(int p0, int p1, boolean p2) {
            return null;
        }

        public NotificationCompat.Builder setPublicVersion(Notification p0) {
            return null;
        }

        public NotificationCompat.Builder setRemoteInputHistory(CharSequence[] p0) {
            return null;
        }

        public NotificationCompat.Builder setShortcutId(String p0) {
            return null;
        }

        public NotificationCompat.Builder setShowWhen(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setSmallIcon(int p0) {
            return null;
        }

        public NotificationCompat.Builder setSmallIcon(int p0, int p1) {
            return null;
        }

        public NotificationCompat.Builder setSortKey(String p0) {
            return null;
        }

        public NotificationCompat.Builder setSound(Uri p0) {
            return null;
        }

        public NotificationCompat.Builder setSound(Uri p0, int p1) {
            return null;
        }

        public NotificationCompat.Builder setStyle(NotificationCompat.Style p0) {
            return null;
        }

        public NotificationCompat.Builder setSubText(CharSequence p0) {
            return null;
        }

        public NotificationCompat.Builder setTicker(CharSequence p0) {
            return null;
        }

        public NotificationCompat.Builder setTicker(CharSequence p0, RemoteViews p1) {
            return null;
        }

        public NotificationCompat.Builder setTimeoutAfter(long p0) {
            return null;
        }

        public NotificationCompat.Builder setUsesChronometer(boolean p0) {
            return null;
        }

        public NotificationCompat.Builder setVibrate(long[] p0) {
            return null;
        }

        public NotificationCompat.Builder setVisibility(int p0) {
            return null;
        }

        public NotificationCompat.Builder setWhen(long p0) {
            return null;
        }

        public RemoteViews getBigContentView() {
            return null;
        }

        public RemoteViews getContentView() {
            return null;
        }

        public RemoteViews getHeadsUpContentView() {
            return null;
        }

        public int getColor() {
            return 0;
        }

        public int getPriority() {
            return 0;
        }

        public long getWhenIfShowing() {
            return 0;
        }
    }
    static public class InboxStyle extends NotificationCompat.Style {
        public InboxStyle() {}

        public InboxStyle(NotificationCompat.Builder p0) {}

        public NotificationCompat.InboxStyle addLine(CharSequence p0) {
            return null;
        }

        public NotificationCompat.InboxStyle setBigContentTitle(CharSequence p0) {
            return null;
        }

        public NotificationCompat.InboxStyle setSummaryText(CharSequence p0) {
            return null;
        }

        public void apply(NotificationBuilderWithBuilderAccessor p0) {}
    }
    static public interface Extender {
        NotificationCompat.Builder extend(NotificationCompat.Builder p0);
    }
}
