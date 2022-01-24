// Generated automatically from javax.servlet.RequestDispatcher for testing purposes

package javax.servlet;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public interface RequestDispatcher
{
    static String ERROR_EXCEPTION = null;
    static String ERROR_EXCEPTION_TYPE = null;
    static String ERROR_MESSAGE = null;
    static String ERROR_REQUEST_URI = null;
    static String ERROR_SERVLET_NAME = null;
    static String ERROR_STATUS_CODE = null;
    static String FORWARD_CONTEXT_PATH = null;
    static String FORWARD_PATH_INFO = null;
    static String FORWARD_QUERY_STRING = null;
    static String FORWARD_REQUEST_URI = null;
    static String FORWARD_SERVLET_PATH = null;
    static String INCLUDE_CONTEXT_PATH = null;
    static String INCLUDE_PATH_INFO = null;
    static String INCLUDE_QUERY_STRING = null;
    static String INCLUDE_REQUEST_URI = null;
    static String INCLUDE_SERVLET_PATH = null;
    void forward(ServletRequest p0, ServletResponse p1);
    void include(ServletRequest p0, ServletResponse p1);
}
