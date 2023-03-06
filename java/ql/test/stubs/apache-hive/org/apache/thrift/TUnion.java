// Generated automatically from org.apache.thrift.TUnion for testing purposes

package org.apache.thrift;

import org.apache.thrift.TBase;
import org.apache.thrift.TFieldIdEnum;
import org.apache.thrift.protocol.TField;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.protocol.TStruct;

abstract public class TUnion<T extends TUnion<? extends Object, ? extends Object>, F extends TFieldIdEnum> implements TBase<T, F>
{
    protected F setField_ = null;
    protected Object value_ = null;
    protected TUnion(){}
    protected TUnion(F p0, Object p1){}
    protected TUnion(TUnion<T, F> p0){}
    protected abstract F enumForId(short p0);
    protected abstract Object standardSchemeReadValue(TProtocol p0, TField p1);
    protected abstract Object tupleSchemeReadValue(TProtocol p0, short p1);
    protected abstract TField getFieldDesc(F p0);
    protected abstract TStruct getStructDesc();
    protected abstract void checkType(F p0, Object p1);
    protected abstract void standardSchemeWriteValue(TProtocol p0);
    protected abstract void tupleSchemeWriteValue(TProtocol p0);
    public F getSetField(){ return null; }
    public Object getFieldValue(){ return null; }
    public Object getFieldValue(F p0){ return null; }
    public Object getFieldValue(int p0){ return null; }
    public String toString(){ return null; }
    public boolean isSet(){ return false; }
    public boolean isSet(F p0){ return false; }
    public boolean isSet(int p0){ return false; }
    public final void clear(){}
    public void read(TProtocol p0){}
    public void setFieldValue(F p0, Object p1){}
    public void setFieldValue(int p0, Object p1){}
    public void write(TProtocol p0){}
}
