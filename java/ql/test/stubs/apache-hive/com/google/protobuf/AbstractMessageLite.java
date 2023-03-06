// Generated automatically from com.google.protobuf.AbstractMessageLite for testing purposes

package com.google.protobuf;

import com.google.protobuf.ByteString;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.MessageLite;
import com.google.protobuf.UninitializedMessageException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Collection;

abstract public class AbstractMessageLite implements MessageLite
{
    abstract static public class Builder<BuilderType extends AbstractMessageLite.Builder> implements MessageLite.Builder
    {
        protected static <T> void addAll(java.lang.Iterable<T> p0, Collection<? super T> p1){}
        protected static UninitializedMessageException newUninitializedMessageException(MessageLite p0){ return null; }
        public Builder(){}
        public BuilderType mergeFrom(ByteString p0){ return null; }
        public BuilderType mergeFrom(ByteString p0, ExtensionRegistryLite p1){ return null; }
        public BuilderType mergeFrom(CodedInputStream p0){ return null; }
        public BuilderType mergeFrom(InputStream p0){ return null; }
        public BuilderType mergeFrom(InputStream p0, ExtensionRegistryLite p1){ return null; }
        public BuilderType mergeFrom(byte[] p0){ return null; }
        public BuilderType mergeFrom(byte[] p0, ExtensionRegistryLite p1){ return null; }
        public BuilderType mergeFrom(byte[] p0, int p1, int p2){ return null; }
        public BuilderType mergeFrom(byte[] p0, int p1, int p2, ExtensionRegistryLite p3){ return null; }
        public abstract BuilderType clone();
        public abstract BuilderType mergeFrom(CodedInputStream p0, ExtensionRegistryLite p1);
        public boolean mergeDelimitedFrom(InputStream p0){ return false; }
        public boolean mergeDelimitedFrom(InputStream p0, ExtensionRegistryLite p1){ return false; }
    }
    public AbstractMessageLite(){}
    public ByteString toByteString(){ return null; }
    public byte[] toByteArray(){ return null; }
    public void writeDelimitedTo(OutputStream p0){}
    public void writeTo(OutputStream p0){}
}
