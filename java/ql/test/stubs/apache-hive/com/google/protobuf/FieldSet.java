// Generated automatically from com.google.protobuf.FieldSet for testing purposes

package com.google.protobuf;

import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import com.google.protobuf.Internal;
import com.google.protobuf.MessageLite;
import com.google.protobuf.WireFormat;
import java.util.Iterator;
import java.util.Map;

class FieldSet<FieldDescriptorType extends FieldSet.FieldDescriptorLite<FieldDescriptorType>>
{
    protected FieldSet() {}
    public FieldSet<FieldDescriptorType> clone(){ return null; }
    public Iterator<Map.Entry<FieldDescriptorType, Object>> iterator(){ return null; }
    public Map<FieldDescriptorType, Object> getAllFields(){ return null; }
    public Object getField(FieldDescriptorType p0){ return null; }
    public Object getRepeatedField(FieldDescriptorType p0, int p1){ return null; }
    public boolean hasField(FieldDescriptorType p0){ return false; }
    public boolean isImmutable(){ return false; }
    public boolean isInitialized(){ return false; }
    public int getMessageSetSerializedSize(){ return 0; }
    public int getRepeatedFieldCount(FieldDescriptorType p0){ return 0; }
    public int getSerializedSize(){ return 0; }
    public static <T extends FieldSet.FieldDescriptorLite<T>> com.google.protobuf.FieldSet<T> emptySet(){ return null; }
    public static <T extends FieldSet.FieldDescriptorLite<T>> com.google.protobuf.FieldSet<T> newFieldSet(){ return null; }
    public static Object readPrimitiveField(CodedInputStream p0, WireFormat.FieldType p1){ return null; }
    public static int computeFieldSize(FieldSet.FieldDescriptorLite<? extends Object> p0, Object p1){ return 0; }
    public static void writeField(FieldSet.FieldDescriptorLite<? extends Object> p0, Object p1, CodedOutputStream p2){}
    public void addRepeatedField(FieldDescriptorType p0, Object p1){}
    public void clear(){}
    public void clearField(FieldDescriptorType p0){}
    public void makeImmutable(){}
    public void mergeFrom(FieldSet<FieldDescriptorType> p0){}
    public void setField(FieldDescriptorType p0, Object p1){}
    public void setRepeatedField(FieldDescriptorType p0, int p1, Object p2){}
    public void writeMessageSetTo(CodedOutputStream p0){}
    public void writeTo(CodedOutputStream p0){}
    static public interface FieldDescriptorLite<T extends FieldSet.FieldDescriptorLite<T>> extends java.lang.Comparable<T>
    {
        Internal.EnumLiteMap<? extends Object> getEnumType();
        MessageLite.Builder internalMergeFrom(MessageLite.Builder p0, MessageLite p1);
        WireFormat.FieldType getLiteType();
        WireFormat.JavaType getLiteJavaType();
        boolean isPacked();
        boolean isRepeated();
        int getNumber();
    }
}
