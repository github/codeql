// Generated automatically from org.apache.hc.client5.http.classic.methods.HttpUriRequestBase for testing purposes

package org.apache.hc.client5.http.classic.methods;

import java.net.URI;
import org.apache.hc.client5.http.classic.methods.HttpUriRequest;
import org.apache.hc.client5.http.config.RequestConfig;
import org.apache.hc.core5.concurrent.Cancellable;
import org.apache.hc.core5.concurrent.CancellableDependency;
import org.apache.hc.core5.http.message.BasicClassicHttpRequest;

public class HttpUriRequestBase extends BasicClassicHttpRequest implements CancellableDependency, HttpUriRequest
{
    protected HttpUriRequestBase() {}
    public HttpUriRequestBase(String p0, URI p1){}
    public RequestConfig getConfig(){ return null; }
    public String toString(){ return null; }
    public boolean cancel(){ return false; }
    public boolean isAborted(){ return false; }
    public boolean isCancelled(){ return false; }
    public void abort(){}
    public void reset(){}
    public void setConfig(RequestConfig p0){}
    public void setDependency(Cancellable p0){}
}
