// Generated automatically from okhttp3.HttpUrl for testing purposes

package okhttp3;

import java.net.URI;
import java.net.URL;
import java.nio.charset.Charset;
import java.util.List;
import java.util.Set;

public class HttpUrl
{
    protected HttpUrl() {}
    public HttpUrl(String p0, String p1, String p2, String p3, int p4, List<String> p5, List<String> p6, String p7, String p8){}
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public final HttpUrl resolve(String p0){ return null; }
    public final HttpUrl.Builder newBuilder(){ return null; }
    public final HttpUrl.Builder newBuilder(String p0){ return null; }
    public final List<String> encodedPathSegments(){ return null; }
    public final List<String> pathSegments(){ return null; }
    public final List<String> queryParameterValues(String p0){ return null; }
    public final Set<String> queryParameterNames(){ return null; }
    public final String encodedFragment(){ return null; }
    public final String encodedPassword(){ return null; }
    public final String encodedPath(){ return null; }
    public final String encodedQuery(){ return null; }
    public final String encodedUsername(){ return null; }
    public final String fragment(){ return null; }
    public final String host(){ return null; }
    public final String password(){ return null; }
    public final String query(){ return null; }
    public final String queryParameter(String p0){ return null; }
    public final String queryParameterName(int p0){ return null; }
    public final String queryParameterValue(int p0){ return null; }
    public final String redact(){ return null; }
    public final String scheme(){ return null; }
    public final String topPrivateDomain(){ return null; }
    public final String username(){ return null; }
    public final URI uri(){ return null; }
    public final URL url(){ return null; }
    public final boolean isHttps(){ return false; }
    public final int pathSize(){ return 0; }
    public final int port(){ return 0; }
    public final int querySize(){ return 0; }
    public int hashCode(){ return 0; }
    public static HttpUrl get(String p0){ return null; }
    public static HttpUrl get(URI p0){ return null; }
    public static HttpUrl get(URL p0){ return null; }
    public static HttpUrl parse(String p0){ return null; }
    public static HttpUrl.Companion Companion = null;
    public static String FORM_ENCODE_SET = null;
    public static String FRAGMENT_ENCODE_SET = null;
    public static String FRAGMENT_ENCODE_SET_URI = null;
    public static String PASSWORD_ENCODE_SET = null;
    public static String PATH_SEGMENT_ENCODE_SET = null;
    public static String PATH_SEGMENT_ENCODE_SET_URI = null;
    public static String QUERY_COMPONENT_ENCODE_SET = null;
    public static String QUERY_COMPONENT_ENCODE_SET_URI = null;
    public static String QUERY_COMPONENT_REENCODE_SET = null;
    public static String QUERY_ENCODE_SET = null;
    public static String USERNAME_ENCODE_SET = null;
    public static int defaultPort(String p0){ return 0; }
    static public class Builder
    {
        public Builder(){}
        public String toString(){ return null; }
        public final HttpUrl build(){ return null; }
        public final HttpUrl.Builder addEncodedPathSegment(String p0){ return null; }
        public final HttpUrl.Builder addEncodedPathSegments(String p0){ return null; }
        public final HttpUrl.Builder addEncodedQueryParameter(String p0, String p1){ return null; }
        public final HttpUrl.Builder addPathSegment(String p0){ return null; }
        public final HttpUrl.Builder addPathSegments(String p0){ return null; }
        public final HttpUrl.Builder addQueryParameter(String p0, String p1){ return null; }
        public final HttpUrl.Builder encodedFragment(String p0){ return null; }
        public final HttpUrl.Builder encodedPassword(String p0){ return null; }
        public final HttpUrl.Builder encodedPath(String p0){ return null; }
        public final HttpUrl.Builder encodedQuery(String p0){ return null; }
        public final HttpUrl.Builder encodedUsername(String p0){ return null; }
        public final HttpUrl.Builder fragment(String p0){ return null; }
        public final HttpUrl.Builder host(String p0){ return null; }
        public final HttpUrl.Builder parse$okhttp(HttpUrl p0, String p1){ return null; }
        public final HttpUrl.Builder password(String p0){ return null; }
        public final HttpUrl.Builder port(int p0){ return null; }
        public final HttpUrl.Builder query(String p0){ return null; }
        public final HttpUrl.Builder reencodeForUri$okhttp(){ return null; }
        public final HttpUrl.Builder removeAllEncodedQueryParameters(String p0){ return null; }
        public final HttpUrl.Builder removeAllQueryParameters(String p0){ return null; }
        public final HttpUrl.Builder removePathSegment(int p0){ return null; }
        public final HttpUrl.Builder scheme(String p0){ return null; }
        public final HttpUrl.Builder setEncodedPathSegment(int p0, String p1){ return null; }
        public final HttpUrl.Builder setEncodedQueryParameter(String p0, String p1){ return null; }
        public final HttpUrl.Builder setPathSegment(int p0, String p1){ return null; }
        public final HttpUrl.Builder setQueryParameter(String p0, String p1){ return null; }
        public final HttpUrl.Builder username(String p0){ return null; }
        public final List<String> getEncodedPathSegments$okhttp(){ return null; }
        public final List<String> getEncodedQueryNamesAndValues$okhttp(){ return null; }
        public final String getEncodedFragment$okhttp(){ return null; }
        public final String getEncodedPassword$okhttp(){ return null; }
        public final String getEncodedUsername$okhttp(){ return null; }
        public final String getHost$okhttp(){ return null; }
        public final String getScheme$okhttp(){ return null; }
        public final int getPort$okhttp(){ return 0; }
        public final void setEncodedFragment$okhttp(String p0){}
        public final void setEncodedPassword$okhttp(String p0){}
        public final void setEncodedQueryNamesAndValues$okhttp(List<String> p0){}
        public final void setEncodedUsername$okhttp(String p0){}
        public final void setHost$okhttp(String p0){}
        public final void setPort$okhttp(int p0){}
        public final void setScheme$okhttp(String p0){}
        public static HttpUrl.Builder.Companion Companion = null;
        public static String INVALID_HOST = null;
        static public class Companion
        {
            protected Companion() {}
        }
    }
    static public class Companion
    {
        protected Companion() {}
        public final HttpUrl get(String p0){ return null; }
        public final HttpUrl get(URI p0){ return null; }
        public final HttpUrl get(URL p0){ return null; }
        public final HttpUrl parse(String p0){ return null; }
        public final List<String> toQueryNamesAndValues$okhttp(String p0){ return null; }
        public final String canonicalize$okhttp(String p0, int p1, int p2, String p3, boolean p4, boolean p5, boolean p6, boolean p7, Charset p8){ return null; }
        public final String percentDecode$okhttp(String p0, int p1, int p2, boolean p3){ return null; }
        public final int defaultPort(String p0){ return 0; }
        public final void toPathString$okhttp(List<String> p0, StringBuilder p1){}
        public final void toQueryString$okhttp(List<String> p0, StringBuilder p1){}
    }
}
