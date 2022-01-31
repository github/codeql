// This file contains auto-generated code.

namespace System
{
    namespace Runtime
    {
        namespace Serialization
        {
            // Generated from `System.Runtime.Serialization.Formatter` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class Formatter : System.Runtime.Serialization.IFormatter
            {
                public abstract System.Runtime.Serialization.SerializationBinder Binder { get; set; }
                public abstract System.Runtime.Serialization.StreamingContext Context { get; set; }
                public abstract object Deserialize(System.IO.Stream serializationStream);
                protected Formatter() => throw null;
                protected virtual object GetNext(out System.Int64 objID) => throw null;
                protected virtual System.Int64 Schedule(object obj) => throw null;
                public abstract void Serialize(System.IO.Stream serializationStream, object graph);
                public abstract System.Runtime.Serialization.ISurrogateSelector SurrogateSelector { get; set; }
                protected abstract void WriteArray(object obj, string name, System.Type memberType);
                protected abstract void WriteBoolean(bool val, string name);
                protected abstract void WriteByte(System.Byte val, string name);
                protected abstract void WriteChar(System.Char val, string name);
                protected abstract void WriteDateTime(System.DateTime val, string name);
                protected abstract void WriteDecimal(System.Decimal val, string name);
                protected abstract void WriteDouble(double val, string name);
                protected abstract void WriteInt16(System.Int16 val, string name);
                protected abstract void WriteInt32(int val, string name);
                protected abstract void WriteInt64(System.Int64 val, string name);
                protected virtual void WriteMember(string memberName, object data) => throw null;
                protected abstract void WriteObjectRef(object obj, string name, System.Type memberType);
                protected abstract void WriteSByte(System.SByte val, string name);
                protected abstract void WriteSingle(float val, string name);
                protected abstract void WriteTimeSpan(System.TimeSpan val, string name);
                protected abstract void WriteUInt16(System.UInt16 val, string name);
                protected abstract void WriteUInt32(System.UInt32 val, string name);
                protected abstract void WriteUInt64(System.UInt64 val, string name);
                protected abstract void WriteValueType(object obj, string name, System.Type memberType);
                protected System.Runtime.Serialization.ObjectIDGenerator m_idGenerator;
                protected System.Collections.Queue m_objectQueue;
            }

            // Generated from `System.Runtime.Serialization.FormatterConverter` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FormatterConverter : System.Runtime.Serialization.IFormatterConverter
            {
                public object Convert(object value, System.Type type) => throw null;
                public object Convert(object value, System.TypeCode typeCode) => throw null;
                public FormatterConverter() => throw null;
                public bool ToBoolean(object value) => throw null;
                public System.Byte ToByte(object value) => throw null;
                public System.Char ToChar(object value) => throw null;
                public System.DateTime ToDateTime(object value) => throw null;
                public System.Decimal ToDecimal(object value) => throw null;
                public double ToDouble(object value) => throw null;
                public System.Int16 ToInt16(object value) => throw null;
                public int ToInt32(object value) => throw null;
                public System.Int64 ToInt64(object value) => throw null;
                public System.SByte ToSByte(object value) => throw null;
                public float ToSingle(object value) => throw null;
                public string ToString(object value) => throw null;
                public System.UInt16 ToUInt16(object value) => throw null;
                public System.UInt32 ToUInt32(object value) => throw null;
                public System.UInt64 ToUInt64(object value) => throw null;
            }

            // Generated from `System.Runtime.Serialization.FormatterServices` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Runtime.Serialization.IFormatter` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface IFormatter
            {
                System.Runtime.Serialization.SerializationBinder Binder { get; set; }
                System.Runtime.Serialization.StreamingContext Context { get; set; }
                object Deserialize(System.IO.Stream serializationStream);
                void Serialize(System.IO.Stream serializationStream, object graph);
                System.Runtime.Serialization.ISurrogateSelector SurrogateSelector { get; set; }
            }

            // Generated from `System.Runtime.Serialization.ISerializationSurrogate` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISerializationSurrogate
            {
                void GetObjectData(object obj, System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context);
                object SetObjectData(object obj, System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context, System.Runtime.Serialization.ISurrogateSelector selector);
            }

            // Generated from `System.Runtime.Serialization.ISurrogateSelector` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISurrogateSelector
            {
                void ChainSelector(System.Runtime.Serialization.ISurrogateSelector selector);
                System.Runtime.Serialization.ISurrogateSelector GetNextSelector();
                System.Runtime.Serialization.ISerializationSurrogate GetSurrogate(System.Type type, System.Runtime.Serialization.StreamingContext context, out System.Runtime.Serialization.ISurrogateSelector selector);
            }

            // Generated from `System.Runtime.Serialization.ObjectIDGenerator` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ObjectIDGenerator
            {
                public virtual System.Int64 GetId(object obj, out bool firstTime) => throw null;
                public virtual System.Int64 HasId(object obj, out bool firstTime) => throw null;
                public ObjectIDGenerator() => throw null;
            }

