// Generated automatically from com.google.protobuf.GeneratedMessage for testing purposes

package com.google.protobuf;

import com.google.protobuf.AbstractMessage;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import com.google.protobuf.Descriptors;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.Message;
import com.google.protobuf.MessageOrBuilder;
import com.google.protobuf.Parser;
import com.google.protobuf.UnknownFieldSet;
import java.io.Serializable;
import java.util.List;
import java.util.Map;

abstract public class GeneratedMessage extends AbstractMessage implements Serializable
{
    abstract static public class Builder<BuilderType extends GeneratedMessage.Builder> extends AbstractMessage.Builder<BuilderType>
    {
        protected Builder(){}
        protected Builder(GeneratedMessage.BuilderParent p0){}
        protected GeneratedMessage.BuilderParent getParentForChildren(){ return null; }
        protected abstract GeneratedMessage.FieldAccessorTable internalGetFieldAccessorTable();
        protected boolean isClean(){ return false; }
        protected boolean parseUnknownField(CodedInputStream p0, UnknownFieldSet.Builder p1, ExtensionRegistryLite p2, int p3){ return false; }
        protected final void onChanged(){}
        protected void markClean(){}
        protected void onBuilt(){}
        public BuilderType addRepeatedField(Descriptors.FieldDescriptor p0, Object p1){ return null; }
        public BuilderType clear(){ return null; }
        public BuilderType clearField(Descriptors.FieldDescriptor p0){ return null; }
        public BuilderType clone(){ return null; }
        public BuilderType setField(Descriptors.FieldDescriptor p0, Object p1){ return null; }
        public BuilderType setRepeatedField(Descriptors.FieldDescriptor p0, int p1, Object p2){ return null; }
        public Descriptors.Descriptor getDescriptorForType(){ return null; }
        public Map<Descriptors.FieldDescriptor, Object> getAllFields(){ return null; }
        public Message.Builder getFieldBuilder(Descriptors.FieldDescriptor p0){ return null; }
        public Message.Builder newBuilderForField(Descriptors.FieldDescriptor p0){ return null; }
        public Object getField(Descriptors.FieldDescriptor p0){ return null; }
        public Object getRepeatedField(Descriptors.FieldDescriptor p0, int p1){ return null; }
        public boolean hasField(Descriptors.FieldDescriptor p0){ return false; }
        public boolean isInitialized(){ return false; }
        public final BuilderType mergeUnknownFields(UnknownFieldSet p0){ return null; }
        public final BuilderType setUnknownFields(UnknownFieldSet p0){ return null; }
        public final UnknownFieldSet getUnknownFields(){ return null; }
        public int getRepeatedFieldCount(Descriptors.FieldDescriptor p0){ return 0; }
    }
    abstract static public class ExtendableBuilder<MessageType extends GeneratedMessage.ExtendableMessage, BuilderType extends GeneratedMessage.ExtendableBuilder> extends GeneratedMessage.Builder<BuilderType> implements GeneratedMessage.ExtendableMessageOrBuilder<MessageType>
    {
        protected ExtendableBuilder(){}
        protected ExtendableBuilder(GeneratedMessage.BuilderParent p0){}
        protected boolean extensionsAreInitialized(){ return false; }
        protected boolean parseUnknownField(CodedInputStream p0, UnknownFieldSet.Builder p1, ExtensionRegistryLite p2, int p3){ return false; }
        protected final void mergeExtensionFields(GeneratedMessage.ExtendableMessage p0){}
        public BuilderType addRepeatedField(Descriptors.FieldDescriptor p0, Object p1){ return null; }
        public BuilderType clear(){ return null; }
        public BuilderType clearField(Descriptors.FieldDescriptor p0){ return null; }
        public BuilderType clone(){ return null; }
        public BuilderType setField(Descriptors.FieldDescriptor p0, Object p1){ return null; }
        public BuilderType setRepeatedField(Descriptors.FieldDescriptor p0, int p1, Object p2){ return null; }
        public Map<Descriptors.FieldDescriptor, Object> getAllFields(){ return null; }
        public Object getField(Descriptors.FieldDescriptor p0){ return null; }
        public Object getRepeatedField(Descriptors.FieldDescriptor p0, int p1){ return null; }
        public boolean hasField(Descriptors.FieldDescriptor p0){ return false; }
        public boolean isInitialized(){ return false; }
        public final <Type> BuilderType addExtension(GeneratedMessage.GeneratedExtension<MessageType, java.util.List<Type>> p0, Type p1){ return null; }
        public final <Type> BuilderType clearExtension(GeneratedMessage.GeneratedExtension<MessageType, ? extends Object> p0){ return null; }
        public final <Type> BuilderType setExtension(GeneratedMessage.GeneratedExtension<MessageType, Type> p0, Type p1){ return null; }
        public final <Type> BuilderType setExtension(GeneratedMessage.GeneratedExtension<MessageType, java.util.List<Type>> p0, int p1, Type p2){ return null; }
        public final <Type> Type getExtension(GeneratedMessage.GeneratedExtension<MessageType, Type> p0){ return null; }
        public final <Type> Type getExtension(GeneratedMessage.GeneratedExtension<MessageType, java.util.List<Type>> p0, int p1){ return null; }
        public final <Type> boolean hasExtension(GeneratedMessage.GeneratedExtension<MessageType, Type> p0){ return false; }
        public final <Type> int getExtensionCount(GeneratedMessage.GeneratedExtension<MessageType, java.util.List<Type>> p0){ return 0; }
        public int getRepeatedFieldCount(Descriptors.FieldDescriptor p0){ return 0; }
    }
    abstract static public class ExtendableMessage<MessageType extends GeneratedMessage.ExtendableMessage> extends GeneratedMessage implements GeneratedMessage.ExtendableMessageOrBuilder<MessageType>
    {
        class ExtensionWriter
        {
            protected ExtensionWriter() {}
            public void writeUntil(int p0, CodedOutputStream p1){}
        }
        protected ExtendableMessage(){}
        protected ExtendableMessage(GeneratedMessage.ExtendableBuilder<MessageType, ? extends Object> p0){}
        protected GeneratedMessage.ExtendableMessage.ExtensionWriter newExtensionWriter(){ return null; }
        protected GeneratedMessage.ExtendableMessage.ExtensionWriter newMessageSetExtensionWriter(){ return null; }
        protected Map<Descriptors.FieldDescriptor, Object> getExtensionFields(){ return null; }
        protected boolean extensionsAreInitialized(){ return false; }
        protected boolean parseUnknownField(CodedInputStream p0, UnknownFieldSet.Builder p1, ExtensionRegistryLite p2, int p3){ return false; }
        protected int extensionsSerializedSize(){ return 0; }
        protected int extensionsSerializedSizeAsMessageSet(){ return 0; }
        protected void makeExtensionsImmutable(){}
        public Map<Descriptors.FieldDescriptor, Object> getAllFields(){ return null; }
        public Object getField(Descriptors.FieldDescriptor p0){ return null; }
        public Object getRepeatedField(Descriptors.FieldDescriptor p0, int p1){ return null; }
        public boolean hasField(Descriptors.FieldDescriptor p0){ return false; }
        public boolean isInitialized(){ return false; }
        public final <Type> Type getExtension(GeneratedMessage.GeneratedExtension<MessageType, Type> p0){ return null; }
        public final <Type> Type getExtension(GeneratedMessage.GeneratedExtension<MessageType, java.util.List<Type>> p0, int p1){ return null; }
        public final <Type> boolean hasExtension(GeneratedMessage.GeneratedExtension<MessageType, Type> p0){ return false; }
        public final <Type> int getExtensionCount(GeneratedMessage.GeneratedExtension<MessageType, java.util.List<Type>> p0){ return 0; }
        public int getRepeatedFieldCount(Descriptors.FieldDescriptor p0){ return 0; }
    }
    protected GeneratedMessage(){}
    protected GeneratedMessage(GeneratedMessage.Builder<? extends Object> p0){}
    protected Object writeReplace(){ return null; }
    protected abstract GeneratedMessage.FieldAccessorTable internalGetFieldAccessorTable();
    protected abstract Message.Builder newBuilderForType(GeneratedMessage.BuilderParent p0);
    protected boolean parseUnknownField(CodedInputStream p0, UnknownFieldSet.Builder p1, ExtensionRegistryLite p2, int p3){ return false; }
    protected static boolean alwaysUseFieldBuilders = false;
    protected void makeExtensionsImmutable(){}
    public Descriptors.Descriptor getDescriptorForType(){ return null; }
    public Map<Descriptors.FieldDescriptor, Object> getAllFields(){ return null; }
    public Object getField(Descriptors.FieldDescriptor p0){ return null; }
    public Object getRepeatedField(Descriptors.FieldDescriptor p0, int p1){ return null; }
    public Parser<? extends Message> getParserForType(){ return null; }
    public UnknownFieldSet getUnknownFields(){ return null; }
    public boolean hasField(Descriptors.FieldDescriptor p0){ return false; }
    public boolean isInitialized(){ return false; }
    public int getRepeatedFieldCount(Descriptors.FieldDescriptor p0){ return 0; }
    public static <ContainingType extends Message, Type> GeneratedMessage.GeneratedExtension<ContainingType, Type> newFileScopedGeneratedExtension(Class p0, Message p1){ return null; }
    public static <ContainingType extends Message, Type> GeneratedMessage.GeneratedExtension<ContainingType, Type> newMessageScopedGeneratedExtension(Message p0, int p1, Class p2, Message p3){ return null; }
    public static interface BuilderParent
    {
        void markDirty();
    }
    static public class FieldAccessorTable
    {
        protected FieldAccessorTable() {}
        public FieldAccessorTable(Descriptors.Descriptor p0, String[] p1){}
        public FieldAccessorTable(Descriptors.Descriptor p0, String[] p1, Class<? extends GeneratedMessage> p2, Class<? extends GeneratedMessage.Builder> p3){}
        public GeneratedMessage.FieldAccessorTable ensureFieldAccessorsInitialized(Class<? extends GeneratedMessage> p0, Class<? extends GeneratedMessage.Builder> p1){ return null; }
    }
    static public class GeneratedExtension<ContainingType extends Message, Type>
    {
        protected GeneratedExtension() {}
        public Descriptors.FieldDescriptor getDescriptor(){ return null; }
        public Message getMessageDefaultInstance(){ return null; }
        public void internalInit(Descriptors.FieldDescriptor p0){}
    }
    static public interface ExtendableMessageOrBuilder<MessageType extends GeneratedMessage.ExtendableMessage> extends MessageOrBuilder
    {
        <Type> Type getExtension(GeneratedMessage.GeneratedExtension<MessageType, Type> p0);
        <Type> Type getExtension(GeneratedMessage.GeneratedExtension<MessageType, java.util.List<Type>> p0, int p1);
        <Type> boolean hasExtension(GeneratedMessage.GeneratedExtension<MessageType, Type> p0);
        <Type> int getExtensionCount(GeneratedMessage.GeneratedExtension<MessageType, java.util.List<Type>> p0);
    }
}
