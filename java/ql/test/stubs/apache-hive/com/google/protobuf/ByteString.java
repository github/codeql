// Generated automatically from com.google.protobuf.ByteString for testing purposes

package com.google.protobuf;

import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.util.Iterator;
import java.util.List;

abstract public class ByteString implements Iterable<Byte>
{
    protected abstract boolean isBalanced();
    protected abstract int getTreeDepth();
    protected abstract int partialHash(int p0, int p1, int p2);
    protected abstract int partialIsValidUtf8(int p0, int p1, int p2);
    protected abstract int peekCachedHashCode();
    protected abstract void copyToInternal(byte[] p0, int p1, int p2, int p3);
    public ByteString concat(ByteString p0){ return null; }
    public ByteString substring(int p0){ return null; }
    public String toString(){ return null; }
    public String toStringUtf8(){ return null; }
    public abstract ByteBuffer asReadOnlyByteBuffer();
    public abstract ByteString substring(int p0, int p1);
    public abstract ByteString.ByteIterator iterator();
    public abstract CodedInputStream newCodedInput();
    public abstract InputStream newInput();
    public abstract List<ByteBuffer> asReadOnlyByteBufferList();
    public abstract String toString(String p0);
    public abstract boolean equals(Object p0);
    public abstract boolean isValidUtf8();
    public abstract byte byteAt(int p0);
    public abstract int hashCode();
    public abstract int size();
    public abstract void copyTo(ByteBuffer p0);
    public abstract void writeTo(OutputStream p0);
    public boolean isEmpty(){ return false; }
    public boolean startsWith(ByteString p0){ return false; }
    public byte[] toByteArray(){ return null; }
    public static ByteString EMPTY = null;
    public static ByteString copyFrom(ByteBuffer p0){ return null; }
    public static ByteString copyFrom(ByteBuffer p0, int p1){ return null; }
    public static ByteString copyFrom(Iterable<ByteString> p0){ return null; }
    public static ByteString copyFrom(String p0, String p1){ return null; }
    public static ByteString copyFrom(byte[] p0){ return null; }
    public static ByteString copyFrom(byte[] p0, int p1, int p2){ return null; }
    public static ByteString copyFromUtf8(String p0){ return null; }
    public static ByteString readFrom(InputStream p0){ return null; }
    public static ByteString readFrom(InputStream p0, int p1){ return null; }
    public static ByteString readFrom(InputStream p0, int p1, int p2){ return null; }
    public static ByteString.Output newOutput(){ return null; }
    public static ByteString.Output newOutput(int p0){ return null; }
    public void copyTo(byte[] p0, int p1){}
    public void copyTo(byte[] p0, int p1, int p2, int p3){}
    static public class Output extends OutputStream
    {
        protected Output() {}
        public ByteString toByteString(){ return null; }
        public String toString(){ return null; }
        public int size(){ return 0; }
        public void reset(){}
        public void write(byte[] p0, int p1, int p2){}
        public void write(int p0){}
        public void writeTo(OutputStream p0){}
    }
    static public interface ByteIterator extends Iterator<Byte>
    {
        byte nextByte();
    }
}
