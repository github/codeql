// Generated automatically from android.content.pm.ResolveInfo for testing purposes

package android.content.pm;

import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.content.pm.ServiceInfo;
import android.graphics.drawable.Drawable;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Printer;

public class ResolveInfo implements Parcelable
{
    public ActivityInfo activityInfo = null;
    public CharSequence loadLabel(PackageManager p0){ return null; }
    public CharSequence nonLocalizedLabel = null;
    public Drawable loadIcon(PackageManager p0){ return null; }
    public IntentFilter filter = null;
    public ProviderInfo providerInfo = null;
    public ResolveInfo(){}
    public ResolveInfo(ResolveInfo p0){}
    public ServiceInfo serviceInfo = null;
    public String resolvePackageName = null;
    public String toString(){ return null; }
    public boolean isCrossProfileIntentForwarderActivity(){ return false; }
    public boolean isDefault = false;
    public boolean isInstantAppAvailable = false;
    public final int getIconResource(){ return 0; }
    public int describeContents(){ return 0; }
    public int icon = 0;
    public int labelRes = 0;
    public int match = 0;
    public int preferredOrder = 0;
    public int priority = 0;
    public int specificIndex = 0;
    public static Parcelable.Creator<ResolveInfo> CREATOR = null;
    public void dump(Printer p0, String p1){}
    public void writeToParcel(Parcel p0, int p1){}
}
