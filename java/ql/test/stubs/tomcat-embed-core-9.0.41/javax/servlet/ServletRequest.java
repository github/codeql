package javax.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Map;

public interface ServletRequest {
    Object getAttribute(String var1);

    Enumeration<String> getAttributeNames();

    String getCharacterEncoding();

    void setCharacterEncoding(String var1) throws UnsupportedEncodingException;

    int getContentLength();

    long getContentLengthLong();

    String getContentType();

    ServletInputStream getInputStream() throws IOException;

    String getParameter(String var1);

    Enumeration<String> getParameterNames();

    String[] getParameterValues(String var1);

    Map<String, String[]> getParameterMap();

    String getProtocol();

    String getScheme();

    String getServerName();

    int getServerPort();

    BufferedReader getReader() throws IOException;

    String getRemoteAddr();

    String getRemoteHost();

    void setAttribute(String var1, Object var2);

    void removeAttribute(String var1);

    Locale getLocale();

    Enumeration<Locale> getLocales();

    boolean isSecure();

    RequestDispatcher getRequestDispatcher(String var1);

    /** @deprecated */
    @Deprecated
    String getRealPath(String var1);

    int getRemotePort();

    String getLocalName();

    String getLocalAddr();

    int getLocalPort();

    ServletContext getServletContext();

    AsyncContext startAsync() throws IllegalStateException;

    AsyncContext startAsync(ServletRequest var1, ServletResponse var2) throws IllegalStateException;

    boolean isAsyncStarted();

    boolean isAsyncSupported();

    AsyncContext getAsyncContext();

    DispatcherType getDispatcherType();
}

