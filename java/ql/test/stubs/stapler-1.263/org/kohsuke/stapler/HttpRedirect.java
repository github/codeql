// Generated automatically from org.kohsuke.stapler.HttpRedirect for testing purposes

package org.kohsuke.stapler;

import org.kohsuke.stapler.HttpResponse;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

public class HttpRedirect extends RuntimeException implements HttpResponse
{
    protected HttpRedirect() {}
    public HttpRedirect(String p0){}
    public HttpRedirect(int p0, String p1){}
    public static HttpRedirect DOT = null;
    public static HttpResponse CONTEXT_ROOT = null;
    public static HttpResponse fromContextPath(String p0){ return null; }
    public void generateResponse(StaplerRequest p0, StaplerResponse p1, Object p2){}
}
