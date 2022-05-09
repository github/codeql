// Generated automatically from org.springframework.http.HttpHeaders for testing purposes

package org.springframework.http;

import java.io.Serializable;
import java.net.InetSocketAddress;
import java.net.URI;
import java.nio.charset.Charset;
import java.time.Duration;
import java.time.Instant;
import java.time.ZonedDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import org.springframework.http.CacheControl;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpRange;
import org.springframework.http.MediaType;
import org.springframework.util.MultiValueMap;

public class HttpHeaders implements MultiValueMap<String, String>, Serializable
{
    protected List<String> getETagValuesAsList(String p0){ return null; }
    protected String getFieldValues(String p0){ return null; }
    protected String toCommaDelimitedString(List<String> p0){ return null; }
    public Collection<List<String>> values(){ return null; }
    public ContentDisposition getContentDisposition(){ return null; }
    public HttpHeaders(){}
    public HttpHeaders(MultiValueMap<String, String> p0){}
    public HttpMethod getAccessControlRequestMethod(){ return null; }
    public InetSocketAddress getHost(){ return null; }
    public List<Charset> getAcceptCharset(){ return null; }
    public List<HttpMethod> getAccessControlAllowMethods(){ return null; }
    public List<HttpRange> getRange(){ return null; }
    public List<Locale.LanguageRange> getAcceptLanguage(){ return null; }
    public List<Locale> getAcceptLanguageAsLocales(){ return null; }
    public List<MediaType> getAccept(){ return null; }
    public List<MediaType> getAcceptPatch(){ return null; }
    public List<String> get(Object p0){ return null; }
    public List<String> getAccessControlAllowHeaders(){ return null; }
    public List<String> getAccessControlExposeHeaders(){ return null; }
    public List<String> getAccessControlRequestHeaders(){ return null; }
    public List<String> getConnection(){ return null; }
    public List<String> getIfMatch(){ return null; }
    public List<String> getIfNoneMatch(){ return null; }
    public List<String> getOrEmpty(Object p0){ return null; }
    public List<String> getValuesAsList(String p0){ return null; }
    public List<String> getVary(){ return null; }
    public List<String> put(String p0, List<String> p1){ return null; }
    public List<String> remove(Object p0){ return null; }
    public Locale getContentLanguage(){ return null; }
    public Map<String, String> toSingleValueMap(){ return null; }
    public MediaType getContentType(){ return null; }
    public Set<HttpMethod> getAllow(){ return null; }
    public Set<Map.Entry<String, List<String>>> entrySet(){ return null; }
    public Set<String> keySet(){ return null; }
    public String getAccessControlAllowOrigin(){ return null; }
    public String getCacheControl(){ return null; }
    public String getETag(){ return null; }
    public String getFirst(String p0){ return null; }
    public String getOrigin(){ return null; }
    public String getPragma(){ return null; }
    public String getUpgrade(){ return null; }
    public String toString(){ return null; }
    public URI getLocation(){ return null; }
    public ZonedDateTime getFirstZonedDateTime(String p0){ return null; }
    public boolean containsKey(Object p0){ return false; }
    public boolean containsValue(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean getAccessControlAllowCredentials(){ return false; }
    public boolean isEmpty(){ return false; }
    public int hashCode(){ return 0; }
    public int size(){ return 0; }
    public long getAccessControlMaxAge(){ return 0; }
    public long getContentLength(){ return 0; }
    public long getDate(){ return 0; }
    public long getExpires(){ return 0; }
    public long getFirstDate(String p0){ return 0; }
    public long getIfModifiedSince(){ return 0; }
    public long getIfUnmodifiedSince(){ return 0; }
    public long getLastModified(){ return 0; }
    public static HttpHeaders EMPTY = null;
    public static HttpHeaders readOnlyHttpHeaders(HttpHeaders p0){ return null; }
    public static HttpHeaders readOnlyHttpHeaders(MultiValueMap<String, String> p0){ return null; }
    public static HttpHeaders writableHttpHeaders(HttpHeaders p0){ return null; }
    public static String ACCEPT = null;
    public static String ACCEPT_CHARSET = null;
    public static String ACCEPT_ENCODING = null;
    public static String ACCEPT_LANGUAGE = null;
    public static String ACCEPT_PATCH = null;
    public static String ACCEPT_RANGES = null;
    public static String ACCESS_CONTROL_ALLOW_CREDENTIALS = null;
    public static String ACCESS_CONTROL_ALLOW_HEADERS = null;
    public static String ACCESS_CONTROL_ALLOW_METHODS = null;
    public static String ACCESS_CONTROL_ALLOW_ORIGIN = null;
    public static String ACCESS_CONTROL_EXPOSE_HEADERS = null;
    public static String ACCESS_CONTROL_MAX_AGE = null;
    public static String ACCESS_CONTROL_REQUEST_HEADERS = null;
    public static String ACCESS_CONTROL_REQUEST_METHOD = null;
    public static String AGE = null;
    public static String ALLOW = null;
    public static String AUTHORIZATION = null;
    public static String CACHE_CONTROL = null;
    public static String CONNECTION = null;
    public static String CONTENT_DISPOSITION = null;
    public static String CONTENT_ENCODING = null;
    public static String CONTENT_LANGUAGE = null;
    public static String CONTENT_LENGTH = null;
    public static String CONTENT_LOCATION = null;
    public static String CONTENT_RANGE = null;
    public static String CONTENT_TYPE = null;
    public static String COOKIE = null;
    public static String DATE = null;
    public static String ETAG = null;
    public static String EXPECT = null;
    public static String EXPIRES = null;
    public static String FROM = null;
    public static String HOST = null;
    public static String IF_MATCH = null;
    public static String IF_MODIFIED_SINCE = null;
    public static String IF_NONE_MATCH = null;
    public static String IF_RANGE = null;
    public static String IF_UNMODIFIED_SINCE = null;
    public static String LAST_MODIFIED = null;
    public static String LINK = null;
    public static String LOCATION = null;
    public static String MAX_FORWARDS = null;
    public static String ORIGIN = null;
    public static String PRAGMA = null;
    public static String PROXY_AUTHENTICATE = null;
    public static String PROXY_AUTHORIZATION = null;
    public static String RANGE = null;
    public static String REFERER = null;
    public static String RETRY_AFTER = null;
    public static String SERVER = null;
    public static String SET_COOKIE = null;
    public static String SET_COOKIE2 = null;
    public static String TE = null;
    public static String TRAILER = null;
    public static String TRANSFER_ENCODING = null;
    public static String UPGRADE = null;
    public static String USER_AGENT = null;
    public static String VARY = null;
    public static String VIA = null;
    public static String WARNING = null;
    public static String WWW_AUTHENTICATE = null;
    public static String encodeBasicAuth(String p0, String p1, Charset p2){ return null; }
    public static String formatHeaders(MultiValueMap<String, String> p0){ return null; }
    public void add(String p0, String p1){}
    public void addAll(MultiValueMap<String, String> p0){}
    public void addAll(String p0, List<? extends String> p1){}
    public void clear(){}
    public void clearContentHeaders(){}
    public void putAll(Map<? extends String, ? extends List<String>> p0){}
    public void set(String p0, String p1){}
    public void setAccept(List<MediaType> p0){}
    public void setAcceptCharset(List<Charset> p0){}
    public void setAcceptLanguage(List<Locale.LanguageRange> p0){}
    public void setAcceptLanguageAsLocales(List<Locale> p0){}
    public void setAcceptPatch(List<MediaType> p0){}
    public void setAccessControlAllowCredentials(boolean p0){}
    public void setAccessControlAllowHeaders(List<String> p0){}
    public void setAccessControlAllowMethods(List<HttpMethod> p0){}
    public void setAccessControlAllowOrigin(String p0){}
    public void setAccessControlExposeHeaders(List<String> p0){}
    public void setAccessControlMaxAge(Duration p0){}
    public void setAccessControlMaxAge(long p0){}
    public void setAccessControlRequestHeaders(List<String> p0){}
    public void setAccessControlRequestMethod(HttpMethod p0){}
    public void setAll(Map<String, String> p0){}
    public void setAllow(Set<HttpMethod> p0){}
    public void setBasicAuth(String p0){}
    public void setBasicAuth(String p0, String p1){}
    public void setBasicAuth(String p0, String p1, Charset p2){}
    public void setBearerAuth(String p0){}
    public void setCacheControl(CacheControl p0){}
    public void setCacheControl(String p0){}
    public void setConnection(List<String> p0){}
    public void setConnection(String p0){}
    public void setContentDisposition(ContentDisposition p0){}
    public void setContentDispositionFormData(String p0, String p1){}
    public void setContentLanguage(Locale p0){}
    public void setContentLength(long p0){}
    public void setContentType(MediaType p0){}
    public void setDate(Instant p0){}
    public void setDate(String p0, long p1){}
    public void setDate(ZonedDateTime p0){}
    public void setDate(long p0){}
    public void setETag(String p0){}
    public void setExpires(Instant p0){}
    public void setExpires(ZonedDateTime p0){}
    public void setExpires(long p0){}
    public void setHost(InetSocketAddress p0){}
    public void setIfMatch(List<String> p0){}
    public void setIfMatch(String p0){}
    public void setIfModifiedSince(Instant p0){}
    public void setIfModifiedSince(ZonedDateTime p0){}
    public void setIfModifiedSince(long p0){}
    public void setIfNoneMatch(List<String> p0){}
    public void setIfNoneMatch(String p0){}
    public void setIfUnmodifiedSince(Instant p0){}
    public void setIfUnmodifiedSince(ZonedDateTime p0){}
    public void setIfUnmodifiedSince(long p0){}
    public void setInstant(String p0, Instant p1){}
    public void setLastModified(Instant p0){}
    public void setLastModified(ZonedDateTime p0){}
    public void setLastModified(long p0){}
    public void setLocation(URI p0){}
    public void setOrigin(String p0){}
    public void setPragma(String p0){}
    public void setRange(List<HttpRange> p0){}
    public void setUpgrade(String p0){}
    public void setVary(List<String> p0){}
    public void setZonedDateTime(String p0, ZonedDateTime p1){}
}
