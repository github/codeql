// Generated automatically from org.apache.hadoop.ipc.protobuf.RpcHeaderProtos for testing purposes

package org.apache.hadoop.ipc.protobuf;

import com.google.protobuf.ByteString;
import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import com.google.protobuf.Descriptors;
import com.google.protobuf.ExtensionRegistry;
import com.google.protobuf.ExtensionRegistryLite;
import com.google.protobuf.GeneratedMessage;
import com.google.protobuf.Internal;
import com.google.protobuf.Message;
import com.google.protobuf.MessageOrBuilder;
import com.google.protobuf.Parser;
import com.google.protobuf.UnknownFieldSet;
import java.io.InputStream;

public class RpcHeaderProtos {
    protected RpcHeaderProtos() {}

    public static Descriptors.FileDescriptor getDescriptor() {
        return null;
    }

    public static void registerAllExtensions(ExtensionRegistry p0) {}

    static public class RpcResponseHeaderProto extends GeneratedMessage
            implements RpcHeaderProtos.RpcResponseHeaderProtoOrBuilder {
        protected RpcResponseHeaderProto() {}

        protected GeneratedMessage.FieldAccessorTable internalGetFieldAccessorTable() {
            return null;
        }

        protected Object writeReplace() {
            return null;
        }

        protected RpcHeaderProtos.RpcResponseHeaderProto.Builder newBuilderForType(
                GeneratedMessage.BuilderParent p0) {
            return null;
        }

        public ByteString getClientId() {
            return null;
        }

        public ByteString getErrorMsgBytes() {
            return null;
        }

        public ByteString getExceptionClassNameBytes() {
            return null;
        }

        public Parser<RpcHeaderProtos.RpcResponseHeaderProto> getParserForType() {
            return null;
        }

        public RpcHeaderProtos.RpcResponseHeaderProto getDefaultInstanceForType() {
            return null;
        }

        public RpcHeaderProtos.RpcResponseHeaderProto.Builder newBuilderForType() {
            return null;
        }

        public RpcHeaderProtos.RpcResponseHeaderProto.Builder toBuilder() {
            return null;
        }

        public RpcHeaderProtos.RpcResponseHeaderProto.RpcErrorCodeProto getErrorDetail() {
            return null;
        }

        public RpcHeaderProtos.RpcResponseHeaderProto.RpcStatusProto getStatus() {
            return null;
        }

        public String getErrorMsg() {
            return null;
        }

        public String getExceptionClassName() {
            return null;
        }

        public boolean equals(Object p0) {
            return false;
        }

        public boolean hasCallId() {
            return false;
        }

        public boolean hasClientId() {
            return false;
        }

        public boolean hasErrorDetail() {
            return false;
        }

        public boolean hasErrorMsg() {
            return false;
        }

        public boolean hasExceptionClassName() {
            return false;
        }

        public boolean hasRetryCount() {
            return false;
        }

        public boolean hasServerIpcVersionNum() {
            return false;
        }

        public boolean hasStatus() {
            return false;
        }

        public final UnknownFieldSet getUnknownFields() {
            return null;
        }

        public final boolean isInitialized() {
            return false;
        }

        public int getCallId() {
            return 0;
        }

        public int getRetryCount() {
            return 0;
        }

        public int getSerializedSize() {
            return 0;
        }

        public int getServerIpcVersionNum() {
            return 0;
        }

        public int hashCode() {
            return 0;
        }

        public static Descriptors.Descriptor getDescriptor() {
            return null;
        }

        public static Parser<RpcHeaderProtos.RpcResponseHeaderProto> PARSER = null;

        public static RpcHeaderProtos.RpcResponseHeaderProto getDefaultInstance() {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseDelimitedFrom(InputStream p0) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseDelimitedFrom(InputStream p0,
                ExtensionRegistryLite p1) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseFrom(ByteString p0) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseFrom(ByteString p0,
                ExtensionRegistryLite p1) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseFrom(CodedInputStream p0) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseFrom(CodedInputStream p0,
                ExtensionRegistryLite p1) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseFrom(InputStream p0) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseFrom(InputStream p0,
                ExtensionRegistryLite p1) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseFrom(byte[] p0) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto parseFrom(byte[] p0,
                ExtensionRegistryLite p1) {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto.Builder newBuilder() {
            return null;
        }

        public static RpcHeaderProtos.RpcResponseHeaderProto.Builder newBuilder(
                RpcHeaderProtos.RpcResponseHeaderProto p0) {
            return null;
        }

        public static int CALLID_FIELD_NUMBER = 0;
        public static int CLIENTID_FIELD_NUMBER = 0;
        public static int ERRORDETAIL_FIELD_NUMBER = 0;
        public static int ERRORMSG_FIELD_NUMBER = 0;
        public static int EXCEPTIONCLASSNAME_FIELD_NUMBER = 0;
        public static int RETRYCOUNT_FIELD_NUMBER = 0;
        public static int SERVERIPCVERSIONNUM_FIELD_NUMBER = 0;
        public static int STATUS_FIELD_NUMBER = 0;

        public void writeTo(CodedOutputStream p0) {}

        static public class Builder
                extends GeneratedMessage.Builder<RpcHeaderProtos.RpcResponseHeaderProto.Builder>
                implements RpcHeaderProtos.RpcResponseHeaderProtoOrBuilder {
            protected Builder() {}

            protected GeneratedMessage.FieldAccessorTable internalGetFieldAccessorTable() {
                return null;
            }

            public ByteString getClientId() {
                return null;
            }

            public ByteString getErrorMsgBytes() {
                return null;
            }

            public ByteString getExceptionClassNameBytes() {
                return null;
            }

            public Descriptors.Descriptor getDescriptorForType() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto build() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto buildPartial() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto getDefaultInstanceForType() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clear() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clearCallId() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clearClientId() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clearErrorDetail() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clearErrorMsg() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clearExceptionClassName() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clearRetryCount() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clearServerIpcVersionNum() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clearStatus() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder clone() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder mergeFrom(CodedInputStream p0,
                    ExtensionRegistryLite p1) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder mergeFrom(Message p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder mergeFrom(
                    RpcHeaderProtos.RpcResponseHeaderProto p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setCallId(int p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setClientId(ByteString p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setErrorDetail(
                    RpcHeaderProtos.RpcResponseHeaderProto.RpcErrorCodeProto p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setErrorMsg(String p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setErrorMsgBytes(ByteString p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setExceptionClassName(String p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setExceptionClassNameBytes(
                    ByteString p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setRetryCount(int p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setServerIpcVersionNum(int p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.Builder setStatus(
                    RpcHeaderProtos.RpcResponseHeaderProto.RpcStatusProto p0) {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.RpcErrorCodeProto getErrorDetail() {
                return null;
            }

            public RpcHeaderProtos.RpcResponseHeaderProto.RpcStatusProto getStatus() {
                return null;
            }

            public String getErrorMsg() {
                return null;
            }

            public String getExceptionClassName() {
                return null;
            }

            public boolean hasCallId() {
                return false;
            }

            public boolean hasClientId() {
                return false;
            }

            public boolean hasErrorDetail() {
                return false;
            }

            public boolean hasErrorMsg() {
                return false;
            }

            public boolean hasExceptionClassName() {
                return false;
            }

            public boolean hasRetryCount() {
                return false;
            }

            public boolean hasServerIpcVersionNum() {
                return false;
            }

            public boolean hasStatus() {
                return false;
            }

            public final boolean isInitialized() {
                return false;
            }

            public int getCallId() {
                return 0;
            }

            public int getRetryCount() {
                return 0;
            }

            public int getServerIpcVersionNum() {
                return 0;
            }

            public static Descriptors.Descriptor getDescriptor() {
                return null;
            }
        }
        static public enum RpcErrorCodeProto implements Internal.EnumLite {
            ERROR_APPLICATION, ERROR_NO_SUCH_METHOD, ERROR_NO_SUCH_PROTOCOL, ERROR_RPC_SERVER, ERROR_RPC_VERSION_MISMATCH, ERROR_SERIALIZING_RESPONSE, FATAL_DESERIALIZING_REQUEST, FATAL_INVALID_RPC_HEADER, FATAL_UNAUTHORIZED, FATAL_UNKNOWN, FATAL_UNSUPPORTED_SERIALIZATION, FATAL_VERSION_MISMATCH;

            private RpcErrorCodeProto() {}

            public final Descriptors.EnumDescriptor getDescriptorForType() {
                return null;
            }

            public final Descriptors.EnumValueDescriptor getValueDescriptor() {
                return null;
            }

            public final int getNumber() {
                return 0;
            }

            public static Descriptors.EnumDescriptor getDescriptor() {
                return null;
            }

            public static Internal.EnumLiteMap<RpcHeaderProtos.RpcResponseHeaderProto.RpcErrorCodeProto> internalGetValueMap() {
                return null;
            }

            public static int ERROR_APPLICATION_VALUE = 0;
            public static int ERROR_NO_SUCH_METHOD_VALUE = 0;
            public static int ERROR_NO_SUCH_PROTOCOL_VALUE = 0;
            public static int ERROR_RPC_SERVER_VALUE = 0;
            public static int ERROR_RPC_VERSION_MISMATCH_VALUE = 0;
            public static int ERROR_SERIALIZING_RESPONSE_VALUE = 0;
            public static int FATAL_DESERIALIZING_REQUEST_VALUE = 0;
            public static int FATAL_INVALID_RPC_HEADER_VALUE = 0;
            public static int FATAL_UNAUTHORIZED_VALUE = 0;
            public static int FATAL_UNKNOWN_VALUE = 0;
            public static int FATAL_UNSUPPORTED_SERIALIZATION_VALUE = 0;
            public static int FATAL_VERSION_MISMATCH_VALUE = 0;
        }
        static public enum RpcStatusProto implements Internal.EnumLite {
            ERROR, FATAL, SUCCESS;

            private RpcStatusProto() {}

            public final Descriptors.EnumDescriptor getDescriptorForType() {
                return null;
            }

            public final Descriptors.EnumValueDescriptor getValueDescriptor() {
                return null;
            }

            public final int getNumber() {
                return 0;
            }

            public static Descriptors.EnumDescriptor getDescriptor() {
                return null;
            }

            public static Internal.EnumLiteMap<RpcHeaderProtos.RpcResponseHeaderProto.RpcStatusProto> internalGetValueMap() {
                return null;
            }

            public static int ERROR_VALUE = 0;
            public static int FATAL_VALUE = 0;
            public static int SUCCESS_VALUE = 0;
        }
    }
    static public enum RpcKindProto implements Internal.EnumLite {
        RPC_BUILTIN, RPC_PROTOCOL_BUFFER, RPC_WRITABLE;

        private RpcKindProto() {}

        public final Descriptors.EnumDescriptor getDescriptorForType() {
            return null;
        }

        public final Descriptors.EnumValueDescriptor getValueDescriptor() {
            return null;
        }

        public final int getNumber() {
            return 0;
        }

        public static Descriptors.EnumDescriptor getDescriptor() {
            return null;
        }

        public static Internal.EnumLiteMap<RpcHeaderProtos.RpcKindProto> internalGetValueMap() {
            return null;
        }

        public static int RPC_BUILTIN_VALUE = 0;
        public static int RPC_PROTOCOL_BUFFER_VALUE = 0;
        public static int RPC_WRITABLE_VALUE = 0;
    }
    static public interface RpcResponseHeaderProtoOrBuilder extends MessageOrBuilder {
        ByteString getClientId();

        ByteString getErrorMsgBytes();

        ByteString getExceptionClassNameBytes();

        RpcHeaderProtos.RpcResponseHeaderProto.RpcErrorCodeProto getErrorDetail();

        RpcHeaderProtos.RpcResponseHeaderProto.RpcStatusProto getStatus();

        String getErrorMsg();

        String getExceptionClassName();

        boolean hasCallId();

        boolean hasClientId();

        boolean hasErrorDetail();

        boolean hasErrorMsg();

        boolean hasExceptionClassName();

        boolean hasRetryCount();

        boolean hasServerIpcVersionNum();

        boolean hasStatus();

        int getCallId();

        int getRetryCount();

        int getServerIpcVersionNum();
    }
}
