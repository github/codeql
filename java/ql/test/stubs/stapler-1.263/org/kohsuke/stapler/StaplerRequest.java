// Generated automatically from org.kohsuke.stapler.StaplerRequest for testing purposes

package org.kohsuke.stapler;

import java.lang.reflect.Type;
import java.util.Calendar;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import net.sf.json.JSONObject;
import org.apache.commons.fileupload.FileItem;
import org.kohsuke.stapler.Ancestor;
import org.kohsuke.stapler.BindInterceptor;
import org.kohsuke.stapler.Stapler;
import org.kohsuke.stapler.StaplerResponse;
import org.kohsuke.stapler.WebApp;
import org.kohsuke.stapler.bind.BoundObjectTable;
import org.kohsuke.stapler.lang.Klass;

public interface StaplerRequest extends HttpServletRequest
{
    <T> T bindJSON(Type p0, java.lang.Class<T> p1, Object p2);
    <T> T bindJSON(java.lang.Class<T> p0, JSONObject p1);
    <T> T bindParameters(java.lang.Class<T> p0, String p1);
    <T> T bindParameters(java.lang.Class<T> p0, String p1, int p2);
    <T> T findAncestorObject(java.lang.Class<T> p0);
    <T> java.util.List<T> bindJSONToList(java.lang.Class<T> p0, Object p1);
    <T> java.util.List<T> bindParametersToList(java.lang.Class<T> p0, String p1);
    Ancestor findAncestor(Class p0);
    Ancestor findAncestor(Object p0);
    BindInterceptor getBindInterceptor();
    BindInterceptor setBindInterceptor(BindInterceptor p0);
    BindInterceptor setBindInterceptpr(BindInterceptor p0);
    BindInterceptor setBindListener(BindInterceptor p0);
    BoundObjectTable getBoundObjectTable();
    FileItem getFileItem(String p0);
    JSONObject getSubmittedForm();
    List<Ancestor> getAncestors();
    RequestDispatcher getView(Class p0, String p1);
    RequestDispatcher getView(Klass<? extends Object> p0, String p1);
    RequestDispatcher getView(Object p0, String p1);
    ServletContext getServletContext();
    Stapler getStapler();
    String createJavaScriptProxy(Object p0);
    String getOriginalRequestURI();
    String getOriginalRestOfPath();
    String getReferer();
    String getRequestURIWithQueryString();
    String getRestOfPath();
    String getRootPath();
    StringBuffer getRequestURLWithQueryString();
    WebApp getWebApp();
    boolean checkIfModified(Calendar p0, StaplerResponse p1);
    boolean checkIfModified(java.util.Date p0, StaplerResponse p1);
    boolean checkIfModified(long p0, StaplerResponse p1);
    boolean checkIfModified(long p0, StaplerResponse p1, long p2);
    boolean hasParameter(String p0);
    boolean isJavaScriptProxyCall();
    void bindJSON(Object p0, JSONObject p1);
    void bindParameters(Object p0);
    void bindParameters(Object p0, String p1);
}
