// Generated automatically from org.apache.http.client.methods.AbstractExecutionAwareRequest for testing purposes

package org.apache.http.client.methods;

import org.apache.http.HttpRequest;
import org.apache.http.client.methods.AbortableHttpRequest;
import org.apache.http.client.methods.HttpExecutionAware;
import org.apache.http.concurrent.Cancellable;
import org.apache.http.conn.ClientConnectionRequest;
import org.apache.http.conn.ConnectionReleaseTrigger;
import org.apache.http.message.AbstractHttpMessage;

abstract public class AbstractExecutionAwareRequest extends AbstractHttpMessage implements AbortableHttpRequest, Cloneable, HttpExecutionAware, HttpRequest
{
    protected AbstractExecutionAwareRequest(){}
    public Object clone(){ return null; }
    public boolean isAborted(){ return false; }
    public void abort(){}
    public void completed(){}
    public void reset(){}
    public void setCancellable(Cancellable p0){}
    public void setConnectionRequest(ClientConnectionRequest p0){}
    public void setReleaseTrigger(ConnectionReleaseTrigger p0){}
}
