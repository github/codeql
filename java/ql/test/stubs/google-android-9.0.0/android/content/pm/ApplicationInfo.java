// Generated automatically from android.content.pm.ApplicationInfo for testing purposes

package android.content.pm;

import android.content.Context;
import android.content.pm.PackageItemInfo;
import android.content.pm.PackageManager;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Printer;
import java.util.UUID;

public class ApplicationInfo extends PackageItemInfo implements Parcelable
{
    public ApplicationInfo(){}
    public ApplicationInfo(ApplicationInfo p0){}
    public CharSequence loadDescription(PackageManager p0){ return null; }
    public String appComponentFactory = null;
    public String backupAgentName = null;
    public String className = null;
    public String compileSdkVersionCodename = null;
    public String dataDir = null;
    public String deviceProtectedDataDir = null;
    public String manageSpaceActivityName = null;
    public String nativeLibraryDir = null;
    public String permission = null;
    public String processName = null;
    public String publicSourceDir = null;
    public String sourceDir = null;
    public String taskAffinity = null;
    public String toString(){ return null; }
    public String[] sharedLibraryFiles = null;
    public String[] splitNames = null;
    public String[] splitPublicSourceDirs = null;
    public String[] splitSourceDirs = null;
    public UUID storageUuid = null;
    public boolean areAttributionsUserVisible(){ return false; }
    public boolean enabled = false;
    public boolean isProfileable(){ return false; }
    public boolean isProfileableByShell(){ return false; }
    public boolean isResourceOverlay(){ return false; }
    public boolean isVirtualPreload(){ return false; }
    public int category = 0;
    public int compatibleWidthLimitDp = 0;
    public int compileSdkVersion = 0;
    public int describeContents(){ return 0; }
    public int descriptionRes = 0;
    public int flags = 0;
    public int getGwpAsanMode(){ return 0; }
    public int getMemtagMode(){ return 0; }
    public int getNativeHeapZeroInitialized(){ return 0; }
    public int getRequestRawExternalStorageAccess(){ return 0; }
    public int largestWidthLimitDp = 0;
    public int minSdkVersion = 0;
    public int requiresSmallestWidthDp = 0;
    public int targetSdkVersion = 0;
    public int theme = 0;
    public int uiOptions = 0;
    public int uid = 0;
    public static CharSequence getCategoryTitle(Context p0, int p1){ return null; }
    public static Parcelable.Creator<ApplicationInfo> CREATOR = null;
    public static int CATEGORY_ACCESSIBILITY = 0;
    public static int CATEGORY_AUDIO = 0;
    public static int CATEGORY_GAME = 0;
    public static int CATEGORY_IMAGE = 0;
    public static int CATEGORY_MAPS = 0;
    public static int CATEGORY_NEWS = 0;
    public static int CATEGORY_PRODUCTIVITY = 0;
    public static int CATEGORY_SOCIAL = 0;
    public static int CATEGORY_UNDEFINED = 0;
    public static int CATEGORY_VIDEO = 0;
    public static int FLAG_ALLOW_BACKUP = 0;
    public static int FLAG_ALLOW_CLEAR_USER_DATA = 0;
    public static int FLAG_ALLOW_TASK_REPARENTING = 0;
    public static int FLAG_DEBUGGABLE = 0;
    public static int FLAG_EXTERNAL_STORAGE = 0;
    public static int FLAG_EXTRACT_NATIVE_LIBS = 0;
    public static int FLAG_FACTORY_TEST = 0;
    public static int FLAG_FULL_BACKUP_ONLY = 0;
    public static int FLAG_HARDWARE_ACCELERATED = 0;
    public static int FLAG_HAS_CODE = 0;
    public static int FLAG_INSTALLED = 0;
    public static int FLAG_IS_DATA_ONLY = 0;
    public static int FLAG_IS_GAME = 0;
    public static int FLAG_KILL_AFTER_RESTORE = 0;
    public static int FLAG_LARGE_HEAP = 0;
    public static int FLAG_MULTIARCH = 0;
    public static int FLAG_PERSISTENT = 0;
    public static int FLAG_RESIZEABLE_FOR_SCREENS = 0;
    public static int FLAG_RESTORE_ANY_VERSION = 0;
    public static int FLAG_STOPPED = 0;
    public static int FLAG_SUPPORTS_LARGE_SCREENS = 0;
    public static int FLAG_SUPPORTS_NORMAL_SCREENS = 0;
    public static int FLAG_SUPPORTS_RTL = 0;
    public static int FLAG_SUPPORTS_SCREEN_DENSITIES = 0;
    public static int FLAG_SUPPORTS_SMALL_SCREENS = 0;
    public static int FLAG_SUPPORTS_XLARGE_SCREENS = 0;
    public static int FLAG_SUSPENDED = 0;
    public static int FLAG_SYSTEM = 0;
    public static int FLAG_TEST_ONLY = 0;
    public static int FLAG_UPDATED_SYSTEM_APP = 0;
    public static int FLAG_USES_CLEARTEXT_TRAFFIC = 0;
    public static int FLAG_VM_SAFE_MODE = 0;
    public static int GWP_ASAN_ALWAYS = 0;
    public static int GWP_ASAN_DEFAULT = 0;
    public static int GWP_ASAN_NEVER = 0;
    public static int MEMTAG_ASYNC = 0;
    public static int MEMTAG_DEFAULT = 0;
    public static int MEMTAG_OFF = 0;
    public static int MEMTAG_SYNC = 0;
    public static int RAW_EXTERNAL_STORAGE_ACCESS_DEFAULT = 0;
    public static int RAW_EXTERNAL_STORAGE_ACCESS_NOT_REQUESTED = 0;
    public static int RAW_EXTERNAL_STORAGE_ACCESS_REQUESTED = 0;
    public static int ZEROINIT_DEFAULT = 0;
    public static int ZEROINIT_DISABLED = 0;
    public static int ZEROINIT_ENABLED = 0;
    public void dump(Printer p0, String p1){}
    public void writeToParcel(Parcel p0, int p1){}
}
