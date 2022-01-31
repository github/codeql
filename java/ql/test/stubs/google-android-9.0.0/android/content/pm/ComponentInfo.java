// Generated automatically from android.content.pm.ComponentInfo for testing purposes

package android.content.pm;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageItemInfo;
import android.os.Parcel;
import android.util.Printer;

public class ComponentInfo extends PackageItemInfo
{
    protected ComponentInfo(Parcel p0){}
    protected void dumpBack(Printer p0, String p1){}
    protected void dumpFront(Printer p0, String p1){}
    public ApplicationInfo applicationInfo = null;
    public ComponentInfo(){}
    public ComponentInfo(ComponentInfo p0){}
    public String processName = null;
    public String splitName = null;
    public String[] attributionTags = null;
    public boolean directBootAware = false;
    public boolean enabled = false;
    public boolean exported = false;
    public boolean isEnabled(){ return false; }
    public final int getBannerResource(){ return 0; }
    public final int getIconResource(){ return 0; }
    public final int getLogoResource(){ return 0; }
    public int descriptionRes = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
