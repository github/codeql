// Generated automatically from android.content.ContentProviderOperation for testing purposes

package android.content;

import android.content.ContentProvider;
import android.content.ContentProviderResult;
import android.content.ContentValues;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

public class ContentProviderOperation implements Parcelable
{
    public Bundle resolveExtrasBackReferences(ContentProviderResult[] p0, int p1){ return null; }
    public ContentProviderResult apply(ContentProvider p0, ContentProviderResult[] p1, int p2){ return null; }
    public ContentValues resolveValueBackReferences(ContentProviderResult[] p0, int p1){ return null; }
    public String toString(){ return null; }
    public String[] resolveSelectionArgsBackReferences(ContentProviderResult[] p0, int p1){ return null; }
    public Uri getUri(){ return null; }
    public boolean isAssertQuery(){ return false; }
    public boolean isCall(){ return false; }
    public boolean isDelete(){ return false; }
    public boolean isExceptionAllowed(){ return false; }
    public boolean isInsert(){ return false; }
    public boolean isReadOperation(){ return false; }
    public boolean isUpdate(){ return false; }
    public boolean isWriteOperation(){ return false; }
    public boolean isYieldAllowed(){ return false; }
    public int describeContents(){ return 0; }
    public static ContentProviderOperation.Builder newAssertQuery(Uri p0){ return null; }
    public static ContentProviderOperation.Builder newCall(Uri p0, String p1, String p2){ return null; }
    public static ContentProviderOperation.Builder newDelete(Uri p0){ return null; }
    public static ContentProviderOperation.Builder newInsert(Uri p0){ return null; }
    public static ContentProviderOperation.Builder newUpdate(Uri p0){ return null; }
    public static Parcelable.Creator<ContentProviderOperation> CREATOR = null;
    public void writeToParcel(Parcel p0, int p1){}
    static public class Builder
    {
        protected Builder() {}
        public ContentProviderOperation build(){ return null; }
        public ContentProviderOperation.Builder withExceptionAllowed(boolean p0){ return null; }
        public ContentProviderOperation.Builder withExpectedCount(int p0){ return null; }
        public ContentProviderOperation.Builder withExtra(String p0, Object p1){ return null; }
        public ContentProviderOperation.Builder withExtraBackReference(String p0, int p1){ return null; }
        public ContentProviderOperation.Builder withExtraBackReference(String p0, int p1, String p2){ return null; }
        public ContentProviderOperation.Builder withExtras(Bundle p0){ return null; }
        public ContentProviderOperation.Builder withSelection(String p0, String[] p1){ return null; }
        public ContentProviderOperation.Builder withSelectionBackReference(int p0, int p1){ return null; }
        public ContentProviderOperation.Builder withSelectionBackReference(int p0, int p1, String p2){ return null; }
        public ContentProviderOperation.Builder withValue(String p0, Object p1){ return null; }
        public ContentProviderOperation.Builder withValueBackReference(String p0, int p1){ return null; }
        public ContentProviderOperation.Builder withValueBackReference(String p0, int p1, String p2){ return null; }
        public ContentProviderOperation.Builder withValueBackReferences(ContentValues p0){ return null; }
        public ContentProviderOperation.Builder withValues(ContentValues p0){ return null; }
        public ContentProviderOperation.Builder withYieldAllowed(boolean p0){ return null; }
    }
}
