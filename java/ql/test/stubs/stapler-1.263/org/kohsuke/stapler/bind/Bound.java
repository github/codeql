// Generated automatically from org.kohsuke.stapler.bind.Bound for testing purposes

package org.kohsuke.stapler.bind;

import org.kohsuke.stapler.HttpResponse;

abstract public class Bound implements HttpResponse
{
    public Bound(){}
    public abstract Object getTarget();
    public abstract String getURL();
    public abstract void release();
    public final String getProxyScript(){ return null; }
}
