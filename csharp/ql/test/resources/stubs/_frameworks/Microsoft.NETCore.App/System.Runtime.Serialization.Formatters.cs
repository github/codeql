// This file contains auto-generated code.
// Generated from `System.Runtime.Serialization.Formatters, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Runtime
    {
        namespace Serialization
        {
            public abstract class Formatter : System.Runtime.Serialization.IFormatter
            {
                public abstract System.Runtime.Serialization.SerializationBinder Binder { get; set; }
                public abstract System.Runtime.Serialization.StreamingContext Context { get; set; }
                protected Formatter() => throw null;
                public abstract object Deserialize(System.IO.Stream serializationStream);
                protected virtual object GetNext(out long objID) => throw null;
                protected System.Runtime.Serialization.ObjectIDGenerator m_idGenerator;
                protected System.Collections.Queue m_objectQueue;
                protected virtual long Schedule(object obj) => throw null;
                public abstract void Serialize(System.IO.Stream serializationStream, object graph);
                public abstract System.Runtime.Serialization.ISurrogateSelector SurrogateSelector { get; set; }
                protected abstract void WriteArray(object obj, string name, System.Type memberType);
                protected abstract void WriteBoolean(bool val, string name);
                protected abstract void WriteByte(byte val, string name);
                protected abstract void WriteChar(char val, string name);
                protected abstract void WriteDateTime(System.DateTime val, string name);
                protected abstract void WriteDecimal(decimal val, string name);
                protected abstract void WriteDouble(double val, string name);
                protected abstract void WriteInt16(short val, string name);
                protected abstract void WriteInt32(int val, string name);
                protected abstract void WriteInt64(long val, string name);
                protected virtual void WriteMember(string memberName, object data) => throw null;
                protected abstract void WriteObjectRef(object obj, string name, System.Type memberType);
                protected abstract void WriteSByte(sbyte val, string name);
                protected abstract void WriteSingle(float val, string name);
                protected abstract void WriteTimeSpan(System.TimeSpan val, string name);
                protected abstract void WriteUInt16(ushort val, string name);
                protected abstract void WriteUInt32(uint val, string name);
                protected abstract void WriteUInt64(ulong val, string name);
                protected abstract void WriteValueType(object obj, string name, System.Type memberType);
            }
            public class FormatterConverter : System.Runtime.Serialization.IFormatterConverter
            {
                public object Convert(object value, System.Type type) => throw null;
                public object Convert(object value, System.TypeCode typeCode) => throw null;
                public FormatterConverter() => throw null;
                public bool ToBoolean(object value) => throw null;
                public byte ToByte(object value) => throw null;
                public char ToChar(object value) => throw null;
                public System.DateTime ToDateTime(object value) => throw null;
                public decimal ToDecimal(object value) => throw null;
                public double ToDouble(object value) => throw null;
                public short ToInt16(object value) => throw null;
                public int ToInt32(object value) => throw null;
                public long ToInt64(object value) => throw null;
                public sbyte ToSByte(object value) => throw null;
                public float ToSingle(object value) => throw null;
                public string ToString(object value) => throw null;
                public ushort ToUInt16(object value) => throw null;
                public uint ToUInt32(object value) => throw null;
                public ulong ToUInt64(object value) => throw null;
            }
            namespace Formatters
            {
                namespace Binary
                {
                    public sealed class BinaryFormatter : System.Runtime.Serialization.IFormatter
                    {
                        public System.Runtime.Serialization.Formatters.FormatterAssemblyStyle AssemblyFormat { get => throw null; set { } }
                        public System.Runtime.Serialization.SerializationBinder Binder { get => throw null; set { } }
                        public System.Runtime.Serialization.StreamingContext Context { get => throw null; set { } }
                        public BinaryFormatter() => throw null;
                        public BinaryFormatter(System.Runtime.Serialization.ISurrogateSelector selector, System.Runtime.Serialization.StreamingContext context) => throw null;
                        public object Deserialize(System.IO.Stream serializationStream) => throw null;
                        public System.Runtime.Serialization.Formatters.TypeFilterLevel FilterLevel { get => throw null; set { } }
                        public void Serialize(System.IO.Stream serializationStream, object graph) => throw null;
                        public System.Runtime.Serialization.ISurrogateSelector SurrogateSelector { get => throw null; set { } }
                        public System.Runtime.Serialization.Formatters.FormatterTypeStyle TypeFormat { get => throw null; set { } }
                    }
                }
                public enum FormatterAssemblyStyle
                {
                    Simple = 0,
                    Full = 1,
                }
                public enum FormatterTypeStyle
                {
                    TypesWhenNeeded = 0,
                    TypesAlways = 1,
                    XsdString = 2,
                }
                public interface IFieldInfo
                {
                    string[] FieldNames { get; set; }
                    System.Type[] FieldTypes { get; set; }
                }
                public enum TypeFilterLevel
                {
                    Low = 2,
                    Full = 3,
                }
            }
            public static class FormatterServices
            {
                public static void CheckTypeSecurity(System.Type t, System.Runtime.Serialization.Formatters.TypeFilterLevel securityLevel) => throw null;
                public static object[] GetObjectData(object obj, System.Reflection.MemberInfo[] members) => throw null;
                public static object GetSafeUninitializedObject(System.Type type) => throw null;
                public static System.Reflection.MemberInfo[] GetSerializableMembers(System.Type type) => throw null;
                public static System.Reflection.MemberInfo[] GetSerializableMembers(System.Type type, System.Runtime.Serialization.StreamingContext context) => throw null;
                public static System.Runtime.Serialization.ISerializationSurrogate GetSurrogateForCyclicalReference(System.Runtime.Serialization.ISerializationSurrogate innerSurrogate) => throw null;
                public static System.Type GetTypeFromAssembly(System.Reflection.Assembly assem, string name) => throw null;
                public static object GetUninitializedObject(System.Type type) => throw null;
                public static object PopulateObjectMembers(object obj, System.Reflection.MemberInfo[] members, object[] data) => throw null;
            }
            public interface IFormatter
            {
                System.Runtime.Serialization.SerializationBinder Binder { get; set; }
                System.Runtime.Serialization.StreamingContext Context { get; set; }
                object Deserialize(System.IO.Stream serializationStream);
                void Serialize(System.IO.Stream serializationStream, object graph);
                System.Runtime.Serialization.ISurrogateSelector SurrogateSelector { get; set; }
            }
            public interface ISerializationSurrogate
            {
                void GetObjectData(object obj, System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context);
                object SetObjectData(object obj, System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context, System.Runtime.Serialization.ISurrogateSelector selector);
            }
            public interface ISurrogateSelector
            {
                void ChainSelector(System.Runtime.Serialization.ISurrogateSelector selector);
                System.Runtime.Serialization.ISurrogateSelector GetNextSelector();
                System.Runtime.Serialization.ISerializationSurrogate GetSurrogate(System.Type type, System.Runtime.Serialization.StreamingContext context, out System.Runtime.Serialization.ISurrogateSelector selector);
            }
            public class ObjectIDGenerator
            {
                public ObjectIDGenerator() => throw null;
                public virtual long GetId(object obj, out bool firstTime) => throw null;
                public virtual long HasId(object obj, out bool firstTime) => throw null;
            }
            public class ObjectManager
            {
                public ObjectManager(System.Runtime.Serialization.ISurrogateSelector selector, System.Runtime.Serialization.StreamingContext context) => throw null;
                public virtual void DoFixups() => throw null;
                public virtual object GetObject(long objectID) => throw null;
                public virtual void RaiseDeserializationEvent() => throw null;
                public void RaiseOnDeserializingEvent(object obj) => throw null;
                public virtual void RecordArrayElementFixup(long arrayToBeFixed, int index, long objectRequired) => throw null;
                public virtual void RecordArrayElementFixup(long arrayToBeFixed, int[] indices, long objectRequired) => throw null;
                public virtual void RecordDelayedFixup(long objectToBeFixed, string memberName, long objectRequired) => throw null;
                public virtual void RecordFixup(long objectToBeFixed, System.Reflection.MemberInfo member, long objectRequired) => throw null;
                public virtual void RegisterObject(object obj, long objectID) => throw null;
                public void RegisterObject(object obj, long objectID, System.Runtime.Serialization.SerializationInfo info) => throw null;
                public void RegisterObject(object obj, long objectID, System.Runtime.Serialization.SerializationInfo info, long idOfContainingObj, System.Reflection.MemberInfo member) => throw null;
                public void RegisterObject(object obj, long objectID, System.Runtime.Serialization.SerializationInfo info, long idOfContainingObj, System.Reflection.MemberInfo member, int[] arrayIndex) => throw null;
            }
            public abstract class SerializationBinder
            {
                public virtual void BindToName(System.Type serializedType, out string assemblyName, out string typeName) => throw null;
                public abstract System.Type BindToType(string assemblyName, string typeName);
                protected SerializationBinder() => throw null;
            }
            public sealed class SerializationObjectManager
            {
                public SerializationObjectManager(System.Runtime.Serialization.StreamingContext context) => throw null;
                public void RaiseOnSerializedEvent() => throw null;
                public void RegisterObject(object obj) => throw null;
            }
            public class SurrogateSelector : System.Runtime.Serialization.ISurrogateSelector
            {
                public virtual void AddSurrogate(System.Type type, System.Runtime.Serialization.StreamingContext context, System.Runtime.Serialization.ISerializationSurrogate surrogate) => throw null;
                public virtual void ChainSelector(System.Runtime.Serialization.ISurrogateSelector selector) => throw null;
                public SurrogateSelector() => throw null;
                public virtual System.Runtime.Serialization.ISurrogateSelector GetNextSelector() => throw null;
                public virtual System.Runtime.Serialization.ISerializationSurrogate GetSurrogate(System.Type type, System.Runtime.Serialization.StreamingContext context, out System.Runtime.Serialization.ISurrogateSelector selector) => throw null;
                public virtual void RemoveSurrogate(System.Type type, System.Runtime.Serialization.StreamingContext context) => throw null;
            }
        }
    }
}
