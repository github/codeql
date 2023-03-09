// Generated automatically from org.apache.htrace.core.TracerPool for testing purposes

package org.apache.htrace.core;

import org.apache.htrace.core.HTraceConfiguration;
import org.apache.htrace.core.SpanReceiver;
import org.apache.htrace.core.Tracer;

public class TracerPool
{
    protected TracerPool() {}
    public SpanReceiver loadReceiverType(String p0, HTraceConfiguration p1, ClassLoader p2){ return null; }
    public SpanReceiver[] getReceivers(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public TracerPool(String p0){}
    public Tracer[] getTracers(){ return null; }
    public boolean addReceiver(SpanReceiver p0){ return false; }
    public boolean removeAndCloseReceiver(SpanReceiver p0){ return false; }
    public boolean removeReceiver(SpanReceiver p0){ return false; }
    public static TracerPool getGlobalTracerPool(){ return null; }
}
