// Generated automatically from javax.servlet.AsyncContext for testing purposes

package javax.servlet;

import javax.servlet.AsyncListener;
import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public interface AsyncContext
{
    <T extends AsyncListener> T createListener(java.lang.Class<T> p0);
    ServletRequest getRequest();
    ServletResponse getResponse();
    boolean hasOriginalRequestAndResponse();
    long getTimeout();
    static String ASYNC_CONTEXT_PATH = null;
    static String ASYNC_MAPPING = null;
    static String ASYNC_PATH_INFO = null;
    static String ASYNC_QUERY_STRING = null;
    static String ASYNC_REQUEST_URI = null;
    static String ASYNC_SERVLET_PATH = null;
    void addListener(AsyncListener p0);
    void addListener(AsyncListener p0, ServletRequest p1, ServletResponse p2);
    void complete();
    void dispatch();
    void dispatch(ServletContext p0, String p1);
    void dispatch(String p0);
    void setTimeout(long p0);
    void start(Runnable p0);
}
