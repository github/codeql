// This file contains auto-generated code.
// Generated from `ServiceStack.Text, Version=6.0.0.0, Culture=neutral, PublicKeyToken=null`.
namespace ServiceStack
{
    public class AssignmentEntry
    {
        public ServiceStack.GetMemberDelegate ConvertValueFn;
        public AssignmentEntry(string name, ServiceStack.AssignmentMember from, ServiceStack.AssignmentMember to) => throw null;
        public ServiceStack.AssignmentMember From;
        public ServiceStack.GetMemberDelegate GetValueFn;
        public string Name;
        public ServiceStack.SetMemberDelegate SetValueFn;
        public ServiceStack.AssignmentMember To;
    }
    public class AssignmentMember
    {
        public ServiceStack.GetMemberDelegate CreateGetter() => throw null;
        public ServiceStack.SetMemberDelegate CreateSetter() => throw null;
        public AssignmentMember(System.Type type, System.Reflection.PropertyInfo propertyInfo) => throw null;
        public AssignmentMember(System.Type type, System.Reflection.FieldInfo fieldInfo) => throw null;
        public AssignmentMember(System.Type type, System.Reflection.MethodInfo methodInfo) => throw null;
        public System.Reflection.FieldInfo FieldInfo;
        public System.Reflection.MethodInfo MethodInfo;
        public System.Reflection.PropertyInfo PropertyInfo;
        public System.Type Type;
    }
    public static class AutoMapping
    {
        public static void IgnoreMapping<From, To>() => throw null;
        public static void IgnoreMapping(System.Type fromType, System.Type toType) => throw null;
        public static void RegisterConverter<From, To>(System.Func<From, To> converter) => throw null;
        public static void RegisterPopulator<Target, Source>(System.Action<Target, Source> populator) => throw null;
    }
    public static class AutoMappingUtils
    {
        public static bool CanCast(System.Type toType, System.Type fromType) => throw null;
        public static object ChangeTo(this string strValue, System.Type type) => throw null;
        public static object ChangeValueType(object from, System.Type toType) => throw null;
        public static T ConvertTo<T>(this object from, T defaultValue) => throw null;
        public static T ConvertTo<T>(this object from) => throw null;
        public static T ConvertTo<T>(this object from, bool skipConverters) => throw null;
        public static object ConvertTo(this object from, System.Type toType) => throw null;
        public static object ConvertTo(this object from, System.Type toType, bool skipConverters) => throw null;
        public static T CreateCopy<T>(this T from) => throw null;
        public static object CreateDefaultValue(System.Type type, System.Collections.Generic.Dictionary<System.Type, int> recursionInfo) => throw null;
        public static object[] CreateDefaultValues(System.Collections.Generic.IEnumerable<System.Type> types, System.Collections.Generic.Dictionary<System.Type, int> recursionInfo) => throw null;
        public static string GetAssemblyPath(this System.Type source) => throw null;
        public static ServiceStack.GetMemberDelegate GetConverter(System.Type fromType, System.Type toType) => throw null;
        public static object GetDefaultValue(this System.Type type) => throw null;
        public static System.Reflection.MethodInfo GetExplicitCastMethod(System.Type fromType, System.Type toType) => throw null;
        public static System.Reflection.MethodInfo GetImplicitCastMethod(System.Type fromType, System.Type toType) => throw null;
        public static ServiceStack.PopulateMemberDelegate GetPopulator(System.Type targetType, System.Type sourceType) => throw null;
        public static object GetProperty(this System.Reflection.PropertyInfo propertyInfo, object obj) => throw null;
        public static System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<System.Reflection.PropertyInfo, T>> GetPropertyAttributes<T>(System.Type fromType) => throw null;
        public static System.Collections.Generic.List<string> GetPropertyNames(this System.Type type) => throw null;
        public static bool IsDebugBuild(this System.Reflection.Assembly assembly) => throw null;
        public static bool IsDefaultValue(object value) => throw null;
        public static bool IsDefaultValue(object value, System.Type valueType) => throw null;
        public static bool IsUnsettableValue(System.Reflection.FieldInfo fieldInfo, System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static System.Array PopulateArray(System.Type type, System.Collections.Generic.Dictionary<System.Type, int> recursionInfo) => throw null;
        public static To PopulateFromPropertiesWithAttribute<To, From>(this To to, From from, System.Type attributeType) => throw null;
        public static To PopulateFromPropertiesWithoutAttribute<To, From>(this To to, From from, System.Type attributeType) => throw null;
        public static object PopulateWith(object obj) => throw null;
        public static To PopulateWith<To, From>(this To to, From from) => throw null;
        public static To PopulateWithNonDefaultValues<To, From>(this To to, From from) => throw null;
        public static void Reset() => throw null;
        public static void SetGenericCollection(System.Type realizedListType, object genericObj, System.Collections.Generic.Dictionary<System.Type, int> recursionInfo) => throw null;
        public static void SetProperty(this System.Reflection.PropertyInfo propertyInfo, object obj, object value) => throw null;
        public static void SetValue(System.Reflection.FieldInfo fieldInfo, System.Reflection.PropertyInfo propertyInfo, object obj, object value) => throw null;
        public static bool ShouldIgnoreMapping(System.Type fromType, System.Type toType) => throw null;
        public static To ThenDo<To>(this To to, System.Action<To> fn) => throw null;
        public static object TryConvertCollections(System.Type fromType, System.Type toType, object fromValue) => throw null;
    }
    public static partial class CollectionExtensions
    {
        public static object Convert<T>(object objCollection, System.Type toCollectionType) => throw null;
        public static System.Collections.Generic.ICollection<T> CreateAndPopulate<T>(System.Type ofCollectionType, T[] withItems) => throw null;
        public static System.Collections.Generic.IEnumerable<T> OrEmpty<T>(this System.Collections.Generic.IEnumerable<T> enumerable) => throw null;
        public static System.Collections.IEnumerable OrEmpty(this System.Collections.IEnumerable enumerable) => throw null;
        public static T[] ToArray<T>(this System.Collections.Generic.ICollection<T> collection) => throw null;
    }
    public static class CompressionTypes
    {
        public static readonly string[] AllCompressionTypes;
        public static void AssertIsValid(string compressionType) => throw null;
        public const string Brotli = default;
        public const string Default = default;
        public const string Deflate = default;
        public static string GetExtension(string compressionType) => throw null;
        public const string GZip = default;
        public static bool IsValid(string compressionType) => throw null;
    }
    public class CustomHttpResult
    {
        public CustomHttpResult() => throw null;
    }
    public struct Defer : System.IDisposable
    {
        public Defer(System.Action fn) => throw null;
        public void Dispose() => throw null;
    }
    public static class DeserializeDynamic<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
    {
        public static ServiceStack.Text.Common.ParseStringDelegate Parse { get => throw null; }
        public static System.Dynamic.IDynamicMetaObjectProvider ParseDynamic(string value) => throw null;
        public static System.Dynamic.IDynamicMetaObjectProvider ParseDynamic(System.ReadOnlySpan<char> value) => throw null;
        public static ServiceStack.Text.Common.ParseStringSpanDelegate ParseStringSpan { get => throw null; }
    }
    public abstract class DiagnosticEvent
    {
        public System.Guid? ClientOperationId { get => throw null; set { } }
        protected DiagnosticEvent() => throw null;
        public System.DateTime Date { get => throw null; set { } }
        public object DiagnosticEntry { get => throw null; set { } }
        public string EventType { get => throw null; set { } }
        public System.Exception Exception { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Operation { get => throw null; set { } }
        public System.Guid OperationId { get => throw null; set { } }
        public virtual string Source { get => throw null; }
        public string StackTrace { get => throw null; set { } }
        public string Tag { get => throw null; set { } }
        public long Timestamp { get => throw null; set { } }
        public string TraceId { get => throw null; set { } }
        public string UserAuthId { get => throw null; set { } }
    }
    public class Diagnostics
    {
        public static class Activity
        {
            public const string HttpBegin = default;
            public const string HttpEnd = default;
            public const string MqBegin = default;
            public const string MqEnd = default;
            public const string OperationId = default;
            public const string Tag = default;
            public const string UserId = default;
        }
        public static System.Diagnostics.DiagnosticListener Client { get => throw null; }
        public static string CreateStackTrace(System.Exception e) => throw null;
        public static class Events
        {
            public static class Client
            {
                public const string WriteRequestAfter = default;
                public const string WriteRequestBefore = default;
                public const string WriteRequestError = default;
            }
            public static class HttpClient
            {
                public const string OutStart = default;
                public const string OutStop = default;
                public const string Request = default;
                public const string Response = default;
            }
            public static class OrmLite
            {
                public const string WriteCommandAfter = default;
                public const string WriteCommandBefore = default;
                public const string WriteCommandError = default;
                public const string WriteConnectionCloseAfter = default;
                public const string WriteConnectionCloseBefore = default;
                public const string WriteConnectionCloseError = default;
                public const string WriteConnectionOpenAfter = default;
                public const string WriteConnectionOpenBefore = default;
                public const string WriteConnectionOpenError = default;
                public const string WriteTransactionCommitAfter = default;
                public const string WriteTransactionCommitBefore = default;
                public const string WriteTransactionCommitError = default;
                public const string WriteTransactionOpen = default;
                public const string WriteTransactionRollbackAfter = default;
                public const string WriteTransactionRollbackBefore = default;
                public const string WriteTransactionRollbackError = default;
            }
            public static class Redis
            {
                public const string WriteCommandAfter = default;
                public const string WriteCommandBefore = default;
                public const string WriteCommandError = default;
                public const string WriteCommandRetry = default;
                public const string WriteConnectionCloseAfter = default;
                public const string WriteConnectionCloseBefore = default;
                public const string WriteConnectionCloseError = default;
                public const string WriteConnectionOpenAfter = default;
                public const string WriteConnectionOpenBefore = default;
                public const string WriteConnectionOpenError = default;
                public const string WritePoolRent = default;
                public const string WritePoolReturn = default;
            }
            public static class ServiceStack
            {
                public const string WriteGatewayAfter = default;
                public const string WriteGatewayBefore = default;
                public const string WriteGatewayError = default;
                public const string WriteMqRequestAfter = default;
                public const string WriteMqRequestBefore = default;
                public const string WriteMqRequestError = default;
                public const string WriteMqRequestPublish = default;
                public const string WriteRequestAfter = default;
                public const string WriteRequestBefore = default;
                public const string WriteRequestError = default;
            }
        }
        public static bool IncludeStackTrace { get => throw null; set { } }
        public static class Keys
        {
            public const string Date = default;
            public static readonly System.Net.Http.HttpRequestOptionsKey<System.Guid> HttpRequestOperationId;
            public static readonly System.Net.Http.HttpRequestOptionsKey<object> HttpRequestRequest;
            public static readonly System.Net.Http.HttpRequestOptionsKey<object> HttpRequestResponseType;
            public const string LoggingRequestId = default;
            public const string OperationId = default;
            public const string Request = default;
            public const string Response = default;
            public const string ResponseType = default;
            public const string Timestamp = default;
        }
        public static class Listeners
        {
            public const string Client = default;
            public const string HttpClient = default;
            public const string OrmLite = default;
            public const string Redis = default;
            public const string ServiceStack = default;
        }
        public static System.Diagnostics.DiagnosticListener OrmLite { get => throw null; }
        public static System.Diagnostics.DiagnosticListener Redis { get => throw null; }
        public static System.Diagnostics.DiagnosticListener ServiceStack { get => throw null; }
    }
    public static class DiagnosticsUtils
    {
        public static System.Diagnostics.Activity GetRoot(System.Diagnostics.Activity activity) => throw null;
        public static string GetTag(this System.Diagnostics.Activity activity) => throw null;
        public static string GetTraceId(this System.Diagnostics.Activity activity) => throw null;
        public static string GetUserId(this System.Diagnostics.Activity activity) => throw null;
        public static T Init<T>(this T evt, System.Diagnostics.Activity activity) where T : ServiceStack.DiagnosticEvent => throw null;
    }
    public class DynamicByte : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public byte Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicByte() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicByte Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public class DynamicDecimal : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public decimal Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicDecimal() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicDecimal Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public class DynamicDouble : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public double Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicDouble() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicDouble Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public class DynamicFloat : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public float Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicFloat() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicFloat Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public class DynamicInt : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public int Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicInt() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicInt Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public class DynamicJson : System.Dynamic.DynamicObject
    {
        public DynamicJson(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> hash) => throw null;
        public static dynamic Deserialize(string json) => throw null;
        public static string Serialize(dynamic instance) => throw null;
        public override string ToString() => throw null;
        public override bool TryGetMember(System.Dynamic.GetMemberBinder binder, out object result) => throw null;
        public override bool TrySetMember(System.Dynamic.SetMemberBinder binder, object value) => throw null;
    }
    public class DynamicLong : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public long Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicLong() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicLong Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public static class DynamicNumber
    {
        public static object Add(object lhs, object rhs) => throw null;
        public static ServiceStack.IDynamicNumber AssertNumbers(string name, object lhs, object rhs) => throw null;
        public static object BitwiseAnd(object lhs, object rhs) => throw null;
        public static object BitwiseLeftShift(object lhs, object rhs) => throw null;
        public static object BitwiseNot(object lhs) => throw null;
        public static object BitwiseOr(object lhs, object rhs) => throw null;
        public static object BitwiseRightShift(object lhs, object rhs) => throw null;
        public static object BitwiseXOr(object lhs, object rhs) => throw null;
        public static int CompareTo(object lhs, object rhs) => throw null;
        public static object Div(object lhs, object rhs) => throw null;
        public static object Divide(object lhs, object rhs) => throw null;
        public static ServiceStack.IDynamicNumber Get(object obj) => throw null;
        public static ServiceStack.IDynamicNumber GetNumber(System.Type type) => throw null;
        public static ServiceStack.IDynamicNumber GetNumber(object lhs, object rhs) => throw null;
        public static bool IsNumber(System.Type type) => throw null;
        public static object Log(object lhs, object rhs) => throw null;
        public static object Max(object lhs, object rhs) => throw null;
        public static object Min(object lhs, object rhs) => throw null;
        public static object Mod(object lhs, object rhs) => throw null;
        public static object Mul(object lhs, object rhs) => throw null;
        public static object Multiply(object lhs, object rhs) => throw null;
        public static object Pow(object lhs, object rhs) => throw null;
        public static object Sub(object lhs, object rhs) => throw null;
        public static object Subtract(object lhs, object rhs) => throw null;
        public static bool TryGetRanking(System.Type type, out int ranking) => throw null;
        public static bool TryParse(string strValue, out object result) => throw null;
        public static bool TryParseIntoBestFit(string strValue, out object result) => throw null;
    }
    public class DynamicSByte : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public sbyte Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicSByte() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicSByte Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public class DynamicShort : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public short Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicShort() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicShort Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public class DynamicUInt : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public uint Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicUInt() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicUInt Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public class DynamicULong : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public ulong Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicULong() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicULong Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public class DynamicUShort : ServiceStack.IDynamicNumber
    {
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public ushort Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public DynamicUShort() => throw null;
        public object DefaultValue { get => throw null; }
        public object div(object lhs, object rhs) => throw null;
        public static ServiceStack.DynamicUShort Instance;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
    }
    public delegate object EmptyCtorDelegate();
    public delegate ServiceStack.EmptyCtorDelegate EmptyCtorFactoryDelegate(System.Type type);
    namespace Extensions
    {
        public static partial class ServiceStackExtensions
        {
            public static System.ReadOnlyMemory<char> Trim(this System.ReadOnlyMemory<char> span) => throw null;
            public static System.ReadOnlyMemory<char> TrimEnd(this System.ReadOnlyMemory<char> value) => throw null;
            public static System.ReadOnlyMemory<char> TrimStart(this System.ReadOnlyMemory<char> value) => throw null;
        }
    }
    public class FieldAccessor
    {
        public FieldAccessor(System.Reflection.FieldInfo fieldInfo, ServiceStack.GetMemberDelegate publicGetter, ServiceStack.SetMemberDelegate publicSetter, ServiceStack.SetMemberRefDelegate publicSetterRef) => throw null;
        public System.Reflection.FieldInfo FieldInfo { get => throw null; }
        public ServiceStack.GetMemberDelegate PublicGetter { get => throw null; }
        public ServiceStack.SetMemberDelegate PublicSetter { get => throw null; }
        public ServiceStack.SetMemberRefDelegate PublicSetterRef { get => throw null; }
    }
    public static class FieldInvoker
    {
        public static ServiceStack.GetMemberDelegate CreateGetter(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static ServiceStack.GetMemberDelegate<T> CreateGetter<T>(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static ServiceStack.SetMemberDelegate CreateSetter(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static ServiceStack.SetMemberDelegate<T> CreateSetter<T>(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static ServiceStack.SetMemberRefDelegate<T> SetExpressionRef<T>(this System.Reflection.FieldInfo fieldInfo) => throw null;
    }
    public delegate object GetMemberDelegate(object instance);
    public delegate object GetMemberDelegate<T>(T instance);
    public static class HttpClientExt
    {
        public static long? GetContentLength(this System.Net.Http.HttpResponseMessage res) => throw null;
        public static bool MatchesContentType(this System.Net.Http.HttpResponseMessage res, string matchesContentType) => throw null;
    }
    public static class HttpHeaders
    {
        public const string Accept = default;
        public const string AcceptCharset = default;
        public const string AcceptEncoding = default;
        public const string AcceptLanguage = default;
        public const string AcceptRanges = default;
        public const string AccessControlMaxAge = default;
        public const string Age = default;
        public const string Allow = default;
        public const string AllowCredentials = default;
        public const string AllowHeaders = default;
        public const string AllowMethods = default;
        public const string AllowOrigin = default;
        public const string Authorization = default;
        public const string CacheControl = default;
        public const string Connection = default;
        public const string ContentDisposition = default;
        public const string ContentEncoding = default;
        public const string ContentLanguage = default;
        public const string ContentLength = default;
        public const string ContentRange = default;
        public const string ContentType = default;
        public const string Cookie = default;
        public const string Date = default;
        public const string ETag = default;
        public const string Expect = default;
        public const string Expires = default;
        public const string ExposeHeaders = default;
        public const string Host = default;
        public const string IfMatch = default;
        public const string IfModifiedSince = default;
        public const string IfNoneMatch = default;
        public const string IfUnmodifiedSince = default;
        public const string LastModified = default;
        public const string Location = default;
        public const string Origin = default;
        public const string Pragma = default;
        public const string ProxyAuthenticate = default;
        public const string ProxyAuthorization = default;
        public const string ProxyConnection = default;
        public const string Range = default;
        public const string Referer = default;
        public const string RequestHeaders = default;
        public const string RequestMethod = default;
        public static System.Collections.Generic.HashSet<string> RestrictedHeaders;
        public const string SetCookie = default;
        public const string SetCookie2 = default;
        public const string SOAPAction = default;
        public const string TE = default;
        public const string Trailer = default;
        public const string TransferEncoding = default;
        public const string Upgrade = default;
        public const string UserAgent = default;
        public const string Vary = default;
        public const string Via = default;
        public const string Warning = default;
        public const string WwwAuthenticate = default;
        public const string XAccelBuffering = default;
        public const string XAutoBatchCompleted = default;
        public const string XForwardedFor = default;
        public const string XForwardedPort = default;
        public const string XForwardedProtocol = default;
        public const string XHttpMethodOverride = default;
        public const string XLocation = default;
        public const string XParamOverridePrefix = default;
        public const string XPoweredBy = default;
        public const string XRealIp = default;
        public const string XStatus = default;
        public const string XTag = default;
        public const string XTrigger = default;
        public const string XUserAuthId = default;
    }
    public static class HttpMethods
    {
        public static System.Collections.Generic.HashSet<string> AllVerbs;
        public const string Connect = default;
        public const string Delete = default;
        public static bool Equals(string methodA, string methodB) => throw null;
        public static bool Exists(string httpMethod) => throw null;
        public const string Get = default;
        public static string GetCanonicalizedValue(string method) => throw null;
        public static bool HasVerb(string httpVerb) => throw null;
        public const string Head = default;
        public static bool IsConnect(string method) => throw null;
        public static bool IsDelete(string method) => throw null;
        public static bool IsGet(string method) => throw null;
        public static bool IsHead(string method) => throw null;
        public static bool IsOptions(string method) => throw null;
        public static bool IsPatch(string method) => throw null;
        public static bool IsPost(string method) => throw null;
        public static bool IsPut(string method) => throw null;
        public static bool IsTrace(string method) => throw null;
        public const string Options = default;
        public const string Patch = default;
        public const string Post = default;
        public const string Put = default;
        public const string Trace = default;
    }
    public class HttpRequestConfig
    {
        public string Accept { get => throw null; set { } }
        public void AddHeader(string name, string value) => throw null;
        public ServiceStack.NameValue Authorization { get => throw null; set { } }
        public string ContentType { get => throw null; set { } }
        public HttpRequestConfig() => throw null;
        public string Expect { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.NameValue> Headers { get => throw null; set { } }
        public ServiceStack.LongRange Range { get => throw null; set { } }
        public string Referer { get => throw null; set { } }
        public void SetAuthBasic(string name, string value) => throw null;
        public void SetAuthBasicRaw(string value) => throw null;
        public void SetAuthBearer(string value) => throw null;
        public void SetRange(long from, long? to = default(long?)) => throw null;
        public string[] TransferEncoding { get => throw null; set { } }
        public bool? TransferEncodingChunked { get => throw null; set { } }
        public string UserAgent { get => throw null; set { } }
    }
    public static class HttpUtils
    {
        public static string AddHashParam(this string url, string key, object val) => throw null;
        public static string AddHashParam(this string url, string key, string val) => throw null;
        public static void AddHeader(this System.Net.Http.HttpRequestMessage res, string name, string value) => throw null;
        public static string AddNameValueCollection(this string url, System.Collections.Specialized.NameValueCollection queryParams) => throw null;
        public static string AddQueryParam(this string url, string key, object val, bool encode = default(bool)) => throw null;
        public static string AddQueryParam(this string url, object key, string val, bool encode = default(bool)) => throw null;
        public static string AddQueryParam(this string url, string key, string val, bool encode = default(bool)) => throw null;
        public static string AddQueryParams(this string url, System.Collections.Generic.Dictionary<string, object> args) => throw null;
        public static System.Threading.Tasks.Task<TBase> ConvertTo<TDerived, TBase>(this System.Threading.Tasks.Task<TDerived> task) where TDerived : TBase => throw null;
        public static System.Net.Http.HttpClient Create() => throw null;
        public static System.Func<System.Net.Http.HttpClient> CreateClient { get => throw null; set { } }
        public static string DeleteFromUrl(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> DeleteFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static void DownloadFileTo(this string downloadUrl, string fileName, System.Collections.Generic.List<ServiceStack.NameValue> headers = default(System.Collections.Generic.List<ServiceStack.NameValue>)) => throw null;
        public static byte[] GetBytesFromUrl(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<byte[]> GetBytesFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string GetCsvFromUrl(this string url, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> GetCsvFromUrlAsync(this string url, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Net.Http.HttpResponseMessage GetErrorResponse(this string url) => throw null;
        public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> GetErrorResponseAsync(this string url, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string GetHeader(this System.Net.Http.HttpRequestMessage req, string name) => throw null;
        public static string GetHeader(this System.Net.Http.HttpResponseMessage res, string name) => throw null;
        public static string GetJsonFromUrl(this string url, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> GetJsonFromUrlAsync(this string url, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> GetRequestStreamAsync(this System.Net.WebRequest request) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> GetRequestStreamAsync(this System.Net.HttpWebRequest request) => throw null;
        public static System.Threading.Tasks.Task<System.Net.WebResponse> GetResponseAsync(this System.Net.WebRequest request) => throw null;
        public static System.Threading.Tasks.Task<System.Net.HttpWebResponse> GetResponseAsync(this System.Net.HttpWebRequest request) => throw null;
        public static string GetResponseBody(this System.Exception ex) => throw null;
        public static System.Threading.Tasks.Task<string> GetResponseBodyAsync(this System.Exception ex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Net.HttpStatusCode? GetResponseStatus(this string url) => throw null;
        public static System.Net.HttpStatusCode? GetStatus(this System.Exception ex) => throw null;
        public static System.Net.HttpStatusCode? GetStatus(this System.Net.Http.HttpRequestException ex) => throw null;
        public static System.Net.HttpStatusCode? GetStatus(this System.Net.WebException webEx) => throw null;
        public static System.IO.Stream GetStreamFromUrl(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> GetStreamFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string GetStringFromUrl(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> GetStringFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string GetXmlFromUrl(this string url, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> GetXmlFromUrlAsync(this string url, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static bool HasRequestBody(string httpMethod) => throw null;
        public static bool HasStatus(this System.Exception ex, System.Net.HttpStatusCode statusCode) => throw null;
        public static string HeadFromUrl(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> HeadFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Func<System.Net.Http.HttpClientHandler> HttpClientHandlerFactory { get => throw null; set { } }
        public static bool IsAny300(this System.Exception ex) => throw null;
        public static bool IsAny400(this System.Exception ex) => throw null;
        public static bool IsAny500(this System.Exception ex) => throw null;
        public static bool IsBadRequest(this System.Exception ex) => throw null;
        public static bool IsForbidden(this System.Exception ex) => throw null;
        public static bool IsInternalServerError(this System.Exception ex) => throw null;
        public static bool IsNotFound(this System.Exception ex) => throw null;
        public static bool IsNotModified(this System.Exception ex) => throw null;
        public static bool IsUnauthorized(this System.Exception ex) => throw null;
        public static string OptionsFromUrl(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> OptionsFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PatchJsonToUrl(this string url, string json, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PatchJsonToUrl(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchJsonToUrlAsync(this string url, string json, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchJsonToUrlAsync(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PatchStringToUrl(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchStringToUrlAsync(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PatchToUrl(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PatchToUrl(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchToUrlAsync(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchToUrlAsync(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static byte[] PostBytesToUrl(this string url, byte[] requestBody = default(byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<byte[]> PostBytesToUrlAsync(this string url, byte[] requestBody = default(byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostCsvToUrl(this string url, string csv, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PostCsvToUrl(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostCsvToUrlAsync(this string url, string csv, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Net.Http.HttpResponseMessage PostFileToUrl(this string url, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PostFileToUrlAsync(this string url, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostJsonToUrl(this string url, string json, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PostJsonToUrl(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostJsonToUrlAsync(this string url, string json, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PostJsonToUrlAsync(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.IO.Stream PostStreamToUrl(this string url, System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> PostStreamToUrlAsync(this string url, System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostStringToUrl(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostStringToUrlAsync(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostToUrl(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PostToUrl(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostToUrlAsync(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PostToUrlAsync(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostXmlToUrl(this string url, string xml, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PostXmlToUrl(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostXmlToUrlAsync(this string url, string xml, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static byte[] PutBytesToUrl(this string url, byte[] requestBody = default(byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<byte[]> PutBytesToUrlAsync(this string url, byte[] requestBody = default(byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutCsvToUrl(this string url, string csv, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PutCsvToUrl(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutCsvToUrlAsync(this string url, string csv, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Net.Http.HttpResponseMessage PutFileToUrl(this string url, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> PutFileToUrlAsync(this string url, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType, string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutJsonToUrl(this string url, string json, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PutJsonToUrl(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutJsonToUrlAsync(this string url, string json, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PutJsonToUrlAsync(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.IO.Stream PutStreamToUrl(this string url, System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> PutStreamToUrlAsync(this string url, System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutStringToUrl(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutStringToUrlAsync(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutToUrl(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PutToUrl(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutToUrlAsync(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PutToUrlAsync(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutXmlToUrl(this string url, string xml, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string PutXmlToUrl(this string url, object data, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutXmlToUrlAsync(this string url, string xml, System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Collections.Generic.IEnumerable<string> ReadLines(this System.Net.WebResponse webRes) => throw null;
        public static System.Collections.Generic.IEnumerable<string> ReadLines(this System.Net.Http.HttpResponseMessage webRes) => throw null;
        public static string ReadToEnd(this System.Net.WebResponse webRes) => throw null;
        public static string ReadToEnd(this System.Net.Http.HttpResponseMessage webRes) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.Net.WebResponse webRes) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.Net.Http.HttpResponseMessage webRes) => throw null;
        public static System.Collections.Generic.Dictionary<string, System.Func<System.Net.Http.HttpRequestMessage, string>> RequestHeadersResolver { get => throw null; set { } }
        public static System.Collections.Generic.Dictionary<string, System.Func<System.Net.Http.HttpResponseMessage, string>> ResponseHeadersResolver { get => throw null; set { } }
        public static byte[] SendBytesToUrl(this string url, string method = default(string), byte[] requestBody = default(byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static byte[] SendBytesToUrl(this System.Net.Http.HttpClient client, string url, string method = default(string), byte[] requestBody = default(byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<byte[]> SendBytesToUrlAsync(this string url, string method = default(string), byte[] requestBody = default(byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<byte[]> SendBytesToUrlAsync(this System.Net.Http.HttpClient client, string url, string method = default(string), byte[] requestBody = default(byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.IO.Stream SendStreamToUrl(this string url, string method = default(string), System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.IO.Stream SendStreamToUrl(this System.Net.Http.HttpClient client, string url, string method = default(string), System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> SendStreamToUrlAsync(this string url, string method = default(string), System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> SendStreamToUrlAsync(this System.Net.Http.HttpClient client, string url, string method = default(string), System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string SendStringToUrl(this string url, string method = default(string), string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static string SendStringToUrl(this System.Net.Http.HttpClient client, string url, string method = default(string), string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Threading.Tasks.Task<string> SendStringToUrlAsync(this string url, string method = default(string), string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> SendStringToUrlAsync(this System.Net.Http.HttpClient client, string url, string method = default(string), string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string SetHashParam(this string url, string key, string val) => throw null;
        public static string SetQueryParam(this string url, string key, string val) => throw null;
        public static System.Net.Http.HttpResponseMessage UploadFile(this System.Net.Http.HttpRequestMessage httpReq, System.IO.Stream fileStream, string fileName, string mimeType, string accept = default(string), string method = default(string), string field = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static System.Net.Http.HttpResponseMessage UploadFile(this System.Net.Http.HttpClient client, System.Net.Http.HttpRequestMessage httpReq, System.IO.Stream fileStream, string fileName, string mimeType = default(string), string accept = default(string), string method = default(string), string fieldName = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>)) => throw null;
        public static void UploadFile(this System.Net.Http.HttpRequestMessage httpReq, System.IO.Stream fileStream, string fileName) => throw null;
        public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> UploadFileAsync(this System.Net.Http.HttpRequestMessage httpReq, System.IO.Stream fileStream, string fileName, string mimeType = default(string), string accept = default(string), string method = default(string), string fieldName = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> UploadFileAsync(this System.Net.Http.HttpClient client, System.Net.Http.HttpRequestMessage httpReq, System.IO.Stream fileStream, string fileName, string mimeType = default(string), string accept = default(string), string method = default(string), string fieldName = default(string), System.Action<System.Net.Http.HttpRequestMessage> requestFilter = default(System.Action<System.Net.Http.HttpRequestMessage>), System.Action<System.Net.Http.HttpResponseMessage> responseFilter = default(System.Action<System.Net.Http.HttpResponseMessage>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task UploadFileAsync(this System.Net.Http.HttpRequestMessage webRequest, System.IO.Stream fileStream, string fileName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Text.Encoding UseEncoding { get => throw null; set { } }
        public static string UserAgent;
        public static System.Net.Http.HttpRequestMessage With(this System.Net.Http.HttpRequestMessage httpReq, System.Action<ServiceStack.HttpRequestConfig> configure) => throw null;
        public static System.Net.Http.HttpRequestMessage WithHeader(this System.Net.Http.HttpRequestMessage httpReq, string name, string value) => throw null;
    }
    public interface IDynamicNumber
    {
        object add(object lhs, object rhs);
        object bitwiseAnd(object lhs, object rhs);
        object bitwiseLeftShift(object lhs, object rhs);
        object bitwiseNot(object target);
        object bitwiseOr(object lhs, object rhs);
        object bitwiseRightShift(object lhs, object rhs);
        object bitwiseXOr(object lhs, object rhs);
        int compareTo(object lhs, object rhs);
        object ConvertFrom(object value);
        object DefaultValue { get; }
        object div(object lhs, object rhs);
        object log(object lhs, object rhs);
        object max(object lhs, object rhs);
        object min(object lhs, object rhs);
        object mod(object lhs, object rhs);
        object mul(object lhs, object rhs);
        object pow(object lhs, object rhs);
        object sub(object lhs, object rhs);
        string ToString(object value);
        bool TryParse(string str, out object result);
        System.Type Type { get; }
    }
    public interface IHasStatusCode
    {
        int StatusCode { get; }
    }
    public interface IHasStatusDescription
    {
        string StatusDescription { get; }
    }
    public class KeyValuePairs : System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, object>>
    {
        public static System.Collections.Generic.KeyValuePair<string, object> Create(string key, object value) => throw null;
        public KeyValuePairs() => throw null;
        public KeyValuePairs(int capacity) => throw null;
        public KeyValuePairs(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> collection) => throw null;
    }
    public class KeyValueStrings : System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>>
    {
        public static System.Collections.Generic.KeyValuePair<string, string> Create(string key, string value) => throw null;
        public KeyValueStrings() => throw null;
        public KeyValueStrings(int capacity) => throw null;
        public KeyValueStrings(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> collection) => throw null;
    }
    public class LicenseException : System.Exception
    {
        public LicenseException(string message) => throw null;
        public LicenseException(string message, System.Exception innerException) => throw null;
    }
    [System.Flags]
    public enum LicenseFeature : long
    {
        None = 0,
        All = 2047,
        RedisSku = 18,
        OrmLiteSku = 34,
        AwsSku = 1026,
        Free = 0,
        Premium = 1,
        Text = 2,
        Client = 4,
        Common = 8,
        Redis = 16,
        OrmLite = 32,
        ServiceStack = 64,
        Server = 128,
        Razor = 256,
        Admin = 512,
        Aws = 1024,
    }
    public class LicenseKey
    {
        public LicenseKey() => throw null;
        public System.DateTime Expiry { get => throw null; set { } }
        public string Hash { get => throw null; set { } }
        public long Meta { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string Ref { get => throw null; set { } }
        public ServiceStack.LicenseType Type { get => throw null; set { } }
    }
    [System.Flags]
    public enum LicenseMeta : long
    {
        None = 0,
        Subscription = 1,
        Cores = 2,
    }
    public enum LicenseType
    {
        Free = 0,
        FreeIndividual = 1,
        FreeOpenSource = 2,
        Indie = 3,
        Business = 4,
        Enterprise = 5,
        TextIndie = 6,
        TextBusiness = 7,
        OrmLiteIndie = 8,
        OrmLiteBusiness = 9,
        RedisIndie = 10,
        RedisBusiness = 11,
        AwsIndie = 12,
        AwsBusiness = 13,
        Trial = 14,
        Site = 15,
        TextSite = 16,
        RedisSite = 17,
        OrmLiteSite = 18,
    }
    public static class LicenseUtils
    {
        public static ServiceStack.LicenseFeature ActivatedLicenseFeatures() => throw null;
        public static void ApprovedUsage(int allowedUsage, int actualUsage, string message) => throw null;
        public static void ApprovedUsage(ServiceStack.LicenseFeature licensedFeatures, ServiceStack.LicenseFeature requestedFeature, int allowedUsage, int actualUsage, string message) => throw null;
        public static void AssertEvaluationLicense() => throw null;
        public static void AssertValidUsage(ServiceStack.LicenseFeature feature, ServiceStack.QuotaType quotaType, int count) => throw null;
        public static class ErrorMessages
        {
            public const string UnauthorizedAccessRequest = default;
        }
        public static class FreeQuotas
        {
            public const int AwsTables = 10;
            public const int OrmLiteTables = 10;
            public const int PremiumFeature = 0;
            public const int RedisRequestPerHour = 6000;
            public const int RedisTypes = 20;
            public const int ServiceStackOperations = 10;
            public const int TypeFields = 20;
        }
        public static string GetHashKeyToSign(this ServiceStack.LicenseKey key) => throw null;
        public static System.Exception GetInnerMostException(this System.Exception ex) => throw null;
        public static ServiceStack.LicenseFeature GetLicensedFeatures(this ServiceStack.LicenseKey key) => throw null;
        public static bool HasInit { get => throw null; }
        public static bool HasLicensedFeature(ServiceStack.LicenseFeature feature) => throw null;
        public static void Init() => throw null;
        public const string LicensePublicKey = default;
        public static string LicenseWarningMessage { get => throw null; }
        public static void RegisterLicense(string licenseKeyText) => throw null;
        public static void RemoveLicense() => throw null;
        public const string RuntimePublicKey = default;
        public static ServiceStack.LicenseKey ToLicenseKey(this string licenseKeyText) => throw null;
        public static ServiceStack.LicenseKey ToLicenseKeyFallback(this string licenseKeyText) => throw null;
        public static ServiceStack.LicenseKey VerifyLicenseKeyText(string licenseKeyText) => throw null;
        public static bool VerifyLicenseKeyText(this string licenseKeyText, out ServiceStack.LicenseKey key) => throw null;
        public static bool VerifyLicenseKeyTextFallback(this string licenseKeyText, out ServiceStack.LicenseKey key) => throw null;
        public static bool VerifySha1Data(this System.Security.Cryptography.RSACryptoServiceProvider RSAalg, byte[] unsignedData, byte[] encryptedData) => throw null;
        public static bool VerifySignedHash(byte[] DataToVerify, byte[] SignedData, System.Security.Cryptography.RSAParameters Key) => throw null;
    }
    public static class Licensing
    {
        public static void RegisterLicense(string licenseKeyText) => throw null;
        public static void RegisterLicenseFromFile(string filePath) => throw null;
        public static void RegisterLicenseFromFileIfExists(string filePath) => throw null;
    }
    public static partial class ListExtensions
    {
        public static System.Collections.Generic.List<System.Type> Add<T>(this System.Collections.Generic.List<System.Type> types) => throw null;
        public static void AddDistinctRange<T>(this System.Collections.Generic.ICollection<T> list, System.Collections.Generic.IEnumerable<T> items) => throw null;
        public static void AddIfNotExists<T>(this System.Collections.Generic.ICollection<T> list, T item) => throw null;
        public static T[] InArray<T>(this T value) => throw null;
        public static System.Collections.Generic.List<T> InList<T>(this T value) => throw null;
        public static bool IsNullOrEmpty<T>(this System.Collections.Generic.List<T> list) => throw null;
        public static string Join<T>(this System.Collections.Generic.IEnumerable<T> values) => throw null;
        public static string Join<T>(this System.Collections.Generic.IEnumerable<T> values, string seperator) => throw null;
        public static T[] NewArray<T>(this T[] array, T with = default(T), T without = default(T)) where T : class => throw null;
        public static int NullableCount<T>(this System.Collections.Generic.List<T> list) => throw null;
        public static System.Linq.IQueryable<TEntity> OrderBy<TEntity>(this System.Linq.IQueryable<TEntity> source, string sqlOrderByList) => throw null;
        public static System.Collections.Generic.IEnumerable<TFrom> SafeWhere<TFrom>(this System.Collections.Generic.List<TFrom> list, System.Func<TFrom, bool> predicate) => throw null;
    }
    public class LongRange : System.IEquatable<ServiceStack.LongRange>
    {
        public LongRange(long from, long? to = default(long?)) => throw null;
        protected LongRange(ServiceStack.LongRange original) => throw null;
        public void Deconstruct(out long from, out long? to) => throw null;
        protected virtual System.Type EqualityContract { get => throw null; }
        public override bool Equals(object obj) => throw null;
        public virtual bool Equals(ServiceStack.LongRange other) => throw null;
        public long From { get => throw null; }
        public override int GetHashCode() => throw null;
        public static bool operator ==(ServiceStack.LongRange left, ServiceStack.LongRange right) => throw null;
        public static bool operator !=(ServiceStack.LongRange left, ServiceStack.LongRange right) => throw null;
        protected virtual bool PrintMembers(System.Text.StringBuilder builder) => throw null;
        public long? To { get => throw null; }
        public override string ToString() => throw null;
    }
    public static partial class MapExtensions
    {
        public static string Join<K, V>(this System.Collections.Generic.Dictionary<K, V> values) => throw null;
        public static string Join<K, V>(this System.Collections.Generic.Dictionary<K, V> values, string itemSeperator, string keySeperator) => throw null;
    }
    public static class MimeTypes
    {
        public const string Binary = default;
        public const string Bson = default;
        public const string Cert = default;
        public const string Compressed = default;
        public const string Css = default;
        public const string Csv = default;
        public const string Dmg = default;
        public const string Excel = default;
        public static System.Collections.Generic.Dictionary<string, string> ExtensionMimeTypes;
        public const string FormUrlEncoded = default;
        public static string GetExtension(string mimeType) => throw null;
        public static string GetMimeType(string fileNameOrExt) => throw null;
        public static string GetRealContentType(string contentType) => throw null;
        public const string Html = default;
        public const string HtmlUtf8 = default;
        public const string ImageGif = default;
        public const string ImageJpg = default;
        public const string ImagePng = default;
        public const string ImageSvg = default;
        public static bool IsBinary(string contentType) => throw null;
        public static System.Func<string, bool?> IsBinaryFilter { get => throw null; set { } }
        public const string Jar = default;
        public const string JavaScript = default;
        public const string Json = default;
        public const string Jsonl = default;
        public const string JsonReport = default;
        public const string JsonText = default;
        public const string Jsv = default;
        public const string JsvText = default;
        public const string MarkdownText = default;
        public static bool MatchesContentType(string contentType, string matchesContentType) => throw null;
        public const string MsgPack = default;
        public const string MsWord = default;
        public const string MultiPartFormData = default;
        public const string NetSerializer = default;
        public const string Pdf = default;
        public const string Pkg = default;
        public const string PlainText = default;
        public const string ProblemJson = default;
        public const string ProtoBuf = default;
        public const string Rss = default;
        public const string ServerSentEvents = default;
        public const string Soap11 = default;
        public const string Soap12 = default;
        public const string Utf8Suffix = default;
        public const string WebAssembly = default;
        public const string Wire = default;
        public const string Xml = default;
        public const string XmlText = default;
        public const string Yaml = default;
        public const string YamlText = default;
    }
    public class NameValue : System.IEquatable<ServiceStack.NameValue>
    {
        public NameValue(string name, string value) => throw null;
        protected NameValue(ServiceStack.NameValue original) => throw null;
        public void Deconstruct(out string name, out string value) => throw null;
        protected virtual System.Type EqualityContract { get => throw null; }
        public override bool Equals(object obj) => throw null;
        public virtual bool Equals(ServiceStack.NameValue other) => throw null;
        public override int GetHashCode() => throw null;
        public string Name { get => throw null; }
        public static bool operator ==(ServiceStack.NameValue left, ServiceStack.NameValue right) => throw null;
        public static bool operator !=(ServiceStack.NameValue left, ServiceStack.NameValue right) => throw null;
        protected virtual bool PrintMembers(System.Text.StringBuilder builder) => throw null;
        public override string ToString() => throw null;
        public string Value { get => throw null; }
    }
    public class Net6PclExport : ServiceStack.NetStandardPclExport
    {
        public Net6PclExport() => throw null;
        public override ServiceStack.Text.Common.ParseStringDelegate GetJsReaderParseMethod<TSerializer>(System.Type type) => throw null;
        public override ServiceStack.Text.Common.ParseStringSpanDelegate GetJsReaderParseStringSpanMethod<TSerializer>(System.Type type) => throw null;
    }
    public class NetStandardPclExport : ServiceStack.PclExport
    {
        public const string AppSettingsKey = default;
        public static ServiceStack.PclExport Configure() => throw null;
        public NetStandardPclExport() => throw null;
        public const string EnvironmentKey = default;
        public override string GetAssemblyCodeBase(System.Reflection.Assembly assembly) => throw null;
        public override string GetAssemblyPath(System.Type source) => throw null;
        public override System.Type GetGenericCollectionType(System.Type type) => throw null;
        public override ServiceStack.Text.Common.ParseStringDelegate GetSpecializedCollectionParseMethod<TSerializer>(System.Type type) => throw null;
        public override ServiceStack.Text.Common.ParseStringSpanDelegate GetSpecializedCollectionParseStringSpanMethod<TSerializer>(System.Type type) => throw null;
        public static void InitForAot() => throw null;
        public override bool InSameAssembly(System.Type t1, System.Type t2) => throw null;
        public override string MapAbsolutePath(string relativePath, string appendPartialPathModifier) => throw null;
        public override System.DateTime ParseXsdDateTimeAsUtc(string dateTimeStr) => throw null;
        public static ServiceStack.NetStandardPclExport Provider;
        public static int RegisterElement<T, TElement>() => throw null;
        public override void RegisterForAot() => throw null;
        public override void RegisterLicenseFromConfig() => throw null;
        public static void RegisterQueryStringWriter() => throw null;
        public static void RegisterTypeForAot<T>() => throw null;
    }
    public class ObjectDictionary : System.Collections.Generic.Dictionary<string, object>
    {
        public ObjectDictionary() => throw null;
        public ObjectDictionary(int capacity) => throw null;
        public ObjectDictionary(System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public ObjectDictionary(int capacity, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public ObjectDictionary(System.Collections.Generic.IDictionary<string, object> dictionary) => throw null;
        public ObjectDictionary(System.Collections.Generic.IDictionary<string, object> dictionary, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        protected ObjectDictionary(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
    }
    public class OrmLiteDiagnosticEvent : ServiceStack.DiagnosticEvent
    {
        public System.Data.IDbCommand Command { get => throw null; set { } }
        public System.Data.IDbConnection Connection { get => throw null; set { } }
        public System.Guid? ConnectionId { get => throw null; set { } }
        public OrmLiteDiagnosticEvent() => throw null;
        public System.Data.IsolationLevel? IsolationLevel { get => throw null; set { } }
        public override string Source { get => throw null; }
        public string TransactionName { get => throw null; set { } }
    }
    public static class PathUtils
    {
        public static void AppendPaths(System.Text.StringBuilder sb, string[] paths) => throw null;
        public static string AssertDir(this string dirPath) => throw null;
        public static string AssertDir(this System.IO.DirectoryInfo dirInfo) => throw null;
        public static string AssertDir(this System.IO.FileInfo fileInfo) => throw null;
        public static string CombinePaths(params string[] paths) => throw null;
        public static string CombineWith(this string path, string withPath) => throw null;
        public static string CombineWith(this string path, params string[] thesePaths) => throw null;
        public static string CombineWith(this string path, params object[] thesePaths) => throw null;
        public static string MapAbsolutePath(this string relativePath, string appendPartialPathModifier) => throw null;
        public static string MapAbsolutePath(this string relativePath) => throw null;
        public static string MapHostAbsolutePath(this string relativePath) => throw null;
        public static string MapProjectPath(this string relativePath) => throw null;
        public static string MapProjectPlatformPath(this string relativePath) => throw null;
        public static string ResolvePaths(this string path) => throw null;
        public static string[] ToStrings(object[] thesePaths) => throw null;
    }
    public abstract class PclExport
    {
        public virtual void AddCompression(System.Net.WebRequest webRequest) => throw null;
        public virtual void AddHeader(System.Net.WebRequest webReq, string name, string value) => throw null;
        public char AltDirSep;
        public virtual void BeginThreadAffinity() => throw null;
        public virtual void CloseStream(System.IO.Stream stream) => throw null;
        public virtual void Config(System.Net.HttpWebRequest req, bool? allowAutoRedirect = default(bool?), System.TimeSpan? timeout = default(System.TimeSpan?), System.TimeSpan? readWriteTimeout = default(System.TimeSpan?), string userAgent = default(string), bool? preAuthenticate = default(bool?)) => throw null;
        public static void Configure(ServiceStack.PclExport instance) => throw null;
        public static bool ConfigureProvider(string typeName) => throw null;
        public virtual void CreateDirectory(string dirPath) => throw null;
        protected PclExport() => throw null;
        public virtual bool DirectoryExists(string dirPath) => throw null;
        public char DirSep;
        public static readonly char[] DirSeps;
        public System.Threading.Tasks.Task EmptyTask;
        public virtual void EndThreadAffinity() => throw null;
        public virtual bool FileExists(string filePath) => throw null;
        public virtual System.Type FindType(string typeName, string assemblyName) => throw null;
        public virtual System.Reflection.Assembly[] GetAllAssemblies() => throw null;
        public virtual byte[] GetAsciiBytes(string str) => throw null;
        public virtual string GetAsciiString(byte[] bytes) => throw null;
        public virtual string GetAsciiString(byte[] bytes, int index, int count) => throw null;
        public virtual string GetAssemblyCodeBase(System.Reflection.Assembly assembly) => throw null;
        public virtual string GetAssemblyPath(System.Type source) => throw null;
        public virtual ServiceStack.Text.Common.ParseStringDelegate GetDictionaryParseMethod<TSerializer>(System.Type type) where TSerializer : ServiceStack.Text.Common.ITypeSerializer => throw null;
        public virtual ServiceStack.Text.Common.ParseStringSpanDelegate GetDictionaryParseStringSpanMethod<TSerializer>(System.Type type) where TSerializer : ServiceStack.Text.Common.ITypeSerializer => throw null;
        public virtual string[] GetDirectoryNames(string dirPath, string searchPattern = default(string)) => throw null;
        public virtual string GetEnvironmentVariable(string name) => throw null;
        public virtual string[] GetFileNames(string dirPath, string searchPattern = default(string)) => throw null;
        public virtual System.Type GetGenericCollectionType(System.Type type) => throw null;
        public virtual ServiceStack.Text.Common.ParseStringDelegate GetJsReaderParseMethod<TSerializer>(System.Type type) where TSerializer : ServiceStack.Text.Common.ITypeSerializer => throw null;
        public virtual ServiceStack.Text.Common.ParseStringSpanDelegate GetJsReaderParseStringSpanMethod<TSerializer>(System.Type type) where TSerializer : ServiceStack.Text.Common.ITypeSerializer => throw null;
        public virtual System.IO.Stream GetRequestStream(System.Net.WebRequest webRequest) => throw null;
        public virtual System.Net.WebResponse GetResponse(System.Net.WebRequest webRequest) => throw null;
        public virtual System.Threading.Tasks.Task<System.Net.WebResponse> GetResponseAsync(System.Net.WebRequest webRequest) => throw null;
        public virtual ServiceStack.Text.Common.ParseStringDelegate GetSpecializedCollectionParseMethod<TSerializer>(System.Type type) where TSerializer : ServiceStack.Text.Common.ITypeSerializer => throw null;
        public virtual ServiceStack.Text.Common.ParseStringSpanDelegate GetSpecializedCollectionParseStringSpanMethod<TSerializer>(System.Type type) where TSerializer : ServiceStack.Text.Common.ITypeSerializer => throw null;
        public virtual string GetStackTrace() => throw null;
        public virtual System.Text.Encoding GetUTF8Encoding(bool emitBom = default(bool)) => throw null;
        public virtual System.Runtime.Serialization.DataContractAttribute GetWeakDataContract(System.Type type) => throw null;
        public virtual System.Runtime.Serialization.DataMemberAttribute GetWeakDataMember(System.Reflection.PropertyInfo pi) => throw null;
        public virtual System.Runtime.Serialization.DataMemberAttribute GetWeakDataMember(System.Reflection.FieldInfo pi) => throw null;
        public virtual void InitHttpWebRequest(System.Net.HttpWebRequest httpReq, long? contentLength = default(long?), bool allowAutoRedirect = default(bool), bool keepAlive = default(bool)) => throw null;
        public virtual bool InSameAssembly(System.Type t1, System.Type t2) => throw null;
        public static ServiceStack.PclExport Instance;
        public System.StringComparer InvariantComparer;
        public System.StringComparer InvariantComparerIgnoreCase;
        public System.StringComparison InvariantComparison;
        public System.StringComparison InvariantComparisonIgnoreCase;
        public virtual bool IsAnonymousType(System.Type type) => throw null;
        public virtual bool IsDebugBuild(System.Reflection.Assembly assembly) => throw null;
        public virtual System.Reflection.Assembly LoadAssembly(string assemblyPath) => throw null;
        public virtual string MapAbsolutePath(string relativePath, string appendPartialPathModifier) => throw null;
        public virtual System.DateTime ParseXsdDateTime(string dateTimeStr) => throw null;
        public virtual System.DateTime ParseXsdDateTimeAsUtc(string dateTimeStr) => throw null;
        public string PlatformName;
        public static class Platforms
        {
            public const string Net6 = default;
            public const string NetFX = default;
            public const string NetStandard = default;
        }
        public virtual string ReadAllText(string filePath) => throw null;
        public static ServiceStack.Text.ReflectionOptimizer Reflection { get => throw null; }
        public System.Text.RegularExpressions.RegexOptions RegexOptions;
        public virtual void RegisterForAot() => throw null;
        public virtual void RegisterLicenseFromConfig() => throw null;
        public virtual void ResetStream(System.IO.Stream stream) => throw null;
        public virtual void SetAllowAutoRedirect(System.Net.HttpWebRequest httpReq, bool value) => throw null;
        public virtual void SetContentLength(System.Net.HttpWebRequest httpReq, long value) => throw null;
        public virtual void SetKeepAlive(System.Net.HttpWebRequest httpReq, bool value) => throw null;
        public virtual void SetUserAgent(System.Net.HttpWebRequest httpReq, string value) => throw null;
        public virtual string ToInvariantUpper(char value) => throw null;
        public virtual string ToLocalXsdDateTimeString(System.DateTime dateTime) => throw null;
        public virtual System.DateTime ToStableUniversalTime(System.DateTime dateTime) => throw null;
        public virtual string ToXsdDateTimeString(System.DateTime dateTime) => throw null;
        public virtual ServiceStack.LicenseKey VerifyLicenseKeyText(string licenseKeyText) => throw null;
        public virtual ServiceStack.LicenseKey VerifyLicenseKeyTextFallback(string licenseKeyText) => throw null;
        public virtual System.Threading.Tasks.Task WriteAndFlushAsync(System.IO.Stream stream, byte[] bytes) => throw null;
        public virtual void WriteLine(string line) => throw null;
        public virtual void WriteLine(string format, params object[] args) => throw null;
    }
    public static partial class PlatformExtensions
    {
        public static System.Type AddAttributes(this System.Type type, params System.Attribute[] attrs) => throw null;
        public static System.Reflection.PropertyInfo AddAttributes(this System.Reflection.PropertyInfo propertyInfo, params System.Attribute[] attrs) => throw null;
        public static object[] AllAttributes(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static object[] AllAttributes(this System.Reflection.PropertyInfo propertyInfo, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Reflection.ParameterInfo paramInfo) => throw null;
        public static object[] AllAttributes(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static object[] AllAttributes(this System.Reflection.MemberInfo memberInfo) => throw null;
        public static object[] AllAttributes(this System.Reflection.ParameterInfo paramInfo, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Reflection.MemberInfo memberInfo, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Reflection.FieldInfo fieldInfo, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Type type) => throw null;
        public static object[] AllAttributes(this System.Type type, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Reflection.Assembly assembly) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Reflection.ParameterInfo pi) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Reflection.MemberInfo mi) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Reflection.FieldInfo fi) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Reflection.PropertyInfo pi) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Type type) => throw null;
        public static System.Collections.Generic.IEnumerable<object> AllAttributesLazy(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static System.Collections.Generic.IEnumerable<object> AllAttributesLazy(this System.Reflection.PropertyInfo propertyInfo, System.Type attrType) => throw null;
        public static System.Collections.Generic.IEnumerable<object> AllAttributesLazy(this System.Type type) => throw null;
        public static System.Collections.Generic.IEnumerable<TAttr> AllAttributesLazy<TAttr>(this System.Reflection.PropertyInfo pi) => throw null;
        public static System.Collections.Generic.IEnumerable<TAttr> AllAttributesLazy<TAttr>(this System.Type type) => throw null;
        public static System.Reflection.PropertyInfo[] AllProperties(this System.Type type) => throw null;
        public static bool AnyValues(this System.Collections.IDictionary map, System.Func<string, object, bool> match) => throw null;
        public static bool AssignableFrom(this System.Type type, System.Type fromType) => throw null;
        public static System.Type BaseType(this System.Type type) => throw null;
        public static void ClearRuntimeAttributes() => throw null;
        public static bool ContainsGenericParameters(this System.Type type) => throw null;
        public static T ConvertFromObject<T>(object value) => throw null;
        public static object ConvertToObject<T>(T value) => throw null;
        public static System.Delegate CreateDelegate(this System.Reflection.MethodInfo methodInfo, System.Type delegateType) => throw null;
        public static System.Delegate CreateDelegate(this System.Reflection.MethodInfo methodInfo, System.Type delegateType, object target) => throw null;
        public static System.Reflection.ConstructorInfo[] DeclaredConstructors(this System.Type type) => throw null;
        public static System.Type ElementType(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo[] Fields(this System.Type type) => throw null;
        public static TAttr FirstAttribute<TAttr>(this System.Type type) where TAttr : class => throw null;
        public static TAttribute FirstAttribute<TAttribute>(this System.Reflection.MemberInfo memberInfo) => throw null;
        public static TAttribute FirstAttribute<TAttribute>(this System.Reflection.ParameterInfo paramInfo) => throw null;
        public static TAttribute FirstAttribute<TAttribute>(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static System.Type FirstGenericTypeDefinition(this System.Type type) => throw null;
        public static object FromObjectDictionary(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> values, System.Type type) => throw null;
        public static T FromObjectDictionary<T>(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> values) => throw null;
        public static System.Type[] GenericTypeArguments(this System.Type type) => throw null;
        public static System.Type GenericTypeDefinition(this System.Type type) => throw null;
        public static System.Collections.Generic.IEnumerable<System.Reflection.ConstructorInfo> GetAllConstructors(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo[] GetAllFields(this System.Type type) => throw null;
        public static System.Reflection.MemberInfo[] GetAllPublicMembers(this System.Type type) => throw null;
        public static System.Reflection.Assembly GetAssembly(this System.Type type) => throw null;
        public static System.Collections.Generic.List<TAttr> GetAttributes<TAttr>(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static System.Collections.Generic.List<System.Attribute> GetAttributes(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static System.Collections.Generic.List<System.Attribute> GetAttributes(this System.Reflection.PropertyInfo propertyInfo, System.Type attrType) => throw null;
        public static System.Type GetCachedGenericType(this System.Type type, params System.Type[] argTypes) => throw null;
        public static System.Type GetCollectionType(this System.Type type) => throw null;
        public static string GetDeclaringTypeName(this System.Type type) => throw null;
        public static string GetDeclaringTypeName(this System.Reflection.MemberInfo mi) => throw null;
        public static System.Reflection.ConstructorInfo GetEmptyConstructor(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo GetFieldInfo(this System.Type type, string fieldName) => throw null;
        public static System.Reflection.MethodInfo GetInstanceMethod(this System.Type type, string methodName) => throw null;
        public static System.Reflection.MethodInfo[] GetInstanceMethods(this System.Type type) => throw null;
        public static System.Type GetKeyValuePairsTypeDef(this System.Type dictType) => throw null;
        public static bool GetKeyValuePairsTypes(this System.Type dictType, out System.Type keyType, out System.Type valueType) => throw null;
        public static bool GetKeyValuePairsTypes(this System.Type dictType, out System.Type keyType, out System.Type valueType, out System.Type kvpType) => throw null;
        public static System.Type GetKeyValuePairTypeDef(this System.Type genericEnumType) => throw null;
        public static bool GetKeyValuePairTypes(this System.Type kvpType, out System.Type keyType, out System.Type valueType) => throw null;
        public static System.Reflection.MethodInfo GetMethodInfo(this System.Type type, string methodName, System.Type[] types = default(System.Type[])) => throw null;
        public static System.Reflection.MethodInfo GetMethodInfo(this System.Reflection.PropertyInfo pi, bool nonPublic = default(bool)) => throw null;
        public static System.Reflection.MethodInfo[] GetMethodInfos(this System.Type type) => throw null;
        public static System.Reflection.PropertyInfo GetPropertyInfo(this System.Type type, string propertyName) => throw null;
        public static System.Reflection.PropertyInfo[] GetPropertyInfos(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo[] GetPublicFields(this System.Type type) => throw null;
        public static System.Reflection.MemberInfo[] GetPublicMembers(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo GetPublicStaticField(this System.Type type, string fieldName) => throw null;
        public static System.Reflection.MethodInfo GetStaticMethod(this System.Type type, string methodName) => throw null;
        public static System.Reflection.MethodInfo GetStaticMethod(this System.Type type, string methodName, System.Type[] types) => throw null;
        public static System.Type[] GetTypeGenericArguments(this System.Type type) => throw null;
        public static System.Type[] GetTypeInterfaces(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo[] GetWritableFields(this System.Type type) => throw null;
        public static bool HasAttribute<T>(this System.Type type) => throw null;
        public static bool HasAttribute<T>(this System.Reflection.PropertyInfo pi) => throw null;
        public static bool HasAttribute<T>(this System.Reflection.FieldInfo fi) => throw null;
        public static bool HasAttribute<T>(this System.Reflection.MethodInfo mi) => throw null;
        public static bool HasAttributeCached<T>(this System.Reflection.MemberInfo memberInfo) => throw null;
        public static bool HasAttributeNamed(this System.Type type, string name) => throw null;
        public static bool HasAttributeNamed(this System.Reflection.PropertyInfo pi, string name) => throw null;
        public static bool HasAttributeNamed(this System.Reflection.FieldInfo fi, string name) => throw null;
        public static bool HasAttributeNamed(this System.Reflection.MemberInfo mi, string name) => throw null;
        public static bool HasAttributeOf<T>(this System.Type type) => throw null;
        public static bool HasAttributeOf<T>(this System.Reflection.PropertyInfo pi) => throw null;
        public static bool HasAttributeOf<T>(this System.Reflection.FieldInfo fi) => throw null;
        public static bool HasAttributeOf<T>(this System.Reflection.MethodInfo mi) => throw null;
        public static bool HasAttributeOfCached<T>(this System.Reflection.MemberInfo memberInfo) => throw null;
        public static bool HasNonDefaultValues(this System.Collections.IDictionary map, string[] ignoreKeys = default(string[])) => throw null;
        public static bool InstanceOfType(this System.Type type, object instance) => throw null;
        public static System.Type[] Interfaces(this System.Type type) => throw null;
        public static object InvokeMethod(this System.Delegate fn, object instance, object[] parameters = default(object[])) => throw null;
        public static bool IsAbstract(this System.Type type) => throw null;
        public static bool IsArray(this System.Type type) => throw null;
        public static bool IsAssignableFromType(this System.Type type, System.Type fromType) => throw null;
        public static bool IsClass(this System.Type type) => throw null;
        public static bool IsDefaultValue(object value) => throw null;
        public static bool IsDto(this System.Type type) => throw null;
        public static bool IsDynamic(this System.Reflection.Assembly assembly) => throw null;
        public static bool IsEnum(this System.Type type) => throw null;
        public static bool IsEnumFlags(this System.Type type) => throw null;
        public static bool IsGeneric(this System.Type type) => throw null;
        public static bool IsGenericType(this System.Type type) => throw null;
        public static bool IsGenericTypeDefinition(this System.Type type) => throw null;
        public static bool IsInterface(this System.Type type) => throw null;
        public static bool? IsNotNullable(this System.Reflection.PropertyInfo property) => throw null;
        public static bool? IsNotNullable(System.Type memberType, System.Reflection.MemberInfo declaringType, System.Collections.Generic.IEnumerable<System.Reflection.CustomAttributeData> customAttributes) => throw null;
        public static bool IsStandardClass(this System.Type type) => throw null;
        public static bool IsUnderlyingEnum(this System.Type type) => throw null;
        public static bool IsValueType(this System.Type type) => throw null;
        public static System.Delegate MakeDelegate(this System.Reflection.MethodInfo mi, System.Type delegateType, bool throwOnBindFailure = default(bool)) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> MergeIntoObjectDictionary(this object obj, params object[] sources) => throw null;
        public static System.Reflection.MethodInfo Method(this System.Delegate fn) => throw null;
        public static void PopulateInstance(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> values, object instance) => throw null;
        public static void PopulateInstance(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> values, object instance) => throw null;
        public static System.Reflection.PropertyInfo[] Properties(this System.Type type) => throw null;
        public static System.Reflection.MethodInfo PropertyGetMethod(this System.Reflection.PropertyInfo pi, bool nonPublic = default(bool)) => throw null;
        public static System.Type ReflectedType(this System.Reflection.PropertyInfo pi) => throw null;
        public static System.Type ReflectedType(this System.Reflection.FieldInfo fi) => throw null;
        public static System.Reflection.PropertyInfo ReplaceAttribute(this System.Reflection.PropertyInfo propertyInfo, System.Attribute attr) => throw null;
        public static System.Reflection.MethodInfo SetMethod(this System.Reflection.PropertyInfo pi, bool nonPublic = default(bool)) => throw null;
        public static System.Collections.IEnumerable ShallowClone(this System.Collections.IEnumerable xs) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> ToObjectDictionary(this object obj) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> ToObjectDictionary(this object obj, System.Func<string, object, object> mapper) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> ToSafePartialObjectDictionary<T>(this T instance) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> ToStringDictionary(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> from) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> ToStringDictionary(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> from, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> WithoutDefaultValues(this System.Collections.IDictionary map, string[] ignoreKeys = default(string[])) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> WithValues(this System.Collections.IDictionary map, System.Func<string, object, bool> match) => throw null;
    }
    public delegate void PopulateMemberDelegate(object target, object source);
    [System.Flags]
    public enum ProfileSource
    {
        None = 0,
        ServiceStack = 1,
        Client = 2,
        Redis = 4,
        OrmLite = 8,
        All = 15,
    }
    public class PropertyAccessor
    {
        public PropertyAccessor(System.Reflection.PropertyInfo propertyInfo, ServiceStack.GetMemberDelegate publicGetter, ServiceStack.SetMemberDelegate publicSetter) => throw null;
        public System.Reflection.PropertyInfo PropertyInfo { get => throw null; }
        public ServiceStack.GetMemberDelegate PublicGetter { get => throw null; }
        public ServiceStack.SetMemberDelegate PublicSetter { get => throw null; }
    }
    public static class PropertyInvoker
    {
        public static ServiceStack.GetMemberDelegate CreateGetter(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static ServiceStack.GetMemberDelegate<T> CreateGetter<T>(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static ServiceStack.SetMemberDelegate CreateSetter(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static ServiceStack.SetMemberDelegate<T> CreateSetter<T>(this System.Reflection.PropertyInfo propertyInfo) => throw null;
    }
    public static class QueryStringSerializer
    {
        public static ServiceStack.WriteComplexTypeDelegate ComplexTypeStrategy { get => throw null; set { } }
        public static void InitAot<T>() => throw null;
        public static string SerializeToString<T>(T value) => throw null;
        public static void WriteLateBoundObject(System.IO.TextWriter writer, object value) => throw null;
    }
    public static class QueryStringStrategy
    {
        public static bool FormUrlEncoded(System.IO.TextWriter writer, string propertyName, object obj) => throw null;
    }
    public static class QueryStringWriter<T>
    {
        public static ServiceStack.Text.Common.WriteObjectDelegate WriteFn() => throw null;
        public static void WriteIDictionary(System.IO.TextWriter writer, object oMap) => throw null;
        public static void WriteObject(System.IO.TextWriter writer, object value) => throw null;
    }
    public enum QuotaType
    {
        Operations = 0,
        Types = 1,
        Fields = 2,
        RequestsPerHour = 3,
        Tables = 4,
        PremiumFeature = 5,
    }
    public class RedisDiagnosticEvent : ServiceStack.DiagnosticEvent
    {
        public object Client { get => throw null; set { } }
        public byte[][] Command { get => throw null; set { } }
        public RedisDiagnosticEvent() => throw null;
        public string Host { get => throw null; set { } }
        public int Port { get => throw null; set { } }
        public System.Net.Sockets.Socket Socket { get => throw null; set { } }
        public override string Source { get => throw null; }
    }
    public static partial class ReflectionExtensions
    {
        public static bool AllHaveInterfacesOfType(this System.Type assignableFromType, params System.Type[] types) => throw null;
        public static bool AreAllStringOrValueTypes(params System.Type[] types) => throw null;
        public static object CreateInstance<T>() => throw null;
        public static object CreateInstance(this System.Type type) => throw null;
        public static T CreateInstance<T>(this System.Type type) => throw null;
        public static object CreateInstance(string typeName) => throw null;
        public const string DataMember = default;
        public static System.Type FirstGenericArg(this System.Type type) => throw null;
        public static System.Type FirstGenericType(this System.Type type) => throw null;
        public static System.Reflection.PropertyInfo[] GetAllProperties(this System.Type type) => throw null;
        public static System.Reflection.PropertyInfo[] GetAllSerializableProperties(this System.Type type) => throw null;
        public static ServiceStack.EmptyCtorDelegate GetConstructorMethod(System.Type type) => throw null;
        public static ServiceStack.EmptyCtorDelegate GetConstructorMethod(string typeName) => throw null;
        public static ServiceStack.EmptyCtorDelegate GetConstructorMethodToCache(System.Type type) => throw null;
        public static System.Runtime.Serialization.DataContractAttribute GetDataContract(this System.Type type) => throw null;
        public static System.Runtime.Serialization.DataMemberAttribute GetDataMember(this System.Reflection.PropertyInfo pi) => throw null;
        public static System.Runtime.Serialization.DataMemberAttribute GetDataMember(this System.Reflection.FieldInfo pi) => throw null;
        public static string GetDataMemberName(this System.Reflection.PropertyInfo pi) => throw null;
        public static string GetDataMemberName(this System.Reflection.FieldInfo fi) => throw null;
        public static ServiceStack.Text.Support.TypePair GetGenericArgumentsIfBothHaveConvertibleGenericDefinitionTypeAndArguments(this System.Type assignableFromType, System.Type typeA, System.Type typeB) => throw null;
        public static System.Type[] GetGenericArgumentsIfBothHaveSameGenericDefinitionTypeAndArguments(this System.Type assignableFromType, System.Type typeA, System.Type typeB) => throw null;
        public static System.Reflection.Module GetModule(this System.Type type) => throw null;
        public static System.Func<object, string, object, object> GetOnDeserializing<T>() => throw null;
        public static System.Reflection.PropertyInfo[] GetPublicProperties(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo[] GetSerializableFields(this System.Type type) => throw null;
        public static System.Reflection.PropertyInfo[] GetSerializableProperties(this System.Type type) => throw null;
        public static System.TypeCode GetTypeCode(this System.Type type) => throw null;
        public static System.Type GetTypeWithGenericInterfaceOf(this System.Type type, System.Type genericInterfaceType) => throw null;
        public static System.Type GetTypeWithGenericTypeDefinitionOf(this System.Type type, System.Type genericTypeDefinition) => throw null;
        public static System.Type GetTypeWithGenericTypeDefinitionOfAny(this System.Type type, params System.Type[] genericTypeDefinitions) => throw null;
        public static System.Type GetTypeWithInterfaceOf(this System.Type type, System.Type interfaceType) => throw null;
        public static System.TypeCode GetUnderlyingTypeCode(this System.Type type) => throw null;
        public static bool HasAnyInterface(this System.Type type, System.Type[] interfaceTypes) => throw null;
        public static bool HasAnyTypeDefinitionsOf(this System.Type genericType, params System.Type[] theseGenericTypes) => throw null;
        public static bool HasGenericType(this System.Type type) => throw null;
        public static bool HasInterface(this System.Type type, System.Type interfaceType) => throw null;
        public static bool IsInstanceOf(this System.Type type, System.Type thisOrBaseType) => throw null;
        public static bool IsIntegerType(this System.Type type) => throw null;
        public static bool IsNullableType(this System.Type type) => throw null;
        public static bool IsNumericType(this System.Type type) => throw null;
        public static bool IsOrHasGenericInterfaceTypeOf(this System.Type type, System.Type genericTypeDefinition) => throw null;
        public static bool IsOrHasGenericTypeOf(this System.Type type, System.Type genericTypeDefinition) => throw null;
        public static bool IsRealNumberType(this System.Type type) => throw null;
        public static T New<T>(this System.Type type) => throw null;
        public static object New(this System.Type type) => throw null;
        public static System.Reflection.PropertyInfo[] OnlySerializableProperties(this System.Reflection.PropertyInfo[] properties, System.Type type = default(System.Type)) => throw null;
    }
    public delegate void SetMemberDelegate(object instance, object value);
    public delegate void SetMemberDelegate<T>(T instance, object value);
    public delegate void SetMemberRefDelegate(ref object instance, object propertyValue);
    public delegate void SetMemberRefDelegate<T>(ref T instance, object value);
    public static partial class StreamExtensions
    {
        public static int AsyncBufferSize;
        public static string CollapseWhitespace(this string str) => throw null;
        public static byte[] Combine(this byte[] bytes, params byte[][] withBytes) => throw null;
        public static long CopyTo(this System.IO.Stream input, System.IO.Stream output) => throw null;
        public static long CopyTo(this System.IO.Stream input, System.IO.Stream output, int bufferSize) => throw null;
        public static long CopyTo(this System.IO.Stream input, System.IO.Stream output, byte[] buffer) => throw null;
        public static System.Threading.Tasks.Task<long> CopyToAsync(this System.IO.Stream input, System.IO.Stream output, byte[] buffer, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task CopyToAsync(this System.IO.Stream input, System.IO.Stream output, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.IO.MemoryStream CopyToNewMemoryStream(this System.IO.Stream stream) => throw null;
        public static System.Threading.Tasks.Task<System.IO.MemoryStream> CopyToNewMemoryStreamAsync(this System.IO.Stream stream) => throw null;
        public const int DefaultBufferSize = 8192;
        public static byte[] GetBufferAsBytes(this System.IO.MemoryStream ms) => throw null;
        public static System.ReadOnlyMemory<byte> GetBufferAsMemory(this System.IO.MemoryStream ms) => throw null;
        public static System.ReadOnlySpan<byte> GetBufferAsSpan(this System.IO.MemoryStream ms) => throw null;
        public static System.IO.MemoryStream InMemoryStream(this byte[] bytes) => throw null;
        public static byte[] ReadExactly(this System.IO.Stream input, int bytesToRead) => throw null;
        public static byte[] ReadExactly(this System.IO.Stream input, byte[] buffer) => throw null;
        public static byte[] ReadExactly(this System.IO.Stream input, byte[] buffer, int bytesToRead) => throw null;
        public static byte[] ReadExactly(this System.IO.Stream input, byte[] buffer, int startIndex, int bytesToRead) => throw null;
        public static byte[] ReadFully(this System.IO.Stream input) => throw null;
        public static byte[] ReadFully(this System.IO.Stream input, int bufferSize) => throw null;
        public static byte[] ReadFully(this System.IO.Stream input, byte[] buffer) => throw null;
        public static System.ReadOnlyMemory<byte> ReadFullyAsMemory(this System.IO.Stream input) => throw null;
        public static System.ReadOnlyMemory<byte> ReadFullyAsMemory(this System.IO.Stream input, int bufferSize) => throw null;
        public static System.ReadOnlyMemory<byte> ReadFullyAsMemory(this System.IO.Stream input, byte[] buffer) => throw null;
        public static System.Threading.Tasks.Task<System.ReadOnlyMemory<byte>> ReadFullyAsMemoryAsync(this System.IO.Stream input, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.ReadOnlyMemory<byte>> ReadFullyAsMemoryAsync(this System.IO.Stream input, int bufferSize, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.ReadOnlyMemory<byte>> ReadFullyAsMemoryAsync(this System.IO.Stream input, byte[] buffer, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<byte[]> ReadFullyAsync(this System.IO.Stream input, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<byte[]> ReadFullyAsync(this System.IO.Stream input, int bufferSize, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<byte[]> ReadFullyAsync(this System.IO.Stream input, byte[] buffer, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Collections.Generic.IEnumerable<string> ReadLines(this System.IO.Stream stream) => throw null;
        public static System.Collections.Generic.IAsyncEnumerable<string> ReadLinesAsync(this System.IO.Stream stream) => throw null;
        public static string ReadToEnd(this System.IO.MemoryStream ms) => throw null;
        public static string ReadToEnd(this System.IO.MemoryStream ms, System.Text.Encoding encoding) => throw null;
        public static string ReadToEnd(this System.IO.Stream stream) => throw null;
        public static string ReadToEnd(this System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.IO.MemoryStream ms) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.IO.MemoryStream ms, System.Text.Encoding encoding) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.IO.Stream stream) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
        public static byte[] ToMd5Bytes(this System.IO.Stream stream) => throw null;
        public static string ToMd5Hash(this System.IO.Stream stream) => throw null;
        public static string ToMd5Hash(this byte[] bytes) => throw null;
        public static System.Threading.Tasks.Task WriteAsync(this System.IO.Stream stream, System.ReadOnlyMemory<byte> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task WriteAsync(this System.IO.Stream stream, byte[] bytes, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task WriteAsync(this System.IO.Stream stream, string text, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static void WritePartialTo(this System.IO.Stream fromStream, System.IO.Stream toStream, long start, long end) => throw null;
        public static System.Threading.Tasks.Task WritePartialToAsync(this System.IO.Stream fromStream, System.IO.Stream toStream, long start, long end, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static long WriteTo(this System.IO.Stream inStream, System.IO.Stream outStream) => throw null;
        public static System.Threading.Tasks.Task WriteToAsync(this System.IO.MemoryStream stream, System.IO.Stream output, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task WriteToAsync(this System.IO.MemoryStream stream, System.IO.Stream output, System.Text.Encoding encoding, System.Threading.CancellationToken token) => throw null;
        public static System.Threading.Tasks.Task WriteToAsync(this System.IO.Stream stream, System.IO.Stream output, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task WriteToAsync(this System.IO.Stream stream, System.IO.Stream output, System.Text.Encoding encoding, System.Threading.CancellationToken token) => throw null;
    }
    public class StringDictionary : System.Collections.Generic.Dictionary<string, string>
    {
        public StringDictionary() => throw null;
        public StringDictionary(int capacity) => throw null;
        public StringDictionary(System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public StringDictionary(int capacity, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public StringDictionary(System.Collections.Generic.IDictionary<string, string> dictionary) => throw null;
        public StringDictionary(System.Collections.Generic.IDictionary<string, string> dictionary, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        protected StringDictionary(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
    }
    public static partial class StringExtensions
    {
        public static string AppendPath(this string uri, params string[] uriComponents) => throw null;
        public static string AppendUrlPaths(this string uri, params string[] uriComponents) => throw null;
        public static string AppendUrlPathsRaw(this string uri, params string[] uriComponents) => throw null;
        public static string BaseConvert(this string source, int from, int to) => throw null;
        public static int CompareIgnoreCase(this string strA, string strB) => throw null;
        public static bool ContainsAny(this string text, params string[] testMatches) => throw null;
        public static bool ContainsAny(this string text, string[] testMatches, System.StringComparison comparisonType) => throw null;
        public static int CountOccurrencesOf(this string text, char needle) => throw null;
        public static int CountOccurrencesOf(this string text, string needle) => throw null;
        public static void CreateDirectory(this string dirPath) => throw null;
        public static string DecodeJsv(this string value) => throw null;
        public static bool DirectoryExists(this string dirPath) => throw null;
        public static string EncodeJson(this string value) => throw null;
        public static string EncodeJsv(this string value) => throw null;
        public static string EncodeXml(this string value) => throw null;
        public static bool EndsWithIgnoreCase(this string text, string endsWith) => throw null;
        public static bool EndsWithInvariant(this string str, string endsWith) => throw null;
        public static bool EqualsIgnoreCase(this string value, string other) => throw null;
        public static string ExtractContents(this string fromText, string startAfter, string endAt) => throw null;
        public static string ExtractContents(this string fromText, string uniqueMarker, string startAfter, string endAt) => throw null;
        public static bool FileExists(this string filePath) => throw null;
        public static string Fmt(this string text, params object[] args) => throw null;
        public static string Fmt(this string text, System.IFormatProvider provider, params object[] args) => throw null;
        public static string Fmt(this string text, object arg1) => throw null;
        public static string Fmt(this string text, object arg1, object arg2) => throw null;
        public static string Fmt(this string text, object arg1, object arg2, object arg3) => throw null;
        public static string FormatWith(this string text, params object[] args) => throw null;
        public static string FromAsciiBytes(this byte[] bytes) => throw null;
        public static byte[] FromBase64UrlSafe(this string input) => throw null;
        public static T FromCsv<T>(this string csv) => throw null;
        public static T FromJson<T>(this string json) => throw null;
        public static T FromJsonSpan<T>(this System.ReadOnlySpan<char> json) => throw null;
        public static T FromJsv<T>(this string jsv) => throw null;
        public static T FromJsvSpan<T>(this System.ReadOnlySpan<char> jsv) => throw null;
        public static string FromUtf8Bytes(this byte[] bytes) => throw null;
        public static T FromXml<T>(this string json) => throw null;
        public static string GenerateSlug(this string phrase, int maxLength = default(int)) => throw null;
        public static string GetExtension(this string filePath) => throw null;
        public static bool Glob(this string value, string pattern) => throw null;
        public static bool GlobPath(this string filePath, string pattern) => throw null;
        public static string HexEscape(this string text, params char[] anyCharOf) => throw null;
        public static string HexUnescape(this string text, params char[] anyCharOf) => throw null;
        public static int IndexOfAny(this string text, params string[] needles) => throw null;
        public static int IndexOfAny(this string text, int startIndex, params string[] needles) => throw null;
        public static bool IsAnonymousType(this System.Type type) => throw null;
        public static bool IsEmpty(this string value) => throw null;
        public static bool IsInt(this string text) => throw null;
        public static bool IsNullOrEmpty(this string value) => throw null;
        public static bool IsSystemType(this System.Type type) => throw null;
        public static bool IsTuple(this System.Type type) => throw null;
        public static bool IsUserEnum(this System.Type type) => throw null;
        public static bool IsUserType(this System.Type type) => throw null;
        public static bool IsValidVarName(this string name) => throw null;
        public static bool IsValidVarRef(this string name) => throw null;
        public static string Join(this System.Collections.Generic.List<string> items) => throw null;
        public static string Join(this System.Collections.Generic.List<string> items, string delimiter) => throw null;
        public static string LastLeftPart(this string strVal, char needle) => throw null;
        public static string LastLeftPart(this string strVal, string needle) => throw null;
        public static string LastRightPart(this string strVal, char needle) => throw null;
        public static string LastRightPart(this string strVal, string needle) => throw null;
        public static string LeftPart(this string strVal, char needle) => throw null;
        public static string LeftPart(this string strVal, string needle) => throw null;
        public static bool Matches(this string value, string pattern) => throw null;
        public static string NormalizeNewLines(this string text) => throw null;
        public static string ParentDirectory(this string filePath) => throw null;
        public static System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>> ParseAsKeyValues(this string text, string delimiter = default(string)) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> ParseKeyValueText(this string text, string delimiter = default(string)) => throw null;
        public static string Quoted(this string text) => throw null;
        public static string ReadAllText(this string filePath) => throw null;
        public static System.Collections.Generic.IEnumerable<string> ReadLines(this string text) => throw null;
        public static string RemoveCharFlags(this string text, bool[] charFlags) => throw null;
        public static string ReplaceAll(this string haystack, string needle, string replacement) => throw null;
        public static string ReplaceFirst(this string haystack, string needle, string replacement) => throw null;
        public static string RightPart(this string strVal, char needle) => throw null;
        public static string RightPart(this string strVal, string needle) => throw null;
        public static string SafeSubstring(this string value, int startIndex) => throw null;
        public static string SafeSubstring(this string value, int startIndex, int length) => throw null;
        public static string SafeVarName(this string text) => throw null;
        public static string SafeVarRef(this string text) => throw null;
        public static string SplitCamelCase(this string value) => throw null;
        public static string[] SplitOnFirst(this string strVal, char needle) => throw null;
        public static string[] SplitOnFirst(this string strVal, string needle) => throw null;
        public static string[] SplitOnLast(this string strVal, char needle) => throw null;
        public static string[] SplitOnLast(this string strVal, string needle) => throw null;
        public static bool StartsWithIgnoreCase(this string text, string startsWith) => throw null;
        public static string StripHtml(this string html) => throw null;
        public static string StripMarkdownMarkup(this string markdown) => throw null;
        public static string StripQuotes(this string text) => throw null;
        public static string SubstringWithElipsis(this string value, int startIndex, int length) => throw null;
        public static string SubstringWithEllipsis(this string value, int startIndex, int length) => throw null;
        public static byte[] ToAsciiBytes(this string value) => throw null;
        public static string ToBase64UrlSafe(this byte[] input) => throw null;
        public static string ToBase64UrlSafe(this System.IO.MemoryStream ms) => throw null;
        public static string ToCamelCase(this string value) => throw null;
        public static string ToCsv<T>(this T obj) => throw null;
        public static string ToCsv<T>(this T obj, System.Action<ServiceStack.Text.Config> configure) => throw null;
        public static decimal ToDecimal(this string text) => throw null;
        public static decimal ToDecimal(this string text, decimal defaultValue) => throw null;
        public static decimal ToDecimalInvariant(this string text) => throw null;
        public static double ToDouble(this string text) => throw null;
        public static double ToDouble(this string text, double defaultValue) => throw null;
        public static double ToDoubleInvariant(this string text) => throw null;
        public static string ToEnglish(this string camelCase) => throw null;
        public static T ToEnum<T>(this string value) => throw null;
        public static T ToEnumOrDefault<T>(this string value, T defaultValue) => throw null;
        public static float ToFloat(this string text) => throw null;
        public static float ToFloat(this string text, float defaultValue) => throw null;
        public static float ToFloatInvariant(this string text) => throw null;
        public static string ToHex(this byte[] hashBytes, bool upper = default(bool)) => throw null;
        public static string ToHttps(this string url) => throw null;
        public static int ToInt(this string text) => throw null;
        public static int ToInt(this string text, int defaultValue) => throw null;
        public static long ToInt64(this string text) => throw null;
        public static long ToInt64(this string text, long defaultValue) => throw null;
        public static string ToInvariantUpper(this char value) => throw null;
        public static string ToJson<T>(this T obj, System.Action<ServiceStack.Text.Config> configure) => throw null;
        public static string ToJson<T>(this T obj) => throw null;
        public static string ToJsv<T>(this T obj) => throw null;
        public static string ToJsv<T>(this T obj, System.Action<ServiceStack.Text.Config> configure) => throw null;
        public static string ToKebabCase(this string value) => throw null;
        public static long ToLong(this string text) => throw null;
        public static long ToLong(this string text, long defaultValue) => throw null;
        public static string ToLowercaseUnderscore(this string value) => throw null;
        public static string ToLowerSafe(this string value) => throw null;
        public static string ToNullIfEmpty(this string text) => throw null;
        public static string ToParentPath(this string path) => throw null;
        public static string ToPascalCase(this string value) => throw null;
        public static string ToRot13(this string value) => throw null;
        public static string ToSafeJson<T>(this T obj) => throw null;
        public static string ToSafeJsv<T>(this T obj) => throw null;
        public static string ToTitleCase(this string value) => throw null;
        public static string ToUpperSafe(this string value) => throw null;
        public static byte[] ToUtf8Bytes(this string value) => throw null;
        public static byte[] ToUtf8Bytes(this int intVal) => throw null;
        public static byte[] ToUtf8Bytes(this long longVal) => throw null;
        public static byte[] ToUtf8Bytes(this ulong ulongVal) => throw null;
        public static byte[] ToUtf8Bytes(this double doubleVal) => throw null;
        public static string ToXml<T>(this T obj) => throw null;
        public static string TrimPrefixes(this string fromString, params string[] prefixes) => throw null;
        public static string UrlDecode(this string text) => throw null;
        public static string UrlEncode(this string text, bool upperCase = default(bool)) => throw null;
        public static string UrlFormat(this string url, params string[] urlComponents) => throw null;
        public static string UrlWithTrailingSlash(this string url) => throw null;
        public static string WithoutBom(this string value) => throw null;
        public static string WithoutExtension(this string filePath) => throw null;
        public static string WithTrailingSlash(this string path) => throw null;
    }
    public static partial class TaskExtensions
    {
        public static System.Threading.Tasks.Task<T> Error<T>(this System.Threading.Tasks.Task<T> task, System.Action<System.Exception> fn, bool onUiThread = default(bool), System.Threading.Tasks.TaskContinuationOptions taskOptions = default(System.Threading.Tasks.TaskContinuationOptions)) => throw null;
        public static System.Threading.Tasks.Task Error(this System.Threading.Tasks.Task task, System.Action<System.Exception> fn, bool onUiThread = default(bool), System.Threading.Tasks.TaskContinuationOptions taskOptions = default(System.Threading.Tasks.TaskContinuationOptions)) => throw null;
        public static System.Threading.Tasks.Task<T> Success<T>(this System.Threading.Tasks.Task<T> task, System.Action<T> fn, bool onUiThread = default(bool), System.Threading.Tasks.TaskContinuationOptions taskOptions = default(System.Threading.Tasks.TaskContinuationOptions)) => throw null;
        public static System.Threading.Tasks.Task Success(this System.Threading.Tasks.Task task, System.Action fn, bool onUiThread = default(bool), System.Threading.Tasks.TaskContinuationOptions taskOptions = default(System.Threading.Tasks.TaskContinuationOptions)) => throw null;
        public static System.Exception UnwrapIfSingleException<T>(this System.Threading.Tasks.Task<T> task) => throw null;
        public static System.Exception UnwrapIfSingleException(this System.Threading.Tasks.Task task) => throw null;
        public static System.Exception UnwrapIfSingleException(this System.Exception ex) => throw null;
    }
    public static class TaskResult
    {
        public static readonly System.Threading.Tasks.Task Canceled;
        public static readonly System.Threading.Tasks.Task<bool> False;
        public static readonly System.Threading.Tasks.Task Finished;
        public static System.Threading.Tasks.Task<int> One;
        public static readonly System.Threading.Tasks.Task<bool> True;
        public static System.Threading.Tasks.Task<int> Zero;
    }
    public static class TaskUtils
    {
        public static System.Threading.Tasks.Task<To> Cast<From, To>(this System.Threading.Tasks.Task<From> task) where To : From => throw null;
        public static System.Threading.Tasks.Task EachAsync<T>(this System.Collections.Generic.IEnumerable<T> items, System.Func<T, int, System.Threading.Tasks.Task> fn) => throw null;
        public static System.Threading.Tasks.Task<T> FromResult<T>(T result) => throw null;
        public static System.Threading.Tasks.Task<T> InTask<T>(this T result) => throw null;
        public static System.Threading.Tasks.Task<T> InTask<T>(this System.Exception ex) => throw null;
        public static bool IsSuccess(this System.Threading.Tasks.Task task) => throw null;
        public static System.Threading.Tasks.TaskScheduler SafeTaskScheduler() => throw null;
        public static void Sleep(int timeMs) => throw null;
        public static void Sleep(System.TimeSpan time) => throw null;
        public static System.Threading.Tasks.Task<To> Then<From, To>(this System.Threading.Tasks.Task<From> task, System.Func<From, To> fn) => throw null;
        public static System.Threading.Tasks.Task Then(this System.Threading.Tasks.Task task, System.Func<System.Threading.Tasks.Task, System.Threading.Tasks.Task> fn) => throw null;
    }
    namespace Text
    {
        public static class AssemblyUtils
        {
            public static System.Type FindType(string typeName) => throw null;
            public static System.Type FindType(string typeName, string assemblyName) => throw null;
            public static System.Type FindTypeFromLoadedAssemblies(string typeName) => throw null;
            public static string GetAssemblyBinPath(System.Reflection.Assembly assembly) => throw null;
            public static System.Reflection.Assembly LoadAssembly(string assemblyPath) => throw null;
            public static System.Type MainInterface<T>() => throw null;
            public static string ToTypeString(this System.Type type) => throw null;
            public static string WriteType(System.Type type) => throw null;
        }
        public class CachedTypeInfo
        {
            public CachedTypeInfo(System.Type type) => throw null;
            public ServiceStack.Text.EnumInfo EnumInfo { get => throw null; }
            public static ServiceStack.Text.CachedTypeInfo Get(System.Type type) => throw null;
        }
        public static partial class CharMemoryExtensions
        {
            public static System.ReadOnlyMemory<char> Advance(this System.ReadOnlyMemory<char> text, int to) => throw null;
            public static System.ReadOnlyMemory<char> AdvancePastChar(this System.ReadOnlyMemory<char> literal, char delim) => throw null;
            public static System.ReadOnlyMemory<char> AdvancePastWhitespace(this System.ReadOnlyMemory<char> literal) => throw null;
            public static bool EndsWith(this System.ReadOnlyMemory<char> value, string other) => throw null;
            public static bool EndsWith(this System.ReadOnlyMemory<char> value, string other, System.StringComparison comparison) => throw null;
            public static bool EqualsOrdinal(this System.ReadOnlyMemory<char> value, string other) => throw null;
            public static bool EqualsOrdinal(this System.ReadOnlyMemory<char> value, System.ReadOnlyMemory<char> other) => throw null;
            public static System.ReadOnlyMemory<char> FromUtf8(this System.ReadOnlyMemory<byte> bytes) => throw null;
            public static int IndexOf(this System.ReadOnlyMemory<char> value, char needle) => throw null;
            public static int IndexOf(this System.ReadOnlyMemory<char> value, string needle) => throw null;
            public static int IndexOf(this System.ReadOnlyMemory<char> value, char needle, int start) => throw null;
            public static int IndexOf(this System.ReadOnlyMemory<char> value, string needle, int start) => throw null;
            public static bool IsNullOrEmpty(this System.ReadOnlyMemory<char> value) => throw null;
            public static bool IsNullOrWhiteSpace(this System.ReadOnlyMemory<char> value) => throw null;
            public static bool IsWhiteSpace(this System.ReadOnlyMemory<char> value) => throw null;
            public static int LastIndexOf(this System.ReadOnlyMemory<char> value, char needle) => throw null;
            public static int LastIndexOf(this System.ReadOnlyMemory<char> value, string needle) => throw null;
            public static int LastIndexOf(this System.ReadOnlyMemory<char> value, char needle, int start) => throw null;
            public static int LastIndexOf(this System.ReadOnlyMemory<char> value, string needle, int start) => throw null;
            public static System.ReadOnlyMemory<char> LastLeftPart(this System.ReadOnlyMemory<char> strVal, char needle) => throw null;
            public static System.ReadOnlyMemory<char> LastLeftPart(this System.ReadOnlyMemory<char> strVal, string needle) => throw null;
            public static System.ReadOnlyMemory<char> LastRightPart(this System.ReadOnlyMemory<char> strVal, char needle) => throw null;
            public static System.ReadOnlyMemory<char> LastRightPart(this System.ReadOnlyMemory<char> strVal, string needle) => throw null;
            public static System.ReadOnlyMemory<char> LeftPart(this System.ReadOnlyMemory<char> strVal, char needle) => throw null;
            public static System.ReadOnlyMemory<char> LeftPart(this System.ReadOnlyMemory<char> strVal, string needle) => throw null;
            public static bool ParseBoolean(this System.ReadOnlyMemory<char> value) => throw null;
            public static byte ParseByte(this System.ReadOnlyMemory<char> value) => throw null;
            public static decimal ParseDecimal(this System.ReadOnlyMemory<char> value) => throw null;
            public static double ParseDouble(this System.ReadOnlyMemory<char> value) => throw null;
            public static float ParseFloat(this System.ReadOnlyMemory<char> value) => throw null;
            public static System.Guid ParseGuid(this System.ReadOnlyMemory<char> value) => throw null;
            public static short ParseInt16(this System.ReadOnlyMemory<char> value) => throw null;
            public static int ParseInt32(this System.ReadOnlyMemory<char> value) => throw null;
            public static long ParseInt64(this System.ReadOnlyMemory<char> value) => throw null;
            public static sbyte ParseSByte(this System.ReadOnlyMemory<char> value) => throw null;
            public static ushort ParseUInt16(this System.ReadOnlyMemory<char> value) => throw null;
            public static uint ParseUInt32(this System.ReadOnlyMemory<char> value) => throw null;
            public static ulong ParseUInt64(this System.ReadOnlyMemory<char> value) => throw null;
            public static System.ReadOnlyMemory<char> RightPart(this System.ReadOnlyMemory<char> strVal, char needle) => throw null;
            public static System.ReadOnlyMemory<char> RightPart(this System.ReadOnlyMemory<char> strVal, string needle) => throw null;
            public static System.ReadOnlyMemory<char> SafeSlice(this System.ReadOnlyMemory<char> value, int startIndex) => throw null;
            public static System.ReadOnlyMemory<char> SafeSlice(this System.ReadOnlyMemory<char> value, int startIndex, int length) => throw null;
            public static void SplitOnFirst(this System.ReadOnlyMemory<char> strVal, char needle, out System.ReadOnlyMemory<char> first, out System.ReadOnlyMemory<char> last) => throw null;
            public static void SplitOnFirst(this System.ReadOnlyMemory<char> strVal, System.ReadOnlyMemory<char> needle, out System.ReadOnlyMemory<char> first, out System.ReadOnlyMemory<char> last) => throw null;
            public static void SplitOnLast(this System.ReadOnlyMemory<char> strVal, char needle, out System.ReadOnlyMemory<char> first, out System.ReadOnlyMemory<char> last) => throw null;
            public static void SplitOnLast(this System.ReadOnlyMemory<char> strVal, System.ReadOnlyMemory<char> needle, out System.ReadOnlyMemory<char> first, out System.ReadOnlyMemory<char> last) => throw null;
            public static bool StartsWith(this System.ReadOnlyMemory<char> value, string other) => throw null;
            public static bool StartsWith(this System.ReadOnlyMemory<char> value, string other, System.StringComparison comparison) => throw null;
            public static string SubstringWithEllipsis(this System.ReadOnlyMemory<char> value, int startIndex, int length) => throw null;
            public static System.ReadOnlyMemory<byte> ToUtf8(this System.ReadOnlyMemory<char> chars) => throw null;
            public static bool TryParseBoolean(this System.ReadOnlyMemory<char> value, out bool result) => throw null;
            public static bool TryParseDecimal(this System.ReadOnlyMemory<char> value, out decimal result) => throw null;
            public static bool TryParseDouble(this System.ReadOnlyMemory<char> value, out double result) => throw null;
            public static bool TryParseFloat(this System.ReadOnlyMemory<char> value, out float result) => throw null;
            public static bool TryReadLine(this System.ReadOnlyMemory<char> text, out System.ReadOnlyMemory<char> line, ref int startIndex) => throw null;
            public static bool TryReadPart(this System.ReadOnlyMemory<char> text, System.ReadOnlyMemory<char> needle, out System.ReadOnlyMemory<char> part, ref int startIndex) => throw null;
        }
        namespace Common
        {
            public delegate object ConvertInstanceDelegate(object obj, System.Type type);
            public delegate object ConvertObjectDelegate(object fromObject);
            public static class DateTimeSerializer
            {
                public const string CondensedDateTimeFormat = default;
                public const string DateTimeFormatSecondsNoOffset = default;
                public const string DateTimeFormatSecondsUtcOffset = default;
                public const string DateTimeFormatTicksNoUtcOffset = default;
                public const string DateTimeFormatTicksUtcOffset = default;
                public const string DefaultDateTimeFormat = default;
                public const string DefaultDateTimeFormatWithFraction = default;
                public const string EscapedWcfJsonPrefix = default;
                public const string EscapedWcfJsonSuffix = default;
                public static System.TimeZoneInfo GetLocalTimeZoneInfo() => throw null;
                public static System.Func<string, System.Exception, System.DateTime> OnParseErrorFn { get => throw null; set { } }
                public static System.DateTime ParseDateTime(string dateTimeStr) => throw null;
                public static System.DateTimeOffset ParseDateTimeOffset(string dateTimeOffsetStr) => throw null;
                public static System.DateTime? ParseManual(string dateTimeStr) => throw null;
                public static System.DateTime? ParseManual(string dateTimeStr, System.DateTimeKind dateKind) => throw null;
                public static System.TimeSpan ParseNSTimeInterval(string doubleInSecs) => throw null;
                public static System.DateTimeOffset? ParseNullableDateTimeOffset(string dateTimeOffsetStr) => throw null;
                public static System.TimeSpan? ParseNullableTimeSpan(string dateTimeStr) => throw null;
                public static System.DateTime ParseRFC1123DateTime(string dateTimeStr) => throw null;
                public static System.DateTime? ParseShortestNullableXsdDateTime(string dateTimeStr) => throw null;
                public static System.DateTime ParseShortestXsdDateTime(string dateTimeStr) => throw null;
                public static System.TimeSpan ParseTimeSpan(string dateTimeStr) => throw null;
                public static System.DateTime ParseWcfJsonDate(string wcfJsonDate) => throw null;
                public static System.DateTimeOffset ParseWcfJsonDateOffset(string wcfJsonDate) => throw null;
                public static System.DateTime ParseXsdDateTime(string dateTimeStr) => throw null;
                public static System.TimeSpan? ParseXsdNullableTimeSpan(string dateTimeStr) => throw null;
                public static System.TimeSpan ParseXsdTimeSpan(string dateTimeStr) => throw null;
                public static System.DateTime Prepare(this System.DateTime dateTime, bool parsedAsUtc = default(bool)) => throw null;
                public const string ShortDateTimeFormat = default;
                public static string ToDateTimeString(System.DateTime dateTime) => throw null;
                public static string ToLocalXsdDateTimeString(System.DateTime dateTime) => throw null;
                public static string ToShortestXsdDateTimeString(System.DateTime dateTime) => throw null;
                public static string ToWcfJsonDate(System.DateTime dateTime) => throw null;
                public static string ToWcfJsonDateTimeOffset(System.DateTimeOffset dateTimeOffset) => throw null;
                public static string ToXsdDateTimeString(System.DateTime dateTime) => throw null;
                public static string ToXsdTimeSpanString(System.TimeSpan timeSpan) => throw null;
                public static string ToXsdTimeSpanString(System.TimeSpan? timeSpan) => throw null;
                public const string UnspecifiedOffset = default;
                public const string UtcOffset = default;
                public const string WcfJsonPrefix = default;
                public const char WcfJsonSuffix = default;
                public static void WriteWcfJsonDate(System.IO.TextWriter writer, System.DateTime dateTime) => throw null;
                public static void WriteWcfJsonDateTimeOffset(System.IO.TextWriter writer, System.DateTimeOffset dateTimeOffset) => throw null;
                public const string XsdDateTimeFormat = default;
                public const string XsdDateTimeFormat3F = default;
                public const string XsdDateTimeFormatSeconds = default;
            }
            public delegate void DeserializationErrorDelegate(object instance, System.Type propertyType, string propertyName, string propertyValueStr, System.Exception ex);
            public static class DeserializeArrayWithElements<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static System.Func<string, ServiceStack.Text.Common.ParseStringDelegate, object> GetParseFn(System.Type type) => throw null;
                public static ServiceStack.Text.Common.DeserializeArrayWithElements<TSerializer>.ParseArrayOfElementsDelegate GetParseStringSpanFn(System.Type type) => throw null;
                public delegate object ParseArrayOfElementsDelegate(System.ReadOnlySpan<char> value, ServiceStack.Text.Common.ParseStringSpanDelegate parseFn);
            }
            public static class DeserializeArrayWithElements<T, TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static T[] ParseGenericArray(string value, ServiceStack.Text.Common.ParseStringDelegate elementParseFn) => throw null;
                public static T[] ParseGenericArray(System.ReadOnlySpan<char> value, ServiceStack.Text.Common.ParseStringSpanDelegate elementParseFn) => throw null;
            }
            public static class DeserializeBuiltin<T>
            {
                public static ServiceStack.Text.Common.ParseStringDelegate Parse { get => throw null; }
                public static ServiceStack.Text.Common.ParseStringSpanDelegate ParseStringSpan { get => throw null; }
            }
            public static class DeserializeDictionary<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static ServiceStack.Text.Common.ParseStringDelegate GetParseMethod(System.Type type) => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanMethod(System.Type type) => throw null;
                public static System.Collections.Generic.IDictionary<TKey, TValue> ParseDictionary<TKey, TValue>(string value, System.Type createMapType, ServiceStack.Text.Common.ParseStringDelegate parseKeyFn, ServiceStack.Text.Common.ParseStringDelegate parseValueFn) => throw null;
                public static System.Collections.Generic.IDictionary<TKey, TValue> ParseDictionary<TKey, TValue>(System.ReadOnlySpan<char> value, System.Type createMapType, ServiceStack.Text.Common.ParseStringSpanDelegate parseKeyFn, ServiceStack.Text.Common.ParseStringSpanDelegate parseValueFn) => throw null;
                public static object ParseDictionaryType(string value, System.Type createMapType, System.Type[] argTypes, ServiceStack.Text.Common.ParseStringDelegate keyParseFn, ServiceStack.Text.Common.ParseStringDelegate valueParseFn) => throw null;
                public static object ParseDictionaryType(System.ReadOnlySpan<char> value, System.Type createMapType, System.Type[] argTypes, ServiceStack.Text.Common.ParseStringSpanDelegate keyParseFn, ServiceStack.Text.Common.ParseStringSpanDelegate valueParseFn) => throw null;
                public static System.Collections.IDictionary ParseIDictionary(string value, System.Type dictType) => throw null;
                public static System.Collections.IDictionary ParseIDictionary(System.ReadOnlySpan<char> value, System.Type dictType) => throw null;
                public static T ParseInheritedJsonObject<T>(System.ReadOnlySpan<char> value) where T : ServiceStack.Text.JsonObject, new() => throw null;
                public static ServiceStack.Text.JsonObject ParseJsonObject(string value) => throw null;
                public static ServiceStack.Text.JsonObject ParseJsonObject(System.ReadOnlySpan<char> value) => throw null;
                public static System.Collections.Generic.Dictionary<string, string> ParseStringDictionary(string value) => throw null;
                public static System.Collections.Generic.Dictionary<string, string> ParseStringDictionary(System.ReadOnlySpan<char> value) => throw null;
            }
            public static class DeserializeList<T, TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static ServiceStack.Text.Common.ParseStringDelegate GetParseFn() => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn() => throw null;
                public static ServiceStack.Text.Common.ParseStringDelegate Parse { get => throw null; }
                public static ServiceStack.Text.Common.ParseStringSpanDelegate ParseStringSpan { get => throw null; }
            }
            public static class DeserializeListWithElements<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static System.Func<string, System.Type, ServiceStack.Text.Common.ParseStringDelegate, object> GetListTypeParseFn(System.Type createListType, System.Type elementType, ServiceStack.Text.Common.ParseStringDelegate parseFn) => throw null;
                public static ServiceStack.Text.Common.DeserializeListWithElements<TSerializer>.ParseListDelegate GetListTypeParseStringSpanFn(System.Type createListType, System.Type elementType, ServiceStack.Text.Common.ParseStringSpanDelegate parseFn) => throw null;
                public static System.Collections.Generic.List<byte> ParseByteList(string value) => throw null;
                public static System.Collections.Generic.List<byte> ParseByteList(System.ReadOnlySpan<char> value) => throw null;
                public static System.Collections.Generic.List<int> ParseIntList(string value) => throw null;
                public static System.Collections.Generic.List<int> ParseIntList(System.ReadOnlySpan<char> value) => throw null;
                public delegate object ParseListDelegate(System.ReadOnlySpan<char> value, System.Type createListType, ServiceStack.Text.Common.ParseStringSpanDelegate parseFn);
                public static System.Collections.Generic.List<string> ParseStringList(string value) => throw null;
                public static System.Collections.Generic.List<string> ParseStringList(System.ReadOnlySpan<char> value) => throw null;
                public static System.ReadOnlySpan<char> StripList(System.ReadOnlySpan<char> value) => throw null;
            }
            public static class DeserializeListWithElements<T, TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static System.Collections.Generic.ICollection<T> ParseGenericList(string value, System.Type createListType, ServiceStack.Text.Common.ParseStringDelegate parseFn) => throw null;
                public static System.Collections.Generic.ICollection<T> ParseGenericList(System.ReadOnlySpan<char> value, System.Type createListType, ServiceStack.Text.Common.ParseStringSpanDelegate parseFn) => throw null;
            }
            public delegate object DeserializeStringSpanDelegate(System.Type type, System.ReadOnlySpan<char> source);
            public static class DeserializeType<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static System.Type ExtractType(string strType) => throw null;
                public static System.Type ExtractType(System.ReadOnlySpan<char> strType) => throw null;
                public static object ObjectStringToType(System.ReadOnlySpan<char> strType) => throw null;
                public static object ParseAbstractType<T>(System.ReadOnlySpan<char> value) => throw null;
                public static object ParsePrimitive(string value) => throw null;
                public static object ParsePrimitive(System.ReadOnlySpan<char> value) => throw null;
                public static object ParseQuotedPrimitive(string value) => throw null;
            }
            public static class DeserializeTypeExensions
            {
                public static bool Has(this ServiceStack.Text.ParseAsType flags, ServiceStack.Text.ParseAsType flag) => throw null;
                public static object ParseNumber(this System.ReadOnlySpan<char> value) => throw null;
                public static object ParseNumber(this System.ReadOnlySpan<char> value, bool bestFit) => throw null;
            }
            public class DeserializeTypeUtils
            {
                public DeserializeTypeUtils() => throw null;
                public static ServiceStack.Text.Common.ParseStringDelegate GetParseMethod(System.Type type) => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanMethod(System.Type type) => throw null;
                public static System.Reflection.ConstructorInfo GetTypeStringConstructor(System.Type type) => throw null;
            }
            public interface ITypeSerializer
            {
                bool EatItemSeperatorOrMapEndChar(string value, ref int i);
                bool EatItemSeperatorOrMapEndChar(System.ReadOnlySpan<char> value, ref int i);
                string EatMapKey(string value, ref int i);
                System.ReadOnlySpan<char> EatMapKey(System.ReadOnlySpan<char> value, ref int i);
                bool EatMapKeySeperator(string value, ref int i);
                bool EatMapKeySeperator(System.ReadOnlySpan<char> value, ref int i);
                bool EatMapStartChar(string value, ref int i);
                bool EatMapStartChar(System.ReadOnlySpan<char> value, ref int i);
                string EatTypeValue(string value, ref int i);
                System.ReadOnlySpan<char> EatTypeValue(System.ReadOnlySpan<char> value, ref int i);
                string EatValue(string value, ref int i);
                System.ReadOnlySpan<char> EatValue(System.ReadOnlySpan<char> value, ref int i);
                void EatWhitespace(string value, ref int i);
                void EatWhitespace(System.ReadOnlySpan<char> value, ref int i);
                ServiceStack.Text.Common.ParseStringDelegate GetParseFn<T>();
                ServiceStack.Text.Common.ParseStringDelegate GetParseFn(System.Type type);
                ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn<T>();
                ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn(System.Type type);
                ServiceStack.Text.Json.TypeInfo GetTypeInfo(System.Type type);
                ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn<T>();
                ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn(System.Type type);
                bool IncludeNullValues { get; }
                bool IncludeNullValuesInDictionaries { get; }
                ServiceStack.Text.Common.ObjectDeserializerDelegate ObjectDeserializer { get; set; }
                string ParseRawString(string value);
                string ParseString(string value);
                string ParseString(System.ReadOnlySpan<char> value);
                string TypeAttrInObject { get; }
                string UnescapeSafeString(string value);
                System.ReadOnlySpan<char> UnescapeSafeString(System.ReadOnlySpan<char> value);
                string UnescapeString(string value);
                System.ReadOnlySpan<char> UnescapeString(System.ReadOnlySpan<char> value);
                object UnescapeStringAsObject(System.ReadOnlySpan<char> value);
                void WriteBool(System.IO.TextWriter writer, object boolValue);
                void WriteBuiltIn(System.IO.TextWriter writer, object value);
                void WriteByte(System.IO.TextWriter writer, object byteValue);
                void WriteBytes(System.IO.TextWriter writer, object oByteValue);
                void WriteChar(System.IO.TextWriter writer, object charValue);
                void WriteDateOnly(System.IO.TextWriter writer, object oDateOnly);
                void WriteDateTime(System.IO.TextWriter writer, object oDateTime);
                void WriteDateTimeOffset(System.IO.TextWriter writer, object oDateTimeOffset);
                void WriteDecimal(System.IO.TextWriter writer, object decimalValue);
                void WriteDouble(System.IO.TextWriter writer, object doubleValue);
                void WriteEnum(System.IO.TextWriter writer, object enumValue);
                void WriteException(System.IO.TextWriter writer, object value);
                void WriteFloat(System.IO.TextWriter writer, object floatValue);
                void WriteFormattableObjectString(System.IO.TextWriter writer, object value);
                void WriteGuid(System.IO.TextWriter writer, object oValue);
                void WriteInt16(System.IO.TextWriter writer, object intValue);
                void WriteInt32(System.IO.TextWriter writer, object intValue);
                void WriteInt64(System.IO.TextWriter writer, object longValue);
                void WriteNullableDateOnly(System.IO.TextWriter writer, object oDateOnly);
                void WriteNullableDateTime(System.IO.TextWriter writer, object dateTime);
                void WriteNullableDateTimeOffset(System.IO.TextWriter writer, object dateTimeOffset);
                void WriteNullableGuid(System.IO.TextWriter writer, object oValue);
                void WriteNullableTimeOnly(System.IO.TextWriter writer, object oTimeOnly);
                void WriteNullableTimeSpan(System.IO.TextWriter writer, object timeSpan);
                void WriteObjectString(System.IO.TextWriter writer, object value);
                void WritePropertyName(System.IO.TextWriter writer, string value);
                void WriteRawString(System.IO.TextWriter writer, string value);
                void WriteSByte(System.IO.TextWriter writer, object sbyteValue);
                void WriteString(System.IO.TextWriter writer, string value);
                void WriteTimeOnly(System.IO.TextWriter writer, object oTimeOnly);
                void WriteTimeSpan(System.IO.TextWriter writer, object timeSpan);
                void WriteUInt16(System.IO.TextWriter writer, object intValue);
                void WriteUInt32(System.IO.TextWriter writer, object uintValue);
                void WriteUInt64(System.IO.TextWriter writer, object ulongValue);
            }
            public class JsReader<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public JsReader() => throw null;
                public ServiceStack.Text.Common.ParseStringDelegate GetParseFn<T>() => throw null;
                public ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn<T>() => throw null;
                public static void InitAot<T>() => throw null;
            }
            public static class JsWriter
            {
                public static void AssertAllowedRuntimeType(System.Type type) => throw null;
                public static readonly char[] CsvChars;
                public const string EmptyMap = default;
                public static readonly char[] EscapeChars;
                public const string EscapedQuoteString = default;
                public static ServiceStack.Text.Common.ITypeSerializer GetTypeSerializer<TSerializer>() => throw null;
                public static bool HasAnyEscapeChars(string value) => throw null;
                public const char ItemSeperator = default;
                public const string ItemSeperatorString = default;
                public const char LineFeedChar = default;
                public const char ListEndChar = default;
                public const char ListStartChar = default;
                public const char MapEndChar = default;
                public const char MapKeySeperator = default;
                public const string MapKeySeperatorString = default;
                public const string MapNullValue = default;
                public const char MapStartChar = default;
                public const char QuoteChar = default;
                public const string QuoteString = default;
                public const char ReturnChar = default;
                public static bool ShouldAllowRuntimeType(System.Type type) => throw null;
                public const string TypeAttr = default;
                public static void WriteDynamic(System.Action callback) => throw null;
                public static void WriteEnumFlags(System.IO.TextWriter writer, object enumFlagValue) => throw null;
            }
            public class JsWriter<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public JsWriter() => throw null;
                public ServiceStack.Text.Common.WriteObjectDelegate GetSpecialWriteFn(System.Type type) => throw null;
                public ServiceStack.Text.Common.WriteObjectDelegate GetValueTypeToStringMethod(System.Type type) => throw null;
                public ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn<T>() => throw null;
                public static void InitAot<T>() => throw null;
                public readonly System.Collections.Generic.Dictionary<System.Type, ServiceStack.Text.Common.WriteObjectDelegate> SpecialTypes;
                public void WriteType(System.IO.TextWriter writer, object value) => throw null;
                public void WriteValue(System.IO.TextWriter writer, object value) => throw null;
            }
            public delegate object ObjectDeserializerDelegate(System.ReadOnlySpan<char> value);
            public delegate object ParseStringDelegate(string stringValue);
            public delegate object ParseStringSpanDelegate(System.ReadOnlySpan<char> value);
            public static class StaticParseMethod<T>
            {
                public static ServiceStack.Text.Common.ParseStringDelegate Parse { get => throw null; }
                public static ServiceStack.Text.Common.ParseStringSpanDelegate ParseStringSpan { get => throw null; }
            }
            public static class ToStringDictionaryMethods<TKey, TValue, TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static void WriteGenericIDictionary(System.IO.TextWriter writer, System.Collections.Generic.IDictionary<TKey, TValue> map, ServiceStack.Text.Common.WriteObjectDelegate writeKeyFn, ServiceStack.Text.Common.WriteObjectDelegate writeValueFn) => throw null;
                public static void WriteIDictionary(System.IO.TextWriter writer, object oMap, ServiceStack.Text.Common.WriteObjectDelegate writeKeyFn, ServiceStack.Text.Common.WriteObjectDelegate writeValueFn) => throw null;
            }
            public static class WriteListsOfElements<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static ServiceStack.Text.Common.WriteObjectDelegate GetGenericWriteArray(System.Type elementType) => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate GetGenericWriteEnumerable(System.Type elementType) => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate GetIListWriteFn(System.Type elementType) => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate GetListWriteFn(System.Type elementType) => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate GetWriteIListValueType(System.Type elementType) => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate GetWriteListValueType(System.Type elementType) => throw null;
                public static void WriteIEnumerable(System.IO.TextWriter writer, object oValueCollection) => throw null;
            }
            public static class WriteListsOfElements<T, TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static void WriteArray(System.IO.TextWriter writer, object oArrayValue) => throw null;
                public static void WriteEnumerable(System.IO.TextWriter writer, object oEnumerable) => throw null;
                public static void WriteGenericArray(System.IO.TextWriter writer, System.Array array) => throw null;
                public static void WriteGenericArrayValueType(System.IO.TextWriter writer, object oArray) => throw null;
                public static void WriteGenericArrayValueType(System.IO.TextWriter writer, T[] array) => throw null;
                public static void WriteGenericEnumerable(System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<T> enumerable) => throw null;
                public static void WriteGenericEnumerableValueType(System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<T> enumerable) => throw null;
                public static void WriteGenericIList(System.IO.TextWriter writer, System.Collections.Generic.IList<T> list) => throw null;
                public static void WriteGenericIListValueType(System.IO.TextWriter writer, System.Collections.Generic.IList<T> list) => throw null;
                public static void WriteGenericList(System.IO.TextWriter writer, System.Collections.Generic.List<T> list) => throw null;
                public static void WriteGenericListValueType(System.IO.TextWriter writer, System.Collections.Generic.List<T> list) => throw null;
                public static void WriteIList(System.IO.TextWriter writer, object oList) => throw null;
                public static void WriteIListValueType(System.IO.TextWriter writer, object list) => throw null;
                public static void WriteList(System.IO.TextWriter writer, object oList) => throw null;
                public static void WriteListValueType(System.IO.TextWriter writer, object list) => throw null;
            }
            public delegate void WriteObjectDelegate(System.IO.TextWriter writer, object obj);
        }
        public class Config
        {
            public bool AlwaysUseUtc { get => throw null; set { } }
            public bool AppendUtcOffset { get => throw null; set { } }
            public static ServiceStack.Text.Config AssertNotInit() => throw null;
            public bool AssumeUtc { get => throw null; set { } }
            public bool ConvertObjectTypesIntoStringDictionary { get => throw null; set { } }
            public Config() => throw null;
            public ServiceStack.Text.DateHandler DateHandler { get => throw null; set { } }
            public string DateTimeFormat { get => throw null; set { } }
            public static ServiceStack.Text.Config Defaults { get => throw null; }
            public bool EmitCamelCaseNames { get => throw null; set { } }
            public bool EmitLowercaseUnderscoreNames { get => throw null; set { } }
            public bool EscapeHtmlChars { get => throw null; set { } }
            public bool EscapeUnicode { get => throw null; set { } }
            public bool ExcludeDefaultValues { get => throw null; set { } }
            public string[] ExcludePropertyReferences { get => throw null; set { } }
            public bool ExcludeTypeInfo { get => throw null; set { } }
            public System.Collections.Generic.HashSet<string> ExcludeTypeNames { get => throw null; set { } }
            public System.Collections.Generic.HashSet<System.Type> ExcludeTypes { get => throw null; set { } }
            public bool IncludeDefaultEnums { get => throw null; set { } }
            public bool IncludeNullValues { get => throw null; set { } }
            public bool IncludeNullValuesInDictionaries { get => throw null; set { } }
            public bool IncludePublicFields { get => throw null; set { } }
            public bool IncludeTypeInfo { get => throw null; set { } }
            public bool Indent { get => throw null; set { } }
            public static void Init() => throw null;
            public static void Init(ServiceStack.Text.Config config) => throw null;
            public int MaxDepth { get => throw null; set { } }
            public ServiceStack.EmptyCtorFactoryDelegate ModelFactory { get => throw null; set { } }
            public ServiceStack.Text.Common.DeserializationErrorDelegate OnDeserializationError { get => throw null; set { } }
            public ServiceStack.Text.ParseAsType ParsePrimitiveFloatingPointTypes { get => throw null; set { } }
            public System.Func<string, object> ParsePrimitiveFn { get => throw null; set { } }
            public ServiceStack.Text.ParseAsType ParsePrimitiveIntegerTypes { get => throw null; set { } }
            public ServiceStack.Text.Config Populate(ServiceStack.Text.Config config) => throw null;
            public bool PreferInterfaces { get => throw null; set { } }
            public ServiceStack.Text.PropertyConvention PropertyConvention { get => throw null; set { } }
            public bool SkipDateTimeConversion { get => throw null; set { } }
            public ServiceStack.Text.TextCase TextCase { get => throw null; set { } }
            public bool ThrowOnError { get => throw null; set { } }
            public ServiceStack.Text.TimeSpanHandler TimeSpanHandler { get => throw null; set { } }
            public bool TreatEnumAsInteger { get => throw null; set { } }
            public bool TryParseIntoBestFit { get => throw null; set { } }
            public bool TryToParseNumericType { get => throw null; set { } }
            public bool TryToParsePrimitiveTypeValues { get => throw null; set { } }
            public string TypeAttr { get => throw null; set { } }
            public System.ReadOnlyMemory<char> TypeAttrMemory { get => throw null; }
            public System.Func<string, System.Type> TypeFinder { get => throw null; set { } }
            public System.Func<System.Type, string> TypeWriter { get => throw null; set { } }
            public static void UnsafeInit(ServiceStack.Text.Config config) => throw null;
        }
        namespace Controller
        {
            public class CommandProcessor
            {
                public CommandProcessor(object[] controllers) => throw null;
                public void Invoke(string commandUri) => throw null;
            }
            public class PathInfo
            {
                public string ActionName { get => throw null; }
                public System.Collections.Generic.List<string> Arguments { get => throw null; }
                public string ControllerName { get => throw null; }
                public PathInfo(string actionName, params string[] arguments) => throw null;
                public PathInfo(string actionName, System.Collections.Generic.List<string> arguments, System.Collections.Generic.Dictionary<string, string> options) => throw null;
                public string FirstArgument { get => throw null; }
                public T GetArgumentValue<T>(int index) => throw null;
                public System.Collections.Generic.Dictionary<string, string> Options { get => throw null; }
                public static ServiceStack.Text.Controller.PathInfo Parse(string pathUri) => throw null;
            }
        }
        public class ConvertibleTypeKey
        {
            public ConvertibleTypeKey() => throw null;
            public ConvertibleTypeKey(System.Type toInstanceType, System.Type fromElementType) => throw null;
            public bool Equals(ServiceStack.Text.ConvertibleTypeKey other) => throw null;
            public override bool Equals(object obj) => throw null;
            public System.Type FromElementType { get => throw null; set { } }
            public override int GetHashCode() => throw null;
            public System.Type ToInstanceType { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)12, Inherited = false, AllowMultiple = false)]
        public class CsvAttribute : System.Attribute
        {
            public ServiceStack.Text.CsvBehavior CsvBehavior { get => throw null; set { } }
            public CsvAttribute(ServiceStack.Text.CsvBehavior csvBehavior) => throw null;
        }
        public enum CsvBehavior
        {
            FirstEnumerable = 0,
        }
        public static class CsvConfig
        {
            public static string[] EscapeStrings { get => throw null; }
            public static string ItemDelimiterString { get => throw null; set { } }
            public static string ItemSeperatorString { get => throw null; set { } }
            public static System.Globalization.CultureInfo RealNumberCultureInfo { get => throw null; set { } }
            public static void Reset() => throw null;
            public static string RowSeparatorString { get => throw null; set { } }
        }
        public static class CsvConfig<T>
        {
            public static object CustomHeaders { set { } }
            public static System.Collections.Generic.Dictionary<string, string> CustomHeadersMap { get => throw null; set { } }
            public static bool OmitHeaders { get => throw null; set { } }
            public static void Reset() => throw null;
        }
        public class CsvReader
        {
            public CsvReader() => throw null;
            public static string EatValue(string value, ref int i) => throw null;
            public static System.Collections.Generic.List<string> ParseFields(string line) => throw null;
            public static System.Collections.Generic.List<string> ParseFields(string line, System.Func<string, string> parseFn) => throw null;
            public static System.Collections.Generic.List<string> ParseLines(string csv) => throw null;
        }
        public class CsvReader<T>
        {
            public CsvReader() => throw null;
            public static System.Collections.Generic.List<T> GetRows(System.Collections.Generic.IEnumerable<string> records) => throw null;
            public static System.Collections.Generic.List<string> Headers { get => throw null; set { } }
            public static System.Collections.Generic.List<T> Read(System.Collections.Generic.List<string> rows) => throw null;
            public static object ReadObject(string csv) => throw null;
            public static object ReadObjectRow(string csv) => throw null;
            public static T ReadRow(string value) => throw null;
            public static System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> ReadStringDictionary(System.Collections.Generic.IEnumerable<string> rows) => throw null;
        }
        public class CsvSerializer
        {
            public CsvSerializer() => throw null;
            public static T DeserializeFromReader<T>(System.IO.TextReader reader) => throw null;
            public static T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public static object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public static T DeserializeFromString<T>(string text) => throw null;
            public static object DeserializeFromString(System.Type type, string text) => throw null;
            public static void InitAot<T>() => throw null;
            public static System.Action<object> OnSerialize { get => throw null; set { } }
            public static (string PropertyName, System.Type PropertyType)[] PropertiesFor<T>() => throw null;
            public static (string PropertyName, System.Type PropertyType)[] PropertiesFor(System.Type type) => throw null;
            public static object ReadLateBoundObject(System.Type type, string value) => throw null;
            public static string SerializeToCsv<T>(System.Collections.Generic.IEnumerable<T> records) => throw null;
            public static void SerializeToStream<T>(T value, System.IO.Stream stream) => throw null;
            public static void SerializeToStream(object obj, System.IO.Stream stream) => throw null;
            public static string SerializeToString<T>(T value) => throw null;
            public static void SerializeToWriter<T>(T value, System.IO.TextWriter writer) => throw null;
            public static System.Text.Encoding UseEncoding { get => throw null; set { } }
            public static void WriteLateBoundObject(System.IO.TextWriter writer, object value) => throw null;
        }
        public static class CsvSerializer<T>
        {
            public static (string PropertyName, System.Type PropertyType)[] Properties { get => throw null; }
            public static object ReadEnumerableProperty(string row) => throw null;
            public static object ReadEnumerableType(string value) => throw null;
            public static ServiceStack.Text.Common.ParseStringDelegate ReadFn() => throw null;
            public static object ReadNonEnumerableType(string row) => throw null;
            public static object ReadObject(string value) => throw null;
            public static object ReadSelf(string value) => throw null;
            public static void WriteEnumerableProperty(System.IO.TextWriter writer, object obj) => throw null;
            public static void WriteEnumerableType(System.IO.TextWriter writer, object obj) => throw null;
            public static ServiceStack.Text.Common.WriteObjectDelegate WriteFn() => throw null;
            public static void WriteNonEnumerableType(System.IO.TextWriter writer, object obj) => throw null;
            public static void WriteObject(System.IO.TextWriter writer, object value) => throw null;
            public static void WriteSelf(System.IO.TextWriter writer, object obj) => throw null;
        }
        public static partial class CsvStreamExtensions
        {
            public static void WriteCsv<T>(this System.IO.Stream outputStream, System.Collections.Generic.IEnumerable<T> records) => throw null;
            public static void WriteCsv<T>(this System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<T> records) => throw null;
        }
        public class CsvStringSerializer : ServiceStack.Text.IStringSerializer
        {
            public CsvStringSerializer() => throw null;
            public To DeserializeFromString<To>(string serializedText) => throw null;
            public object DeserializeFromString(string serializedText, System.Type type) => throw null;
            public string SerializeToString<TFrom>(TFrom from) => throw null;
        }
        public static class CsvWriter
        {
            public static bool HasAnyEscapeChars(string value) => throw null;
        }
        public class CsvWriter<T>
        {
            public CsvWriter() => throw null;
            public const char DelimiterChar = default;
            public static System.Collections.Generic.List<System.Collections.Generic.List<string>> GetRows(System.Collections.Generic.IEnumerable<T> records) => throw null;
            public static System.Collections.Generic.List<string> Headers { get => throw null; set { } }
            public static void Write(System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<T> records) => throw null;
            public static void Write(System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<System.Collections.Generic.List<string>> rows) => throw null;
            public static void WriteObject(System.IO.TextWriter writer, object records) => throw null;
            public static void WriteObjectRow(System.IO.TextWriter writer, object record) => throw null;
            public static void WriteRow(System.IO.TextWriter writer, T row) => throw null;
            public static void WriteRow(System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<string> row) => throw null;
        }
        public enum DateHandler
        {
            TimestampOffset = 0,
            DCJSCompatible = 1,
            ISO8601 = 2,
            ISO8601DateOnly = 3,
            ISO8601DateTime = 4,
            RFC1123 = 5,
            UnixTime = 6,
            UnixTimeMs = 7,
        }
        public static partial class DateTimeExtensions
        {
            public static System.DateTime EndOfLastMonth(this System.DateTime from) => throw null;
            public static string FmtSortableDate(this System.DateTime from) => throw null;
            public static string FmtSortableDateTime(this System.DateTime from) => throw null;
            public static System.DateTime FromShortestXsdDateTimeString(this string xsdDateTime) => throw null;
            public static System.TimeSpan FromTimeOffsetString(this string offsetString) => throw null;
            public static System.DateTime FromUnixTime(this int unixTime) => throw null;
            public static System.DateTime FromUnixTime(this double unixTime) => throw null;
            public static System.DateTime FromUnixTime(this long unixTime) => throw null;
            public static System.DateTime FromUnixTimeMs(this double msSince1970) => throw null;
            public static System.DateTime FromUnixTimeMs(this long msSince1970) => throw null;
            public static System.DateTime FromUnixTimeMs(this long msSince1970, System.TimeSpan offset) => throw null;
            public static System.DateTime FromUnixTimeMs(this double msSince1970, System.TimeSpan offset) => throw null;
            public static System.DateTime FromUnixTimeMs(string msSince1970) => throw null;
            public static System.DateTime FromUnixTimeMs(string msSince1970, System.TimeSpan offset) => throw null;
            public static string Humanize(this System.TimeSpan span) => throw null;
            public static bool IsEqualToTheSecond(this System.DateTime dateTime, System.DateTime otherDateTime) => throw null;
            public static System.DateTime LastMonday(this System.DateTime from) => throw null;
            public static System.DateTime RoundToMs(this System.DateTime dateTime) => throw null;
            public static System.DateTime RoundToSecond(this System.DateTime dateTime) => throw null;
            public static System.DateTime StartOfLastMonth(this System.DateTime from) => throw null;
            public static string ToShortestXsdDateTimeString(this System.DateTime dateTime) => throw null;
            public static System.DateTime ToStableUniversalTime(this System.DateTime dateTime) => throw null;
            public static string ToTimeOffsetString(this System.TimeSpan offset, string seperator = default(string)) => throw null;
            public static long ToUnixTime(this System.DateTime dateTime) => throw null;
            public static long ToUnixTime(this System.DateOnly dateOnly) => throw null;
            public static long ToUnixTimeMs(this System.DateTimeOffset dateTimeOffset) => throw null;
            public static long ToUnixTimeMs(this System.DateTime dateTime) => throw null;
            public static long ToUnixTimeMs(this long ticks) => throw null;
            public static long ToUnixTimeMs(this System.DateOnly dateOnly) => throw null;
            public static long ToUnixTimeMsAlt(this System.DateTime dateTime) => throw null;
            public static System.DateTime Truncate(this System.DateTime dateTime, System.TimeSpan timeSpan) => throw null;
            public const long UnixEpoch = 621355968000000000;
        }
        public sealed class DefaultMemory : ServiceStack.Text.MemoryProvider
        {
            public override System.Text.StringBuilder Append(System.Text.StringBuilder sb, System.ReadOnlySpan<char> value) => throw null;
            public static void Configure() => throw null;
            public override object Deserialize(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer) => throw null;
            public override System.Threading.Tasks.Task<object> DeserializeAsync(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer) => throw null;
            public override System.ReadOnlyMemory<char> FromUtf8(System.ReadOnlySpan<byte> source) => throw null;
            public override int FromUtf8(System.ReadOnlySpan<byte> source, System.Span<char> destination) => throw null;
            public override string FromUtf8Bytes(System.ReadOnlySpan<byte> source) => throw null;
            public override int GetUtf8ByteCount(System.ReadOnlySpan<char> chars) => throw null;
            public override int GetUtf8CharCount(System.ReadOnlySpan<byte> bytes) => throw null;
            public override byte[] ParseBase64(System.ReadOnlySpan<char> value) => throw null;
            public override bool ParseBoolean(System.ReadOnlySpan<char> value) => throw null;
            public override byte ParseByte(System.ReadOnlySpan<char> value) => throw null;
            public override decimal ParseDecimal(System.ReadOnlySpan<char> value) => throw null;
            public override decimal ParseDecimal(System.ReadOnlySpan<char> value, bool allowThousands) => throw null;
            public override double ParseDouble(System.ReadOnlySpan<char> value) => throw null;
            public override float ParseFloat(System.ReadOnlySpan<char> value) => throw null;
            public override System.Guid ParseGuid(System.ReadOnlySpan<char> value) => throw null;
            public override short ParseInt16(System.ReadOnlySpan<char> value) => throw null;
            public override int ParseInt32(System.ReadOnlySpan<char> value) => throw null;
            public override long ParseInt64(System.ReadOnlySpan<char> value) => throw null;
            public override sbyte ParseSByte(System.ReadOnlySpan<char> value) => throw null;
            public override ushort ParseUInt16(System.ReadOnlySpan<char> value) => throw null;
            public override uint ParseUInt32(System.ReadOnlySpan<char> value) => throw null;
            public override uint ParseUInt32(System.ReadOnlySpan<char> value, System.Globalization.NumberStyles style) => throw null;
            public override ulong ParseUInt64(System.ReadOnlySpan<char> value) => throw null;
            public static ServiceStack.Text.DefaultMemory Provider { get => throw null; }
            public override string ToBase64(System.ReadOnlyMemory<byte> value) => throw null;
            public override System.IO.MemoryStream ToMemoryStream(System.ReadOnlySpan<byte> source) => throw null;
            public override System.ReadOnlyMemory<byte> ToUtf8(System.ReadOnlySpan<char> source) => throw null;
            public override int ToUtf8(System.ReadOnlySpan<char> source, System.Span<byte> destination) => throw null;
            public override byte[] ToUtf8Bytes(System.ReadOnlySpan<char> source) => throw null;
            public override bool TryParseBoolean(System.ReadOnlySpan<char> value, out bool result) => throw null;
            public override bool TryParseDecimal(System.ReadOnlySpan<char> value, out decimal result) => throw null;
            public static bool TryParseDecimal(System.ReadOnlySpan<char> value, bool allowThousands, out decimal result) => throw null;
            public override bool TryParseDouble(System.ReadOnlySpan<char> value, out double result) => throw null;
            public override bool TryParseFloat(System.ReadOnlySpan<char> value, out float result) => throw null;
            public override void Write(System.IO.Stream stream, System.ReadOnlyMemory<char> value) => throw null;
            public override void Write(System.IO.Stream stream, System.ReadOnlyMemory<byte> value) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlySpan<char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<byte> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteUtf8ToStream(string contents, System.IO.Stream stream) => throw null;
        }
        public class DirectStreamWriter : System.IO.TextWriter
        {
            public DirectStreamWriter(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
            public override System.Text.Encoding Encoding { get => throw null; }
            public override void Flush() => throw null;
            public override void Write(string s) => throw null;
            public override void Write(char c) => throw null;
        }
        public static class DynamicProxy
        {
            public static void BindProperty(System.Reflection.Emit.TypeBuilder typeBuilder, System.Reflection.MethodInfo methodInfo) => throw null;
            public static T GetInstanceFor<T>() => throw null;
            public static object GetInstanceFor(System.Type targetType) => throw null;
        }
        public sealed class EmitReflectionOptimizer : ServiceStack.Text.ReflectionOptimizer
        {
            public override ServiceStack.EmptyCtorDelegate CreateConstructor(System.Type type) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberRefDelegate<T> CreateSetterRef<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override bool IsDynamic(System.Reflection.Assembly assembly) => throw null;
            public static ServiceStack.Text.EmitReflectionOptimizer Provider { get => throw null; }
            public override System.Type UseType(System.Type type) => throw null;
        }
        public class EnumInfo
        {
            public static ServiceStack.Text.EnumInfo GetEnumInfo(System.Type type) => throw null;
            public object GetSerializedValue(object enumValue) => throw null;
            public object Parse(string serializedValue) => throw null;
        }
        public static class Env
        {
            public static System.Runtime.CompilerServices.ConfiguredTaskAwaitable ConfigAwait(this System.Threading.Tasks.Task task) => throw null;
            public static System.Runtime.CompilerServices.ConfiguredTaskAwaitable<T> ConfigAwait<T>(this System.Threading.Tasks.Task<T> task) => throw null;
            public static System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable ConfigAwait(this System.Threading.Tasks.ValueTask task) => throw null;
            public static System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable<T> ConfigAwait<T>(this System.Threading.Tasks.ValueTask<T> task) => throw null;
            public static System.Runtime.CompilerServices.ConfiguredTaskAwaitable ConfigAwaitNetCore(this System.Threading.Tasks.Task task) => throw null;
            public static System.Runtime.CompilerServices.ConfiguredTaskAwaitable<T> ConfigAwaitNetCore<T>(this System.Threading.Tasks.Task<T> task) => throw null;
            public const bool ContinueOnCapturedContext = false;
            public static System.DateTime GetReleaseDate() => throw null;
            public static bool HasMultiplePlatformTargets { get => throw null; set { } }
            public static bool IsAndroid { get => throw null; set { } }
            public static bool IsIOS { get => throw null; set { } }
            public static bool IsLinux { get => throw null; set { } }
            public static bool IsMono { get => throw null; set { } }
            public static bool IsNet6 { get => throw null; set { } }
            public static bool IsNet8 { get => throw null; set { } }
            public static bool IsNetCore { get => throw null; set { } }
            public static bool IsNetCore21 { get => throw null; set { } }
            public static bool IsNetCore3 { get => throw null; set { } }
            public static bool IsNetFramework { get => throw null; set { } }
            public static bool IsNetNative { get => throw null; set { } }
            public static bool IsNetStandard { get => throw null; set { } }
            public static bool IsNetStandard20 { get => throw null; set { } }
            public static bool IsOSX { get => throw null; set { } }
            public static bool IsUnix { get => throw null; set { } }
            public static bool IsUWP { get => throw null; }
            public static bool IsWindows { get => throw null; set { } }
            public static string ReferenceAssemblyPath { get => throw null; set { } }
            public static string ServerUserAgent { get => throw null; set { } }
            public static decimal ServiceStackVersion;
            public static bool StrictMode { get => throw null; set { } }
            public static bool SupportsDynamic { get => throw null; }
            public static bool SupportsEmit { get => throw null; }
            public static bool SupportsExpressions { get => throw null; }
            public static string VersionString { get => throw null; set { } }
        }
        public sealed class ExpressionReflectionOptimizer : ServiceStack.Text.ReflectionOptimizer
        {
            public override ServiceStack.EmptyCtorDelegate CreateConstructor(System.Type type) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberRefDelegate<T> CreateSetterRef<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public static System.Linq.Expressions.Expression<ServiceStack.GetMemberDelegate> GetExpressionLambda(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public static System.Linq.Expressions.Expression<ServiceStack.GetMemberDelegate<T>> GetExpressionLambda<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override bool IsDynamic(System.Reflection.Assembly assembly) => throw null;
            public static ServiceStack.Text.ExpressionReflectionOptimizer Provider { get => throw null; }
            public static System.Linq.Expressions.Expression<ServiceStack.SetMemberDelegate<T>> SetExpressionLambda<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override System.Type UseType(System.Type type) => throw null;
        }
        public static class HttpStatus
        {
            public static string GetStatusDescription(int statusCode) => throw null;
        }
        public interface IRuntimeSerializable
        {
        }
        public interface IStringSerializer
        {
            To DeserializeFromString<To>(string serializedText);
            object DeserializeFromString(string serializedText, System.Type type);
            string SerializeToString<TFrom>(TFrom from);
        }
        public interface ITracer
        {
            void WriteDebug(string error);
            void WriteDebug(string format, params object[] args);
            void WriteError(System.Exception ex);
            void WriteError(string error);
            void WriteError(string format, params object[] args);
            void WriteWarning(string warning);
            void WriteWarning(string format, params object[] args);
        }
        public interface ITypeSerializer<T>
        {
            bool CanCreateFromString(System.Type type);
            T DeserializeFromReader(System.IO.TextReader reader);
            T DeserializeFromString(string value);
            string SerializeToString(T value);
            void SerializeToWriter(T value, System.IO.TextWriter writer);
        }
        public interface IValueWriter
        {
            void WriteTo(ServiceStack.Text.Common.ITypeSerializer serializer, System.IO.TextWriter writer);
        }
        public static class JsConfig
        {
            public static bool AllowRuntimeInterfaces { get => throw null; set { } }
            public static System.Func<System.Type, bool> AllowRuntimeType { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<string> AllowRuntimeTypeInTypes { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<string> AllowRuntimeTypeInTypesWithNamespaces { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<string> AllowRuntimeTypeWithAttributesNamed { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<string> AllowRuntimeTypeWithInterfacesNamed { get => throw null; set { } }
            public static bool AlwaysUseUtc { get => throw null; set { } }
            public static bool AppendUtcOffset { get => throw null; set { } }
            public static bool AssumeUtc { get => throw null; set { } }
            public static ServiceStack.Text.JsConfigScope BeginScope() => throw null;
            public static bool ConvertObjectTypesIntoStringDictionary { get => throw null; set { } }
            public static ServiceStack.Text.JsConfigScope CreateScope(string config, ServiceStack.Text.JsConfigScope scope = default(ServiceStack.Text.JsConfigScope)) => throw null;
            public static ServiceStack.Text.DateHandler DateHandler { get => throw null; set { } }
            public static string DateTimeFormat { get => throw null; set { } }
            public static bool EmitCamelCaseNames { get => throw null; set { } }
            public static bool EmitLowercaseUnderscoreNames { get => throw null; set { } }
            public static bool EscapeHtmlChars { get => throw null; set { } }
            public static bool EscapeUnicode { get => throw null; set { } }
            public static bool ExcludeDefaultValues { get => throw null; set { } }
            public static string[] ExcludePropertyReferences { get => throw null; set { } }
            public static bool ExcludeTypeInfo { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<string> ExcludeTypeNames { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<System.Type> ExcludeTypes { get => throw null; set { } }
            public static ServiceStack.Text.Config GetConfig() => throw null;
            public static bool HasInit { get => throw null; }
            public static string[] IgnoreAttributesNamed { get => throw null; set { } }
            public static bool IncludeDefaultEnums { get => throw null; set { } }
            public static bool IncludeNullValues { get => throw null; set { } }
            public static bool IncludeNullValuesInDictionaries { get => throw null; set { } }
            public static bool IncludePublicFields { get => throw null; set { } }
            public static bool IncludeTypeInfo { get => throw null; set { } }
            public static bool Indent { get => throw null; set { } }
            public static void Init() => throw null;
            public static void Init(ServiceStack.Text.Config config) => throw null;
            public static void InitStatics() => throw null;
            public static int MaxDepth { get => throw null; set { } }
            public static ServiceStack.EmptyCtorFactoryDelegate ModelFactory { get => throw null; set { } }
            public static ServiceStack.Text.Common.DeserializationErrorDelegate OnDeserializationError { get => throw null; set { } }
            public static ServiceStack.Text.ParseAsType ParsePrimitiveFloatingPointTypes { get => throw null; set { } }
            public static System.Func<string, object> ParsePrimitiveFn { get => throw null; set { } }
            public static ServiceStack.Text.ParseAsType ParsePrimitiveIntegerTypes { get => throw null; set { } }
            public static bool PreferInterfaces { get => throw null; set { } }
            public static ServiceStack.Text.PropertyConvention PropertyConvention { get => throw null; set { } }
            public static void Reset() => throw null;
            public static bool ShouldExcludePropertyType(System.Type propType) => throw null;
            public static bool SkipDateTimeConversion { get => throw null; set { } }
            public static ServiceStack.Text.TextCase TextCase { get => throw null; set { } }
            public static bool ThrowOnDeserializationError { get => throw null; set { } }
            public static bool ThrowOnError { get => throw null; set { } }
            public static ServiceStack.Text.TimeSpanHandler TimeSpanHandler { get => throw null; set { } }
            public static bool TreatEnumAsInteger { get => throw null; set { } }
            public static System.Collections.Generic.HashSet<System.Type> TreatValueAsRefTypes;
            public static bool TryParseIntoBestFit { get => throw null; set { } }
            public static bool TryToParseNumericType { get => throw null; set { } }
            public static bool TryToParsePrimitiveTypeValues { get => throw null; set { } }
            public static string TypeAttr { get => throw null; set { } }
            public static System.Func<string, System.Type> TypeFinder { get => throw null; set { } }
            public static System.Func<System.Type, string> TypeWriter { get => throw null; set { } }
            public static System.Text.UTF8Encoding UTF8Encoding { get => throw null; set { } }
            public static ServiceStack.Text.JsConfigScope With(ServiceStack.Text.Config config) => throw null;
            public static ServiceStack.Text.JsConfigScope With(bool? convertObjectTypesIntoStringDictionary = default(bool?), bool? tryToParsePrimitiveTypeValues = default(bool?), bool? tryToParseNumericType = default(bool?), ServiceStack.Text.ParseAsType? parsePrimitiveFloatingPointTypes = default(ServiceStack.Text.ParseAsType?), ServiceStack.Text.ParseAsType? parsePrimitiveIntegerTypes = default(ServiceStack.Text.ParseAsType?), bool? excludeDefaultValues = default(bool?), bool? includeNullValues = default(bool?), bool? includeNullValuesInDictionaries = default(bool?), bool? includeDefaultEnums = default(bool?), bool? excludeTypeInfo = default(bool?), bool? includeTypeInfo = default(bool?), bool? emitCamelCaseNames = default(bool?), bool? emitLowercaseUnderscoreNames = default(bool?), ServiceStack.Text.DateHandler? dateHandler = default(ServiceStack.Text.DateHandler?), ServiceStack.Text.TimeSpanHandler? timeSpanHandler = default(ServiceStack.Text.TimeSpanHandler?), ServiceStack.Text.PropertyConvention? propertyConvention = default(ServiceStack.Text.PropertyConvention?), bool? preferInterfaces = default(bool?), bool? throwOnDeserializationError = default(bool?), string typeAttr = default(string), string dateTimeFormat = default(string), System.Func<System.Type, string> typeWriter = default(System.Func<System.Type, string>), System.Func<string, System.Type> typeFinder = default(System.Func<string, System.Type>), bool? treatEnumAsInteger = default(bool?), bool? skipDateTimeConversion = default(bool?), bool? alwaysUseUtc = default(bool?), bool? assumeUtc = default(bool?), bool? appendUtcOffset = default(bool?), bool? escapeUnicode = default(bool?), bool? includePublicFields = default(bool?), int? maxDepth = default(int?), ServiceStack.EmptyCtorFactoryDelegate modelFactory = default(ServiceStack.EmptyCtorFactoryDelegate), string[] excludePropertyReferences = default(string[]), bool? useSystemParseMethods = default(bool?)) => throw null;
        }
        public class JsConfig<T>
        {
            public JsConfig() => throw null;
            public static System.Func<string, T> DeSerializeFn { get => throw null; set { } }
            public static bool? EmitCamelCaseNames { get => throw null; set { } }
            public static bool? EmitLowercaseUnderscoreNames { get => throw null; set { } }
            public static string[] ExcludePropertyNames;
            public static bool? ExcludeTypeInfo;
            public static bool HasDeserializeFn { get => throw null; }
            public static bool HasDeserializingFn { get => throw null; }
            public static bool HasSerializeFn { get => throw null; }
            public static bool IncludeDefaultValue { get => throw null; set { } }
            public static bool? IncludeTypeInfo;
            public static System.Func<T, T> OnDeserializedFn { get => throw null; set { } }
            public static System.Func<T, string, object, object> OnDeserializingFn { get => throw null; set { } }
            public static System.Action<T> OnSerializedFn { get => throw null; set { } }
            public static System.Func<T, T> OnSerializingFn { get => throw null; set { } }
            public static object ParseFn(string str) => throw null;
            public static System.Func<string, T> RawDeserializeFn { get => throw null; set { } }
            public static System.Func<T, string> RawSerializeFn { get => throw null; set { } }
            public static void RefreshRead() => throw null;
            public static void RefreshWrite() => throw null;
            public static void Reset() => throw null;
            public static System.Func<T, string> SerializeFn { get => throw null; set { } }
            public static ServiceStack.Text.TextCase TextCase { get => throw null; set { } }
            public static bool TreatValueAsRefType { get => throw null; set { } }
            public static void WriteFn<TSerializer>(System.IO.TextWriter writer, object obj) => throw null;
        }
        public sealed class JsConfigScope : ServiceStack.Text.Config, System.IDisposable
        {
            public void Dispose() => throw null;
        }
        namespace Json
        {
            public class JsonlReader
            {
                public JsonlReader() => throw null;
                public static System.Collections.Generic.IEnumerable<string> ParseLines(string jsonl) => throw null;
            }
            public class JsonlReader<T>
            {
                public JsonlReader() => throw null;
                public static System.Collections.Generic.List<T> GetRows(System.Collections.Generic.IEnumerable<string> rows) => throw null;
                public static System.Collections.Generic.List<T> Read(System.Collections.Generic.IEnumerable<string> rows) => throw null;
                public static object ReadObject(string csv) => throw null;
                public static object ReadObjectRow(string csv) => throw null;
                public static T ReadRow(string value) => throw null;
                public static System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> ReadStringDictionary(System.Collections.Generic.IEnumerable<string> rows) => throw null;
            }
            public class JsonlSerializer
            {
                public JsonlSerializer() => throw null;
                public static T DeserializeFromReader<T>(System.IO.TextReader reader) => throw null;
                public static T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
                public static object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
                public static T DeserializeFromString<T>(string text) => throw null;
                public static object DeserializeFromString(System.Type type, string text) => throw null;
                public static System.Action<object> OnSerialize { get => throw null; set { } }
                public static object ReadLateBoundObject(System.Type type, string value) => throw null;
                public static void SerializeToStream<T>(T value, System.IO.Stream stream) => throw null;
                public static void SerializeToStream(object obj, System.IO.Stream stream) => throw null;
                public static string SerializeToString<T>(T value) => throw null;
                public static void SerializeToWriter<T>(T value, System.IO.TextWriter writer) => throw null;
                public static System.Text.Encoding UseEncoding { get => throw null; set { } }
                public static void WriteLateBoundObject(System.IO.TextWriter writer, object value) => throw null;
            }
            public static class JsonlSerializer<T>
            {
                public static object ReadEnumerableProperty(string row) => throw null;
                public static object ReadEnumerableType(string value) => throw null;
                public static ServiceStack.Text.Common.ParseStringDelegate ReadFn() => throw null;
                public static object ReadNonEnumerableType(string row) => throw null;
                public static object ReadObject(string value) => throw null;
                public static object ReadSelf(string value) => throw null;
                public static void Write(System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<System.Collections.Generic.List<string>> rows) => throw null;
                public static void WriteEnumerableProperty(System.IO.TextWriter writer, object obj) => throw null;
                public static void WriteEnumerableType(System.IO.TextWriter writer, object obj) => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate WriteFn() => throw null;
                public static void WriteNonEnumerableType(System.IO.TextWriter writer, object obj) => throw null;
                public static void WriteObject(System.IO.TextWriter writer, object value) => throw null;
                public static void WriteRow(System.IO.TextWriter writer, object row) => throw null;
                public static void WriteSelf(System.IO.TextWriter writer, object obj) => throw null;
            }
            public class JsonlWriter
            {
                public JsonlWriter() => throw null;
            }
            public class JsonlWriter<T>
            {
                public JsonlWriter() => throw null;
                public static void WriteObject(System.IO.TextWriter writer, object records) => throw null;
                public static void WriteObjectRow(System.IO.TextWriter writer, object record) => throw null;
            }
            public static class JsonReader
            {
                public static void InitAot<T>() => throw null;
                public static readonly ServiceStack.Text.Common.JsReader<ServiceStack.Text.Json.JsonTypeSerializer> Instance;
            }
            public struct JsonTypeSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static string ConvertFromUtf32(int utf32) => throw null;
                public bool EatItemSeperatorOrMapEndChar(string value, ref int i) => throw null;
                public bool EatItemSeperatorOrMapEndChar(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public string EatMapKey(string value, ref int i) => throw null;
                public System.ReadOnlySpan<char> EatMapKey(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public bool EatMapKeySeperator(string value, ref int i) => throw null;
                public bool EatMapKeySeperator(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public bool EatMapStartChar(string value, ref int i) => throw null;
                public bool EatMapStartChar(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public string EatTypeValue(string value, ref int i) => throw null;
                public System.ReadOnlySpan<char> EatTypeValue(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public string EatValue(string value, ref int i) => throw null;
                public System.ReadOnlySpan<char> EatValue(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public void EatWhitespace(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public void EatWhitespace(string value, ref int i) => throw null;
                public ServiceStack.Text.Common.ParseStringDelegate GetParseFn<T>() => throw null;
                public ServiceStack.Text.Common.ParseStringDelegate GetParseFn(System.Type type) => throw null;
                public ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn<T>() => throw null;
                public ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn(System.Type type) => throw null;
                public ServiceStack.Text.Json.TypeInfo GetTypeInfo(System.Type type) => throw null;
                public ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn<T>() => throw null;
                public ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn(System.Type type) => throw null;
                public bool IncludeNullValues { get => throw null; }
                public bool IncludeNullValuesInDictionaries { get => throw null; }
                public static ServiceStack.Text.Common.ITypeSerializer Instance;
                public static bool IsEmptyMap(System.ReadOnlySpan<char> value, int i = default(int)) => throw null;
                public ServiceStack.Text.Common.ObjectDeserializerDelegate ObjectDeserializer { get => throw null; set { } }
                public string ParseRawString(string value) => throw null;
                public string ParseString(System.ReadOnlySpan<char> value) => throw null;
                public string ParseString(string value) => throw null;
                public string TypeAttrInObject { get => throw null; }
                public static string Unescape(string input) => throw null;
                public static string Unescape(string input, bool removeQuotes) => throw null;
                public static System.ReadOnlySpan<char> Unescape(System.ReadOnlySpan<char> input) => throw null;
                public static System.ReadOnlySpan<char> Unescape(System.ReadOnlySpan<char> input, bool removeQuotes) => throw null;
                public static System.ReadOnlySpan<char> Unescape(System.ReadOnlySpan<char> input, bool removeQuotes, char quoteChar) => throw null;
                public static System.ReadOnlySpan<char> UnescapeJsString(System.ReadOnlySpan<char> json, char quoteChar) => throw null;
                public static ServiceStack.Text.Json.SpanIndex UnescapeJsString(System.ReadOnlySpan<char> json, char quoteChar, bool removeQuotes, int index) => throw null;
                public string UnescapeSafeString(string value) => throw null;
                public System.ReadOnlySpan<char> UnescapeSafeString(System.ReadOnlySpan<char> value) => throw null;
                public string UnescapeString(string value) => throw null;
                public System.ReadOnlySpan<char> UnescapeString(System.ReadOnlySpan<char> value) => throw null;
                public object UnescapeStringAsObject(System.ReadOnlySpan<char> value) => throw null;
                public void WriteBool(System.IO.TextWriter writer, object boolValue) => throw null;
                public void WriteBuiltIn(System.IO.TextWriter writer, object value) => throw null;
                public void WriteByte(System.IO.TextWriter writer, object byteValue) => throw null;
                public void WriteBytes(System.IO.TextWriter writer, object oByteValue) => throw null;
                public void WriteChar(System.IO.TextWriter writer, object charValue) => throw null;
                public void WriteDateOnly(System.IO.TextWriter writer, object oDateOnly) => throw null;
                public void WriteDateTime(System.IO.TextWriter writer, object oDateTime) => throw null;
                public void WriteDateTimeOffset(System.IO.TextWriter writer, object oDateTimeOffset) => throw null;
                public void WriteDecimal(System.IO.TextWriter writer, object decimalValue) => throw null;
                public void WriteDouble(System.IO.TextWriter writer, object doubleValue) => throw null;
                public void WriteEnum(System.IO.TextWriter writer, object enumValue) => throw null;
                public void WriteException(System.IO.TextWriter writer, object value) => throw null;
                public void WriteFloat(System.IO.TextWriter writer, object floatValue) => throw null;
                public void WriteFormattableObjectString(System.IO.TextWriter writer, object value) => throw null;
                public void WriteGuid(System.IO.TextWriter writer, object oValue) => throw null;
                public void WriteInt16(System.IO.TextWriter writer, object intValue) => throw null;
                public void WriteInt32(System.IO.TextWriter writer, object intValue) => throw null;
                public void WriteInt64(System.IO.TextWriter writer, object integerValue) => throw null;
                public void WriteNullableDateOnly(System.IO.TextWriter writer, object oDateOnly) => throw null;
                public void WriteNullableDateTime(System.IO.TextWriter writer, object dateTime) => throw null;
                public void WriteNullableDateTimeOffset(System.IO.TextWriter writer, object dateTimeOffset) => throw null;
                public void WriteNullableGuid(System.IO.TextWriter writer, object oValue) => throw null;
                public void WriteNullableTimeOnly(System.IO.TextWriter writer, object oTimeOnly) => throw null;
                public void WriteNullableTimeSpan(System.IO.TextWriter writer, object oTimeSpan) => throw null;
                public void WriteObjectString(System.IO.TextWriter writer, object value) => throw null;
                public void WritePropertyName(System.IO.TextWriter writer, string value) => throw null;
                public void WriteRawString(System.IO.TextWriter writer, string value) => throw null;
                public void WriteSByte(System.IO.TextWriter writer, object sbyteValue) => throw null;
                public void WriteString(System.IO.TextWriter writer, string value) => throw null;
                public void WriteTimeOnly(System.IO.TextWriter writer, object oTimeOnly) => throw null;
                public void WriteTimeSpan(System.IO.TextWriter writer, object oTimeSpan) => throw null;
                public void WriteUInt16(System.IO.TextWriter writer, object intValue) => throw null;
                public void WriteUInt32(System.IO.TextWriter writer, object uintValue) => throw null;
                public void WriteUInt64(System.IO.TextWriter writer, object ulongValue) => throw null;
            }
            public static class JsonUtils
            {
                public const char BackspaceChar = default;
                public const char CarriageReturnChar = default;
                public const char EscapeChar = default;
                public const string False = default;
                public const char FormFeedChar = default;
                public static void IntToHex(int intValue, char[] hex) => throw null;
                public static bool IsJsArray(string value) => throw null;
                public static bool IsJsArray(System.ReadOnlySpan<char> value) => throw null;
                public static bool IsJsObject(string value) => throw null;
                public static bool IsJsObject(System.ReadOnlySpan<char> value) => throw null;
                public static bool IsWhiteSpace(char c) => throw null;
                public const char LineFeedChar = default;
                public const long MaxInteger = 9007199254740992;
                public const long MinInteger = -9007199254740992;
                public const string Null = default;
                public const char QuoteChar = default;
                public const char SpaceChar = default;
                public const char TabChar = default;
                public const string True = default;
                public static readonly char[] WhiteSpaceChars;
                public static void WriteString(System.IO.TextWriter writer, string value) => throw null;
            }
            public static class JsonWriter
            {
                public static void InitAot<T>() => throw null;
                public static readonly ServiceStack.Text.Common.JsWriter<ServiceStack.Text.Json.JsonTypeSerializer> Instance;
            }
            public static class JsonWriter<T>
            {
                public static ServiceStack.Text.Common.WriteObjectDelegate GetRootObjectWriteFn(object value) => throw null;
                public static ServiceStack.Text.Json.TypeInfo GetTypeInfo() => throw null;
                public static void Refresh() => throw null;
                public static void Reset() => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate WriteFn() => throw null;
                public static void WriteObject(System.IO.TextWriter writer, object value) => throw null;
                public static void WriteRootObject(System.IO.TextWriter writer, object value) => throw null;
            }
            public struct SpanIndex
            {
                public SpanIndex(System.ReadOnlySpan<char> value, int index) => throw null;
                public int Index { get => throw null; }
                public System.ReadOnlySpan<char> Span { get => throw null; }
            }
            public class TypeInfo
            {
                public TypeInfo() => throw null;
            }
        }
        public class JsonArrayObjects : System.Collections.Generic.List<ServiceStack.Text.JsonObject>
        {
            public JsonArrayObjects() => throw null;
            public static ServiceStack.Text.JsonArrayObjects Parse(string json) => throw null;
        }
        public static partial class JsonExtensions
        {
            public static ServiceStack.Text.JsonArrayObjects ArrayObjects(this string json) => throw null;
            public static System.Collections.Generic.List<T> ConvertAll<T>(this ServiceStack.Text.JsonArrayObjects jsonArrayObjects, System.Func<ServiceStack.Text.JsonObject, T> converter) => throw null;
            public static T ConvertTo<T>(this ServiceStack.Text.JsonObject jsonObject, System.Func<ServiceStack.Text.JsonObject, T> convertFn) => throw null;
            public static T Get<T>(this System.Collections.Generic.Dictionary<string, string> map, string key, T defaultValue = default(T)) => throw null;
            public static string Get(this System.Collections.Generic.Dictionary<string, string> map, string key) => throw null;
            public static T[] GetArray<T>(this System.Collections.Generic.Dictionary<string, string> map, string key) => throw null;
            public static T JsonTo<T>(this System.Collections.Generic.Dictionary<string, string> map, string key) => throw null;
            public static System.Collections.Generic.Dictionary<string, string> ToDictionary(this ServiceStack.Text.JsonObject jsonObject) => throw null;
        }
        public class JsonObject : System.Collections.Generic.Dictionary<string, string>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.IEnumerable
        {
            public ServiceStack.Text.JsonArrayObjects ArrayObjects(string propertyName) => throw null;
            public string Child(string key) => throw null;
            public T ConvertTo<T>() => throw null;
            public object ConvertTo(System.Type type) => throw null;
            public JsonObject() => throw null;
            public System.Collections.Generic.Dictionary<string, string>.Enumerator GetEnumerator() => throw null;
            System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, string>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>.GetEnumerator() => throw null;
            public string GetUnescaped(string key) => throw null;
            public ServiceStack.Text.JsonObject Object(string propertyName) => throw null;
            public static ServiceStack.Text.JsonObject Parse(string json) => throw null;
            public static ServiceStack.Text.JsonArrayObjects ParseArray(string json) => throw null;
            public string this[string key] { get => throw null; set { } }
            public System.Collections.Generic.Dictionary<string, string> ToUnescapedDictionary() => throw null;
            public static void WriteValue(System.IO.TextWriter writer, object value) => throw null;
        }
        public static class JsonSerializer
        {
            public static int BufferSize;
            public static T DeserializeFromReader<T>(System.IO.TextReader reader) => throw null;
            public static object DeserializeFromReader(System.IO.TextReader reader, System.Type type) => throw null;
            public static T DeserializeFromSpan<T>(System.ReadOnlySpan<char> value) => throw null;
            public static object DeserializeFromSpan(System.Type type, System.ReadOnlySpan<char> value) => throw null;
            public static T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public static object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public static System.Threading.Tasks.Task<object> DeserializeFromStreamAsync(System.Type type, System.IO.Stream stream) => throw null;
            public static System.Threading.Tasks.Task<T> DeserializeFromStreamAsync<T>(System.IO.Stream stream) => throw null;
            public static T DeserializeFromString<T>(string value) => throw null;
            public static object DeserializeFromString(string value, System.Type type) => throw null;
            public static T DeserializeRequest<T>(System.Net.WebRequest webRequest) => throw null;
            public static object DeserializeRequest(System.Type type, System.Net.WebRequest webRequest) => throw null;
            public static T DeserializeResponse<T>(System.Net.WebRequest webRequest) => throw null;
            public static object DeserializeResponse<T>(System.Type type, System.Net.WebRequest webRequest) => throw null;
            public static T DeserializeResponse<T>(System.Net.WebResponse webResponse) => throw null;
            public static object DeserializeResponse(System.Type type, System.Net.WebResponse webResponse) => throw null;
            public static System.Action<object> OnSerialize { get => throw null; set { } }
            public static void SerializeToStream<T>(T value, System.IO.Stream stream) => throw null;
            public static void SerializeToStream(object value, System.Type type, System.IO.Stream stream) => throw null;
            public static string SerializeToString<T>(T value) => throw null;
            public static string SerializeToString(object value, System.Type type) => throw null;
            public static void SerializeToWriter<T>(T value, System.IO.TextWriter writer) => throw null;
            public static void SerializeToWriter(object value, System.Type type, System.IO.TextWriter writer) => throw null;
            public static System.Text.UTF8Encoding UTF8Encoding { get => throw null; set { } }
        }
        public class JsonSerializer<T> : ServiceStack.Text.ITypeSerializer<T>
        {
            public bool CanCreateFromString(System.Type type) => throw null;
            public JsonSerializer() => throw null;
            public T DeserializeFromReader(System.IO.TextReader reader) => throw null;
            public T DeserializeFromString(string value) => throw null;
            public string SerializeToString(T value) => throw null;
            public void SerializeToWriter(T value, System.IO.TextWriter writer) => throw null;
        }
        public class JsonStringSerializer : ServiceStack.Text.IStringSerializer
        {
            public JsonStringSerializer() => throw null;
            public To DeserializeFromString<To>(string serializedText) => throw null;
            public object DeserializeFromString(string serializedText, System.Type type) => throw null;
            public string SerializeToString<TFrom>(TFrom from) => throw null;
        }
        public struct JsonValue : ServiceStack.Text.IValueWriter
        {
            public T As<T>() => throw null;
            public JsonValue(string json) => throw null;
            public override string ToString() => throw null;
            public void WriteTo(ServiceStack.Text.Common.ITypeSerializer serializer, System.IO.TextWriter writer) => throw null;
        }
        namespace Jsv
        {
            public static class JsvReader
            {
                public static ServiceStack.Text.Common.ParseStringDelegate GetParseFn(System.Type type) => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseSpanFn(System.Type type) => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn(System.Type type) => throw null;
                public static void InitAot<T>() => throw null;
            }
            public struct JsvTypeSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public bool EatItemSeperatorOrMapEndChar(string value, ref int i) => throw null;
                public bool EatItemSeperatorOrMapEndChar(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public string EatMapKey(string value, ref int i) => throw null;
                public System.ReadOnlySpan<char> EatMapKey(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public bool EatMapKeySeperator(string value, ref int i) => throw null;
                public bool EatMapKeySeperator(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public bool EatMapStartChar(string value, ref int i) => throw null;
                public bool EatMapStartChar(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public string EatTypeValue(string value, ref int i) => throw null;
                public System.ReadOnlySpan<char> EatTypeValue(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public string EatValue(string value, ref int i) => throw null;
                public System.ReadOnlySpan<char> EatValue(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public void EatWhitespace(string value, ref int i) => throw null;
                public void EatWhitespace(System.ReadOnlySpan<char> value, ref int i) => throw null;
                public ServiceStack.Text.Common.ParseStringDelegate GetParseFn<T>() => throw null;
                public ServiceStack.Text.Common.ParseStringDelegate GetParseFn(System.Type type) => throw null;
                public ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn<T>() => throw null;
                public ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn(System.Type type) => throw null;
                public ServiceStack.Text.Json.TypeInfo GetTypeInfo(System.Type type) => throw null;
                public ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn<T>() => throw null;
                public ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn(System.Type type) => throw null;
                public bool IncludeNullValues { get => throw null; }
                public bool IncludeNullValuesInDictionaries { get => throw null; }
                public static ServiceStack.Text.Common.ITypeSerializer Instance;
                public ServiceStack.Text.Common.ObjectDeserializerDelegate ObjectDeserializer { get => throw null; set { } }
                public string ParseRawString(string value) => throw null;
                public string ParseString(string value) => throw null;
                public string ParseString(System.ReadOnlySpan<char> value) => throw null;
                public string TypeAttrInObject { get => throw null; }
                public string UnescapeSafeString(string value) => throw null;
                public System.ReadOnlySpan<char> UnescapeSafeString(System.ReadOnlySpan<char> value) => throw null;
                public string UnescapeString(string value) => throw null;
                public System.ReadOnlySpan<char> UnescapeString(System.ReadOnlySpan<char> value) => throw null;
                public object UnescapeStringAsObject(System.ReadOnlySpan<char> value) => throw null;
                public void WriteBool(System.IO.TextWriter writer, object boolValue) => throw null;
                public void WriteBuiltIn(System.IO.TextWriter writer, object value) => throw null;
                public void WriteByte(System.IO.TextWriter writer, object byteValue) => throw null;
                public void WriteBytes(System.IO.TextWriter writer, object oByteValue) => throw null;
                public void WriteChar(System.IO.TextWriter writer, object charValue) => throw null;
                public void WriteDateOnly(System.IO.TextWriter writer, object oDateOnly) => throw null;
                public void WriteDateTime(System.IO.TextWriter writer, object oDateTime) => throw null;
                public void WriteDateTimeOffset(System.IO.TextWriter writer, object oDateTimeOffset) => throw null;
                public void WriteDecimal(System.IO.TextWriter writer, object decimalValue) => throw null;
                public void WriteDouble(System.IO.TextWriter writer, object doubleValue) => throw null;
                public void WriteEnum(System.IO.TextWriter writer, object enumValue) => throw null;
                public void WriteException(System.IO.TextWriter writer, object value) => throw null;
                public void WriteFloat(System.IO.TextWriter writer, object floatValue) => throw null;
                public void WriteFormattableObjectString(System.IO.TextWriter writer, object value) => throw null;
                public void WriteGuid(System.IO.TextWriter writer, object oValue) => throw null;
                public void WriteInt16(System.IO.TextWriter writer, object intValue) => throw null;
                public void WriteInt32(System.IO.TextWriter writer, object intValue) => throw null;
                public void WriteInt64(System.IO.TextWriter writer, object longValue) => throw null;
                public void WriteNullableDateOnly(System.IO.TextWriter writer, object oDateOnly) => throw null;
                public void WriteNullableDateTime(System.IO.TextWriter writer, object dateTime) => throw null;
                public void WriteNullableDateTimeOffset(System.IO.TextWriter writer, object dateTimeOffset) => throw null;
                public void WriteNullableGuid(System.IO.TextWriter writer, object oValue) => throw null;
                public void WriteNullableTimeOnly(System.IO.TextWriter writer, object oTimeOnly) => throw null;
                public void WriteNullableTimeSpan(System.IO.TextWriter writer, object oTimeSpan) => throw null;
                public void WriteObjectString(System.IO.TextWriter writer, object value) => throw null;
                public void WritePropertyName(System.IO.TextWriter writer, string value) => throw null;
                public void WriteRawString(System.IO.TextWriter writer, string value) => throw null;
                public void WriteSByte(System.IO.TextWriter writer, object sbyteValue) => throw null;
                public void WriteString(System.IO.TextWriter writer, string value) => throw null;
                public void WriteTimeOnly(System.IO.TextWriter writer, object oTimeOnly) => throw null;
                public void WriteTimeSpan(System.IO.TextWriter writer, object oTimeSpan) => throw null;
                public void WriteUInt16(System.IO.TextWriter writer, object intValue) => throw null;
                public void WriteUInt32(System.IO.TextWriter writer, object uintValue) => throw null;
                public void WriteUInt64(System.IO.TextWriter writer, object ulongValue) => throw null;
            }
            public static class JsvWriter
            {
                public static ServiceStack.Text.Common.WriteObjectDelegate GetValueTypeToStringMethod(System.Type type) => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn(System.Type type) => throw null;
                public static void InitAot<T>() => throw null;
                public static readonly ServiceStack.Text.Common.JsWriter<ServiceStack.Text.Jsv.JsvTypeSerializer> Instance;
                public static void WriteLateBoundObject(System.IO.TextWriter writer, object value) => throw null;
            }
            public static class JsvWriter<T>
            {
                public static void Refresh() => throw null;
                public static void Reset() => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate WriteFn() => throw null;
                public static void WriteObject(System.IO.TextWriter writer, object value) => throw null;
                public static void WriteRootObject(System.IO.TextWriter writer, object value) => throw null;
            }
        }
        public static class JsvFormatter
        {
            public static string Format(string serializedText) => throw null;
        }
        public class JsvStringSerializer : ServiceStack.Text.IStringSerializer
        {
            public JsvStringSerializer() => throw null;
            public To DeserializeFromString<To>(string serializedText) => throw null;
            public object DeserializeFromString(string serializedText, System.Type type) => throw null;
            public string SerializeToString<TFrom>(TFrom from) => throw null;
        }
        public abstract class MemoryProvider
        {
            public abstract System.Text.StringBuilder Append(System.Text.StringBuilder sb, System.ReadOnlySpan<char> value);
            protected MemoryProvider() => throw null;
            public abstract object Deserialize(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer);
            public abstract System.Threading.Tasks.Task<object> DeserializeAsync(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer);
            public abstract System.ReadOnlyMemory<char> FromUtf8(System.ReadOnlySpan<byte> source);
            public abstract int FromUtf8(System.ReadOnlySpan<byte> source, System.Span<char> destination);
            public abstract string FromUtf8Bytes(System.ReadOnlySpan<byte> source);
            public abstract int GetUtf8ByteCount(System.ReadOnlySpan<char> chars);
            public abstract int GetUtf8CharCount(System.ReadOnlySpan<byte> bytes);
            public static ServiceStack.Text.MemoryProvider Instance;
            public abstract byte[] ParseBase64(System.ReadOnlySpan<char> value);
            public abstract bool ParseBoolean(System.ReadOnlySpan<char> value);
            public abstract byte ParseByte(System.ReadOnlySpan<char> value);
            public abstract decimal ParseDecimal(System.ReadOnlySpan<char> value);
            public abstract decimal ParseDecimal(System.ReadOnlySpan<char> value, bool allowThousands);
            public abstract double ParseDouble(System.ReadOnlySpan<char> value);
            public abstract float ParseFloat(System.ReadOnlySpan<char> value);
            public abstract System.Guid ParseGuid(System.ReadOnlySpan<char> value);
            public abstract short ParseInt16(System.ReadOnlySpan<char> value);
            public abstract int ParseInt32(System.ReadOnlySpan<char> value);
            public abstract long ParseInt64(System.ReadOnlySpan<char> value);
            public abstract sbyte ParseSByte(System.ReadOnlySpan<char> value);
            public abstract ushort ParseUInt16(System.ReadOnlySpan<char> value);
            public abstract uint ParseUInt32(System.ReadOnlySpan<char> value);
            public abstract uint ParseUInt32(System.ReadOnlySpan<char> value, System.Globalization.NumberStyles style);
            public abstract ulong ParseUInt64(System.ReadOnlySpan<char> value);
            public abstract string ToBase64(System.ReadOnlyMemory<byte> value);
            public abstract System.IO.MemoryStream ToMemoryStream(System.ReadOnlySpan<byte> source);
            public abstract System.ReadOnlyMemory<byte> ToUtf8(System.ReadOnlySpan<char> source);
            public abstract int ToUtf8(System.ReadOnlySpan<char> source, System.Span<byte> destination);
            public abstract byte[] ToUtf8Bytes(System.ReadOnlySpan<char> source);
            public abstract bool TryParseBoolean(System.ReadOnlySpan<char> value, out bool result);
            public abstract bool TryParseDecimal(System.ReadOnlySpan<char> value, out decimal result);
            public abstract bool TryParseDouble(System.ReadOnlySpan<char> value, out double result);
            public abstract bool TryParseFloat(System.ReadOnlySpan<char> value, out float result);
            public abstract void Write(System.IO.Stream stream, System.ReadOnlyMemory<char> value);
            public abstract void Write(System.IO.Stream stream, System.ReadOnlyMemory<byte> value);
            public abstract System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            public abstract System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<byte> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            public abstract System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlySpan<char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            public abstract void WriteUtf8ToStream(string contents, System.IO.Stream stream);
        }
        public static class MemoryStreamFactory
        {
            public static System.IO.MemoryStream GetStream() => throw null;
            public static System.IO.MemoryStream GetStream(int capacity) => throw null;
            public static System.IO.MemoryStream GetStream(byte[] bytes) => throw null;
            public static System.IO.MemoryStream GetStream(byte[] bytes, int index, int count) => throw null;
            public static ServiceStack.Text.RecyclableMemoryStreamManager RecyclableInstance;
            public static bool UseRecyclableMemoryStream { get => throw null; set { } }
        }
        public class MurmurHash2
        {
            public MurmurHash2() => throw null;
            public static uint Hash(string data) => throw null;
            public static uint Hash(byte[] data) => throw null;
            public static uint Hash(byte[] data, uint seed) => throw null;
        }
        public sealed class NetCoreMemory : ServiceStack.Text.MemoryProvider
        {
            public override System.Text.StringBuilder Append(System.Text.StringBuilder sb, System.ReadOnlySpan<char> value) => throw null;
            public static void Configure() => throw null;
            public override object Deserialize(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer) => throw null;
            public override System.Threading.Tasks.Task<object> DeserializeAsync(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer) => throw null;
            public override System.ReadOnlyMemory<char> FromUtf8(System.ReadOnlySpan<byte> source) => throw null;
            public override int FromUtf8(System.ReadOnlySpan<byte> source, System.Span<char> destination) => throw null;
            public override string FromUtf8Bytes(System.ReadOnlySpan<byte> source) => throw null;
            public override int GetUtf8ByteCount(System.ReadOnlySpan<char> chars) => throw null;
            public override int GetUtf8CharCount(System.ReadOnlySpan<byte> bytes) => throw null;
            public override byte[] ParseBase64(System.ReadOnlySpan<char> value) => throw null;
            public override bool ParseBoolean(System.ReadOnlySpan<char> value) => throw null;
            public override byte ParseByte(System.ReadOnlySpan<char> value) => throw null;
            public override decimal ParseDecimal(System.ReadOnlySpan<char> value, bool allowThousands) => throw null;
            public override decimal ParseDecimal(System.ReadOnlySpan<char> value) => throw null;
            public override double ParseDouble(System.ReadOnlySpan<char> value) => throw null;
            public override float ParseFloat(System.ReadOnlySpan<char> value) => throw null;
            public override System.Guid ParseGuid(System.ReadOnlySpan<char> value) => throw null;
            public override short ParseInt16(System.ReadOnlySpan<char> value) => throw null;
            public override int ParseInt32(System.ReadOnlySpan<char> value) => throw null;
            public override long ParseInt64(System.ReadOnlySpan<char> value) => throw null;
            public override sbyte ParseSByte(System.ReadOnlySpan<char> value) => throw null;
            public override ushort ParseUInt16(System.ReadOnlySpan<char> value) => throw null;
            public override uint ParseUInt32(System.ReadOnlySpan<char> value) => throw null;
            public override uint ParseUInt32(System.ReadOnlySpan<char> value, System.Globalization.NumberStyles style) => throw null;
            public override ulong ParseUInt64(System.ReadOnlySpan<char> value) => throw null;
            public static ServiceStack.Text.NetCoreMemory Provider { get => throw null; }
            public override string ToBase64(System.ReadOnlyMemory<byte> value) => throw null;
            public override System.IO.MemoryStream ToMemoryStream(System.ReadOnlySpan<byte> source) => throw null;
            public override System.ReadOnlyMemory<byte> ToUtf8(System.ReadOnlySpan<char> source) => throw null;
            public override int ToUtf8(System.ReadOnlySpan<char> source, System.Span<byte> destination) => throw null;
            public override byte[] ToUtf8Bytes(System.ReadOnlySpan<char> source) => throw null;
            public override bool TryParseBoolean(System.ReadOnlySpan<char> value, out bool result) => throw null;
            public override bool TryParseDecimal(System.ReadOnlySpan<char> value, out decimal result) => throw null;
            public override bool TryParseDouble(System.ReadOnlySpan<char> value, out double result) => throw null;
            public override bool TryParseFloat(System.ReadOnlySpan<char> value, out float result) => throw null;
            public override void Write(System.IO.Stream stream, System.ReadOnlyMemory<char> value) => throw null;
            public override void Write(System.IO.Stream stream, System.ReadOnlyMemory<byte> value) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlySpan<char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<byte> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override void WriteUtf8ToStream(string contents, System.IO.Stream stream) => throw null;
        }
        [System.Flags]
        public enum ParseAsType
        {
            None = 0,
            Bool = 2,
            Byte = 4,
            SByte = 8,
            Int16 = 16,
            Int32 = 32,
            Int64 = 64,
            UInt16 = 128,
            UInt32 = 256,
            UInt64 = 512,
            Decimal = 1024,
            Double = 2048,
            Single = 4096,
        }
        namespace Pools
        {
            public sealed class BufferPool
            {
                public const int BUFFER_LENGTH = 1450;
                public static void Flush() => throw null;
                public static byte[] GetBuffer() => throw null;
                public static byte[] GetBuffer(int minSize) => throw null;
                public static byte[] GetCachedBuffer(int minSize) => throw null;
                public static void ReleaseBufferToPool(ref byte[] buffer) => throw null;
                public static void ResizeAndFlushLeft(ref byte[] buffer, int toFitAtLeastBytes, int copyFromIndex, int copyBytes) => throw null;
            }
            public sealed class CharPool
            {
                public const int BUFFER_LENGTH = 1450;
                public static void Flush() => throw null;
                public static char[] GetBuffer() => throw null;
                public static char[] GetBuffer(int minSize) => throw null;
                public static char[] GetCachedBuffer(int minSize) => throw null;
                public static void ReleaseBufferToPool(ref char[] buffer) => throw null;
                public static void ResizeAndFlushLeft(ref char[] buffer, int toFitAtLeastchars, int copyFromIndex, int copychars) => throw null;
            }
            public class ObjectPool<T> where T : class
            {
                public T Allocate() => throw null;
                public ObjectPool(ServiceStack.Text.Pools.ObjectPool<T>.Factory factory) => throw null;
                public ObjectPool(ServiceStack.Text.Pools.ObjectPool<T>.Factory factory, int size) => throw null;
                public delegate T Factory();
                public void ForgetTrackedObject(T old, T replacement = default(T)) => throw null;
                public void Free(T obj) => throw null;
            }
            public struct PooledObject<T> : System.IDisposable where T : class
            {
                public static ServiceStack.Text.Pools.PooledObject<System.Text.StringBuilder> Create(ServiceStack.Text.Pools.ObjectPool<System.Text.StringBuilder> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.Stack<TItem>> Create<TItem>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.Stack<TItem>> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.Queue<TItem>> Create<TItem>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.Queue<TItem>> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.HashSet<TItem>> Create<TItem>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.HashSet<TItem>> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.Dictionary<TKey, TValue>> Create<TKey, TValue>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.Dictionary<TKey, TValue>> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.List<TItem>> Create<TItem>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.List<TItem>> pool) => throw null;
                public PooledObject(ServiceStack.Text.Pools.ObjectPool<T> pool, System.Func<ServiceStack.Text.Pools.ObjectPool<T>, T> allocator, System.Action<ServiceStack.Text.Pools.ObjectPool<T>, T> releaser) => throw null;
                public void Dispose() => throw null;
                public T Object { get => throw null; }
            }
            public static class SharedPools
            {
                public static readonly ServiceStack.Text.Pools.ObjectPool<byte[]> AsyncByteArray;
                public static ServiceStack.Text.Pools.ObjectPool<T> BigDefault<T>() where T : class, new() => throw null;
                public static readonly ServiceStack.Text.Pools.ObjectPool<byte[]> ByteArray;
                public const int ByteBufferSize = 4096;
                public static ServiceStack.Text.Pools.ObjectPool<T> Default<T>() where T : class, new() => throw null;
                public static readonly ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.HashSet<string>> StringHashSet;
                public static ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.Dictionary<string, T>> StringIgnoreCaseDictionary<T>() => throw null;
                public static readonly ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.HashSet<string>> StringIgnoreCaseHashSet;
            }
            public static class StringBuilderPool
            {
                public static System.Text.StringBuilder Allocate() => throw null;
                public static void Free(System.Text.StringBuilder builder) => throw null;
                public static string ReturnAndFree(System.Text.StringBuilder builder) => throw null;
            }
        }
        public enum PropertyConvention
        {
            Strict = 0,
            Lenient = 1,
        }
        public sealed class RecyclableMemoryStream : System.IO.MemoryStream
        {
            public override bool CanRead { get => throw null; }
            public override bool CanSeek { get => throw null; }
            public override bool CanTimeout { get => throw null; }
            public override bool CanWrite { get => throw null; }
            public override int Capacity { get => throw null; set { } }
            public override void Close() => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, System.Guid id) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, string tag) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, System.Guid id, string tag) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, string tag, int requestedSize) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, System.Guid id, string tag, int requestedSize) => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public override byte[] GetBuffer() => throw null;
            public override long Length { get => throw null; }
            public override long Position { get => throw null; set { } }
            public override int Read(byte[] buffer, int offset, int count) => throw null;
            public override int Read(System.Span<byte> buffer) => throw null;
            public override int ReadByte() => throw null;
            public int SafeRead(byte[] buffer, int offset, int count, ref int streamPosition) => throw null;
            public int SafeRead(System.Span<byte> buffer, ref int streamPosition) => throw null;
            public int SafeReadByte(ref int streamPosition) => throw null;
            public override long Seek(long offset, System.IO.SeekOrigin loc) => throw null;
            public override void SetLength(long value) => throw null;
            public override byte[] ToArray() => throw null;
            public override string ToString() => throw null;
            public override bool TryGetBuffer(out System.ArraySegment<byte> buffer) => throw null;
            public override void Write(byte[] buffer, int offset, int count) => throw null;
            public override void Write(System.ReadOnlySpan<byte> source) => throw null;
            public override void WriteByte(byte value) => throw null;
            public override void WriteTo(System.IO.Stream stream) => throw null;
            public void WriteTo(System.IO.Stream stream, int offset, int count) => throw null;
        }
        public sealed class RecyclableMemoryStreamManager
        {
            public bool AggressiveBufferReturn { get => throw null; set { } }
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler BlockCreated;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler BlockDiscarded;
            public int BlockSize { get => throw null; }
            public RecyclableMemoryStreamManager() => throw null;
            public RecyclableMemoryStreamManager(int blockSize, int largeBufferMultiple, int maximumBufferSize) => throw null;
            public RecyclableMemoryStreamManager(int blockSize, int largeBufferMultiple, int maximumBufferSize, bool useExponentialLargeBuffer) => throw null;
            public const int DefaultBlockSize = 131072;
            public const int DefaultLargeBufferMultiple = 1048576;
            public const int DefaultMaximumBufferSize = 134217728;
            public delegate void EventHandler();
            public sealed class Events : System.Diagnostics.Tracing.EventSource
            {
                public Events() => throw null;
                public enum MemoryStreamBufferType
                {
                    Small = 0,
                    Large = 1,
                }
                public void MemoryStreamCreated(System.Guid guid, string tag, int requestedSize) => throw null;
                public void MemoryStreamDiscardBuffer(ServiceStack.Text.RecyclableMemoryStreamManager.Events.MemoryStreamBufferType bufferType, string tag, ServiceStack.Text.RecyclableMemoryStreamManager.Events.MemoryStreamDiscardReason reason) => throw null;
                public enum MemoryStreamDiscardReason
                {
                    TooLarge = 0,
                    EnoughFree = 1,
                }
                public void MemoryStreamDisposed(System.Guid guid, string tag) => throw null;
                public void MemoryStreamDoubleDispose(System.Guid guid, string tag, string allocationStack, string disposeStack1, string disposeStack2) => throw null;
                public void MemoryStreamFinalized(System.Guid guid, string tag, string allocationStack) => throw null;
                public void MemoryStreamManagerInitialized(int blockSize, int largeBufferMultiple, int maximumBufferSize) => throw null;
                public void MemoryStreamNewBlockCreated(long smallPoolInUseBytes) => throw null;
                public void MemoryStreamNewLargeBufferCreated(int requiredSize, long largePoolInUseBytes) => throw null;
                public void MemoryStreamNonPooledLargeBufferCreated(int requiredSize, string tag, string allocationStack) => throw null;
                public void MemoryStreamOverCapacity(int requestedCapacity, long maxCapacity, string tag, string allocationStack) => throw null;
                public void MemoryStreamToArray(System.Guid guid, string tag, string stack, int size) => throw null;
                public static ServiceStack.Text.RecyclableMemoryStreamManager.Events Writer;
            }
            public bool GenerateCallStacks { get => throw null; set { } }
            public System.IO.MemoryStream GetStream() => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id) => throw null;
            public System.IO.MemoryStream GetStream(string tag) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag) => throw null;
            public System.IO.MemoryStream GetStream(string tag, int requiredSize) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag, int requiredSize) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag, int requiredSize, bool asContiguousBuffer) => throw null;
            public System.IO.MemoryStream GetStream(string tag, int requiredSize, bool asContiguousBuffer) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag, byte[] buffer, int offset, int count) => throw null;
            public System.IO.MemoryStream GetStream(byte[] buffer) => throw null;
            public System.IO.MemoryStream GetStream(string tag, byte[] buffer, int offset, int count) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag, System.Memory<byte> buffer) => throw null;
            public System.IO.MemoryStream GetStream(System.Memory<byte> buffer) => throw null;
            public System.IO.MemoryStream GetStream(string tag, System.Memory<byte> buffer) => throw null;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler LargeBufferCreated;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.LargeBufferDiscardedEventHandler LargeBufferDiscarded;
            public delegate void LargeBufferDiscardedEventHandler(ServiceStack.Text.RecyclableMemoryStreamManager.Events.MemoryStreamDiscardReason reason);
            public int LargeBufferMultiple { get => throw null; }
            public long LargeBuffersFree { get => throw null; }
            public long LargePoolFreeSize { get => throw null; }
            public long LargePoolInUseSize { get => throw null; }
            public int MaximumBufferSize { get => throw null; }
            public long MaximumFreeLargePoolBytes { get => throw null; set { } }
            public long MaximumFreeSmallPoolBytes { get => throw null; set { } }
            public long MaximumStreamCapacity { get => throw null; set { } }
            public long SmallBlocksFree { get => throw null; }
            public long SmallPoolFreeSize { get => throw null; }
            public long SmallPoolInUseSize { get => throw null; }
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler StreamConvertedToArray;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler StreamCreated;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler StreamDisposed;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler StreamFinalized;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.StreamLengthReportHandler StreamLength;
            public delegate void StreamLengthReportHandler(long bytes);
            public bool ThrowExceptionOnToArray { get => throw null; set { } }
            public event ServiceStack.Text.RecyclableMemoryStreamManager.UsageReportEventHandler UsageReport;
            public delegate void UsageReportEventHandler(long smallPoolInUseBytes, long smallPoolFreeBytes, long largePoolInUseBytes, long largePoolFreeBytes);
            public bool UseExponentialLargeBuffer { get => throw null; }
            public bool UseMultipleLargeBuffer { get => throw null; }
        }
        public abstract class ReflectionOptimizer
        {
            public abstract ServiceStack.EmptyCtorDelegate CreateConstructor(System.Type type);
            public abstract ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.PropertyInfo propertyInfo);
            public abstract ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.PropertyInfo propertyInfo);
            public abstract ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.FieldInfo fieldInfo);
            public abstract ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.FieldInfo fieldInfo);
            public abstract ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.PropertyInfo propertyInfo);
            public abstract ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.PropertyInfo propertyInfo);
            public abstract ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.FieldInfo fieldInfo);
            public abstract ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.FieldInfo fieldInfo);
            public abstract ServiceStack.SetMemberRefDelegate<T> CreateSetterRef<T>(System.Reflection.FieldInfo fieldInfo);
            protected ReflectionOptimizer() => throw null;
            public static ServiceStack.Text.ReflectionOptimizer Instance;
            public abstract bool IsDynamic(System.Reflection.Assembly assembly);
            public abstract System.Type UseType(System.Type type);
        }
        public sealed class RuntimeReflectionOptimizer : ServiceStack.Text.ReflectionOptimizer
        {
            public override ServiceStack.EmptyCtorDelegate CreateConstructor(System.Type type) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberRefDelegate<T> CreateSetterRef<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override bool IsDynamic(System.Reflection.Assembly assembly) => throw null;
            public static ServiceStack.Text.RuntimeReflectionOptimizer Provider { get => throw null; }
            public override System.Type UseType(System.Type type) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public class RuntimeSerializableAttribute : System.Attribute
        {
            public RuntimeSerializableAttribute() => throw null;
        }
        public static class StringBuilderCache
        {
            public static System.Text.StringBuilder Allocate() => throw null;
            public static void Free(System.Text.StringBuilder sb) => throw null;
            public static string ReturnAndFree(System.Text.StringBuilder sb) => throw null;
        }
        public static class StringBuilderCacheAlt
        {
            public static System.Text.StringBuilder Allocate() => throw null;
            public static void Free(System.Text.StringBuilder sb) => throw null;
            public static string ReturnAndFree(System.Text.StringBuilder sb) => throw null;
        }
        public static partial class StringSpanExtensions
        {
            public static System.ReadOnlySpan<char> Advance(this System.ReadOnlySpan<char> text, int to) => throw null;
            public static System.ReadOnlySpan<char> AdvancePastChar(this System.ReadOnlySpan<char> literal, char delim) => throw null;
            public static System.ReadOnlySpan<char> AdvancePastWhitespace(this System.ReadOnlySpan<char> literal) => throw null;
            public static System.Text.StringBuilder Append(this System.Text.StringBuilder sb, System.ReadOnlySpan<char> value) => throw null;
            public static bool CompareIgnoreCase(this System.ReadOnlySpan<char> value, System.ReadOnlySpan<char> text) => throw null;
            public static int CountOccurrencesOf(this System.ReadOnlySpan<char> value, char needle) => throw null;
            public static int CountOccurrencesOf(this System.ReadOnlySpan<char> text, string needle, System.StringComparison comparisonType = default(System.StringComparison)) => throw null;
            public static bool EndsWith(this System.ReadOnlySpan<char> value, string other, System.StringComparison comparison) => throw null;
            public static bool EndsWith(this System.ReadOnlySpan<char> value, string other) => throw null;
            public static bool EndsWithIgnoreCase(this System.ReadOnlySpan<char> value, System.ReadOnlySpan<char> other) => throw null;
            public static bool EqualsIgnoreCase(this System.ReadOnlySpan<char> value, System.ReadOnlySpan<char> other) => throw null;
            public static bool EqualsOrdinal(this System.ReadOnlySpan<char> value, string other) => throw null;
            public static bool EqualTo(this System.ReadOnlySpan<char> value, string other) => throw null;
            public static bool EqualTo(this System.ReadOnlySpan<char> value, System.ReadOnlySpan<char> other) => throw null;
            public static System.ReadOnlySpan<char> FromCsvField(this System.ReadOnlySpan<char> text) => throw null;
            public static System.ReadOnlyMemory<char> FromUtf8(this System.ReadOnlySpan<byte> value) => throw null;
            public static string FromUtf8Bytes(this System.ReadOnlySpan<byte> value) => throw null;
            public static char GetChar(this System.ReadOnlySpan<char> value, int index) => throw null;
            public static System.ReadOnlySpan<char> GetExtension(this System.ReadOnlySpan<char> filePath) => throw null;
            public static int IndexOf(this System.ReadOnlySpan<char> value, string other) => throw null;
            public static int IndexOf(this System.ReadOnlySpan<char> value, string needle, int start, System.StringComparison comparisonType = default(System.StringComparison)) => throw null;
            public static bool IsNullOrEmpty(this System.ReadOnlySpan<char> value) => throw null;
            public static bool IsNullOrWhiteSpace(this System.ReadOnlySpan<char> value) => throw null;
            public static int LastIndexOf(this System.ReadOnlySpan<char> value, string other) => throw null;
            public static int LastIndexOf(this System.ReadOnlySpan<char> value, string needle, int start) => throw null;
            public static System.ReadOnlySpan<char> LastLeftPart(this System.ReadOnlySpan<char> strVal, char needle) => throw null;
            public static System.ReadOnlySpan<char> LastLeftPart(this System.ReadOnlySpan<char> strVal, string needle) => throw null;
            public static System.ReadOnlySpan<char> LastRightPart(this System.ReadOnlySpan<char> strVal, char needle) => throw null;
            public static System.ReadOnlySpan<char> LastRightPart(this System.ReadOnlySpan<char> strVal, string needle) => throw null;
            public static System.ReadOnlySpan<char> LeftPart(this System.ReadOnlySpan<char> strVal, char needle) => throw null;
            public static System.ReadOnlySpan<char> LeftPart(this System.ReadOnlySpan<char> strVal, string needle) => throw null;
            public static System.ReadOnlySpan<char> ParentDirectory(this System.ReadOnlySpan<char> filePath) => throw null;
            public static byte[] ParseBase64(this System.ReadOnlySpan<char> value) => throw null;
            public static bool ParseBoolean(this System.ReadOnlySpan<char> value) => throw null;
            public static byte ParseByte(this System.ReadOnlySpan<char> value) => throw null;
            public static decimal ParseDecimal(this System.ReadOnlySpan<char> value) => throw null;
            public static decimal ParseDecimal(this System.ReadOnlySpan<char> value, bool allowThousands) => throw null;
            public static double ParseDouble(this System.ReadOnlySpan<char> value) => throw null;
            public static float ParseFloat(this System.ReadOnlySpan<char> value) => throw null;
            public static System.Guid ParseGuid(this System.ReadOnlySpan<char> value) => throw null;
            public static short ParseInt16(this System.ReadOnlySpan<char> value) => throw null;
            public static int ParseInt32(this System.ReadOnlySpan<char> value) => throw null;
            public static long ParseInt64(this System.ReadOnlySpan<char> value) => throw null;
            public static sbyte ParseSByte(this System.ReadOnlySpan<char> value) => throw null;
            public static object ParseSignedInteger(this System.ReadOnlySpan<char> value) => throw null;
            public static ushort ParseUInt16(this System.ReadOnlySpan<char> value) => throw null;
            public static uint ParseUInt32(this System.ReadOnlySpan<char> value) => throw null;
            public static ulong ParseUInt64(this System.ReadOnlySpan<char> value) => throw null;
            public static System.ReadOnlySpan<char> RightPart(this System.ReadOnlySpan<char> strVal, char needle) => throw null;
            public static System.ReadOnlySpan<char> RightPart(this System.ReadOnlySpan<char> strVal, string needle) => throw null;
            public static System.ReadOnlySpan<char> SafeSlice(this System.ReadOnlySpan<char> value, int startIndex) => throw null;
            public static System.ReadOnlySpan<char> SafeSlice(this System.ReadOnlySpan<char> value, int startIndex, int length) => throw null;
            public static System.ReadOnlySpan<char> SafeSubstring(this System.ReadOnlySpan<char> value, int startIndex) => throw null;
            public static System.ReadOnlySpan<char> SafeSubstring(this System.ReadOnlySpan<char> value, int startIndex, int length) => throw null;
            public static void SplitOnFirst(this System.ReadOnlySpan<char> strVal, char needle, out System.ReadOnlySpan<char> first, out System.ReadOnlySpan<char> last) => throw null;
            public static void SplitOnFirst(this System.ReadOnlySpan<char> strVal, string needle, out System.ReadOnlySpan<char> first, out System.ReadOnlySpan<char> last) => throw null;
            public static void SplitOnLast(this System.ReadOnlySpan<char> strVal, char needle, out System.ReadOnlySpan<char> first, out System.ReadOnlySpan<char> last) => throw null;
            public static void SplitOnLast(this System.ReadOnlySpan<char> strVal, string needle, out System.ReadOnlySpan<char> first, out System.ReadOnlySpan<char> last) => throw null;
            public static bool StartsWith(this System.ReadOnlySpan<char> value, string other) => throw null;
            public static bool StartsWith(this System.ReadOnlySpan<char> value, string other, System.StringComparison comparison) => throw null;
            public static bool StartsWithIgnoreCase(this System.ReadOnlySpan<char> value, System.ReadOnlySpan<char> other) => throw null;
            public static System.ReadOnlySpan<char> Subsegment(this System.ReadOnlySpan<char> text, int startPos) => throw null;
            public static System.ReadOnlySpan<char> Subsegment(this System.ReadOnlySpan<char> text, int startPos, int length) => throw null;
            public static string Substring(this System.ReadOnlySpan<char> value, int pos) => throw null;
            public static string Substring(this System.ReadOnlySpan<char> value, int pos, int length) => throw null;
            public static string SubstringWithEllipsis(this System.ReadOnlySpan<char> value, int startIndex, int length) => throw null;
            public static System.Collections.Generic.List<string> ToStringList(this System.Collections.Generic.IEnumerable<System.ReadOnlyMemory<char>> from) => throw null;
            public static System.ReadOnlyMemory<byte> ToUtf8(this System.ReadOnlySpan<char> value) => throw null;
            public static byte[] ToUtf8Bytes(this System.ReadOnlySpan<char> value) => throw null;
            public static System.ReadOnlySpan<char> TrimEnd(this System.ReadOnlySpan<char> value, params char[] trimChars) => throw null;
            public static bool TryParseBoolean(this System.ReadOnlySpan<char> value, out bool result) => throw null;
            public static bool TryParseDecimal(this System.ReadOnlySpan<char> value, out decimal result) => throw null;
            public static bool TryParseDouble(this System.ReadOnlySpan<char> value, out double result) => throw null;
            public static bool TryParseFloat(this System.ReadOnlySpan<char> value, out float result) => throw null;
            public static bool TryReadLine(this System.ReadOnlySpan<char> text, out System.ReadOnlySpan<char> line, ref int startIndex) => throw null;
            public static bool TryReadPart(this System.ReadOnlySpan<char> text, string needle, out System.ReadOnlySpan<char> part, ref int startIndex) => throw null;
            public static string Value(this System.ReadOnlySpan<char> value) => throw null;
            public static System.ReadOnlySpan<char> WithoutBom(this System.ReadOnlySpan<char> value) => throw null;
            public static System.ReadOnlySpan<byte> WithoutBom(this System.ReadOnlySpan<byte> value) => throw null;
            public static System.ReadOnlySpan<char> WithoutExtension(this System.ReadOnlySpan<char> filePath) => throw null;
            public static System.Threading.Tasks.Task WriteAsync(this System.IO.Stream stream, System.ReadOnlySpan<char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }
        public static class StringWriterCache
        {
            public static System.IO.StringWriter Allocate() => throw null;
            public static void Free(System.IO.StringWriter writer) => throw null;
            public static string ReturnAndFree(System.IO.StringWriter writer) => throw null;
        }
        public static class StringWriterCacheAlt
        {
            public static System.IO.StringWriter Allocate() => throw null;
            public static void Free(System.IO.StringWriter writer) => throw null;
            public static string ReturnAndFree(System.IO.StringWriter writer) => throw null;
        }
        namespace Support
        {
            public class DoubleConverter
            {
                public DoubleConverter() => throw null;
                public static string ToExactString(double d) => throw null;
            }
            public class TimeSpanConverter
            {
                public TimeSpanConverter() => throw null;
                public static System.TimeSpan FromXsdDuration(string xsdDuration) => throw null;
                public static string ToXsdDuration(System.TimeSpan timeSpan) => throw null;
            }
            public class TypePair
            {
                public System.Type[] Arg2 { get => throw null; set { } }
                public System.Type[] Args1 { get => throw null; set { } }
                public TypePair(System.Type[] arg1, System.Type[] arg2) => throw null;
                public bool Equals(ServiceStack.Text.Support.TypePair other) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
            }
        }
        public static class SystemTime
        {
            public static System.DateTime Now { get => throw null; }
            public static System.Func<System.DateTime> UtcDateTimeResolver;
            public static System.DateTime UtcNow { get => throw null; }
        }
        public enum TextCase
        {
            Default = 0,
            PascalCase = 1,
            CamelCase = 2,
            SnakeCase = 3,
        }
        public class TextConfig
        {
            public static System.Func<System.Security.Cryptography.SHA1> CreateSha { get => throw null; set { } }
            public TextConfig() => throw null;
        }
        public enum TimeSpanHandler
        {
            DurationFormat = 0,
            StandardFormat = 1,
        }
        public class Tracer
        {
            public class ConsoleTracer : ServiceStack.Text.ITracer
            {
                public ConsoleTracer() => throw null;
                public void WriteDebug(string error) => throw null;
                public void WriteDebug(string format, params object[] args) => throw null;
                public void WriteError(System.Exception ex) => throw null;
                public void WriteError(string error) => throw null;
                public void WriteError(string format, params object[] args) => throw null;
                public void WriteWarning(string warning) => throw null;
                public void WriteWarning(string format, params object[] args) => throw null;
            }
            public Tracer() => throw null;
            public static ServiceStack.Text.ITracer Instance;
            public class NullTracer : ServiceStack.Text.ITracer
            {
                public NullTracer() => throw null;
                public void WriteDebug(string error) => throw null;
                public void WriteDebug(string format, params object[] args) => throw null;
                public void WriteError(System.Exception ex) => throw null;
                public void WriteError(string error) => throw null;
                public void WriteError(string format, params object[] args) => throw null;
                public void WriteWarning(string warning) => throw null;
                public void WriteWarning(string format, params object[] args) => throw null;
            }
        }
        public static class TracerExceptions
        {
            public static T Trace<T>(this T ex) where T : System.Exception => throw null;
        }
        public class TranslateListWithConvertibleElements<TFrom, TTo>
        {
            public TranslateListWithConvertibleElements() => throw null;
            public static object LateBoundTranslateToGenericICollection(object fromList, System.Type toInstanceOfType) => throw null;
            public static System.Collections.Generic.ICollection<TTo> TranslateToGenericICollection(System.Collections.Generic.ICollection<TFrom> fromList, System.Type toInstanceOfType) => throw null;
        }
        public static class TranslateListWithElements
        {
            public static object TranslateToConvertibleGenericICollectionCache(object from, System.Type toInstanceOfType, System.Type fromElementType) => throw null;
            public static object TranslateToGenericICollectionCache(object from, System.Type toInstanceOfType, System.Type elementType) => throw null;
            public static object TryTranslateCollections(System.Type fromPropertyType, System.Type toPropertyType, object fromValue) => throw null;
        }
        public class TranslateListWithElements<T>
        {
            public static object CreateInstance(System.Type toInstanceOfType) => throw null;
            public TranslateListWithElements() => throw null;
            public static object LateBoundTranslateToGenericICollection(object fromList, System.Type toInstanceOfType) => throw null;
            public static System.Collections.Generic.ICollection<T> TranslateToGenericICollection(System.Collections.IEnumerable fromList, System.Type toInstanceOfType) => throw null;
            public static System.Collections.IList TranslateToIList(System.Collections.IList fromList, System.Type toInstanceOfType) => throw null;
        }
        public static class TypeConfig<T>
        {
            public static bool EnableAnonymousFieldSetters { get => throw null; set { } }
            public static System.Reflection.FieldInfo[] Fields { get => throw null; set { } }
            public static bool IsUserType { get => throw null; set { } }
            public static System.Func<object, string, object, object> OnDeserializing { get => throw null; set { } }
            public static System.Reflection.PropertyInfo[] Properties { get => throw null; set { } }
            public static void Reset() => throw null;
        }
        public static class TypeSerializer
        {
            public static bool CanCreateFromString(System.Type type) => throw null;
            public static T Clone<T>(T value) => throw null;
            public static T DeserializeFromReader<T>(System.IO.TextReader reader) => throw null;
            public static object DeserializeFromReader(System.IO.TextReader reader, System.Type type) => throw null;
            public static T DeserializeFromSpan<T>(System.ReadOnlySpan<char> value) => throw null;
            public static object DeserializeFromSpan(System.Type type, System.ReadOnlySpan<char> value) => throw null;
            public static T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public static object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public static System.Threading.Tasks.Task<object> DeserializeFromStreamAsync(System.Type type, System.IO.Stream stream) => throw null;
            public static System.Threading.Tasks.Task<T> DeserializeFromStreamAsync<T>(System.IO.Stream stream) => throw null;
            public static T DeserializeFromString<T>(string value) => throw null;
            public static object DeserializeFromString(string value, System.Type type) => throw null;
            public const string DoubleQuoteString = default;
            public static string Dump<T>(this T instance) => throw null;
            public static string Dump(this System.Delegate fn) => throw null;
            public static bool HasCircularReferences(object value) => throw null;
            public static string IndentJson(this string json) => throw null;
            public static System.Action<object> OnSerialize { get => throw null; set { } }
            public static void Print(this string text, params object[] args) => throw null;
            public static void Print(this int intValue) => throw null;
            public static void Print(this long longValue) => throw null;
            public static void PrintDump<T>(this T instance) => throw null;
            public static string SerializeAndFormat<T>(this T instance) => throw null;
            public static void SerializeToStream<T>(T value, System.IO.Stream stream) => throw null;
            public static void SerializeToStream(object value, System.Type type, System.IO.Stream stream) => throw null;
            public static string SerializeToString<T>(T value) => throw null;
            public static string SerializeToString(object value, System.Type type) => throw null;
            public static void SerializeToWriter<T>(T value, System.IO.TextWriter writer) => throw null;
            public static void SerializeToWriter(object value, System.Type type, System.IO.TextWriter writer) => throw null;
            public static System.Collections.Generic.Dictionary<string, string> ToStringDictionary(this object obj) => throw null;
            public static System.Text.UTF8Encoding UTF8Encoding { get => throw null; set { } }
        }
        public class TypeSerializer<T> : ServiceStack.Text.ITypeSerializer<T>
        {
            public bool CanCreateFromString(System.Type type) => throw null;
            public TypeSerializer() => throw null;
            public T DeserializeFromReader(System.IO.TextReader reader) => throw null;
            public T DeserializeFromString(string value) => throw null;
            public string SerializeToString(T value) => throw null;
            public void SerializeToWriter(T value, System.IO.TextWriter writer) => throw null;
        }
        public class XmlSerializer
        {
            public XmlSerializer(bool omitXmlDeclaration = default(bool), int maxCharsInDocument = default(int)) => throw null;
            public static T DeserializeFromReader<T>(System.IO.TextReader reader) => throw null;
            public static T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public static object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public static object DeserializeFromString(string xml, System.Type type) => throw null;
            public static T DeserializeFromString<T>(string xml) => throw null;
            public static ServiceStack.Text.XmlSerializer Instance;
            public static void SerializeToStream(object obj, System.IO.Stream stream) => throw null;
            public static string SerializeToString<T>(T from) => throw null;
            public static void SerializeToWriter<T>(T value, System.IO.TextWriter writer) => throw null;
            public static readonly System.Xml.XmlReaderSettings XmlReaderSettings;
            public static readonly System.Xml.XmlWriterSettings XmlWriterSettings;
        }
    }
    public static partial class TextExtensions
    {
        public static string FromCsvField(this string text) => throw null;
        public static System.Collections.Generic.List<string> FromCsvFields(this System.Collections.Generic.IEnumerable<string> texts) => throw null;
        public static string[] FromCsvFields(params string[] texts) => throw null;
        public static string SerializeToString<T>(this T value) => throw null;
        public static string ToCsvField(this string text) => throw null;
        public static object ToCsvField(this object text) => throw null;
    }
    public static class TypeConstants
    {
        public static readonly bool[] EmptyBoolArray;
        public static readonly System.Collections.Generic.List<bool> EmptyBoolList;
        public static readonly byte[] EmptyByteArray;
        public static readonly byte[][] EmptyByteArrayArray;
        public static readonly System.Collections.Generic.List<byte> EmptyByteList;
        public static readonly char[] EmptyCharArray;
        public static readonly System.Collections.Generic.List<char> EmptyCharList;
        public static readonly System.Reflection.FieldInfo[] EmptyFieldInfoArray;
        public static readonly System.Collections.Generic.List<System.Reflection.FieldInfo> EmptyFieldInfoList;
        public static readonly int[] EmptyIntArray;
        public static readonly System.Collections.Generic.List<int> EmptyIntList;
        public static readonly long[] EmptyLongArray;
        public static readonly System.Collections.Generic.List<long> EmptyLongList;
        public static readonly object EmptyObject;
        public static readonly object[] EmptyObjectArray;
        public static readonly System.Collections.Generic.Dictionary<string, object> EmptyObjectDictionary;
        public static readonly System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object>> EmptyObjectDictionaryList;
        public static readonly System.Collections.Generic.List<object> EmptyObjectList;
        public static readonly System.Reflection.PropertyInfo[] EmptyPropertyInfoArray;
        public static readonly System.Collections.Generic.List<System.Reflection.PropertyInfo> EmptyPropertyInfoList;
        public static readonly string[] EmptyStringArray;
        public static readonly System.Collections.Generic.Dictionary<string, string> EmptyStringDictionary;
        public static readonly System.Collections.Generic.List<string> EmptyStringList;
        public static System.ReadOnlyMemory<char> EmptyStringMemory { get => throw null; }
        public static System.ReadOnlySpan<char> EmptyStringSpan { get => throw null; }
        public static readonly System.Threading.Tasks.Task<object> EmptyTask;
        public static readonly System.Type[] EmptyTypeArray;
        public static readonly System.Collections.Generic.List<System.Type> EmptyTypeList;
        public static readonly System.Threading.Tasks.Task<bool> FalseTask;
        public const char NonWidthWhiteSpace = default;
        public static char[] NonWidthWhiteSpaceChars;
        public static System.ReadOnlyMemory<char> NullStringMemory { get => throw null; }
        public static System.ReadOnlySpan<char> NullStringSpan { get => throw null; }
        public static readonly System.Threading.Tasks.Task<bool> TrueTask;
        public static readonly System.Threading.Tasks.Task<int> ZeroTask;
    }
    public static class TypeConstants<T>
    {
        public static readonly T[] EmptyArray;
        public static readonly System.Collections.Generic.HashSet<T> EmptyHashSet;
        public static readonly System.Collections.Generic.List<T> EmptyList;
    }
    public class TypeFields<T> : ServiceStack.TypeFields
    {
        public TypeFields() => throw null;
        public static ServiceStack.FieldAccessor GetAccessor(string propertyName) => throw null;
        public static readonly ServiceStack.TypeFields<T> Instance;
    }
    public abstract class TypeFields
    {
        protected TypeFields() => throw null;
        public static System.Type FactoryType;
        public readonly System.Collections.Generic.Dictionary<string, ServiceStack.FieldAccessor> FieldsMap;
        public static ServiceStack.TypeFields Get(System.Type type) => throw null;
        public ServiceStack.FieldAccessor GetAccessor(string propertyName) => throw null;
        public virtual System.Reflection.FieldInfo GetPublicField(string name) => throw null;
        public virtual ServiceStack.GetMemberDelegate GetPublicGetter(System.Reflection.FieldInfo fi) => throw null;
        public virtual ServiceStack.GetMemberDelegate GetPublicGetter(string name) => throw null;
        public virtual ServiceStack.SetMemberDelegate GetPublicSetter(System.Reflection.FieldInfo fi) => throw null;
        public virtual ServiceStack.SetMemberDelegate GetPublicSetter(string name) => throw null;
        public virtual ServiceStack.SetMemberRefDelegate GetPublicSetterRef(string name) => throw null;
        public System.Reflection.FieldInfo[] PublicFieldInfos { get => throw null; set { } }
        public System.Type Type { get => throw null; set { } }
    }
    public class TypeProperties<T> : ServiceStack.TypeProperties
    {
        public TypeProperties() => throw null;
        public static ServiceStack.PropertyAccessor GetAccessor(string propertyName) => throw null;
        public static readonly ServiceStack.TypeProperties<T> Instance;
    }
    public abstract class TypeProperties
    {
        protected TypeProperties() => throw null;
        public static readonly System.Type FactoryType;
        public static ServiceStack.TypeProperties Get(System.Type type) => throw null;
        public ServiceStack.PropertyAccessor GetAccessor(string propertyName) => throw null;
        public ServiceStack.GetMemberDelegate GetPublicGetter(System.Reflection.PropertyInfo pi) => throw null;
        public ServiceStack.GetMemberDelegate GetPublicGetter(string name) => throw null;
        public System.Reflection.PropertyInfo GetPublicProperty(string name) => throw null;
        public ServiceStack.SetMemberDelegate GetPublicSetter(System.Reflection.PropertyInfo pi) => throw null;
        public ServiceStack.SetMemberDelegate GetPublicSetter(string name) => throw null;
        public readonly System.Collections.Generic.Dictionary<string, ServiceStack.PropertyAccessor> PropertyMap;
        public System.Reflection.PropertyInfo[] PublicPropertyInfos { get => throw null; set { } }
        public System.Type Type { get => throw null; set { } }
    }
    public static class Words
    {
        public static string Capitalize(string word) => throw null;
        public static string Pluralize(string word) => throw null;
        public static string Singularize(string word) => throw null;
    }
    public delegate bool WriteComplexTypeDelegate(System.IO.TextWriter writer, string propertyName, object obj);
    public static class X
    {
        public static T Apply<T>(T obj, System.Action<T> fn = default(System.Action<T>)) => throw null;
        public static To Map<From, To>(From from, System.Func<From, To> fn) => throw null;
    }
}
