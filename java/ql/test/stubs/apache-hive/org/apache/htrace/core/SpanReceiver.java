// Generated automatically from org.apache.htrace.core.SpanReceiver for testing purposes

package org.apache.htrace.core;

import java.io.Closeable;
import org.apache.htrace.core.Span;

abstract public class SpanReceiver implements Closeable
{
    protected SpanReceiver(){}
    public abstract void receiveSpan(Span p0);
    public final long getId(){ return 0; }
}
