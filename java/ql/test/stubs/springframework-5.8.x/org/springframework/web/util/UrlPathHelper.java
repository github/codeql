// Generated automatically from org.springframework.web.util.UrlPathHelper for testing purposes

package org.springframework.web.util;

import java.util.Map;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import org.springframework.util.MultiValueMap;

public class UrlPathHelper
{
    protected String determineEncoding(HttpServletRequest p0){ return null; }
    protected String getDefaultEncoding(){ return null; }
    protected String getPathWithinServletMapping(HttpServletRequest p0, String p1){ return null; }
    public Map<String, String> decodePathVariables(HttpServletRequest p0, Map<String, String> p1){ return null; }
    public MultiValueMap<String, String> decodeMatrixVariables(HttpServletRequest p0, MultiValueMap<String, String> p1){ return null; }
    public String decodeRequestString(HttpServletRequest p0, String p1){ return null; }
    public String getContextPath(HttpServletRequest p0){ return null; }
    public String getLookupPathForRequest(HttpServletRequest p0){ return null; }
    public String getLookupPathForRequest(HttpServletRequest p0, String p1){ return null; }
    public String getOriginatingContextPath(HttpServletRequest p0){ return null; }
    public String getOriginatingQueryString(HttpServletRequest p0){ return null; }
    public String getOriginatingRequestUri(HttpServletRequest p0){ return null; }
    public String getOriginatingServletPath(HttpServletRequest p0){ return null; }
    public String getPathWithinApplication(HttpServletRequest p0){ return null; }
    public String getPathWithinServletMapping(HttpServletRequest p0){ return null; }
    public String getRequestUri(HttpServletRequest p0){ return null; }
    public String getServletPath(HttpServletRequest p0){ return null; }
    public String removeSemicolonContent(String p0){ return null; }
    public String resolveAndCacheLookupPath(HttpServletRequest p0){ return null; }
    public UrlPathHelper(){}
    public boolean isUrlDecode(){ return false; }
    public boolean shouldRemoveSemicolonContent(){ return false; }
    public static String PATH_ATTRIBUTE = null;
    public static String getResolvedLookupPath(ServletRequest p0){ return null; }
    public static UrlPathHelper defaultInstance = null;
    public static UrlPathHelper rawPathInstance = null;
    public void setAlwaysUseFullPath(boolean p0){}
    public void setDefaultEncoding(String p0){}
    public void setRemoveSemicolonContent(boolean p0){}
    public void setUrlDecode(boolean p0){}
    static Boolean websphereComplianceFlag = null;
    static boolean servlet4Present = false;
}
