// Generated automatically from org.springframework.web.util.WebUtils for testing purposes

package org.springframework.web.util;

import java.io.File;
import java.util.Collection;
import java.util.Map;
import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.http.HttpRequest;
import org.springframework.util.MultiValueMap;

abstract public class WebUtils
{
    public WebUtils(){}
    public static <T> T getNativeRequest(ServletRequest p0, Class<T> p1){ return null; }
    public static <T> T getNativeResponse(ServletResponse p0, Class<T> p1){ return null; }
    public static Boolean getDefaultHtmlEscape(ServletContext p0){ return null; }
    public static Boolean getResponseEncodedHtmlEscape(ServletContext p0){ return null; }
    public static Cookie getCookie(HttpServletRequest p0, String p1){ return null; }
    public static File getTempDir(ServletContext p0){ return null; }
    public static Map<String, Object> getParametersStartingWith(ServletRequest p0, String p1){ return null; }
    public static MultiValueMap<String, String> parseMatrixVariables(String p0){ return null; }
    public static Object getRequiredSessionAttribute(HttpServletRequest p0, String p1){ return null; }
    public static Object getSessionAttribute(HttpServletRequest p0, String p1){ return null; }
    public static Object getSessionMutex(HttpSession p0){ return null; }
    public static String CONTENT_TYPE_CHARSET_PREFIX = null;
    public static String DEFAULT_CHARACTER_ENCODING = null;
    public static String DEFAULT_WEB_APP_ROOT_KEY = null;
    public static String ERROR_EXCEPTION_ATTRIBUTE = null;
    public static String ERROR_EXCEPTION_TYPE_ATTRIBUTE = null;
    public static String ERROR_MESSAGE_ATTRIBUTE = null;
    public static String ERROR_REQUEST_URI_ATTRIBUTE = null;
    public static String ERROR_SERVLET_NAME_ATTRIBUTE = null;
    public static String ERROR_STATUS_CODE_ATTRIBUTE = null;
    public static String FORWARD_CONTEXT_PATH_ATTRIBUTE = null;
    public static String FORWARD_PATH_INFO_ATTRIBUTE = null;
    public static String FORWARD_QUERY_STRING_ATTRIBUTE = null;
    public static String FORWARD_REQUEST_URI_ATTRIBUTE = null;
    public static String FORWARD_SERVLET_PATH_ATTRIBUTE = null;
    public static String HTML_ESCAPE_CONTEXT_PARAM = null;
    public static String INCLUDE_CONTEXT_PATH_ATTRIBUTE = null;
    public static String INCLUDE_PATH_INFO_ATTRIBUTE = null;
    public static String INCLUDE_QUERY_STRING_ATTRIBUTE = null;
    public static String INCLUDE_REQUEST_URI_ATTRIBUTE = null;
    public static String INCLUDE_SERVLET_PATH_ATTRIBUTE = null;
    public static String RESPONSE_ENCODED_HTML_ESCAPE_CONTEXT_PARAM = null;
    public static String SESSION_MUTEX_ATTRIBUTE = null;
    public static String TEMP_DIR_CONTEXT_ATTRIBUTE = null;
    public static String WEB_APP_ROOT_KEY_PARAM = null;
    public static String findParameterValue(Map<String, ? extends Object> p0, String p1){ return null; }
    public static String findParameterValue(ServletRequest p0, String p1){ return null; }
    public static String getRealPath(ServletContext p0, String p1){ return null; }
    public static String getSessionId(HttpServletRequest p0){ return null; }
    public static String[] SUBMIT_IMAGE_SUFFIXES = null;
    public static boolean hasSubmitParameter(ServletRequest p0, String p1){ return false; }
    public static boolean isIncludeRequest(ServletRequest p0){ return false; }
    public static boolean isSameOrigin(HttpRequest p0){ return false; }
    public static boolean isValidOrigin(HttpRequest p0, Collection<String> p1){ return false; }
    public static void clearErrorRequestAttributes(HttpServletRequest p0){}
    public static void exposeErrorRequestAttributes(HttpServletRequest p0, Throwable p1, String p2){}
    public static void removeWebAppRootSystemProperty(ServletContext p0){}
    public static void setSessionAttribute(HttpServletRequest p0, String p1, Object p2){}
    public static void setWebAppRootSystemProperty(ServletContext p0){}
}
