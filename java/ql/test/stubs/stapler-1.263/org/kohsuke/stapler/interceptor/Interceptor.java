// Generated automatically from org.kohsuke.stapler.interceptor.Interceptor for testing purposes

package org.kohsuke.stapler.interceptor;

import org.kohsuke.stapler.Function;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

abstract public class Interceptor
{
    protected Function target = null;
    public Interceptor(){}
    public abstract Object invoke(StaplerRequest p0, StaplerResponse p1, Object p2, Object[] p3);
    public void setTarget(Function p0){}
}
