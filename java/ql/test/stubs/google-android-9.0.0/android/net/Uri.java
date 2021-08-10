// Generated automatically from android.net.Uri for testing purposes

package android.net;

import android.os.Parcel;
import android.os.Parcelable;
import java.io.File;
import java.util.List;
import java.util.Set;

abstract public class Uri implements Comparable<Uri>, Parcelable
{
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

    public Builder buildUpon() { return null; }

    /**
     * Helper class for building or manipulating URI references. Not safe for
     * concurrent use.
     *
     * <p>An absolute hierarchical URI reference follows the pattern:
     * {@code <scheme>://<authority><absolute path>?<query>#<fragment>}
     *
     * <p>Relative URI references (which are always hierarchical) follow one
     * of two patterns: {@code <relative or absolute path>?<query>#<fragment>}
     * or {@code //<authority><absolute path>?<query>#<fragment>}
     *
     * <p>An opaque URI follows this pattern:
     * {@code <scheme>:<opaque part>#<fragment>}
     *
     * <p>Use {@link Uri#buildUpon()} to obtain a builder representing an existing URI.
     */
    public static final class Builder {
        /**
         * Constructs a new Builder.
         */
        public Builder() {}
        /**
         * Sets the scheme.
         *
         * @param scheme name or {@code null} if this is a relative Uri
         */
        public Builder scheme(String scheme) {
            return null;
        }
        /**
         * Encodes and sets the given opaque scheme-specific-part.
         *
         * @param opaquePart decoded opaque part
         */
        public Builder opaquePart(String opaquePart) {
            return null;
        }
        /**
         * Sets the previously encoded opaque scheme-specific-part.
         *
         * @param opaquePart encoded opaque part
         */
        public Builder encodedOpaquePart(String opaquePart) {
            return null;
        }
        /**
         * Encodes and sets the authority.
         */
        public Builder authority(String authority) {
            return null;
        }
        /**
         * Sets the previously encoded authority.
         */
        public Builder encodedAuthority(String authority) {
            return null;
        }
        /**
         * Sets the path. Leaves '/' characters intact but encodes others as
         * necessary.
         *
         * <p>If the path is not null and doesn't start with a '/', and if
         * you specify a scheme and/or authority, the builder will prepend the
         * given path with a '/'.
         */
        public Builder path(String path) {
            return null;
        }
        /**
         * Sets the previously encoded path.
         *
         * <p>If the path is not null and doesn't start with a '/', and if
         * you specify a scheme and/or authority, the builder will prepend the
         * given path with a '/'.
         */
        public Builder encodedPath(String path) {
            return null;
        }
        /**
         * Encodes the given segment and appends it to the path.
         */
        public Builder appendPath(String newSegment) {
            return null;
        }
        /**
         * Appends the given segment to the path.
         */
        public Builder appendEncodedPath(String newSegment) {
            return null;
        }
        /**
         * Encodes and sets the query.
         */
        public Builder query(String query) {
            return null;
        }
        /**
         * Sets the previously encoded query.
         */
        public Builder encodedQuery(String query) {
            return null;
        }
        /**
         * Encodes and sets the fragment.
         */
        public Builder fragment(String fragment) {
            return null;
        }
        /**
         * Sets the previously encoded fragment.
         */
        public Builder encodedFragment(String fragment) {
            return null;
        }
        /**
         * Encodes the key and value and then appends the parameter to the
         * query string.
         *
         * @param key which will be encoded
         * @param value which will be encoded
         */
        public Builder appendQueryParameter(String key, String value) {
            return null;
        }
        /**
         * Clears the the previously set query.
         */
        public Builder clearQuery() {
          return null;
        }
        /**
         * Constructs a Uri with the current attributes.
         *
         * @throws UnsupportedOperationException if the URI is opaque and the
         *  scheme is null
         */
        public Uri build() {
          return null;
        }
        @Override
        public String toString() {
            return null;
        }
    }

}
