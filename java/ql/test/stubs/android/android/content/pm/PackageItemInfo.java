// Generated automatically from android.content.pm.PackageItemInfo for testing purposes

package android.content.pm;

import android.content.pm.PackageManager;
import android.content.res.XmlResourceParser;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Parcel;
import android.util.Printer;

public class PackageItemInfo
{
    protected PackageItemInfo(Parcel p0){}
    protected void dumpBack(Printer p0, String p1){}
    protected void dumpFront(Printer p0, String p1){}
    public Bundle metaData = null;
    public CharSequence loadLabel(PackageManager p0){ return null; }
    public CharSequence nonLocalizedLabel = null;
    public Drawable loadBanner(PackageManager p0){ return null; }
    public Drawable loadIcon(PackageManager p0){ return null; }
    public Drawable loadLogo(PackageManager p0){ return null; }
    public Drawable loadUnbadgedIcon(PackageManager p0){ return null; }
    public PackageItemInfo(){}
    public PackageItemInfo(PackageItemInfo p0){}
    public String name = null;
    public String packageName = null;
    public XmlResourceParser loadXmlMetaData(PackageManager p0, String p1){ return null; }
    public int banner = 0;
    public int icon = 0;
    public int labelRes = 0;
    public int logo = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
