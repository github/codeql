// Generated automatically from com.google.protobuf.UnknownFieldSet for testing purposes

package com.google.protobuf;

import com.google.protobuf.AbstractParser;
import com.google.protobuf.ByteString;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.MessageLite;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

public class UnknownFieldSet implements MessageLite
{
    protected UnknownFieldSet() {}
    public ByteString toByteString(){ return null; }
    public Map<Integer, UnknownFieldSet.Field> asMap(){ return null; }
    public String toString(){ return null; }
    public UnknownFieldSet getDefaultInstanceForType(){ return null; }
    public UnknownFieldSet.Builder newBuilderForType(){ return null; }
    public UnknownFieldSet.Builder toBuilder(){ return null; }
    public UnknownFieldSet.Field getField(int p0){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean hasField(int p0){ return false; }
    public boolean isInitialized(){ return false; }
    public byte[] toByteArray(){ return null; }
    public final UnknownFieldSet.Parser getParserForType(){ return null; }
    public int getSerializedSize(){ return 0; }
    public int getSerializedSizeAsMessageSet(){ return 0; }
    public int hashCode(){ return 0; }
    public static UnknownFieldSet getDefaultInstance(){ return null; }
    public static UnknownFieldSet parseFrom(ByteString p0){ return null; }
    public static UnknownFieldSet parseFrom(CodedInputStream p0){ return null; }
    public static UnknownFieldSet parseFrom(InputStream p0){ return null; }
    public static UnknownFieldSet parseFrom(byte[] p0){ return null; }
    public static UnknownFieldSet.Builder newBuilder(){ return null; }
    public static UnknownFieldSet.Builder newBuilder(UnknownFieldSet p0){ return null; }
    public void writeAsMessageSetTo(CodedOutputStream p0){}
    public void writeDelimitedTo(OutputStream p0){}
    public void writeTo(CodedOutputStream p0){}
    public void writeTo(OutputStream p0){}
    static public class Builder implements MessageLite.Builder
    {
        protected Builder() {}
        public Map<Integer, UnknownFieldSet.Field> asMap(){ return null; }
        public UnknownFieldSet build(){ return null; }
        public UnknownFieldSet buildPartial(){ return null; }
        public UnknownFieldSet getDefaultInstanceForType(){ return null; }
        public UnknownFieldSet.Builder addField(int p0, UnknownFieldSet.Field p1){ return null; }
        public UnknownFieldSet.Builder clear(){ return null; }
        public UnknownFieldSet.Builder clone(){ return null; }
        public UnknownFieldSet.Builder mergeField(int p0, UnknownFieldSet.Field p1){ return null; }
        public UnknownFieldSet.Builder mergeFrom(ByteString p0){ return null; }
        public UnknownFieldSet.Builder mergeFrom(ByteString p0, ExtensionRegistryLite p1){ return null; }
        public UnknownFieldSet.Builder mergeFrom(CodedInputStream p0){ return null; }
        public UnknownFieldSet.Builder mergeFrom(CodedInputStream p0, ExtensionRegistryLite p1){ return null; }
        public UnknownFieldSet.Builder mergeFrom(InputStream p0){ return null; }
        public UnknownFieldSet.Builder mergeFrom(InputStream p0, ExtensionRegistryLite p1){ return null; }
        public UnknownFieldSet.Builder mergeFrom(UnknownFieldSet p0){ return null; }
        public UnknownFieldSet.Builder mergeFrom(byte[] p0){ return null; }
        public UnknownFieldSet.Builder mergeFrom(byte[] p0, ExtensionRegistryLite p1){ return null; }
        public UnknownFieldSet.Builder mergeFrom(byte[] p0, int p1, int p2){ return null; }
        public UnknownFieldSet.Builder mergeFrom(byte[] p0, int p1, int p2, ExtensionRegistryLite p3){ return null; }
        public UnknownFieldSet.Builder mergeVarintField(int p0, int p1){ return null; }
        public boolean hasField(int p0){ return false; }
        public boolean isInitialized(){ return false; }
        public boolean mergeDelimitedFrom(InputStream p0){ return false; }
        public boolean mergeDelimitedFrom(InputStream p0, ExtensionRegistryLite p1){ return false; }
        public boolean mergeFieldFrom(int p0, CodedInputStream p1){ return false; }
    }
    static public class Field
    {
        protected Field() {}
        public List<ByteString> getLengthDelimitedList(){ return null; }
        public List<Integer> getFixed32List(){ return null; }
        public List<Long> getFixed64List(){ return null; }
        public List<Long> getVarintList(){ return null; }
        public List<UnknownFieldSet> getGroupList(){ return null; }
        public boolean equals(Object p0){ return false; }
        public int getSerializedSize(int p0){ return 0; }
        public int getSerializedSizeAsMessageSetExtension(int p0){ return 0; }
        public int hashCode(){ return 0; }
        public static UnknownFieldSet.Field getDefaultInstance(){ return null; }
        public static UnknownFieldSet.Field.Builder newBuilder(){ return null; }
        public static UnknownFieldSet.Field.Builder newBuilder(UnknownFieldSet.Field p0){ return null; }
        public void writeAsMessageSetExtensionTo(int p0, CodedOutputStream p1){}
        public void writeTo(int p0, CodedOutputStream p1){}
        static public class Builder
        {
            protected Builder() {}
            public UnknownFieldSet.Field build(){ return null; }
            public UnknownFieldSet.Field.Builder addFixed32(int p0){ return null; }
            public UnknownFieldSet.Field.Builder addFixed64(long p0){ return null; }
            public UnknownFieldSet.Field.Builder addGroup(UnknownFieldSet p0){ return null; }
            public UnknownFieldSet.Field.Builder addLengthDelimited(ByteString p0){ return null; }
            public UnknownFieldSet.Field.Builder addVarint(long p0){ return null; }
            public UnknownFieldSet.Field.Builder clear(){ return null; }
            public UnknownFieldSet.Field.Builder mergeFrom(UnknownFieldSet.Field p0){ return null; }
        }
    }
    static public class Parser extends AbstractParser<UnknownFieldSet>
    {
        public Parser(){}
        public UnknownFieldSet parsePartialFrom(CodedInputStream p0, ExtensionRegistryLite p1){ return null; }
    }
}
