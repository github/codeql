package org.springframework.web.servlet.view;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Array;
import java.net.URLEncoder;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.lang.Nullable;

public class RedirectView extends AbstractUrlBasedView {
    private static final Pattern URI_TEMPLATE_VARIABLE_PATTERN = Pattern.compile("\\{([^/]+?)\\}");
    private boolean contextRelative = false;
    private boolean http10Compatible = true;
    private boolean exposeModelAttributes = true;
    @Nullable
    private String encodingScheme;
    @Nullable
    private HttpStatus statusCode;
    private boolean expandUriTemplateVariables = true;
    private boolean propagateQueryParams = false;
    @Nullable
    private String[] hosts;

    public RedirectView() { }

    public RedirectView(String url) { }

    public RedirectView(String url, boolean contextRelative) { }

    public RedirectView(String url, boolean contextRelative, boolean http10Compatible) { }

    public RedirectView(String url, boolean contextRelative, boolean http10Compatible, boolean exposeModelAttributes) { }

    public void setContextRelative(boolean contextRelative) { }

    public void setHttp10Compatible(boolean http10Compatible) { }

    public void setExposeModelAttributes(boolean exposeModelAttributes) { }

    public void setEncodingScheme(String encodingScheme) { }

    public void setStatusCode(HttpStatus statusCode) { }

    public void setExpandUriTemplateVariables(boolean expandUriTemplateVariables) { }

    public void setPropagateQueryParams(boolean propagateQueryParams) { }

    public boolean isPropagateQueryProperties() {
        return true;
    }

    public void setHosts(@Nullable String... hosts) { }

    @Nullable
    public String[] getHosts() {
        return this.hosts;
    }

    public boolean isRedirectView() {
        return true;
    }

    protected boolean isContextRequired() {
        return false;
    }

    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws IOException { }

    protected final String createTargetUrl(Map<String, Object> model, HttpServletRequest request) throws UnsupportedEncodingException {
        return "";
    }

    private String getContextPath(HttpServletRequest request) {
        return "";
    }

    protected StringBuilder replaceUriTemplateVariables(String targetUrl, Map<String, Object> model, Map<String, String> currentUriVariables, String encodingScheme) throws UnsupportedEncodingException {
        return null;
    }

    private Map<String, String> getCurrentRequestUriVariables(HttpServletRequest request) {
        return null;
    }

    protected void appendCurrentQueryParams(StringBuilder targetUrl, HttpServletRequest request) { }

    protected void appendQueryProperties(StringBuilder targetUrl, Map<String, Object> model, String encodingScheme) throws UnsupportedEncodingException { }

    protected Map<String, Object> queryProperties(Map<String, Object> model) {
        return null;
    }

    protected boolean isEligibleProperty(String key, @Nullable Object value) {
        return true;
    }

    protected boolean isEligibleValue(@Nullable Object value) {
        return true;
    }

    protected String urlEncode(String input, String encodingScheme) throws UnsupportedEncodingException {
        return "";
    }

    protected String updateTargetUrl(String targetUrl, Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) {
        return "";
    }

    protected void sendRedirect(HttpServletRequest request, HttpServletResponse response, String targetUrl, boolean http10Compatible) throws IOException { }

    protected boolean isRemoteHost(String targetUrl) {
        return true;
    }

    protected HttpStatus getHttp11StatusCode(HttpServletRequest request, HttpServletResponse response, String targetUrl) {
        return this.statusCode;
    }
}

