// Generated automatically from org.kohsuke.stapler.StaplerResponse for testing purposes

package org.kohsuke.stapler;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.Writer;
import java.net.URL;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JsonConfig;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.export.ExportConfig;
import org.kohsuke.stapler.export.Flavor;

public interface StaplerResponse extends HttpServletResponse
{
    JsonConfig getJsonConfig();
    OutputStream getCompressedOutputStream(HttpServletRequest p0);
    Writer getCompressedWriter(HttpServletRequest p0);
    default void serveExposedBean(StaplerRequest p0, Object p1, ExportConfig p2){}
    int reverseProxyTo(URL p0, StaplerRequest p1);
    void forward(Object p0, String p1, StaplerRequest p2);
    void forwardToPreviousPage(StaplerRequest p0);
    void sendRedirect(int p0, String p1);
    void sendRedirect2(String p0);
    void serveExposedBean(StaplerRequest p0, Object p1, Flavor p2);
    void serveFile(StaplerRequest p0, InputStream p1, long p2, int p3, String p4);
    void serveFile(StaplerRequest p0, InputStream p1, long p2, long p3, String p4);
    void serveFile(StaplerRequest p0, InputStream p1, long p2, long p3, int p4, String p5);
    void serveFile(StaplerRequest p0, InputStream p1, long p2, long p3, long p4, String p5);
    void serveFile(StaplerRequest p0, URL p1);
    void serveFile(StaplerRequest p0, URL p1, long p2);
    void serveLocalizedFile(StaplerRequest p0, URL p1);
    void serveLocalizedFile(StaplerRequest p0, URL p1, long p2);
    void setJsonConfig(JsonConfig p0);
}
