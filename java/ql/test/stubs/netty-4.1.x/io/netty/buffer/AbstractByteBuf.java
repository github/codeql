// Generated automatically from io.netty.buffer.AbstractByteBuf for testing purposes

package io.netty.buffer;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.SwappedByteBuf;
import io.netty.util.ByteProcessor;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.channels.FileChannel;
import java.nio.channels.GatheringByteChannel;
import java.nio.channels.ScatteringByteChannel;
import java.nio.charset.Charset;

abstract public class AbstractByteBuf extends ByteBuf
{
    protected AbstractByteBuf() {}
    protected AbstractByteBuf(int p0){}
    protected SwappedByteBuf newSwappedByteBuf(){ return null; }
    protected abstract byte _getByte(int p0);
    protected abstract int _getInt(int p0);
    protected abstract int _getIntLE(int p0);
    protected abstract int _getUnsignedMedium(int p0);
    protected abstract int _getUnsignedMediumLE(int p0);
    protected abstract long _getLong(int p0);
    protected abstract long _getLongLE(int p0);
    protected abstract short _getShort(int p0);
    protected abstract short _getShortLE(int p0);
    protected abstract void _setByte(int p0, int p1);
    protected abstract void _setInt(int p0, int p1);
    protected abstract void _setIntLE(int p0, int p1);
    protected abstract void _setLong(int p0, long p1);
    protected abstract void _setLongLE(int p0, long p1);
    protected abstract void _setMedium(int p0, int p1);
    protected abstract void _setMediumLE(int p0, int p1);
    protected abstract void _setShort(int p0, int p1);
    protected abstract void _setShortLE(int p0, int p1);
    protected final void adjustMarkers(int p0){}
    protected final void checkDstIndex(int p0, int p1, int p2){}
    protected final void checkDstIndex(int p0, int p1, int p2, int p3){}
    protected final void checkIndex(int p0){}
    protected final void checkIndex(int p0, int p1){}
    protected final void checkNewCapacity(int p0){}
    protected final void checkReadableBytes(int p0){}
    protected final void checkSrcIndex(int p0, int p1, int p2, int p3){}
    protected final void ensureAccessible(){}
    protected final void maxCapacity(int p0){}
    protected final void trimIndicesToCapacity(int p0){}
    public ByteBuf asReadOnly(){ return null; }
    public ByteBuf clear(){ return null; }
    public ByteBuf copy(){ return null; }
    public ByteBuf discardReadBytes(){ return null; }
    public ByteBuf discardSomeReadBytes(){ return null; }
    public ByteBuf duplicate(){ return null; }
    public ByteBuf ensureWritable(int p0){ return null; }
    public ByteBuf getBytes(int p0, ByteBuf p1){ return null; }
    public ByteBuf getBytes(int p0, ByteBuf p1, int p2){ return null; }
    public ByteBuf getBytes(int p0, byte[] p1){ return null; }
    public ByteBuf markReaderIndex(){ return null; }
    public ByteBuf markWriterIndex(){ return null; }
    public ByteBuf order(ByteOrder p0){ return null; }
    public ByteBuf readBytes(ByteBuf p0){ return null; }
    public ByteBuf readBytes(ByteBuf p0, int p1){ return null; }
    public ByteBuf readBytes(ByteBuf p0, int p1, int p2){ return null; }
    public ByteBuf readBytes(ByteBuffer p0){ return null; }
    public ByteBuf readBytes(OutputStream p0, int p1){ return null; }
    public ByteBuf readBytes(byte[] p0){ return null; }
    public ByteBuf readBytes(byte[] p0, int p1, int p2){ return null; }
    public ByteBuf readBytes(int p0){ return null; }
    public ByteBuf readRetainedSlice(int p0){ return null; }
    public ByteBuf readSlice(int p0){ return null; }
    public ByteBuf readerIndex(int p0){ return null; }
    public ByteBuf resetReaderIndex(){ return null; }
    public ByteBuf resetWriterIndex(){ return null; }
    public ByteBuf retainedDuplicate(){ return null; }
    public ByteBuf retainedSlice(){ return null; }
    public ByteBuf retainedSlice(int p0, int p1){ return null; }
    public ByteBuf setBoolean(int p0, boolean p1){ return null; }
    public ByteBuf setByte(int p0, int p1){ return null; }
    public ByteBuf setBytes(int p0, ByteBuf p1){ return null; }
    public ByteBuf setBytes(int p0, ByteBuf p1, int p2){ return null; }
    public ByteBuf setBytes(int p0, byte[] p1){ return null; }
    public ByteBuf setChar(int p0, int p1){ return null; }
    public ByteBuf setDouble(int p0, double p1){ return null; }
    public ByteBuf setFloat(int p0, float p1){ return null; }
    public ByteBuf setIndex(int p0, int p1){ return null; }
    public ByteBuf setInt(int p0, int p1){ return null; }
    public ByteBuf setIntLE(int p0, int p1){ return null; }
    public ByteBuf setLong(int p0, long p1){ return null; }
    public ByteBuf setLongLE(int p0, long p1){ return null; }
    public ByteBuf setMedium(int p0, int p1){ return null; }
    public ByteBuf setMediumLE(int p0, int p1){ return null; }
    public ByteBuf setShort(int p0, int p1){ return null; }
    public ByteBuf setShortLE(int p0, int p1){ return null; }
    public ByteBuf setZero(int p0, int p1){ return null; }
    public ByteBuf skipBytes(int p0){ return null; }
    public ByteBuf slice(){ return null; }
    public ByteBuf slice(int p0, int p1){ return null; }
    public ByteBuf writeBoolean(boolean p0){ return null; }
    public ByteBuf writeByte(int p0){ return null; }
    public ByteBuf writeBytes(ByteBuf p0){ return null; }
    public ByteBuf writeBytes(ByteBuf p0, int p1){ return null; }
    public ByteBuf writeBytes(ByteBuf p0, int p1, int p2){ return null; }
    public ByteBuf writeBytes(ByteBuffer p0){ return null; }
    public ByteBuf writeBytes(byte[] p0){ return null; }
    public ByteBuf writeBytes(byte[] p0, int p1, int p2){ return null; }
    public ByteBuf writeChar(int p0){ return null; }
    public ByteBuf writeDouble(double p0){ return null; }
    public ByteBuf writeFloat(float p0){ return null; }
    public ByteBuf writeInt(int p0){ return null; }
    public ByteBuf writeIntLE(int p0){ return null; }
    public ByteBuf writeLong(long p0){ return null; }
    public ByteBuf writeLongLE(long p0){ return null; }
    public ByteBuf writeMedium(int p0){ return null; }
    public ByteBuf writeMediumLE(int p0){ return null; }
    public ByteBuf writeShort(int p0){ return null; }
    public ByteBuf writeShortLE(int p0){ return null; }
    public ByteBuf writeZero(int p0){ return null; }
    public ByteBuf writerIndex(int p0){ return null; }
    public ByteBuffer nioBuffer(){ return null; }
    public ByteBuffer[] nioBuffers(){ return null; }
    public CharSequence getCharSequence(int p0, int p1, Charset p2){ return null; }
    public CharSequence readCharSequence(int p0, Charset p1){ return null; }
    public String toString(){ return null; }
    public String toString(Charset p0){ return null; }
    public String toString(int p0, int p1, Charset p2){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean getBoolean(int p0){ return false; }
    public boolean isReadOnly(){ return false; }
    public boolean isReadable(){ return false; }
    public boolean isReadable(int p0){ return false; }
    public boolean isWritable(){ return false; }
    public boolean isWritable(int p0){ return false; }
    public boolean readBoolean(){ return false; }
    public byte getByte(int p0){ return 0; }
    public byte readByte(){ return 0; }
    public char getChar(int p0){ return '0'; }
    public char readChar(){ return '0'; }
    public double getDouble(int p0){ return 0; }
    public double readDouble(){ return 0; }
    public float getFloat(int p0){ return 0; }
    public float readFloat(){ return 0; }
    public int bytesBefore(byte p0){ return 0; }
    public int bytesBefore(int p0, byte p1){ return 0; }
    public int bytesBefore(int p0, int p1, byte p2){ return 0; }
    public int compareTo(ByteBuf p0){ return 0; }
    public int ensureWritable(int p0, boolean p1){ return 0; }
    public int forEachByte(ByteProcessor p0){ return 0; }
    public int forEachByte(int p0, int p1, ByteProcessor p2){ return 0; }
    public int forEachByteDesc(ByteProcessor p0){ return 0; }
    public int forEachByteDesc(int p0, int p1, ByteProcessor p2){ return 0; }
    public int getInt(int p0){ return 0; }
    public int getIntLE(int p0){ return 0; }
    public int getMedium(int p0){ return 0; }
    public int getMediumLE(int p0){ return 0; }
    public int getUnsignedMedium(int p0){ return 0; }
    public int getUnsignedMediumLE(int p0){ return 0; }
    public int getUnsignedShort(int p0){ return 0; }
    public int getUnsignedShortLE(int p0){ return 0; }
    public int hashCode(){ return 0; }
    public int indexOf(int p0, int p1, byte p2){ return 0; }
    public int maxCapacity(){ return 0; }
    public int maxWritableBytes(){ return 0; }
    public int readBytes(FileChannel p0, long p1, int p2){ return 0; }
    public int readBytes(GatheringByteChannel p0, int p1){ return 0; }
    public int readInt(){ return 0; }
    public int readIntLE(){ return 0; }
    public int readMedium(){ return 0; }
    public int readMediumLE(){ return 0; }
    public int readUnsignedMedium(){ return 0; }
    public int readUnsignedMediumLE(){ return 0; }
    public int readUnsignedShort(){ return 0; }
    public int readUnsignedShortLE(){ return 0; }
    public int readableBytes(){ return 0; }
    public int readerIndex(){ return 0; }
    public int setCharSequence(int p0, CharSequence p1, Charset p2){ return 0; }
    public int writableBytes(){ return 0; }
    public int writeBytes(FileChannel p0, long p1, int p2){ return 0; }
    public int writeBytes(InputStream p0, int p1){ return 0; }
    public int writeBytes(ScatteringByteChannel p0, int p1){ return 0; }
    public int writeCharSequence(CharSequence p0, Charset p1){ return 0; }
    public int writerIndex(){ return 0; }
    public long getLong(int p0){ return 0; }
    public long getLongLE(int p0){ return 0; }
    public long getUnsignedInt(int p0){ return 0; }
    public long getUnsignedIntLE(int p0){ return 0; }
    public long readLong(){ return 0; }
    public long readLongLE(){ return 0; }
    public long readUnsignedInt(){ return 0; }
    public long readUnsignedIntLE(){ return 0; }
    public short getShort(int p0){ return 0; }
    public short getShortLE(int p0){ return 0; }
    public short getUnsignedByte(int p0){ return 0; }
    public short readShort(){ return 0; }
    public short readShortLE(){ return 0; }
    public short readUnsignedByte(){ return 0; }
}
