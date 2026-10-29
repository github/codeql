// Generated automatically from
// org.apache.htrace.shaded.fasterxml.jackson.databind.util.PrimitiveArrayBuilder for testing
// purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.util;


abstract public class PrimitiveArrayBuilder<T> {
    class Node<T> {
    }

    protected PrimitiveArrayBuilder() {}

    protected PrimitiveArrayBuilder.Node _bufferHead = null;
    protected PrimitiveArrayBuilder.Node _bufferTail = null;
    protected T _freeBuffer = null;

    protected abstract T _constructArray(int p0);

    protected int _bufferedEntryCount = 0;

    protected void _reset() {}

    public T completeAndClearBuffer(T p0, int p1) {
        return null;
    }

    public T resetAndStart() {
        return null;
    }

    public final T appendCompletedChunk(T p0, int p1) {
        return null;
    }
}
