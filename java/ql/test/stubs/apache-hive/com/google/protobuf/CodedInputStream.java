// Generated automatically from com.google.protobuf.CodedInputStream for testing purposes

package com.google.protobuf;

import com.google.protobuf.ByteString;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.MessageLite;
import com.google.protobuf.Parser;
import java.io.InputStream;

public class CodedInputStream
{
    protected CodedInputStream() {}
    public <T extends MessageLite> T readGroup(int p0, com.google.protobuf.Parser<T> p1, ExtensionRegistryLite p2){ return null; }
    public <T extends MessageLite> T readMessage(com.google.protobuf.Parser<T> p0, ExtensionRegistryLite p1){ return null; }
    public ByteString readBytes(){ return null; }
    public String readString(){ return null; }
    public boolean isAtEnd(){ return false; }
    public boolean readBool(){ return false; }
    public boolean skipField(int p0){ return false; }
    public byte readRawByte(){ return 0; }
    public byte[] readRawBytes(int p0){ return null; }
    public double readDouble(){ return 0; }
    public float readFloat(){ return 0; }
    public int getBytesUntilLimit(){ return 0; }
    public int getTotalBytesRead(){ return 0; }
    public int pushLimit(int p0){ return 0; }
    public int readEnum(){ return 0; }
    public int readFixed32(){ return 0; }
    public int readInt32(){ return 0; }
    public int readRawLittleEndian32(){ return 0; }
    public int readRawVarint32(){ return 0; }
    public int readSFixed32(){ return 0; }
    public int readSInt32(){ return 0; }
    public int readTag(){ return 0; }
    public int readUInt32(){ return 0; }
    public int setRecursionLimit(int p0){ return 0; }
    public int setSizeLimit(int p0){ return 0; }
    public long readFixed64(){ return 0; }
    public long readInt64(){ return 0; }
    public long readRawLittleEndian64(){ return 0; }
    public long readRawVarint64(){ return 0; }
    public long readSFixed64(){ return 0; }
    public long readSInt64(){ return 0; }
    public long readUInt64(){ return 0; }
    public static CodedInputStream newInstance(InputStream p0){ return null; }
    public static CodedInputStream newInstance(byte[] p0){ return null; }
    public static CodedInputStream newInstance(byte[] p0, int p1, int p2){ return null; }
    public static int decodeZigZag32(int p0){ return 0; }
    public static int readRawVarint32(int p0, InputStream p1){ return 0; }
    public static long decodeZigZag64(long p0){ return 0; }
    public void checkLastTagWas(int p0){}
    public void popLimit(int p0){}
    public void readGroup(int p0, MessageLite.Builder p1, ExtensionRegistryLite p2){}
    public void readMessage(MessageLite.Builder p0, ExtensionRegistryLite p1){}
    public void readUnknownGroup(int p0, MessageLite.Builder p1){}
    public void resetSizeCounter(){}
    public void skipMessage(){}
    public void skipRawBytes(int p0){}
}
