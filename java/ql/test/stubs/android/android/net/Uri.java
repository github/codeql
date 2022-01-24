// Generated automatically from android.net.Uri for testing purposes

package android.net;

import android.os.Parcel;
import android.os.Parcelable;
import java.io.File;
import java.util.List;
import java.util.Set;

abstract public class Uri implements Comparable<Uri>, Parcelable
{
    protected Uri() {}
    public List<String> getQueryParameters(String p0){ return null; }
    public Set<String> getQueryParameterNames(){ return null; }
    public String getQueryParameter(String p0){ return null; }
    public Uri normalizeScheme(){ return null; }
    public abstract List<String> getPathSegments();
    public abstract String getAuthority();
    public abstract String getEncodedAuthority();
    public abstract String getEncodedFragment();
    public abstract String getEncodedPath();
    public abstract String getEncodedQuery();
    public abstract String getEncodedSchemeSpecificPart();
    public abstract String getEncodedUserInfo();
    public abstract String getFragment();
    public abstract String getHost();
    public abstract String getLastPathSegment();
    public abstract String getPath();
    public abstract String getQuery();
    public abstract String getScheme();
    public abstract String getSchemeSpecificPart();
    public abstract String getUserInfo();
    public abstract String toString();
    public abstract Uri.Builder buildUpon();
    public abstract boolean isHierarchical();
    public abstract boolean isRelative();
    public abstract int getPort();
    public boolean equals(Object p0){ return false; }
    public boolean getBooleanQueryParameter(String p0, boolean p1){ return false; }
    public boolean isAbsolute(){ return false; }
    public boolean isOpaque(){ return false; }
    public int compareTo(Uri p0){ return 0; }
    public int hashCode(){ return 0; }
    public static Parcelable.Creator<Uri> CREATOR = null;
    public static String decode(String p0){ return null; }
    public static String encode(String p0){ return null; }
    public static String encode(String p0, String p1){ return null; }
    public static Uri EMPTY = null;
    public static Uri fromFile(File p0){ return null; }
    public static Uri fromParts(String p0, String p1, String p2){ return null; }
    public static Uri parse(String p0){ return null; }
    public static Uri withAppendedPath(Uri p0, String p1){ return null; }
    public static void writeToParcel(Parcel p0, Uri p1){}
    static public class Builder
    {
        public Builder(){}
        public String toString(){ return null; }
        public Uri build(){ return null; }
        public Uri.Builder appendEncodedPath(String p0){ return null; }
        public Uri.Builder appendPath(String p0){ return null; }
        public Uri.Builder appendQueryParameter(String p0, String p1){ return null; }
        public Uri.Builder authority(String p0){ return null; }
        public Uri.Builder clearQuery(){ return null; }
        public Uri.Builder encodedAuthority(String p0){ return null; }
        public Uri.Builder encodedFragment(String p0){ return null; }
        public Uri.Builder encodedOpaquePart(String p0){ return null; }
        public Uri.Builder encodedPath(String p0){ return null; }
        public Uri.Builder encodedQuery(String p0){ return null; }
        public Uri.Builder fragment(String p0){ return null; }
        public Uri.Builder opaquePart(String p0){ return null; }
        public Uri.Builder path(String p0){ return null; }
        public Uri.Builder query(String p0){ return null; }
        public Uri.Builder scheme(String p0){ return null; }
    }
}
