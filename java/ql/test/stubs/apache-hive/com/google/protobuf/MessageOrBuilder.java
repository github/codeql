// Generated automatically from com.google.protobuf.MessageOrBuilder for testing purposes

package com.google.protobuf;

import com.google.protobuf.Descriptors;
import com.google.protobuf.Message;
import com.google.protobuf.MessageLiteOrBuilder;
import com.google.protobuf.UnknownFieldSet;
import java.util.List;
import java.util.Map;

public interface MessageOrBuilder extends MessageLiteOrBuilder
{
    Descriptors.Descriptor getDescriptorForType();
    List<String> findInitializationErrors();
    Map<Descriptors.FieldDescriptor, Object> getAllFields();
    Message getDefaultInstanceForType();
    Object getField(Descriptors.FieldDescriptor p0);
    Object getRepeatedField(Descriptors.FieldDescriptor p0, int p1);
    String getInitializationErrorString();
    UnknownFieldSet getUnknownFields();
    boolean hasField(Descriptors.FieldDescriptor p0);
    int getRepeatedFieldCount(Descriptors.FieldDescriptor p0);
}
