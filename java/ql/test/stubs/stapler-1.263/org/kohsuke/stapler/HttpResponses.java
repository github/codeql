// Generated automatically from org.kohsuke.stapler.HttpResponses for testing purposes

package org.kohsuke.stapler;

import java.net.URL;
import org.kohsuke.stapler.ForwardToView;
import org.kohsuke.stapler.HttpRedirect;
import org.kohsuke.stapler.HttpResponse;

public class HttpResponses
{
    abstract static public class HttpResponseException extends RuntimeException implements HttpResponse
    {
        public HttpResponseException(){}
        public HttpResponseException(String p0){}
        public HttpResponseException(String p0, Throwable p1){}
        public HttpResponseException(Throwable p0){}
    }
    public HttpResponses(){}
    public static ForwardToView forwardToView(Class p0, String p1){ return null; }
    public static ForwardToView forwardToView(Object p0, String p1){ return null; }
    public static HttpRedirect redirectTo(String p0){ return null; }
    public static HttpRedirect redirectTo(int p0, String p1){ return null; }
    public static HttpResponse html(String p0){ return null; }
    public static HttpResponse literalHtml(String p0){ return null; }
    public static HttpResponse plainText(String p0){ return null; }
    public static HttpResponse redirectToDot(){ return null; }
    public static HttpResponse staticResource(URL p0){ return null; }
    public static HttpResponse staticResource(URL p0, long p1){ return null; }
    public static HttpResponse text(String p0){ return null; }
    public static HttpResponses.HttpResponseException error(Throwable p0){ return null; }
    public static HttpResponses.HttpResponseException error(int p0, String p1){ return null; }
    public static HttpResponses.HttpResponseException error(int p0, Throwable p1){ return null; }
    public static HttpResponses.HttpResponseException errorWithoutStack(int p0, String p1){ return null; }
    public static HttpResponses.HttpResponseException forbidden(){ return null; }
    public static HttpResponses.HttpResponseException forwardToPreviousPage(){ return null; }
    public static HttpResponses.HttpResponseException notFound(){ return null; }
    public static HttpResponses.HttpResponseException ok(){ return null; }
    public static HttpResponses.HttpResponseException redirectToContextRoot(){ return null; }
    public static HttpResponses.HttpResponseException redirectViaContextPath(String p0){ return null; }
    public static HttpResponses.HttpResponseException redirectViaContextPath(int p0, String p1){ return null; }
    public static HttpResponses.HttpResponseException status(int p0){ return null; }
}
