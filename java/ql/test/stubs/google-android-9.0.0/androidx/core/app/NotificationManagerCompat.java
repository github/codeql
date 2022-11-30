// Generated automatically from androidx.core.app.NotificationManagerCompat for testing purposes

package androidx.core.app;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationChannelGroup;
import android.content.Context;
import java.util.List;
import java.util.Set;

public class NotificationManagerCompat
{
    protected NotificationManagerCompat() {}
    public List<NotificationChannel> getNotificationChannels(){ return null; }
    public List<NotificationChannelGroup> getNotificationChannelGroups(){ return null; }
    public NotificationChannel getNotificationChannel(String p0){ return null; }
    public NotificationChannelGroup getNotificationChannelGroup(String p0){ return null; }
    public boolean areNotificationsEnabled(){ return false; }
    public int getImportance(){ return 0; }
    public static NotificationManagerCompat from(Context p0){ return null; }
    public static Set<String> getEnabledListenerPackages(Context p0){ return null; }
    public static String ACTION_BIND_SIDE_CHANNEL = null;
    public static String EXTRA_USE_SIDE_CHANNEL = null;
    public static int IMPORTANCE_DEFAULT = 0;
    public static int IMPORTANCE_HIGH = 0;
    public static int IMPORTANCE_LOW = 0;
    public static int IMPORTANCE_MAX = 0;
    public static int IMPORTANCE_MIN = 0;
    public static int IMPORTANCE_NONE = 0;
    public static int IMPORTANCE_UNSPECIFIED = 0;
    public void cancel(String p0, int p1){}
    public void cancel(int p0){}
    public void cancelAll(){}
    public void createNotificationChannel(NotificationChannel p0){}
    public void createNotificationChannelGroup(NotificationChannelGroup p0){}
    public void createNotificationChannelGroups(List<NotificationChannelGroup> p0){}
    public void createNotificationChannels(List<NotificationChannel> p0){}
    public void deleteNotificationChannel(String p0){}
    public void deleteNotificationChannelGroup(String p0){}
    public void notify(String p0, int p1, Notification p2){}
    public void notify(int p0, Notification p1){}
}
