// Generated automatically from org.kohsuke.stapler.ResponseImpl for testing purposes

package org.kohsuke.stapler;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.Writer;
import java.net.URL;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import net.sf.json.JsonConfig;
import org.kohsuke.stapler.Stapler;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;
import org.kohsuke.stapler.export.ExportConfig;
import org.kohsuke.stapler.export.Flavor;

public class ResponseImpl extends HttpServletResponseWrapper implements StaplerResponse
{
    protected ResponseImpl() {}
    public JsonConfig getJsonConfig(){ return null; }
    public OutputStream getCompressedOutputStream(HttpServletRequest p0){ return null; }
    public PrintWriter getWriter(){ return null; }
    public ResponseImpl(Stapler p0, HttpServletResponse p1){}
    public ServletOutputStream getOutputStream(){ return null; }
    public Writer getCompressedWriter(HttpServletRequest p0){ return null; }
    public int reverseProxyTo(URL p0, StaplerRequest p1){ return 0; }
    public static String encode(String p0){ return null; }
    public void forward(Object p0, String p1, StaplerRequest p2){}
    public void forwardToPreviousPage(StaplerRequest p0){}
    public void sendRedirect(String p0){}
    public void sendRedirect(int p0, String p1){}
    public void sendRedirect2(String p0){}
    public void serveExposedBean(StaplerRequest p0, Object p1, ExportConfig p2){}
    public void serveExposedBean(StaplerRequest p0, Object p1, Flavor p2){}
    public void serveFile(StaplerRequest p0, InputStream p1, long p2, int p3, String p4){}
    public void serveFile(StaplerRequest p0, InputStream p1, long p2, long p3, String p4){}
    public void serveFile(StaplerRequest p0, InputStream p1, long p2, long p3, int p4, String p5){}
    public void serveFile(StaplerRequest p0, InputStream p1, long p2, long p3, long p4, String p5){}
    public void serveFile(StaplerRequest p0, URL p1){}
    public void serveFile(StaplerRequest p0, URL p1, long p2){}
    public void serveLocalizedFile(StaplerRequest p0, URL p1){}
    public void serveLocalizedFile(StaplerRequest p0, URL p1, long p2){}
    public void setJsonConfig(JsonConfig p0){}
}
