// Generated automatically from android.content.pm.PackageManager for testing purposes

package android.content.pm;

import android.content.ComponentName;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.ChangedPackages;
import android.content.pm.FeatureInfo;
import android.content.pm.InstallSourceInfo;
import android.content.pm.InstrumentationInfo;
import android.content.pm.ModuleInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageInstaller;
import android.content.pm.PermissionGroupInfo;
import android.content.pm.PermissionInfo;
import android.content.pm.ProviderInfo;
import android.content.pm.ResolveInfo;
import android.content.pm.ServiceInfo;
import android.content.pm.SharedLibraryInfo;
import android.content.pm.VersionedPackage;
import android.content.res.Resources;
import android.content.res.XmlResourceParser;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.UserHandle;
import android.util.AndroidException;
import java.util.List;
import java.util.Set;

abstract public class PackageManager
{
    public Bundle getSuspendedPackageAppExtras(){ return null; }
    public CharSequence getBackgroundPermissionOptionLabel(){ return null; }
    public InstallSourceInfo getInstallSourceInfo(String p0){ return null; }
    public List<ModuleInfo> getInstalledModules(int p0){ return null; }
    public ModuleInfo getModuleInfo(String p0, int p1){ return null; }
    public PackageInfo getPackageArchiveInfo(String p0, int p1){ return null; }
    public PackageManager(){}
    public Set<String> getMimeGroup(String p0){ return null; }
    public Set<String> getWhitelistedRestrictedPermissions(String p0, int p1){ return null; }
    public abstract ActivityInfo getActivityInfo(ComponentName p0, int p1);
    public abstract ActivityInfo getReceiverInfo(ComponentName p0, int p1);
    public abstract ApplicationInfo getApplicationInfo(String p0, int p1);
    public abstract ChangedPackages getChangedPackages(int p0);
    public abstract CharSequence getApplicationLabel(ApplicationInfo p0);
    public abstract CharSequence getText(String p0, int p1, ApplicationInfo p2);
    public abstract CharSequence getUserBadgedLabel(CharSequence p0, UserHandle p1);
    public abstract Drawable getActivityBanner(ComponentName p0);
    public abstract Drawable getActivityBanner(Intent p0);
    public abstract Drawable getActivityIcon(ComponentName p0);
    public abstract Drawable getActivityIcon(Intent p0);
    public abstract Drawable getActivityLogo(ComponentName p0);
    public abstract Drawable getActivityLogo(Intent p0);
    public abstract Drawable getApplicationBanner(ApplicationInfo p0);
    public abstract Drawable getApplicationBanner(String p0);
    public abstract Drawable getApplicationIcon(ApplicationInfo p0);
    public abstract Drawable getApplicationIcon(String p0);
    public abstract Drawable getApplicationLogo(ApplicationInfo p0);
    public abstract Drawable getApplicationLogo(String p0);
    public abstract Drawable getDefaultActivityIcon();
    public abstract Drawable getDrawable(String p0, int p1, ApplicationInfo p2);
    public abstract Drawable getUserBadgedDrawableForDensity(Drawable p0, UserHandle p1, Rect p2, int p3);
    public abstract Drawable getUserBadgedIcon(Drawable p0, UserHandle p1);
    public abstract FeatureInfo[] getSystemAvailableFeatures();
    public abstract InstrumentationInfo getInstrumentationInfo(ComponentName p0, int p1);
    public abstract Intent getLaunchIntentForPackage(String p0);
    public abstract Intent getLeanbackLaunchIntentForPackage(String p0);
    public abstract List<ApplicationInfo> getInstalledApplications(int p0);
    public abstract List<InstrumentationInfo> queryInstrumentation(String p0, int p1);
    public abstract List<PackageInfo> getInstalledPackages(int p0);
    public abstract List<PackageInfo> getPackagesHoldingPermissions(String[] p0, int p1);
    public abstract List<PackageInfo> getPreferredPackages(int p0);
    public abstract List<PermissionGroupInfo> getAllPermissionGroups(int p0);
    public abstract List<PermissionInfo> queryPermissionsByGroup(String p0, int p1);
    public abstract List<ProviderInfo> queryContentProviders(String p0, int p1, int p2);
    public abstract List<ResolveInfo> queryBroadcastReceivers(Intent p0, int p1);
    public abstract List<ResolveInfo> queryIntentActivities(Intent p0, int p1);
    public abstract List<ResolveInfo> queryIntentActivityOptions(ComponentName p0, Intent[] p1, Intent p2, int p3);
    public abstract List<ResolveInfo> queryIntentContentProviders(Intent p0, int p1);
    public abstract List<ResolveInfo> queryIntentServices(Intent p0, int p1);
    public abstract List<SharedLibraryInfo> getSharedLibraries(int p0);
    public abstract PackageInfo getPackageInfo(String p0, int p1);
    public abstract PackageInfo getPackageInfo(VersionedPackage p0, int p1);
    public abstract PackageInstaller getPackageInstaller();
    public abstract PermissionGroupInfo getPermissionGroupInfo(String p0, int p1);
    public abstract PermissionInfo getPermissionInfo(String p0, int p1);
    public abstract ProviderInfo getProviderInfo(ComponentName p0, int p1);
    public abstract ProviderInfo resolveContentProvider(String p0, int p1);
    public abstract ResolveInfo resolveActivity(Intent p0, int p1);
    public abstract ResolveInfo resolveService(Intent p0, int p1);
    public abstract Resources getResourcesForActivity(ComponentName p0);
    public abstract Resources getResourcesForApplication(ApplicationInfo p0);
    public abstract Resources getResourcesForApplication(String p0);
    public abstract ServiceInfo getServiceInfo(ComponentName p0, int p1);
    public abstract String getInstallerPackageName(String p0);
    public abstract String getNameForUid(int p0);
    public abstract String[] canonicalToCurrentPackageNames(String[] p0);
    public abstract String[] currentToCanonicalPackageNames(String[] p0);
    public abstract String[] getPackagesForUid(int p0);
    public abstract String[] getSystemSharedLibraryNames();
    public abstract XmlResourceParser getXml(String p0, int p1, ApplicationInfo p2);
    public abstract boolean addPermission(PermissionInfo p0);
    public abstract boolean addPermissionAsync(PermissionInfo p0);
    public abstract boolean canRequestPackageInstalls();
    public abstract boolean hasSystemFeature(String p0);
    public abstract boolean hasSystemFeature(String p0, int p1);
    public abstract boolean isInstantApp();
    public abstract boolean isInstantApp(String p0);
    public abstract boolean isPermissionRevokedByPolicy(String p0, String p1);
    public abstract boolean isSafeMode();
    public abstract byte[] getInstantAppCookie();
    public abstract int checkPermission(String p0, String p1);
    public abstract int checkSignatures(String p0, String p1);
    public abstract int checkSignatures(int p0, int p1);
    public abstract int getApplicationEnabledSetting(String p0);
    public abstract int getComponentEnabledSetting(ComponentName p0);
    public abstract int getInstantAppCookieMaxBytes();
    public abstract int getPackageUid(String p0, int p1);
    public abstract int getPreferredActivities(List<IntentFilter> p0, List<ComponentName> p1, String p2);
    public abstract int[] getPackageGids(String p0);
    public abstract int[] getPackageGids(String p0, int p1);
    public abstract void addPackageToPreferred(String p0);
    public abstract void addPreferredActivity(IntentFilter p0, int p1, ComponentName[] p2, ComponentName p3);
    public abstract void clearInstantAppCookie();
    public abstract void clearPackagePreferredActivities(String p0);
    public abstract void extendVerificationTimeout(int p0, int p1, long p2);
    public abstract void removePackageFromPreferred(String p0);
    public abstract void removePermission(String p0);
    public abstract void setApplicationCategoryHint(String p0, int p1);
    public abstract void setApplicationEnabledSetting(String p0, int p1, int p2);
    public abstract void setComponentEnabledSetting(ComponentName p0, int p1, int p2);
    public abstract void setInstallerPackageName(String p0, String p1);
    public abstract void updateInstantAppCookie(byte[] p0);
    public abstract void verifyPendingInstall(int p0, int p1);
    public boolean addWhitelistedRestrictedPermission(String p0, String p1, int p2){ return false; }
    public boolean getSyntheticAppDetailsActivityEnabled(String p0){ return false; }
    public boolean hasSigningCertificate(String p0, byte[] p1, int p2){ return false; }
    public boolean hasSigningCertificate(int p0, byte[] p1, int p2){ return false; }
    public boolean isAutoRevokeWhitelisted(){ return false; }
    public boolean isAutoRevokeWhitelisted(String p0){ return false; }
    public boolean isDefaultApplicationIcon(Drawable p0){ return false; }
    public boolean isDeviceUpgrading(){ return false; }
    public boolean isPackageSuspended(){ return false; }
    public boolean isPackageSuspended(String p0){ return false; }
    public boolean removeWhitelistedRestrictedPermission(String p0, String p1, int p2){ return false; }
    public boolean setAutoRevokeWhitelisted(String p0, boolean p1){ return false; }
    public static String EXTRA_VERIFICATION_ID = null;
    public static String EXTRA_VERIFICATION_RESULT = null;
    public static String FEATURE_ACTIVITIES_ON_SECONDARY_DISPLAYS = null;
    public static String FEATURE_APP_WIDGETS = null;
    public static String FEATURE_AUDIO_LOW_LATENCY = null;
    public static String FEATURE_AUDIO_OUTPUT = null;
    public static String FEATURE_AUDIO_PRO = null;
    public static String FEATURE_AUTOFILL = null;
    public static String FEATURE_AUTOMOTIVE = null;
    public static String FEATURE_BACKUP = null;
    public static String FEATURE_BLUETOOTH = null;
    public static String FEATURE_BLUETOOTH_LE = null;
    public static String FEATURE_CAMERA = null;
    public static String FEATURE_CAMERA_ANY = null;
    public static String FEATURE_CAMERA_AR = null;
    public static String FEATURE_CAMERA_AUTOFOCUS = null;
    public static String FEATURE_CAMERA_CAPABILITY_MANUAL_POST_PROCESSING = null;
    public static String FEATURE_CAMERA_CAPABILITY_MANUAL_SENSOR = null;
    public static String FEATURE_CAMERA_CAPABILITY_RAW = null;
    public static String FEATURE_CAMERA_CONCURRENT = null;
    public static String FEATURE_CAMERA_EXTERNAL = null;
    public static String FEATURE_CAMERA_FLASH = null;
    public static String FEATURE_CAMERA_FRONT = null;
    public static String FEATURE_CAMERA_LEVEL_FULL = null;
    public static String FEATURE_CANT_SAVE_STATE = null;
    public static String FEATURE_COMPANION_DEVICE_SETUP = null;
    public static String FEATURE_CONNECTION_SERVICE = null;
    public static String FEATURE_CONSUMER_IR = null;
    public static String FEATURE_CONTROLS = null;
    public static String FEATURE_DEVICE_ADMIN = null;
    public static String FEATURE_EMBEDDED = null;
    public static String FEATURE_ETHERNET = null;
    public static String FEATURE_FACE = null;
    public static String FEATURE_FAKETOUCH = null;
    public static String FEATURE_FAKETOUCH_MULTITOUCH_DISTINCT = null;
    public static String FEATURE_FAKETOUCH_MULTITOUCH_JAZZHAND = null;
    public static String FEATURE_FINGERPRINT = null;
    public static String FEATURE_FREEFORM_WINDOW_MANAGEMENT = null;
    public static String FEATURE_GAMEPAD = null;
    public static String FEATURE_HIFI_SENSORS = null;
    public static String FEATURE_HOME_SCREEN = null;
    public static String FEATURE_INPUT_METHODS = null;
    public static String FEATURE_IPSEC_TUNNELS = null;
    public static String FEATURE_IRIS = null;
    public static String FEATURE_LEANBACK = null;
    public static String FEATURE_LEANBACK_ONLY = null;
    public static String FEATURE_LIVE_TV = null;
    public static String FEATURE_LIVE_WALLPAPER = null;
    public static String FEATURE_LOCATION = null;
    public static String FEATURE_LOCATION_GPS = null;
    public static String FEATURE_LOCATION_NETWORK = null;
    public static String FEATURE_MANAGED_USERS = null;
    public static String FEATURE_MICROPHONE = null;
    public static String FEATURE_MIDI = null;
    public static String FEATURE_NFC = null;
    public static String FEATURE_NFC_BEAM = null;
    public static String FEATURE_NFC_HOST_CARD_EMULATION = null;
    public static String FEATURE_NFC_HOST_CARD_EMULATION_NFCF = null;
    public static String FEATURE_NFC_OFF_HOST_CARD_EMULATION_ESE = null;
    public static String FEATURE_NFC_OFF_HOST_CARD_EMULATION_UICC = null;
    public static String FEATURE_OPENGLES_EXTENSION_PACK = null;
    public static String FEATURE_PC = null;
    public static String FEATURE_PICTURE_IN_PICTURE = null;
    public static String FEATURE_PRINTING = null;
    public static String FEATURE_RAM_LOW = null;
    public static String FEATURE_RAM_NORMAL = null;
    public static String FEATURE_SCREEN_LANDSCAPE = null;
    public static String FEATURE_SCREEN_PORTRAIT = null;
    public static String FEATURE_SECURELY_REMOVES_USERS = null;
    public static String FEATURE_SECURE_LOCK_SCREEN = null;
    public static String FEATURE_SENSOR_ACCELEROMETER = null;
    public static String FEATURE_SENSOR_AMBIENT_TEMPERATURE = null;
    public static String FEATURE_SENSOR_BAROMETER = null;
    public static String FEATURE_SENSOR_COMPASS = null;
    public static String FEATURE_SENSOR_GYROSCOPE = null;
    public static String FEATURE_SENSOR_HEART_RATE = null;
    public static String FEATURE_SENSOR_HEART_RATE_ECG = null;
    public static String FEATURE_SENSOR_HINGE_ANGLE = null;
    public static String FEATURE_SENSOR_LIGHT = null;
    public static String FEATURE_SENSOR_PROXIMITY = null;
    public static String FEATURE_SENSOR_RELATIVE_HUMIDITY = null;
    public static String FEATURE_SENSOR_STEP_COUNTER = null;
    public static String FEATURE_SENSOR_STEP_DETECTOR = null;
    public static String FEATURE_SE_OMAPI_ESE = null;
    public static String FEATURE_SE_OMAPI_SD = null;
    public static String FEATURE_SE_OMAPI_UICC = null;
    public static String FEATURE_SIP = null;
    public static String FEATURE_SIP_VOIP = null;
    public static String FEATURE_STRONGBOX_KEYSTORE = null;
    public static String FEATURE_TELEPHONY = null;
    public static String FEATURE_TELEPHONY_CDMA = null;
    public static String FEATURE_TELEPHONY_EUICC = null;
    public static String FEATURE_TELEPHONY_GSM = null;
    public static String FEATURE_TELEPHONY_IMS = null;
    public static String FEATURE_TELEPHONY_MBMS = null;
    public static String FEATURE_TELEVISION = null;
    public static String FEATURE_TOUCHSCREEN = null;
    public static String FEATURE_TOUCHSCREEN_MULTITOUCH = null;
    public static String FEATURE_TOUCHSCREEN_MULTITOUCH_DISTINCT = null;
    public static String FEATURE_TOUCHSCREEN_MULTITOUCH_JAZZHAND = null;
    public static String FEATURE_USB_ACCESSORY = null;
    public static String FEATURE_USB_HOST = null;
    public static String FEATURE_VERIFIED_BOOT = null;
    public static String FEATURE_VR_HEADTRACKING = null;
    public static String FEATURE_VR_MODE = null;
    public static String FEATURE_VR_MODE_HIGH_PERFORMANCE = null;
    public static String FEATURE_VULKAN_DEQP_LEVEL = null;
    public static String FEATURE_VULKAN_HARDWARE_COMPUTE = null;
    public static String FEATURE_VULKAN_HARDWARE_LEVEL = null;
    public static String FEATURE_VULKAN_HARDWARE_VERSION = null;
    public static String FEATURE_WATCH = null;
    public static String FEATURE_WEBVIEW = null;
    public static String FEATURE_WIFI = null;
    public static String FEATURE_WIFI_AWARE = null;
    public static String FEATURE_WIFI_DIRECT = null;
    public static String FEATURE_WIFI_PASSPOINT = null;
    public static String FEATURE_WIFI_RTT = null;
    public static int CERT_INPUT_RAW_X509 = 0;
    public static int CERT_INPUT_SHA256 = 0;
    public static int COMPONENT_ENABLED_STATE_DEFAULT = 0;
    public static int COMPONENT_ENABLED_STATE_DISABLED = 0;
    public static int COMPONENT_ENABLED_STATE_DISABLED_UNTIL_USED = 0;
    public static int COMPONENT_ENABLED_STATE_DISABLED_USER = 0;
    public static int COMPONENT_ENABLED_STATE_ENABLED = 0;
    public static int DONT_KILL_APP = 0;
    public static int FLAG_PERMISSION_WHITELIST_INSTALLER = 0;
    public static int FLAG_PERMISSION_WHITELIST_SYSTEM = 0;
    public static int FLAG_PERMISSION_WHITELIST_UPGRADE = 0;
    public static int GET_ACTIVITIES = 0;
    public static int GET_CONFIGURATIONS = 0;
    public static int GET_DISABLED_COMPONENTS = 0;
    public static int GET_DISABLED_UNTIL_USED_COMPONENTS = 0;
    public static int GET_GIDS = 0;
    public static int GET_INSTRUMENTATION = 0;
    public static int GET_INTENT_FILTERS = 0;
    public static int GET_META_DATA = 0;
    public static int GET_PERMISSIONS = 0;
    public static int GET_PROVIDERS = 0;
    public static int GET_RECEIVERS = 0;
    public static int GET_RESOLVED_FILTER = 0;
    public static int GET_SERVICES = 0;
    public static int GET_SHARED_LIBRARY_FILES = 0;
    public static int GET_SIGNATURES = 0;
    public static int GET_SIGNING_CERTIFICATES = 0;
    public static int GET_UNINSTALLED_PACKAGES = 0;
    public static int GET_URI_PERMISSION_PATTERNS = 0;
    public static int INSTALL_REASON_DEVICE_RESTORE = 0;
    public static int INSTALL_REASON_DEVICE_SETUP = 0;
    public static int INSTALL_REASON_POLICY = 0;
    public static int INSTALL_REASON_UNKNOWN = 0;
    public static int INSTALL_REASON_USER = 0;
    public static int MATCH_ALL = 0;
    public static int MATCH_APEX = 0;
    public static int MATCH_DEFAULT_ONLY = 0;
    public static int MATCH_DIRECT_BOOT_AUTO = 0;
    public static int MATCH_DIRECT_BOOT_AWARE = 0;
    public static int MATCH_DIRECT_BOOT_UNAWARE = 0;
    public static int MATCH_DISABLED_COMPONENTS = 0;
    public static int MATCH_DISABLED_UNTIL_USED_COMPONENTS = 0;
    public static int MATCH_SYSTEM_ONLY = 0;
    public static int MATCH_UNINSTALLED_PACKAGES = 0;
    public static int PERMISSION_DENIED = 0;
    public static int PERMISSION_GRANTED = 0;
    public static int SIGNATURE_FIRST_NOT_SIGNED = 0;
    public static int SIGNATURE_MATCH = 0;
    public static int SIGNATURE_NEITHER_SIGNED = 0;
    public static int SIGNATURE_NO_MATCH = 0;
    public static int SIGNATURE_SECOND_NOT_SIGNED = 0;
    public static int SIGNATURE_UNKNOWN_PACKAGE = 0;
    public static int SYNCHRONOUS = 0;
    public static int VERIFICATION_ALLOW = 0;
    public static int VERIFICATION_REJECT = 0;
    public static int VERSION_CODE_HIGHEST = 0;
    public static long MAXIMUM_VERIFICATION_TIMEOUT = 0;
    public void setMimeGroup(String p0, Set<String> p1){}
    static public class NameNotFoundException extends AndroidException
    {
        public NameNotFoundException(){}
        public NameNotFoundException(String p0){}
    }
}
