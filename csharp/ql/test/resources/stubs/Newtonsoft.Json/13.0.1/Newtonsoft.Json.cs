// This file contains auto-generated code.

namespace Newtonsoft
{
    namespace Json
    {
        // Generated from `Newtonsoft.Json.ConstructorHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum ConstructorHandling
        {
            AllowNonPublicDefaultConstructor,
            Default,
        }

        // Generated from `Newtonsoft.Json.DateFormatHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum DateFormatHandling
        {
            IsoDateFormat,
            MicrosoftDateFormat,
        }

        // Generated from `Newtonsoft.Json.DateParseHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum DateParseHandling
        {
            DateTime,
            DateTimeOffset,
            None,
        }

        // Generated from `Newtonsoft.Json.DateTimeZoneHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum DateTimeZoneHandling
        {
            Local,
            RoundtripKind,
            Unspecified,
            Utc,
        }

        // Generated from `Newtonsoft.Json.DefaultJsonNameTable` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class DefaultJsonNameTable : Newtonsoft.Json.JsonNameTable
        {
            public string Add(string key) => throw null;
            public DefaultJsonNameTable() => throw null;
            public override string Get(System.Char[] key, int start, int length) => throw null;
        }

        // Generated from `Newtonsoft.Json.DefaultValueHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        [System.Flags]
        public enum DefaultValueHandling
        {
            Ignore,
            IgnoreAndPopulate,
            Include,
            Populate,
        }

        // Generated from `Newtonsoft.Json.FloatFormatHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum FloatFormatHandling
        {
            DefaultValue,
            String,
            Symbol,
        }

        // Generated from `Newtonsoft.Json.FloatParseHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum FloatParseHandling
        {
            Decimal,
            Double,
        }

        // Generated from `Newtonsoft.Json.Formatting` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum Formatting
        {
            Indented,
            None,
        }

        // Generated from `Newtonsoft.Json.IArrayPool<>` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public interface IArrayPool<T>
        {
            T[] Rent(int minimumLength);
            void Return(T[] array);
        }

        // Generated from `Newtonsoft.Json.IJsonLineInfo` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public interface IJsonLineInfo
        {
            bool HasLineInfo();
            int LineNumber { get; }
            int LinePosition { get; }
        }

