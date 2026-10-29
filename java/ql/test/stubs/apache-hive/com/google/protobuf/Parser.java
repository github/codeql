// Generated automatically from com.google.protobuf.Parser for testing purposes

package com.google.protobuf;

import com.google.protobuf.ByteString;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.ExtensionRegistryLite;
import java.io.InputStream;

public interface Parser<MessageType>
{
    MessageType parseDelimitedFrom(InputStream p0);
    MessageType parseDelimitedFrom(InputStream p0, ExtensionRegistryLite p1);
    MessageType parseFrom(ByteString p0);
    MessageType parseFrom(ByteString p0, ExtensionRegistryLite p1);
    MessageType parseFrom(CodedInputStream p0);
    MessageType parseFrom(CodedInputStream p0, ExtensionRegistryLite p1);
    MessageType parseFrom(InputStream p0);
    MessageType parseFrom(InputStream p0, ExtensionRegistryLite p1);
    MessageType parseFrom(byte[] p0);
    MessageType parseFrom(byte[] p0, ExtensionRegistryLite p1);
    MessageType parseFrom(byte[] p0, int p1, int p2);
    MessageType parseFrom(byte[] p0, int p1, int p2, ExtensionRegistryLite p3);
    MessageType parsePartialDelimitedFrom(InputStream p0);
    MessageType parsePartialDelimitedFrom(InputStream p0, ExtensionRegistryLite p1);
    MessageType parsePartialFrom(ByteString p0);
    MessageType parsePartialFrom(ByteString p0, ExtensionRegistryLite p1);
    MessageType parsePartialFrom(CodedInputStream p0);
    MessageType parsePartialFrom(CodedInputStream p0, ExtensionRegistryLite p1);
    MessageType parsePartialFrom(InputStream p0);
    MessageType parsePartialFrom(InputStream p0, ExtensionRegistryLite p1);
    MessageType parsePartialFrom(byte[] p0);
    MessageType parsePartialFrom(byte[] p0, ExtensionRegistryLite p1);
    MessageType parsePartialFrom(byte[] p0, int p1, int p2);
    MessageType parsePartialFrom(byte[] p0, int p1, int p2, ExtensionRegistryLite p3);
}
