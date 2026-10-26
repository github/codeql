// Generated automatically from com.google.protobuf.Message for testing purposes

package com.google.protobuf;

import com.google.protobuf.ByteString;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.Descriptors;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.MessageLite;
import com.google.protobuf.MessageOrBuilder;
import com.google.protobuf.Parser;
import com.google.protobuf.UnknownFieldSet;
import java.io.InputStream;

public interface Message extends MessageLite, MessageOrBuilder
{
    Message.Builder newBuilderForType();
    Message.Builder toBuilder();
    Parser<? extends Message> getParserForType();
    String toString();
    boolean equals(Object p0);
    int hashCode();
    static public interface Builder extends MessageLite.Builder, MessageOrBuilder
    {
        Descriptors.Descriptor getDescriptorForType();
        Message build();
        Message buildPartial();
        Message.Builder addRepeatedField(Descriptors.FieldDescriptor p0, Object p1);
        Message.Builder clear();
        Message.Builder clearField(Descriptors.FieldDescriptor p0);
        Message.Builder clone();
        Message.Builder getFieldBuilder(Descriptors.FieldDescriptor p0);
        Message.Builder mergeFrom(ByteString p0);
        Message.Builder mergeFrom(ByteString p0, ExtensionRegistryLite p1);
        Message.Builder mergeFrom(CodedInputStream p0);
        Message.Builder mergeFrom(CodedInputStream p0, ExtensionRegistryLite p1);
        Message.Builder mergeFrom(InputStream p0);
        Message.Builder mergeFrom(InputStream p0, ExtensionRegistryLite p1);
        Message.Builder mergeFrom(Message p0);
        Message.Builder mergeFrom(byte[] p0);
        Message.Builder mergeFrom(byte[] p0, ExtensionRegistryLite p1);
        Message.Builder mergeFrom(byte[] p0, int p1, int p2);
        Message.Builder mergeFrom(byte[] p0, int p1, int p2, ExtensionRegistryLite p3);
        Message.Builder mergeUnknownFields(UnknownFieldSet p0);
        Message.Builder newBuilderForField(Descriptors.FieldDescriptor p0);
        Message.Builder setField(Descriptors.FieldDescriptor p0, Object p1);
        Message.Builder setRepeatedField(Descriptors.FieldDescriptor p0, int p1, Object p2);
        Message.Builder setUnknownFields(UnknownFieldSet p0);
        boolean mergeDelimitedFrom(InputStream p0);
        boolean mergeDelimitedFrom(InputStream p0, ExtensionRegistryLite p1);
    }
}
