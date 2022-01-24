// Generated automatically from android.content.ClipData for testing purposes

package android.content;

import android.content.ClipDescription;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import android.view.textclassifier.TextLinks;

public class ClipData implements Parcelable
{
    protected ClipData() {}
    public ClipData(CharSequence p0, String[] p1, ClipData.Item p2){}
    public ClipData(ClipData p0){}
    public ClipData(ClipDescription p0, ClipData.Item p1){}
    public ClipData.Item getItemAt(int p0){ return null; }
    public ClipDescription getDescription(){ return null; }
    public String toString(){ return null; }
    public int describeContents(){ return 0; }
    public int getItemCount(){ return 0; }
    public static ClipData newHtmlText(CharSequence p0, CharSequence p1, String p2){ return null; }
    public static ClipData newIntent(CharSequence p0, Intent p1){ return null; }
    public static ClipData newPlainText(CharSequence p0, CharSequence p1){ return null; }
    public static ClipData newRawUri(CharSequence p0, Uri p1){ return null; }
    public static ClipData newUri(ContentResolver p0, CharSequence p1, Uri p2){ return null; }
    public static Parcelable.Creator<ClipData> CREATOR = null;
    public void addItem(ClipData.Item p0){}
    public void addItem(ContentResolver p0, ClipData.Item p1){}
    public void writeToParcel(Parcel p0, int p1){}
    static public class Item
    {
        protected Item() {}
        public CharSequence coerceToStyledText(Context p0){ return null; }
        public CharSequence coerceToText(Context p0){ return null; }
        public CharSequence getText(){ return null; }
        public Intent getIntent(){ return null; }
        public Item(CharSequence p0){}
        public Item(CharSequence p0, Intent p1, Uri p2){}
        public Item(CharSequence p0, String p1){}
        public Item(CharSequence p0, String p1, Intent p2, Uri p3){}
        public Item(Intent p0){}
        public Item(Uri p0){}
        public String coerceToHtmlText(Context p0){ return null; }
        public String getHtmlText(){ return null; }
        public String toString(){ return null; }
        public TextLinks getTextLinks(){ return null; }
        public Uri getUri(){ return null; }
    }
}
