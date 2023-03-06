// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.util.BufferRecycler for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core.util;


public class BufferRecycler
{
    protected BufferRecycler(int p0, int p1){}
    protected byte[] balloc(int p0){ return null; }
    protected char[] calloc(int p0){ return null; }
    protected final byte[][] _byteBuffers = null;
    protected final char[][] _charBuffers = null;
    protected int byteBufferLength(int p0){ return 0; }
    protected int charBufferLength(int p0){ return 0; }
    public BufferRecycler(){}
    public byte[] allocByteBuffer(int p0, int p1){ return null; }
    public char[] allocCharBuffer(int p0, int p1){ return null; }
    public final byte[] allocByteBuffer(int p0){ return null; }
    public final char[] allocCharBuffer(int p0){ return null; }
    public final void releaseByteBuffer(int p0, byte[] p1){}
    public static int BYTE_BASE64_CODEC_BUFFER = 0;
    public static int BYTE_READ_IO_BUFFER = 0;
    public static int BYTE_WRITE_CONCAT_BUFFER = 0;
    public static int BYTE_WRITE_ENCODING_BUFFER = 0;
    public static int CHAR_CONCAT_BUFFER = 0;
    public static int CHAR_NAME_COPY_BUFFER = 0;
    public static int CHAR_TEXT_BUFFER = 0;
    public static int CHAR_TOKEN_BUFFER = 0;
    public void releaseCharBuffer(int p0, char[] p1){}
}
