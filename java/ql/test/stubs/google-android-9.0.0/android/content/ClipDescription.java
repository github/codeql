// Generated automatically from android.content.ClipDescription for testing purposes

package android.content;

import android.os.Parcel;
import android.os.Parcelable;
import android.os.PersistableBundle;

public class ClipDescription implements Parcelable
{
    protected ClipDescription() {}
    public CharSequence getLabel(){ return null; }
    public ClipDescription(CharSequence p0, String[] p1){}
    public ClipDescription(ClipDescription p0){}
    public PersistableBundle getExtras(){ return null; }
    public String getMimeType(int p0){ return null; }
    public String toString(){ return null; }
    public String[] filterMimeTypes(String p0){ return null; }
    public boolean hasMimeType(String p0){ return false; }
    public boolean isStyledText(){ return false; }
    public float getConfidenceScore(String p0){ return 0; }
    public int describeContents(){ return 0; }
    public int getClassificationStatus(){ return 0; }
    public int getMimeTypeCount(){ return 0; }
    public long getTimestamp(){ return 0; }
    public static Parcelable.Creator<ClipDescription> CREATOR = null;
    public static String MIMETYPE_TEXT_HTML = null;
    public static String MIMETYPE_TEXT_INTENT = null;
    public static String MIMETYPE_TEXT_PLAIN = null;
    public static String MIMETYPE_TEXT_URILIST = null;
    public static String MIMETYPE_UNKNOWN = null;
    public static boolean compareMimeTypes(String p0, String p1){ return false; }
    public static int CLASSIFICATION_COMPLETE = 0;
    public static int CLASSIFICATION_NOT_COMPLETE = 0;
    public static int CLASSIFICATION_NOT_PERFORMED = 0;
    public void setExtras(PersistableBundle p0){}
    public void writeToParcel(Parcel p0, int p1){}
}
