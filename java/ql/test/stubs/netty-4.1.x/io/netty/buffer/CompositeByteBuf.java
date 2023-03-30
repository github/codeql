// Generated automatically from io.netty.buffer.CompositeByteBuf for testing purposes

package io.netty.buffer;

import io.netty.buffer.AbstractReferenceCountedByteBuf;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufAllocator;
import io.netty.util.ByteProcessor;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.channels.FileChannel;
import java.nio.channels.GatheringByteChannel;
import java.nio.channels.ScatteringByteChannel;
import java.util.Iterator;
import java.util.List;

public class CompositeByteBuf extends AbstractReferenceCountedByteBuf implements Iterable<ByteBuf>
{
    protected CompositeByteBuf() {}
    protected byte _getByte(int p0){ return 0; }
    protected int _getInt(int p0){ return 0; }
    protected int _getIntLE(int p0){ return 0; }
    protected int _getUnsignedMedium(int p0){ return 0; }
    protected int _getUnsignedMediumLE(int p0){ return 0; }
    protected int forEachByteAsc0(int p0, int p1, ByteProcessor p2){ return 0; }
    protected int forEachByteDesc0(int p0, int p1, ByteProcessor p2){ return 0; }
    protected long _getLong(int p0){ return 0; }
    protected long _getLongLE(int p0){ return 0; }
    protected short _getShort(int p0){ return 0; }
    protected short _getShortLE(int p0){ return 0; }
    protected void _setByte(int p0, int p1){}
    protected void _setInt(int p0, int p1){}
    protected void _setIntLE(int p0, int p1){}
    protected void _setLong(int p0, long p1){}
    protected void _setLongLE(int p0, long p1){}
    protected void _setMedium(int p0, int p1){}
    protected void _setMediumLE(int p0, int p1){}
    protected void _setShort(int p0, int p1){}
    protected void _setShortLE(int p0, int p1){}
    protected void deallocate(){}
    public ByteBuf component(int p0){ return null; }
    public ByteBuf componentAtOffset(int p0){ return null; }
    public ByteBuf copy(int p0, int p1){ return null; }
    public ByteBuf internalComponent(int p0){ return null; }
    public ByteBuf internalComponentAtOffset(int p0){ return null; }
    public ByteBuf unwrap(){ return null; }
    public ByteBufAllocator alloc(){ return null; }
    public ByteBuffer internalNioBuffer(int p0, int p1){ return null; }
    public ByteBuffer nioBuffer(int p0, int p1){ return null; }
    public ByteBuffer[] nioBuffers(){ return null; }
    public ByteBuffer[] nioBuffers(int p0, int p1){ return null; }
    public ByteOrder order(){ return null; }
    public CompositeByteBuf addComponent(ByteBuf p0){ return null; }
    public CompositeByteBuf addComponent(boolean p0, ByteBuf p1){ return null; }
    public CompositeByteBuf addComponent(boolean p0, int p1, ByteBuf p2){ return null; }
    public CompositeByteBuf addComponent(int p0, ByteBuf p1){ return null; }
    public CompositeByteBuf addComponents(ByteBuf... p0){ return null; }
    public CompositeByteBuf addComponents(Iterable<ByteBuf> p0){ return null; }
    public CompositeByteBuf addComponents(boolean p0, ByteBuf... p1){ return null; }
    public CompositeByteBuf addComponents(boolean p0, Iterable<ByteBuf> p1){ return null; }
    public CompositeByteBuf addComponents(int p0, ByteBuf... p1){ return null; }
    public CompositeByteBuf addComponents(int p0, Iterable<ByteBuf> p1){ return null; }
    public CompositeByteBuf addFlattenedComponents(boolean p0, ByteBuf p1){ return null; }
    public CompositeByteBuf capacity(int p0){ return null; }
    public CompositeByteBuf clear(){ return null; }
    public CompositeByteBuf consolidate(){ return null; }
    public CompositeByteBuf consolidate(int p0, int p1){ return null; }
    public CompositeByteBuf discardReadBytes(){ return null; }
    public CompositeByteBuf discardReadComponents(){ return null; }
    public CompositeByteBuf discardSomeReadBytes(){ return null; }
    public CompositeByteBuf ensureWritable(int p0){ return null; }
    public CompositeByteBuf getBytes(int p0, ByteBuf p1){ return null; }
    public CompositeByteBuf getBytes(int p0, ByteBuf p1, int p2){ return null; }
    public CompositeByteBuf getBytes(int p0, ByteBuf p1, int p2, int p3){ return null; }
    public CompositeByteBuf getBytes(int p0, ByteBuffer p1){ return null; }
    public CompositeByteBuf getBytes(int p0, OutputStream p1, int p2){ return null; }
    public CompositeByteBuf getBytes(int p0, byte[] p1){ return null; }
    public CompositeByteBuf getBytes(int p0, byte[] p1, int p2, int p3){ return null; }
    public CompositeByteBuf markReaderIndex(){ return null; }
    public CompositeByteBuf markWriterIndex(){ return null; }
    public CompositeByteBuf readBytes(ByteBuf p0){ return null; }
    public CompositeByteBuf readBytes(ByteBuf p0, int p1){ return null; }
    public CompositeByteBuf readBytes(ByteBuf p0, int p1, int p2){ return null; }
    public CompositeByteBuf readBytes(ByteBuffer p0){ return null; }
    public CompositeByteBuf readBytes(OutputStream p0, int p1){ return null; }
    public CompositeByteBuf readBytes(byte[] p0){ return null; }
    public CompositeByteBuf readBytes(byte[] p0, int p1, int p2){ return null; }
    public CompositeByteBuf readerIndex(int p0){ return null; }
    public CompositeByteBuf removeComponent(int p0){ return null; }
    public CompositeByteBuf removeComponents(int p0, int p1){ return null; }
    public CompositeByteBuf resetReaderIndex(){ return null; }
    public CompositeByteBuf resetWriterIndex(){ return null; }
    public CompositeByteBuf retain(){ return null; }
    public CompositeByteBuf retain(int p0){ return null; }
    public CompositeByteBuf setBoolean(int p0, boolean p1){ return null; }
    public CompositeByteBuf setByte(int p0, int p1){ return null; }
    public CompositeByteBuf setBytes(int p0, ByteBuf p1){ return null; }
    public CompositeByteBuf setBytes(int p0, ByteBuf p1, int p2){ return null; }
    public CompositeByteBuf setBytes(int p0, ByteBuf p1, int p2, int p3){ return null; }
    public CompositeByteBuf setBytes(int p0, ByteBuffer p1){ return null; }
    public CompositeByteBuf setBytes(int p0, byte[] p1){ return null; }
    public CompositeByteBuf setBytes(int p0, byte[] p1, int p2, int p3){ return null; }
    public CompositeByteBuf setChar(int p0, int p1){ return null; }
    public CompositeByteBuf setDouble(int p0, double p1){ return null; }
    public CompositeByteBuf setFloat(int p0, float p1){ return null; }
    public CompositeByteBuf setIndex(int p0, int p1){ return null; }
    public CompositeByteBuf setInt(int p0, int p1){ return null; }
    public CompositeByteBuf setLong(int p0, long p1){ return null; }
    public CompositeByteBuf setMedium(int p0, int p1){ return null; }
    public CompositeByteBuf setShort(int p0, int p1){ return null; }
    public CompositeByteBuf setZero(int p0, int p1){ return null; }
    public CompositeByteBuf skipBytes(int p0){ return null; }
    public CompositeByteBuf touch(){ return null; }
    public CompositeByteBuf touch(Object p0){ return null; }
    public CompositeByteBuf writeBoolean(boolean p0){ return null; }
    public CompositeByteBuf writeByte(int p0){ return null; }
    public CompositeByteBuf writeBytes(ByteBuf p0){ return null; }
    public CompositeByteBuf writeBytes(ByteBuf p0, int p1){ return null; }
    public CompositeByteBuf writeBytes(ByteBuf p0, int p1, int p2){ return null; }
    public CompositeByteBuf writeBytes(ByteBuffer p0){ return null; }
    public CompositeByteBuf writeBytes(byte[] p0){ return null; }
    public CompositeByteBuf writeBytes(byte[] p0, int p1, int p2){ return null; }
    public CompositeByteBuf writeChar(int p0){ return null; }
    public CompositeByteBuf writeDouble(double p0){ return null; }
    public CompositeByteBuf writeFloat(float p0){ return null; }
    public CompositeByteBuf writeInt(int p0){ return null; }
    public CompositeByteBuf writeLong(long p0){ return null; }
    public CompositeByteBuf writeMedium(int p0){ return null; }
    public CompositeByteBuf writeShort(int p0){ return null; }
    public CompositeByteBuf writeZero(int p0){ return null; }
    public CompositeByteBuf writerIndex(int p0){ return null; }
    public CompositeByteBuf(ByteBufAllocator p0, boolean p1, int p2){}
    public CompositeByteBuf(ByteBufAllocator p0, boolean p1, int p2, ByteBuf... p3){}
    public CompositeByteBuf(ByteBufAllocator p0, boolean p1, int p2, Iterable<ByteBuf> p3){}
    public Iterator<ByteBuf> iterator(){ return null; }
    public List<ByteBuf> decompose(int p0, int p1){ return null; }
    public String toString(){ return null; }
    public boolean hasArray(){ return false; }
    public boolean hasMemoryAddress(){ return false; }
    public boolean isDirect(){ return false; }
    public byte getByte(int p0){ return 0; }
    public byte[] array(){ return null; }
    public int arrayOffset(){ return 0; }
    public int capacity(){ return 0; }
    public int getBytes(int p0, FileChannel p1, long p2, int p3){ return 0; }
    public int getBytes(int p0, GatheringByteChannel p1, int p2){ return 0; }
    public int maxNumComponents(){ return 0; }
    public int nioBufferCount(){ return 0; }
    public int numComponents(){ return 0; }
    public int setBytes(int p0, FileChannel p1, long p2, int p3){ return 0; }
    public int setBytes(int p0, InputStream p1, int p2){ return 0; }
    public int setBytes(int p0, ScatteringByteChannel p1, int p2){ return 0; }
    public int toByteIndex(int p0){ return 0; }
    public int toComponentIndex(int p0){ return 0; }
    public long memoryAddress(){ return 0; }
}
