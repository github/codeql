// Generated automatically from io.netty.handler.codec.http.cookie.Cookie for testing purposes

package io.netty.handler.codec.http.cookie;


public interface Cookie extends Comparable<Cookie>
{
    String domain();
    String name();
    String path();
    String value();
    boolean isHttpOnly();
    boolean isSecure();
    boolean wrap();
    long maxAge();
    static long UNDEFINED_MAX_AGE = 0;
    void setDomain(String p0);
    void setHttpOnly(boolean p0);
    void setMaxAge(long p0);
    void setPath(String p0);
    void setSecure(boolean p0);
    void setValue(String p0);
    void setWrap(boolean p0);
}
