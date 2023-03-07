// Generated automatically from com.google.protobuf.MessageLite for testing purposes

package com.google.protobuf;

import com.google.protobuf.ByteString;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.MessageLiteOrBuilder;
import com.google.protobuf.Parser;
import java.io.InputStream;
import java.io.OutputStream;

public interface MessageLite extends MessageLiteOrBuilder
{
    ByteString toByteString();
    MessageLite.Builder newBuilderForType();
    MessageLite.Builder toBuilder();
    Parser<? extends MessageLite> getParserForType();
    byte[] toByteArray();
    int getSerializedSize();
    static public interface Builder extends Cloneable, MessageLiteOrBuilder
    {
        MessageLite build();
        MessageLite buildPartial();
        MessageLite.Builder clear();
        MessageLite.Builder clone();
        MessageLite.Builder mergeFrom(ByteString p0);
        MessageLite.Builder mergeFrom(ByteString p0, ExtensionRegistryLite p1);
        MessageLite.Builder mergeFrom(CodedInputStream p0);
        MessageLite.Builder mergeFrom(CodedInputStream p0, ExtensionRegistryLite p1);
        MessageLite.Builder mergeFrom(InputStream p0);
        MessageLite.Builder mergeFrom(InputStream p0, ExtensionRegistryLite p1);
        MessageLite.Builder mergeFrom(byte[] p0);
        MessageLite.Builder mergeFrom(byte[] p0, ExtensionRegistryLite p1);
        MessageLite.Builder mergeFrom(byte[] p0, int p1, int p2);
        MessageLite.Builder mergeFrom(byte[] p0, int p1, int p2, ExtensionRegistryLite p3);
        boolean mergeDelimitedFrom(InputStream p0);
        boolean mergeDelimitedFrom(InputStream p0, ExtensionRegistryLite p1);
    }
    void writeDelimitedTo(OutputStream p0);
    void writeTo(CodedOutputStream p0);
    void writeTo(OutputStream p0);
}
