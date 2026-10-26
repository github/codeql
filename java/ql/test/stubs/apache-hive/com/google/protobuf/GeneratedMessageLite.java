// Generated automatically from com.google.protobuf.GeneratedMessageLite for testing purposes

package com.google.protobuf;

import com.google.protobuf.AbstractMessageLite;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.Internal;
import com.google.protobuf.MessageLite;
import com.google.protobuf.Parser;
import com.google.protobuf.WireFormat;
import java.io.Serializable;

abstract public class GeneratedMessageLite extends AbstractMessageLite implements Serializable
{
    abstract static public class Builder<MessageType extends GeneratedMessageLite, BuilderType extends GeneratedMessageLite.Builder> extends AbstractMessageLite.Builder<BuilderType>
    {
        protected Builder(){}
        protected boolean parseUnknownField(CodedInputStream p0, ExtensionRegistryLite p1, int p2){ return false; }
        public BuilderType clear(){ return null; }
        public BuilderType clone(){ return null; }
        public abstract BuilderType mergeFrom(MessageType p0);
        public abstract MessageType getDefaultInstanceForType();
    }
    protected GeneratedMessageLite(){}
    protected GeneratedMessageLite(GeneratedMessageLite.Builder p0){}
    protected Object writeReplace(){ return null; }
    protected boolean parseUnknownField(CodedInputStream p0, ExtensionRegistryLite p1, int p2){ return false; }
    protected void makeExtensionsImmutable(){}
    public Parser<? extends MessageLite> getParserForType(){ return null; }
    public static <ContainingType extends MessageLite, Type> GeneratedMessageLite.GeneratedExtension<ContainingType, Type> newRepeatedGeneratedExtension(ContainingType p0, MessageLite p1, Internal.EnumLiteMap<? extends Object> p2, int p3, WireFormat.FieldType p4, boolean p5){ return null; }
    public static <ContainingType extends MessageLite, Type> GeneratedMessageLite.GeneratedExtension<ContainingType, Type> newSingularGeneratedExtension(ContainingType p0, Type p1, MessageLite p2, Internal.EnumLiteMap<? extends Object> p3, int p4, WireFormat.FieldType p5){ return null; }
    static public class GeneratedExtension<ContainingType extends MessageLite, Type>
    {
        protected GeneratedExtension() {}
        public ContainingType getContainingTypeDefaultInstance(){ return null; }
        public MessageLite getMessageDefaultInstance(){ return null; }
        public int getNumber(){ return 0; }
    }
}
