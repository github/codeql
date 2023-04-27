// Generated automatically from org.apache.hadoop.security.proto.SecurityProtos for testing purposes

package org.apache.hadoop.security.proto;

import com.google.protobuf.ByteString;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import com.google.protobuf.Descriptors;
import com.google.protobuf.ExtensionRegistry;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.GeneratedMessage;
import com.google.protobuf.Message;
import com.google.protobuf.MessageOrBuilder;
import com.google.protobuf.Parser;
import com.google.protobuf.UnknownFieldSet;
import java.io.InputStream;

public class SecurityProtos
{
    protected SecurityProtos() {}
    public static Descriptors.FileDescriptor getDescriptor(){ return null; }
    public static void registerAllExtensions(ExtensionRegistry p0){}
    static public class TokenProto extends GeneratedMessage implements SecurityProtos.TokenProtoOrBuilder
    {
        protected TokenProto() {}
        protected GeneratedMessage.FieldAccessorTable internalGetFieldAccessorTable(){ return null; }
        protected Object writeReplace(){ return null; }
        protected SecurityProtos.TokenProto.Builder newBuilderForType(GeneratedMessage.BuilderParent p0){ return null; }
        public ByteString getIdentifier(){ return null; }
        public ByteString getKindBytes(){ return null; }
        public ByteString getPassword(){ return null; }
        public ByteString getServiceBytes(){ return null; }
        public Parser<SecurityProtos.TokenProto> getParserForType(){ return null; }
        public SecurityProtos.TokenProto getDefaultInstanceForType(){ return null; }
        public SecurityProtos.TokenProto.Builder newBuilderForType(){ return null; }
        public SecurityProtos.TokenProto.Builder toBuilder(){ return null; }
        public String getKind(){ return null; }
        public String getService(){ return null; }
        public boolean equals(Object p0){ return false; }
        public boolean hasIdentifier(){ return false; }
        public boolean hasKind(){ return false; }
        public boolean hasPassword(){ return false; }
        public boolean hasService(){ return false; }
        public final UnknownFieldSet getUnknownFields(){ return null; }
        public final boolean isInitialized(){ return false; }
        public int getSerializedSize(){ return 0; }
        public int hashCode(){ return 0; }
        public static Descriptors.Descriptor getDescriptor(){ return null; }
        public static Parser<SecurityProtos.TokenProto> PARSER = null;
        public static SecurityProtos.TokenProto getDefaultInstance(){ return null; }
        public static SecurityProtos.TokenProto parseDelimitedFrom(InputStream p0){ return null; }
        public static SecurityProtos.TokenProto parseDelimitedFrom(InputStream p0, ExtensionRegistryLite p1){ return null; }
        public static SecurityProtos.TokenProto parseFrom(ByteString p0){ return null; }
        public static SecurityProtos.TokenProto parseFrom(ByteString p0, ExtensionRegistryLite p1){ return null; }
        public static SecurityProtos.TokenProto parseFrom(CodedInputStream p0){ return null; }
        public static SecurityProtos.TokenProto parseFrom(CodedInputStream p0, ExtensionRegistryLite p1){ return null; }
        public static SecurityProtos.TokenProto parseFrom(InputStream p0){ return null; }
        public static SecurityProtos.TokenProto parseFrom(InputStream p0, ExtensionRegistryLite p1){ return null; }
        public static SecurityProtos.TokenProto parseFrom(byte[] p0){ return null; }
        public static SecurityProtos.TokenProto parseFrom(byte[] p0, ExtensionRegistryLite p1){ return null; }
        public static SecurityProtos.TokenProto.Builder newBuilder(){ return null; }
        public static SecurityProtos.TokenProto.Builder newBuilder(SecurityProtos.TokenProto p0){ return null; }
        public static int IDENTIFIER_FIELD_NUMBER = 0;
        public static int KIND_FIELD_NUMBER = 0;
        public static int PASSWORD_FIELD_NUMBER = 0;
        public static int SERVICE_FIELD_NUMBER = 0;
        public void writeTo(CodedOutputStream p0){}
        static public class Builder extends GeneratedMessage.Builder<SecurityProtos.TokenProto.Builder> implements SecurityProtos.TokenProtoOrBuilder
        {
            protected Builder() {}
            protected GeneratedMessage.FieldAccessorTable internalGetFieldAccessorTable(){ return null; }
            public ByteString getIdentifier(){ return null; }
            public ByteString getKindBytes(){ return null; }
            public ByteString getPassword(){ return null; }
            public ByteString getServiceBytes(){ return null; }
            public Descriptors.Descriptor getDescriptorForType(){ return null; }
            public SecurityProtos.TokenProto build(){ return null; }
            public SecurityProtos.TokenProto buildPartial(){ return null; }
            public SecurityProtos.TokenProto getDefaultInstanceForType(){ return null; }
            public SecurityProtos.TokenProto.Builder clear(){ return null; }
            public SecurityProtos.TokenProto.Builder clearIdentifier(){ return null; }
            public SecurityProtos.TokenProto.Builder clearKind(){ return null; }
            public SecurityProtos.TokenProto.Builder clearPassword(){ return null; }
            public SecurityProtos.TokenProto.Builder clearService(){ return null; }
            public SecurityProtos.TokenProto.Builder clone(){ return null; }
            public SecurityProtos.TokenProto.Builder mergeFrom(CodedInputStream p0, ExtensionRegistryLite p1){ return null; }
            public SecurityProtos.TokenProto.Builder mergeFrom(Message p0){ return null; }
            public SecurityProtos.TokenProto.Builder mergeFrom(SecurityProtos.TokenProto p0){ return null; }
            public SecurityProtos.TokenProto.Builder setIdentifier(ByteString p0){ return null; }
            public SecurityProtos.TokenProto.Builder setKind(String p0){ return null; }
            public SecurityProtos.TokenProto.Builder setKindBytes(ByteString p0){ return null; }
            public SecurityProtos.TokenProto.Builder setPassword(ByteString p0){ return null; }
            public SecurityProtos.TokenProto.Builder setService(String p0){ return null; }
            public SecurityProtos.TokenProto.Builder setServiceBytes(ByteString p0){ return null; }
            public String getKind(){ return null; }
            public String getService(){ return null; }
            public boolean hasIdentifier(){ return false; }
            public boolean hasKind(){ return false; }
            public boolean hasPassword(){ return false; }
            public boolean hasService(){ return false; }
            public final boolean isInitialized(){ return false; }
            public static Descriptors.Descriptor getDescriptor(){ return null; }
        }
    }
    static public interface TokenProtoOrBuilder extends MessageOrBuilder
    {
        ByteString getIdentifier();
        ByteString getKindBytes();
        ByteString getPassword();
        ByteString getServiceBytes();
        String getKind();
        String getService();
        boolean hasIdentifier();
        boolean hasKind();
        boolean hasPassword();
        boolean hasService();
    }
}
