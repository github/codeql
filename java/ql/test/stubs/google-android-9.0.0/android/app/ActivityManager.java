// Generated automatically from android.app.ActivityManager for testing purposes

package android.app;

import android.app.Activity;
import android.app.ApplicationExitInfo;
import android.app.PendingIntent;
import android.app.TaskInfo;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ConfigurationInfo;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Debug;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Size;
import java.io.FileDescriptor;
import java.util.List;

public class ActivityManager
{
    public ConfigurationInfo getDeviceConfigurationInfo(){ return null; }
    public Debug.MemoryInfo[] getProcessMemoryInfo(int[] p0){ return null; }
    public List<ActivityManager.AppTask> getAppTasks(){ return null; }
    public List<ActivityManager.ProcessErrorStateInfo> getProcessesInErrorState(){ return null; }
    public List<ActivityManager.RecentTaskInfo> getRecentTasks(int p0, int p1){ return null; }
    public List<ActivityManager.RunningAppProcessInfo> getRunningAppProcesses(){ return null; }
    public List<ActivityManager.RunningServiceInfo> getRunningServices(int p0){ return null; }
    public List<ActivityManager.RunningTaskInfo> getRunningTasks(int p0){ return null; }
    public List<ApplicationExitInfo> getHistoricalProcessExitReasons(String p0, int p1, int p2){ return null; }
    public PendingIntent getRunningServiceControlPanel(ComponentName p0){ return null; }
    public Size getAppTaskThumbnailSize(){ return null; }
    public boolean clearApplicationUserData(){ return false; }
    public boolean isActivityStartAllowedOnDisplay(Context p0, int p1, Intent p2){ return false; }
    public boolean isBackgroundRestricted(){ return false; }
    public boolean isInLockTaskMode(){ return false; }
    public boolean isLowRamDevice(){ return false; }
    public int addAppTask(Activity p0, Intent p1, ActivityManager.TaskDescription p2, Bitmap p3){ return 0; }
    public int getLargeMemoryClass(){ return 0; }
    public int getLauncherLargeIconDensity(){ return 0; }
    public int getLauncherLargeIconSize(){ return 0; }
    public int getLockTaskModeState(){ return 0; }
    public int getMemoryClass(){ return 0; }
    public static String ACTION_REPORT_HEAP_LIMIT = null;
    public static String META_HOME_ALTERNATE = null;
    public static boolean isLowMemoryKillReportSupported(){ return false; }
    public static boolean isRunningInTestHarness(){ return false; }
    public static boolean isRunningInUserTestHarness(){ return false; }
    public static boolean isUserAMonkey(){ return false; }
    public static int LOCK_TASK_MODE_LOCKED = 0;
    public static int LOCK_TASK_MODE_NONE = 0;
    public static int LOCK_TASK_MODE_PINNED = 0;
    public static int MOVE_TASK_NO_USER_ACTION = 0;
    public static int MOVE_TASK_WITH_HOME = 0;
    public static int RECENT_IGNORE_UNAVAILABLE = 0;
    public static int RECENT_WITH_EXCLUDED = 0;
    public static void getMyMemoryState(ActivityManager.RunningAppProcessInfo p0){}
    public static void setVrThread(int p0){}
    public void appNotResponding(String p0){}
    public void clearWatchHeapLimit(){}
    public void dumpPackageState(FileDescriptor p0, String p1){}
    public void getMemoryInfo(ActivityManager.MemoryInfo p0){}
    public void killBackgroundProcesses(String p0){}
    public void moveTaskToFront(int p0, int p1){}
    public void moveTaskToFront(int p0, int p1, Bundle p2){}
    public void restartPackage(String p0){}
    public void setProcessStateSummary(byte[] p0){}
    public void setWatchHeapLimit(long p0){}
    static public class AppTask
    {
        public ActivityManager.RecentTaskInfo getTaskInfo(){ return null; }
        public void finishAndRemoveTask(){}
        public void moveToFront(){}
        public void setExcludeFromRecents(boolean p0){}
        public void startActivity(Context p0, Intent p1, Bundle p2){}
    }
    static public class MemoryInfo implements Parcelable
    {
        public MemoryInfo(){}
        public boolean lowMemory = false;
        public int describeContents(){ return 0; }
        public long availMem = 0;
        public long threshold = 0;
        public long totalMem = 0;
        public static Parcelable.Creator<ActivityManager.MemoryInfo> CREATOR = null;
        public void readFromParcel(Parcel p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class ProcessErrorStateInfo implements Parcelable
    {
        public ProcessErrorStateInfo(){}
        public String longMsg = null;
        public String processName = null;
        public String shortMsg = null;
        public String stackTrace = null;
        public String tag = null;
        public byte[] crashData = null;
        public int condition = 0;
        public int describeContents(){ return 0; }
        public int pid = 0;
        public int uid = 0;
        public static Parcelable.Creator<ActivityManager.ProcessErrorStateInfo> CREATOR = null;
        public static int CRASHED = 0;
        public static int NOT_RESPONDING = 0;
        public static int NO_ERROR = 0;
        public void readFromParcel(Parcel p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class RecentTaskInfo extends TaskInfo implements Parcelable
    {
        public CharSequence description = null;
        public RecentTaskInfo(){}
        public int affiliatedTaskId = 0;
        public int describeContents(){ return 0; }
        public int id = 0;
        public int persistentId = 0;
        public static Parcelable.Creator<ActivityManager.RecentTaskInfo> CREATOR = null;
        public void readFromParcel(Parcel p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class RunningAppProcessInfo implements Parcelable
    {
        public ComponentName importanceReasonComponent = null;
        public RunningAppProcessInfo(){}
        public RunningAppProcessInfo(String p0, int p1, String[] p2){}
        public String processName = null;
        public String[] pkgList = null;
        public int describeContents(){ return 0; }
        public int importance = 0;
        public int importanceReasonCode = 0;
        public int importanceReasonPid = 0;
        public int lastTrimLevel = 0;
        public int lru = 0;
        public int pid = 0;
        public int uid = 0;
        public static Parcelable.Creator<ActivityManager.RunningAppProcessInfo> CREATOR = null;
        public static int IMPORTANCE_BACKGROUND = 0;
        public static int IMPORTANCE_CACHED = 0;
        public static int IMPORTANCE_CANT_SAVE_STATE = 0;
        public static int IMPORTANCE_EMPTY = 0;
        public static int IMPORTANCE_FOREGROUND = 0;
        public static int IMPORTANCE_FOREGROUND_SERVICE = 0;
        public static int IMPORTANCE_GONE = 0;
        public static int IMPORTANCE_PERCEPTIBLE = 0;
        public static int IMPORTANCE_PERCEPTIBLE_PRE_26 = 0;
        public static int IMPORTANCE_SERVICE = 0;
        public static int IMPORTANCE_TOP_SLEEPING = 0;
        public static int IMPORTANCE_TOP_SLEEPING_PRE_28 = 0;
        public static int IMPORTANCE_VISIBLE = 0;
        public static int REASON_PROVIDER_IN_USE = 0;
        public static int REASON_SERVICE_IN_USE = 0;
        public static int REASON_UNKNOWN = 0;
        public void readFromParcel(Parcel p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class RunningServiceInfo implements Parcelable
    {
        public ComponentName service = null;
        public RunningServiceInfo(){}
        public String clientPackage = null;
        public String process = null;
        public boolean foreground = false;
        public boolean started = false;
        public int clientCount = 0;
        public int clientLabel = 0;
        public int crashCount = 0;
        public int describeContents(){ return 0; }
        public int flags = 0;
        public int pid = 0;
        public int uid = 0;
        public long activeSince = 0;
        public long lastActivityTime = 0;
        public long restarting = 0;
        public static Parcelable.Creator<ActivityManager.RunningServiceInfo> CREATOR = null;
        public static int FLAG_FOREGROUND = 0;
        public static int FLAG_PERSISTENT_PROCESS = 0;
        public static int FLAG_STARTED = 0;
        public static int FLAG_SYSTEM_PROCESS = 0;
        public void readFromParcel(Parcel p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class RunningTaskInfo extends TaskInfo implements Parcelable
    {
        public Bitmap thumbnail = null;
        public CharSequence description = null;
        public RunningTaskInfo(){}
        public int describeContents(){ return 0; }
        public int id = 0;
        public int numRunning = 0;
        public static Parcelable.Creator<ActivityManager.RunningTaskInfo> CREATOR = null;
        public void readFromParcel(Parcel p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
    static public class TaskDescription implements Parcelable
    {
        public Bitmap getIcon(){ return null; }
        public String getLabel(){ return null; }
        public String toString(){ return null; }
        public TaskDescription(){}
        public TaskDescription(ActivityManager.TaskDescription p0){}
        public TaskDescription(String p0){}
        public TaskDescription(String p0, Bitmap p1){}
        public TaskDescription(String p0, Bitmap p1, int p2){}
        public TaskDescription(String p0, int p1){}
        public TaskDescription(String p0, int p1, int p2){}
        public boolean equals(Object p0){ return false; }
        public int describeContents(){ return 0; }
        public int getPrimaryColor(){ return 0; }
        public static Parcelable.Creator<ActivityManager.TaskDescription> CREATOR = null;
        public void readFromParcel(Parcel p0){}
        public void writeToParcel(Parcel p0, int p1){}
    }
}
