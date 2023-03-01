// Generated automatically from org.apache.thrift.transport.TTransport for testing purposes

package org.apache.thrift.transport;

import java.io.Closeable;

abstract public class TTransport implements Closeable
{
    public TTransport(){}
    public abstract boolean isOpen();
    public abstract int read(byte[] p0, int p1, int p2);
    public abstract void close();
    public abstract void open();
    public abstract void write(byte[] p0, int p1, int p2);
    public boolean peek(){ return false; }
    public byte[] getBuffer(){ return null; }
    public int getBufferPosition(){ return 0; }
    public int getBytesRemainingInBuffer(){ return 0; }
    public int readAll(byte[] p0, int p1, int p2){ return 0; }
    public void consumeBuffer(int p0){}
    public void flush(){}
    public void write(byte[] p0){}
}
