// Generated automatically from org.springframework.core.io.buffer.DataBuffer for testing purposes

package org.springframework.core.io.buffer;

import java.io.Closeable;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.util.Iterator;
import java.util.function.IntPredicate;
import org.springframework.core.io.buffer.DataBufferFactory;

public interface DataBuffer
{
    ByteBuffer asByteBuffer();
    ByteBuffer asByteBuffer(int p0, int p1);
    ByteBuffer toByteBuffer(int p0, int p1);
    DataBuffer capacity(int p0);
    DataBuffer ensureWritable(int p0);
    DataBuffer read(byte[] p0);
    DataBuffer read(byte[] p0, int p1, int p2);
    DataBuffer readPosition(int p0);
    DataBuffer slice(int p0, int p1);
    DataBuffer split(int p0);
    DataBuffer write(ByteBuffer... p0);
    DataBuffer write(DataBuffer... p0);
    DataBuffer write(byte p0);
    DataBuffer write(byte[] p0);
    DataBuffer write(byte[] p0, int p1, int p2);
    DataBuffer writePosition(int p0);
    DataBuffer.ByteBufferIterator readableByteBuffers();
    DataBuffer.ByteBufferIterator writableByteBuffers();
    DataBufferFactory factory();
    String toString(int p0, int p1, Charset p2);
    byte getByte(int p0);
    byte read();
    default ByteBuffer toByteBuffer(){ return null; }
    default DataBuffer ensureCapacity(int p0){ return null; }
    default DataBuffer retainedSlice(int p0, int p1){ return null; }
    default DataBuffer write(CharSequence p0, Charset p1){ return null; }
    default InputStream asInputStream(){ return null; }
    default InputStream asInputStream(boolean p0){ return null; }
    default OutputStream asOutputStream(){ return null; }
    default String toString(Charset p0){ return null; }
    default void toByteBuffer(ByteBuffer p0){}
    int capacity();
    int indexOf(IntPredicate p0, int p1);
    int lastIndexOf(IntPredicate p0, int p1);
    int readPosition();
    int readableByteCount();
    int writableByteCount();
    int writePosition();
    static public interface ByteBufferIterator extends Closeable, Iterator<ByteBuffer>
    {
        void close();
    }
    void toByteBuffer(int p0, ByteBuffer p1, int p2, int p3);
}
