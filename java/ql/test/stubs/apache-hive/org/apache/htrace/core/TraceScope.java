// Generated automatically from org.apache.htrace.core.TraceScope for testing purposes

package org.apache.htrace.core;

import java.io.Closeable;
import org.apache.htrace.core.Span;
import org.apache.htrace.core.SpanId;

public class TraceScope implements Closeable
{
    protected TraceScope() {}
    public Span getSpan(){ return null; }
    public SpanId getSpanId(){ return null; }
    public String toString(){ return null; }
    public void addKVAnnotation(String p0, String p1){}
    public void addTimelineAnnotation(String p0){}
    public void close(){}
    public void detach(){}
    public void reattach(){}
}
