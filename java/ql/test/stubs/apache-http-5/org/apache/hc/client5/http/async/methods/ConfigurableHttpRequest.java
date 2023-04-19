// Generated automatically from org.apache.hc.client5.http.async.methods.ConfigurableHttpRequest for testing purposes

package org.apache.hc.client5.http.async.methods;

import java.net.URI;
import org.apache.hc.client5.http.config.Configurable;
import org.apache.hc.client5.http.config.RequestConfig;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.message.BasicHttpRequest;
import org.apache.hc.core5.net.URIAuthority;

public class ConfigurableHttpRequest extends BasicHttpRequest implements Configurable
{
    protected ConfigurableHttpRequest() {}
    public ConfigurableHttpRequest(String p0, HttpHost p1, String p2){}
    public ConfigurableHttpRequest(String p0, String p1){}
    public ConfigurableHttpRequest(String p0, String p1, URIAuthority p2, String p3){}
    public ConfigurableHttpRequest(String p0, URI p1){}
    public RequestConfig getConfig(){ return null; }
    public void setConfig(RequestConfig p0){}
}
