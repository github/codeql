// Generated automatically from android.view.ContentInfo for testing purposes

package android.view;

import android.content.ClipData;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

public class ContentInfo implements Parcelable
{
    protected ContentInfo() {}
    public Bundle getExtras(){ return null; }
    public ClipData getClip(){ return null; }
    public String toString(){ return null; }
    public Uri getLinkUri(){ return null; }
    public int describeContents(){ return 0; }
    public int getFlags(){ return 0; }
    public int getSource(){ return 0; }
    public static Parcelable.Creator<ContentInfo> CREATOR = null;
    public static int FLAG_CONVERT_TO_PLAIN_TEXT = 0;
    public static int SOURCE_APP = 0;
    public static int SOURCE_AUTOFILL = 0;
    public static int SOURCE_CLIPBOARD = 0;
    public static int SOURCE_DRAG_AND_DROP = 0;
    public static int SOURCE_INPUT_METHOD = 0;
    public static int SOURCE_PROCESS_TEXT = 0;
    public void writeToParcel(Parcel p0, int p1){}
}
