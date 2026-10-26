// Generated automatically from org.apache.http.message.BasicHttpEntityEnclosingRequest for testing purposes

package org.apache.http.message;

import org.apache.http.HttpEntity;
import org.apache.http.HttpEntityEnclosingRequest;
import org.apache.http.ProtocolVersion;
import org.apache.http.RequestLine;
import org.apache.http.message.BasicHttpRequest;

public class BasicHttpEntityEnclosingRequest extends BasicHttpRequest implements HttpEntityEnclosingRequest
{
    protected BasicHttpEntityEnclosingRequest() {}
    public BasicHttpEntityEnclosingRequest(RequestLine p0){}
    public BasicHttpEntityEnclosingRequest(String p0, String p1){}
    public BasicHttpEntityEnclosingRequest(String p0, String p1, ProtocolVersion p2){}
    public HttpEntity getEntity(){ return null; }
    public boolean expectContinue(){ return false; }
    public void setEntity(HttpEntity p0){}
}
