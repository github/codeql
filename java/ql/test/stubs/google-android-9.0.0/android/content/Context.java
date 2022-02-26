// Generated automatically from android.content.Context for testing purposes

package android.content;

import android.content.AttributionSource;
import android.content.BroadcastReceiver;
import android.content.ComponentCallbacks;
import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.ContextParams;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.IntentSender;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.content.res.ColorStateList;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.UserHandle;
import android.util.AttributeSet;
import android.view.Display;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.List;
import java.util.concurrent.Executor;

abstract public class Context
{
    public AttributionSource getAttributionSource(){ return null; }
    public Context createAttributionContext(String p0){ return null; }
    public Context createContext(ContextParams p0){ return null; }
    public Context createWindowContext(Display p0, int p1, Bundle p2){ return null; }
    public Context createWindowContext(int p0, Bundle p1){ return null; }
    public Context(){}
    public ContextParams getParams(){ return null; }
    public Display getDisplay(){ return null; }
    public Executor getMainExecutor(){ return null; }
    public String getAttributionTag(){ return null; }
    public String getOpPackageName(){ return null; }
    public abstract ApplicationInfo getApplicationInfo();
    public abstract AssetManager getAssets();
    public abstract ClassLoader getClassLoader();
    public abstract ComponentName startForegroundService(Intent p0);
    public abstract ComponentName startService(Intent p0);
    public abstract ComponentName startServiceAsUser(Intent p0, UserHandle p1);
    public abstract ContentResolver getContentResolver();
    public abstract Context createConfigurationContext(Configuration p0);
    public abstract Context createContextForSplit(String p0);
    public abstract Context createDeviceProtectedStorageContext();
    public abstract Context createDisplayContext(Display p0);
    public abstract Context createPackageContext(String p0, int p1);
    public abstract Context getApplicationContext();
    public abstract Drawable getWallpaper();
    public abstract Drawable peekWallpaper();
    public abstract File getCacheDir();
    public abstract File getCodeCacheDir();
    public abstract File getDataDir();
    public abstract File getDatabasePath(String p0);
    public abstract File getDir(String p0, int p1);
    public abstract File getExternalCacheDir();
    public abstract File getExternalFilesDir(String p0);
    public abstract File getFileStreamPath(String p0);
    public abstract File getFilesDir();
    public abstract File getNoBackupFilesDir();
    public abstract File getObbDir();
    public abstract FileInputStream openFileInput(String p0);
    public abstract FileOutputStream openFileOutput(String p0, int p1);
    public abstract File[] getExternalCacheDirs();
    public abstract File[] getExternalFilesDirs(String p0);
    public abstract File[] getExternalMediaDirs();
    public abstract File[] getObbDirs();
    public abstract Intent registerReceiver(BroadcastReceiver p0, IntentFilter p1);
    public abstract Intent registerReceiver(BroadcastReceiver p0, IntentFilter p1, String p2, Handler p3);
    public abstract Intent registerReceiver(BroadcastReceiver p0, IntentFilter p1, String p2, Handler p3, int p4);
    public abstract Intent registerReceiver(BroadcastReceiver p0, IntentFilter p1, int p2);
    public abstract Looper getMainLooper();
    public abstract Object getSystemService(String p0);
    public abstract PackageManager getPackageManager();
    public abstract Resources getResources();
    public abstract Resources.Theme getTheme();
    public abstract SQLiteDatabase openOrCreateDatabase(String p0, int p1, SQLiteDatabase.CursorFactory p2);
    public abstract SQLiteDatabase openOrCreateDatabase(String p0, int p1, SQLiteDatabase.CursorFactory p2, DatabaseErrorHandler p3);
    public abstract SharedPreferences getSharedPreferences(String p0, int p1);
    public abstract String getPackageCodePath();
    public abstract String getPackageName();
    public abstract String getPackageResourcePath();
    public abstract String getSystemServiceName(Class<? extends Object> p0);
    public abstract String[] databaseList();
    public abstract String[] fileList();
    public abstract boolean bindService(Intent p0, ServiceConnection p1, int p2);
    public abstract boolean bindServiceAsUser(Intent p0, ServiceConnection p1, int p2, UserHandle p3);
    public abstract boolean deleteDatabase(String p0);
    public abstract boolean deleteFile(String p0);
    public abstract boolean deleteSharedPreferences(String p0);
    public abstract boolean isDeviceProtectedStorage();
    public abstract boolean moveDatabaseFrom(Context p0, String p1);
    public abstract boolean moveSharedPreferencesFrom(Context p0, String p1);
    public abstract boolean startInstrumentation(ComponentName p0, String p1, Bundle p2);
    public abstract boolean stopService(Intent p0);
    public abstract int checkCallingOrSelfPermission(String p0);
    public abstract int checkCallingOrSelfUriPermission(Uri p0, int p1);
    public abstract int checkCallingPermission(String p0);
    public abstract int checkCallingUriPermission(Uri p0, int p1);
    public abstract int checkPermission(String p0, int p1, int p2);
    public abstract int checkSelfPermission(String p0);
    public abstract int checkUriPermission(Uri p0, String p1, String p2, int p3, int p4, int p5);
    public abstract int checkUriPermission(Uri p0, int p1, int p2, int p3);
    public abstract int getWallpaperDesiredMinimumHeight();
    public abstract int getWallpaperDesiredMinimumWidth();
    public abstract void clearWallpaper();
    public abstract void enforceCallingOrSelfPermission(String p0, String p1);
    public abstract void enforceCallingOrSelfUriPermission(Uri p0, int p1, String p2);
    public abstract void enforceCallingPermission(String p0, String p1);
    public abstract void enforceCallingUriPermission(Uri p0, int p1, String p2);
    public abstract void enforcePermission(String p0, int p1, int p2, String p3);
    public abstract void enforceUriPermission(Uri p0, String p1, String p2, int p3, int p4, int p5, String p6);
    public abstract void enforceUriPermission(Uri p0, int p1, int p2, int p3, String p4);
    public abstract void grantUriPermission(String p0, Uri p1, int p2);
    public abstract void removeStickyBroadcast(Intent p0);
    public abstract void removeStickyBroadcastAsUser(Intent p0, UserHandle p1);
    public abstract void revokeUriPermission(String p0, Uri p1, int p2);
    public abstract void revokeUriPermission(Uri p0, int p1);
    public abstract void sendBroadcast(Intent p0);
    public abstract void sendBroadcast(Intent p0, String p1);
    public abstract void sendBroadcastAsUser(Intent p0, UserHandle p1);
    public abstract void sendBroadcastAsUser(Intent p0, UserHandle p1, String p2);
    public abstract void sendOrderedBroadcast(Intent p0, String p1);
    public abstract void sendOrderedBroadcast(Intent p0, String p1, BroadcastReceiver p2, Handler p3, int p4, String p5, Bundle p6);
    public abstract void sendOrderedBroadcastAsUser(Intent p0, UserHandle p1, String p2, BroadcastReceiver p3, Handler p4, int p5, String p6, Bundle p7);
    public abstract void sendStickyBroadcast(Intent p0);
    public abstract void sendStickyBroadcastAsUser(Intent p0, UserHandle p1);
    public abstract void sendStickyOrderedBroadcast(Intent p0, BroadcastReceiver p1, Handler p2, int p3, String p4, Bundle p5);
    public abstract void sendStickyOrderedBroadcastAsUser(Intent p0, UserHandle p1, BroadcastReceiver p2, Handler p3, int p4, String p5, Bundle p6);
    public abstract void setTheme(int p0);
    public abstract void setWallpaper(Bitmap p0);
    public abstract void setWallpaper(InputStream p0);
    public abstract void startActivities(Intent[] p0);
    public abstract void startActivities(Intent[] p0, Bundle p1);
    public abstract void startActivity(Intent p0);
    public abstract void startActivity(Intent p0, Bundle p1);
    public abstract void startActivityAsUser(Intent intent, UserHandle user);
    public abstract void startIntentSender(IntentSender p0, Intent p1, int p2, int p3, int p4);
    public abstract void startIntentSender(IntentSender p0, Intent p1, int p2, int p3, int p4, Bundle p5);
    public abstract void unbindService(ServiceConnection p0);
    public abstract void unregisterReceiver(BroadcastReceiver p0);
    public boolean bindIsolatedService(Intent p0, int p1, String p2, Executor p3, ServiceConnection p4){ return false; }
    public boolean bindService(Intent p0, int p1, Executor p2, ServiceConnection p3){ return false; }
    public boolean isRestricted(){ return false; }
    public boolean isUiContext(){ return false; }
    public final <T> T getSystemService(Class<T> p0){ return null; }
    public final CharSequence getText(int p0){ return null; }
    public final ColorStateList getColorStateList(int p0){ return null; }
    public final Drawable getDrawable(int p0){ return null; }
    public final String getString(int p0){ return null; }
    public final String getString(int p0, Object... p1){ return null; }
    public final TypedArray obtainStyledAttributes(AttributeSet p0, int[] p1){ return null; }
    public final TypedArray obtainStyledAttributes(AttributeSet p0, int[] p1, int p2, int p3){ return null; }
    public final TypedArray obtainStyledAttributes(int p0, int[] p1){ return null; }
    public final TypedArray obtainStyledAttributes(int[] p0){ return null; }
    public final int getColor(int p0){ return 0; }
    public int[] checkCallingOrSelfUriPermissions(List<Uri> p0, int p1){ return null; }
    public int[] checkCallingUriPermissions(List<Uri> p0, int p1){ return null; }
    public int[] checkUriPermissions(List<Uri> p0, int p1, int p2, int p3){ return null; }
    public static String ACCESSIBILITY_SERVICE = null;
    public static String ACCOUNT_SERVICE = null;
    public static String ACTIVITY_SERVICE = null;
    public static String ALARM_SERVICE = null;
    public static String APPWIDGET_SERVICE = null;
    public static String APP_OPS_SERVICE = null;
    public static String APP_SEARCH_SERVICE = null;
    public static String AUDIO_SERVICE = null;
    public static String BATTERY_SERVICE = null;
    public static String BIOMETRIC_SERVICE = null;
    public static String BLOB_STORE_SERVICE = null;
    public static String BLUETOOTH_SERVICE = null;
    public static String BUGREPORT_SERVICE = null;
    public static String CAMERA_SERVICE = null;
    public static String CAPTIONING_SERVICE = null;
    public static String CARRIER_CONFIG_SERVICE = null;
    public static String CLIPBOARD_SERVICE = null;
    public static String COMPANION_DEVICE_SERVICE = null;
    public static String CONNECTIVITY_DIAGNOSTICS_SERVICE = null;
    public static String CONNECTIVITY_SERVICE = null;
    public static String CONSUMER_IR_SERVICE = null;
    public static String CROSS_PROFILE_APPS_SERVICE = null;
    public static String DEVICE_POLICY_SERVICE = null;
    public static String DISPLAY_HASH_SERVICE = null;
    public static String DISPLAY_SERVICE = null;
    public static String DOMAIN_VERIFICATION_SERVICE = null;
    public static String DOWNLOAD_SERVICE = null;
    public static String DROPBOX_SERVICE = null;
    public static String EUICC_SERVICE = null;
    public static String FILE_INTEGRITY_SERVICE = null;
    public static String FINGERPRINT_SERVICE = null;
    public static String GAME_SERVICE = null;
    public static String HARDWARE_PROPERTIES_SERVICE = null;
    public static String INPUT_METHOD_SERVICE = null;
    public static String INPUT_SERVICE = null;
    public static String IPSEC_SERVICE = null;
    public static String JOB_SCHEDULER_SERVICE = null;
    public static String KEYGUARD_SERVICE = null;
    public static String LAUNCHER_APPS_SERVICE = null;
    public static String LAYOUT_INFLATER_SERVICE = null;
    public static String LOCATION_SERVICE = null;
    public static String MEDIA_COMMUNICATION_SERVICE = null;
    public static String MEDIA_METRICS_SERVICE = null;
    public static String MEDIA_PROJECTION_SERVICE = null;
    public static String MEDIA_ROUTER_SERVICE = null;
    public static String MEDIA_SESSION_SERVICE = null;
    public static String MIDI_SERVICE = null;
    public static String NETWORK_STATS_SERVICE = null;
    public static String NFC_SERVICE = null;
    public static String NOTIFICATION_SERVICE = null;
    public static String NSD_SERVICE = null;
    public static String PEOPLE_SERVICE = null;
    public static String PERFORMANCE_HINT_SERVICE = null;
    public static String POWER_SERVICE = null;
    public static String PRINT_SERVICE = null;
    public static String RESTRICTIONS_SERVICE = null;
    public static String ROLE_SERVICE = null;
    public static String SEARCH_SERVICE = null;
    public static String SENSOR_SERVICE = null;
    public static String SHORTCUT_SERVICE = null;
    public static String STORAGE_SERVICE = null;
    public static String STORAGE_STATS_SERVICE = null;
    public static String SYSTEM_HEALTH_SERVICE = null;
    public static String TELECOM_SERVICE = null;
    public static String TELEPHONY_IMS_SERVICE = null;
    public static String TELEPHONY_SERVICE = null;
    public static String TELEPHONY_SUBSCRIPTION_SERVICE = null;
    public static String TEXT_CLASSIFICATION_SERVICE = null;
    public static String TEXT_SERVICES_MANAGER_SERVICE = null;
    public static String TV_INPUT_SERVICE = null;
    public static String UI_MODE_SERVICE = null;
    public static String USAGE_STATS_SERVICE = null;
    public static String USB_SERVICE = null;
    public static String USER_SERVICE = null;
    public static String VIBRATOR_MANAGER_SERVICE = null;
    public static String VIBRATOR_SERVICE = null;
    public static String VPN_MANAGEMENT_SERVICE = null;
    public static String WALLPAPER_SERVICE = null;
    public static String WIFI_AWARE_SERVICE = null;
    public static String WIFI_P2P_SERVICE = null;
    public static String WIFI_RTT_RANGING_SERVICE = null;
    public static String WIFI_SERVICE = null;
    public static String WINDOW_SERVICE = null;
    public static int BIND_ABOVE_CLIENT = 0;
    public static int BIND_ADJUST_WITH_ACTIVITY = 0;
    public static int BIND_ALLOW_OOM_MANAGEMENT = 0;
    public static int BIND_AUTO_CREATE = 0;
    public static int BIND_DEBUG_UNBIND = 0;
    public static int BIND_EXTERNAL_SERVICE = 0;
    public static int BIND_IMPORTANT = 0;
    public static int BIND_INCLUDE_CAPABILITIES = 0;
    public static int BIND_NOT_FOREGROUND = 0;
    public static int BIND_NOT_PERCEPTIBLE = 0;
    public static int BIND_WAIVE_PRIORITY = 0;
    public static int CONTEXT_IGNORE_SECURITY = 0;
    public static int CONTEXT_INCLUDE_CODE = 0;
    public static int CONTEXT_RESTRICTED = 0;
    public static int MODE_APPEND = 0;
    public static int MODE_ENABLE_WRITE_AHEAD_LOGGING = 0;
    public static int MODE_MULTI_PROCESS = 0;
    public static int MODE_NO_LOCALIZED_COLLATORS = 0;
    public static int MODE_PRIVATE = 0;
    public static int MODE_WORLD_READABLE = 0;
    public static int MODE_WORLD_WRITEABLE = 0;
    public static int RECEIVER_VISIBLE_TO_INSTANT_APPS = 0;
    public void registerComponentCallbacks(ComponentCallbacks p0){}
    public void sendBroadcastWithMultiplePermissions(Intent p0, String[] p1){}
    public void sendOrderedBroadcast(Intent p0, String p1, String p2, BroadcastReceiver p3, Handler p4, int p5, String p6, Bundle p7){}
    public void sendStickyBroadcast(Intent p0, Bundle p1){}
    public void unregisterComponentCallbacks(ComponentCallbacks p0){}
    public void updateServiceGroup(ServiceConnection p0, int p1, int p2){}
}
