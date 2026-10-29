// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.io.IOContext for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core.io;

import org.apache.htrace.shaded.fasterxml.jackson.core.JsonEncoding;
import org.apache.htrace.shaded.fasterxml.jackson.core.util.BufferRecycler;
import org.apache.htrace.shaded.fasterxml.jackson.core.util.TextBuffer;

public class IOContext
{
    protected IOContext() {}
    protected JsonEncoding _encoding = null;
    protected byte[] _base64Buffer = null;
    protected byte[] _readIOBuffer = null;
    protected byte[] _writeEncodingBuffer = null;
    protected char[] _concatCBuffer = null;
    protected char[] _nameCopyBuffer = null;
    protected char[] _tokenCBuffer = null;
    protected final BufferRecycler _bufferRecycler = null;
    protected final Object _sourceRef = null;
    protected final boolean _managedResource = false;
    protected void _verifyAlloc(Object p0){}
    protected void _verifyRelease(byte[] p0, byte[] p1){}
    protected void _verifyRelease(char[] p0, char[] p1){}
    public IOContext(BufferRecycler p0, Object p1, boolean p2){}
    public JsonEncoding getEncoding(){ return null; }
    public Object getSourceReference(){ return null; }
    public TextBuffer constructTextBuffer(){ return null; }
    public boolean isResourceManaged(){ return false; }
    public byte[] allocBase64Buffer(){ return null; }
    public byte[] allocReadIOBuffer(){ return null; }
    public byte[] allocReadIOBuffer(int p0){ return null; }
    public byte[] allocWriteEncodingBuffer(){ return null; }
    public byte[] allocWriteEncodingBuffer(int p0){ return null; }
    public char[] allocConcatBuffer(){ return null; }
    public char[] allocNameCopyBuffer(int p0){ return null; }
    public char[] allocTokenBuffer(){ return null; }
    public char[] allocTokenBuffer(int p0){ return null; }
    public void releaseBase64Buffer(byte[] p0){}
    public void releaseConcatBuffer(char[] p0){}
    public void releaseNameCopyBuffer(char[] p0){}
    public void releaseReadIOBuffer(byte[] p0){}
    public void releaseTokenBuffer(char[] p0){}
    public void releaseWriteEncodingBuffer(byte[] p0){}
    public void setEncoding(JsonEncoding p0){}
}
