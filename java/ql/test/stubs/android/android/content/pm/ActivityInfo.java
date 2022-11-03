// Generated automatically from android.content.pm.ActivityInfo for testing purposes

package android.content.pm;

import android.content.pm.ComponentInfo;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Printer;

public class ActivityInfo extends ComponentInfo implements Parcelable
{
    public ActivityInfo(){}
    public ActivityInfo(ActivityInfo p0){}
    public ActivityInfo.WindowLayout windowLayout = null;
    public String parentActivityName = null;
    public String permission = null;
    public String targetActivity = null;
    public String taskAffinity = null;
    public String toString(){ return null; }
    public final int getThemeResource(){ return 0; }
    public int colorMode = 0;
    public int configChanges = 0;
    public int describeContents(){ return 0; }
    public int documentLaunchMode = 0;
    public int flags = 0;
    public int launchMode = 0;
    public int maxRecents = 0;
    public int persistableMode = 0;
    public int screenOrientation = 0;
    public int softInputMode = 0;
    public int theme = 0;
    public int uiOptions = 0;
    public static Parcelable.Creator<ActivityInfo> CREATOR = null;
    public static int COLOR_MODE_DEFAULT = 0;
    public static int COLOR_MODE_HDR = 0;
    public static int COLOR_MODE_WIDE_COLOR_GAMUT = 0;
    public static int CONFIG_COLOR_MODE = 0;
    public static int CONFIG_DENSITY = 0;
    public static int CONFIG_FONT_SCALE = 0;
    public static int CONFIG_KEYBOARD = 0;
    public static int CONFIG_KEYBOARD_HIDDEN = 0;
    public static int CONFIG_LAYOUT_DIRECTION = 0;
    public static int CONFIG_LOCALE = 0;
    public static int CONFIG_MCC = 0;
    public static int CONFIG_MNC = 0;
    public static int CONFIG_NAVIGATION = 0;
    public static int CONFIG_ORIENTATION = 0;
    public static int CONFIG_SCREEN_LAYOUT = 0;
    public static int CONFIG_SCREEN_SIZE = 0;
    public static int CONFIG_SMALLEST_SCREEN_SIZE = 0;
    public static int CONFIG_TOUCHSCREEN = 0;
    public static int CONFIG_UI_MODE = 0;
    public static int DOCUMENT_LAUNCH_ALWAYS = 0;
    public static int DOCUMENT_LAUNCH_INTO_EXISTING = 0;
    public static int DOCUMENT_LAUNCH_NEVER = 0;
    public static int DOCUMENT_LAUNCH_NONE = 0;
    public static int FLAG_ALLOW_TASK_REPARENTING = 0;
    public static int FLAG_ALWAYS_RETAIN_TASK_STATE = 0;
    public static int FLAG_AUTO_REMOVE_FROM_RECENTS = 0;
    public static int FLAG_CLEAR_TASK_ON_LAUNCH = 0;
    public static int FLAG_ENABLE_VR_MODE = 0;
    public static int FLAG_EXCLUDE_FROM_RECENTS = 0;
    public static int FLAG_FINISH_ON_CLOSE_SYSTEM_DIALOGS = 0;
    public static int FLAG_FINISH_ON_TASK_LAUNCH = 0;
    public static int FLAG_HARDWARE_ACCELERATED = 0;
    public static int FLAG_IMMERSIVE = 0;
    public static int FLAG_MULTIPROCESS = 0;
    public static int FLAG_NO_HISTORY = 0;
    public static int FLAG_PREFER_MINIMAL_POST_PROCESSING = 0;
    public static int FLAG_RELINQUISH_TASK_IDENTITY = 0;
    public static int FLAG_RESUME_WHILE_PAUSING = 0;
    public static int FLAG_SINGLE_USER = 0;
    public static int FLAG_STATE_NOT_NEEDED = 0;
    public static int LAUNCH_MULTIPLE = 0;
    public static int LAUNCH_SINGLE_INSTANCE = 0;
    public static int LAUNCH_SINGLE_TASK = 0;
    public static int LAUNCH_SINGLE_TOP = 0;
    public static int PERSIST_ACROSS_REBOOTS = 0;
    public static int PERSIST_NEVER = 0;
    public static int PERSIST_ROOT_ONLY = 0;
    public static int SCREEN_ORIENTATION_BEHIND = 0;
    public static int SCREEN_ORIENTATION_FULL_SENSOR = 0;
    public static int SCREEN_ORIENTATION_FULL_USER = 0;
    public static int SCREEN_ORIENTATION_LANDSCAPE = 0;
    public static int SCREEN_ORIENTATION_LOCKED = 0;
    public static int SCREEN_ORIENTATION_NOSENSOR = 0;
    public static int SCREEN_ORIENTATION_PORTRAIT = 0;
    public static int SCREEN_ORIENTATION_REVERSE_LANDSCAPE = 0;
    public static int SCREEN_ORIENTATION_REVERSE_PORTRAIT = 0;
    public static int SCREEN_ORIENTATION_SENSOR = 0;
    public static int SCREEN_ORIENTATION_SENSOR_LANDSCAPE = 0;
    public static int SCREEN_ORIENTATION_SENSOR_PORTRAIT = 0;
    public static int SCREEN_ORIENTATION_UNSPECIFIED = 0;
    public static int SCREEN_ORIENTATION_USER = 0;
    public static int SCREEN_ORIENTATION_USER_LANDSCAPE = 0;
    public static int SCREEN_ORIENTATION_USER_PORTRAIT = 0;
    public static int UIOPTION_SPLIT_ACTION_BAR_WHEN_NARROW = 0;
    public void dump(Printer p0, String p1){}
    public void writeToParcel(Parcel p0, int p1){}
    static public class WindowLayout
    {
        protected WindowLayout() {}
        public WindowLayout(int p0, float p1, int p2, float p3, int p4, int p5, int p6){}
        public final float heightFraction = 0;
        public final float widthFraction = 0;
        public final int gravity = 0;
        public final int height = 0;
        public final int minHeight = 0;
        public final int minWidth = 0;
        public final int width = 0;
    }
}
