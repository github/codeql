// Generated automatically from android.app.Notification for testing purposes

package android.app;

import android.app.PendingIntent;
import android.app.Person;
import android.app.RemoteInput;
import android.content.Context;
import android.content.LocusId;
import android.graphics.Bitmap;
import android.graphics.drawable.Icon;
import android.media.AudioAttributes;
import android.media.session.MediaSession;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Pair;
import android.widget.RemoteViews;
import java.util.List;

public class Notification implements Parcelable
{
    abstract static public class Style
    {
        protected Notification.Builder mBuilder = null;
        protected RemoteViews getStandardView(int p0){ return null; }
        protected void checkBuilder(){}
        protected void internalSetBigContentTitle(CharSequence p0){}
        protected void internalSetSummaryText(CharSequence p0){}
        public Notification build(){ return null; }
        public Style(){}
        public void setBuilder(Notification.Builder p0){}
    }
    public AudioAttributes audioAttributes = null;
    public Bitmap largeIcon = null;
    public Bundle extras = null;
    public CharSequence getSettingsText(){ return null; }
    public CharSequence tickerText = null;
    public Icon getLargeIcon(){ return null; }
    public Icon getSmallIcon(){ return null; }
    public List<Notification.Action> getContextualActions(){ return null; }
    public LocusId getLocusId(){ return null; }
    public Notification clone(){ return null; }
    public Notification publicVersion = null;
    public Notification(){}
    public Notification(Parcel p0){}
    public Notification(int p0, CharSequence p1, long p2){}
    public Notification.Action[] actions = null;
    public Notification.BubbleMetadata getBubbleMetadata(){ return null; }
    public Pair<RemoteInput, Notification.Action> findRemoteInputActionPair(boolean p0){ return null; }
    public PendingIntent contentIntent = null;
    public PendingIntent deleteIntent = null;
    public PendingIntent fullScreenIntent = null;
    public RemoteViews bigContentView = null;
    public RemoteViews contentView = null;
    public RemoteViews headsUpContentView = null;
    public RemoteViews tickerView = null;
    public String category = null;
    public String getChannelId(){ return null; }
    public String getGroup(){ return null; }
    public String getShortcutId(){ return null; }
    public String getSortKey(){ return null; }
    public String toString(){ return null; }
    public Uri sound = null;
    public boolean getAllowSystemGeneratedContextualActions(){ return false; }
    public boolean hasImage(){ return false; }
    public int audioStreamType = 0;
    public int color = 0;
    public int defaults = 0;
    public int describeContents(){ return 0; }
    public int flags = 0;
    public int getBadgeIconType(){ return 0; }
    public int getGroupAlertBehavior(){ return 0; }
    public int icon = 0;
    public int iconLevel = 0;
    public int ledARGB = 0;
    public int ledOffMS = 0;
    public int ledOnMS = 0;
    public int number = 0;
    public int priority = 0;
    public int visibility = 0;
    public long getTimeoutAfter(){ return 0; }
    public long when = 0;
    public long[] vibrate = null;
    public static AudioAttributes AUDIO_ATTRIBUTES_DEFAULT = null;
    public static Parcelable.Creator<Notification> CREATOR = null;
    public static String CATEGORY_ALARM = null;
    public static String CATEGORY_CALL = null;
    public static String CATEGORY_EMAIL = null;
    public static String CATEGORY_ERROR = null;
    public static String CATEGORY_EVENT = null;
    public static String CATEGORY_LOCATION_SHARING = null;
    public static String CATEGORY_MESSAGE = null;
    public static String CATEGORY_MISSED_CALL = null;
    public static String CATEGORY_NAVIGATION = null;
    public static String CATEGORY_PROGRESS = null;
    public static String CATEGORY_PROMO = null;
    public static String CATEGORY_RECOMMENDATION = null;
    public static String CATEGORY_REMINDER = null;
    public static String CATEGORY_SERVICE = null;
    public static String CATEGORY_SOCIAL = null;
    public static String CATEGORY_STATUS = null;
    public static String CATEGORY_STOPWATCH = null;
    public static String CATEGORY_SYSTEM = null;
    public static String CATEGORY_TRANSPORT = null;
    public static String CATEGORY_WORKOUT = null;
    public static String EXTRA_ANSWER_COLOR = null;
    public static String EXTRA_ANSWER_INTENT = null;
    public static String EXTRA_AUDIO_CONTENTS_URI = null;
    public static String EXTRA_BACKGROUND_IMAGE_URI = null;
    public static String EXTRA_BIG_TEXT = null;
    public static String EXTRA_CALL_IS_VIDEO = null;
    public static String EXTRA_CALL_PERSON = null;
    public static String EXTRA_CHANNEL_GROUP_ID = null;
    public static String EXTRA_CHANNEL_ID = null;
    public static String EXTRA_CHRONOMETER_COUNT_DOWN = null;
    public static String EXTRA_COLORIZED = null;
    public static String EXTRA_COMPACT_ACTIONS = null;
    public static String EXTRA_CONVERSATION_TITLE = null;
    public static String EXTRA_DECLINE_COLOR = null;
    public static String EXTRA_DECLINE_INTENT = null;
    public static String EXTRA_HANG_UP_INTENT = null;
    public static String EXTRA_HISTORIC_MESSAGES = null;
    public static String EXTRA_INFO_TEXT = null;
    public static String EXTRA_IS_GROUP_CONVERSATION = null;
    public static String EXTRA_LARGE_ICON = null;
    public static String EXTRA_LARGE_ICON_BIG = null;
    public static String EXTRA_MEDIA_SESSION = null;
    public static String EXTRA_MESSAGES = null;
    public static String EXTRA_MESSAGING_PERSON = null;
    public static String EXTRA_NOTIFICATION_ID = null;
    public static String EXTRA_NOTIFICATION_TAG = null;
    public static String EXTRA_PEOPLE = null;
    public static String EXTRA_PEOPLE_LIST = null;
    public static String EXTRA_PICTURE = null;
    public static String EXTRA_PICTURE_CONTENT_DESCRIPTION = null;
    public static String EXTRA_PICTURE_ICON = null;
    public static String EXTRA_PROGRESS = null;
    public static String EXTRA_PROGRESS_INDETERMINATE = null;
    public static String EXTRA_PROGRESS_MAX = null;
    public static String EXTRA_REMOTE_INPUT_DRAFT = null;
    public static String EXTRA_REMOTE_INPUT_HISTORY = null;
    public static String EXTRA_SELF_DISPLAY_NAME = null;
    public static String EXTRA_SHOW_BIG_PICTURE_WHEN_COLLAPSED = null;
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
    public static String EXTRA_VERIFICATION_ICON = null;
    public static String EXTRA_VERIFICATION_TEXT = null;
    public static String INTENT_CATEGORY_NOTIFICATION_PREFERENCES = null;
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
    public static int FOREGROUND_SERVICE_DEFAULT = 0;
    public static int FOREGROUND_SERVICE_DEFERRED = 0;
    public static int FOREGROUND_SERVICE_IMMEDIATE = 0;
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
    public void writeToParcel(Parcel p0, int p1){}
    static public class Action implements Parcelable
    {
        protected Action() {}
        public Action(int p0, CharSequence p1, PendingIntent p2){}
        public Bundle getExtras(){ return null; }
        public CharSequence title = null;
        public Icon getIcon(){ return null; }
        public Notification.Action clone(){ return null; }
        public PendingIntent actionIntent = null;
        public RemoteInput[] getDataOnlyRemoteInputs(){ return null; }
        public RemoteInput[] getRemoteInputs(){ return null; }
        public boolean getAllowGeneratedReplies(){ return false; }
        public boolean isAuthenticationRequired(){ return false; }
        public boolean isContextual(){ return false; }
        public int describeContents(){ return 0; }
        public int getSemanticAction(){ return 0; }
        public int icon = 0;
        public static Parcelable.Creator<Notification.Action> CREATOR = null;
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
        public void writeToParcel(Parcel p0, int p1){}
        static public class Builder
        {
            protected Builder() {}
            public Builder(Icon p0, CharSequence p1, PendingIntent p2){}
            public Builder(Notification.Action p0){}
            public Builder(int p0, CharSequence p1, PendingIntent p2){}
            public Bundle getExtras(){ return null; }
            public Notification.Action build(){ return null; }
            public Notification.Action.Builder addExtras(Bundle p0){ return null; }
            public Notification.Action.Builder addRemoteInput(RemoteInput p0){ return null; }
            public Notification.Action.Builder extend(Notification.Action.Extender p0){ return null; }
            public Notification.Action.Builder setAllowGeneratedReplies(boolean p0){ return null; }
            public Notification.Action.Builder setAuthenticationRequired(boolean p0){ return null; }
            public Notification.Action.Builder setContextual(boolean p0){ return null; }
            public Notification.Action.Builder setSemanticAction(int p0){ return null; }
        }
        static public interface Extender
        {
            Notification.Action.Builder extend(Notification.Action.Builder p0);
        }
    }
    static public class BigPictureStyle extends Notification.Style
    {
        public BigPictureStyle(){}
        public BigPictureStyle(Notification.Builder p0){}
        public Notification.BigPictureStyle bigLargeIcon(Bitmap p0){ return null; }
        public Notification.BigPictureStyle bigLargeIcon(Icon p0){ return null; }
        public Notification.BigPictureStyle bigPicture(Bitmap p0){ return null; }
        public Notification.BigPictureStyle bigPicture(Icon p0){ return null; }
        public Notification.BigPictureStyle setBigContentTitle(CharSequence p0){ return null; }
        public Notification.BigPictureStyle setContentDescription(CharSequence p0){ return null; }
        public Notification.BigPictureStyle setSummaryText(CharSequence p0){ return null; }
        public Notification.BigPictureStyle showBigPictureWhenCollapsed(boolean p0){ return null; }
    }
    static public class BigTextStyle extends Notification.Style
    {
        public BigTextStyle(){}
        public BigTextStyle(Notification.Builder p0){}
        public Notification.BigTextStyle bigText(CharSequence p0){ return null; }
        public Notification.BigTextStyle setBigContentTitle(CharSequence p0){ return null; }
        public Notification.BigTextStyle setSummaryText(CharSequence p0){ return null; }
    }
    static public class BubbleMetadata implements Parcelable
    {
        protected BubbleMetadata() {}
        public Icon getIcon(){ return null; }
        public PendingIntent getDeleteIntent(){ return null; }
        public PendingIntent getIntent(){ return null; }
        public String getShortcutId(){ return null; }
        public boolean getAutoExpandBubble(){ return false; }
        public boolean isBubbleSuppressable(){ return false; }
        public boolean isBubbleSuppressed(){ return false; }
        public boolean isNotificationSuppressed(){ return false; }
        public int describeContents(){ return 0; }
        public int getDesiredHeight(){ return 0; }
        public int getDesiredHeightResId(){ return 0; }
        public static Parcelable.Creator<Notification.BubbleMetadata> CREATOR = null;
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class Builder
    {
        protected Builder() {}
        public Builder(Context p0){}
        public Builder(Context p0, String p1){}
        public Bundle getExtras(){ return null; }
        public Notification build(){ return null; }
        public Notification getNotification(){ return null; }
        public Notification.Builder addAction(Notification.Action p0){ return null; }
        public Notification.Builder addAction(int p0, CharSequence p1, PendingIntent p2){ return null; }
        public Notification.Builder addExtras(Bundle p0){ return null; }
        public Notification.Builder addPerson(Person p0){ return null; }
        public Notification.Builder addPerson(String p0){ return null; }
        public Notification.Builder extend(Notification.Extender p0){ return null; }
        public Notification.Builder setActions(Notification.Action... p0){ return null; }
        public Notification.Builder setAllowSystemGeneratedContextualActions(boolean p0){ return null; }
        public Notification.Builder setAutoCancel(boolean p0){ return null; }
        public Notification.Builder setBadgeIconType(int p0){ return null; }
        public Notification.Builder setBubbleMetadata(Notification.BubbleMetadata p0){ return null; }
        public Notification.Builder setCategory(String p0){ return null; }
        public Notification.Builder setChannelId(String p0){ return null; }
        public Notification.Builder setChronometerCountDown(boolean p0){ return null; }
        public Notification.Builder setColor(int p0){ return null; }
        public Notification.Builder setColorized(boolean p0){ return null; }
        public Notification.Builder setContent(RemoteViews p0){ return null; }
        public Notification.Builder setContentInfo(CharSequence p0){ return null; }
        public Notification.Builder setContentIntent(PendingIntent p0){ return null; }
        public Notification.Builder setContentText(CharSequence p0){ return null; }
        public Notification.Builder setContentTitle(CharSequence p0){ return null; }
        public Notification.Builder setCustomBigContentView(RemoteViews p0){ return null; }
        public Notification.Builder setCustomContentView(RemoteViews p0){ return null; }
        public Notification.Builder setCustomHeadsUpContentView(RemoteViews p0){ return null; }
        public Notification.Builder setDefaults(int p0){ return null; }
        public Notification.Builder setDeleteIntent(PendingIntent p0){ return null; }
        public Notification.Builder setExtras(Bundle p0){ return null; }
        public Notification.Builder setFlag(int p0, boolean p1){ return null; }
        public Notification.Builder setForegroundServiceBehavior(int p0){ return null; }
        public Notification.Builder setFullScreenIntent(PendingIntent p0, boolean p1){ return null; }
        public Notification.Builder setGroup(String p0){ return null; }
        public Notification.Builder setGroupAlertBehavior(int p0){ return null; }
        public Notification.Builder setGroupSummary(boolean p0){ return null; }
        public Notification.Builder setLargeIcon(Bitmap p0){ return null; }
        public Notification.Builder setLargeIcon(Icon p0){ return null; }
        public Notification.Builder setLights(int p0, int p1, int p2){ return null; }
        public Notification.Builder setLocalOnly(boolean p0){ return null; }
        public Notification.Builder setLocusId(LocusId p0){ return null; }
        public Notification.Builder setNumber(int p0){ return null; }
        public Notification.Builder setOngoing(boolean p0){ return null; }
        public Notification.Builder setOnlyAlertOnce(boolean p0){ return null; }
        public Notification.Builder setPriority(int p0){ return null; }
        public Notification.Builder setProgress(int p0, int p1, boolean p2){ return null; }
        public Notification.Builder setPublicVersion(Notification p0){ return null; }
        public Notification.Builder setRemoteInputHistory(CharSequence[] p0){ return null; }
        public Notification.Builder setSettingsText(CharSequence p0){ return null; }
        public Notification.Builder setShortcutId(String p0){ return null; }
        public Notification.Builder setShowWhen(boolean p0){ return null; }
        public Notification.Builder setSmallIcon(Icon p0){ return null; }
        public Notification.Builder setSmallIcon(int p0){ return null; }
        public Notification.Builder setSmallIcon(int p0, int p1){ return null; }
        public Notification.Builder setSortKey(String p0){ return null; }
        public Notification.Builder setSound(Uri p0){ return null; }
        public Notification.Builder setSound(Uri p0, AudioAttributes p1){ return null; }
        public Notification.Builder setSound(Uri p0, int p1){ return null; }
        public Notification.Builder setStyle(Notification.Style p0){ return null; }
        public Notification.Builder setSubText(CharSequence p0){ return null; }
        public Notification.Builder setTicker(CharSequence p0){ return null; }
        public Notification.Builder setTicker(CharSequence p0, RemoteViews p1){ return null; }
        public Notification.Builder setTimeoutAfter(long p0){ return null; }
        public Notification.Builder setUsesChronometer(boolean p0){ return null; }
        public Notification.Builder setVibrate(long[] p0){ return null; }
        public Notification.Builder setVisibility(int p0){ return null; }
        public Notification.Builder setWhen(long p0){ return null; }
        public Notification.Style getStyle(){ return null; }
        public RemoteViews createBigContentView(){ return null; }
        public RemoteViews createContentView(){ return null; }
        public RemoteViews createHeadsUpContentView(){ return null; }
        public static Notification.Builder recoverBuilder(Context p0, Notification p1){ return null; }
    }
    static public class CallStyle extends Notification.Style
    {
        public Notification.CallStyle setAnswerButtonColorHint(int p0){ return null; }
        public Notification.CallStyle setDeclineButtonColorHint(int p0){ return null; }
        public Notification.CallStyle setIsVideo(boolean p0){ return null; }
        public Notification.CallStyle setVerificationIcon(Icon p0){ return null; }
        public Notification.CallStyle setVerificationText(CharSequence p0){ return null; }
        public static Notification.CallStyle forIncomingCall(Person p0, PendingIntent p1, PendingIntent p2){ return null; }
        public static Notification.CallStyle forOngoingCall(Person p0, PendingIntent p1){ return null; }
        public static Notification.CallStyle forScreeningCall(Person p0, PendingIntent p1, PendingIntent p2){ return null; }
    }
    static public class InboxStyle extends Notification.Style
    {
        public InboxStyle(){}
        public InboxStyle(Notification.Builder p0){}
        public Notification.InboxStyle addLine(CharSequence p0){ return null; }
        public Notification.InboxStyle setBigContentTitle(CharSequence p0){ return null; }
        public Notification.InboxStyle setSummaryText(CharSequence p0){ return null; }
    }
    static public class MediaStyle extends Notification.Style
    {
        public MediaStyle(){}
        public MediaStyle(Notification.Builder p0){}
        public Notification.MediaStyle setMediaSession(MediaSession.Token p0){ return null; }
        public Notification.MediaStyle setRemotePlaybackInfo(CharSequence p0, int p1, PendingIntent p2){ return null; } // added manually
        public Notification.MediaStyle setShowActionsInCompactView(int... p0){ return null; }
    }
    static public class MessagingStyle extends Notification.Style
    {
        protected MessagingStyle() {}
        public CharSequence getConversationTitle(){ return null; }
        public CharSequence getUserDisplayName(){ return null; }
        public List<Notification.MessagingStyle.Message> getHistoricMessages(){ return null; }
        public List<Notification.MessagingStyle.Message> getMessages(){ return null; }
        public MessagingStyle(CharSequence p0){}
        public MessagingStyle(Person p0){}
        public Notification.MessagingStyle addHistoricMessage(Notification.MessagingStyle.Message p0){ return null; }
        public Notification.MessagingStyle addMessage(CharSequence p0, long p1, CharSequence p2){ return null; }
        public Notification.MessagingStyle addMessage(CharSequence p0, long p1, Person p2){ return null; }
        public Notification.MessagingStyle addMessage(Notification.MessagingStyle.Message p0){ return null; }
        public Notification.MessagingStyle setConversationTitle(CharSequence p0){ return null; }
        public Notification.MessagingStyle setGroupConversation(boolean p0){ return null; }
        public Person getUser(){ return null; }
        public boolean isGroupConversation(){ return false; }
        public static int MAXIMUM_RETAINED_MESSAGES = 0;
        static public class Message
        {
            protected Message() {}
            public Bundle getExtras(){ return null; }
            public CharSequence getSender(){ return null; }
            public CharSequence getText(){ return null; }
            public Message(CharSequence p0, long p1, CharSequence p2){}
            public Message(CharSequence p0, long p1, Person p2){}
            public Notification.MessagingStyle.Message setData(String p0, Uri p1){ return null; }
            public Person getSenderPerson(){ return null; }
            public String getDataMimeType(){ return null; }
            public Uri getDataUri(){ return null; }
            public long getTimestamp(){ return 0; }
            public static List<Notification.MessagingStyle.Message> getMessagesFromBundleArray(Parcelable[] p0){ return null; }
        }
    }
    static public interface Extender
    {
        Notification.Builder extend(Notification.Builder p0);
    }
}
