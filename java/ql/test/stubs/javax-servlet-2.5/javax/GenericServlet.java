// Generated automatically from javax.servlet.GenericServlet for testing purposes

package javax.servlet;

import java.io.Serializable;
import java.util.Enumeration;
import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

abstract public class GenericServlet implements Serializable, Servlet, ServletConfig
{
    public Enumeration<String> getInitParameterNames(){ return null; }
    public GenericServlet(){}
    public ServletConfig getServletConfig(){ return null; }
    public ServletContext getServletContext(){ return null; }
    public String getInitParameter(String p0){ return null; }
    public String getServletInfo(){ return null; }
    public String getServletName(){ return null; }
    public abstract void service(ServletRequest p0, ServletResponse p1);
    public void destroy(){}
    public void init(){}
    public void init(ServletConfig p0){}
    public void log(String p0){}
    public void log(String p0, Throwable p1){}
}