            // Generated from `System.Runtime.Serialization.ObjectManager` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ObjectManager
            {
                public virtual void DoFixups() => throw null;
                public virtual object GetObject(System.Int64 objectID) => throw null;
                public ObjectManager(System.Runtime.Serialization.ISurrogateSelector selector, System.Runtime.Serialization.StreamingContext context) => throw null;
                public virtual void RaiseDeserializationEvent() => throw null;
                public void RaiseOnDeserializingEvent(object obj) => throw null;
                public virtual void RecordArrayElementFixup(System.Int64 arrayToBeFixed, int[] indices, System.Int64 objectRequired) => throw null;
                public virtual void RecordArrayElementFixup(System.Int64 arrayToBeFixed, int index, System.Int64 objectRequired) => throw null;
                public virtual void RecordDelayedFixup(System.Int64 objectToBeFixed, string memberName, System.Int64 objectRequired) => throw null;
                public virtual void RecordFixup(System.Int64 objectToBeFixed, System.Reflection.MemberInfo member, System.Int64 objectRequired) => throw null;
                public virtual void RegisterObject(object obj, System.Int64 objectID) => throw null;
                public void RegisterObject(object obj, System.Int64 objectID, System.Runtime.Serialization.SerializationInfo info) => throw null;
                public void RegisterObject(object obj, System.Int64 objectID, System.Runtime.Serialization.SerializationInfo info, System.Int64 idOfContainingObj, System.Reflection.MemberInfo member) => throw null;
                public void RegisterObject(object obj, System.Int64 objectID, System.Runtime.Serialization.SerializationInfo info, System.Int64 idOfContainingObj, System.Reflection.MemberInfo member, int[] arrayIndex) => throw null;
            }

            // Generated from `System.Runtime.Serialization.SerializationBinder` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class SerializationBinder
            {
                public virtual void BindToName(System.Type serializedType, out string assemblyName, out string typeName) => throw null;
                public abstract System.Type BindToType(string assemblyName, string typeName);
                protected SerializationBinder() => throw null;
            }

            // Generated from `System.Runtime.Serialization.SerializationObjectManager` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SerializationObjectManager
            {
                public void RaiseOnSerializedEvent() => throw null;
                public void RegisterObject(object obj) => throw null;
                public SerializationObjectManager(System.Runtime.Serialization.StreamingContext context) => throw null;
            }

            // Generated from `System.Runtime.Serialization.SurrogateSelector` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SurrogateSelector : System.Runtime.Serialization.ISurrogateSelector
            {
                public virtual void AddSurrogate(System.Type type, System.Runtime.Serialization.StreamingContext context, System.Runtime.Serialization.ISerializationSurrogate surrogate) => throw null;
                public virtual void ChainSelector(System.Runtime.Serialization.ISurrogateSelector selector) => throw null;
                public virtual System.Runtime.Serialization.ISurrogateSelector GetNextSelector() => throw null;
                public virtual System.Runtime.Serialization.ISerializationSurrogate GetSurrogate(System.Type type, System.Runtime.Serialization.StreamingContext context, out System.Runtime.Serialization.ISurrogateSelector selector) => throw null;
                public virtual void RemoveSurrogate(System.Type type, System.Runtime.Serialization.StreamingContext context) => throw null;
                public SurrogateSelector() => throw null;
            }

            namespace Formatters
            {
                // Generated from `System.Runtime.Serialization.Formatters.FormatterAssemblyStyle` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum FormatterAssemblyStyle
                {
                    Full,
                    Simple,
                }

                // Generated from `System.Runtime.Serialization.Formatters.FormatterTypeStyle` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum FormatterTypeStyle
                {
                    TypesAlways,
                    TypesWhenNeeded,
                    XsdString,
                }

                // Generated from `System.Runtime.Serialization.Formatters.IFieldInfo` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public interface IFieldInfo
                {
                    string[] FieldNames { get; set; }
                    System.Type[] FieldTypes { get; set; }
                }

                // Generated from `System.Runtime.Serialization.Formatters.TypeFilterLevel` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum TypeFilterLevel
                {
                    Full,
                    Low,
                }

                namespace Binary
                {
                    // Generated from `System.Runtime.Serialization.Formatters.Binary.BinaryFormatter` in `System.Runtime.Serialization.Formatters, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                    public class BinaryFormatter : System.Runtime.Serialization.IFormatter
                    {
                        public System.Runtime.Serialization.Formatters.FormatterAssemblyStyle AssemblyFormat { get => throw null; set => throw null; }
                        public BinaryFormatter() => throw null;
                        public BinaryFormatter(System.Runtime.Serialization.ISurrogateSelector selector, System.Runtime.Serialization.StreamingContext context) => throw null;
                        public System.Runtime.Serialization.SerializationBinder Binder { get => throw null; set => throw null; }
                        public System.Runtime.Serialization.StreamingContext Context { get => throw null; set => throw null; }
                        public object Deserialize(System.IO.Stream serializationStream) => throw null;
                        public System.Runtime.Serialization.Formatters.TypeFilterLevel FilterLevel { get => throw null; set => throw null; }
                        public void Serialize(System.IO.Stream serializationStream, object graph) => throw null;
                        public System.Runtime.Serialization.ISurrogateSelector SurrogateSelector { get => throw null; set => throw null; }
                        public System.Runtime.Serialization.Formatters.FormatterTypeStyle TypeFormat { get => throw null; set => throw null; }
                    }

                }
            }
        }
    }
}
