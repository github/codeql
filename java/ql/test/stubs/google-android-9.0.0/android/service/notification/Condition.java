// Generated automatically from android.service.notification.Condition for testing purposes

package android.service.notification;

import android.content.Context;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;

public class Condition implements Parcelable
{
    protected Condition() {}
    public Condition copy(){ return null; }
    public Condition(Parcel p0){}
    public Condition(Uri p0, String p1, String p2, String p3, int p4, int p5, int p6){}
    public Condition(Uri p0, String p1, int p2){}
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public final String line1 = null;
    public final String line2 = null;
    public final String summary = null;
    public final Uri id = null;
    public final int flags = 0;
    public final int icon = 0;
    public final int state = 0;
    public int describeContents(){ return 0; }
    public int hashCode(){ return 0; }
    public static Parcelable.Creator<Condition> CREATOR = null;
    public static String SCHEME = null;
    public static String relevanceToString(int p0){ return null; }
    public static String stateToString(int p0){ return null; }
    public static Uri.Builder newId(Context p0){ return null; }
    public static boolean isValidId(Uri p0, String p1){ return false; }
    public static int FLAG_RELEVANT_ALWAYS = 0;
    public static int FLAG_RELEVANT_NOW = 0;
    public static int STATE_ERROR = 0;
    public static int STATE_FALSE = 0;
    public static int STATE_TRUE = 0;
    public static int STATE_UNKNOWN = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