        // Generated from `Newtonsoft.Json.JsonArrayAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonArrayAttribute : Newtonsoft.Json.JsonContainerAttribute
        {
            public bool AllowNullItems { get => throw null; set => throw null; }
            public JsonArrayAttribute(string id) => throw null;
            public JsonArrayAttribute(bool allowNullItems) => throw null;
            public JsonArrayAttribute() => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonConstructorAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonConstructorAttribute : System.Attribute
        {
            public JsonConstructorAttribute() => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonContainerAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public abstract class JsonContainerAttribute : System.Attribute
        {
            public string Description { get => throw null; set => throw null; }
            public string Id { get => throw null; set => throw null; }
            public bool IsReference { get => throw null; set => throw null; }
            public object[] ItemConverterParameters { get => throw null; set => throw null; }
            public System.Type ItemConverterType { get => throw null; set => throw null; }
            public bool ItemIsReference { get => throw null; set => throw null; }
            public Newtonsoft.Json.ReferenceLoopHandling ItemReferenceLoopHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.TypeNameHandling ItemTypeNameHandling { get => throw null; set => throw null; }
            protected JsonContainerAttribute(string id) => throw null;
            protected JsonContainerAttribute() => throw null;
            public object[] NamingStrategyParameters { get => throw null; set => throw null; }
            public System.Type NamingStrategyType { get => throw null; set => throw null; }
            public string Title { get => throw null; set => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonConvert` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public static class JsonConvert
        {
            public static System.Func<Newtonsoft.Json.JsonSerializerSettings> DefaultSettings { get => throw null; set => throw null; }
            public static T DeserializeAnonymousType<T>(string value, T anonymousTypeObject, Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static T DeserializeAnonymousType<T>(string value, T anonymousTypeObject) => throw null;
            public static object DeserializeObject(string value, System.Type type, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
            public static object DeserializeObject(string value, System.Type type, Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static object DeserializeObject(string value, System.Type type) => throw null;
            public static object DeserializeObject(string value, Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static object DeserializeObject(string value) => throw null;
            public static T DeserializeObject<T>(string value, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
            public static T DeserializeObject<T>(string value, Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static T DeserializeObject<T>(string value) => throw null;
            public static System.Xml.Linq.XDocument DeserializeXNode(string value, string deserializeRootElementName, bool writeArrayAttribute, bool encodeSpecialCharacters) => throw null;
            public static System.Xml.Linq.XDocument DeserializeXNode(string value, string deserializeRootElementName, bool writeArrayAttribute) => throw null;
            public static System.Xml.Linq.XDocument DeserializeXNode(string value, string deserializeRootElementName) => throw null;
            public static System.Xml.Linq.XDocument DeserializeXNode(string value) => throw null;
            public static System.Xml.XmlDocument DeserializeXmlNode(string value, string deserializeRootElementName, bool writeArrayAttribute, bool encodeSpecialCharacters) => throw null;
            public static System.Xml.XmlDocument DeserializeXmlNode(string value, string deserializeRootElementName, bool writeArrayAttribute) => throw null;
            public static System.Xml.XmlDocument DeserializeXmlNode(string value, string deserializeRootElementName) => throw null;
            public static System.Xml.XmlDocument DeserializeXmlNode(string value) => throw null;
            public static string False;
            public static string NaN;
            public static string NegativeInfinity;
            public static string Null;
            public static void PopulateObject(string value, object target, Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static void PopulateObject(string value, object target) => throw null;
            public static string PositiveInfinity;
            public static string SerializeObject(object value, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
            public static string SerializeObject(object value, System.Type type, Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static string SerializeObject(object value, System.Type type, Newtonsoft.Json.Formatting formatting, Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static string SerializeObject(object value, Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static string SerializeObject(object value, Newtonsoft.Json.Formatting formatting, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
            public static string SerializeObject(object value, Newtonsoft.Json.Formatting formatting, Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static string SerializeObject(object value, Newtonsoft.Json.Formatting formatting) => throw null;
            public static string SerializeObject(object value) => throw null;
            public static string SerializeXNode(System.Xml.Linq.XObject node, Newtonsoft.Json.Formatting formatting, bool omitRootObject) => throw null;
            public static string SerializeXNode(System.Xml.Linq.XObject node, Newtonsoft.Json.Formatting formatting) => throw null;
            public static string SerializeXNode(System.Xml.Linq.XObject node) => throw null;
            public static string SerializeXmlNode(System.Xml.XmlNode node, Newtonsoft.Json.Formatting formatting, bool omitRootObject) => throw null;
            public static string SerializeXmlNode(System.Xml.XmlNode node, Newtonsoft.Json.Formatting formatting) => throw null;
            public static string SerializeXmlNode(System.Xml.XmlNode node) => throw null;
            public static string ToString(string value, System.Char delimiter, Newtonsoft.Json.StringEscapeHandling stringEscapeHandling) => throw null;
            public static string ToString(string value, System.Char delimiter) => throw null;
            public static string ToString(string value) => throw null;
            public static string ToString(object value) => throw null;
            public static string ToString(int value) => throw null;
            public static string ToString(float value) => throw null;
            public static string ToString(double value) => throw null;
            public static string ToString(bool value) => throw null;
            public static string ToString(System.Uri value) => throw null;
            public static string ToString(System.UInt64 value) => throw null;
            public static string ToString(System.UInt32 value) => throw null;
            public static string ToString(System.UInt16 value) => throw null;
            public static string ToString(System.TimeSpan value) => throw null;
            public static string ToString(System.SByte value) => throw null;
            public static string ToString(System.Int64 value) => throw null;
            public static string ToString(System.Int16 value) => throw null;
            public static string ToString(System.Guid value) => throw null;
            public static string ToString(System.Enum value) => throw null;
            public static string ToString(System.Decimal value) => throw null;
            public static string ToString(System.DateTimeOffset value, Newtonsoft.Json.DateFormatHandling format) => throw null;
            public static string ToString(System.DateTimeOffset value) => throw null;
            public static string ToString(System.DateTime value, Newtonsoft.Json.DateFormatHandling format, Newtonsoft.Json.DateTimeZoneHandling timeZoneHandling) => throw null;
            public static string ToString(System.DateTime value) => throw null;
            public static string ToString(System.Char value) => throw null;
            public static string ToString(System.Byte value) => throw null;
            public static string True;
            public static string Undefined;
        }

        // Generated from `Newtonsoft.Json.JsonConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public abstract class JsonConverter
        {
            public abstract bool CanConvert(System.Type objectType);
            public virtual bool CanRead { get => throw null; }
            public virtual bool CanWrite { get => throw null; }
            protected JsonConverter() => throw null;
            public abstract object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer);
            public abstract void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer);
        }

        // Generated from `Newtonsoft.Json.JsonConverter<>` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public abstract class JsonConverter<T> : Newtonsoft.Json.JsonConverter
        {
            public override bool CanConvert(System.Type objectType) => throw null;
            protected JsonConverter() => throw null;
            public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            public abstract T ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, T existingValue, bool hasExistingValue, Newtonsoft.Json.JsonSerializer serializer);
            public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            public abstract void WriteJson(Newtonsoft.Json.JsonWriter writer, T value, Newtonsoft.Json.JsonSerializer serializer);
        }

        // Generated from `Newtonsoft.Json.JsonConverterAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonConverterAttribute : System.Attribute
        {
            public object[] ConverterParameters { get => throw null; }
            public System.Type ConverterType { get => throw null; }
            public JsonConverterAttribute(System.Type converterType, params object[] converterParameters) => throw null;
            public JsonConverterAttribute(System.Type converterType) => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonConverterCollection` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonConverterCollection : System.Collections.ObjectModel.Collection<Newtonsoft.Json.JsonConverter>
        {
            public JsonConverterCollection() => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonDictionaryAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonDictionaryAttribute : Newtonsoft.Json.JsonContainerAttribute
        {
            public JsonDictionaryAttribute(string id) => throw null;
            public JsonDictionaryAttribute() => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonException` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonException : System.Exception
        {
            public JsonException(string message, System.Exception innerException) => throw null;
            public JsonException(string message) => throw null;
            public JsonException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public JsonException() => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonExtensionDataAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonExtensionDataAttribute : System.Attribute
        {
            public JsonExtensionDataAttribute() => throw null;
            public bool ReadData { get => throw null; set => throw null; }
            public bool WriteData { get => throw null; set => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonIgnoreAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonIgnoreAttribute : System.Attribute
        {
            public JsonIgnoreAttribute() => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonNameTable` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public abstract class JsonNameTable
        {
            public abstract string Get(System.Char[] key, int start, int length);
            protected JsonNameTable() => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonObjectAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonObjectAttribute : Newtonsoft.Json.JsonContainerAttribute
        {
            public Newtonsoft.Json.NullValueHandling ItemNullValueHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.Required ItemRequired { get => throw null; set => throw null; }
            public JsonObjectAttribute(string id) => throw null;
            public JsonObjectAttribute(Newtonsoft.Json.MemberSerialization memberSerialization) => throw null;
            public JsonObjectAttribute() => throw null;
            public Newtonsoft.Json.MemberSerialization MemberSerialization { get => throw null; set => throw null; }
            public Newtonsoft.Json.MissingMemberHandling MissingMemberHandling { get => throw null; set => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonPropertyAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonPropertyAttribute : System.Attribute
        {
            public Newtonsoft.Json.DefaultValueHandling DefaultValueHandling { get => throw null; set => throw null; }
            public bool IsReference { get => throw null; set => throw null; }
            public object[] ItemConverterParameters { get => throw null; set => throw null; }
            public System.Type ItemConverterType { get => throw null; set => throw null; }
            public bool ItemIsReference { get => throw null; set => throw null; }
            public Newtonsoft.Json.ReferenceLoopHandling ItemReferenceLoopHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.TypeNameHandling ItemTypeNameHandling { get => throw null; set => throw null; }
            public JsonPropertyAttribute(string propertyName) => throw null;
            public JsonPropertyAttribute() => throw null;
            public object[] NamingStrategyParameters { get => throw null; set => throw null; }
            public System.Type NamingStrategyType { get => throw null; set => throw null; }
            public Newtonsoft.Json.NullValueHandling NullValueHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.ObjectCreationHandling ObjectCreationHandling { get => throw null; set => throw null; }
            public int Order { get => throw null; set => throw null; }
            public string PropertyName { get => throw null; set => throw null; }
            public Newtonsoft.Json.ReferenceLoopHandling ReferenceLoopHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.Required Required { get => throw null; set => throw null; }
            public Newtonsoft.Json.TypeNameHandling TypeNameHandling { get => throw null; set => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonReader` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public abstract class JsonReader : System.IDisposable
        {
            public virtual void Close() => throw null;
            public bool CloseInput { get => throw null; set => throw null; }
            public System.Globalization.CultureInfo Culture { get => throw null; set => throw null; }
            protected Newtonsoft.Json.JsonReader.State CurrentState { get => throw null; }
            public string DateFormatString { get => throw null; set => throw null; }
            public Newtonsoft.Json.DateParseHandling DateParseHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.DateTimeZoneHandling DateTimeZoneHandling { get => throw null; set => throw null; }
            public virtual int Depth { get => throw null; }
            void System.IDisposable.Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public Newtonsoft.Json.FloatParseHandling FloatParseHandling { get => throw null; set => throw null; }
            protected JsonReader() => throw null;
            public int? MaxDepth { get => throw null; set => throw null; }
            public virtual string Path { get => throw null; }
            public virtual System.Char QuoteChar { get => throw null; set => throw null; }
            public abstract bool Read();
            public virtual bool? ReadAsBoolean() => throw null;
            public virtual System.Threading.Tasks.Task<bool?> ReadAsBooleanAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Byte[] ReadAsBytes() => throw null;
            public virtual System.Threading.Tasks.Task<System.Byte[]> ReadAsBytesAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.DateTime? ReadAsDateTime() => throw null;
            public virtual System.Threading.Tasks.Task<System.DateTime?> ReadAsDateTimeAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.DateTimeOffset? ReadAsDateTimeOffset() => throw null;
            public virtual System.Threading.Tasks.Task<System.DateTimeOffset?> ReadAsDateTimeOffsetAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Decimal? ReadAsDecimal() => throw null;
            public virtual System.Threading.Tasks.Task<System.Decimal?> ReadAsDecimalAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual double? ReadAsDouble() => throw null;
            public virtual System.Threading.Tasks.Task<double?> ReadAsDoubleAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual int? ReadAsInt32() => throw null;
            public virtual System.Threading.Tasks.Task<int?> ReadAsInt32Async(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual string ReadAsString() => throw null;
            public virtual System.Threading.Tasks.Task<string> ReadAsStringAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task<bool> ReadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected void SetStateBasedOnCurrent() => throw null;
            protected void SetToken(Newtonsoft.Json.JsonToken newToken, object value, bool updateIndex) => throw null;
            protected void SetToken(Newtonsoft.Json.JsonToken newToken, object value) => throw null;
            protected void SetToken(Newtonsoft.Json.JsonToken newToken) => throw null;
            public void Skip() => throw null;
            public System.Threading.Tasks.Task SkipAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            // Generated from `Newtonsoft.Json.JsonReader+State` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            protected internal enum State
            {
                Array,
                ArrayStart,
                Closed,
                Complete,
                Constructor,
                ConstructorStart,
                Error,
                Finished,
                Object,
                ObjectStart,
                PostValue,
                Property,
                Start,
            }


            public bool SupportMultipleContent { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.JsonToken TokenType { get => throw null; }
            public virtual object Value { get => throw null; }
            public virtual System.Type ValueType { get => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonReaderException` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonReaderException : Newtonsoft.Json.JsonException
        {
            public JsonReaderException(string message, string path, int lineNumber, int linePosition, System.Exception innerException) => throw null;
            public JsonReaderException(string message, System.Exception innerException) => throw null;
            public JsonReaderException(string message) => throw null;
            public JsonReaderException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public JsonReaderException() => throw null;
            public int LineNumber { get => throw null; }
            public int LinePosition { get => throw null; }
            public string Path { get => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonRequiredAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonRequiredAttribute : System.Attribute
        {
            public JsonRequiredAttribute() => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonSerializationException` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonSerializationException : Newtonsoft.Json.JsonException
        {
            public JsonSerializationException(string message, string path, int lineNumber, int linePosition, System.Exception innerException) => throw null;
            public JsonSerializationException(string message, System.Exception innerException) => throw null;
            public JsonSerializationException(string message) => throw null;
            public JsonSerializationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public JsonSerializationException() => throw null;
            public int LineNumber { get => throw null; }
            public int LinePosition { get => throw null; }
            public string Path { get => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonSerializer` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonSerializer
        {
            public virtual System.Runtime.Serialization.SerializationBinder Binder { get => throw null; set => throw null; }
            public virtual bool CheckAdditionalContent { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.ConstructorHandling ConstructorHandling { get => throw null; set => throw null; }
            public virtual System.Runtime.Serialization.StreamingContext Context { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.Serialization.IContractResolver ContractResolver { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.JsonConverterCollection Converters { get => throw null; }
            public static Newtonsoft.Json.JsonSerializer Create(Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static Newtonsoft.Json.JsonSerializer Create() => throw null;
            public static Newtonsoft.Json.JsonSerializer CreateDefault(Newtonsoft.Json.JsonSerializerSettings settings) => throw null;
            public static Newtonsoft.Json.JsonSerializer CreateDefault() => throw null;
            public virtual System.Globalization.CultureInfo Culture { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.DateFormatHandling DateFormatHandling { get => throw null; set => throw null; }
            public virtual string DateFormatString { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.DateParseHandling DateParseHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.DateTimeZoneHandling DateTimeZoneHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.DefaultValueHandling DefaultValueHandling { get => throw null; set => throw null; }
            public object Deserialize(System.IO.TextReader reader, System.Type objectType) => throw null;
            public object Deserialize(Newtonsoft.Json.JsonReader reader, System.Type objectType) => throw null;
            public object Deserialize(Newtonsoft.Json.JsonReader reader) => throw null;
            public T Deserialize<T>(Newtonsoft.Json.JsonReader reader) => throw null;
            public virtual System.Collections.IEqualityComparer EqualityComparer { get => throw null; set => throw null; }
            public virtual event System.EventHandler<Newtonsoft.Json.Serialization.ErrorEventArgs> Error;
            public virtual Newtonsoft.Json.FloatFormatHandling FloatFormatHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.FloatParseHandling FloatParseHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.Formatting Formatting { get => throw null; set => throw null; }
            public JsonSerializer() => throw null;
            public virtual int? MaxDepth { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.MetadataPropertyHandling MetadataPropertyHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.MissingMemberHandling MissingMemberHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.NullValueHandling NullValueHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.ObjectCreationHandling ObjectCreationHandling { get => throw null; set => throw null; }
            public void Populate(System.IO.TextReader reader, object target) => throw null;
            public void Populate(Newtonsoft.Json.JsonReader reader, object target) => throw null;
            public virtual Newtonsoft.Json.PreserveReferencesHandling PreserveReferencesHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.ReferenceLoopHandling ReferenceLoopHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.Serialization.IReferenceResolver ReferenceResolver { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.Serialization.ISerializationBinder SerializationBinder { get => throw null; set => throw null; }
            public void Serialize(System.IO.TextWriter textWriter, object value, System.Type objectType) => throw null;
            public void Serialize(System.IO.TextWriter textWriter, object value) => throw null;
            public void Serialize(Newtonsoft.Json.JsonWriter jsonWriter, object value, System.Type objectType) => throw null;
            public void Serialize(Newtonsoft.Json.JsonWriter jsonWriter, object value) => throw null;
            public virtual Newtonsoft.Json.StringEscapeHandling StringEscapeHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.Serialization.ITraceWriter TraceWriter { get => throw null; set => throw null; }
            public virtual System.Runtime.Serialization.Formatters.FormatterAssemblyStyle TypeNameAssemblyFormat { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.TypeNameAssemblyFormatHandling TypeNameAssemblyFormatHandling { get => throw null; set => throw null; }
            public virtual Newtonsoft.Json.TypeNameHandling TypeNameHandling { get => throw null; set => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonSerializerSettings` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonSerializerSettings
        {
            public System.Runtime.Serialization.SerializationBinder Binder { get => throw null; set => throw null; }
            public bool CheckAdditionalContent { get => throw null; set => throw null; }
            public Newtonsoft.Json.ConstructorHandling ConstructorHandling { get => throw null; set => throw null; }
            public System.Runtime.Serialization.StreamingContext Context { get => throw null; set => throw null; }
            public Newtonsoft.Json.Serialization.IContractResolver ContractResolver { get => throw null; set => throw null; }
            public System.Collections.Generic.IList<Newtonsoft.Json.JsonConverter> Converters { get => throw null; set => throw null; }
            public System.Globalization.CultureInfo Culture { get => throw null; set => throw null; }
            public Newtonsoft.Json.DateFormatHandling DateFormatHandling { get => throw null; set => throw null; }
            public string DateFormatString { get => throw null; set => throw null; }
            public Newtonsoft.Json.DateParseHandling DateParseHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.DateTimeZoneHandling DateTimeZoneHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.DefaultValueHandling DefaultValueHandling { get => throw null; set => throw null; }
            public System.Collections.IEqualityComparer EqualityComparer { get => throw null; set => throw null; }
            public System.EventHandler<Newtonsoft.Json.Serialization.ErrorEventArgs> Error { get => throw null; set => throw null; }
            public Newtonsoft.Json.FloatFormatHandling FloatFormatHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.FloatParseHandling FloatParseHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.Formatting Formatting { get => throw null; set => throw null; }
            public JsonSerializerSettings() => throw null;
            public int? MaxDepth { get => throw null; set => throw null; }
            public Newtonsoft.Json.MetadataPropertyHandling MetadataPropertyHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.MissingMemberHandling MissingMemberHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.NullValueHandling NullValueHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.ObjectCreationHandling ObjectCreationHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.PreserveReferencesHandling PreserveReferencesHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.ReferenceLoopHandling ReferenceLoopHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.Serialization.IReferenceResolver ReferenceResolver { get => throw null; set => throw null; }
            public System.Func<Newtonsoft.Json.Serialization.IReferenceResolver> ReferenceResolverProvider { get => throw null; set => throw null; }
            public Newtonsoft.Json.Serialization.ISerializationBinder SerializationBinder { get => throw null; set => throw null; }
            public Newtonsoft.Json.StringEscapeHandling StringEscapeHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.Serialization.ITraceWriter TraceWriter { get => throw null; set => throw null; }
            public System.Runtime.Serialization.Formatters.FormatterAssemblyStyle TypeNameAssemblyFormat { get => throw null; set => throw null; }
            public Newtonsoft.Json.TypeNameAssemblyFormatHandling TypeNameAssemblyFormatHandling { get => throw null; set => throw null; }
            public Newtonsoft.Json.TypeNameHandling TypeNameHandling { get => throw null; set => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonTextReader` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonTextReader : Newtonsoft.Json.JsonReader, Newtonsoft.Json.IJsonLineInfo
        {
            public Newtonsoft.Json.IArrayPool<System.Char> ArrayPool { get => throw null; set => throw null; }
            public override void Close() => throw null;
            public bool HasLineInfo() => throw null;
            public JsonTextReader(System.IO.TextReader reader) => throw null;
            public int LineNumber { get => throw null; }
            public int LinePosition { get => throw null; }
            public Newtonsoft.Json.JsonNameTable PropertyNameTable { get => throw null; set => throw null; }
            public override bool Read() => throw null;
            public override bool? ReadAsBoolean() => throw null;
            public override System.Threading.Tasks.Task<bool?> ReadAsBooleanAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Byte[] ReadAsBytes() => throw null;
            public override System.Threading.Tasks.Task<System.Byte[]> ReadAsBytesAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.DateTime? ReadAsDateTime() => throw null;
            public override System.Threading.Tasks.Task<System.DateTime?> ReadAsDateTimeAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.DateTimeOffset? ReadAsDateTimeOffset() => throw null;
            public override System.Threading.Tasks.Task<System.DateTimeOffset?> ReadAsDateTimeOffsetAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Decimal? ReadAsDecimal() => throw null;
            public override System.Threading.Tasks.Task<System.Decimal?> ReadAsDecimalAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override double? ReadAsDouble() => throw null;
            public override System.Threading.Tasks.Task<double?> ReadAsDoubleAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override int? ReadAsInt32() => throw null;
            public override System.Threading.Tasks.Task<int?> ReadAsInt32Async(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override string ReadAsString() => throw null;
            public override System.Threading.Tasks.Task<string> ReadAsStringAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task<bool> ReadAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonTextWriter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonTextWriter : Newtonsoft.Json.JsonWriter
        {
            public Newtonsoft.Json.IArrayPool<System.Char> ArrayPool { get => throw null; set => throw null; }
            public override void Close() => throw null;
            public override System.Threading.Tasks.Task CloseAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void Flush() => throw null;
            public override System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public System.Char IndentChar { get => throw null; set => throw null; }
            public int Indentation { get => throw null; set => throw null; }
            public JsonTextWriter(System.IO.TextWriter textWriter) => throw null;
            public System.Char QuoteChar { get => throw null; set => throw null; }
            public bool QuoteName { get => throw null; set => throw null; }
            public override void WriteComment(string text) => throw null;
            public override System.Threading.Tasks.Task WriteCommentAsync(string text, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected override void WriteEnd(Newtonsoft.Json.JsonToken token) => throw null;
            public override System.Threading.Tasks.Task WriteEndArrayAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteEndAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected override System.Threading.Tasks.Task WriteEndAsync(Newtonsoft.Json.JsonToken token, System.Threading.CancellationToken cancellationToken) => throw null;
            public override System.Threading.Tasks.Task WriteEndConstructorAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteEndObjectAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected override void WriteIndent() => throw null;
            protected override System.Threading.Tasks.Task WriteIndentAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            protected override void WriteIndentSpace() => throw null;
            protected override System.Threading.Tasks.Task WriteIndentSpaceAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public override void WriteNull() => throw null;
            public override System.Threading.Tasks.Task WriteNullAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WritePropertyName(string name, bool escape) => throw null;
            public override void WritePropertyName(string name) => throw null;
            public override System.Threading.Tasks.Task WritePropertyNameAsync(string name, bool escape, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WritePropertyNameAsync(string name, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteRaw(string json) => throw null;
            public override System.Threading.Tasks.Task WriteRawAsync(string json, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteRawValueAsync(string json, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteStartArray() => throw null;
            public override System.Threading.Tasks.Task WriteStartArrayAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteStartConstructor(string name) => throw null;
            public override System.Threading.Tasks.Task WriteStartConstructorAsync(string name, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteStartObject() => throw null;
            public override System.Threading.Tasks.Task WriteStartObjectAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteUndefined() => throw null;
            public override System.Threading.Tasks.Task WriteUndefinedAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteValue(string value) => throw null;
            public override void WriteValue(object value) => throw null;
            public override void WriteValue(int value) => throw null;
            public override void WriteValue(float? value) => throw null;
            public override void WriteValue(float value) => throw null;
            public override void WriteValue(double? value) => throw null;
            public override void WriteValue(double value) => throw null;
            public override void WriteValue(bool value) => throw null;
            public override void WriteValue(System.Uri value) => throw null;
            public override void WriteValue(System.UInt64 value) => throw null;
            public override void WriteValue(System.UInt32 value) => throw null;
            public override void WriteValue(System.UInt16 value) => throw null;
            public override void WriteValue(System.TimeSpan value) => throw null;
            public override void WriteValue(System.SByte value) => throw null;
            public override void WriteValue(System.Int64 value) => throw null;
            public override void WriteValue(System.Int16 value) => throw null;
            public override void WriteValue(System.Guid value) => throw null;
            public override void WriteValue(System.Decimal value) => throw null;
            public override void WriteValue(System.DateTimeOffset value) => throw null;
            public override void WriteValue(System.DateTime value) => throw null;
            public override void WriteValue(System.Char value) => throw null;
            public override void WriteValue(System.Byte[] value) => throw null;
            public override void WriteValue(System.Byte value) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(string value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(object value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(int? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(int value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(float? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(float value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(double? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(double value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(bool? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(bool value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Uri value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.UInt64? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.UInt64 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.UInt32? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.UInt32 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.UInt16? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.UInt16 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.TimeSpan? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.TimeSpan value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.SByte? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.SByte value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Int64? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Int64 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Int16? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Int16 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Guid? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Guid value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Decimal? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Decimal value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.DateTimeOffset? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.DateTimeOffset value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.DateTime? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.DateTime value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Char? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Char value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Byte[] value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Byte? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteValueAsync(System.Byte value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected override void WriteValueDelimiter() => throw null;
            protected override System.Threading.Tasks.Task WriteValueDelimiterAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public override void WriteWhitespace(string ws) => throw null;
            public override System.Threading.Tasks.Task WriteWhitespaceAsync(string ws, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonToken` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum JsonToken
        {
            Boolean,
            Bytes,
            Comment,
            Date,
            EndArray,
            EndConstructor,
            EndObject,
            Float,
            Integer,
            None,
            Null,
            PropertyName,
            Raw,
            StartArray,
            StartConstructor,
            StartObject,
            String,
            Undefined,
        }

        // Generated from `Newtonsoft.Json.JsonValidatingReader` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonValidatingReader : Newtonsoft.Json.JsonReader, Newtonsoft.Json.IJsonLineInfo
        {
            public override void Close() => throw null;
            public override int Depth { get => throw null; }
            bool Newtonsoft.Json.IJsonLineInfo.HasLineInfo() => throw null;
            public JsonValidatingReader(Newtonsoft.Json.JsonReader reader) => throw null;
            int Newtonsoft.Json.IJsonLineInfo.LineNumber { get => throw null; }
            int Newtonsoft.Json.IJsonLineInfo.LinePosition { get => throw null; }
            public override string Path { get => throw null; }
            public override System.Char QuoteChar { get => throw null; set => throw null; }
            public override bool Read() => throw null;
            public override bool? ReadAsBoolean() => throw null;
            public override System.Byte[] ReadAsBytes() => throw null;
            public override System.DateTime? ReadAsDateTime() => throw null;
            public override System.DateTimeOffset? ReadAsDateTimeOffset() => throw null;
            public override System.Decimal? ReadAsDecimal() => throw null;
            public override double? ReadAsDouble() => throw null;
            public override int? ReadAsInt32() => throw null;
            public override string ReadAsString() => throw null;
            public Newtonsoft.Json.JsonReader Reader { get => throw null; }
            public Newtonsoft.Json.Schema.JsonSchema Schema { get => throw null; set => throw null; }
            public override Newtonsoft.Json.JsonToken TokenType { get => throw null; }
            public event Newtonsoft.Json.Schema.ValidationEventHandler ValidationEventHandler;
            public override object Value { get => throw null; }
            public override System.Type ValueType { get => throw null; }
        }

        // Generated from `Newtonsoft.Json.JsonWriter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public abstract class JsonWriter : System.IDisposable
        {
            public bool AutoCompleteOnClose { get => throw null; set => throw null; }
            public virtual void Close() => throw null;
            public virtual System.Threading.Tasks.Task CloseAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public bool CloseOutput { get => throw null; set => throw null; }
            public System.Globalization.CultureInfo Culture { get => throw null; set => throw null; }
            public Newtonsoft.Json.DateFormatHandling DateFormatHandling { get => throw null; set => throw null; }
            public string DateFormatString { get => throw null; set => throw null; }
            public Newtonsoft.Json.DateTimeZoneHandling DateTimeZoneHandling { get => throw null; set => throw null; }
            void System.IDisposable.Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            public Newtonsoft.Json.FloatFormatHandling FloatFormatHandling { get => throw null; set => throw null; }
            public abstract void Flush();
            public virtual System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public Newtonsoft.Json.Formatting Formatting { get => throw null; set => throw null; }
            protected JsonWriter() => throw null;
            public string Path { get => throw null; }
            protected void SetWriteState(Newtonsoft.Json.JsonToken token, object value) => throw null;
            protected System.Threading.Tasks.Task SetWriteStateAsync(Newtonsoft.Json.JsonToken token, object value, System.Threading.CancellationToken cancellationToken) => throw null;
            public Newtonsoft.Json.StringEscapeHandling StringEscapeHandling { get => throw null; set => throw null; }
            protected internal int Top { get => throw null; }
            public virtual void WriteComment(string text) => throw null;
            public virtual System.Threading.Tasks.Task WriteCommentAsync(string text, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteEnd() => throw null;
            protected virtual void WriteEnd(Newtonsoft.Json.JsonToken token) => throw null;
            public virtual void WriteEndArray() => throw null;
            public virtual System.Threading.Tasks.Task WriteEndArrayAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteEndAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected virtual System.Threading.Tasks.Task WriteEndAsync(Newtonsoft.Json.JsonToken token, System.Threading.CancellationToken cancellationToken) => throw null;
            public virtual void WriteEndConstructor() => throw null;
            public virtual System.Threading.Tasks.Task WriteEndConstructorAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteEndObject() => throw null;
            public virtual System.Threading.Tasks.Task WriteEndObjectAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected virtual void WriteIndent() => throw null;
            protected virtual System.Threading.Tasks.Task WriteIndentAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            protected virtual void WriteIndentSpace() => throw null;
            protected virtual System.Threading.Tasks.Task WriteIndentSpaceAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public virtual void WriteNull() => throw null;
            public virtual System.Threading.Tasks.Task WriteNullAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WritePropertyName(string name, bool escape) => throw null;
            public virtual void WritePropertyName(string name) => throw null;
            public virtual System.Threading.Tasks.Task WritePropertyNameAsync(string name, bool escape, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WritePropertyNameAsync(string name, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteRaw(string json) => throw null;
            public virtual System.Threading.Tasks.Task WriteRawAsync(string json, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteRawValue(string json) => throw null;
            public virtual System.Threading.Tasks.Task WriteRawValueAsync(string json, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteStartArray() => throw null;
            public virtual System.Threading.Tasks.Task WriteStartArrayAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteStartConstructor(string name) => throw null;
            public virtual System.Threading.Tasks.Task WriteStartConstructorAsync(string name, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteStartObject() => throw null;
            public virtual System.Threading.Tasks.Task WriteStartObjectAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public Newtonsoft.Json.WriteState WriteState { get => throw null; }
            public void WriteToken(Newtonsoft.Json.JsonToken token, object value) => throw null;
            public void WriteToken(Newtonsoft.Json.JsonToken token) => throw null;
            public void WriteToken(Newtonsoft.Json.JsonReader reader, bool writeChildren) => throw null;
            public void WriteToken(Newtonsoft.Json.JsonReader reader) => throw null;
            public System.Threading.Tasks.Task WriteTokenAsync(Newtonsoft.Json.JsonToken token, object value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public System.Threading.Tasks.Task WriteTokenAsync(Newtonsoft.Json.JsonToken token, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public System.Threading.Tasks.Task WriteTokenAsync(Newtonsoft.Json.JsonReader reader, bool writeChildren, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public System.Threading.Tasks.Task WriteTokenAsync(Newtonsoft.Json.JsonReader reader, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteUndefined() => throw null;
            public virtual System.Threading.Tasks.Task WriteUndefinedAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual void WriteValue(string value) => throw null;
            public virtual void WriteValue(object value) => throw null;
            public virtual void WriteValue(int? value) => throw null;
            public virtual void WriteValue(int value) => throw null;
            public virtual void WriteValue(float? value) => throw null;
            public virtual void WriteValue(float value) => throw null;
            public virtual void WriteValue(double? value) => throw null;
            public virtual void WriteValue(double value) => throw null;
            public virtual void WriteValue(bool? value) => throw null;
            public virtual void WriteValue(bool value) => throw null;
            public virtual void WriteValue(System.Uri value) => throw null;
            public virtual void WriteValue(System.UInt64? value) => throw null;
            public virtual void WriteValue(System.UInt64 value) => throw null;
            public virtual void WriteValue(System.UInt32? value) => throw null;
            public virtual void WriteValue(System.UInt32 value) => throw null;
            public virtual void WriteValue(System.UInt16? value) => throw null;
            public virtual void WriteValue(System.UInt16 value) => throw null;
            public virtual void WriteValue(System.TimeSpan? value) => throw null;
            public virtual void WriteValue(System.TimeSpan value) => throw null;
            public virtual void WriteValue(System.SByte? value) => throw null;
            public virtual void WriteValue(System.SByte value) => throw null;
            public virtual void WriteValue(System.Int64? value) => throw null;
            public virtual void WriteValue(System.Int64 value) => throw null;
            public virtual void WriteValue(System.Int16? value) => throw null;
            public virtual void WriteValue(System.Int16 value) => throw null;
            public virtual void WriteValue(System.Guid? value) => throw null;
            public virtual void WriteValue(System.Guid value) => throw null;
            public virtual void WriteValue(System.Decimal? value) => throw null;
            public virtual void WriteValue(System.Decimal value) => throw null;
            public virtual void WriteValue(System.DateTimeOffset? value) => throw null;
            public virtual void WriteValue(System.DateTimeOffset value) => throw null;
            public virtual void WriteValue(System.DateTime? value) => throw null;
            public virtual void WriteValue(System.DateTime value) => throw null;
            public virtual void WriteValue(System.Char? value) => throw null;
            public virtual void WriteValue(System.Char value) => throw null;
            public virtual void WriteValue(System.Byte[] value) => throw null;
            public virtual void WriteValue(System.Byte? value) => throw null;
            public virtual void WriteValue(System.Byte value) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(string value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(object value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(int? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(int value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(float? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(float value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(double? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(double value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(bool? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(bool value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Uri value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.UInt64? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.UInt64 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.UInt32? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.UInt32 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.UInt16? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.UInt16 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.TimeSpan? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.TimeSpan value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.SByte? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.SByte value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Int64? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Int64 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Int16? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Int16 value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Guid? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Guid value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Decimal? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Decimal value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.DateTimeOffset? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.DateTimeOffset value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.DateTime? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.DateTime value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Char? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Char value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Byte[] value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Byte? value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            public virtual System.Threading.Tasks.Task WriteValueAsync(System.Byte value, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected virtual void WriteValueDelimiter() => throw null;
            protected virtual System.Threading.Tasks.Task WriteValueDelimiterAsync(System.Threading.CancellationToken cancellationToken) => throw null;
            public virtual void WriteWhitespace(string ws) => throw null;
            public virtual System.Threading.Tasks.Task WriteWhitespaceAsync(string ws, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
        }

        // Generated from `Newtonsoft.Json.JsonWriterException` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public class JsonWriterException : Newtonsoft.Json.JsonException
        {
            public JsonWriterException(string message, string path, System.Exception innerException) => throw null;
            public JsonWriterException(string message, System.Exception innerException) => throw null;
            public JsonWriterException(string message) => throw null;
            public JsonWriterException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public JsonWriterException() => throw null;
            public string Path { get => throw null; }
        }

        // Generated from `Newtonsoft.Json.MemberSerialization` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum MemberSerialization
        {
            Fields,
            OptIn,
            OptOut,
        }

        // Generated from `Newtonsoft.Json.MetadataPropertyHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum MetadataPropertyHandling
        {
            Default,
            Ignore,
            ReadAhead,
        }

        // Generated from `Newtonsoft.Json.MissingMemberHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum MissingMemberHandling
        {
            Error,
            Ignore,
        }

        // Generated from `Newtonsoft.Json.NullValueHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum NullValueHandling
        {
            Ignore,
            Include,
        }

        // Generated from `Newtonsoft.Json.ObjectCreationHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum ObjectCreationHandling
        {
            Auto,
            Replace,
            Reuse,
        }

        // Generated from `Newtonsoft.Json.PreserveReferencesHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        [System.Flags]
        public enum PreserveReferencesHandling
        {
            All,
            Arrays,
            None,
            Objects,
        }

        // Generated from `Newtonsoft.Json.ReferenceLoopHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum ReferenceLoopHandling
        {
            Error,
            Ignore,
            Serialize,
        }

        // Generated from `Newtonsoft.Json.Required` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum Required
        {
            AllowNull,
            Always,
            Default,
            DisallowNull,
        }

        // Generated from `Newtonsoft.Json.StringEscapeHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum StringEscapeHandling
        {
            Default,
            EscapeHtml,
            EscapeNonAscii,
        }

        // Generated from `Newtonsoft.Json.TypeNameAssemblyFormatHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum TypeNameAssemblyFormatHandling
        {
            Full,
            Simple,
        }

        // Generated from `Newtonsoft.Json.TypeNameHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        [System.Flags]
        public enum TypeNameHandling
        {
            All,
            Arrays,
            Auto,
            None,
            Objects,
        }

        // Generated from `Newtonsoft.Json.WriteState` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
        public enum WriteState
        {
            Array,
            Closed,
            Constructor,
            Error,
            Object,
            Property,
            Start,
        }

        namespace Bson
        {
            // Generated from `Newtonsoft.Json.Bson.BsonObjectId` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class BsonObjectId
            {
                public BsonObjectId(System.Byte[] value) => throw null;
                public System.Byte[] Value { get => throw null; }
            }

            // Generated from `Newtonsoft.Json.Bson.BsonReader` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class BsonReader : Newtonsoft.Json.JsonReader
            {
                public BsonReader(System.IO.Stream stream, bool readRootValueAsArray, System.DateTimeKind dateTimeKindHandling) => throw null;
                public BsonReader(System.IO.Stream stream) => throw null;
                public BsonReader(System.IO.BinaryReader reader, bool readRootValueAsArray, System.DateTimeKind dateTimeKindHandling) => throw null;
                public BsonReader(System.IO.BinaryReader reader) => throw null;
                public override void Close() => throw null;
                public System.DateTimeKind DateTimeKindHandling { get => throw null; set => throw null; }
                public bool JsonNet35BinaryCompatibility { get => throw null; set => throw null; }
                public override bool Read() => throw null;
                public bool ReadRootValueAsArray { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Bson.BsonWriter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class BsonWriter : Newtonsoft.Json.JsonWriter
            {
                public BsonWriter(System.IO.Stream stream) => throw null;
                public BsonWriter(System.IO.BinaryWriter writer) => throw null;
                public override void Close() => throw null;
                public System.DateTimeKind DateTimeKindHandling { get => throw null; set => throw null; }
                public override void Flush() => throw null;
                public override void WriteComment(string text) => throw null;
                protected override void WriteEnd(Newtonsoft.Json.JsonToken token) => throw null;
                public override void WriteNull() => throw null;
                public void WriteObjectId(System.Byte[] value) => throw null;
                public override void WritePropertyName(string name) => throw null;
                public override void WriteRaw(string json) => throw null;
                public override void WriteRawValue(string json) => throw null;
                public void WriteRegex(string pattern, string options) => throw null;
                public override void WriteStartArray() => throw null;
                public override void WriteStartConstructor(string name) => throw null;
                public override void WriteStartObject() => throw null;
                public override void WriteUndefined() => throw null;
                public override void WriteValue(string value) => throw null;
                public override void WriteValue(object value) => throw null;
                public override void WriteValue(int value) => throw null;
                public override void WriteValue(float value) => throw null;
                public override void WriteValue(double value) => throw null;
                public override void WriteValue(bool value) => throw null;
                public override void WriteValue(System.Uri value) => throw null;
                public override void WriteValue(System.UInt64 value) => throw null;
                public override void WriteValue(System.UInt32 value) => throw null;
                public override void WriteValue(System.UInt16 value) => throw null;
                public override void WriteValue(System.TimeSpan value) => throw null;
                public override void WriteValue(System.SByte value) => throw null;
                public override void WriteValue(System.Int64 value) => throw null;
                public override void WriteValue(System.Int16 value) => throw null;
                public override void WriteValue(System.Guid value) => throw null;
                public override void WriteValue(System.Decimal value) => throw null;
                public override void WriteValue(System.DateTimeOffset value) => throw null;
                public override void WriteValue(System.DateTime value) => throw null;
                public override void WriteValue(System.Char value) => throw null;
                public override void WriteValue(System.Byte[] value) => throw null;
                public override void WriteValue(System.Byte value) => throw null;
            }

        }
        namespace Converters
        {
            // Generated from `Newtonsoft.Json.Converters.BinaryConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class BinaryConverter : Newtonsoft.Json.JsonConverter
            {
                public BinaryConverter() => throw null;
                public override bool CanConvert(System.Type objectType) => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.BsonObjectIdConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class BsonObjectIdConverter : Newtonsoft.Json.JsonConverter
            {
                public BsonObjectIdConverter() => throw null;
                public override bool CanConvert(System.Type objectType) => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.CustomCreationConverter<>` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public abstract class CustomCreationConverter<T> : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type objectType) => throw null;
                public override bool CanWrite { get => throw null; }
                public abstract T Create(System.Type objectType);
                protected CustomCreationConverter() => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.DataSetConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class DataSetConverter : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type valueType) => throw null;
                public DataSetConverter() => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.DataTableConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class DataTableConverter : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type valueType) => throw null;
                public DataTableConverter() => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.DateTimeConverterBase` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public abstract class DateTimeConverterBase : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type objectType) => throw null;
                protected DateTimeConverterBase() => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.DiscriminatedUnionConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class DiscriminatedUnionConverter : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type objectType) => throw null;
                public DiscriminatedUnionConverter() => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.EntityKeyMemberConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class EntityKeyMemberConverter : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type objectType) => throw null;
                public EntityKeyMemberConverter() => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.ExpandoObjectConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class ExpandoObjectConverter : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type objectType) => throw null;
                public override bool CanWrite { get => throw null; }
                public ExpandoObjectConverter() => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.IsoDateTimeConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class IsoDateTimeConverter : Newtonsoft.Json.Converters.DateTimeConverterBase
            {
                public System.Globalization.CultureInfo Culture { get => throw null; set => throw null; }
                public string DateTimeFormat { get => throw null; set => throw null; }
                public System.Globalization.DateTimeStyles DateTimeStyles { get => throw null; set => throw null; }
                public IsoDateTimeConverter() => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.JavaScriptDateTimeConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JavaScriptDateTimeConverter : Newtonsoft.Json.Converters.DateTimeConverterBase
            {
                public JavaScriptDateTimeConverter() => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.KeyValuePairConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class KeyValuePairConverter : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type objectType) => throw null;
                public KeyValuePairConverter() => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.RegexConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class RegexConverter : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type objectType) => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public RegexConverter() => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.StringEnumConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class StringEnumConverter : Newtonsoft.Json.JsonConverter
            {
                public bool AllowIntegerValues { get => throw null; set => throw null; }
                public bool CamelCaseText { get => throw null; set => throw null; }
                public override bool CanConvert(System.Type objectType) => throw null;
                public Newtonsoft.Json.Serialization.NamingStrategy NamingStrategy { get => throw null; set => throw null; }
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public StringEnumConverter(bool camelCaseText) => throw null;
                public StringEnumConverter(System.Type namingStrategyType, object[] namingStrategyParameters, bool allowIntegerValues) => throw null;
                public StringEnumConverter(System.Type namingStrategyType, object[] namingStrategyParameters) => throw null;
                public StringEnumConverter(System.Type namingStrategyType) => throw null;
                public StringEnumConverter(Newtonsoft.Json.Serialization.NamingStrategy namingStrategy, bool allowIntegerValues = default(bool)) => throw null;
                public StringEnumConverter() => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.UnixDateTimeConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class UnixDateTimeConverter : Newtonsoft.Json.Converters.DateTimeConverterBase
            {
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public UnixDateTimeConverter() => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.VersionConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class VersionConverter : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type objectType) => throw null;
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public VersionConverter() => throw null;
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Converters.XmlNodeConverter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class XmlNodeConverter : Newtonsoft.Json.JsonConverter
            {
                public override bool CanConvert(System.Type valueType) => throw null;
                public string DeserializeRootElementName { get => throw null; set => throw null; }
                public bool EncodeSpecialCharacters { get => throw null; set => throw null; }
                public bool OmitRootObject { get => throw null; set => throw null; }
                public override object ReadJson(Newtonsoft.Json.JsonReader reader, System.Type objectType, object existingValue, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public bool WriteArrayAttribute { get => throw null; set => throw null; }
                public override void WriteJson(Newtonsoft.Json.JsonWriter writer, object value, Newtonsoft.Json.JsonSerializer serializer) => throw null;
                public XmlNodeConverter() => throw null;
            }

        }
        namespace Linq
        {
            // Generated from `Newtonsoft.Json.Linq.CommentHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public enum CommentHandling
            {
                Ignore,
                Load,
            }

            // Generated from `Newtonsoft.Json.Linq.DuplicatePropertyNameHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public enum DuplicatePropertyNameHandling
            {
                Error,
                Ignore,
                Replace,
            }

            // Generated from `Newtonsoft.Json.Linq.Extensions` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public static class Extensions
            {
                public static Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> Ancestors<T>(this System.Collections.Generic.IEnumerable<T> source) where T : Newtonsoft.Json.Linq.JToken => throw null;
                public static Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> AncestorsAndSelf<T>(this System.Collections.Generic.IEnumerable<T> source) where T : Newtonsoft.Json.Linq.JToken => throw null;
                public static Newtonsoft.Json.Linq.IJEnumerable<T> AsJEnumerable<T>(this System.Collections.Generic.IEnumerable<T> source) where T : Newtonsoft.Json.Linq.JToken => throw null;
                public static Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> AsJEnumerable(this System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> source) => throw null;
                public static System.Collections.Generic.IEnumerable<U> Children<T, U>(this System.Collections.Generic.IEnumerable<T> source) where T : Newtonsoft.Json.Linq.JToken => throw null;
                public static Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> Children<T>(this System.Collections.Generic.IEnumerable<T> source) where T : Newtonsoft.Json.Linq.JToken => throw null;
                public static Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> Descendants<T>(this System.Collections.Generic.IEnumerable<T> source) where T : Newtonsoft.Json.Linq.JContainer => throw null;
                public static Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> DescendantsAndSelf<T>(this System.Collections.Generic.IEnumerable<T> source) where T : Newtonsoft.Json.Linq.JContainer => throw null;
                public static Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JProperty> Properties(this System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JObject> source) => throw null;
                public static U Value<U>(this System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> value) => throw null;
                public static U Value<T, U>(this System.Collections.Generic.IEnumerable<T> value) where T : Newtonsoft.Json.Linq.JToken => throw null;
                public static System.Collections.Generic.IEnumerable<U> Values<U>(this System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> source, object key) => throw null;
                public static System.Collections.Generic.IEnumerable<U> Values<U>(this System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> source) => throw null;
                public static Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> Values(this System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> source, object key) => throw null;
                public static Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> Values(this System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> source) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.IJEnumerable<>` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public interface IJEnumerable<T> : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<T> where T : Newtonsoft.Json.Linq.JToken
            {
                Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> this[object key] { get; }
            }

            // Generated from `Newtonsoft.Json.Linq.JArray` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JArray : Newtonsoft.Json.Linq.JContainer, System.Collections.IEnumerable, System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken>, System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken>, System.Collections.Generic.ICollection<Newtonsoft.Json.Linq.JToken>
            {
                public void Add(Newtonsoft.Json.Linq.JToken item) => throw null;
                protected override System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken> ChildrenTokens { get => throw null; }
                public void Clear() => throw null;
                public bool Contains(Newtonsoft.Json.Linq.JToken item) => throw null;
                public void CopyTo(Newtonsoft.Json.Linq.JToken[] array, int arrayIndex) => throw null;
                public static Newtonsoft.Json.Linq.JArray FromObject(object o, Newtonsoft.Json.JsonSerializer jsonSerializer) => throw null;
                public static Newtonsoft.Json.Linq.JArray FromObject(object o) => throw null;
                public System.Collections.Generic.IEnumerator<Newtonsoft.Json.Linq.JToken> GetEnumerator() => throw null;
                public int IndexOf(Newtonsoft.Json.Linq.JToken item) => throw null;
                public void Insert(int index, Newtonsoft.Json.Linq.JToken item) => throw null;
                public bool IsReadOnly { get => throw null; }
                public override Newtonsoft.Json.Linq.JToken this[object key] { get => throw null; set => throw null; }
                public Newtonsoft.Json.Linq.JToken this[int index] { get => throw null; set => throw null; }
                public JArray(params object[] content) => throw null;
                public JArray(object content) => throw null;
                public JArray(Newtonsoft.Json.Linq.JArray other) => throw null;
                public JArray() => throw null;
                public static Newtonsoft.Json.Linq.JArray Load(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings) => throw null;
                public static Newtonsoft.Json.Linq.JArray Load(Newtonsoft.Json.JsonReader reader) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JArray> LoadAsync(Newtonsoft.Json.JsonReader reader, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JArray> LoadAsync(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static Newtonsoft.Json.Linq.JArray Parse(string json, Newtonsoft.Json.Linq.JsonLoadSettings settings) => throw null;
                public static Newtonsoft.Json.Linq.JArray Parse(string json) => throw null;
                public bool Remove(Newtonsoft.Json.Linq.JToken item) => throw null;
                public void RemoveAt(int index) => throw null;
                public override Newtonsoft.Json.Linq.JTokenType Type { get => throw null; }
                public override void WriteTo(Newtonsoft.Json.JsonWriter writer, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(Newtonsoft.Json.JsonWriter writer, System.Threading.CancellationToken cancellationToken, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JConstructor` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JConstructor : Newtonsoft.Json.Linq.JContainer
            {
                protected override System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken> ChildrenTokens { get => throw null; }
                public override Newtonsoft.Json.Linq.JToken this[object key] { get => throw null; set => throw null; }
                public JConstructor(string name, params object[] content) => throw null;
                public JConstructor(string name, object content) => throw null;
                public JConstructor(string name) => throw null;
                public JConstructor(Newtonsoft.Json.Linq.JConstructor other) => throw null;
                public JConstructor() => throw null;
                public static Newtonsoft.Json.Linq.JConstructor Load(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings) => throw null;
                public static Newtonsoft.Json.Linq.JConstructor Load(Newtonsoft.Json.JsonReader reader) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JConstructor> LoadAsync(Newtonsoft.Json.JsonReader reader, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JConstructor> LoadAsync(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public string Name { get => throw null; set => throw null; }
                public override Newtonsoft.Json.Linq.JTokenType Type { get => throw null; }
                public override void WriteTo(Newtonsoft.Json.JsonWriter writer, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(Newtonsoft.Json.JsonWriter writer, System.Threading.CancellationToken cancellationToken, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JContainer` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public abstract class JContainer : Newtonsoft.Json.Linq.JToken, System.ComponentModel.ITypedList, System.ComponentModel.IBindingList, System.Collections.Specialized.INotifyCollectionChanged, System.Collections.IList, System.Collections.IEnumerable, System.Collections.ICollection, System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken>, System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken>, System.Collections.Generic.ICollection<Newtonsoft.Json.Linq.JToken>
            {
                void System.Collections.Generic.ICollection<Newtonsoft.Json.Linq.JToken>.Add(Newtonsoft.Json.Linq.JToken item) => throw null;
                public virtual void Add(object content) => throw null;
                int System.Collections.IList.Add(object value) => throw null;
                public void AddFirst(object content) => throw null;
                void System.ComponentModel.IBindingList.AddIndex(System.ComponentModel.PropertyDescriptor property) => throw null;
                object System.ComponentModel.IBindingList.AddNew() => throw null;
                public event System.ComponentModel.AddingNewEventHandler AddingNew;
                bool System.ComponentModel.IBindingList.AllowEdit { get => throw null; }
                bool System.ComponentModel.IBindingList.AllowNew { get => throw null; }
                bool System.ComponentModel.IBindingList.AllowRemove { get => throw null; }
                void System.ComponentModel.IBindingList.ApplySort(System.ComponentModel.PropertyDescriptor property, System.ComponentModel.ListSortDirection direction) => throw null;
                public override Newtonsoft.Json.Linq.JEnumerable<Newtonsoft.Json.Linq.JToken> Children() => throw null;
                protected abstract System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken> ChildrenTokens { get; }
                void System.Collections.IList.Clear() => throw null;
                void System.Collections.Generic.ICollection<Newtonsoft.Json.Linq.JToken>.Clear() => throw null;
                public event System.Collections.Specialized.NotifyCollectionChangedEventHandler CollectionChanged;
                bool System.Collections.IList.Contains(object value) => throw null;
                bool System.Collections.Generic.ICollection<Newtonsoft.Json.Linq.JToken>.Contains(Newtonsoft.Json.Linq.JToken item) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                void System.Collections.Generic.ICollection<Newtonsoft.Json.Linq.JToken>.CopyTo(Newtonsoft.Json.Linq.JToken[] array, int arrayIndex) => throw null;
                public int Count { get => throw null; }
                public Newtonsoft.Json.JsonWriter CreateWriter() => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> Descendants() => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> DescendantsAndSelf() => throw null;
                int System.ComponentModel.IBindingList.Find(System.ComponentModel.PropertyDescriptor property, object key) => throw null;
                public override Newtonsoft.Json.Linq.JToken First { get => throw null; }
                System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ITypedList.GetItemProperties(System.ComponentModel.PropertyDescriptor[] listAccessors) => throw null;
                string System.ComponentModel.ITypedList.GetListName(System.ComponentModel.PropertyDescriptor[] listAccessors) => throw null;
                public override bool HasValues { get => throw null; }
                int System.Collections.IList.IndexOf(object value) => throw null;
                int System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken>.IndexOf(Newtonsoft.Json.Linq.JToken item) => throw null;
                void System.Collections.IList.Insert(int index, object value) => throw null;
                void System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken>.Insert(int index, Newtonsoft.Json.Linq.JToken item) => throw null;
                bool System.Collections.IList.IsFixedSize { get => throw null; }
                bool System.Collections.IList.IsReadOnly { get => throw null; }
                bool System.Collections.Generic.ICollection<Newtonsoft.Json.Linq.JToken>.IsReadOnly { get => throw null; }
                bool System.ComponentModel.IBindingList.IsSorted { get => throw null; }
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                object System.Collections.IList.this[int index] { get => throw null; set => throw null; }
                Newtonsoft.Json.Linq.JToken System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken>.this[int index] { get => throw null; set => throw null; }
                internal JContainer() => throw null;
                public override Newtonsoft.Json.Linq.JToken Last { get => throw null; }
                public event System.ComponentModel.ListChangedEventHandler ListChanged;
                public void Merge(object content, Newtonsoft.Json.Linq.JsonMergeSettings settings) => throw null;
                public void Merge(object content) => throw null;
                protected virtual void OnAddingNew(System.ComponentModel.AddingNewEventArgs e) => throw null;
                protected virtual void OnCollectionChanged(System.Collections.Specialized.NotifyCollectionChangedEventArgs e) => throw null;
                protected virtual void OnListChanged(System.ComponentModel.ListChangedEventArgs e) => throw null;
                void System.Collections.IList.Remove(object value) => throw null;
                bool System.Collections.Generic.ICollection<Newtonsoft.Json.Linq.JToken>.Remove(Newtonsoft.Json.Linq.JToken item) => throw null;
                public void RemoveAll() => throw null;
                void System.Collections.IList.RemoveAt(int index) => throw null;
                void System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken>.RemoveAt(int index) => throw null;
                void System.ComponentModel.IBindingList.RemoveIndex(System.ComponentModel.PropertyDescriptor property) => throw null;
                void System.ComponentModel.IBindingList.RemoveSort() => throw null;
                public void ReplaceAll(object content) => throw null;
                System.ComponentModel.ListSortDirection System.ComponentModel.IBindingList.SortDirection { get => throw null; }
                System.ComponentModel.PropertyDescriptor System.ComponentModel.IBindingList.SortProperty { get => throw null; }
                bool System.ComponentModel.IBindingList.SupportsChangeNotification { get => throw null; }
                bool System.ComponentModel.IBindingList.SupportsSearching { get => throw null; }
                bool System.ComponentModel.IBindingList.SupportsSorting { get => throw null; }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public override System.Collections.Generic.IEnumerable<T> Values<T>() => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JEnumerable<>` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public struct JEnumerable<T> : System.IEquatable<Newtonsoft.Json.Linq.JEnumerable<T>>, System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<T>, Newtonsoft.Json.Linq.IJEnumerable<T> where T : Newtonsoft.Json.Linq.JToken
            {
                public static Newtonsoft.Json.Linq.JEnumerable<T> Empty;
                public override bool Equals(object obj) => throw null;
                public bool Equals(Newtonsoft.Json.Linq.JEnumerable<T> other) => throw null;
                public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public override int GetHashCode() => throw null;
                public Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> this[object key] { get => throw null; }
                public JEnumerable(System.Collections.Generic.IEnumerable<T> enumerable) => throw null;
                // Stub generator skipped constructor 
            }

            // Generated from `Newtonsoft.Json.Linq.JObject` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JObject : Newtonsoft.Json.Linq.JContainer, System.ComponentModel.INotifyPropertyChanging, System.ComponentModel.INotifyPropertyChanged, System.ComponentModel.ICustomTypeDescriptor, System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>>, System.Collections.Generic.IDictionary<string, Newtonsoft.Json.Linq.JToken>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>>
            {
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>>.Add(System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken> item) => throw null;
                public void Add(string propertyName, Newtonsoft.Json.Linq.JToken value) => throw null;
                protected override System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken> ChildrenTokens { get => throw null; }
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>>.Clear() => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>>.Contains(System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken> item) => throw null;
                public bool ContainsKey(string propertyName) => throw null;
                void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>>.CopyTo(System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>[] array, int arrayIndex) => throw null;
                public static Newtonsoft.Json.Linq.JObject FromObject(object o, Newtonsoft.Json.JsonSerializer jsonSerializer) => throw null;
                public static Newtonsoft.Json.Linq.JObject FromObject(object o) => throw null;
                System.ComponentModel.AttributeCollection System.ComponentModel.ICustomTypeDescriptor.GetAttributes() => throw null;
                string System.ComponentModel.ICustomTypeDescriptor.GetClassName() => throw null;
                string System.ComponentModel.ICustomTypeDescriptor.GetComponentName() => throw null;
                System.ComponentModel.TypeConverter System.ComponentModel.ICustomTypeDescriptor.GetConverter() => throw null;
                System.ComponentModel.EventDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultEvent() => throw null;
                System.ComponentModel.PropertyDescriptor System.ComponentModel.ICustomTypeDescriptor.GetDefaultProperty() => throw null;
                object System.ComponentModel.ICustomTypeDescriptor.GetEditor(System.Type editorBaseType) => throw null;
                public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>> GetEnumerator() => throw null;
                System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents(System.Attribute[] attributes) => throw null;
                System.ComponentModel.EventDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetEvents() => throw null;
                protected override System.Dynamic.DynamicMetaObject GetMetaObject(System.Linq.Expressions.Expression parameter) => throw null;
                System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties(System.Attribute[] attributes) => throw null;
                System.ComponentModel.PropertyDescriptorCollection System.ComponentModel.ICustomTypeDescriptor.GetProperties() => throw null;
                object System.ComponentModel.ICustomTypeDescriptor.GetPropertyOwner(System.ComponentModel.PropertyDescriptor pd) => throw null;
                public Newtonsoft.Json.Linq.JToken GetValue(string propertyName, System.StringComparison comparison) => throw null;
                public Newtonsoft.Json.Linq.JToken GetValue(string propertyName) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>>.IsReadOnly { get => throw null; }
                public override Newtonsoft.Json.Linq.JToken this[object key] { get => throw null; set => throw null; }
                public Newtonsoft.Json.Linq.JToken this[string propertyName] { get => throw null; set => throw null; }
                public JObject(params object[] content) => throw null;
                public JObject(object content) => throw null;
                public JObject(Newtonsoft.Json.Linq.JObject other) => throw null;
                public JObject() => throw null;
                System.Collections.Generic.ICollection<string> System.Collections.Generic.IDictionary<string, Newtonsoft.Json.Linq.JToken>.Keys { get => throw null; }
                public static Newtonsoft.Json.Linq.JObject Load(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings) => throw null;
                public static Newtonsoft.Json.Linq.JObject Load(Newtonsoft.Json.JsonReader reader) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JObject> LoadAsync(Newtonsoft.Json.JsonReader reader, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JObject> LoadAsync(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected virtual void OnPropertyChanged(string propertyName) => throw null;
                protected virtual void OnPropertyChanging(string propertyName) => throw null;
                public static Newtonsoft.Json.Linq.JObject Parse(string json, Newtonsoft.Json.Linq.JsonLoadSettings settings) => throw null;
                public static Newtonsoft.Json.Linq.JObject Parse(string json) => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JProperty> Properties() => throw null;
                public Newtonsoft.Json.Linq.JProperty Property(string name, System.StringComparison comparison) => throw null;
                public Newtonsoft.Json.Linq.JProperty Property(string name) => throw null;
                public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
                public event System.ComponentModel.PropertyChangingEventHandler PropertyChanging;
                public Newtonsoft.Json.Linq.JEnumerable<Newtonsoft.Json.Linq.JToken> PropertyValues() => throw null;
                public bool Remove(string propertyName) => throw null;
                bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken>>.Remove(System.Collections.Generic.KeyValuePair<string, Newtonsoft.Json.Linq.JToken> item) => throw null;
                public bool TryGetValue(string propertyName, out Newtonsoft.Json.Linq.JToken value) => throw null;
                public bool TryGetValue(string propertyName, System.StringComparison comparison, out Newtonsoft.Json.Linq.JToken value) => throw null;
                public override Newtonsoft.Json.Linq.JTokenType Type { get => throw null; }
                System.Collections.Generic.ICollection<Newtonsoft.Json.Linq.JToken> System.Collections.Generic.IDictionary<string, Newtonsoft.Json.Linq.JToken>.Values { get => throw null; }
                public override void WriteTo(Newtonsoft.Json.JsonWriter writer, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(Newtonsoft.Json.JsonWriter writer, System.Threading.CancellationToken cancellationToken, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JProperty` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JProperty : Newtonsoft.Json.Linq.JContainer
            {
                protected override System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken> ChildrenTokens { get => throw null; }
                public JProperty(string name, params object[] content) => throw null;
                public JProperty(string name, object content) => throw null;
                public JProperty(Newtonsoft.Json.Linq.JProperty other) => throw null;
                public static Newtonsoft.Json.Linq.JProperty Load(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings) => throw null;
                public static Newtonsoft.Json.Linq.JProperty Load(Newtonsoft.Json.JsonReader reader) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JProperty> LoadAsync(Newtonsoft.Json.JsonReader reader, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JProperty> LoadAsync(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public string Name { get => throw null; }
                public override Newtonsoft.Json.Linq.JTokenType Type { get => throw null; }
                public Newtonsoft.Json.Linq.JToken Value { get => throw null; set => throw null; }
                public override void WriteTo(Newtonsoft.Json.JsonWriter writer, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(Newtonsoft.Json.JsonWriter writer, System.Threading.CancellationToken cancellationToken, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JPropertyDescriptor` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JPropertyDescriptor : System.ComponentModel.PropertyDescriptor
            {
                public override bool CanResetValue(object component) => throw null;
                public override System.Type ComponentType { get => throw null; }
                public override object GetValue(object component) => throw null;
                public override bool IsReadOnly { get => throw null; }
                public JPropertyDescriptor(string name) : base(default(System.ComponentModel.MemberDescriptor)) => throw null;
                protected override int NameHashCode { get => throw null; }
                public override System.Type PropertyType { get => throw null; }
                public override void ResetValue(object component) => throw null;
                public override void SetValue(object component, object value) => throw null;
                public override bool ShouldSerializeValue(object component) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JRaw` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JRaw : Newtonsoft.Json.Linq.JValue
            {
                public static Newtonsoft.Json.Linq.JRaw Create(Newtonsoft.Json.JsonReader reader) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JRaw> CreateAsync(Newtonsoft.Json.JsonReader reader, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public JRaw(object rawJson) : base(default(Newtonsoft.Json.Linq.JValue)) => throw null;
                public JRaw(Newtonsoft.Json.Linq.JRaw other) : base(default(Newtonsoft.Json.Linq.JValue)) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JToken` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public abstract class JToken : System.ICloneable, System.Dynamic.IDynamicMetaObjectProvider, System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken>, Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken>, Newtonsoft.Json.IJsonLineInfo
            {
                public void AddAfterSelf(object content) => throw null;
                public void AddAnnotation(object annotation) => throw null;
                public void AddBeforeSelf(object content) => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> AfterSelf() => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> Ancestors() => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> AncestorsAndSelf() => throw null;
                public object Annotation(System.Type type) => throw null;
                public T Annotation<T>() where T : class => throw null;
                public System.Collections.Generic.IEnumerable<object> Annotations(System.Type type) => throw null;
                public System.Collections.Generic.IEnumerable<T> Annotations<T>() where T : class => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> BeforeSelf() => throw null;
                public virtual Newtonsoft.Json.Linq.JEnumerable<Newtonsoft.Json.Linq.JToken> Children() => throw null;
                public Newtonsoft.Json.Linq.JEnumerable<T> Children<T>() where T : Newtonsoft.Json.Linq.JToken => throw null;
                object System.ICloneable.Clone() => throw null;
                public Newtonsoft.Json.JsonReader CreateReader() => throw null;
                public Newtonsoft.Json.Linq.JToken DeepClone() => throw null;
                public static bool DeepEquals(Newtonsoft.Json.Linq.JToken t1, Newtonsoft.Json.Linq.JToken t2) => throw null;
                public static Newtonsoft.Json.Linq.JTokenEqualityComparer EqualityComparer { get => throw null; }
                public virtual Newtonsoft.Json.Linq.JToken First { get => throw null; }
                public static Newtonsoft.Json.Linq.JToken FromObject(object o, Newtonsoft.Json.JsonSerializer jsonSerializer) => throw null;
                public static Newtonsoft.Json.Linq.JToken FromObject(object o) => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<Newtonsoft.Json.Linq.JToken> System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken>.GetEnumerator() => throw null;
                protected virtual System.Dynamic.DynamicMetaObject GetMetaObject(System.Linq.Expressions.Expression parameter) => throw null;
                System.Dynamic.DynamicMetaObject System.Dynamic.IDynamicMetaObjectProvider.GetMetaObject(System.Linq.Expressions.Expression parameter) => throw null;
                bool Newtonsoft.Json.IJsonLineInfo.HasLineInfo() => throw null;
                public abstract bool HasValues { get; }
                public virtual Newtonsoft.Json.Linq.JToken this[object key] { get => throw null; set => throw null; }
                Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken> Newtonsoft.Json.Linq.IJEnumerable<Newtonsoft.Json.Linq.JToken>.this[object key] { get => throw null; }
                internal JToken() => throw null;
                public virtual Newtonsoft.Json.Linq.JToken Last { get => throw null; }
                int Newtonsoft.Json.IJsonLineInfo.LineNumber { get => throw null; }
                int Newtonsoft.Json.IJsonLineInfo.LinePosition { get => throw null; }
                public static Newtonsoft.Json.Linq.JToken Load(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings) => throw null;
                public static Newtonsoft.Json.Linq.JToken Load(Newtonsoft.Json.JsonReader reader) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JToken> LoadAsync(Newtonsoft.Json.JsonReader reader, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JToken> LoadAsync(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public Newtonsoft.Json.Linq.JToken Next { get => throw null; set => throw null; }
                public Newtonsoft.Json.Linq.JContainer Parent { get => throw null; set => throw null; }
                public static Newtonsoft.Json.Linq.JToken Parse(string json, Newtonsoft.Json.Linq.JsonLoadSettings settings) => throw null;
                public static Newtonsoft.Json.Linq.JToken Parse(string json) => throw null;
                public string Path { get => throw null; }
                public Newtonsoft.Json.Linq.JToken Previous { get => throw null; set => throw null; }
                public static Newtonsoft.Json.Linq.JToken ReadFrom(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings) => throw null;
                public static Newtonsoft.Json.Linq.JToken ReadFrom(Newtonsoft.Json.JsonReader reader) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JToken> ReadFromAsync(Newtonsoft.Json.JsonReader reader, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public static System.Threading.Tasks.Task<Newtonsoft.Json.Linq.JToken> ReadFromAsync(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Linq.JsonLoadSettings settings, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public void Remove() => throw null;
                public void RemoveAnnotations<T>() where T : class => throw null;
                public void RemoveAnnotations(System.Type type) => throw null;
                public void Replace(Newtonsoft.Json.Linq.JToken value) => throw null;
                public Newtonsoft.Json.Linq.JToken Root { get => throw null; }
                public Newtonsoft.Json.Linq.JToken SelectToken(string path, bool errorWhenNoMatch) => throw null;
                public Newtonsoft.Json.Linq.JToken SelectToken(string path, Newtonsoft.Json.Linq.JsonSelectSettings settings) => throw null;
                public Newtonsoft.Json.Linq.JToken SelectToken(string path) => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> SelectTokens(string path, bool errorWhenNoMatch) => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> SelectTokens(string path, Newtonsoft.Json.Linq.JsonSelectSettings settings) => throw null;
                public System.Collections.Generic.IEnumerable<Newtonsoft.Json.Linq.JToken> SelectTokens(string path) => throw null;
                public object ToObject(System.Type objectType, Newtonsoft.Json.JsonSerializer jsonSerializer) => throw null;
                public object ToObject(System.Type objectType) => throw null;
                public T ToObject<T>(Newtonsoft.Json.JsonSerializer jsonSerializer) => throw null;
                public T ToObject<T>() => throw null;
                public string ToString(Newtonsoft.Json.Formatting formatting, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
                public override string ToString() => throw null;
                public abstract Newtonsoft.Json.Linq.JTokenType Type { get; }
                public virtual T Value<T>(object key) => throw null;
                public virtual System.Collections.Generic.IEnumerable<T> Values<T>() => throw null;
                public abstract void WriteTo(Newtonsoft.Json.JsonWriter writer, params Newtonsoft.Json.JsonConverter[] converters);
                public virtual System.Threading.Tasks.Task WriteToAsync(Newtonsoft.Json.JsonWriter writer, System.Threading.CancellationToken cancellationToken, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
                public System.Threading.Tasks.Task WriteToAsync(Newtonsoft.Json.JsonWriter writer, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
                public static explicit operator string(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator int?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator int(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator float?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator float(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator double?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator double(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator bool?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator bool(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Uri(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.UInt64?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.UInt64(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.UInt32?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.UInt32(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.UInt16?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.UInt16(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.TimeSpan?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.TimeSpan(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.SByte?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.SByte(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Int64?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Int64(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Int16?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Int16(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Guid?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Guid(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Decimal?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Decimal(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.DateTimeOffset?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.DateTimeOffset(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.DateTime?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.DateTime(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Char?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Char(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Byte[](Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Byte?(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static explicit operator System.Byte(Newtonsoft.Json.Linq.JToken value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(string value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(int? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(int value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(float? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(float value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(double? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(double value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(bool? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(bool value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Uri value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.UInt64? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.UInt64 value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.UInt32? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.UInt32 value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.UInt16? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.UInt16 value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.TimeSpan? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.TimeSpan value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.SByte? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.SByte value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Int64? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Int64 value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Int16? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Int16 value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Guid? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Guid value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Decimal? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Decimal value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.DateTimeOffset? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.DateTimeOffset value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.DateTime? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.DateTime value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Byte[] value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Byte? value) => throw null;
                public static implicit operator Newtonsoft.Json.Linq.JToken(System.Byte value) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JTokenEqualityComparer` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JTokenEqualityComparer : System.Collections.Generic.IEqualityComparer<Newtonsoft.Json.Linq.JToken>
            {
                public bool Equals(Newtonsoft.Json.Linq.JToken x, Newtonsoft.Json.Linq.JToken y) => throw null;
                public int GetHashCode(Newtonsoft.Json.Linq.JToken obj) => throw null;
                public JTokenEqualityComparer() => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JTokenReader` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JTokenReader : Newtonsoft.Json.JsonReader, Newtonsoft.Json.IJsonLineInfo
            {
                public Newtonsoft.Json.Linq.JToken CurrentToken { get => throw null; }
                bool Newtonsoft.Json.IJsonLineInfo.HasLineInfo() => throw null;
                public JTokenReader(Newtonsoft.Json.Linq.JToken token, string initialPath) => throw null;
                public JTokenReader(Newtonsoft.Json.Linq.JToken token) => throw null;
                int Newtonsoft.Json.IJsonLineInfo.LineNumber { get => throw null; }
                int Newtonsoft.Json.IJsonLineInfo.LinePosition { get => throw null; }
                public override string Path { get => throw null; }
                public override bool Read() => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JTokenType` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public enum JTokenType
            {
                Array,
                Boolean,
                Bytes,
                Comment,
                Constructor,
                Date,
                Float,
                Guid,
                Integer,
                None,
                Null,
                Object,
                Property,
                Raw,
                String,
                TimeSpan,
                Undefined,
                Uri,
            }

            // Generated from `Newtonsoft.Json.Linq.JTokenWriter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JTokenWriter : Newtonsoft.Json.JsonWriter
            {
                public override void Close() => throw null;
                public Newtonsoft.Json.Linq.JToken CurrentToken { get => throw null; }
                public override void Flush() => throw null;
                public JTokenWriter(Newtonsoft.Json.Linq.JContainer container) => throw null;
                public JTokenWriter() => throw null;
                public Newtonsoft.Json.Linq.JToken Token { get => throw null; }
                public override void WriteComment(string text) => throw null;
                protected override void WriteEnd(Newtonsoft.Json.JsonToken token) => throw null;
                public override void WriteNull() => throw null;
                public override void WritePropertyName(string name) => throw null;
                public override void WriteRaw(string json) => throw null;
                public override void WriteStartArray() => throw null;
                public override void WriteStartConstructor(string name) => throw null;
                public override void WriteStartObject() => throw null;
                public override void WriteUndefined() => throw null;
                public override void WriteValue(string value) => throw null;
                public override void WriteValue(object value) => throw null;
                public override void WriteValue(int value) => throw null;
                public override void WriteValue(float value) => throw null;
                public override void WriteValue(double value) => throw null;
                public override void WriteValue(bool value) => throw null;
                public override void WriteValue(System.Uri value) => throw null;
                public override void WriteValue(System.UInt64 value) => throw null;
                public override void WriteValue(System.UInt32 value) => throw null;
                public override void WriteValue(System.UInt16 value) => throw null;
                public override void WriteValue(System.TimeSpan value) => throw null;
                public override void WriteValue(System.SByte value) => throw null;
                public override void WriteValue(System.Int64 value) => throw null;
                public override void WriteValue(System.Int16 value) => throw null;
                public override void WriteValue(System.Guid value) => throw null;
                public override void WriteValue(System.Decimal value) => throw null;
                public override void WriteValue(System.DateTimeOffset value) => throw null;
                public override void WriteValue(System.DateTime value) => throw null;
                public override void WriteValue(System.Char value) => throw null;
                public override void WriteValue(System.Byte[] value) => throw null;
                public override void WriteValue(System.Byte value) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JValue` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JValue : Newtonsoft.Json.Linq.JToken, System.IFormattable, System.IEquatable<Newtonsoft.Json.Linq.JValue>, System.IConvertible, System.IComparable<Newtonsoft.Json.Linq.JValue>, System.IComparable
            {
                public int CompareTo(Newtonsoft.Json.Linq.JValue obj) => throw null;
                int System.IComparable.CompareTo(object obj) => throw null;
                public static Newtonsoft.Json.Linq.JValue CreateComment(string value) => throw null;
                public static Newtonsoft.Json.Linq.JValue CreateNull() => throw null;
                public static Newtonsoft.Json.Linq.JValue CreateString(string value) => throw null;
                public static Newtonsoft.Json.Linq.JValue CreateUndefined() => throw null;
                public override bool Equals(object obj) => throw null;
                public bool Equals(Newtonsoft.Json.Linq.JValue other) => throw null;
                public override int GetHashCode() => throw null;
                protected override System.Dynamic.DynamicMetaObject GetMetaObject(System.Linq.Expressions.Expression parameter) => throw null;
                System.TypeCode System.IConvertible.GetTypeCode() => throw null;
                public override bool HasValues { get => throw null; }
                public JValue(string value) => throw null;
                public JValue(object value) => throw null;
                public JValue(float value) => throw null;
                public JValue(double value) => throw null;
                public JValue(bool value) => throw null;
                public JValue(System.Uri value) => throw null;
                public JValue(System.UInt64 value) => throw null;
                public JValue(System.TimeSpan value) => throw null;
                public JValue(System.Int64 value) => throw null;
                public JValue(System.Guid value) => throw null;
                public JValue(System.Decimal value) => throw null;
                public JValue(System.DateTimeOffset value) => throw null;
                public JValue(System.DateTime value) => throw null;
                public JValue(System.Char value) => throw null;
                public JValue(Newtonsoft.Json.Linq.JValue other) => throw null;
                bool System.IConvertible.ToBoolean(System.IFormatProvider provider) => throw null;
                System.Byte System.IConvertible.ToByte(System.IFormatProvider provider) => throw null;
                System.Char System.IConvertible.ToChar(System.IFormatProvider provider) => throw null;
                System.DateTime System.IConvertible.ToDateTime(System.IFormatProvider provider) => throw null;
                System.Decimal System.IConvertible.ToDecimal(System.IFormatProvider provider) => throw null;
                double System.IConvertible.ToDouble(System.IFormatProvider provider) => throw null;
                System.Int16 System.IConvertible.ToInt16(System.IFormatProvider provider) => throw null;
                int System.IConvertible.ToInt32(System.IFormatProvider provider) => throw null;
                System.Int64 System.IConvertible.ToInt64(System.IFormatProvider provider) => throw null;
                System.SByte System.IConvertible.ToSByte(System.IFormatProvider provider) => throw null;
                float System.IConvertible.ToSingle(System.IFormatProvider provider) => throw null;
                public string ToString(string format, System.IFormatProvider formatProvider) => throw null;
                public string ToString(string format) => throw null;
                public string ToString(System.IFormatProvider formatProvider) => throw null;
                public override string ToString() => throw null;
                object System.IConvertible.ToType(System.Type conversionType, System.IFormatProvider provider) => throw null;
                System.UInt16 System.IConvertible.ToUInt16(System.IFormatProvider provider) => throw null;
                System.UInt32 System.IConvertible.ToUInt32(System.IFormatProvider provider) => throw null;
                System.UInt64 System.IConvertible.ToUInt64(System.IFormatProvider provider) => throw null;
                public override Newtonsoft.Json.Linq.JTokenType Type { get => throw null; }
                public object Value { get => throw null; set => throw null; }
                public override void WriteTo(Newtonsoft.Json.JsonWriter writer, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
                public override System.Threading.Tasks.Task WriteToAsync(Newtonsoft.Json.JsonWriter writer, System.Threading.CancellationToken cancellationToken, params Newtonsoft.Json.JsonConverter[] converters) => throw null;
            }

            // Generated from `Newtonsoft.Json.Linq.JsonLoadSettings` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonLoadSettings
            {
                public Newtonsoft.Json.Linq.CommentHandling CommentHandling { get => throw null; set => throw null; }
                public Newtonsoft.Json.Linq.DuplicatePropertyNameHandling DuplicatePropertyNameHandling { get => throw null; set => throw null; }
                public JsonLoadSettings() => throw null;
                public Newtonsoft.Json.Linq.LineInfoHandling LineInfoHandling { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Linq.JsonMergeSettings` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonMergeSettings
            {
                public JsonMergeSettings() => throw null;
                public Newtonsoft.Json.Linq.MergeArrayHandling MergeArrayHandling { get => throw null; set => throw null; }
                public Newtonsoft.Json.Linq.MergeNullValueHandling MergeNullValueHandling { get => throw null; set => throw null; }
                public System.StringComparison PropertyNameComparison { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Linq.JsonSelectSettings` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonSelectSettings
            {
                public bool ErrorWhenNoMatch { get => throw null; set => throw null; }
                public JsonSelectSettings() => throw null;
                public System.TimeSpan? RegexMatchTimeout { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Linq.LineInfoHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public enum LineInfoHandling
            {
                Ignore,
                Load,
            }

            // Generated from `Newtonsoft.Json.Linq.MergeArrayHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public enum MergeArrayHandling
            {
                Concat,
                Merge,
                Replace,
                Union,
            }

            // Generated from `Newtonsoft.Json.Linq.MergeNullValueHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            [System.Flags]
            public enum MergeNullValueHandling
            {
                Ignore,
                Merge,
            }

        }
        namespace Schema
        {
            // Generated from `Newtonsoft.Json.Schema.Extensions` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public static class Extensions
            {
                public static bool IsValid(this Newtonsoft.Json.Linq.JToken source, Newtonsoft.Json.Schema.JsonSchema schema, out System.Collections.Generic.IList<string> errorMessages) => throw null;
                public static bool IsValid(this Newtonsoft.Json.Linq.JToken source, Newtonsoft.Json.Schema.JsonSchema schema) => throw null;
                public static void Validate(this Newtonsoft.Json.Linq.JToken source, Newtonsoft.Json.Schema.JsonSchema schema, Newtonsoft.Json.Schema.ValidationEventHandler validationEventHandler) => throw null;
                public static void Validate(this Newtonsoft.Json.Linq.JToken source, Newtonsoft.Json.Schema.JsonSchema schema) => throw null;
            }

            // Generated from `Newtonsoft.Json.Schema.JsonSchema` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonSchema
            {
                public Newtonsoft.Json.Schema.JsonSchema AdditionalItems { get => throw null; set => throw null; }
                public Newtonsoft.Json.Schema.JsonSchema AdditionalProperties { get => throw null; set => throw null; }
                public bool AllowAdditionalItems { get => throw null; set => throw null; }
                public bool AllowAdditionalProperties { get => throw null; set => throw null; }
                public Newtonsoft.Json.Linq.JToken Default { get => throw null; set => throw null; }
                public string Description { get => throw null; set => throw null; }
                public Newtonsoft.Json.Schema.JsonSchemaType? Disallow { get => throw null; set => throw null; }
                public double? DivisibleBy { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<Newtonsoft.Json.Linq.JToken> Enum { get => throw null; set => throw null; }
                public bool? ExclusiveMaximum { get => throw null; set => throw null; }
                public bool? ExclusiveMinimum { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<Newtonsoft.Json.Schema.JsonSchema> Extends { get => throw null; set => throw null; }
                public string Format { get => throw null; set => throw null; }
                public bool? Hidden { get => throw null; set => throw null; }
                public string Id { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<Newtonsoft.Json.Schema.JsonSchema> Items { get => throw null; set => throw null; }
                public JsonSchema() => throw null;
                public double? Maximum { get => throw null; set => throw null; }
                public int? MaximumItems { get => throw null; set => throw null; }
                public int? MaximumLength { get => throw null; set => throw null; }
                public double? Minimum { get => throw null; set => throw null; }
                public int? MinimumItems { get => throw null; set => throw null; }
                public int? MinimumLength { get => throw null; set => throw null; }
                public static Newtonsoft.Json.Schema.JsonSchema Parse(string json, Newtonsoft.Json.Schema.JsonSchemaResolver resolver) => throw null;
                public static Newtonsoft.Json.Schema.JsonSchema Parse(string json) => throw null;
                public string Pattern { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, Newtonsoft.Json.Schema.JsonSchema> PatternProperties { get => throw null; set => throw null; }
                public bool PositionalItemsValidation { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, Newtonsoft.Json.Schema.JsonSchema> Properties { get => throw null; set => throw null; }
                public static Newtonsoft.Json.Schema.JsonSchema Read(Newtonsoft.Json.JsonReader reader, Newtonsoft.Json.Schema.JsonSchemaResolver resolver) => throw null;
                public static Newtonsoft.Json.Schema.JsonSchema Read(Newtonsoft.Json.JsonReader reader) => throw null;
                public bool? ReadOnly { get => throw null; set => throw null; }
                public bool? Required { get => throw null; set => throw null; }
                public string Requires { get => throw null; set => throw null; }
                public string Title { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public bool? Transient { get => throw null; set => throw null; }
                public Newtonsoft.Json.Schema.JsonSchemaType? Type { get => throw null; set => throw null; }
                public bool UniqueItems { get => throw null; set => throw null; }
                public void WriteTo(Newtonsoft.Json.JsonWriter writer, Newtonsoft.Json.Schema.JsonSchemaResolver resolver) => throw null;
                public void WriteTo(Newtonsoft.Json.JsonWriter writer) => throw null;
            }

            // Generated from `Newtonsoft.Json.Schema.JsonSchemaException` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonSchemaException : Newtonsoft.Json.JsonException
            {
                public JsonSchemaException(string message, System.Exception innerException) => throw null;
                public JsonSchemaException(string message) => throw null;
                public JsonSchemaException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public JsonSchemaException() => throw null;
                public int LineNumber { get => throw null; }
                public int LinePosition { get => throw null; }
                public string Path { get => throw null; }
            }

            // Generated from `Newtonsoft.Json.Schema.JsonSchemaGenerator` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonSchemaGenerator
            {
                public Newtonsoft.Json.Serialization.IContractResolver ContractResolver { get => throw null; set => throw null; }
                public Newtonsoft.Json.Schema.JsonSchema Generate(System.Type type, bool rootSchemaNullable) => throw null;
                public Newtonsoft.Json.Schema.JsonSchema Generate(System.Type type, Newtonsoft.Json.Schema.JsonSchemaResolver resolver, bool rootSchemaNullable) => throw null;
                public Newtonsoft.Json.Schema.JsonSchema Generate(System.Type type, Newtonsoft.Json.Schema.JsonSchemaResolver resolver) => throw null;
                public Newtonsoft.Json.Schema.JsonSchema Generate(System.Type type) => throw null;
                public JsonSchemaGenerator() => throw null;
                public Newtonsoft.Json.Schema.UndefinedSchemaIdHandling UndefinedSchemaIdHandling { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Schema.JsonSchemaResolver` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonSchemaResolver
            {
                public virtual Newtonsoft.Json.Schema.JsonSchema GetSchema(string reference) => throw null;
                public JsonSchemaResolver() => throw null;
                public System.Collections.Generic.IList<Newtonsoft.Json.Schema.JsonSchema> LoadedSchemas { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Schema.JsonSchemaType` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            [System.Flags]
            public enum JsonSchemaType
            {
                Any,
                Array,
                Boolean,
                Float,
                Integer,
                None,
                Null,
                Object,
                String,
            }

            // Generated from `Newtonsoft.Json.Schema.UndefinedSchemaIdHandling` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public enum UndefinedSchemaIdHandling
            {
                None,
                UseAssemblyQualifiedName,
                UseTypeName,
            }

            // Generated from `Newtonsoft.Json.Schema.ValidationEventArgs` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class ValidationEventArgs : System.EventArgs
            {
                public Newtonsoft.Json.Schema.JsonSchemaException Exception { get => throw null; }
                public string Message { get => throw null; }
                public string Path { get => throw null; }
            }

            // Generated from `Newtonsoft.Json.Schema.ValidationEventHandler` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public delegate void ValidationEventHandler(object sender, Newtonsoft.Json.Schema.ValidationEventArgs e);

        }
        namespace Serialization
        {
            // Generated from `Newtonsoft.Json.Serialization.CamelCaseNamingStrategy` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class CamelCaseNamingStrategy : Newtonsoft.Json.Serialization.NamingStrategy
            {
                public CamelCaseNamingStrategy(bool processDictionaryKeys, bool overrideSpecifiedNames, bool processExtensionDataNames) => throw null;
                public CamelCaseNamingStrategy(bool processDictionaryKeys, bool overrideSpecifiedNames) => throw null;
                public CamelCaseNamingStrategy() => throw null;
                protected override string ResolvePropertyName(string name) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.CamelCasePropertyNamesContractResolver` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class CamelCasePropertyNamesContractResolver : Newtonsoft.Json.Serialization.DefaultContractResolver
            {
                public CamelCasePropertyNamesContractResolver() => throw null;
                public override Newtonsoft.Json.Serialization.JsonContract ResolveContract(System.Type type) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.DefaultContractResolver` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class DefaultContractResolver : Newtonsoft.Json.Serialization.IContractResolver
            {
                protected virtual Newtonsoft.Json.Serialization.JsonArrayContract CreateArrayContract(System.Type objectType) => throw null;
                protected virtual System.Collections.Generic.IList<Newtonsoft.Json.Serialization.JsonProperty> CreateConstructorParameters(System.Reflection.ConstructorInfo constructor, Newtonsoft.Json.Serialization.JsonPropertyCollection memberProperties) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonContract CreateContract(System.Type objectType) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonDictionaryContract CreateDictionaryContract(System.Type objectType) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonDynamicContract CreateDynamicContract(System.Type objectType) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonISerializableContract CreateISerializableContract(System.Type objectType) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonLinqContract CreateLinqContract(System.Type objectType) => throw null;
                protected virtual Newtonsoft.Json.Serialization.IValueProvider CreateMemberValueProvider(System.Reflection.MemberInfo member) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonObjectContract CreateObjectContract(System.Type objectType) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonPrimitiveContract CreatePrimitiveContract(System.Type objectType) => throw null;
                protected virtual System.Collections.Generic.IList<Newtonsoft.Json.Serialization.JsonProperty> CreateProperties(System.Type type, Newtonsoft.Json.MemberSerialization memberSerialization) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonProperty CreateProperty(System.Reflection.MemberInfo member, Newtonsoft.Json.MemberSerialization memberSerialization) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonProperty CreatePropertyFromConstructorParameter(Newtonsoft.Json.Serialization.JsonProperty matchingMemberProperty, System.Reflection.ParameterInfo parameterInfo) => throw null;
                protected virtual Newtonsoft.Json.Serialization.JsonStringContract CreateStringContract(System.Type objectType) => throw null;
                public DefaultContractResolver() => throw null;
                public System.Reflection.BindingFlags DefaultMembersSearchFlags { get => throw null; set => throw null; }
                public bool DynamicCodeGeneration { get => throw null; }
                public string GetResolvedPropertyName(string propertyName) => throw null;
                protected virtual System.Collections.Generic.List<System.Reflection.MemberInfo> GetSerializableMembers(System.Type objectType) => throw null;
                public bool IgnoreIsSpecifiedMembers { get => throw null; set => throw null; }
                public bool IgnoreSerializableAttribute { get => throw null; set => throw null; }
                public bool IgnoreSerializableInterface { get => throw null; set => throw null; }
                public bool IgnoreShouldSerializeMembers { get => throw null; set => throw null; }
                public Newtonsoft.Json.Serialization.NamingStrategy NamingStrategy { get => throw null; set => throw null; }
                public virtual Newtonsoft.Json.Serialization.JsonContract ResolveContract(System.Type type) => throw null;
                protected virtual Newtonsoft.Json.JsonConverter ResolveContractConverter(System.Type objectType) => throw null;
                protected virtual string ResolveDictionaryKey(string dictionaryKey) => throw null;
                protected virtual string ResolveExtensionDataName(string extensionDataName) => throw null;
                protected virtual string ResolvePropertyName(string propertyName) => throw null;
                public bool SerializeCompilerGeneratedMembers { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Serialization.DefaultNamingStrategy` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class DefaultNamingStrategy : Newtonsoft.Json.Serialization.NamingStrategy
            {
                public DefaultNamingStrategy() => throw null;
                protected override string ResolvePropertyName(string name) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.DefaultSerializationBinder` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class DefaultSerializationBinder : System.Runtime.Serialization.SerializationBinder, Newtonsoft.Json.Serialization.ISerializationBinder
            {
                public override void BindToName(System.Type serializedType, out string assemblyName, out string typeName) => throw null;
                public override System.Type BindToType(string assemblyName, string typeName) => throw null;
                public DefaultSerializationBinder() => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.DiagnosticsTraceWriter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class DiagnosticsTraceWriter : Newtonsoft.Json.Serialization.ITraceWriter
            {
                public DiagnosticsTraceWriter() => throw null;
                public System.Diagnostics.TraceLevel LevelFilter { get => throw null; set => throw null; }
                public void Trace(System.Diagnostics.TraceLevel level, string message, System.Exception ex) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.ErrorContext` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class ErrorContext
            {
                public System.Exception Error { get => throw null; }
                public bool Handled { get => throw null; set => throw null; }
                public object Member { get => throw null; }
                public object OriginalObject { get => throw null; }
                public string Path { get => throw null; }
            }

            // Generated from `Newtonsoft.Json.Serialization.ErrorEventArgs` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class ErrorEventArgs : System.EventArgs
            {
                public object CurrentObject { get => throw null; }
                public Newtonsoft.Json.Serialization.ErrorContext ErrorContext { get => throw null; }
                public ErrorEventArgs(object currentObject, Newtonsoft.Json.Serialization.ErrorContext errorContext) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.ExpressionValueProvider` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class ExpressionValueProvider : Newtonsoft.Json.Serialization.IValueProvider
            {
                public ExpressionValueProvider(System.Reflection.MemberInfo memberInfo) => throw null;
                public object GetValue(object target) => throw null;
                public void SetValue(object target, object value) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.ExtensionDataGetter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public delegate System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<object, object>> ExtensionDataGetter(object o);

            // Generated from `Newtonsoft.Json.Serialization.ExtensionDataSetter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public delegate void ExtensionDataSetter(object o, string key, object value);

            // Generated from `Newtonsoft.Json.Serialization.IAttributeProvider` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public interface IAttributeProvider
            {
                System.Collections.Generic.IList<System.Attribute> GetAttributes(bool inherit);
                System.Collections.Generic.IList<System.Attribute> GetAttributes(System.Type attributeType, bool inherit);
            }

            // Generated from `Newtonsoft.Json.Serialization.IContractResolver` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public interface IContractResolver
            {
                Newtonsoft.Json.Serialization.JsonContract ResolveContract(System.Type type);
            }

            // Generated from `Newtonsoft.Json.Serialization.IReferenceResolver` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public interface IReferenceResolver
            {
                void AddReference(object context, string reference, object value);
                string GetReference(object context, object value);
                bool IsReferenced(object context, object value);
                object ResolveReference(object context, string reference);
            }

            // Generated from `Newtonsoft.Json.Serialization.ISerializationBinder` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public interface ISerializationBinder
            {
                void BindToName(System.Type serializedType, out string assemblyName, out string typeName);
                System.Type BindToType(string assemblyName, string typeName);
            }

            // Generated from `Newtonsoft.Json.Serialization.ITraceWriter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public interface ITraceWriter
            {
                System.Diagnostics.TraceLevel LevelFilter { get; }
                void Trace(System.Diagnostics.TraceLevel level, string message, System.Exception ex);
            }

            // Generated from `Newtonsoft.Json.Serialization.IValueProvider` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public interface IValueProvider
            {
                object GetValue(object target);
                void SetValue(object target, object value);
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonArrayContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonArrayContract : Newtonsoft.Json.Serialization.JsonContainerContract
            {
                public System.Type CollectionItemType { get => throw null; }
                public bool HasParameterizedCreator { get => throw null; set => throw null; }
                public bool IsMultidimensionalArray { get => throw null; }
                public JsonArrayContract(System.Type underlyingType) : base(default(System.Type)) => throw null;
                public Newtonsoft.Json.Serialization.ObjectConstructor<object> OverrideCreator { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonContainerContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonContainerContract : Newtonsoft.Json.Serialization.JsonContract
            {
                public Newtonsoft.Json.JsonConverter ItemConverter { get => throw null; set => throw null; }
                public bool? ItemIsReference { get => throw null; set => throw null; }
                public Newtonsoft.Json.ReferenceLoopHandling? ItemReferenceLoopHandling { get => throw null; set => throw null; }
                public Newtonsoft.Json.TypeNameHandling? ItemTypeNameHandling { get => throw null; set => throw null; }
                internal JsonContainerContract(System.Type underlyingType) : base(default(System.Type)) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public abstract class JsonContract
            {
                public Newtonsoft.Json.JsonConverter Converter { get => throw null; set => throw null; }
                public System.Type CreatedType { get => throw null; set => throw null; }
                public System.Func<object> DefaultCreator { get => throw null; set => throw null; }
                public bool DefaultCreatorNonPublic { get => throw null; set => throw null; }
                public Newtonsoft.Json.JsonConverter InternalConverter { get => throw null; set => throw null; }
                public bool? IsReference { get => throw null; set => throw null; }
                internal JsonContract(System.Type underlyingType) => throw null;
                public System.Collections.Generic.IList<Newtonsoft.Json.Serialization.SerializationCallback> OnDeserializedCallbacks { get => throw null; }
                public System.Collections.Generic.IList<Newtonsoft.Json.Serialization.SerializationCallback> OnDeserializingCallbacks { get => throw null; }
                public System.Collections.Generic.IList<Newtonsoft.Json.Serialization.SerializationErrorCallback> OnErrorCallbacks { get => throw null; }
                public System.Collections.Generic.IList<Newtonsoft.Json.Serialization.SerializationCallback> OnSerializedCallbacks { get => throw null; }
                public System.Collections.Generic.IList<Newtonsoft.Json.Serialization.SerializationCallback> OnSerializingCallbacks { get => throw null; }
                public System.Type UnderlyingType { get => throw null; }
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonDictionaryContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonDictionaryContract : Newtonsoft.Json.Serialization.JsonContainerContract
            {
                public System.Func<string, string> DictionaryKeyResolver { get => throw null; set => throw null; }
                public System.Type DictionaryKeyType { get => throw null; }
                public System.Type DictionaryValueType { get => throw null; }
                public bool HasParameterizedCreator { get => throw null; set => throw null; }
                public JsonDictionaryContract(System.Type underlyingType) : base(default(System.Type)) => throw null;
                public Newtonsoft.Json.Serialization.ObjectConstructor<object> OverrideCreator { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonDynamicContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonDynamicContract : Newtonsoft.Json.Serialization.JsonContainerContract
            {
                public JsonDynamicContract(System.Type underlyingType) : base(default(System.Type)) => throw null;
                public Newtonsoft.Json.Serialization.JsonPropertyCollection Properties { get => throw null; }
                public System.Func<string, string> PropertyNameResolver { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonISerializableContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonISerializableContract : Newtonsoft.Json.Serialization.JsonContainerContract
            {
                public Newtonsoft.Json.Serialization.ObjectConstructor<object> ISerializableCreator { get => throw null; set => throw null; }
                public JsonISerializableContract(System.Type underlyingType) : base(default(System.Type)) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonLinqContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonLinqContract : Newtonsoft.Json.Serialization.JsonContract
            {
                public JsonLinqContract(System.Type underlyingType) : base(default(System.Type)) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonObjectContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonObjectContract : Newtonsoft.Json.Serialization.JsonContainerContract
            {
                public Newtonsoft.Json.Serialization.JsonPropertyCollection CreatorParameters { get => throw null; }
                public Newtonsoft.Json.Serialization.ExtensionDataGetter ExtensionDataGetter { get => throw null; set => throw null; }
                public System.Func<string, string> ExtensionDataNameResolver { get => throw null; set => throw null; }
                public Newtonsoft.Json.Serialization.ExtensionDataSetter ExtensionDataSetter { get => throw null; set => throw null; }
                public System.Type ExtensionDataValueType { get => throw null; set => throw null; }
                public Newtonsoft.Json.NullValueHandling? ItemNullValueHandling { get => throw null; set => throw null; }
                public Newtonsoft.Json.Required? ItemRequired { get => throw null; set => throw null; }
                public JsonObjectContract(System.Type underlyingType) : base(default(System.Type)) => throw null;
                public Newtonsoft.Json.MemberSerialization MemberSerialization { get => throw null; set => throw null; }
                public Newtonsoft.Json.MissingMemberHandling? MissingMemberHandling { get => throw null; set => throw null; }
                public Newtonsoft.Json.Serialization.ObjectConstructor<object> OverrideCreator { get => throw null; set => throw null; }
                public Newtonsoft.Json.Serialization.JsonPropertyCollection Properties { get => throw null; }
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonPrimitiveContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonPrimitiveContract : Newtonsoft.Json.Serialization.JsonContract
            {
                public JsonPrimitiveContract(System.Type underlyingType) : base(default(System.Type)) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonProperty` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonProperty
            {
                public Newtonsoft.Json.Serialization.IAttributeProvider AttributeProvider { get => throw null; set => throw null; }
                public Newtonsoft.Json.JsonConverter Converter { get => throw null; set => throw null; }
                public System.Type DeclaringType { get => throw null; set => throw null; }
                public object DefaultValue { get => throw null; set => throw null; }
                public Newtonsoft.Json.DefaultValueHandling? DefaultValueHandling { get => throw null; set => throw null; }
                public System.Predicate<object> GetIsSpecified { get => throw null; set => throw null; }
                public bool HasMemberAttribute { get => throw null; set => throw null; }
                public bool Ignored { get => throw null; set => throw null; }
                public bool? IsReference { get => throw null; set => throw null; }
                public bool IsRequiredSpecified { get => throw null; }
                public Newtonsoft.Json.JsonConverter ItemConverter { get => throw null; set => throw null; }
                public bool? ItemIsReference { get => throw null; set => throw null; }
                public Newtonsoft.Json.ReferenceLoopHandling? ItemReferenceLoopHandling { get => throw null; set => throw null; }
                public Newtonsoft.Json.TypeNameHandling? ItemTypeNameHandling { get => throw null; set => throw null; }
                public JsonProperty() => throw null;
                public Newtonsoft.Json.JsonConverter MemberConverter { get => throw null; set => throw null; }
                public Newtonsoft.Json.NullValueHandling? NullValueHandling { get => throw null; set => throw null; }
                public Newtonsoft.Json.ObjectCreationHandling? ObjectCreationHandling { get => throw null; set => throw null; }
                public int? Order { get => throw null; set => throw null; }
                public string PropertyName { get => throw null; set => throw null; }
                public System.Type PropertyType { get => throw null; set => throw null; }
                public bool Readable { get => throw null; set => throw null; }
                public Newtonsoft.Json.ReferenceLoopHandling? ReferenceLoopHandling { get => throw null; set => throw null; }
                public Newtonsoft.Json.Required Required { get => throw null; set => throw null; }
                public System.Action<object, object> SetIsSpecified { get => throw null; set => throw null; }
                public System.Predicate<object> ShouldDeserialize { get => throw null; set => throw null; }
                public System.Predicate<object> ShouldSerialize { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public Newtonsoft.Json.TypeNameHandling? TypeNameHandling { get => throw null; set => throw null; }
                public string UnderlyingName { get => throw null; set => throw null; }
                public Newtonsoft.Json.Serialization.IValueProvider ValueProvider { get => throw null; set => throw null; }
                public bool Writable { get => throw null; set => throw null; }
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonPropertyCollection` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonPropertyCollection : System.Collections.ObjectModel.KeyedCollection<string, Newtonsoft.Json.Serialization.JsonProperty>
            {
                public void AddProperty(Newtonsoft.Json.Serialization.JsonProperty property) => throw null;
                public Newtonsoft.Json.Serialization.JsonProperty GetClosestMatchProperty(string propertyName) => throw null;
                protected override string GetKeyForItem(Newtonsoft.Json.Serialization.JsonProperty item) => throw null;
                public Newtonsoft.Json.Serialization.JsonProperty GetProperty(string propertyName, System.StringComparison comparisonType) => throw null;
                public JsonPropertyCollection(System.Type type) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.JsonStringContract` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class JsonStringContract : Newtonsoft.Json.Serialization.JsonPrimitiveContract
            {
                public JsonStringContract(System.Type underlyingType) : base(default(System.Type)) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.KebabCaseNamingStrategy` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class KebabCaseNamingStrategy : Newtonsoft.Json.Serialization.NamingStrategy
            {
                public KebabCaseNamingStrategy(bool processDictionaryKeys, bool overrideSpecifiedNames, bool processExtensionDataNames) => throw null;
                public KebabCaseNamingStrategy(bool processDictionaryKeys, bool overrideSpecifiedNames) => throw null;
                public KebabCaseNamingStrategy() => throw null;
                protected override string ResolvePropertyName(string name) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.MemoryTraceWriter` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class MemoryTraceWriter : Newtonsoft.Json.Serialization.ITraceWriter
            {
                public System.Collections.Generic.IEnumerable<string> GetTraceMessages() => throw null;
                public System.Diagnostics.TraceLevel LevelFilter { get => throw null; set => throw null; }
                public MemoryTraceWriter() => throw null;
                public override string ToString() => throw null;
                public void Trace(System.Diagnostics.TraceLevel level, string message, System.Exception ex) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.NamingStrategy` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public abstract class NamingStrategy
            {
                public override bool Equals(object obj) => throw null;
                protected bool Equals(Newtonsoft.Json.Serialization.NamingStrategy other) => throw null;
                public virtual string GetDictionaryKey(string key) => throw null;
                public virtual string GetExtensionDataName(string name) => throw null;
                public override int GetHashCode() => throw null;
                public virtual string GetPropertyName(string name, bool hasSpecifiedName) => throw null;
                protected NamingStrategy() => throw null;
                public bool OverrideSpecifiedNames { get => throw null; set => throw null; }
                public bool ProcessDictionaryKeys { get => throw null; set => throw null; }
                public bool ProcessExtensionDataNames { get => throw null; set => throw null; }
                protected abstract string ResolvePropertyName(string name);
            }

            // Generated from `Newtonsoft.Json.Serialization.ObjectConstructor<>` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public delegate object ObjectConstructor<T>(params object[] args);

            // Generated from `Newtonsoft.Json.Serialization.OnErrorAttribute` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class OnErrorAttribute : System.Attribute
            {
                public OnErrorAttribute() => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.ReflectionAttributeProvider` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class ReflectionAttributeProvider : Newtonsoft.Json.Serialization.IAttributeProvider
            {
                public System.Collections.Generic.IList<System.Attribute> GetAttributes(bool inherit) => throw null;
                public System.Collections.Generic.IList<System.Attribute> GetAttributes(System.Type attributeType, bool inherit) => throw null;
                public ReflectionAttributeProvider(object attributeProvider) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.ReflectionValueProvider` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class ReflectionValueProvider : Newtonsoft.Json.Serialization.IValueProvider
            {
                public object GetValue(object target) => throw null;
                public ReflectionValueProvider(System.Reflection.MemberInfo memberInfo) => throw null;
                public void SetValue(object target, object value) => throw null;
            }

            // Generated from `Newtonsoft.Json.Serialization.SerializationCallback` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public delegate void SerializationCallback(object o, System.Runtime.Serialization.StreamingContext context);

            // Generated from `Newtonsoft.Json.Serialization.SerializationErrorCallback` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public delegate void SerializationErrorCallback(object o, System.Runtime.Serialization.StreamingContext context, Newtonsoft.Json.Serialization.ErrorContext errorContext);

            // Generated from `Newtonsoft.Json.Serialization.SnakeCaseNamingStrategy` in `Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed`
            public class SnakeCaseNamingStrategy : Newtonsoft.Json.Serialization.NamingStrategy
            {
                protected override string ResolvePropertyName(string name) => throw null;
                public SnakeCaseNamingStrategy(bool processDictionaryKeys, bool overrideSpecifiedNames, bool processExtensionDataNames) => throw null;
                public SnakeCaseNamingStrategy(bool processDictionaryKeys, bool overrideSpecifiedNames) => throw null;
                public SnakeCaseNamingStrategy() => throw null;
            }

        }
    }
}
namespace System
{
    namespace Diagnostics
    {
        namespace CodeAnalysis
        {
            /* Duplicate type 'AllowNullAttribute' is not stubbed in this assembly 'Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'. */

            /* Duplicate type 'DoesNotReturnIfAttribute' is not stubbed in this assembly 'Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'. */

            /* Duplicate type 'MaybeNullAttribute' is not stubbed in this assembly 'Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'. */

            /* Duplicate type 'NotNullAttribute' is not stubbed in this assembly 'Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'. */

            /* Duplicate type 'NotNullWhenAttribute' is not stubbed in this assembly 'Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'. */

        }
    }
    namespace Runtime
    {
        namespace CompilerServices
        {
            /* Duplicate type 'IsReadOnlyAttribute' is not stubbed in this assembly 'Newtonsoft.Json, Version=13.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed'. */

        }
    }
}
