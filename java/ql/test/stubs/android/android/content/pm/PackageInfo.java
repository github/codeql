// Generated automatically from android.content.pm.PackageInfo for testing purposes

package android.content.pm;

import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.ConfigurationInfo;
import android.content.pm.FeatureGroupInfo;
import android.content.pm.FeatureInfo;
import android.content.pm.InstrumentationInfo;
import android.content.pm.PermissionInfo;
import android.content.pm.ProviderInfo;
import android.content.pm.ServiceInfo;
import android.content.pm.Signature;
import android.content.pm.SigningInfo;
import android.os.Parcel;
import android.os.Parcelable;

public class PackageInfo implements Parcelable
{
    public ActivityInfo[] activities = null;
    public ActivityInfo[] receivers = null;
    public ApplicationInfo applicationInfo = null;
    public ConfigurationInfo[] configPreferences = null;
    public FeatureGroupInfo[] featureGroups = null;
    public FeatureInfo[] reqFeatures = null;
    public InstrumentationInfo[] instrumentation = null;
    public PackageInfo(){}
    public PermissionInfo[] permissions = null;
    public ProviderInfo[] providers = null;
    public ServiceInfo[] services = null;
    public Signature[] signatures = null;
    public SigningInfo signingInfo = null;
    public String packageName = null;
    public String sharedUserId = null;
    public String toString(){ return null; }
    public String versionName = null;
    public String[] requestedPermissions = null;
    public String[] splitNames = null;
    public boolean isApex = false;
    public int baseRevisionCode = 0;
    public int describeContents(){ return 0; }
    public int installLocation = 0;
    public int sharedUserLabel = 0;
    public int versionCode = 0;
    public int[] gids = null;
    public int[] requestedPermissionsFlags = null;
    public int[] splitRevisionCodes = null;
    public long firstInstallTime = 0;
    public long getLongVersionCode(){ return 0; }
    public long lastUpdateTime = 0;
    public static Parcelable.Creator<PackageInfo> CREATOR = null;
    public static int INSTALL_LOCATION_AUTO = 0;
    public static int INSTALL_LOCATION_INTERNAL_ONLY = 0;
    public static int INSTALL_LOCATION_PREFER_EXTERNAL = 0;
    public static int REQUESTED_PERMISSION_GRANTED = 0;
    public void setLongVersionCode(long p0){}
    public void writeToParcel(Parcel p0, int p1){}
}
