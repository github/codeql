// Generated automatically from org.apache.thrift.protocol.TProtocol for testing purposes

package org.apache.thrift.protocol;

import java.nio.ByteBuffer;
import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.protocol.TField;
import org.apache.thrift.protocol.TList;
import org.apache.thrift.protocol.TMap;
import org.apache.thrift.protocol.TMessage;
import org.apache.thrift.protocol.TSet;
import org.apache.thrift.protocol.TStruct;
import org.apache.thrift.scheme.IScheme;
import org.apache.thrift.transport.TTransport;

abstract public class TProtocol
{
    protected TProtocol() {}
    protected TProtocol(TTransport p0){}
    protected TTransport trans_ = null;
    public Class<? extends IScheme> getScheme(){ return null; }
    public TTransport getTransport(){ return null; }
    public abstract ByteBuffer readBinary();
    public abstract String readString();
    public abstract TField readFieldBegin();
    public abstract TList readListBegin();
    public abstract TMap readMapBegin();
    public abstract TMessage readMessageBegin();
    public abstract TSet readSetBegin();
    public abstract TStruct readStructBegin();
    public abstract boolean readBool();
    public abstract byte readByte();
    public abstract double readDouble();
    public abstract int readI32();
    public abstract long readI64();
    public abstract short readI16();
    public abstract void readFieldEnd();
    public abstract void readListEnd();
    public abstract void readMapEnd();
    public abstract void readMessageEnd();
    public abstract void readSetEnd();
    public abstract void readStructEnd();
    public abstract void writeBinary(ByteBuffer p0);
    public abstract void writeBool(boolean p0);
    public abstract void writeByte(byte p0);
    public abstract void writeDouble(double p0);
    public abstract void writeFieldBegin(TField p0);
    public abstract void writeFieldEnd();
    public abstract void writeFieldStop();
    public abstract void writeI16(short p0);
    public abstract void writeI32(int p0);
    public abstract void writeI64(long p0);
    public abstract void writeListBegin(TList p0);
    public abstract void writeListEnd();
    public abstract void writeMapBegin(TMap p0);
    public abstract void writeMapEnd();
    public abstract void writeMessageBegin(TMessage p0);
    public abstract void writeMessageEnd();
    public abstract void writeSetBegin(TSet p0);
    public abstract void writeSetEnd();
    public abstract void writeString(String p0);
    public abstract void writeStructBegin(TStruct p0);
    public abstract void writeStructEnd();
    public void reset(){}
}
