// Generated automatically from io.netty.handler.codec.http.HttpHeaders for testing purposes

package io.netty.handler.codec.http;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http.HttpMessage;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

abstract public class HttpHeaders implements Iterable<Map.Entry<String, String>>
{
    protected HttpHeaders(){}
    public HttpHeaders add(CharSequence p0, Iterable<? extends Object> p1){ return null; }
    public HttpHeaders add(CharSequence p0, Object p1){ return null; }
    public HttpHeaders add(HttpHeaders p0){ return null; }
    public HttpHeaders copy(){ return null; }
    public HttpHeaders remove(CharSequence p0){ return null; }
    public HttpHeaders set(CharSequence p0, Iterable<? extends Object> p1){ return null; }
    public HttpHeaders set(CharSequence p0, Object p1){ return null; }
    public HttpHeaders set(HttpHeaders p0){ return null; }
    public HttpHeaders setAll(HttpHeaders p0){ return null; }
    public Iterator<? extends CharSequence> valueCharSequenceIterator(CharSequence p0){ return null; }
    public Iterator<String> valueStringIterator(CharSequence p0){ return null; }
    public List<String> getAll(CharSequence p0){ return null; }
    public String get(CharSequence p0){ return null; }
    public String get(CharSequence p0, String p1){ return null; }
    public String toString(){ return null; }
    public abstract HttpHeaders add(String p0, Iterable<? extends Object> p1);
    public abstract HttpHeaders add(String p0, Object p1);
    public abstract HttpHeaders addInt(CharSequence p0, int p1);
    public abstract HttpHeaders addShort(CharSequence p0, short p1);
    public abstract HttpHeaders clear();
    public abstract HttpHeaders remove(String p0);
    public abstract HttpHeaders set(String p0, Iterable<? extends Object> p1);
    public abstract HttpHeaders set(String p0, Object p1);
    public abstract HttpHeaders setInt(CharSequence p0, int p1);
    public abstract HttpHeaders setShort(CharSequence p0, short p1);
    public abstract Integer getInt(CharSequence p0);
    public abstract Iterator<Map.Entry<CharSequence, CharSequence>> iteratorCharSequence();
    public abstract Iterator<Map.Entry<String, String>> iterator();
    public abstract List<Map.Entry<String, String>> entries();
    public abstract List<String> getAll(String p0);
    public abstract Long getTimeMillis(CharSequence p0);
    public abstract Set<String> names();
    public abstract Short getShort(CharSequence p0);
    public abstract String get(String p0);
    public abstract boolean contains(String p0);
    public abstract boolean isEmpty();
    public abstract int getInt(CharSequence p0, int p1);
    public abstract int size();
    public abstract long getTimeMillis(CharSequence p0, long p1);
    public abstract short getShort(CharSequence p0, short p1);
    public boolean contains(CharSequence p0){ return false; }
    public boolean contains(CharSequence p0, CharSequence p1, boolean p2){ return false; }
    public boolean contains(String p0, String p1, boolean p2){ return false; }
    public boolean containsValue(CharSequence p0, CharSequence p1, boolean p2){ return false; }
    public final Iterator<Map.Entry<String, String>> iteratorAsString(){ return null; }
    public final List<String> getAllAsString(CharSequence p0){ return null; }
    public final String getAsString(CharSequence p0){ return null; }
    public static CharSequence newEntity(String p0){ return null; }
    public static Date getDate(HttpMessage p0){ return null; }
    public static Date getDate(HttpMessage p0, Date p1){ return null; }
    public static Date getDateHeader(HttpMessage p0, CharSequence p1){ return null; }
    public static Date getDateHeader(HttpMessage p0, CharSequence p1, Date p2){ return null; }
    public static Date getDateHeader(HttpMessage p0, String p1){ return null; }
    public static Date getDateHeader(HttpMessage p0, String p1, Date p2){ return null; }
    public static HttpHeaders EMPTY_HEADERS = null;
    public static String getHeader(HttpMessage p0, CharSequence p1){ return null; }
    public static String getHeader(HttpMessage p0, CharSequence p1, String p2){ return null; }
    public static String getHeader(HttpMessage p0, String p1){ return null; }
    public static String getHeader(HttpMessage p0, String p1, String p2){ return null; }
    public static String getHost(HttpMessage p0){ return null; }
    public static String getHost(HttpMessage p0, String p1){ return null; }
    public static boolean equalsIgnoreCase(CharSequence p0, CharSequence p1){ return false; }
    public static boolean is100ContinueExpected(HttpMessage p0){ return false; }
    public static boolean isContentLengthSet(HttpMessage p0){ return false; }
    public static boolean isKeepAlive(HttpMessage p0){ return false; }
    public static boolean isTransferEncodingChunked(HttpMessage p0){ return false; }
    public static int getIntHeader(HttpMessage p0, CharSequence p1){ return 0; }
    public static int getIntHeader(HttpMessage p0, CharSequence p1, int p2){ return 0; }
    public static int getIntHeader(HttpMessage p0, String p1){ return 0; }
    public static int getIntHeader(HttpMessage p0, String p1, int p2){ return 0; }
    public static long getContentLength(HttpMessage p0){ return 0; }
    public static long getContentLength(HttpMessage p0, long p1){ return 0; }
    public static void addDateHeader(HttpMessage p0, CharSequence p1, Date p2){}
    public static void addDateHeader(HttpMessage p0, String p1, Date p2){}
    public static void addHeader(HttpMessage p0, CharSequence p1, Object p2){}
    public static void addHeader(HttpMessage p0, String p1, Object p2){}
    public static void addIntHeader(HttpMessage p0, CharSequence p1, int p2){}
    public static void addIntHeader(HttpMessage p0, String p1, int p2){}
    public static void clearHeaders(HttpMessage p0){}
    public static void encodeAscii(CharSequence p0, ByteBuf p1){}
    public static void removeHeader(HttpMessage p0, CharSequence p1){}
    public static void removeHeader(HttpMessage p0, String p1){}
    public static void removeTransferEncodingChunked(HttpMessage p0){}
    public static void set100ContinueExpected(HttpMessage p0){}
    public static void set100ContinueExpected(HttpMessage p0, boolean p1){}
    public static void setContentLength(HttpMessage p0, long p1){}
    public static void setDate(HttpMessage p0, Date p1){}
    public static void setDateHeader(HttpMessage p0, CharSequence p1, Date p2){}
    public static void setDateHeader(HttpMessage p0, CharSequence p1, Iterable<Date> p2){}
    public static void setDateHeader(HttpMessage p0, String p1, Date p2){}
    public static void setDateHeader(HttpMessage p0, String p1, Iterable<Date> p2){}
    public static void setHeader(HttpMessage p0, CharSequence p1, Iterable<? extends Object> p2){}
    public static void setHeader(HttpMessage p0, CharSequence p1, Object p2){}
    public static void setHeader(HttpMessage p0, String p1, Iterable<? extends Object> p2){}
    public static void setHeader(HttpMessage p0, String p1, Object p2){}
    public static void setHost(HttpMessage p0, CharSequence p1){}
    public static void setHost(HttpMessage p0, String p1){}
    public static void setIntHeader(HttpMessage p0, CharSequence p1, Iterable<Integer> p2){}
    public static void setIntHeader(HttpMessage p0, CharSequence p1, int p2){}
    public static void setIntHeader(HttpMessage p0, String p1, Iterable<Integer> p2){}
    public static void setIntHeader(HttpMessage p0, String p1, int p2){}
    public static void setKeepAlive(HttpMessage p0, boolean p1){}
    public static void setTransferEncodingChunked(HttpMessage p0){}
}
