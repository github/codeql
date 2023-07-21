// Generated automatically from org.kohsuke.stapler.RequestImpl for testing purposes

package org.kohsuke.stapler;

import java.lang.reflect.Type;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import net.sf.json.JSONObject;
import org.apache.commons.fileupload.FileItem;
import org.kohsuke.stapler.Ancestor;
import org.kohsuke.stapler.AncestorImpl;
import org.kohsuke.stapler.BindInterceptor;
import org.kohsuke.stapler.Stapler;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;
import org.kohsuke.stapler.TokenList;
import org.kohsuke.stapler.WebApp;
import org.kohsuke.stapler.bind.BoundObjectTable;
import org.kohsuke.stapler.lang.Klass;

public class RequestImpl extends HttpServletRequestWrapper implements StaplerRequest {
    protected RequestImpl() {}

    public <T> T bindJSON(java.lang.Class<T> p0, JSONObject p1) {
        return null;
    }

    public <T> T bindParameters(java.lang.Class<T> p0, String p1) {
        return null;
    }

    public <T> T bindParameters(java.lang.Class<T> p0, String p1, int p2) {
        return null;
    }

    public <T> T findAncestorObject(java.lang.Class<T> p0) {
        return null;
    }

    public <T> java.util.List<T> bindJSONToList(java.lang.Class<T> p0, Object p1) {
        return null;
    }

    public <T> java.util.List<T> bindParametersToList(java.lang.Class<T> p0, String p1) {
        return null;
    }

    public Ancestor findAncestor(Class p0) {
        return null;
    }

    public Ancestor findAncestor(Object p0) {
        return null;
    }

    public BindInterceptor getBindInterceptor() {
        return null;
    }

    public BindInterceptor setBindInterceptor(BindInterceptor p0) {
        return null;
    }

    public BindInterceptor setBindInterceptpr(BindInterceptor p0) {
        return null;
    }

    public BindInterceptor setBindListener(BindInterceptor p0) {
        return null;
    }

    public BoundObjectTable getBoundObjectTable() {
        return null;
    }

    public Enumeration getParameterNames() {
        return null;
    }

    public FileItem getFileItem(String p0) {
        return null;
    }

    public JSONObject getSubmittedForm() {
        return null;
    }

    public List<Ancestor> getAncestors() {
        return null;
    }

    public Map getParameterMap() {
        return null;
    }

    public Object bindJSON(Type p0, Class p1, Object p2) {
        return null;
    }

    public RequestDispatcher getView(Class p0, String p1) {
        return null;
    }

    public RequestDispatcher getView(Klass<? extends Object> p0, Object p1, String p2) {
        return null;
    }

    public RequestDispatcher getView(Klass<? extends Object> p0, String p1) {
        return null;
    }

    public RequestDispatcher getView(Object p0, String p1) {
        return null;
    }

    public RequestImpl(Stapler p0, HttpServletRequest p1, List<AncestorImpl> p2, TokenList p3) {}

    public ServletContext getServletContext() {
        return null;
    }

    public Stapler getStapler() {
        return null;
    }

    public String createJavaScriptProxy(Object p0) {
        return null;
    }

    public String getOriginalRequestURI() {
        return null;
    }

    public String getOriginalRestOfPath() {
        return null;
    }

    public String getParameter(String p0) {
        return p0;
    }

    public String getReferer() {
        return null;
    }

    public String getRequestURIWithQueryString() {
        return null;
    }

    public String getRestOfPath() {
        return null;
    }

    public String getRootPath() {
        return null;
    }

    public StringBuffer getRequestURLWithQueryString() {
        return null;
    }

    public String[] getParameterValues(String p0) {
        return null;
    }

    public WebApp getWebApp() {
        return null;
    }

    public boolean checkIfModified(Calendar p0, StaplerResponse p1) {
        return false;
    }

    public boolean checkIfModified(java.util.Date p0, StaplerResponse p1) {
        return false;
    }

    public boolean checkIfModified(long p0, StaplerResponse p1) {
        return false;
    }

    public boolean checkIfModified(long p0, StaplerResponse p1, long p2) {
        return false;
    }

    public boolean hasParameter(String p0) {
        return false;
    }

    public boolean isJavaScriptProxyCall() {
        return false;
    }

    public final List<AncestorImpl> ancestors = null;
    public final Stapler stapler = null;
    public final TokenList tokens = null;

    public void bindJSON(Object p0, JSONObject p1) {}

    public void bindParameters(Object p0) {}

    public void bindParameters(Object p0, String p1) {}
}
