// Generated automatically from com.google.protobuf.Descriptors for testing purposes

package com.google.protobuf;

import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.ExtensionRegistry;
import com.google.protobuf.FieldSet;
import com.google.protobuf.Internal;
import com.google.protobuf.Message;
import com.google.protobuf.MessageLite;
import com.google.protobuf.WireFormat;
import java.util.List;

public class Descriptors
{
    public interface GenericDescriptor {}
    public Descriptors(){}
    static public class Descriptor implements Descriptors.GenericDescriptor
    {
        protected Descriptor() {}
        public DescriptorProtos.DescriptorProto toProto(){ return null; }
        public DescriptorProtos.MessageOptions getOptions(){ return null; }
        public Descriptors.Descriptor findNestedTypeByName(String p0){ return null; }
        public Descriptors.Descriptor getContainingType(){ return null; }
        public Descriptors.EnumDescriptor findEnumTypeByName(String p0){ return null; }
        public Descriptors.FieldDescriptor findFieldByName(String p0){ return null; }
        public Descriptors.FieldDescriptor findFieldByNumber(int p0){ return null; }
        public Descriptors.FileDescriptor getFile(){ return null; }
        public List<Descriptors.Descriptor> getNestedTypes(){ return null; }
        public List<Descriptors.EnumDescriptor> getEnumTypes(){ return null; }
        public List<Descriptors.FieldDescriptor> getExtensions(){ return null; }
        public List<Descriptors.FieldDescriptor> getFields(){ return null; }
        public String getFullName(){ return null; }
        public String getName(){ return null; }
        public boolean isExtensionNumber(int p0){ return false; }
        public int getIndex(){ return 0; }
    }
    static public class DescriptorValidationException extends Exception
    {
        protected DescriptorValidationException() {}
        public Message getProblemProto(){ return null; }
        public String getDescription(){ return null; }
        public String getProblemSymbolName(){ return null; }
    }
    static public class EnumDescriptor implements Descriptors.GenericDescriptor, Internal.EnumLiteMap<Descriptors.EnumValueDescriptor>
    {
        protected EnumDescriptor() {}
        public DescriptorProtos.EnumDescriptorProto toProto(){ return null; }
        public DescriptorProtos.EnumOptions getOptions(){ return null; }
        public Descriptors.Descriptor getContainingType(){ return null; }
        public Descriptors.EnumValueDescriptor findValueByName(String p0){ return null; }
        public Descriptors.EnumValueDescriptor findValueByNumber(int p0){ return null; }
        public Descriptors.FileDescriptor getFile(){ return null; }
        public List<Descriptors.EnumValueDescriptor> getValues(){ return null; }
        public String getFullName(){ return null; }
        public String getName(){ return null; }
        public int getIndex(){ return 0; }
    }
    static public class EnumValueDescriptor implements Descriptors.GenericDescriptor, Internal.EnumLite
    {
        protected EnumValueDescriptor() {}
        public DescriptorProtos.EnumValueDescriptorProto toProto(){ return null; }
        public DescriptorProtos.EnumValueOptions getOptions(){ return null; }
        public Descriptors.EnumDescriptor getType(){ return null; }
        public Descriptors.FileDescriptor getFile(){ return null; }
        public String getFullName(){ return null; }
        public String getName(){ return null; }
        public int getIndex(){ return 0; }
        public int getNumber(){ return 0; }
    }
    static public class FieldDescriptor implements Comparable<Descriptors.FieldDescriptor>, Descriptors.GenericDescriptor, FieldSet.FieldDescriptorLite<Descriptors.FieldDescriptor>
    {
        protected FieldDescriptor() {}
        public DescriptorProtos.FieldDescriptorProto toProto(){ return null; }
        public DescriptorProtos.FieldOptions getOptions(){ return null; }
        public Descriptors.Descriptor getContainingType(){ return null; }
        public Descriptors.Descriptor getExtensionScope(){ return null; }
        public Descriptors.Descriptor getMessageType(){ return null; }
        public Descriptors.EnumDescriptor getEnumType(){ return null; }
        public Descriptors.FieldDescriptor.JavaType getJavaType(){ return null; }
        public Descriptors.FieldDescriptor.Type getType(){ return null; }
        public Descriptors.FileDescriptor getFile(){ return null; }
        public MessageLite.Builder internalMergeFrom(MessageLite.Builder p0, MessageLite p1){ return null; }
        public Object getDefaultValue(){ return null; }
        public String getFullName(){ return null; }
        public String getName(){ return null; }
        public WireFormat.FieldType getLiteType(){ return null; }
        public WireFormat.JavaType getLiteJavaType(){ return null; }
        public boolean hasDefaultValue(){ return false; }
        public boolean isExtension(){ return false; }
        public boolean isOptional(){ return false; }
        public boolean isPackable(){ return false; }
        public boolean isPacked(){ return false; }
        public boolean isRepeated(){ return false; }
        public boolean isRequired(){ return false; }
        public int compareTo(Descriptors.FieldDescriptor p0){ return 0; }
        public int getIndex(){ return 0; }
        public int getNumber(){ return 0; }
        static public enum JavaType
        {
            BOOLEAN, BYTE_STRING, DOUBLE, ENUM, FLOAT, INT, LONG, MESSAGE, STRING;
            private JavaType() {}
        }
        static public enum Type
        {
            BOOL, BYTES, DOUBLE, ENUM, FIXED32, FIXED64, FLOAT, GROUP, INT32, INT64, MESSAGE, SFIXED32, SFIXED64, SINT32, SINT64, STRING, UINT32, UINT64;
            private Type() {}
            public DescriptorProtos.FieldDescriptorProto.Type toProto(){ return null; }
            public Descriptors.FieldDescriptor.JavaType getJavaType(){ return null; }
        }
    }
    static public class FileDescriptor
    {
        protected FileDescriptor() {}
        public DescriptorProtos.FileDescriptorProto toProto(){ return null; }
        public DescriptorProtos.FileOptions getOptions(){ return null; }
        public Descriptors.Descriptor findMessageTypeByName(String p0){ return null; }
        public Descriptors.EnumDescriptor findEnumTypeByName(String p0){ return null; }
        public Descriptors.FieldDescriptor findExtensionByName(String p0){ return null; }
        public Descriptors.ServiceDescriptor findServiceByName(String p0){ return null; }
        public List<Descriptors.Descriptor> getMessageTypes(){ return null; }
        public List<Descriptors.EnumDescriptor> getEnumTypes(){ return null; }
        public List<Descriptors.FieldDescriptor> getExtensions(){ return null; }
        public List<Descriptors.FileDescriptor> getDependencies(){ return null; }
        public List<Descriptors.FileDescriptor> getPublicDependencies(){ return null; }
        public List<Descriptors.ServiceDescriptor> getServices(){ return null; }
        public String getName(){ return null; }
        public String getPackage(){ return null; }
        public static Descriptors.FileDescriptor buildFrom(DescriptorProtos.FileDescriptorProto p0, Descriptors.FileDescriptor[] p1){ return null; }
        public static void internalBuildGeneratedFileFrom(String[] p0, Descriptors.FileDescriptor[] p1, Descriptors.FileDescriptor.InternalDescriptorAssigner p2){}
        static public interface InternalDescriptorAssigner
        {
            ExtensionRegistry assignDescriptors(Descriptors.FileDescriptor p0);
        }
    }
    static public class MethodDescriptor implements Descriptors.GenericDescriptor
    {
        protected MethodDescriptor() {}
        public DescriptorProtos.MethodDescriptorProto toProto(){ return null; }
        public DescriptorProtos.MethodOptions getOptions(){ return null; }
        public Descriptors.Descriptor getInputType(){ return null; }
        public Descriptors.Descriptor getOutputType(){ return null; }
        public Descriptors.FileDescriptor getFile(){ return null; }
        public Descriptors.ServiceDescriptor getService(){ return null; }
        public String getFullName(){ return null; }
        public String getName(){ return null; }
        public int getIndex(){ return 0; }
    }
    static public class ServiceDescriptor implements Descriptors.GenericDescriptor
    {
        protected ServiceDescriptor() {}
        public DescriptorProtos.ServiceDescriptorProto toProto(){ return null; }
        public DescriptorProtos.ServiceOptions getOptions(){ return null; }
        public Descriptors.FileDescriptor getFile(){ return null; }
        public Descriptors.MethodDescriptor findMethodByName(String p0){ return null; }
        public List<Descriptors.MethodDescriptor> getMethods(){ return null; }
        public String getFullName(){ return null; }
        public String getName(){ return null; }
        public int getIndex(){ return 0; }
    }
}
