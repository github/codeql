// Generated automatically from android.app.AutomaticZenRule for testing purposes

package android.app;

import android.content.ComponentName;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import android.service.notification.ZenPolicy;

public class AutomaticZenRule implements Parcelable
{
    protected AutomaticZenRule() {}
    public AutomaticZenRule(Parcel p0){}
    public AutomaticZenRule(String p0, ComponentName p1, ComponentName p2, Uri p3, ZenPolicy p4, int p5, boolean p6){}
    public AutomaticZenRule(String p0, ComponentName p1, Uri p2, int p3, boolean p4){}
    public ComponentName getConfigurationActivity(){ return null; }
    public ComponentName getOwner(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public Uri getConditionId(){ return null; }
    public ZenPolicy getZenPolicy(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isEnabled(){ return false; }
    public int describeContents(){ return 0; }
    public int getInterruptionFilter(){ return 0; }
    public int hashCode(){ return 0; }
    public long getCreationTime(){ return 0; }
    public static Parcelable.Creator<AutomaticZenRule> CREATOR = null;
    public void setConditionId(Uri p0){}
    public void setConfigurationActivity(ComponentName p0){}
    public void setEnabled(boolean p0){}
    public void setInterruptionFilter(int p0){}
    public void setName(String p0){}
    public void setZenPolicy(ZenPolicy p0){}
    public void writeToParcel(Parcel p0, int p1){}
}
