// Generated automatically from com.google.protobuf.AbstractMessage for testing purposes

package com.google.protobuf;

import com.google.protobuf.AbstractMessageLite;
import com.google.protobuf.ByteString;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import com.google.protobuf.Descriptors;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.Internal;
import com.google.protobuf.Message;
import com.google.protobuf.UninitializedMessageException;
import com.google.protobuf.UnknownFieldSet;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

abstract public class AbstractMessage extends AbstractMessageLite implements Message
{
    abstract static public class Builder<BuilderType extends AbstractMessage.Builder> extends AbstractMessageLite.Builder<BuilderType> implements Message.Builder
    {
        protected static UninitializedMessageException newUninitializedMessageException(Message p0){ return null; }
        public Builder(){}
        public BuilderType clear(){ return null; }
        public BuilderType mergeFrom(ByteString p0){ return null; }
        public BuilderType mergeFrom(ByteString p0, ExtensionRegistryLite p1){ return null; }
        public BuilderType mergeFrom(CodedInputStream p0){ return null; }
        public BuilderType mergeFrom(CodedInputStream p0, ExtensionRegistryLite p1){ return null; }
        public BuilderType mergeFrom(InputStream p0){ return null; }
        public BuilderType mergeFrom(InputStream p0, ExtensionRegistryLite p1){ return null; }
        public BuilderType mergeFrom(Message p0){ return null; }
        public BuilderType mergeFrom(byte[] p0){ return null; }
        public BuilderType mergeFrom(byte[] p0, ExtensionRegistryLite p1){ return null; }
        public BuilderType mergeFrom(byte[] p0, int p1, int p2){ return null; }
        public BuilderType mergeFrom(byte[] p0, int p1, int p2, ExtensionRegistryLite p3){ return null; }
        public BuilderType mergeUnknownFields(UnknownFieldSet p0){ return null; }
        public List<String> findInitializationErrors(){ return null; }
        public Message.Builder getFieldBuilder(Descriptors.FieldDescriptor p0){ return null; }
        public String getInitializationErrorString(){ return null; }
        public abstract BuilderType clone();
        public boolean mergeDelimitedFrom(InputStream p0){ return false; }
        public boolean mergeDelimitedFrom(InputStream p0, ExtensionRegistryLite p1){ return false; }
    }
    protected int hashFields(int p0, Map<Descriptors.FieldDescriptor, Object> p1){ return 0; }
    protected static int hashBoolean(boolean p0){ return 0; }
    protected static int hashEnum(Internal.EnumLite p0){ return 0; }
    protected static int hashEnumList(List<? extends Internal.EnumLite> p0){ return 0; }
    protected static int hashLong(long p0){ return 0; }
    public AbstractMessage(){}
    public List<String> findInitializationErrors(){ return null; }
    public String getInitializationErrorString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isInitialized(){ return false; }
    public final String toString(){ return null; }
    public int getSerializedSize(){ return 0; }
    public int hashCode(){ return 0; }
    public void writeTo(CodedOutputStream p0){}
}
