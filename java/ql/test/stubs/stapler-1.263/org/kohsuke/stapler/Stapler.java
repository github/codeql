// Generated automatically from org.kohsuke.stapler.Stapler for testing purposes

package org.kohsuke.stapler;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.beanutils.ConvertUtilsBean;
import org.apache.commons.beanutils.Converter;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;
import org.kohsuke.stapler.WebApp;

public class Stapler extends HttpServlet
{
    protected void service(HttpServletRequest p0, HttpServletResponse p1){}
    public ClassLoader getClassLoader(){ return null; }
    public Stapler(){}
    public WebApp getWebApp(){ return null; }
    public static ClassLoader getClassLoader(ServletContext p0){ return null; }
    public static ConvertUtilsBean CONVERT_UTILS = null;
    public static Converter lookupConverter(Class p0){ return null; }
    public static Object htmlSafeArgument(Object p0){ return null; }
    public static Object[] htmlSafeArguments(Object[] p0){ return null; }
    public static Stapler getCurrent(){ return null; }
    public static StaplerRequest getCurrentRequest(){ return null; }
    public static StaplerResponse getCurrentResponse(){ return null; }
    public static String escape(String p0){ return null; }
    public static String getViewURL(Class p0, String p1){ return null; }
    public static boolean isSocketException(Throwable p0){ return false; }
    public static void setClassLoader(ServletContext p0, ClassLoader p1){}
    public static void setRoot(ServletContextEvent p0, Object p1){}
    public void buildResourcePaths(){}
    public void forward(RequestDispatcher p0, StaplerRequest p1, HttpServletResponse p2){}
    public void init(ServletConfig p0){}
    public void invoke(HttpServletRequest p0, HttpServletResponse p1, Object p2, String p3){}
}
