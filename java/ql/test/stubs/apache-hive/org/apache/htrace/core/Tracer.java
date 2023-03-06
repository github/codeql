// Generated automatically from org.apache.htrace.core.Tracer for testing purposes

package org.apache.htrace.core;

import java.io.Closeable;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import org.apache.htrace.core.Sampler;
import org.apache.htrace.core.Span;
import org.apache.htrace.core.SpanId;
import org.apache.htrace.core.TraceExecutorService;
import org.apache.htrace.core.TraceScope;
import org.apache.htrace.core.TracerPool;

public class Tracer implements Closeable
{
    protected Tracer() {}
    public <V> java.util.concurrent.Callable<V> wrap(java.util.concurrent.Callable<V> p0, String p1){ return null; }
    public Runnable wrap(Runnable p0, String p1){ return null; }
    public Sampler[] getSamplers(){ return null; }
    public String getTracerId(){ return null; }
    public String toString(){ return null; }
    public TraceExecutorService newTraceExecutorService(ExecutorService p0, String p1){ return null; }
    public TraceScope newNullScope(){ return null; }
    public TraceScope newScope(String p0){ return null; }
    public TraceScope newScope(String p0, SpanId p1){ return null; }
    public TracerPool getTracerPool(){ return null; }
    public boolean addSampler(Sampler p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean removeSampler(Sampler p0){ return false; }
    public int hashCode(){ return 0; }
    public static Span getCurrentSpan(){ return null; }
    public static SpanId getCurrentSpanId(){ return null; }
    public static String SAMPLER_CLASSES_KEY = null;
    public static String SPAN_RECEIVER_CLASSES_KEY = null;
    public static Tracer curThreadTracer(){ return null; }
    public void close(){}
}
