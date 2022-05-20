// Generated automatically from android.content.pm.ProviderInfo for testing purposes

package android.content.pm;

import android.content.pm.ComponentInfo;
import android.content.pm.PathPermission;
import android.os.Parcel;
import android.os.Parcelable;
import android.os.PatternMatcher;
import android.util.Printer;

public class ProviderInfo extends ComponentInfo implements Parcelable
{
    public PathPermission[] pathPermissions = null;
    public PatternMatcher[] uriPermissionPatterns = null;
    public ProviderInfo(){}
    public ProviderInfo(ProviderInfo p0){}
    public String authority = null;
    public String readPermission = null;
    public String toString(){ return null; }
    public String writePermission = null;
    public boolean forceUriPermissions = false;
    public boolean grantUriPermissions = false;
    public boolean isSyncable = false;
    public boolean multiprocess = false;
    public int describeContents(){ return 0; }
    public int flags = 0;
    public int initOrder = 0;
    public static Parcelable.Creator<ProviderInfo> CREATOR = null;
    public static int FLAG_SINGLE_USER = 0;
    public void dump(Printer p0, String p1){}
    public void writeToParcel(Parcel p0, int p1){}
}
