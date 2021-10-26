// Generated automatically from android.content.Intent for testing purposes

package android.content;

import android.content.ClipData;
import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.Context;
import android.content.IntentSender;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.AttributeSet;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Set;
import org.xmlpull.v1.XmlPullParser;

public class Intent implements Cloneable, Parcelable
{
    public <T extends Parcelable> ArrayList<T> getParcelableArrayListExtra(String p0){ return null; }
    public <T extends Parcelable> T getParcelableExtra(String p0){ return null; }
    public ActivityInfo resolveActivityInfo(PackageManager p0, int p1){ return null; }
    public ArrayList<CharSequence> getCharSequenceArrayListExtra(String p0){ return null; }
    public ArrayList<Integer> getIntegerArrayListExtra(String p0){ return null; }
    public ArrayList<String> getStringArrayListExtra(String p0){ return null; }
    public Bundle getBundleExtra(String p0){ return null; }
    public Bundle getExtras(){ return null; }
    public CharSequence getCharSequenceExtra(String p0){ return null; }
    public CharSequence[] getCharSequenceArrayExtra(String p0){ return null; }
    public ClipData getClipData(){ return null; }
    public ComponentName getComponent(){ return null; }
    public ComponentName resolveActivity(PackageManager p0){ return null; }
    public Intent addCategory(String p0){ return null; }
    public Intent addFlags(int p0){ return null; }
    public Intent cloneFilter(){ return null; }
    public Intent getSelector(){ return null; }
    public Intent putCharSequenceArrayListExtra(String p0, ArrayList<CharSequence> p1){ return null; }
    public Intent putExtra(String p0, Bundle p1){ return null; }
    public Intent putExtra(String p0, CharSequence p1){ return null; }
    public Intent putExtra(String p0, CharSequence[] p1){ return null; }
    public Intent putExtra(String p0, Parcelable p1){ return null; }
    public Intent putExtra(String p0, Parcelable[] p1){ return null; }
    public Intent putExtra(String p0, Serializable p1){ return null; }
    public Intent putExtra(String p0, String p1){ return null; }
    public Intent putExtra(String p0, String[] p1){ return null; }
    public Intent putExtra(String p0, boolean p1){ return null; }
    public Intent putExtra(String p0, boolean[] p1){ return null; }
    public Intent putExtra(String p0, byte p1){ return null; }
    public Intent putExtra(String p0, byte[] p1){ return null; }
    public Intent putExtra(String p0, char p1){ return null; }
    public Intent putExtra(String p0, char[] p1){ return null; }
    public Intent putExtra(String p0, double p1){ return null; }
    public Intent putExtra(String p0, double[] p1){ return null; }
    public Intent putExtra(String p0, float p1){ return null; }
    public Intent putExtra(String p0, float[] p1){ return null; }
    public Intent putExtra(String p0, int p1){ return null; }
    public Intent putExtra(String p0, int[] p1){ return null; }
    public Intent putExtra(String p0, long p1){ return null; }
    public Intent putExtra(String p0, long[] p1){ return null; }
    public Intent putExtra(String p0, short p1){ return null; }
    public Intent putExtra(String p0, short[] p1){ return null; }
    public Intent putExtras(Bundle p0){ return null; }
    public Intent putExtras(Intent p0){ return null; }
    public Intent putIntegerArrayListExtra(String p0, ArrayList<Integer> p1){ return null; }
    public Intent putParcelableArrayListExtra(String p0, ArrayList<? extends Parcelable> p1){ return null; }
    public Intent putStringArrayListExtra(String p0, ArrayList<String> p1){ return null; }
    public Intent replaceExtras(Bundle p0){ return null; }
    public Intent replaceExtras(Intent p0){ return null; }
    public Intent setAction(String p0){ return null; }
    public Intent setClass(Context p0, Class<? extends Object> p1){ return null; }
    public Intent setClassName(Context p0, String p1){ return null; }
    public Intent setClassName(String p0, String p1){ return null; }
    public Intent setComponent(ComponentName p0){ return null; }
    public Intent setData(Uri p0){ return null; }
    public Intent setDataAndNormalize(Uri p0){ return null; }
    public Intent setDataAndType(Uri p0, String p1){ return null; }
    public Intent setDataAndTypeAndNormalize(Uri p0, String p1){ return null; }
    public Intent setFlags(int p0){ return null; }
    public Intent setIdentifier(String p0){ return null; }
    public Intent setPackage(String p0){ return null; }
    public Intent setType(String p0){ return null; }
    public Intent setTypeAndNormalize(String p0){ return null; }
    public Intent(){}
    public Intent(Context p0, Class<? extends Object> p1){}
    public Intent(Intent p0){}
    public Intent(String p0){}
    public Intent(String p0, Uri p1){}
    public Intent(String p0, Uri p1, Context p2, Class<? extends Object> p3){}
    public Object clone(){ return null; }
    public Parcelable[] getParcelableArrayExtra(String p0){ return null; }
    public Rect getSourceBounds(){ return null; }
    public Serializable getSerializableExtra(String p0){ return null; }
    public Set<String> getCategories(){ return null; }
    public String getAction(){ return null; }
    public String getDataString(){ return null; }
    public String getIdentifier(){ return null; }
    public String getPackage(){ return null; }
    public String getScheme(){ return null; }
    public String getStringExtra(String p0){ return null; }
    public String getType(){ return null; }
    public String resolveType(ContentResolver p0){ return null; }
    public String resolveType(Context p0){ return null; }
    public String resolveTypeIfNeeded(ContentResolver p0){ return null; }
    public String toString(){ return null; }
    public String toURI(){ return null; }
    public String toUri(int p0){ return null; }
    public String[] getStringArrayExtra(String p0){ return null; }
    public Uri getData(){ return null; }
    public boolean filterEquals(Intent p0){ return false; }
    public boolean getBooleanExtra(String p0, boolean p1){ return false; }
    public boolean hasCategory(String p0){ return false; }
    public boolean hasExtra(String p0){ return false; }
    public boolean hasFileDescriptors(){ return false; }
    public boolean[] getBooleanArrayExtra(String p0){ return null; }
    public byte getByteExtra(String p0, byte p1){ return 0; }
    public byte[] getByteArrayExtra(String p0){ return null; }
    public char getCharExtra(String p0, char p1){ return '0'; }
    public char[] getCharArrayExtra(String p0){ return null; }
    public double getDoubleExtra(String p0, double p1){ return 0; }
    public double[] getDoubleArrayExtra(String p0){ return null; }
    public float getFloatExtra(String p0, float p1){ return 0; }
    public float[] getFloatArrayExtra(String p0){ return null; }
    public int describeContents(){ return 0; }
    public int fillIn(Intent p0, int p1){ return 0; }
    public int filterHashCode(){ return 0; }
    public int getFlags(){ return 0; }
    public int getIntExtra(String p0, int p1){ return 0; }
    public int[] getIntArrayExtra(String p0){ return null; }
    public long getLongExtra(String p0, long p1){ return 0; }
    public long[] getLongArrayExtra(String p0){ return null; }
    public short getShortExtra(String p0, short p1){ return 0; }
    public short[] getShortArrayExtra(String p0){ return null; }
    public static Intent createChooser(Intent p0, CharSequence p1){ return null; }
    public static Intent createChooser(Intent p0, CharSequence p1, IntentSender p2){ return null; }
    public static Intent getIntent(String p0){ return null; }
    public static Intent getIntentOld(String p0){ return null; }
    public static Intent makeMainActivity(ComponentName p0){ return null; }
    public static Intent makeMainSelectorActivity(String p0, String p1){ return null; }
    public static Intent makeRestartActivityTask(ComponentName p0){ return null; }
    public static Intent parseIntent(Resources p0, XmlPullParser p1, AttributeSet p2){ return null; }
    public static Intent parseUri(String p0, int p1){ return null; }
    public static Parcelable.Creator<Intent> CREATOR = null;
    public static String ACTION_AIRPLANE_MODE_CHANGED = null;
    public static String ACTION_ALL_APPS = null;
    public static String ACTION_ANSWER = null;
    public static String ACTION_APPLICATION_PREFERENCES = null;
    public static String ACTION_APPLICATION_RESTRICTIONS_CHANGED = null;
    public static String ACTION_APP_ERROR = null;
    public static String ACTION_ASSIST = null;
    public static String ACTION_ATTACH_DATA = null;
    public static String ACTION_AUTO_REVOKE_PERMISSIONS = null;
    public static String ACTION_BATTERY_CHANGED = null;
    public static String ACTION_BATTERY_LOW = null;
    public static String ACTION_BATTERY_OKAY = null;
    public static String ACTION_BOOT_COMPLETED = null;
    public static String ACTION_BUG_REPORT = null;
    public static String ACTION_CALL = null;
    public static String ACTION_CALL_BUTTON = null;
    public static String ACTION_CAMERA_BUTTON = null;
    public static String ACTION_CARRIER_SETUP = null;
    public static String ACTION_CHOOSER = null;
    public static String ACTION_CLOSE_SYSTEM_DIALOGS = null;
    public static String ACTION_CONFIGURATION_CHANGED = null;
    public static String ACTION_CREATE_DOCUMENT = null;
    public static String ACTION_CREATE_REMINDER = null;
    public static String ACTION_CREATE_SHORTCUT = null;
    public static String ACTION_DATE_CHANGED = null;
    public static String ACTION_DEFAULT = null;
    public static String ACTION_DEFINE = null;
    public static String ACTION_DELETE = null;
    public static String ACTION_DEVICE_STORAGE_LOW = null;
    public static String ACTION_DEVICE_STORAGE_OK = null;
    public static String ACTION_DIAL = null;
    public static String ACTION_DOCK_EVENT = null;
    public static String ACTION_DREAMING_STARTED = null;
    public static String ACTION_DREAMING_STOPPED = null;
    public static String ACTION_EDIT = null;
    public static String ACTION_EXTERNAL_APPLICATIONS_AVAILABLE = null;
    public static String ACTION_EXTERNAL_APPLICATIONS_UNAVAILABLE = null;
    public static String ACTION_FACTORY_TEST = null;
    public static String ACTION_GET_CONTENT = null;
    public static String ACTION_GET_RESTRICTION_ENTRIES = null;
    public static String ACTION_GTALK_SERVICE_CONNECTED = null;
    public static String ACTION_GTALK_SERVICE_DISCONNECTED = null;
    public static String ACTION_HEADSET_PLUG = null;
    public static String ACTION_INPUT_METHOD_CHANGED = null;
    public static String ACTION_INSERT = null;
    public static String ACTION_INSERT_OR_EDIT = null;
    public static String ACTION_INSTALL_FAILURE = null;
    public static String ACTION_INSTALL_PACKAGE = null;
    public static String ACTION_LOCALE_CHANGED = null;
    public static String ACTION_LOCKED_BOOT_COMPLETED = null;
    public static String ACTION_MAIN = null;
    public static String ACTION_MANAGED_PROFILE_ADDED = null;
    public static String ACTION_MANAGED_PROFILE_AVAILABLE = null;
    public static String ACTION_MANAGED_PROFILE_REMOVED = null;
    public static String ACTION_MANAGED_PROFILE_UNAVAILABLE = null;
    public static String ACTION_MANAGED_PROFILE_UNLOCKED = null;
    public static String ACTION_MANAGE_NETWORK_USAGE = null;
    public static String ACTION_MANAGE_PACKAGE_STORAGE = null;
    public static String ACTION_MEDIA_BAD_REMOVAL = null;
    public static String ACTION_MEDIA_BUTTON = null;
    public static String ACTION_MEDIA_CHECKING = null;
    public static String ACTION_MEDIA_EJECT = null;
    public static String ACTION_MEDIA_MOUNTED = null;
    public static String ACTION_MEDIA_NOFS = null;
    public static String ACTION_MEDIA_REMOVED = null;
    public static String ACTION_MEDIA_SCANNER_FINISHED = null;
    public static String ACTION_MEDIA_SCANNER_SCAN_FILE = null;
    public static String ACTION_MEDIA_SCANNER_STARTED = null;
    public static String ACTION_MEDIA_SHARED = null;
    public static String ACTION_MEDIA_UNMOUNTABLE = null;
    public static String ACTION_MEDIA_UNMOUNTED = null;
    public static String ACTION_MY_PACKAGE_REPLACED = null;
    public static String ACTION_MY_PACKAGE_SUSPENDED = null;
    public static String ACTION_MY_PACKAGE_UNSUSPENDED = null;
    public static String ACTION_NEW_OUTGOING_CALL = null;
    public static String ACTION_OPEN_DOCUMENT = null;
    public static String ACTION_OPEN_DOCUMENT_TREE = null;
    public static String ACTION_PACKAGES_SUSPENDED = null;
    public static String ACTION_PACKAGES_UNSUSPENDED = null;
    public static String ACTION_PACKAGE_ADDED = null;
    public static String ACTION_PACKAGE_CHANGED = null;
    public static String ACTION_PACKAGE_DATA_CLEARED = null;
    public static String ACTION_PACKAGE_FIRST_LAUNCH = null;
    public static String ACTION_PACKAGE_FULLY_REMOVED = null;
    public static String ACTION_PACKAGE_INSTALL = null;
    public static String ACTION_PACKAGE_NEEDS_VERIFICATION = null;
    public static String ACTION_PACKAGE_REMOVED = null;
    public static String ACTION_PACKAGE_REPLACED = null;
    public static String ACTION_PACKAGE_RESTARTED = null;
    public static String ACTION_PACKAGE_VERIFIED = null;
    public static String ACTION_PASTE = null;
    public static String ACTION_PICK = null;
    public static String ACTION_PICK_ACTIVITY = null;
    public static String ACTION_POWER_CONNECTED = null;
    public static String ACTION_POWER_DISCONNECTED = null;
    public static String ACTION_POWER_USAGE_SUMMARY = null;
    public static String ACTION_PROCESS_TEXT = null;
    public static String ACTION_PROVIDER_CHANGED = null;
    public static String ACTION_QUICK_CLOCK = null;
    public static String ACTION_QUICK_VIEW = null;
    public static String ACTION_REBOOT = null;
    public static String ACTION_RUN = null;
    public static String ACTION_SCREEN_OFF = null;
    public static String ACTION_SCREEN_ON = null;
    public static String ACTION_SEARCH = null;
    public static String ACTION_SEARCH_LONG_PRESS = null;
    public static String ACTION_SEND = null;
    public static String ACTION_SENDTO = null;
    public static String ACTION_SEND_MULTIPLE = null;
    public static String ACTION_SET_WALLPAPER = null;
    public static String ACTION_SHOW_APP_INFO = null;
    public static String ACTION_SHUTDOWN = null;
    public static String ACTION_SYNC = null;
    public static String ACTION_SYSTEM_TUTORIAL = null;
    public static String ACTION_TIMEZONE_CHANGED = null;
    public static String ACTION_TIME_CHANGED = null;
    public static String ACTION_TIME_TICK = null;
    public static String ACTION_TRANSLATE = null;
    public static String ACTION_UID_REMOVED = null;
    public static String ACTION_UMS_CONNECTED = null;
    public static String ACTION_UMS_DISCONNECTED = null;
    public static String ACTION_UNINSTALL_PACKAGE = null;
    public static String ACTION_USER_BACKGROUND = null;
    public static String ACTION_USER_FOREGROUND = null;
    public static String ACTION_USER_INITIALIZE = null;
    public static String ACTION_USER_PRESENT = null;
    public static String ACTION_USER_UNLOCKED = null;
    public static String ACTION_VIEW = null;
    public static String ACTION_VIEW_LOCUS = null;
    public static String ACTION_VIEW_PERMISSION_USAGE = null;
    public static String ACTION_VOICE_COMMAND = null;
    public static String ACTION_WALLPAPER_CHANGED = null;
    public static String ACTION_WEB_SEARCH = null;
    public static String CATEGORY_ACCESSIBILITY_SHORTCUT_TARGET = null;
    public static String CATEGORY_ALTERNATIVE = null;
    public static String CATEGORY_APP_BROWSER = null;
    public static String CATEGORY_APP_CALCULATOR = null;
    public static String CATEGORY_APP_CALENDAR = null;
    public static String CATEGORY_APP_CONTACTS = null;
    public static String CATEGORY_APP_EMAIL = null;
    public static String CATEGORY_APP_FILES = null;
    public static String CATEGORY_APP_GALLERY = null;
    public static String CATEGORY_APP_MAPS = null;
    public static String CATEGORY_APP_MARKET = null;
    public static String CATEGORY_APP_MESSAGING = null;
    public static String CATEGORY_APP_MUSIC = null;
    public static String CATEGORY_BROWSABLE = null;
    public static String CATEGORY_CAR_DOCK = null;
    public static String CATEGORY_CAR_MODE = null;
    public static String CATEGORY_DEFAULT = null;
    public static String CATEGORY_DESK_DOCK = null;
    public static String CATEGORY_DEVELOPMENT_PREFERENCE = null;
    public static String CATEGORY_EMBED = null;
    public static String CATEGORY_FRAMEWORK_INSTRUMENTATION_TEST = null;
    public static String CATEGORY_HE_DESK_DOCK = null;
    public static String CATEGORY_HOME = null;
    public static String CATEGORY_INFO = null;
    public static String CATEGORY_LAUNCHER = null;
    public static String CATEGORY_LEANBACK_LAUNCHER = null;
    public static String CATEGORY_LE_DESK_DOCK = null;
    public static String CATEGORY_MONKEY = null;
    public static String CATEGORY_OPENABLE = null;
    public static String CATEGORY_PREFERENCE = null;
    public static String CATEGORY_SAMPLE_CODE = null;
    public static String CATEGORY_SECONDARY_HOME = null;
    public static String CATEGORY_SELECTED_ALTERNATIVE = null;
    public static String CATEGORY_TAB = null;
    public static String CATEGORY_TEST = null;
    public static String CATEGORY_TYPED_OPENABLE = null;
    public static String CATEGORY_UNIT_TEST = null;
    public static String CATEGORY_VOICE = null;
    public static String CATEGORY_VR_HOME = null;
    public static String EXTRA_ALARM_COUNT = null;
    public static String EXTRA_ALLOW_MULTIPLE = null;
    public static String EXTRA_ALLOW_REPLACE = null;
    public static String EXTRA_ALTERNATE_INTENTS = null;
    public static String EXTRA_ASSIST_CONTEXT = null;
    public static String EXTRA_ASSIST_INPUT_DEVICE_ID = null;
    public static String EXTRA_ASSIST_INPUT_HINT_KEYBOARD = null;
    public static String EXTRA_ASSIST_PACKAGE = null;
    public static String EXTRA_ASSIST_UID = null;
    public static String EXTRA_AUTO_LAUNCH_SINGLE_CHOICE = null;
    public static String EXTRA_BCC = null;
    public static String EXTRA_BUG_REPORT = null;
    public static String EXTRA_CC = null;
    public static String EXTRA_CHANGED_COMPONENT_NAME = null;
    public static String EXTRA_CHANGED_COMPONENT_NAME_LIST = null;
    public static String EXTRA_CHANGED_PACKAGE_LIST = null;
    public static String EXTRA_CHANGED_UID_LIST = null;
    public static String EXTRA_CHOOSER_REFINEMENT_INTENT_SENDER = null;
    public static String EXTRA_CHOOSER_TARGETS = null;
    public static String EXTRA_CHOSEN_COMPONENT = null;
    public static String EXTRA_CHOSEN_COMPONENT_INTENT_SENDER = null;
    public static String EXTRA_COMPONENT_NAME = null;
    public static String EXTRA_CONTENT_ANNOTATIONS = null;
    public static String EXTRA_CONTENT_QUERY = null;
    public static String EXTRA_DATA_REMOVED = null;
    public static String EXTRA_DOCK_STATE = null;
    public static String EXTRA_DONT_KILL_APP = null;
    public static String EXTRA_DURATION_MILLIS = null;
    public static String EXTRA_EMAIL = null;
    public static String EXTRA_EXCLUDE_COMPONENTS = null;
    public static String EXTRA_FROM_STORAGE = null;
    public static String EXTRA_HTML_TEXT = null;
    public static String EXTRA_INDEX = null;
    public static String EXTRA_INITIAL_INTENTS = null;
    public static String EXTRA_INSTALLER_PACKAGE_NAME = null;
    public static String EXTRA_INTENT = null;
    public static String EXTRA_KEY_EVENT = null;
    public static String EXTRA_LOCAL_ONLY = null;
    public static String EXTRA_LOCUS_ID = null;
    public static String EXTRA_MIME_TYPES = null;
    public static String EXTRA_NOT_UNKNOWN_SOURCE = null;
    public static String EXTRA_ORIGINATING_URI = null;
    public static String EXTRA_PACKAGE_NAME = null;
    public static String EXTRA_PHONE_NUMBER = null;
    public static String EXTRA_PROCESS_TEXT = null;
    public static String EXTRA_PROCESS_TEXT_READONLY = null;
    public static String EXTRA_QUICK_VIEW_FEATURES = null;
    public static String EXTRA_QUIET_MODE = null;
    public static String EXTRA_REFERRER = null;
    public static String EXTRA_REFERRER_NAME = null;
    public static String EXTRA_REMOTE_INTENT_TOKEN = null;
    public static String EXTRA_REPLACEMENT_EXTRAS = null;
    public static String EXTRA_REPLACING = null;
    public static String EXTRA_RESTRICTIONS_BUNDLE = null;
    public static String EXTRA_RESTRICTIONS_INTENT = null;
    public static String EXTRA_RESTRICTIONS_LIST = null;
    public static String EXTRA_RESULT_RECEIVER = null;
    public static String EXTRA_RETURN_RESULT = null;
    public static String EXTRA_SHORTCUT_ICON = null;
    public static String EXTRA_SHORTCUT_ICON_RESOURCE = null;
    public static String EXTRA_SHORTCUT_ID = null;
    public static String EXTRA_SHORTCUT_INTENT = null;
    public static String EXTRA_SHORTCUT_NAME = null;
    public static String EXTRA_SHUTDOWN_USERSPACE_ONLY = null;
    public static String EXTRA_SPLIT_NAME = null;
    public static String EXTRA_STREAM = null;
    public static String EXTRA_SUBJECT = null;
    public static String EXTRA_SUSPENDED_PACKAGE_EXTRAS = null;
    public static String EXTRA_TEMPLATE = null;
    public static String EXTRA_TEXT = null;
    public static String EXTRA_TIME = null;
    public static String EXTRA_TIMEZONE = null;
    public static String EXTRA_TITLE = null;
    public static String EXTRA_UID = null;
    public static String EXTRA_USER = null;
    public static String METADATA_DOCK_HOME = null;
    public static String normalizeMimeType(String p0){ return null; }
    public static int EXTRA_DOCK_STATE_CAR = 0;
    public static int EXTRA_DOCK_STATE_DESK = 0;
    public static int EXTRA_DOCK_STATE_HE_DESK = 0;
    public static int EXTRA_DOCK_STATE_LE_DESK = 0;
    public static int EXTRA_DOCK_STATE_UNDOCKED = 0;
    public static int FILL_IN_ACTION = 0;
    public static int FILL_IN_CATEGORIES = 0;
    public static int FILL_IN_CLIP_DATA = 0;
    public static int FILL_IN_COMPONENT = 0;
    public static int FILL_IN_DATA = 0;
    public static int FILL_IN_IDENTIFIER = 0;
    public static int FILL_IN_PACKAGE = 0;
    public static int FILL_IN_SELECTOR = 0;
    public static int FILL_IN_SOURCE_BOUNDS = 0;
    public static int FLAG_ACTIVITY_BROUGHT_TO_FRONT = 0;
    public static int FLAG_ACTIVITY_CLEAR_TASK = 0;
    public static int FLAG_ACTIVITY_CLEAR_TOP = 0;
    public static int FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET = 0;
    public static int FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS = 0;
    public static int FLAG_ACTIVITY_FORWARD_RESULT = 0;
    public static int FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY = 0;
    public static int FLAG_ACTIVITY_LAUNCH_ADJACENT = 0;
    public static int FLAG_ACTIVITY_MATCH_EXTERNAL = 0;
    public static int FLAG_ACTIVITY_MULTIPLE_TASK = 0;
    public static int FLAG_ACTIVITY_NEW_DOCUMENT = 0;
    public static int FLAG_ACTIVITY_NEW_TASK = 0;
    public static int FLAG_ACTIVITY_NO_ANIMATION = 0;
    public static int FLAG_ACTIVITY_NO_HISTORY = 0;
    public static int FLAG_ACTIVITY_NO_USER_ACTION = 0;
    public static int FLAG_ACTIVITY_PREVIOUS_IS_TOP = 0;
    public static int FLAG_ACTIVITY_REORDER_TO_FRONT = 0;
    public static int FLAG_ACTIVITY_REQUIRE_DEFAULT = 0;
    public static int FLAG_ACTIVITY_REQUIRE_NON_BROWSER = 0;
    public static int FLAG_ACTIVITY_RESET_TASK_IF_NEEDED = 0;
    public static int FLAG_ACTIVITY_RETAIN_IN_RECENTS = 0;
    public static int FLAG_ACTIVITY_SINGLE_TOP = 0;
    public static int FLAG_ACTIVITY_TASK_ON_HOME = 0;
    public static int FLAG_DEBUG_LOG_RESOLUTION = 0;
    public static int FLAG_DIRECT_BOOT_AUTO = 0;
    public static int FLAG_EXCLUDE_STOPPED_PACKAGES = 0;
    public static int FLAG_FROM_BACKGROUND = 0;
    public static int FLAG_GRANT_PERSISTABLE_URI_PERMISSION = 0;
    public static int FLAG_GRANT_PREFIX_URI_PERMISSION = 0;
    public static int FLAG_GRANT_READ_URI_PERMISSION = 0;
    public static int FLAG_GRANT_WRITE_URI_PERMISSION = 0;
    public static int FLAG_INCLUDE_STOPPED_PACKAGES = 0;
    public static int FLAG_RECEIVER_FOREGROUND = 0;
    public static int FLAG_RECEIVER_NO_ABORT = 0;
    public static int FLAG_RECEIVER_REGISTERED_ONLY = 0;
    public static int FLAG_RECEIVER_REPLACE_PENDING = 0;
    public static int FLAG_RECEIVER_VISIBLE_TO_INSTANT_APPS = 0;
    public static int URI_ALLOW_UNSAFE = 0;
    public static int URI_ANDROID_APP_SCHEME = 0;
    public static int URI_INTENT_SCHEME = 0;
    public void readFromParcel(Parcel p0){}
    public void removeCategory(String p0){}
    public void removeExtra(String p0){}
    public void removeFlags(int p0){}
    public void setClipData(ClipData p0){}
    public void setExtrasClassLoader(ClassLoader p0){}
    public void setSelector(Intent p0){}
    public void setSourceBounds(Rect p0){}
    public void writeToParcel(Parcel p0, int p1){}
}
