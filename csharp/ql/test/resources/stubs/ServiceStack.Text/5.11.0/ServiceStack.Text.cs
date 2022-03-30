// This file contains auto-generated code.

namespace ServiceStack
{
    // Generated from `ServiceStack.AssignmentEntry` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AssignmentEntry
    {
        public AssignmentEntry(string name, ServiceStack.AssignmentMember from, ServiceStack.AssignmentMember to) => throw null;
        public ServiceStack.GetMemberDelegate ConvertValueFn;
        public ServiceStack.AssignmentMember From;
        public ServiceStack.GetMemberDelegate GetValueFn;
        public string Name;
        public ServiceStack.SetMemberDelegate SetValueFn;
        public ServiceStack.AssignmentMember To;
    }

    // Generated from `ServiceStack.AssignmentMember` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AssignmentMember
    {
        public AssignmentMember(System.Type type, System.Reflection.PropertyInfo propertyInfo) => throw null;
        public AssignmentMember(System.Type type, System.Reflection.MethodInfo methodInfo) => throw null;
        public AssignmentMember(System.Type type, System.Reflection.FieldInfo fieldInfo) => throw null;
        public ServiceStack.GetMemberDelegate CreateGetter() => throw null;
        public ServiceStack.SetMemberDelegate CreateSetter() => throw null;
        public System.Reflection.FieldInfo FieldInfo;
        public System.Reflection.MethodInfo MethodInfo;
        public System.Reflection.PropertyInfo PropertyInfo;
        public System.Type Type;
    }

    // Generated from `ServiceStack.AutoMapping` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class AutoMapping
    {
        public static void IgnoreMapping<From, To>() => throw null;
        public static void IgnoreMapping(System.Type fromType, System.Type toType) => throw null;
        public static void RegisterConverter<From, To>(System.Func<From, To> converter) => throw null;
        public static void RegisterPopulator<Target, Source>(System.Action<Target, Source> populator) => throw null;
    }

    // Generated from `ServiceStack.AutoMappingUtils` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class AutoMappingUtils
    {
        public static bool CanCast(System.Type toType, System.Type fromType) => throw null;
        public static object ChangeTo(this string strValue, System.Type type) => throw null;
        public static object ChangeValueType(object from, System.Type toType) => throw null;
        public static object ConvertTo(this object from, System.Type toType, bool skipConverters) => throw null;
        public static object ConvertTo(this object from, System.Type toType) => throw null;
        public static T ConvertTo<T>(this object from, bool skipConverters) => throw null;
        public static T ConvertTo<T>(this object from, T defaultValue) => throw null;
        public static T ConvertTo<T>(this object from) => throw null;
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
        public static bool IsDefaultValue(object value, System.Type valueType) => throw null;
        public static bool IsDefaultValue(object value) => throw null;
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

    // Generated from `ServiceStack.CollectionExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class CollectionExtensions
    {
        public static object Convert<T>(object objCollection, System.Type toCollectionType) => throw null;
        public static System.Collections.Generic.ICollection<T> CreateAndPopulate<T>(System.Type ofCollectionType, T[] withItems) => throw null;
        public static T[] ToArray<T>(this System.Collections.Generic.ICollection<T> collection) => throw null;
    }

    // Generated from `ServiceStack.CompressionTypes` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class CompressionTypes
    {
        public static string[] AllCompressionTypes;
        public static void AssertIsValid(string compressionType) => throw null;
        public const string Default = default;
        public const string Deflate = default;
        public const string GZip = default;
        public static string GetExtension(string compressionType) => throw null;
        public static bool IsValid(string compressionType) => throw null;
    }

    // Generated from `ServiceStack.CustomHttpResult` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class CustomHttpResult
    {
        public CustomHttpResult() => throw null;
    }

    // Generated from `ServiceStack.Defer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public struct Defer : System.IDisposable
    {
        public Defer(System.Action fn) => throw null;
        // Stub generator skipped constructor 
        public void Dispose() => throw null;
    }

    // Generated from `ServiceStack.DeserializeDynamic<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class DeserializeDynamic<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
    {
        public static ServiceStack.Text.Common.ParseStringDelegate Parse { get => throw null; }
        public static System.Dynamic.IDynamicMetaObjectProvider ParseDynamic(string value) => throw null;
        public static System.Dynamic.IDynamicMetaObjectProvider ParseDynamic(System.ReadOnlySpan<System.Char> value) => throw null;
        public static ServiceStack.Text.Common.ParseStringSpanDelegate ParseStringSpan { get => throw null; }
    }

    // Generated from `ServiceStack.DynamicByte` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicByte : ServiceStack.IDynamicNumber
    {
        public System.Byte Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicByte() => throw null;
        public static ServiceStack.DynamicByte Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicDecimal` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicDecimal : ServiceStack.IDynamicNumber
    {
        public System.Decimal Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicDecimal() => throw null;
        public static ServiceStack.DynamicDecimal Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicDouble` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicDouble : ServiceStack.IDynamicNumber
    {
        public double Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicDouble() => throw null;
        public static ServiceStack.DynamicDouble Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicFloat` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicFloat : ServiceStack.IDynamicNumber
    {
        public float Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicFloat() => throw null;
        public static ServiceStack.DynamicFloat Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicInt` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicInt : ServiceStack.IDynamicNumber
    {
        public int Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicInt() => throw null;
        public static ServiceStack.DynamicInt Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicJson` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicJson : System.Dynamic.DynamicObject
    {
        public static dynamic Deserialize(string json) => throw null;
        public DynamicJson(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> hash) => throw null;
        public static string Serialize(dynamic instance) => throw null;
        public override string ToString() => throw null;
        public override bool TryGetMember(System.Dynamic.GetMemberBinder binder, out object result) => throw null;
        public override bool TrySetMember(System.Dynamic.SetMemberBinder binder, object value) => throw null;
    }

    // Generated from `ServiceStack.DynamicLong` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicLong : ServiceStack.IDynamicNumber
    {
        public System.Int64 Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicLong() => throw null;
        public static ServiceStack.DynamicLong Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicNumber` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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
        public static ServiceStack.IDynamicNumber GetNumber(object lhs, object rhs) => throw null;
        public static ServiceStack.IDynamicNumber GetNumber(System.Type type) => throw null;
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

    // Generated from `ServiceStack.DynamicSByte` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicSByte : ServiceStack.IDynamicNumber
    {
        public System.SByte Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicSByte() => throw null;
        public static ServiceStack.DynamicSByte Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicShort` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicShort : ServiceStack.IDynamicNumber
    {
        public System.Int16 Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicShort() => throw null;
        public static ServiceStack.DynamicShort Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicUInt` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicUInt : ServiceStack.IDynamicNumber
    {
        public System.UInt32 Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicUInt() => throw null;
        public static ServiceStack.DynamicUInt Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicULong` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicULong : ServiceStack.IDynamicNumber
    {
        public System.UInt64 Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicULong() => throw null;
        public static ServiceStack.DynamicULong Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.DynamicUShort` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class DynamicUShort : ServiceStack.IDynamicNumber
    {
        public System.UInt16 Convert(object value) => throw null;
        public object ConvertFrom(object value) => throw null;
        public object DefaultValue { get => throw null; }
        public DynamicUShort() => throw null;
        public static ServiceStack.DynamicUShort Instance;
        public string ToString(object value) => throw null;
        public bool TryParse(string str, out object result) => throw null;
        public System.Type Type { get => throw null; }
        public object add(object lhs, object rhs) => throw null;
        public object bitwiseAnd(object lhs, object rhs) => throw null;
        public object bitwiseLeftShift(object lhs, object rhs) => throw null;
        public object bitwiseNot(object target) => throw null;
        public object bitwiseOr(object lhs, object rhs) => throw null;
        public object bitwiseRightShift(object lhs, object rhs) => throw null;
        public object bitwiseXOr(object lhs, object rhs) => throw null;
        public int compareTo(object lhs, object rhs) => throw null;
        public object div(object lhs, object rhs) => throw null;
        public object log(object lhs, object rhs) => throw null;
        public object max(object lhs, object rhs) => throw null;
        public object min(object lhs, object rhs) => throw null;
        public object mod(object lhs, object rhs) => throw null;
        public object mul(object lhs, object rhs) => throw null;
        public object pow(object lhs, object rhs) => throw null;
        public object sub(object lhs, object rhs) => throw null;
    }

    // Generated from `ServiceStack.EmptyCtorDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate object EmptyCtorDelegate();

    // Generated from `ServiceStack.EmptyCtorFactoryDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate ServiceStack.EmptyCtorDelegate EmptyCtorFactoryDelegate(System.Type type);

    // Generated from `ServiceStack.FieldAccessor` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class FieldAccessor
    {
        public FieldAccessor(System.Reflection.FieldInfo fieldInfo, ServiceStack.GetMemberDelegate publicGetter, ServiceStack.SetMemberDelegate publicSetter, ServiceStack.SetMemberRefDelegate publicSetterRef) => throw null;
        public System.Reflection.FieldInfo FieldInfo { get => throw null; }
        public ServiceStack.GetMemberDelegate PublicGetter { get => throw null; }
        public ServiceStack.SetMemberDelegate PublicSetter { get => throw null; }
        public ServiceStack.SetMemberRefDelegate PublicSetterRef { get => throw null; }
    }

    // Generated from `ServiceStack.FieldInvoker` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class FieldInvoker
    {
        public static ServiceStack.GetMemberDelegate<T> CreateGetter<T>(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static ServiceStack.GetMemberDelegate CreateGetter(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static ServiceStack.SetMemberDelegate<T> CreateSetter<T>(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static ServiceStack.SetMemberDelegate CreateSetter(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static ServiceStack.SetMemberRefDelegate<T> SetExpressionRef<T>(this System.Reflection.FieldInfo fieldInfo) => throw null;
    }

    // Generated from `ServiceStack.GetMemberDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate object GetMemberDelegate(object instance);

    // Generated from `ServiceStack.GetMemberDelegate<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate object GetMemberDelegate<T>(T instance);

    // Generated from `ServiceStack.HttpHeaders` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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
        public const string SOAPAction = default;
        public const string SetCookie = default;
        public const string SetCookie2 = default;
        public const string TE = default;
        public const string Trailer = default;
        public const string TransferEncoding = default;
        public const string Upgrade = default;
        public const string UserAgent = default;
        public const string Vary = default;
        public const string Via = default;
        public const string Warning = default;
        public const string WwwAuthenticate = default;
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

    // Generated from `ServiceStack.HttpMethods` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class HttpMethods
    {
        public static System.Collections.Generic.HashSet<string> AllVerbs;
        public const string Delete = default;
        public static bool Exists(string httpMethod) => throw null;
        public const string Get = default;
        public static bool HasVerb(string httpVerb) => throw null;
        public const string Head = default;
        public const string Options = default;
        public const string Patch = default;
        public const string Post = default;
        public const string Put = default;
    }

    // Generated from `ServiceStack.HttpResultsFilter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class HttpResultsFilter : System.IDisposable, ServiceStack.IHttpResultsFilter
    {
        public System.Byte[] BytesResult { get => throw null; set => throw null; }
        public System.Func<System.Net.HttpWebRequest, System.Byte[], System.Byte[]> BytesResultFn { get => throw null; set => throw null; }
        public void Dispose() => throw null;
        public System.Byte[] GetBytes(System.Net.HttpWebRequest webReq, System.Byte[] reqBody) => throw null;
        public string GetString(System.Net.HttpWebRequest webReq, string reqBody) => throw null;
        public HttpResultsFilter(string stringResult = default(string), System.Byte[] bytesResult = default(System.Byte[])) => throw null;
        public string StringResult { get => throw null; set => throw null; }
        public System.Func<System.Net.HttpWebRequest, string, string> StringResultFn { get => throw null; set => throw null; }
        public System.Action<System.Net.HttpWebRequest, System.IO.Stream, string> UploadFileFn { get => throw null; set => throw null; }
        public void UploadStream(System.Net.HttpWebRequest webRequest, System.IO.Stream fileStream, string fileName) => throw null;
    }

    // Generated from `ServiceStack.HttpStatus` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class HttpStatus
    {
        public static string GetStatusDescription(int statusCode) => throw null;
    }

    // Generated from `ServiceStack.HttpUtils` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class HttpUtils
    {
        public static string AddHashParam(this string url, string key, string val) => throw null;
        public static string AddHashParam(this string url, string key, object val) => throw null;
        public static string AddQueryParam(this string url, string key, string val, bool encode = default(bool)) => throw null;
        public static string AddQueryParam(this string url, string key, object val, bool encode = default(bool)) => throw null;
        public static string AddQueryParam(this string url, object key, string val, bool encode = default(bool)) => throw null;
        public static System.Threading.Tasks.Task<TBase> ConvertTo<TDerived, TBase>(this System.Threading.Tasks.Task<TDerived> task) where TDerived : TBase => throw null;
        public static string DeleteFromUrl(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> DeleteFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Byte[] GetBytesFromUrl(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<System.Byte[]> GetBytesFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string GetCsvFromUrl(this string url, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> GetCsvFromUrlAsync(this string url, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Net.HttpWebResponse GetErrorResponse(this string url) => throw null;
        public static System.Threading.Tasks.Task<System.Net.HttpWebResponse> GetErrorResponseAsync(this string url) => throw null;
        public static string GetJsonFromUrl(this string url, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> GetJsonFromUrlAsync(this string url, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> GetRequestStreamAsync(this System.Net.WebRequest request) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> GetRequestStreamAsync(this System.Net.HttpWebRequest request) => throw null;
        public static System.Threading.Tasks.Task<System.Net.WebResponse> GetResponseAsync(this System.Net.WebRequest request) => throw null;
        public static System.Threading.Tasks.Task<System.Net.HttpWebResponse> GetResponseAsync(this System.Net.HttpWebRequest request) => throw null;
        public static string GetResponseBody(this System.Exception ex) => throw null;
        public static System.Threading.Tasks.Task<string> GetResponseBodyAsync(this System.Exception ex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Net.HttpStatusCode? GetResponseStatus(this string url) => throw null;
        public static System.Net.HttpStatusCode? GetStatus(this System.Net.WebException webEx) => throw null;
        public static System.Net.HttpStatusCode? GetStatus(this System.Exception ex) => throw null;
        public static System.IO.Stream GetStreamFromUrl(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> GetStreamFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string GetStringFromUrl(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> GetStringFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string GetXmlFromUrl(this string url, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> GetXmlFromUrlAsync(this string url, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static bool HasRequestBody(string httpMethod) => throw null;
        public static bool HasStatus(this System.Exception ex, System.Net.HttpStatusCode statusCode) => throw null;
        public static string HeadFromUrl(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> HeadFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static bool IsAny300(this System.Exception ex) => throw null;
        public static bool IsAny400(this System.Exception ex) => throw null;
        public static bool IsAny500(this System.Exception ex) => throw null;
        public static bool IsBadRequest(this System.Exception ex) => throw null;
        public static bool IsForbidden(this System.Exception ex) => throw null;
        public static bool IsInternalServerError(this System.Exception ex) => throw null;
        public static bool IsNotFound(this System.Exception ex) => throw null;
        public static bool IsNotModified(this System.Exception ex) => throw null;
        public static bool IsUnauthorized(this System.Exception ex) => throw null;
        public static string OptionsFromUrl(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> OptionsFromUrlAsync(this string url, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PatchJsonToUrl(this string url, string json, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PatchJsonToUrl(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchJsonToUrlAsync(this string url, string json, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchJsonToUrlAsync(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PatchStringToUrl(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchStringToUrlAsync(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PatchToUrl(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PatchToUrl(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchToUrlAsync(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PatchToUrlAsync(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Byte[] PostBytesToUrl(this string url, System.Byte[] requestBody = default(System.Byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<System.Byte[]> PostBytesToUrlAsync(this string url, System.Byte[] requestBody = default(System.Byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostCsvToUrl(this string url, string csv, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PostCsvToUrl(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostCsvToUrlAsync(this string url, string csv, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Net.WebResponse PostFileToUrl(this string url, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>)) => throw null;
        public static System.Threading.Tasks.Task<System.Net.WebResponse> PostFileToUrlAsync(this string url, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostJsonToUrl(this string url, string json, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PostJsonToUrl(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostJsonToUrlAsync(this string url, string json, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PostJsonToUrlAsync(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.IO.Stream PostStreamToUrl(this string url, System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> PostStreamToUrlAsync(this string url, System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostStringToUrl(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostStringToUrlAsync(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostToUrl(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PostToUrl(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostToUrlAsync(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PostToUrlAsync(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PostXmlToUrl(this string url, string xml, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PostXmlToUrl(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PostXmlToUrlAsync(this string url, string xml, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Byte[] PutBytesToUrl(this string url, System.Byte[] requestBody = default(System.Byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<System.Byte[]> PutBytesToUrlAsync(this string url, System.Byte[] requestBody = default(System.Byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutCsvToUrl(this string url, string csv, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PutCsvToUrl(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutCsvToUrlAsync(this string url, string csv, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Net.WebResponse PutFileToUrl(this string url, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>)) => throw null;
        public static System.Threading.Tasks.Task<System.Net.WebResponse> PutFileToUrlAsync(this string url, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutJsonToUrl(this string url, string json, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PutJsonToUrl(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutJsonToUrlAsync(this string url, string json, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PutJsonToUrlAsync(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.IO.Stream PutStreamToUrl(this string url, System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> PutStreamToUrlAsync(this string url, System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutStringToUrl(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutStringToUrlAsync(this string url, string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutToUrl(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PutToUrl(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutToUrlAsync(this string url, string formData = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<string> PutToUrlAsync(this string url, object formData = default(object), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string PutXmlToUrl(this string url, string xml, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static string PutXmlToUrl(this string url, object data, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> PutXmlToUrlAsync(this string url, string xml, System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Collections.Generic.IEnumerable<string> ReadLines(this System.Net.WebResponse webRes) => throw null;
        public static string ReadToEnd(this System.Net.WebResponse webRes) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.Net.WebResponse webRes) => throw null;
        public static ServiceStack.IHttpResultsFilter ResultsFilter;
        public static System.Byte[] SendBytesToUrl(this string url, string method = default(string), System.Byte[] requestBody = default(System.Byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<System.Byte[]> SendBytesToUrlAsync(this string url, string method = default(string), System.Byte[] requestBody = default(System.Byte[]), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.IO.Stream SendStreamToUrl(this string url, string method = default(string), System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<System.IO.Stream> SendStreamToUrlAsync(this string url, string method = default(string), System.IO.Stream requestBody = default(System.IO.Stream), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string SendStringToUrl(this string url, string method = default(string), string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> SendStringToUrlAsync(this string url, string method = default(string), string requestBody = default(string), string contentType = default(string), string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string SetHashParam(this string url, string key, string val) => throw null;
        public static string SetQueryParam(this string url, string key, string val) => throw null;
        public static void UploadFile(this System.Net.WebRequest webRequest, System.IO.Stream fileStream, string fileName, string mimeType, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), string method = default(string), string field = default(string)) => throw null;
        public static void UploadFile(this System.Net.WebRequest webRequest, System.IO.Stream fileStream, string fileName) => throw null;
        public static System.Net.WebResponse UploadFile(this System.Net.WebRequest webRequest, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType) => throw null;
        public static System.Threading.Tasks.Task<System.Net.WebResponse> UploadFileAsync(this System.Net.WebRequest webRequest, System.IO.FileInfo uploadFileInfo, string uploadFileMimeType) => throw null;
        public static System.Threading.Tasks.Task UploadFileAsync(this System.Net.WebRequest webRequest, System.IO.Stream fileStream, string fileName, string mimeType, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), string method = default(string), string field = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task UploadFileAsync(this System.Net.WebRequest webRequest, System.IO.Stream fileStream, string fileName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Text.Encoding UseEncoding { get => throw null; set => throw null; }
        public static string UserAgent;
    }

    // Generated from `ServiceStack.IDynamicNumber` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IDynamicNumber
    {
        object ConvertFrom(object value);
        object DefaultValue { get; }
        string ToString(object value);
        bool TryParse(string str, out object result);
        System.Type Type { get; }
        object add(object lhs, object rhs);
        object bitwiseAnd(object lhs, object rhs);
        object bitwiseLeftShift(object lhs, object rhs);
        object bitwiseNot(object target);
        object bitwiseOr(object lhs, object rhs);
        object bitwiseRightShift(object lhs, object rhs);
        object bitwiseXOr(object lhs, object rhs);
        int compareTo(object lhs, object rhs);
        object div(object lhs, object rhs);
        object log(object lhs, object rhs);
        object max(object lhs, object rhs);
        object min(object lhs, object rhs);
        object mod(object lhs, object rhs);
        object mul(object lhs, object rhs);
        object pow(object lhs, object rhs);
        object sub(object lhs, object rhs);
    }

    // Generated from `ServiceStack.IHasStatusCode` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHasStatusCode
    {
        int StatusCode { get; }
    }

    // Generated from `ServiceStack.IHasStatusDescription` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHasStatusDescription
    {
        string StatusDescription { get; }
    }

    // Generated from `ServiceStack.IHttpResultsFilter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHttpResultsFilter : System.IDisposable
    {
        System.Byte[] GetBytes(System.Net.HttpWebRequest webReq, System.Byte[] reqBody);
        string GetString(System.Net.HttpWebRequest webReq, string reqBody);
        void UploadStream(System.Net.HttpWebRequest webRequest, System.IO.Stream fileStream, string fileName);
    }

    // Generated from `ServiceStack.KeyValuePairs` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class KeyValuePairs : System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, object>>
    {
        public static System.Collections.Generic.KeyValuePair<string, object> Create(string key, object value) => throw null;
        public KeyValuePairs(int capacity) => throw null;
        public KeyValuePairs(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> collection) => throw null;
        public KeyValuePairs() => throw null;
    }

    // Generated from `ServiceStack.KeyValueStrings` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class KeyValueStrings : System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>>
    {
        public static System.Collections.Generic.KeyValuePair<string, string> Create(string key, string value) => throw null;
        public KeyValueStrings(int capacity) => throw null;
        public KeyValueStrings(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> collection) => throw null;
        public KeyValueStrings() => throw null;
    }

    // Generated from `ServiceStack.LicenseException` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class LicenseException : System.Exception
    {
        public LicenseException(string message, System.Exception innerException) => throw null;
        public LicenseException(string message) => throw null;
    }

    // Generated from `ServiceStack.LicenseFeature` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    [System.Flags]
    public enum LicenseFeature
    {
        Admin,
        All,
        Aws,
        AwsSku,
        Client,
        Common,
        Free,
        None,
        OrmLite,
        OrmLiteSku,
        Premium,
        Razor,
        Redis,
        RedisSku,
        Server,
        ServiceStack,
        Text,
    }

    // Generated from `ServiceStack.LicenseKey` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class LicenseKey
    {
        public System.DateTime Expiry { get => throw null; set => throw null; }
        public string Hash { get => throw null; set => throw null; }
        public LicenseKey() => throw null;
        public System.Int64 Meta { get => throw null; set => throw null; }
        public string Name { get => throw null; set => throw null; }
        public string Ref { get => throw null; set => throw null; }
        public ServiceStack.LicenseType Type { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.LicenseMeta` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    [System.Flags]
    public enum LicenseMeta
    {
        Cores,
        None,
        Subscription,
    }

    // Generated from `ServiceStack.LicenseType` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum LicenseType
    {
        AwsBusiness,
        AwsIndie,
        Business,
        Enterprise,
        Free,
        Indie,
        OrmLiteBusiness,
        OrmLiteIndie,
        OrmLiteSite,
        RedisBusiness,
        RedisIndie,
        RedisSite,
        Site,
        TextBusiness,
        TextIndie,
        TextSite,
        Trial,
    }

    // Generated from `ServiceStack.LicenseUtils` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class LicenseUtils
    {
        public static ServiceStack.LicenseFeature ActivatedLicenseFeatures() => throw null;
        public static void ApprovedUsage(ServiceStack.LicenseFeature licenseFeature, ServiceStack.LicenseFeature requestedFeature, int allowedUsage, int actualUsage, string message) => throw null;
        public static void AssertEvaluationLicense() => throw null;
        public static void AssertValidUsage(ServiceStack.LicenseFeature feature, ServiceStack.QuotaType quotaType, int count) => throw null;
        // Generated from `ServiceStack.LicenseUtils+ErrorMessages` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class ErrorMessages
        {
            public const string UnauthorizedAccessRequest = default;
        }


        // Generated from `ServiceStack.LicenseUtils+FreeQuotas` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class FreeQuotas
        {
            public const int AwsTables = default;
            public const int OrmLiteTables = default;
            public const int PremiumFeature = default;
            public const int RedisRequestPerHour = default;
            public const int RedisTypes = default;
            public const int ServiceStackOperations = default;
            public const int TypeFields = default;
        }


        public static string GetHashKeyToSign(this ServiceStack.LicenseKey key) => throw null;
        public static System.Exception GetInnerMostException(this System.Exception ex) => throw null;
        public static ServiceStack.LicenseFeature GetLicensedFeatures(this ServiceStack.LicenseKey key) => throw null;
        public static bool HasInit { get => throw null; set => throw null; }
        public static bool HasLicensedFeature(ServiceStack.LicenseFeature feature) => throw null;
        public static void Init() => throw null;
        public const string LicensePublicKey = default;
        public static string LicenseWarningMessage { get => throw null; set => throw null; }
        public static void RegisterLicense(string licenseKeyText) => throw null;
        public static void RemoveLicense() => throw null;
        public const string RuntimePublicKey = default;
        public static ServiceStack.LicenseKey ToLicenseKey(this string licenseKeyText) => throw null;
        public static ServiceStack.LicenseKey ToLicenseKeyFallback(this string licenseKeyText) => throw null;
        public static bool VerifyLicenseKeyText(this string licenseKeyText, out ServiceStack.LicenseKey key) => throw null;
        public static ServiceStack.LicenseKey VerifyLicenseKeyText(string licenseKeyText) => throw null;
        public static bool VerifyLicenseKeyTextFallback(this string licenseKeyText, out ServiceStack.LicenseKey key) => throw null;
        public static bool VerifySha1Data(this System.Security.Cryptography.RSACryptoServiceProvider RSAalg, System.Byte[] unsignedData, System.Byte[] encryptedData) => throw null;
        public static bool VerifySignedHash(System.Byte[] DataToVerify, System.Byte[] SignedData, System.Security.Cryptography.RSAParameters Key) => throw null;
    }

    // Generated from `ServiceStack.Licensing` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class Licensing
    {
        public static void RegisterLicense(string licenseKeyText) => throw null;
        public static void RegisterLicenseFromFile(string filePath) => throw null;
        public static void RegisterLicenseFromFileIfExists(string filePath) => throw null;
    }

    // Generated from `ServiceStack.ListExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class ListExtensions
    {
        public static System.Collections.Generic.List<System.Type> Add<T>(this System.Collections.Generic.List<System.Type> types) => throw null;
        public static void AddIfNotExists<T>(this System.Collections.Generic.List<T> list, T item) => throw null;
        public static T[] InArray<T>(this T value) => throw null;
        public static System.Collections.Generic.List<T> InList<T>(this T value) => throw null;
        public static bool IsNullOrEmpty<T>(this System.Collections.Generic.List<T> list) => throw null;
        public static string Join<T>(this System.Collections.Generic.IEnumerable<T> values, string seperator) => throw null;
        public static string Join<T>(this System.Collections.Generic.IEnumerable<T> values) => throw null;
        public static T[] NewArray<T>(this T[] array, T with = default(T), T without = default(T)) where T : class => throw null;
        public static int NullableCount<T>(this System.Collections.Generic.List<T> list) => throw null;
        public static System.Collections.Generic.IEnumerable<TFrom> SafeWhere<TFrom>(this System.Collections.Generic.List<TFrom> list, System.Func<TFrom, bool> predicate) => throw null;
    }

    // Generated from `ServiceStack.MapExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class MapExtensions
    {
        public static string Join<K, V>(this System.Collections.Generic.Dictionary<K, V> values, string itemSeperator, string keySeperator) => throw null;
        public static string Join<K, V>(this System.Collections.Generic.Dictionary<K, V> values) => throw null;
    }

    // Generated from `ServiceStack.MimeTypes` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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
        public static System.Func<string, bool?> IsBinaryFilter { get => throw null; set => throw null; }
        public const string Jar = default;
        public const string JavaScript = default;
        public const string Json = default;
        public const string JsonReport = default;
        public const string JsonText = default;
        public const string Jsv = default;
        public const string JsvText = default;
        public const string MarkdownText = default;
        public static bool MatchesContentType(string contentType, string matchesContentType) => throw null;
        public const string MsWord = default;
        public const string MsgPack = default;
        public const string MultiPartFormData = default;
        public const string NetSerializer = default;
        public const string Pkg = default;
        public const string PlainText = default;
        public const string ProblemJson = default;
        public const string ProtoBuf = default;
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

    // Generated from `ServiceStack.NetCorePclExport` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class NetCorePclExport : ServiceStack.NetStandardPclExport
    {
        public override ServiceStack.Text.Common.ParseStringDelegate GetJsReaderParseMethod<TSerializer>(System.Type type) => throw null;
        public override ServiceStack.Text.Common.ParseStringSpanDelegate GetJsReaderParseStringSpanMethod<TSerializer>(System.Type type) => throw null;
        public NetCorePclExport() => throw null;
    }

    // Generated from `ServiceStack.NetStandardPclExport` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class NetStandardPclExport : ServiceStack.PclExport
    {
        public override void AddCompression(System.Net.WebRequest webReq) => throw null;
        public override void AddHeader(System.Net.WebRequest webReq, string name, string value) => throw null;
        public const string AppSettingsKey = default;
        public override void Config(System.Net.HttpWebRequest req, bool? allowAutoRedirect = default(bool?), System.TimeSpan? timeout = default(System.TimeSpan?), System.TimeSpan? readWriteTimeout = default(System.TimeSpan?), string userAgent = default(string), bool? preAuthenticate = default(bool?)) => throw null;
        public static ServiceStack.PclExport Configure() => throw null;
        public override void CreateDirectory(string dirPath) => throw null;
        public override bool DirectoryExists(string dirPath) => throw null;
        public const string EnvironmentKey = default;
        public override bool FileExists(string filePath) => throw null;
        public override System.Reflection.Assembly[] GetAllAssemblies() => throw null;
        public override System.Byte[] GetAsciiBytes(string str) => throw null;
        public override string GetAsciiString(System.Byte[] bytes, int index, int count) => throw null;
        public override string GetAssemblyCodeBase(System.Reflection.Assembly assembly) => throw null;
        public override string GetAssemblyPath(System.Type source) => throw null;
        public override string[] GetDirectoryNames(string dirPath, string searchPattern = default(string)) => throw null;
        public override string GetEnvironmentVariable(string name) => throw null;
        public override string[] GetFileNames(string dirPath, string searchPattern = default(string)) => throw null;
        public override System.Type GetGenericCollectionType(System.Type type) => throw null;
        public override ServiceStack.Text.Common.ParseStringDelegate GetSpecializedCollectionParseMethod<TSerializer>(System.Type type) => throw null;
        public override ServiceStack.Text.Common.ParseStringSpanDelegate GetSpecializedCollectionParseStringSpanMethod<TSerializer>(System.Type type) => throw null;
        public override string GetStackTrace() => throw null;
        public override bool InSameAssembly(System.Type t1, System.Type t2) => throw null;
        public static void InitForAot() => throw null;
        public override void InitHttpWebRequest(System.Net.HttpWebRequest httpReq, System.Int64? contentLength = default(System.Int64?), bool allowAutoRedirect = default(bool), bool keepAlive = default(bool)) => throw null;
        public override string MapAbsolutePath(string relativePath, string appendPartialPathModifier) => throw null;
        public NetStandardPclExport() => throw null;
        public override System.DateTime ParseXsdDateTimeAsUtc(string dateTimeStr) => throw null;
        public static ServiceStack.NetStandardPclExport Provider;
        public override string ReadAllText(string filePath) => throw null;
        public static int RegisterElement<T, TElement>() => throw null;
        public override void RegisterForAot() => throw null;
        public override void RegisterLicenseFromConfig() => throw null;
        public static void RegisterQueryStringWriter() => throw null;
        public static void RegisterTypeForAot<T>() => throw null;
        public override void SetAllowAutoRedirect(System.Net.HttpWebRequest httpReq, bool value) => throw null;
        public override void SetContentLength(System.Net.HttpWebRequest httpReq, System.Int64 value) => throw null;
        public override void SetKeepAlive(System.Net.HttpWebRequest httpReq, bool value) => throw null;
        public override void SetUserAgent(System.Net.HttpWebRequest httpReq, string value) => throw null;
        public override void WriteLine(string line) => throw null;
        public override void WriteLine(string format, params object[] args) => throw null;
    }

    // Generated from `ServiceStack.ObjectDictionary` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ObjectDictionary : System.Collections.Generic.Dictionary<string, object>
    {
        public ObjectDictionary(int capacity, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public ObjectDictionary(int capacity) => throw null;
        public ObjectDictionary(System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public ObjectDictionary(System.Collections.Generic.IDictionary<string, object> dictionary, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public ObjectDictionary(System.Collections.Generic.IDictionary<string, object> dictionary) => throw null;
        public ObjectDictionary() => throw null;
        protected ObjectDictionary(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
    }

    // Generated from `ServiceStack.PathUtils` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class PathUtils
    {
        public static void AppendPaths(System.Text.StringBuilder sb, string[] paths) => throw null;
        public static string AssertDir(this string dirPath) => throw null;
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

    // Generated from `ServiceStack.PclExport` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class PclExport
    {
        public virtual void AddCompression(System.Net.WebRequest webRequest) => throw null;
        public virtual void AddHeader(System.Net.WebRequest webReq, string name, string value) => throw null;
        public System.Char AltDirSep;
        public virtual void BeginThreadAffinity() => throw null;
        public virtual void CloseStream(System.IO.Stream stream) => throw null;
        public virtual void Config(System.Net.HttpWebRequest req, bool? allowAutoRedirect = default(bool?), System.TimeSpan? timeout = default(System.TimeSpan?), System.TimeSpan? readWriteTimeout = default(System.TimeSpan?), string userAgent = default(string), bool? preAuthenticate = default(bool?)) => throw null;
        public static void Configure(ServiceStack.PclExport instance) => throw null;
        public static bool ConfigureProvider(string typeName) => throw null;
        public virtual void CreateDirectory(string dirPath) => throw null;
        public virtual ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
        public virtual ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.FieldInfo fieldInfo) => throw null;
        public ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
        public ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
        public virtual ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
        public virtual ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.FieldInfo fieldInfo) => throw null;
        public ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
        public ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
        public virtual System.Net.HttpWebRequest CreateWebRequest(string requestUri, bool? emulateHttpViaPost = default(bool?)) => throw null;
        public System.Char DirSep;
        public static System.Char[] DirSeps;
        public virtual bool DirectoryExists(string dirPath) => throw null;
        public System.Threading.Tasks.Task EmptyTask;
        public virtual void EndThreadAffinity() => throw null;
        public virtual bool FileExists(string filePath) => throw null;
        public virtual System.Type FindType(string typeName, string assemblyName) => throw null;
        public virtual System.Reflection.Assembly[] GetAllAssemblies() => throw null;
        public virtual System.Byte[] GetAsciiBytes(string str) => throw null;
        public virtual string GetAsciiString(System.Byte[] bytes, int index, int count) => throw null;
        public virtual string GetAsciiString(System.Byte[] bytes) => throw null;
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
        public virtual bool InSameAssembly(System.Type t1, System.Type t2) => throw null;
        public virtual void InitHttpWebRequest(System.Net.HttpWebRequest httpReq, System.Int64? contentLength = default(System.Int64?), bool allowAutoRedirect = default(bool), bool keepAlive = default(bool)) => throw null;
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
        protected PclExport() => throw null;
        public string PlatformName;
        // Generated from `ServiceStack.PclExport+Platforms` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class Platforms
        {
            public const string Net45 = default;
            public const string NetCore = default;
            public const string NetStandard = default;
        }


        public abstract string ReadAllText(string filePath);
        public static ServiceStack.Text.ReflectionOptimizer Reflection { get => throw null; }
        public System.Text.RegularExpressions.RegexOptions RegexOptions;
        public virtual void RegisterForAot() => throw null;
        public virtual void RegisterLicenseFromConfig() => throw null;
        public virtual void ResetStream(System.IO.Stream stream) => throw null;
        public virtual void SetAllowAutoRedirect(System.Net.HttpWebRequest httpReq, bool value) => throw null;
        public virtual void SetContentLength(System.Net.HttpWebRequest httpReq, System.Int64 value) => throw null;
        public virtual void SetKeepAlive(System.Net.HttpWebRequest httpReq, bool value) => throw null;
        public virtual void SetUserAgent(System.Net.HttpWebRequest httpReq, string value) => throw null;
        public virtual string ToInvariantUpper(System.Char value) => throw null;
        public virtual string ToLocalXsdDateTimeString(System.DateTime dateTime) => throw null;
        public virtual System.DateTime ToStableUniversalTime(System.DateTime dateTime) => throw null;
        public virtual string ToXsdDateTimeString(System.DateTime dateTime) => throw null;
        public virtual ServiceStack.LicenseKey VerifyLicenseKeyText(string licenseKeyText) => throw null;
        public virtual ServiceStack.LicenseKey VerifyLicenseKeyTextFallback(string licenseKeyText) => throw null;
        public virtual System.Threading.Tasks.Task WriteAndFlushAsync(System.IO.Stream stream, System.Byte[] bytes) => throw null;
        public virtual void WriteLine(string line, params object[] args) => throw null;
        public virtual void WriteLine(string line) => throw null;
    }

    // Generated from `ServiceStack.PlatformExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class PlatformExtensions
    {
        public static System.Type AddAttributes(this System.Type type, params System.Attribute[] attrs) => throw null;
        public static System.Reflection.PropertyInfo AddAttributes(this System.Reflection.PropertyInfo propertyInfo, params System.Attribute[] attrs) => throw null;
        public static object[] AllAttributes(this System.Type type, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Type type) => throw null;
        public static object[] AllAttributes(this System.Reflection.PropertyInfo propertyInfo, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static object[] AllAttributes(this System.Reflection.ParameterInfo paramInfo, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Reflection.ParameterInfo paramInfo) => throw null;
        public static object[] AllAttributes(this System.Reflection.MemberInfo memberInfo, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Reflection.MemberInfo memberInfo) => throw null;
        public static object[] AllAttributes(this System.Reflection.FieldInfo fieldInfo, System.Type attrType) => throw null;
        public static object[] AllAttributes(this System.Reflection.FieldInfo fieldInfo) => throw null;
        public static object[] AllAttributes(this System.Reflection.Assembly assembly) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Type type) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Reflection.PropertyInfo pi) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Reflection.ParameterInfo pi) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Reflection.MemberInfo mi) => throw null;
        public static TAttr[] AllAttributes<TAttr>(this System.Reflection.FieldInfo fi) => throw null;
        public static System.Collections.Generic.IEnumerable<object> AllAttributesLazy(this System.Type type) => throw null;
        public static System.Collections.Generic.IEnumerable<object> AllAttributesLazy(this System.Reflection.PropertyInfo propertyInfo, System.Type attrType) => throw null;
        public static System.Collections.Generic.IEnumerable<object> AllAttributesLazy(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static System.Collections.Generic.IEnumerable<TAttr> AllAttributesLazy<TAttr>(this System.Type type) => throw null;
        public static System.Collections.Generic.IEnumerable<TAttr> AllAttributesLazy<TAttr>(this System.Reflection.PropertyInfo pi) => throw null;
        public static System.Reflection.PropertyInfo[] AllProperties(this System.Type type) => throw null;
        public static bool AssignableFrom(this System.Type type, System.Type fromType) => throw null;
        public static System.Type BaseType(this System.Type type) => throw null;
        public static void ClearRuntimeAttributes() => throw null;
        public static bool ContainsGenericParameters(this System.Type type) => throw null;
        public static System.Delegate CreateDelegate(this System.Reflection.MethodInfo methodInfo, System.Type delegateType, object target) => throw null;
        public static System.Delegate CreateDelegate(this System.Reflection.MethodInfo methodInfo, System.Type delegateType) => throw null;
        public static System.Reflection.ConstructorInfo[] DeclaredConstructors(this System.Type type) => throw null;
        public static System.Type ElementType(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo[] Fields(this System.Type type) => throw null;
        public static TAttribute FirstAttribute<TAttribute>(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static TAttribute FirstAttribute<TAttribute>(this System.Reflection.ParameterInfo paramInfo) => throw null;
        public static TAttribute FirstAttribute<TAttribute>(this System.Reflection.MemberInfo memberInfo) => throw null;
        public static TAttr FirstAttribute<TAttr>(this System.Type type) where TAttr : class => throw null;
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
        public static System.Collections.Generic.List<System.Attribute> GetAttributes(this System.Reflection.PropertyInfo propertyInfo, System.Type attrType) => throw null;
        public static System.Collections.Generic.List<System.Attribute> GetAttributes(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static System.Type GetCachedGenericType(this System.Type type, params System.Type[] argTypes) => throw null;
        public static System.Type GetCollectionType(this System.Type type) => throw null;
        public static string GetDeclaringTypeName(this System.Type type) => throw null;
        public static string GetDeclaringTypeName(this System.Reflection.MemberInfo mi) => throw null;
        public static System.Reflection.ConstructorInfo GetEmptyConstructor(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo GetFieldInfo(this System.Type type, string fieldName) => throw null;
        public static System.Reflection.MethodInfo GetInstanceMethod(this System.Type type, string methodName) => throw null;
        public static System.Reflection.MethodInfo[] GetInstanceMethods(this System.Type type) => throw null;
        public static System.Type GetKeyValuePairTypeDef(this System.Type genericEnumType) => throw null;
        public static bool GetKeyValuePairTypes(this System.Type kvpType, out System.Type keyType, out System.Type valueType) => throw null;
        public static System.Type GetKeyValuePairsTypeDef(this System.Type dictType) => throw null;
        public static bool GetKeyValuePairsTypes(this System.Type dictType, out System.Type keyType, out System.Type valueType, out System.Type kvpType) => throw null;
        public static bool GetKeyValuePairsTypes(this System.Type dictType, out System.Type keyType, out System.Type valueType) => throw null;
        public static System.Reflection.MethodInfo GetMethodInfo(this System.Type type, string methodName, System.Type[] types = default(System.Type[])) => throw null;
        public static System.Reflection.MethodInfo GetMethodInfo(this System.Reflection.PropertyInfo pi, bool nonPublic = default(bool)) => throw null;
        public static System.Reflection.MethodInfo[] GetMethodInfos(this System.Type type) => throw null;
        public static System.Reflection.PropertyInfo GetPropertyInfo(this System.Type type, string propertyName) => throw null;
        public static System.Reflection.PropertyInfo[] GetPropertyInfos(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo[] GetPublicFields(this System.Type type) => throw null;
        public static System.Reflection.MemberInfo[] GetPublicMembers(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo GetPublicStaticField(this System.Type type, string fieldName) => throw null;
        public static System.Reflection.MethodInfo GetStaticMethod(this System.Type type, string methodName, System.Type[] types) => throw null;
        public static System.Reflection.MethodInfo GetStaticMethod(this System.Type type, string methodName) => throw null;
        public static System.Type[] GetTypeGenericArguments(this System.Type type) => throw null;
        public static System.Type[] GetTypeInterfaces(this System.Type type) => throw null;
        public static System.Reflection.FieldInfo[] GetWritableFields(this System.Type type) => throw null;
        public static bool HasAttribute<T>(this System.Type type) => throw null;
        public static bool HasAttribute<T>(this System.Reflection.PropertyInfo pi) => throw null;
        public static bool HasAttribute<T>(this System.Reflection.MethodInfo mi) => throw null;
        public static bool HasAttribute<T>(this System.Reflection.FieldInfo fi) => throw null;
        public static bool HasAttributeCached<T>(this System.Reflection.MemberInfo memberInfo) => throw null;
        public static bool HasAttributeNamed(this System.Type type, string name) => throw null;
        public static bool HasAttributeNamed(this System.Reflection.PropertyInfo pi, string name) => throw null;
        public static bool HasAttributeNamed(this System.Reflection.MemberInfo mi, string name) => throw null;
        public static bool HasAttributeNamed(this System.Reflection.FieldInfo fi, string name) => throw null;
        public static bool HasAttributeOf<T>(this System.Type type) => throw null;
        public static bool HasAttributeOf<T>(this System.Reflection.PropertyInfo pi) => throw null;
        public static bool HasAttributeOf<T>(this System.Reflection.MethodInfo mi) => throw null;
        public static bool HasAttributeOf<T>(this System.Reflection.FieldInfo fi) => throw null;
        public static bool HasAttributeOfCached<T>(this System.Reflection.MemberInfo memberInfo) => throw null;
        public static bool InstanceOfType(this System.Type type, object instance) => throw null;
        public static System.Type[] Interfaces(this System.Type type) => throw null;
        public static object InvokeMethod(this System.Delegate fn, object instance, object[] parameters = default(object[])) => throw null;
        public static bool IsAbstract(this System.Type type) => throw null;
        public static bool IsArray(this System.Type type) => throw null;
        public static bool IsAssignableFromType(this System.Type type, System.Type fromType) => throw null;
        public static bool IsClass(this System.Type type) => throw null;
        public static bool IsDto(this System.Type type) => throw null;
        public static bool IsDynamic(this System.Reflection.Assembly assembly) => throw null;
        public static bool IsEnum(this System.Type type) => throw null;
        public static bool IsEnumFlags(this System.Type type) => throw null;
        public static bool IsGeneric(this System.Type type) => throw null;
        public static bool IsGenericType(this System.Type type) => throw null;
        public static bool IsGenericTypeDefinition(this System.Type type) => throw null;
        public static bool IsInterface(this System.Type type) => throw null;
        public static bool IsStandardClass(this System.Type type) => throw null;
        public static bool IsUnderlyingEnum(this System.Type type) => throw null;
        public static bool IsValueType(this System.Type type) => throw null;
        public static System.Delegate MakeDelegate(this System.Reflection.MethodInfo mi, System.Type delegateType, bool throwOnBindFailure = default(bool)) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> MergeIntoObjectDictionary(this object obj, params object[] sources) => throw null;
        public static System.Reflection.MethodInfo Method(this System.Delegate fn) => throw null;
        public static void PopulateInstance(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> values, object instance) => throw null;
        public static void PopulateInstance(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> values, object instance) => throw null;
        public static System.Reflection.PropertyInfo[] Properties(this System.Type type) => throw null;
        public static System.Reflection.MethodInfo PropertyGetMethod(this System.Reflection.PropertyInfo pi, bool nonPublic = default(bool)) => throw null;
        public static System.Type ReflectedType(this System.Reflection.PropertyInfo pi) => throw null;
        public static System.Type ReflectedType(this System.Reflection.FieldInfo fi) => throw null;
        public static System.Reflection.PropertyInfo ReplaceAttribute(this System.Reflection.PropertyInfo propertyInfo, System.Attribute attr) => throw null;
        public static System.Reflection.MethodInfo SetMethod(this System.Reflection.PropertyInfo pi, bool nonPublic = default(bool)) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> ToObjectDictionary(this object obj, System.Func<string, object, object> mapper) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> ToObjectDictionary(this object obj) => throw null;
        public static System.Collections.Generic.Dictionary<string, object> ToSafePartialObjectDictionary<T>(this T instance) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> ToStringDictionary(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> from, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> ToStringDictionary(this System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> from) => throw null;
    }

    // Generated from `ServiceStack.PopulateMemberDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate void PopulateMemberDelegate(object target, object source);

    // Generated from `ServiceStack.PropertyAccessor` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class PropertyAccessor
    {
        public PropertyAccessor(System.Reflection.PropertyInfo propertyInfo, ServiceStack.GetMemberDelegate publicGetter, ServiceStack.SetMemberDelegate publicSetter) => throw null;
        public System.Reflection.PropertyInfo PropertyInfo { get => throw null; }
        public ServiceStack.GetMemberDelegate PublicGetter { get => throw null; }
        public ServiceStack.SetMemberDelegate PublicSetter { get => throw null; }
    }

    // Generated from `ServiceStack.PropertyInvoker` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class PropertyInvoker
    {
        public static ServiceStack.GetMemberDelegate<T> CreateGetter<T>(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static ServiceStack.GetMemberDelegate CreateGetter(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static ServiceStack.SetMemberDelegate<T> CreateSetter<T>(this System.Reflection.PropertyInfo propertyInfo) => throw null;
        public static ServiceStack.SetMemberDelegate CreateSetter(this System.Reflection.PropertyInfo propertyInfo) => throw null;
    }

    // Generated from `ServiceStack.QueryStringSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class QueryStringSerializer
    {
        public static ServiceStack.WriteComplexTypeDelegate ComplexTypeStrategy { get => throw null; set => throw null; }
        public static void InitAot<T>() => throw null;
        public static string SerializeToString<T>(T value) => throw null;
        public static void WriteLateBoundObject(System.IO.TextWriter writer, object value) => throw null;
    }

    // Generated from `ServiceStack.QueryStringStrategy` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class QueryStringStrategy
    {
        public static bool FormUrlEncoded(System.IO.TextWriter writer, string propertyName, object obj) => throw null;
    }

    // Generated from `ServiceStack.QueryStringWriter<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class QueryStringWriter<T>
    {
        public static ServiceStack.Text.Common.WriteObjectDelegate WriteFn() => throw null;
        public static void WriteIDictionary(System.IO.TextWriter writer, object oMap) => throw null;
        public static void WriteObject(System.IO.TextWriter writer, object value) => throw null;
    }

    // Generated from `ServiceStack.QuotaType` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum QuotaType
    {
        Fields,
        Operations,
        PremiumFeature,
        RequestsPerHour,
        Tables,
        Types,
    }

    // Generated from `ServiceStack.ReflectionExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class ReflectionExtensions
    {
        public static bool AllHaveInterfacesOfType(this System.Type assignableFromType, params System.Type[] types) => throw null;
        public static bool AreAllStringOrValueTypes(params System.Type[] types) => throw null;
        public static object CreateInstance<T>() => throw null;
        public static object CreateInstance(this System.Type type) => throw null;
        public static object CreateInstance(string typeName) => throw null;
        public static T CreateInstance<T>(this System.Type type) => throw null;
        public const string DataMember = default;
        public static System.Type FirstGenericType(this System.Type type) => throw null;
        public static System.Reflection.PropertyInfo[] GetAllProperties(this System.Type type) => throw null;
        public static ServiceStack.EmptyCtorDelegate GetConstructorMethod(string typeName) => throw null;
        public static ServiceStack.EmptyCtorDelegate GetConstructorMethod(System.Type type) => throw null;
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
        public static bool HasAnyTypeDefinitionsOf(this System.Type genericType, params System.Type[] theseGenericTypes) => throw null;
        public static bool HasGenericType(this System.Type type) => throw null;
        public static bool HasInterface(this System.Type type, System.Type interfaceType) => throw null;
        public static bool IsInstanceOf(this System.Type type, System.Type thisOrBaseType) => throw null;
        public static bool IsIntegerType(this System.Type type) => throw null;
        public static bool IsNullableType(this System.Type type) => throw null;
        public static bool IsNumericType(this System.Type type) => throw null;
        public static bool IsOrHasGenericInterfaceTypeOf(this System.Type type, System.Type genericTypeDefinition) => throw null;
        public static bool IsRealNumberType(this System.Type type) => throw null;
        public static object New(this System.Type type) => throw null;
        public static T New<T>(this System.Type type) => throw null;
        public static System.Reflection.PropertyInfo[] OnlySerializableProperties(this System.Reflection.PropertyInfo[] properties, System.Type type = default(System.Type)) => throw null;
    }

    // Generated from `ServiceStack.SetMemberDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate void SetMemberDelegate(object instance, object value);

    // Generated from `ServiceStack.SetMemberDelegate<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate void SetMemberDelegate<T>(T instance, object value);

    // Generated from `ServiceStack.SetMemberRefDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate void SetMemberRefDelegate(ref object instance, object propertyValue);

    // Generated from `ServiceStack.SetMemberRefDelegate<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate void SetMemberRefDelegate<T>(ref T instance, object value);

    // Generated from `ServiceStack.StreamExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class StreamExtensions
    {
        public static int AsyncBufferSize;
        public static string CollapseWhitespace(this string str) => throw null;
        public static System.Byte[] Combine(this System.Byte[] bytes, params System.Byte[][] withBytes) => throw null;
        public static System.Int64 CopyTo(this System.IO.Stream input, System.IO.Stream output, int bufferSize) => throw null;
        public static System.Int64 CopyTo(this System.IO.Stream input, System.IO.Stream output, System.Byte[] buffer) => throw null;
        public static System.Int64 CopyTo(this System.IO.Stream input, System.IO.Stream output) => throw null;
        public static System.Threading.Tasks.Task<System.Int64> CopyToAsync(this System.IO.Stream input, System.IO.Stream output, System.Byte[] buffer, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task CopyToAsync(this System.IO.Stream input, System.IO.Stream output, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.IO.MemoryStream CopyToNewMemoryStream(this System.IO.Stream stream) => throw null;
        public static System.Threading.Tasks.Task<System.IO.MemoryStream> CopyToNewMemoryStreamAsync(this System.IO.Stream stream) => throw null;
        public const int DefaultBufferSize = default;
        public static System.Byte[] GetBufferAsBytes(this System.IO.MemoryStream ms) => throw null;
        public static System.ReadOnlyMemory<System.Byte> GetBufferAsMemory(this System.IO.MemoryStream ms) => throw null;
        public static System.ReadOnlySpan<System.Byte> GetBufferAsSpan(this System.IO.MemoryStream ms) => throw null;
        public static System.IO.MemoryStream InMemoryStream(this System.Byte[] bytes) => throw null;
        public static System.Byte[] ReadExactly(this System.IO.Stream input, int bytesToRead) => throw null;
        public static System.Byte[] ReadExactly(this System.IO.Stream input, System.Byte[] buffer, int startIndex, int bytesToRead) => throw null;
        public static System.Byte[] ReadExactly(this System.IO.Stream input, System.Byte[] buffer, int bytesToRead) => throw null;
        public static System.Byte[] ReadExactly(this System.IO.Stream input, System.Byte[] buffer) => throw null;
        public static System.Byte[] ReadFully(this System.IO.Stream input, int bufferSize) => throw null;
        public static System.Byte[] ReadFully(this System.IO.Stream input, System.Byte[] buffer) => throw null;
        public static System.Byte[] ReadFully(this System.IO.Stream input) => throw null;
        public static System.ReadOnlyMemory<System.Byte> ReadFullyAsMemory(this System.IO.Stream input, int bufferSize) => throw null;
        public static System.ReadOnlyMemory<System.Byte> ReadFullyAsMemory(this System.IO.Stream input, System.Byte[] buffer) => throw null;
        public static System.ReadOnlyMemory<System.Byte> ReadFullyAsMemory(this System.IO.Stream input) => throw null;
        public static System.Threading.Tasks.Task<System.ReadOnlyMemory<System.Byte>> ReadFullyAsMemoryAsync(this System.IO.Stream input, int bufferSize, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.ReadOnlyMemory<System.Byte>> ReadFullyAsMemoryAsync(this System.IO.Stream input, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.ReadOnlyMemory<System.Byte>> ReadFullyAsMemoryAsync(this System.IO.Stream input, System.Byte[] buffer, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.Byte[]> ReadFullyAsync(this System.IO.Stream input, int bufferSize, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.Byte[]> ReadFullyAsync(this System.IO.Stream input, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.Byte[]> ReadFullyAsync(this System.IO.Stream input, System.Byte[] buffer, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Collections.Generic.IEnumerable<string> ReadLines(this System.IO.Stream stream) => throw null;
        public static string ReadToEnd(this System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
        public static string ReadToEnd(this System.IO.Stream stream) => throw null;
        public static string ReadToEnd(this System.IO.MemoryStream ms, System.Text.Encoding encoding) => throw null;
        public static string ReadToEnd(this System.IO.MemoryStream ms) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.IO.Stream stream) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.IO.MemoryStream ms, System.Text.Encoding encoding) => throw null;
        public static System.Threading.Tasks.Task<string> ReadToEndAsync(this System.IO.MemoryStream ms) => throw null;
        public static string ToMd5Hash(this System.IO.Stream stream) => throw null;
        public static string ToMd5Hash(this System.Byte[] bytes) => throw null;
        public static System.Threading.Tasks.Task WriteAsync(this System.IO.Stream stream, string text, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task WriteAsync(this System.IO.Stream stream, System.ReadOnlyMemory<System.Byte> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task WriteAsync(this System.IO.Stream stream, System.Byte[] bytes, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Int64 WriteTo(this System.IO.Stream inStream, System.IO.Stream outStream) => throw null;
        public static System.Threading.Tasks.Task WriteToAsync(this System.IO.Stream stream, System.IO.Stream output, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task WriteToAsync(this System.IO.Stream stream, System.IO.Stream output, System.Text.Encoding encoding, System.Threading.CancellationToken token) => throw null;
        public static System.Threading.Tasks.Task WriteToAsync(this System.IO.MemoryStream stream, System.IO.Stream output, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task WriteToAsync(this System.IO.MemoryStream stream, System.IO.Stream output, System.Text.Encoding encoding, System.Threading.CancellationToken token) => throw null;
    }

    // Generated from `ServiceStack.StringDictionary` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class StringDictionary : System.Collections.Generic.Dictionary<string, string>
    {
        public StringDictionary(int capacity, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public StringDictionary(int capacity) => throw null;
        public StringDictionary(System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public StringDictionary(System.Collections.Generic.IDictionary<string, string> dictionary, System.Collections.Generic.IEqualityComparer<string> comparer) => throw null;
        public StringDictionary(System.Collections.Generic.IDictionary<string, string> dictionary) => throw null;
        public StringDictionary() => throw null;
        protected StringDictionary(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
    }

    // Generated from `ServiceStack.StringExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class StringExtensions
    {
        public static string AppendPath(this string uri, params string[] uriComponents) => throw null;
        public static string AppendUrlPaths(this string uri, params string[] uriComponents) => throw null;
        public static string AppendUrlPathsRaw(this string uri, params string[] uriComponents) => throw null;
        public static string BaseConvert(this string source, int from, int to) => throw null;
        public static int CompareIgnoreCase(this string strA, string strB) => throw null;
        public static bool ContainsAny(this string text, string[] testMatches, System.StringComparison comparisonType) => throw null;
        public static bool ContainsAny(this string text, params string[] testMatches) => throw null;
        public static int CountOccurrencesOf(this string text, System.Char needle) => throw null;
        public static void CreateDirectory(this string dirPath) => throw null;
        public static string DecodeJsv(this string value) => throw null;
        public static bool DirectoryExists(this string dirPath) => throw null;
        public static string EncodeJson(this string value) => throw null;
        public static string EncodeJsv(this string value) => throw null;
        public static string EncodeXml(this string value) => throw null;
        public static bool EndsWithIgnoreCase(this string text, string endsWith) => throw null;
        public static bool EndsWithInvariant(this string str, string endsWith) => throw null;
        public static bool EqualsIgnoreCase(this string value, string other) => throw null;
        public static string ExtractContents(this string fromText, string uniqueMarker, string startAfter, string endAt) => throw null;
        public static string ExtractContents(this string fromText, string startAfter, string endAt) => throw null;
        public static bool FileExists(this string filePath) => throw null;
        public static string Fmt(this string text, params object[] args) => throw null;
        public static string Fmt(this string text, object arg1, object arg2, object arg3) => throw null;
        public static string Fmt(this string text, object arg1, object arg2) => throw null;
        public static string Fmt(this string text, object arg1) => throw null;
        public static string Fmt(this string text, System.IFormatProvider provider, params object[] args) => throw null;
        public static string FormatWith(this string text, params object[] args) => throw null;
        public static string FromAsciiBytes(this System.Byte[] bytes) => throw null;
        public static System.Byte[] FromBase64UrlSafe(this string input) => throw null;
        public static T FromCsv<T>(this string csv) => throw null;
        public static T FromJson<T>(this string json) => throw null;
        public static T FromJsonSpan<T>(this System.ReadOnlySpan<System.Char> json) => throw null;
        public static T FromJsv<T>(this string jsv) => throw null;
        public static T FromJsvSpan<T>(this System.ReadOnlySpan<System.Char> jsv) => throw null;
        public static string FromUtf8Bytes(this System.Byte[] bytes) => throw null;
        public static T FromXml<T>(this string json) => throw null;
        public static string GetExtension(this string filePath) => throw null;
        public static bool Glob(this string value, string pattern) => throw null;
        public static bool GlobPath(this string filePath, string pattern) => throw null;
        public static string HexEscape(this string text, params System.Char[] anyCharOf) => throw null;
        public static string HexUnescape(this string text, params System.Char[] anyCharOf) => throw null;
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
        public static string Join(this System.Collections.Generic.List<string> items, string delimeter) => throw null;
        public static string Join(this System.Collections.Generic.List<string> items) => throw null;
        public static string LastLeftPart(this string strVal, string needle) => throw null;
        public static string LastLeftPart(this string strVal, System.Char needle) => throw null;
        public static string LastRightPart(this string strVal, string needle) => throw null;
        public static string LastRightPart(this string strVal, System.Char needle) => throw null;
        public static string LeftPart(this string strVal, string needle) => throw null;
        public static string LeftPart(this string strVal, System.Char needle) => throw null;
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
        public static string RightPart(this string strVal, string needle) => throw null;
        public static string RightPart(this string strVal, System.Char needle) => throw null;
        public static string SafeSubstring(this string value, int startIndex, int length) => throw null;
        public static string SafeSubstring(this string value, int startIndex) => throw null;
        public static string SafeVarName(this string text) => throw null;
        public static string SafeVarRef(this string text) => throw null;
        public static string SplitCamelCase(this string value) => throw null;
        public static string[] SplitOnFirst(this string strVal, string needle) => throw null;
        public static string[] SplitOnFirst(this string strVal, System.Char needle) => throw null;
        public static string[] SplitOnLast(this string strVal, string needle) => throw null;
        public static string[] SplitOnLast(this string strVal, System.Char needle) => throw null;
        public static bool StartsWithIgnoreCase(this string text, string startsWith) => throw null;
        public static string StripHtml(this string html) => throw null;
        public static string StripMarkdownMarkup(this string markdown) => throw null;
        public static string StripQuotes(this string text) => throw null;
        public static string SubstringWithElipsis(this string value, int startIndex, int length) => throw null;
        public static string SubstringWithEllipsis(this string value, int startIndex, int length) => throw null;
        public static System.Byte[] ToAsciiBytes(this string value) => throw null;
        public static string ToBase64UrlSafe(this System.IO.MemoryStream ms) => throw null;
        public static string ToBase64UrlSafe(this System.Byte[] input) => throw null;
        public static string ToCamelCase(this string value) => throw null;
        public static string ToCsv<T>(this T obj) => throw null;
        public static System.Decimal ToDecimal(this string text, System.Decimal defaultValue) => throw null;
        public static System.Decimal ToDecimal(this string text) => throw null;
        public static System.Decimal ToDecimalInvariant(this string text) => throw null;
        public static double ToDouble(this string text, double defaultValue) => throw null;
        public static double ToDouble(this string text) => throw null;
        public static double ToDoubleInvariant(this string text) => throw null;
        public static string ToEnglish(this string camelCase) => throw null;
        public static T ToEnum<T>(this string value) => throw null;
        public static T ToEnumOrDefault<T>(this string value, T defaultValue) => throw null;
        public static float ToFloat(this string text, float defaultValue) => throw null;
        public static float ToFloat(this string text) => throw null;
        public static float ToFloatInvariant(this string text) => throw null;
        public static string ToHex(this System.Byte[] hashBytes, bool upper = default(bool)) => throw null;
        public static string ToHttps(this string url) => throw null;
        public static int ToInt(this string text, int defaultValue) => throw null;
        public static int ToInt(this string text) => throw null;
        public static System.Int64 ToInt64(this string text, System.Int64 defaultValue) => throw null;
        public static System.Int64 ToInt64(this string text) => throw null;
        public static string ToInvariantUpper(this System.Char value) => throw null;
        public static string ToJson<T>(this T obj) => throw null;
        public static string ToJsv<T>(this T obj) => throw null;
        public static System.Int64 ToLong(this string text, System.Int64 defaultValue) => throw null;
        public static System.Int64 ToLong(this string text) => throw null;
        public static string ToLowerSafe(this string value) => throw null;
        public static string ToLowercaseUnderscore(this string value) => throw null;
        public static string ToNullIfEmpty(this string text) => throw null;
        public static string ToParentPath(this string path) => throw null;
        public static string ToPascalCase(this string value) => throw null;
        public static string ToRot13(this string value) => throw null;
        public static string ToSafeJson<T>(this T obj) => throw null;
        public static string ToSafeJsv<T>(this T obj) => throw null;
        public static string ToTitleCase(this string value) => throw null;
        public static string ToUpperSafe(this string value) => throw null;
        public static System.Byte[] ToUtf8Bytes(this string value) => throw null;
        public static System.Byte[] ToUtf8Bytes(this int intVal) => throw null;
        public static System.Byte[] ToUtf8Bytes(this double doubleVal) => throw null;
        public static System.Byte[] ToUtf8Bytes(this System.UInt64 ulongVal) => throw null;
        public static System.Byte[] ToUtf8Bytes(this System.Int64 longVal) => throw null;
        public static string ToXml<T>(this T obj) => throw null;
        public static string TrimPrefixes(this string fromString, params string[] prefixes) => throw null;
        public static string UrlDecode(this string text) => throw null;
        public static string UrlEncode(this string text, bool upperCase = default(bool)) => throw null;
        public static string UrlFormat(this string url, params string[] urlComponents) => throw null;
        public static string UrlWithTrailingSlash(this string url) => throw null;
        public static string WithTrailingSlash(this string path) => throw null;
        public static string WithoutBom(this string value) => throw null;
        public static string WithoutExtension(this string filePath) => throw null;
    }

    // Generated from `ServiceStack.TaskExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class TaskExtensions
    {
        public static System.Threading.Tasks.Task<T> Error<T>(this System.Threading.Tasks.Task<T> task, System.Action<System.Exception> fn, bool onUiThread = default(bool), System.Threading.Tasks.TaskContinuationOptions taskOptions = default(System.Threading.Tasks.TaskContinuationOptions)) => throw null;
        public static System.Threading.Tasks.Task Error(this System.Threading.Tasks.Task task, System.Action<System.Exception> fn, bool onUiThread = default(bool), System.Threading.Tasks.TaskContinuationOptions taskOptions = default(System.Threading.Tasks.TaskContinuationOptions)) => throw null;
        public static System.Threading.Tasks.Task<T> Success<T>(this System.Threading.Tasks.Task<T> task, System.Action<T> fn, bool onUiThread = default(bool), System.Threading.Tasks.TaskContinuationOptions taskOptions = default(System.Threading.Tasks.TaskContinuationOptions)) => throw null;
        public static System.Threading.Tasks.Task Success(this System.Threading.Tasks.Task task, System.Action fn, bool onUiThread = default(bool), System.Threading.Tasks.TaskContinuationOptions taskOptions = default(System.Threading.Tasks.TaskContinuationOptions)) => throw null;
        public static System.Exception UnwrapIfSingleException<T>(this System.Threading.Tasks.Task<T> task) => throw null;
        public static System.Exception UnwrapIfSingleException(this System.Threading.Tasks.Task task) => throw null;
        public static System.Exception UnwrapIfSingleException(this System.Exception ex) => throw null;
    }

    // Generated from `ServiceStack.TaskResult` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class TaskResult
    {
        public static System.Threading.Tasks.Task Canceled;
        public static System.Threading.Tasks.Task<bool> False;
        public static System.Threading.Tasks.Task Finished;
        public static System.Threading.Tasks.Task<int> One;
        public static System.Threading.Tasks.Task<bool> True;
        public static System.Threading.Tasks.Task<int> Zero;
    }

    // Generated from `ServiceStack.TaskUtils` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

    // Generated from `ServiceStack.TextExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class TextExtensions
    {
        public static string FromCsvField(this string text) => throw null;
        public static string[] FromCsvFields(params string[] texts) => throw null;
        public static System.Collections.Generic.List<string> FromCsvFields(this System.Collections.Generic.IEnumerable<string> texts) => throw null;
        public static string SerializeToString<T>(this T value) => throw null;
        public static string ToCsvField(this string text) => throw null;
        public static object ToCsvField(this object text) => throw null;
    }

    // Generated from `ServiceStack.TypeConstants` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class TypeConstants
    {
        public static bool[] EmptyBoolArray;
        public static System.Collections.Generic.List<bool> EmptyBoolList;
        public static System.Byte[] EmptyByteArray;
        public static System.Byte[][] EmptyByteArrayArray;
        public static System.Collections.Generic.List<System.Byte> EmptyByteList;
        public static System.Char[] EmptyCharArray;
        public static System.Collections.Generic.List<System.Char> EmptyCharList;
        public static System.Reflection.FieldInfo[] EmptyFieldInfoArray;
        public static System.Collections.Generic.List<System.Reflection.FieldInfo> EmptyFieldInfoList;
        public static int[] EmptyIntArray;
        public static System.Collections.Generic.List<int> EmptyIntList;
        public static System.Int64[] EmptyLongArray;
        public static System.Collections.Generic.List<System.Int64> EmptyLongList;
        public static object EmptyObject;
        public static object[] EmptyObjectArray;
        public static System.Collections.Generic.Dictionary<string, object> EmptyObjectDictionary;
        public static System.Collections.Generic.List<object> EmptyObjectList;
        public static System.Reflection.PropertyInfo[] EmptyPropertyInfoArray;
        public static System.Collections.Generic.List<System.Reflection.PropertyInfo> EmptyPropertyInfoList;
        public static string[] EmptyStringArray;
        public static System.Collections.Generic.Dictionary<string, string> EmptyStringDictionary;
        public static System.Collections.Generic.List<string> EmptyStringList;
        public static System.ReadOnlyMemory<System.Char> EmptyStringMemory { get => throw null; }
        public static System.ReadOnlySpan<System.Char> EmptyStringSpan { get => throw null; }
        public static System.Threading.Tasks.Task<object> EmptyTask;
        public static System.Type[] EmptyTypeArray;
        public static System.Collections.Generic.List<System.Type> EmptyTypeList;
        public static System.Threading.Tasks.Task<bool> FalseTask;
        public const System.Char NonWidthWhiteSpace = default;
        public static System.Char[] NonWidthWhiteSpaceChars;
        public static System.ReadOnlyMemory<System.Char> NullStringMemory { get => throw null; }
        public static System.ReadOnlySpan<System.Char> NullStringSpan { get => throw null; }
        public static System.Threading.Tasks.Task<bool> TrueTask;
        public static System.Threading.Tasks.Task<int> ZeroTask;
    }

    // Generated from `ServiceStack.TypeConstants<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class TypeConstants<T>
    {
        public static T[] EmptyArray;
        public static System.Collections.Generic.HashSet<T> EmptyHashSet;
        public static System.Collections.Generic.List<T> EmptyList;
    }

    // Generated from `ServiceStack.TypeFields` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class TypeFields
    {
        public static System.Type FactoryType;
        public System.Collections.Generic.Dictionary<string, ServiceStack.FieldAccessor> FieldsMap;
        public static ServiceStack.TypeFields Get(System.Type type) => throw null;
        public ServiceStack.FieldAccessor GetAccessor(string propertyName) => throw null;
        public virtual System.Reflection.FieldInfo GetPublicField(string name) => throw null;
        public virtual ServiceStack.GetMemberDelegate GetPublicGetter(string name) => throw null;
        public virtual ServiceStack.GetMemberDelegate GetPublicGetter(System.Reflection.FieldInfo fi) => throw null;
        public virtual ServiceStack.SetMemberDelegate GetPublicSetter(string name) => throw null;
        public virtual ServiceStack.SetMemberDelegate GetPublicSetter(System.Reflection.FieldInfo fi) => throw null;
        public virtual ServiceStack.SetMemberRefDelegate GetPublicSetterRef(string name) => throw null;
        public System.Reflection.FieldInfo[] PublicFieldInfos { get => throw null; set => throw null; }
        public System.Type Type { get => throw null; set => throw null; }
        protected TypeFields() => throw null;
    }

    // Generated from `ServiceStack.TypeFields<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class TypeFields<T> : ServiceStack.TypeFields
    {
        public static ServiceStack.FieldAccessor GetAccessor(string propertyName) => throw null;
        public static ServiceStack.TypeFields<T> Instance;
        public TypeFields() => throw null;
    }

    // Generated from `ServiceStack.TypeProperties` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class TypeProperties
    {
        public static System.Type FactoryType;
        public static ServiceStack.TypeProperties Get(System.Type type) => throw null;
        public ServiceStack.PropertyAccessor GetAccessor(string propertyName) => throw null;
        public ServiceStack.GetMemberDelegate GetPublicGetter(string name) => throw null;
        public ServiceStack.GetMemberDelegate GetPublicGetter(System.Reflection.PropertyInfo pi) => throw null;
        public System.Reflection.PropertyInfo GetPublicProperty(string name) => throw null;
        public ServiceStack.SetMemberDelegate GetPublicSetter(string name) => throw null;
        public ServiceStack.SetMemberDelegate GetPublicSetter(System.Reflection.PropertyInfo pi) => throw null;
        public System.Collections.Generic.Dictionary<string, ServiceStack.PropertyAccessor> PropertyMap;
        public System.Reflection.PropertyInfo[] PublicPropertyInfos { get => throw null; set => throw null; }
        public System.Type Type { get => throw null; set => throw null; }
        protected TypeProperties() => throw null;
    }

    // Generated from `ServiceStack.TypeProperties<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class TypeProperties<T> : ServiceStack.TypeProperties
    {
        public static ServiceStack.PropertyAccessor GetAccessor(string propertyName) => throw null;
        public static ServiceStack.TypeProperties<T> Instance;
        public TypeProperties() => throw null;
    }

    // Generated from `ServiceStack.WriteComplexTypeDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public delegate bool WriteComplexTypeDelegate(System.IO.TextWriter writer, string propertyName, object obj);

    namespace Extensions
    {
        // Generated from `ServiceStack.Extensions.ServiceStackExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class ServiceStackExtensions
        {
            public static System.ReadOnlyMemory<System.Char> Trim(this System.ReadOnlyMemory<System.Char> span) => throw null;
            public static System.ReadOnlyMemory<System.Char> TrimEnd(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.ReadOnlyMemory<System.Char> TrimStart(this System.ReadOnlyMemory<System.Char> value) => throw null;
        }

    }
    namespace Memory
    {
        // Generated from `ServiceStack.Memory.NetCoreMemory` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class NetCoreMemory : ServiceStack.Text.MemoryProvider
        {
            public override System.Text.StringBuilder Append(System.Text.StringBuilder sb, System.ReadOnlySpan<System.Char> value) => throw null;
            public static void Configure() => throw null;
            public override object Deserialize(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer) => throw null;
            public override System.Threading.Tasks.Task<object> DeserializeAsync(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer) => throw null;
            public override int FromUtf8(System.ReadOnlySpan<System.Byte> source, System.Span<System.Char> destination) => throw null;
            public override System.ReadOnlyMemory<System.Char> FromUtf8(System.ReadOnlySpan<System.Byte> source) => throw null;
            public override string FromUtf8Bytes(System.ReadOnlySpan<System.Byte> source) => throw null;
            public override int GetUtf8ByteCount(System.ReadOnlySpan<System.Char> chars) => throw null;
            public override int GetUtf8CharCount(System.ReadOnlySpan<System.Byte> bytes) => throw null;
            public override System.Byte[] ParseBase64(System.ReadOnlySpan<System.Char> value) => throw null;
            public override bool ParseBoolean(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Byte ParseByte(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Decimal ParseDecimal(System.ReadOnlySpan<System.Char> value, bool allowThousands) => throw null;
            public override System.Decimal ParseDecimal(System.ReadOnlySpan<System.Char> value) => throw null;
            public override double ParseDouble(System.ReadOnlySpan<System.Char> value) => throw null;
            public override float ParseFloat(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Guid ParseGuid(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Int16 ParseInt16(System.ReadOnlySpan<System.Char> value) => throw null;
            public override int ParseInt32(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Int64 ParseInt64(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.SByte ParseSByte(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.UInt16 ParseUInt16(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.UInt32 ParseUInt32(System.ReadOnlySpan<System.Char> value, System.Globalization.NumberStyles style) => throw null;
            public override System.UInt32 ParseUInt32(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.UInt64 ParseUInt64(System.ReadOnlySpan<System.Char> value) => throw null;
            public static ServiceStack.Memory.NetCoreMemory Provider { get => throw null; }
            public override string ToBase64(System.ReadOnlyMemory<System.Byte> value) => throw null;
            public override System.IO.MemoryStream ToMemoryStream(System.ReadOnlySpan<System.Byte> source) => throw null;
            public override int ToUtf8(System.ReadOnlySpan<System.Char> source, System.Span<System.Byte> destination) => throw null;
            public override System.ReadOnlyMemory<System.Byte> ToUtf8(System.ReadOnlySpan<System.Char> source) => throw null;
            public override System.Byte[] ToUtf8Bytes(System.ReadOnlySpan<System.Char> source) => throw null;
            public override bool TryParseBoolean(System.ReadOnlySpan<System.Char> value, out bool result) => throw null;
            public override bool TryParseDecimal(System.ReadOnlySpan<System.Char> value, out System.Decimal result) => throw null;
            public override bool TryParseDouble(System.ReadOnlySpan<System.Char> value, out double result) => throw null;
            public override bool TryParseFloat(System.ReadOnlySpan<System.Char> value, out float result) => throw null;
            public override void Write(System.IO.Stream stream, System.ReadOnlyMemory<System.Char> value) => throw null;
            public override void Write(System.IO.Stream stream, System.ReadOnlyMemory<System.Byte> value) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlySpan<System.Char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<System.Char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<System.Byte> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }

    }
    namespace Text
    {
        // Generated from `ServiceStack.Text.AssemblyUtils` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class AssemblyUtils
        {
            public static System.Type FindType(string typeName, string assemblyName) => throw null;
            public static System.Type FindType(string typeName) => throw null;
            public static System.Type FindTypeFromLoadedAssemblies(string typeName) => throw null;
            public static string GetAssemblyBinPath(System.Reflection.Assembly assembly) => throw null;
            public static System.Reflection.Assembly LoadAssembly(string assemblyPath) => throw null;
            public static System.Type MainInterface<T>() => throw null;
            public static string ToTypeString(this System.Type type) => throw null;
            public static string WriteType(System.Type type) => throw null;
        }

        // Generated from `ServiceStack.Text.CachedTypeInfo` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CachedTypeInfo
        {
            public CachedTypeInfo(System.Type type) => throw null;
            public ServiceStack.Text.EnumInfo EnumInfo { get => throw null; }
            public static ServiceStack.Text.CachedTypeInfo Get(System.Type type) => throw null;
        }

        // Generated from `ServiceStack.Text.CharMemoryExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class CharMemoryExtensions
        {
            public static System.ReadOnlyMemory<System.Char> Advance(this System.ReadOnlyMemory<System.Char> text, int to) => throw null;
            public static System.ReadOnlyMemory<System.Char> AdvancePastChar(this System.ReadOnlyMemory<System.Char> literal, System.Char delim) => throw null;
            public static System.ReadOnlyMemory<System.Char> AdvancePastWhitespace(this System.ReadOnlyMemory<System.Char> literal) => throw null;
            public static bool EndsWith(this System.ReadOnlyMemory<System.Char> value, string other, System.StringComparison comparison) => throw null;
            public static bool EndsWith(this System.ReadOnlyMemory<System.Char> value, string other) => throw null;
            public static bool EqualsOrdinal(this System.ReadOnlyMemory<System.Char> value, string other) => throw null;
            public static bool EqualsOrdinal(this System.ReadOnlyMemory<System.Char> value, System.ReadOnlyMemory<System.Char> other) => throw null;
            public static System.ReadOnlyMemory<System.Char> FromUtf8(this System.ReadOnlyMemory<System.Byte> bytes) => throw null;
            public static int IndexOf(this System.ReadOnlyMemory<System.Char> value, string needle, int start) => throw null;
            public static int IndexOf(this System.ReadOnlyMemory<System.Char> value, string needle) => throw null;
            public static int IndexOf(this System.ReadOnlyMemory<System.Char> value, System.Char needle, int start) => throw null;
            public static int IndexOf(this System.ReadOnlyMemory<System.Char> value, System.Char needle) => throw null;
            public static bool IsNullOrEmpty(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static bool IsNullOrWhiteSpace(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static bool IsWhiteSpace(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static int LastIndexOf(this System.ReadOnlyMemory<System.Char> value, string needle, int start) => throw null;
            public static int LastIndexOf(this System.ReadOnlyMemory<System.Char> value, string needle) => throw null;
            public static int LastIndexOf(this System.ReadOnlyMemory<System.Char> value, System.Char needle, int start) => throw null;
            public static int LastIndexOf(this System.ReadOnlyMemory<System.Char> value, System.Char needle) => throw null;
            public static System.ReadOnlyMemory<System.Char> LastLeftPart(this System.ReadOnlyMemory<System.Char> strVal, string needle) => throw null;
            public static System.ReadOnlyMemory<System.Char> LastLeftPart(this System.ReadOnlyMemory<System.Char> strVal, System.Char needle) => throw null;
            public static System.ReadOnlyMemory<System.Char> LastRightPart(this System.ReadOnlyMemory<System.Char> strVal, string needle) => throw null;
            public static System.ReadOnlyMemory<System.Char> LastRightPart(this System.ReadOnlyMemory<System.Char> strVal, System.Char needle) => throw null;
            public static System.ReadOnlyMemory<System.Char> LeftPart(this System.ReadOnlyMemory<System.Char> strVal, string needle) => throw null;
            public static System.ReadOnlyMemory<System.Char> LeftPart(this System.ReadOnlyMemory<System.Char> strVal, System.Char needle) => throw null;
            public static bool ParseBoolean(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.Byte ParseByte(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.Decimal ParseDecimal(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static double ParseDouble(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static float ParseFloat(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.Guid ParseGuid(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.Int16 ParseInt16(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static int ParseInt32(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.Int64 ParseInt64(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.SByte ParseSByte(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.UInt16 ParseUInt16(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.UInt32 ParseUInt32(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.UInt64 ParseUInt64(this System.ReadOnlyMemory<System.Char> value) => throw null;
            public static System.ReadOnlyMemory<System.Char> RightPart(this System.ReadOnlyMemory<System.Char> strVal, string needle) => throw null;
            public static System.ReadOnlyMemory<System.Char> RightPart(this System.ReadOnlyMemory<System.Char> strVal, System.Char needle) => throw null;
            public static System.ReadOnlyMemory<System.Char> SafeSlice(this System.ReadOnlyMemory<System.Char> value, int startIndex, int length) => throw null;
            public static System.ReadOnlyMemory<System.Char> SafeSlice(this System.ReadOnlyMemory<System.Char> value, int startIndex) => throw null;
            public static void SplitOnFirst(this System.ReadOnlyMemory<System.Char> strVal, System.ReadOnlyMemory<System.Char> needle, out System.ReadOnlyMemory<System.Char> first, out System.ReadOnlyMemory<System.Char> last) => throw null;
            public static void SplitOnFirst(this System.ReadOnlyMemory<System.Char> strVal, System.Char needle, out System.ReadOnlyMemory<System.Char> first, out System.ReadOnlyMemory<System.Char> last) => throw null;
            public static void SplitOnLast(this System.ReadOnlyMemory<System.Char> strVal, System.ReadOnlyMemory<System.Char> needle, out System.ReadOnlyMemory<System.Char> first, out System.ReadOnlyMemory<System.Char> last) => throw null;
            public static void SplitOnLast(this System.ReadOnlyMemory<System.Char> strVal, System.Char needle, out System.ReadOnlyMemory<System.Char> first, out System.ReadOnlyMemory<System.Char> last) => throw null;
            public static bool StartsWith(this System.ReadOnlyMemory<System.Char> value, string other, System.StringComparison comparison) => throw null;
            public static bool StartsWith(this System.ReadOnlyMemory<System.Char> value, string other) => throw null;
            public static string SubstringWithEllipsis(this System.ReadOnlyMemory<System.Char> value, int startIndex, int length) => throw null;
            public static System.ReadOnlyMemory<System.Byte> ToUtf8(this System.ReadOnlyMemory<System.Char> chars) => throw null;
            public static bool TryParseBoolean(this System.ReadOnlyMemory<System.Char> value, out bool result) => throw null;
            public static bool TryParseDecimal(this System.ReadOnlyMemory<System.Char> value, out System.Decimal result) => throw null;
            public static bool TryParseDouble(this System.ReadOnlyMemory<System.Char> value, out double result) => throw null;
            public static bool TryParseFloat(this System.ReadOnlyMemory<System.Char> value, out float result) => throw null;
            public static bool TryReadLine(this System.ReadOnlyMemory<System.Char> text, out System.ReadOnlyMemory<System.Char> line, ref int startIndex) => throw null;
            public static bool TryReadPart(this System.ReadOnlyMemory<System.Char> text, System.ReadOnlyMemory<System.Char> needle, out System.ReadOnlyMemory<System.Char> part, ref int startIndex) => throw null;
        }

        // Generated from `ServiceStack.Text.Config` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class Config
        {
            public bool AlwaysUseUtc { get => throw null; set => throw null; }
            public bool AppendUtcOffset { get => throw null; set => throw null; }
            public static ServiceStack.Text.Config AssertNotInit() => throw null;
            public bool AssumeUtc { get => throw null; set => throw null; }
            public Config() => throw null;
            public bool ConvertObjectTypesIntoStringDictionary { get => throw null; set => throw null; }
            public ServiceStack.Text.DateHandler DateHandler { get => throw null; set => throw null; }
            public string DateTimeFormat { get => throw null; set => throw null; }
            public static ServiceStack.Text.Config Defaults { get => throw null; }
            public bool EmitCamelCaseNames { get => throw null; set => throw null; }
            public bool EmitLowercaseUnderscoreNames { get => throw null; set => throw null; }
            public bool EscapeHtmlChars { get => throw null; set => throw null; }
            public bool EscapeUnicode { get => throw null; set => throw null; }
            public bool ExcludeDefaultValues { get => throw null; set => throw null; }
            public string[] ExcludePropertyReferences { get => throw null; set => throw null; }
            public bool ExcludeTypeInfo { get => throw null; set => throw null; }
            public System.Collections.Generic.HashSet<string> ExcludeTypeNames { get => throw null; set => throw null; }
            public System.Collections.Generic.HashSet<System.Type> ExcludeTypes { get => throw null; set => throw null; }
            public bool IncludeDefaultEnums { get => throw null; set => throw null; }
            public bool IncludeNullValues { get => throw null; set => throw null; }
            public bool IncludeNullValuesInDictionaries { get => throw null; set => throw null; }
            public bool IncludePublicFields { get => throw null; set => throw null; }
            public bool IncludeTypeInfo { get => throw null; set => throw null; }
            public static void Init(ServiceStack.Text.Config config) => throw null;
            public static void Init() => throw null;
            public int MaxDepth { get => throw null; set => throw null; }
            public ServiceStack.EmptyCtorFactoryDelegate ModelFactory { get => throw null; set => throw null; }
            public ServiceStack.Text.Common.DeserializationErrorDelegate OnDeserializationError { get => throw null; set => throw null; }
            public ServiceStack.Text.ParseAsType ParsePrimitiveFloatingPointTypes { get => throw null; set => throw null; }
            public System.Func<string, object> ParsePrimitiveFn { get => throw null; set => throw null; }
            public ServiceStack.Text.ParseAsType ParsePrimitiveIntegerTypes { get => throw null; set => throw null; }
            public ServiceStack.Text.Config Populate(ServiceStack.Text.Config config) => throw null;
            public bool PreferInterfaces { get => throw null; set => throw null; }
            public ServiceStack.Text.PropertyConvention PropertyConvention { get => throw null; set => throw null; }
            public bool SkipDateTimeConversion { get => throw null; set => throw null; }
            public ServiceStack.Text.TextCase TextCase { get => throw null; set => throw null; }
            public bool ThrowOnError { get => throw null; set => throw null; }
            public ServiceStack.Text.TimeSpanHandler TimeSpanHandler { get => throw null; set => throw null; }
            public bool TreatEnumAsInteger { get => throw null; set => throw null; }
            public bool TryParseIntoBestFit { get => throw null; set => throw null; }
            public bool TryToParseNumericType { get => throw null; set => throw null; }
            public bool TryToParsePrimitiveTypeValues { get => throw null; set => throw null; }
            public string TypeAttr { get => throw null; set => throw null; }
            public System.ReadOnlyMemory<System.Char> TypeAttrMemory { get => throw null; }
            public System.Func<string, System.Type> TypeFinder { get => throw null; set => throw null; }
            public System.Func<System.Type, string> TypeWriter { get => throw null; set => throw null; }
            public static void UnsafeInit(ServiceStack.Text.Config config) => throw null;
        }

        // Generated from `ServiceStack.Text.ConvertibleTypeKey` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ConvertibleTypeKey
        {
            public ConvertibleTypeKey(System.Type toInstanceType, System.Type fromElementType) => throw null;
            public ConvertibleTypeKey() => throw null;
            public override bool Equals(object obj) => throw null;
            public bool Equals(ServiceStack.Text.ConvertibleTypeKey other) => throw null;
            public System.Type FromElementType { get => throw null; set => throw null; }
            public override int GetHashCode() => throw null;
            public System.Type ToInstanceType { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Text.CsvAttribute` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CsvAttribute : System.Attribute
        {
            public CsvAttribute(ServiceStack.Text.CsvBehavior csvBehavior) => throw null;
            public ServiceStack.Text.CsvBehavior CsvBehavior { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Text.CsvBehavior` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public enum CsvBehavior
        {
            FirstEnumerable,
        }

        // Generated from `ServiceStack.Text.CsvConfig` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class CsvConfig
        {
            public static string[] EscapeStrings { get => throw null; set => throw null; }
            public static string ItemDelimiterString { get => throw null; set => throw null; }
            public static string ItemSeperatorString { get => throw null; set => throw null; }
            public static System.Globalization.CultureInfo RealNumberCultureInfo { get => throw null; set => throw null; }
            public static void Reset() => throw null;
            public static string RowSeparatorString { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Text.CsvConfig<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class CsvConfig<T>
        {
            public static object CustomHeaders { set => throw null; }
            public static System.Collections.Generic.Dictionary<string, string> CustomHeadersMap { get => throw null; set => throw null; }
            public static bool OmitHeaders { get => throw null; set => throw null; }
            public static void Reset() => throw null;
        }

        // Generated from `ServiceStack.Text.CsvReader` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CsvReader
        {
            public CsvReader() => throw null;
            public static string EatValue(string value, ref int i) => throw null;
            public static System.Collections.Generic.List<string> ParseFields(string line, System.Func<string, string> parseFn) => throw null;
            public static System.Collections.Generic.List<string> ParseFields(string line) => throw null;
            public static System.Collections.Generic.List<string> ParseLines(string csv) => throw null;
        }

        // Generated from `ServiceStack.Text.CsvReader<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CsvReader<T>
        {
            public CsvReader() => throw null;
            public static System.Collections.Generic.List<T> GetRows(System.Collections.Generic.IEnumerable<string> records) => throw null;
            public static System.Collections.Generic.List<string> Headers { get => throw null; set => throw null; }
            public static System.Collections.Generic.List<T> Read(System.Collections.Generic.List<string> rows) => throw null;
            public static object ReadObject(string csv) => throw null;
            public static object ReadObjectRow(string csv) => throw null;
            public static T ReadRow(string value) => throw null;
            public static System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> ReadStringDictionary(System.Collections.Generic.IEnumerable<string> rows) => throw null;
        }

        // Generated from `ServiceStack.Text.CsvSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CsvSerializer
        {
            public CsvSerializer() => throw null;
            public static T DeserializeFromReader<T>(System.IO.TextReader reader) => throw null;
            public static object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public static T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public static object DeserializeFromString(System.Type type, string text) => throw null;
            public static T DeserializeFromString<T>(string text) => throw null;
            public static void InitAot<T>() => throw null;
            public static System.Action<object> OnSerialize { get => throw null; set => throw null; }
            public static object ReadLateBoundObject(System.Type type, string value) => throw null;
            public static string SerializeToCsv<T>(System.Collections.Generic.IEnumerable<T> records) => throw null;
            public static void SerializeToStream<T>(T value, System.IO.Stream stream) => throw null;
            public static void SerializeToStream(object obj, System.IO.Stream stream) => throw null;
            public static string SerializeToString<T>(T value) => throw null;
            public static void SerializeToWriter<T>(T value, System.IO.TextWriter writer) => throw null;
            public static System.Text.Encoding UseEncoding { get => throw null; set => throw null; }
            public static void WriteLateBoundObject(System.IO.TextWriter writer, object value) => throw null;
        }

        // Generated from `ServiceStack.Text.CsvSerializer<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class CsvSerializer<T>
        {
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

        // Generated from `ServiceStack.Text.CsvStreamExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class CsvStreamExtensions
        {
            public static void WriteCsv<T>(this System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<T> records) => throw null;
            public static void WriteCsv<T>(this System.IO.Stream outputStream, System.Collections.Generic.IEnumerable<T> records) => throw null;
        }

        // Generated from `ServiceStack.Text.CsvWriter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class CsvWriter
        {
            public static bool HasAnyEscapeChars(string value) => throw null;
        }

        // Generated from `ServiceStack.Text.CsvWriter<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CsvWriter<T>
        {
            public CsvWriter() => throw null;
            public const System.Char DelimiterChar = default;
            public static System.Collections.Generic.List<System.Collections.Generic.List<string>> GetRows(System.Collections.Generic.IEnumerable<T> records) => throw null;
            public static System.Collections.Generic.List<string> Headers { get => throw null; set => throw null; }
            public static void Write(System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<T> records) => throw null;
            public static void Write(System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<System.Collections.Generic.List<string>> rows) => throw null;
            public static void WriteObject(System.IO.TextWriter writer, object records) => throw null;
            public static void WriteObjectRow(System.IO.TextWriter writer, object record) => throw null;
            public static void WriteRow(System.IO.TextWriter writer, T row) => throw null;
            public static void WriteRow(System.IO.TextWriter writer, System.Collections.Generic.IEnumerable<string> row) => throw null;
        }

        // Generated from `ServiceStack.Text.DateHandler` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public enum DateHandler
        {
            DCJSCompatible,
            ISO8601,
            ISO8601DateOnly,
            ISO8601DateTime,
            RFC1123,
            TimestampOffset,
            UnixTime,
            UnixTimeMs,
        }

        // Generated from `ServiceStack.Text.DateTimeExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class DateTimeExtensions
        {
            public static System.DateTime EndOfLastMonth(this System.DateTime from) => throw null;
            public static string FmtSortableDate(this System.DateTime from) => throw null;
            public static string FmtSortableDateTime(this System.DateTime from) => throw null;
            public static System.DateTime FromShortestXsdDateTimeString(this string xsdDateTime) => throw null;
            public static System.TimeSpan FromTimeOffsetString(this string offsetString) => throw null;
            public static System.DateTime FromUnixTime(this int unixTime) => throw null;
            public static System.DateTime FromUnixTime(this double unixTime) => throw null;
            public static System.DateTime FromUnixTime(this System.Int64 unixTime) => throw null;
            public static System.DateTime FromUnixTimeMs(this double msSince1970, System.TimeSpan offset) => throw null;
            public static System.DateTime FromUnixTimeMs(this double msSince1970) => throw null;
            public static System.DateTime FromUnixTimeMs(this System.Int64 msSince1970, System.TimeSpan offset) => throw null;
            public static System.DateTime FromUnixTimeMs(this System.Int64 msSince1970) => throw null;
            public static System.DateTime FromUnixTimeMs(string msSince1970, System.TimeSpan offset) => throw null;
            public static System.DateTime FromUnixTimeMs(string msSince1970) => throw null;
            public static bool IsEqualToTheSecond(this System.DateTime dateTime, System.DateTime otherDateTime) => throw null;
            public static System.DateTime LastMonday(this System.DateTime from) => throw null;
            public static System.DateTime RoundToMs(this System.DateTime dateTime) => throw null;
            public static System.DateTime RoundToSecond(this System.DateTime dateTime) => throw null;
            public static System.DateTime StartOfLastMonth(this System.DateTime from) => throw null;
            public static string ToShortestXsdDateTimeString(this System.DateTime dateTime) => throw null;
            public static System.DateTime ToStableUniversalTime(this System.DateTime dateTime) => throw null;
            public static string ToTimeOffsetString(this System.TimeSpan offset, string seperator = default(string)) => throw null;
            public static System.Int64 ToUnixTime(this System.DateTime dateTime) => throw null;
            public static System.Int64 ToUnixTimeMs(this System.Int64 ticks) => throw null;
            public static System.Int64 ToUnixTimeMs(this System.DateTime dateTime) => throw null;
            public static System.Int64 ToUnixTimeMsAlt(this System.DateTime dateTime) => throw null;
            public static System.DateTime Truncate(this System.DateTime dateTime, System.TimeSpan timeSpan) => throw null;
            public const System.Int64 UnixEpoch = default;
        }

        // Generated from `ServiceStack.Text.DefaultMemory` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class DefaultMemory : ServiceStack.Text.MemoryProvider
        {
            public override System.Text.StringBuilder Append(System.Text.StringBuilder sb, System.ReadOnlySpan<System.Char> value) => throw null;
            public static void Configure() => throw null;
            public override object Deserialize(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer) => throw null;
            public override System.Threading.Tasks.Task<object> DeserializeAsync(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer) => throw null;
            public override int FromUtf8(System.ReadOnlySpan<System.Byte> source, System.Span<System.Char> destination) => throw null;
            public override System.ReadOnlyMemory<System.Char> FromUtf8(System.ReadOnlySpan<System.Byte> source) => throw null;
            public override string FromUtf8Bytes(System.ReadOnlySpan<System.Byte> source) => throw null;
            public override int GetUtf8ByteCount(System.ReadOnlySpan<System.Char> chars) => throw null;
            public override int GetUtf8CharCount(System.ReadOnlySpan<System.Byte> bytes) => throw null;
            public override System.Byte[] ParseBase64(System.ReadOnlySpan<System.Char> value) => throw null;
            public override bool ParseBoolean(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Byte ParseByte(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Decimal ParseDecimal(System.ReadOnlySpan<System.Char> value, bool allowThousands) => throw null;
            public override System.Decimal ParseDecimal(System.ReadOnlySpan<System.Char> value) => throw null;
            public override double ParseDouble(System.ReadOnlySpan<System.Char> value) => throw null;
            public override float ParseFloat(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Guid ParseGuid(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Int16 ParseInt16(System.ReadOnlySpan<System.Char> value) => throw null;
            public override int ParseInt32(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.Int64 ParseInt64(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.SByte ParseSByte(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.UInt16 ParseUInt16(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.UInt32 ParseUInt32(System.ReadOnlySpan<System.Char> value, System.Globalization.NumberStyles style) => throw null;
            public override System.UInt32 ParseUInt32(System.ReadOnlySpan<System.Char> value) => throw null;
            public override System.UInt64 ParseUInt64(System.ReadOnlySpan<System.Char> value) => throw null;
            public static ServiceStack.Text.DefaultMemory Provider { get => throw null; }
            public override string ToBase64(System.ReadOnlyMemory<System.Byte> value) => throw null;
            public override System.IO.MemoryStream ToMemoryStream(System.ReadOnlySpan<System.Byte> source) => throw null;
            public override int ToUtf8(System.ReadOnlySpan<System.Char> source, System.Span<System.Byte> destination) => throw null;
            public override System.ReadOnlyMemory<System.Byte> ToUtf8(System.ReadOnlySpan<System.Char> source) => throw null;
            public override System.Byte[] ToUtf8Bytes(System.ReadOnlySpan<System.Char> source) => throw null;
            public override bool TryParseBoolean(System.ReadOnlySpan<System.Char> value, out bool result) => throw null;
            public static bool TryParseDecimal(System.ReadOnlySpan<System.Char> value, bool allowThousands, out System.Decimal result) => throw null;
            public override bool TryParseDecimal(System.ReadOnlySpan<System.Char> value, out System.Decimal result) => throw null;
            public override bool TryParseDouble(System.ReadOnlySpan<System.Char> value, out double result) => throw null;
            public override bool TryParseFloat(System.ReadOnlySpan<System.Char> value, out float result) => throw null;
            public override void Write(System.IO.Stream stream, System.ReadOnlyMemory<System.Char> value) => throw null;
            public override void Write(System.IO.Stream stream, System.ReadOnlyMemory<System.Byte> value) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlySpan<System.Char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<System.Char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
            public override System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<System.Byte> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }

        // Generated from `ServiceStack.Text.DirectStreamWriter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class DirectStreamWriter : System.IO.TextWriter
        {
            public DirectStreamWriter(System.IO.Stream stream, System.Text.Encoding encoding) => throw null;
            public override System.Text.Encoding Encoding { get => throw null; }
            public override void Flush() => throw null;
            public override void Write(string s) => throw null;
            public override void Write(System.Char c) => throw null;
        }

        // Generated from `ServiceStack.Text.DynamicProxy` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class DynamicProxy
        {
            public static void BindProperty(System.Reflection.Emit.TypeBuilder typeBuilder, System.Reflection.MethodInfo methodInfo) => throw null;
            public static object GetInstanceFor(System.Type targetType) => throw null;
            public static T GetInstanceFor<T>() => throw null;
        }

        // Generated from `ServiceStack.Text.EmitReflectionOptimizer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class EmitReflectionOptimizer : ServiceStack.Text.ReflectionOptimizer
        {
            public override ServiceStack.EmptyCtorDelegate CreateConstructor(System.Type type) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberRefDelegate<T> CreateSetterRef<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override bool IsDynamic(System.Reflection.Assembly assembly) => throw null;
            public static ServiceStack.Text.EmitReflectionOptimizer Provider { get => throw null; }
            public override System.Type UseType(System.Type type) => throw null;
        }

        // Generated from `ServiceStack.Text.EnumInfo` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class EnumInfo
        {
            public static ServiceStack.Text.EnumInfo GetEnumInfo(System.Type type) => throw null;
            public object GetSerializedValue(object enumValue) => throw null;
            public object Parse(string serializedValue) => throw null;
        }

        // Generated from `ServiceStack.Text.Env` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class Env
        {
            public static System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable<T> ConfigAwait<T>(this System.Threading.Tasks.ValueTask<T> task) => throw null;
            public static System.Runtime.CompilerServices.ConfiguredValueTaskAwaitable ConfigAwait(this System.Threading.Tasks.ValueTask task) => throw null;
            public static System.Runtime.CompilerServices.ConfiguredTaskAwaitable<T> ConfigAwait<T>(this System.Threading.Tasks.Task<T> task) => throw null;
            public static System.Runtime.CompilerServices.ConfiguredTaskAwaitable ConfigAwait(this System.Threading.Tasks.Task task) => throw null;
            public const bool ContinueOnCapturedContext = default;
            public static System.DateTime GetReleaseDate() => throw null;
            public static bool HasMultiplePlatformTargets { get => throw null; set => throw null; }
            public static bool IsAndroid { get => throw null; set => throw null; }
            public static bool IsIOS { get => throw null; set => throw null; }
            public static bool IsLinux { get => throw null; set => throw null; }
            public static bool IsMono { get => throw null; set => throw null; }
            public static bool IsNetCore { get => throw null; set => throw null; }
            public static bool IsNetCore21 { get => throw null; set => throw null; }
            public static bool IsNetCore3 { get => throw null; set => throw null; }
            public static bool IsNetFramework { get => throw null; set => throw null; }
            public static bool IsNetNative { get => throw null; set => throw null; }
            public static bool IsNetStandard { get => throw null; set => throw null; }
            public static bool IsNetStandard20 { get => throw null; set => throw null; }
            public static bool IsOSX { get => throw null; set => throw null; }
            public static bool IsUWP { get => throw null; set => throw null; }
            public static bool IsUnix { get => throw null; set => throw null; }
            public static bool IsWindows { get => throw null; set => throw null; }
            public static string ReferenceAssemblyPath { get => throw null; set => throw null; }
            public static string ReferenceAssembyPath { get => throw null; }
            public static string ServerUserAgent { get => throw null; set => throw null; }
            public static System.Decimal ServiceStackVersion;
            public static bool StrictMode { get => throw null; set => throw null; }
            public static bool SupportsDynamic { get => throw null; set => throw null; }
            public static bool SupportsEmit { get => throw null; set => throw null; }
            public static bool SupportsExpressions { get => throw null; set => throw null; }
            public static string VersionString { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Text.ExpressionReflectionOptimizer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ExpressionReflectionOptimizer : ServiceStack.Text.ReflectionOptimizer
        {
            public override ServiceStack.EmptyCtorDelegate CreateConstructor(System.Type type) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberRefDelegate<T> CreateSetterRef<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public static System.Linq.Expressions.Expression<ServiceStack.GetMemberDelegate> GetExpressionLambda(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public static System.Linq.Expressions.Expression<ServiceStack.GetMemberDelegate<T>> GetExpressionLambda<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override bool IsDynamic(System.Reflection.Assembly assembly) => throw null;
            public static ServiceStack.Text.ExpressionReflectionOptimizer Provider { get => throw null; }
            public static System.Linq.Expressions.Expression<ServiceStack.SetMemberDelegate<T>> SetExpressionLambda<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override System.Type UseType(System.Type type) => throw null;
        }

        // Generated from `ServiceStack.Text.IRuntimeSerializable` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRuntimeSerializable
        {
        }

        // Generated from `ServiceStack.Text.IStringSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IStringSerializer
        {
            object DeserializeFromString(string serializedText, System.Type type);
            To DeserializeFromString<To>(string serializedText);
            string SerializeToString<TFrom>(TFrom from);
        }

        // Generated from `ServiceStack.Text.ITracer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ITracer
        {
            void WriteDebug(string format, params object[] args);
            void WriteDebug(string error);
            void WriteError(string format, params object[] args);
            void WriteError(string error);
            void WriteError(System.Exception ex);
            void WriteWarning(string warning);
            void WriteWarning(string format, params object[] args);
        }

        // Generated from `ServiceStack.Text.ITypeSerializer<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ITypeSerializer<T>
        {
            bool CanCreateFromString(System.Type type);
            T DeserializeFromReader(System.IO.TextReader reader);
            T DeserializeFromString(string value);
            string SerializeToString(T value);
            void SerializeToWriter(T value, System.IO.TextWriter writer);
        }

        // Generated from `ServiceStack.Text.IValueWriter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IValueWriter
        {
            void WriteTo(ServiceStack.Text.Common.ITypeSerializer serializer, System.IO.TextWriter writer);
        }

        // Generated from `ServiceStack.Text.JsConfig` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class JsConfig
        {
            public static System.Func<System.Type, bool> AllowRuntimeType { get => throw null; set => throw null; }
            public static System.Collections.Generic.HashSet<string> AllowRuntimeTypeInTypes { get => throw null; set => throw null; }
            public static System.Collections.Generic.HashSet<string> AllowRuntimeTypeInTypesWithNamespaces { get => throw null; set => throw null; }
            public static System.Collections.Generic.HashSet<string> AllowRuntimeTypeWithAttributesNamed { get => throw null; set => throw null; }
            public static System.Collections.Generic.HashSet<string> AllowRuntimeTypeWithInterfacesNamed { get => throw null; set => throw null; }
            public static bool AlwaysUseUtc { get => throw null; set => throw null; }
            public static bool AppendUtcOffset { get => throw null; set => throw null; }
            public static bool AssumeUtc { get => throw null; set => throw null; }
            public static ServiceStack.Text.JsConfigScope BeginScope() => throw null;
            public static bool ConvertObjectTypesIntoStringDictionary { get => throw null; set => throw null; }
            public static ServiceStack.Text.JsConfigScope CreateScope(string config, ServiceStack.Text.JsConfigScope scope = default(ServiceStack.Text.JsConfigScope)) => throw null;
            public static ServiceStack.Text.DateHandler DateHandler { get => throw null; set => throw null; }
            public static string DateTimeFormat { get => throw null; set => throw null; }
            public static bool EmitCamelCaseNames { get => throw null; set => throw null; }
            public static bool EmitLowercaseUnderscoreNames { get => throw null; set => throw null; }
            public static bool EscapeHtmlChars { get => throw null; set => throw null; }
            public static bool EscapeUnicode { get => throw null; set => throw null; }
            public static bool ExcludeDefaultValues { get => throw null; set => throw null; }
            public static string[] ExcludePropertyReferences { get => throw null; set => throw null; }
            public static bool ExcludeTypeInfo { get => throw null; set => throw null; }
            public static System.Collections.Generic.HashSet<string> ExcludeTypeNames { get => throw null; set => throw null; }
            public static System.Collections.Generic.HashSet<System.Type> ExcludeTypes { get => throw null; set => throw null; }
            public static ServiceStack.Text.Config GetConfig() => throw null;
            public static bool HasInit { get => throw null; }
            public static string[] IgnoreAttributesNamed { get => throw null; set => throw null; }
            public static bool IncludeDefaultEnums { get => throw null; set => throw null; }
            public static bool IncludeNullValues { get => throw null; set => throw null; }
            public static bool IncludeNullValuesInDictionaries { get => throw null; set => throw null; }
            public static bool IncludePublicFields { get => throw null; set => throw null; }
            public static bool IncludeTypeInfo { get => throw null; set => throw null; }
            public static void Init(ServiceStack.Text.Config config) => throw null;
            public static void Init() => throw null;
            public static void InitStatics() => throw null;
            public static int MaxDepth { get => throw null; set => throw null; }
            public static ServiceStack.EmptyCtorFactoryDelegate ModelFactory { get => throw null; set => throw null; }
            public static ServiceStack.Text.Common.DeserializationErrorDelegate OnDeserializationError { get => throw null; set => throw null; }
            public static ServiceStack.Text.ParseAsType ParsePrimitiveFloatingPointTypes { get => throw null; set => throw null; }
            public static System.Func<string, object> ParsePrimitiveFn { get => throw null; set => throw null; }
            public static ServiceStack.Text.ParseAsType ParsePrimitiveIntegerTypes { get => throw null; set => throw null; }
            public static bool PreferInterfaces { get => throw null; set => throw null; }
            public static ServiceStack.Text.PropertyConvention PropertyConvention { get => throw null; set => throw null; }
            public static void Reset() => throw null;
            public static bool SkipDateTimeConversion { get => throw null; set => throw null; }
            public static ServiceStack.Text.TextCase TextCase { get => throw null; set => throw null; }
            public static bool ThrowOnDeserializationError { get => throw null; set => throw null; }
            public static bool ThrowOnError { get => throw null; set => throw null; }
            public static ServiceStack.Text.TimeSpanHandler TimeSpanHandler { get => throw null; set => throw null; }
            public static bool TreatEnumAsInteger { get => throw null; set => throw null; }
            public static System.Collections.Generic.HashSet<System.Type> TreatValueAsRefTypes;
            public static bool TryParseIntoBestFit { get => throw null; set => throw null; }
            public static bool TryToParseNumericType { get => throw null; set => throw null; }
            public static bool TryToParsePrimitiveTypeValues { get => throw null; set => throw null; }
            public static string TypeAttr { get => throw null; set => throw null; }
            public static System.Func<string, System.Type> TypeFinder { get => throw null; set => throw null; }
            public static System.Func<System.Type, string> TypeWriter { get => throw null; set => throw null; }
            public static System.Text.UTF8Encoding UTF8Encoding { get => throw null; set => throw null; }
            public static ServiceStack.Text.JsConfigScope With(bool? convertObjectTypesIntoStringDictionary = default(bool?), bool? tryToParsePrimitiveTypeValues = default(bool?), bool? tryToParseNumericType = default(bool?), ServiceStack.Text.ParseAsType? parsePrimitiveFloatingPointTypes = default(ServiceStack.Text.ParseAsType?), ServiceStack.Text.ParseAsType? parsePrimitiveIntegerTypes = default(ServiceStack.Text.ParseAsType?), bool? excludeDefaultValues = default(bool?), bool? includeNullValues = default(bool?), bool? includeNullValuesInDictionaries = default(bool?), bool? includeDefaultEnums = default(bool?), bool? excludeTypeInfo = default(bool?), bool? includeTypeInfo = default(bool?), bool? emitCamelCaseNames = default(bool?), bool? emitLowercaseUnderscoreNames = default(bool?), ServiceStack.Text.DateHandler? dateHandler = default(ServiceStack.Text.DateHandler?), ServiceStack.Text.TimeSpanHandler? timeSpanHandler = default(ServiceStack.Text.TimeSpanHandler?), ServiceStack.Text.PropertyConvention? propertyConvention = default(ServiceStack.Text.PropertyConvention?), bool? preferInterfaces = default(bool?), bool? throwOnDeserializationError = default(bool?), string typeAttr = default(string), string dateTimeFormat = default(string), System.Func<System.Type, string> typeWriter = default(System.Func<System.Type, string>), System.Func<string, System.Type> typeFinder = default(System.Func<string, System.Type>), bool? treatEnumAsInteger = default(bool?), bool? skipDateTimeConversion = default(bool?), bool? alwaysUseUtc = default(bool?), bool? assumeUtc = default(bool?), bool? appendUtcOffset = default(bool?), bool? escapeUnicode = default(bool?), bool? includePublicFields = default(bool?), int? maxDepth = default(int?), ServiceStack.EmptyCtorFactoryDelegate modelFactory = default(ServiceStack.EmptyCtorFactoryDelegate), string[] excludePropertyReferences = default(string[]), bool? useSystemParseMethods = default(bool?)) => throw null;
            public static ServiceStack.Text.JsConfigScope With(ServiceStack.Text.Config config) => throw null;
        }

        // Generated from `ServiceStack.Text.JsConfig<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class JsConfig<T>
        {
            public static System.Func<string, T> DeSerializeFn { get => throw null; set => throw null; }
            public static bool? EmitCamelCaseNames { get => throw null; set => throw null; }
            public static bool? EmitLowercaseUnderscoreNames { get => throw null; set => throw null; }
            public static string[] ExcludePropertyNames;
            public static bool? ExcludeTypeInfo;
            public static bool HasDeserializeFn { get => throw null; }
            public static bool HasDeserializingFn { get => throw null; }
            public static bool HasSerializeFn { get => throw null; }
            public static bool IncludeDefaultValue { get => throw null; set => throw null; }
            public static bool? IncludeTypeInfo;
            public JsConfig() => throw null;
            public static System.Func<T, T> OnDeserializedFn { get => throw null; set => throw null; }
            public static System.Func<T, string, object, object> OnDeserializingFn { get => throw null; set => throw null; }
            public static System.Action<T> OnSerializedFn { get => throw null; set => throw null; }
            public static System.Func<T, T> OnSerializingFn { get => throw null; set => throw null; }
            public static object ParseFn(string str) => throw null;
            public static System.Func<string, T> RawDeserializeFn { get => throw null; set => throw null; }
            public static System.Func<T, string> RawSerializeFn { get => throw null; set => throw null; }
            public static void RefreshRead() => throw null;
            public static void RefreshWrite() => throw null;
            public static void Reset() => throw null;
            public static System.Func<T, string> SerializeFn { get => throw null; set => throw null; }
            public static ServiceStack.Text.TextCase TextCase { get => throw null; set => throw null; }
            public static bool TreatValueAsRefType { get => throw null; set => throw null; }
            public static void WriteFn<TSerializer>(System.IO.TextWriter writer, object obj) => throw null;
        }

        // Generated from `ServiceStack.Text.JsConfigScope` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class JsConfigScope : ServiceStack.Text.Config, System.IDisposable
        {
            public void Dispose() => throw null;
        }

        // Generated from `ServiceStack.Text.JsonArrayObjects` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class JsonArrayObjects : System.Collections.Generic.List<ServiceStack.Text.JsonObject>
        {
            public JsonArrayObjects() => throw null;
            public static ServiceStack.Text.JsonArrayObjects Parse(string json) => throw null;
        }

        // Generated from `ServiceStack.Text.JsonExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class JsonExtensions
        {
            public static ServiceStack.Text.JsonArrayObjects ArrayObjects(this string json) => throw null;
            public static System.Collections.Generic.List<T> ConvertAll<T>(this ServiceStack.Text.JsonArrayObjects jsonArrayObjects, System.Func<ServiceStack.Text.JsonObject, T> converter) => throw null;
            public static T ConvertTo<T>(this ServiceStack.Text.JsonObject jsonObject, System.Func<ServiceStack.Text.JsonObject, T> convertFn) => throw null;
            public static string Get(this System.Collections.Generic.Dictionary<string, string> map, string key) => throw null;
            public static T Get<T>(this System.Collections.Generic.Dictionary<string, string> map, string key, T defaultValue = default(T)) => throw null;
            public static T[] GetArray<T>(this System.Collections.Generic.Dictionary<string, string> map, string key) => throw null;
            public static T JsonTo<T>(this System.Collections.Generic.Dictionary<string, string> map, string key) => throw null;
            public static System.Collections.Generic.Dictionary<string, string> ToDictionary(this ServiceStack.Text.JsonObject jsonObject) => throw null;
        }

        // Generated from `ServiceStack.Text.JsonObject` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class JsonObject : System.Collections.Generic.Dictionary<string, string>
        {
            public ServiceStack.Text.JsonArrayObjects ArrayObjects(string propertyName) => throw null;
            public string Child(string key) => throw null;
            public object ConvertTo(System.Type type) => throw null;
            public T ConvertTo<T>() => throw null;
            public string GetUnescaped(string key) => throw null;
            public string this[string key] { get => throw null; set => throw null; }
            public JsonObject() => throw null;
            public ServiceStack.Text.JsonObject Object(string propertyName) => throw null;
            public static ServiceStack.Text.JsonObject Parse(string json) => throw null;
            public static ServiceStack.Text.JsonArrayObjects ParseArray(string json) => throw null;
            public static void WriteValue(System.IO.TextWriter writer, object value) => throw null;
        }

        // Generated from `ServiceStack.Text.JsonSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class JsonSerializer
        {
            public static int BufferSize;
            public static object DeserializeFromReader(System.IO.TextReader reader, System.Type type) => throw null;
            public static T DeserializeFromReader<T>(System.IO.TextReader reader) => throw null;
            public static object DeserializeFromSpan(System.Type type, System.ReadOnlySpan<System.Char> value) => throw null;
            public static T DeserializeFromSpan<T>(System.ReadOnlySpan<System.Char> value) => throw null;
            public static object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public static T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public static System.Threading.Tasks.Task<object> DeserializeFromStreamAsync(System.Type type, System.IO.Stream stream) => throw null;
            public static System.Threading.Tasks.Task<T> DeserializeFromStreamAsync<T>(System.IO.Stream stream) => throw null;
            public static object DeserializeFromString(string value, System.Type type) => throw null;
            public static T DeserializeFromString<T>(string value) => throw null;
            public static object DeserializeRequest(System.Type type, System.Net.WebRequest webRequest) => throw null;
            public static T DeserializeRequest<T>(System.Net.WebRequest webRequest) => throw null;
            public static object DeserializeResponse<T>(System.Type type, System.Net.WebRequest webRequest) => throw null;
            public static object DeserializeResponse(System.Type type, System.Net.WebResponse webResponse) => throw null;
            public static T DeserializeResponse<T>(System.Net.WebResponse webResponse) => throw null;
            public static T DeserializeResponse<T>(System.Net.WebRequest webRequest) => throw null;
            public static System.Action<object> OnSerialize { get => throw null; set => throw null; }
            public static void SerializeToStream<T>(T value, System.IO.Stream stream) => throw null;
            public static void SerializeToStream(object value, System.Type type, System.IO.Stream stream) => throw null;
            public static string SerializeToString<T>(T value) => throw null;
            public static string SerializeToString(object value, System.Type type) => throw null;
            public static void SerializeToWriter<T>(T value, System.IO.TextWriter writer) => throw null;
            public static void SerializeToWriter(object value, System.Type type, System.IO.TextWriter writer) => throw null;
            public static System.Text.UTF8Encoding UTF8Encoding { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Text.JsonSerializer<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class JsonSerializer<T> : ServiceStack.Text.ITypeSerializer<T>
        {
            public bool CanCreateFromString(System.Type type) => throw null;
            public T DeserializeFromReader(System.IO.TextReader reader) => throw null;
            public T DeserializeFromString(string value) => throw null;
            public JsonSerializer() => throw null;
            public string SerializeToString(T value) => throw null;
            public void SerializeToWriter(T value, System.IO.TextWriter writer) => throw null;
        }

        // Generated from `ServiceStack.Text.JsonStringSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class JsonStringSerializer : ServiceStack.Text.IStringSerializer
        {
            public object DeserializeFromString(string serializedText, System.Type type) => throw null;
            public To DeserializeFromString<To>(string serializedText) => throw null;
            public JsonStringSerializer() => throw null;
            public string SerializeToString<TFrom>(TFrom from) => throw null;
        }

        // Generated from `ServiceStack.Text.JsonValue` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public struct JsonValue : ServiceStack.Text.IValueWriter
        {
            public T As<T>() => throw null;
            public JsonValue(string json) => throw null;
            // Stub generator skipped constructor 
            public override string ToString() => throw null;
            public void WriteTo(ServiceStack.Text.Common.ITypeSerializer serializer, System.IO.TextWriter writer) => throw null;
        }

        // Generated from `ServiceStack.Text.JsvFormatter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class JsvFormatter
        {
            public static string Format(string serializedText) => throw null;
        }

        // Generated from `ServiceStack.Text.JsvStringSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class JsvStringSerializer : ServiceStack.Text.IStringSerializer
        {
            public object DeserializeFromString(string serializedText, System.Type type) => throw null;
            public To DeserializeFromString<To>(string serializedText) => throw null;
            public JsvStringSerializer() => throw null;
            public string SerializeToString<TFrom>(TFrom from) => throw null;
        }

        // Generated from `ServiceStack.Text.MemoryProvider` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public abstract class MemoryProvider
        {
            public abstract System.Text.StringBuilder Append(System.Text.StringBuilder sb, System.ReadOnlySpan<System.Char> value);
            public abstract object Deserialize(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer);
            public abstract System.Threading.Tasks.Task<object> DeserializeAsync(System.IO.Stream stream, System.Type type, ServiceStack.Text.Common.DeserializeStringSpanDelegate deserializer);
            public abstract int FromUtf8(System.ReadOnlySpan<System.Byte> source, System.Span<System.Char> destination);
            public abstract System.ReadOnlyMemory<System.Char> FromUtf8(System.ReadOnlySpan<System.Byte> source);
            public abstract string FromUtf8Bytes(System.ReadOnlySpan<System.Byte> source);
            public abstract int GetUtf8ByteCount(System.ReadOnlySpan<System.Char> chars);
            public abstract int GetUtf8CharCount(System.ReadOnlySpan<System.Byte> bytes);
            public static ServiceStack.Text.MemoryProvider Instance;
            protected MemoryProvider() => throw null;
            public abstract System.Byte[] ParseBase64(System.ReadOnlySpan<System.Char> value);
            public abstract bool ParseBoolean(System.ReadOnlySpan<System.Char> value);
            public abstract System.Byte ParseByte(System.ReadOnlySpan<System.Char> value);
            public abstract System.Decimal ParseDecimal(System.ReadOnlySpan<System.Char> value, bool allowThousands);
            public abstract System.Decimal ParseDecimal(System.ReadOnlySpan<System.Char> value);
            public abstract double ParseDouble(System.ReadOnlySpan<System.Char> value);
            public abstract float ParseFloat(System.ReadOnlySpan<System.Char> value);
            public abstract System.Guid ParseGuid(System.ReadOnlySpan<System.Char> value);
            public abstract System.Int16 ParseInt16(System.ReadOnlySpan<System.Char> value);
            public abstract int ParseInt32(System.ReadOnlySpan<System.Char> value);
            public abstract System.Int64 ParseInt64(System.ReadOnlySpan<System.Char> value);
            public abstract System.SByte ParseSByte(System.ReadOnlySpan<System.Char> value);
            public abstract System.UInt16 ParseUInt16(System.ReadOnlySpan<System.Char> value);
            public abstract System.UInt32 ParseUInt32(System.ReadOnlySpan<System.Char> value, System.Globalization.NumberStyles style);
            public abstract System.UInt32 ParseUInt32(System.ReadOnlySpan<System.Char> value);
            public abstract System.UInt64 ParseUInt64(System.ReadOnlySpan<System.Char> value);
            public abstract string ToBase64(System.ReadOnlyMemory<System.Byte> value);
            public abstract System.IO.MemoryStream ToMemoryStream(System.ReadOnlySpan<System.Byte> source);
            public abstract int ToUtf8(System.ReadOnlySpan<System.Char> source, System.Span<System.Byte> destination);
            public abstract System.ReadOnlyMemory<System.Byte> ToUtf8(System.ReadOnlySpan<System.Char> source);
            public abstract System.Byte[] ToUtf8Bytes(System.ReadOnlySpan<System.Char> source);
            public abstract bool TryParseBoolean(System.ReadOnlySpan<System.Char> value, out bool result);
            public abstract bool TryParseDecimal(System.ReadOnlySpan<System.Char> value, out System.Decimal result);
            public abstract bool TryParseDouble(System.ReadOnlySpan<System.Char> value, out double result);
            public abstract bool TryParseFloat(System.ReadOnlySpan<System.Char> value, out float result);
            public abstract void Write(System.IO.Stream stream, System.ReadOnlyMemory<System.Char> value);
            public abstract void Write(System.IO.Stream stream, System.ReadOnlyMemory<System.Byte> value);
            public abstract System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlySpan<System.Char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            public abstract System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<System.Char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            public abstract System.Threading.Tasks.Task WriteAsync(System.IO.Stream stream, System.ReadOnlyMemory<System.Byte> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Text.MemoryStreamFactory` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class MemoryStreamFactory
        {
            public static System.IO.MemoryStream GetStream(int capacity) => throw null;
            public static System.IO.MemoryStream GetStream(System.Byte[] bytes, int index, int count) => throw null;
            public static System.IO.MemoryStream GetStream(System.Byte[] bytes) => throw null;
            public static System.IO.MemoryStream GetStream() => throw null;
            public static ServiceStack.Text.RecyclableMemoryStreamManager RecyclableInstance;
            public static bool UseRecyclableMemoryStream { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Text.MurmurHash2` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class MurmurHash2
        {
            public static System.UInt32 Hash(string data) => throw null;
            public static System.UInt32 Hash(System.Byte[] data, System.UInt32 seed) => throw null;
            public static System.UInt32 Hash(System.Byte[] data) => throw null;
            public MurmurHash2() => throw null;
        }

        // Generated from `ServiceStack.Text.ParseAsType` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        [System.Flags]
        public enum ParseAsType
        {
            Bool,
            Byte,
            Decimal,
            Double,
            Int16,
            Int32,
            Int64,
            None,
            SByte,
            Single,
            UInt16,
            UInt32,
            UInt64,
        }

        // Generated from `ServiceStack.Text.PropertyConvention` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public enum PropertyConvention
        {
            Lenient,
            Strict,
        }

        // Generated from `ServiceStack.Text.RecyclableMemoryStream` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RecyclableMemoryStream : System.IO.MemoryStream
        {
            public override bool CanRead { get => throw null; }
            public override bool CanSeek { get => throw null; }
            public override bool CanTimeout { get => throw null; }
            public override bool CanWrite { get => throw null; }
            public override int Capacity { get => throw null; set => throw null; }
            public override void Close() => throw null;
            protected override void Dispose(bool disposing) => throw null;
            public override System.Byte[] GetBuffer() => throw null;
            public override System.Int64 Length { get => throw null; }
            public override System.Int64 Position { get => throw null; set => throw null; }
            public override int Read(System.Span<System.Byte> buffer) => throw null;
            public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
            public override int ReadByte() => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, string tag, int requestedSize) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, string tag) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, System.Guid id, string tag, int requestedSize) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, System.Guid id, string tag) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager, System.Guid id) => throw null;
            public RecyclableMemoryStream(ServiceStack.Text.RecyclableMemoryStreamManager memoryManager) => throw null;
            public int SafeRead(System.Span<System.Byte> buffer, ref int streamPosition) => throw null;
            public int SafeRead(System.Byte[] buffer, int offset, int count, ref int streamPosition) => throw null;
            public int SafeReadByte(ref int streamPosition) => throw null;
            public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin loc) => throw null;
            public override void SetLength(System.Int64 value) => throw null;
            public override System.Byte[] ToArray() => throw null;
            public override string ToString() => throw null;
            public override bool TryGetBuffer(out System.ArraySegment<System.Byte> buffer) => throw null;
            public override void Write(System.ReadOnlySpan<System.Byte> source) => throw null;
            public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
            public override void WriteByte(System.Byte value) => throw null;
            public void WriteTo(System.IO.Stream stream, int offset, int count) => throw null;
            public override void WriteTo(System.IO.Stream stream) => throw null;
            // ERR: Stub generator didn't handle member: ~RecyclableMemoryStream
        }

        // Generated from `ServiceStack.Text.RecyclableMemoryStreamManager` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RecyclableMemoryStreamManager
        {
            public bool AggressiveBufferReturn { get => throw null; set => throw null; }
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler BlockCreated;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler BlockDiscarded;
            public int BlockSize { get => throw null; }
            public const int DefaultBlockSize = default;
            public const int DefaultLargeBufferMultiple = default;
            public const int DefaultMaximumBufferSize = default;
            // Generated from `ServiceStack.Text.RecyclableMemoryStreamManager+EventHandler` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate void EventHandler();


            // Generated from `ServiceStack.Text.RecyclableMemoryStreamManager+Events` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class Events : System.Diagnostics.Tracing.EventSource
            {
                public Events() => throw null;
                // Generated from `ServiceStack.Text.RecyclableMemoryStreamManager+Events+MemoryStreamBufferType` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public enum MemoryStreamBufferType
                {
                    Large,
                    Small,
                }


                public void MemoryStreamCreated(System.Guid guid, string tag, int requestedSize) => throw null;
                public void MemoryStreamDiscardBuffer(ServiceStack.Text.RecyclableMemoryStreamManager.Events.MemoryStreamBufferType bufferType, string tag, ServiceStack.Text.RecyclableMemoryStreamManager.Events.MemoryStreamDiscardReason reason) => throw null;
                // Generated from `ServiceStack.Text.RecyclableMemoryStreamManager+Events+MemoryStreamDiscardReason` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public enum MemoryStreamDiscardReason
                {
                    EnoughFree,
                    TooLarge,
                }


                public void MemoryStreamDisposed(System.Guid guid, string tag) => throw null;
                public void MemoryStreamDoubleDispose(System.Guid guid, string tag, string allocationStack, string disposeStack1, string disposeStack2) => throw null;
                public void MemoryStreamFinalized(System.Guid guid, string tag, string allocationStack) => throw null;
                public void MemoryStreamManagerInitialized(int blockSize, int largeBufferMultiple, int maximumBufferSize) => throw null;
                public void MemoryStreamNewBlockCreated(System.Int64 smallPoolInUseBytes) => throw null;
                public void MemoryStreamNewLargeBufferCreated(int requiredSize, System.Int64 largePoolInUseBytes) => throw null;
                public void MemoryStreamNonPooledLargeBufferCreated(int requiredSize, string tag, string allocationStack) => throw null;
                public void MemoryStreamOverCapacity(int requestedCapacity, System.Int64 maxCapacity, string tag, string allocationStack) => throw null;
                public void MemoryStreamToArray(System.Guid guid, string tag, string stack, int size) => throw null;
                public static ServiceStack.Text.RecyclableMemoryStreamManager.Events Writer;
            }


            public bool GenerateCallStacks { get => throw null; set => throw null; }
            public System.IO.MemoryStream GetStream(string tag, int requiredSize, bool asContiguousBuffer) => throw null;
            public System.IO.MemoryStream GetStream(string tag, int requiredSize) => throw null;
            public System.IO.MemoryStream GetStream(string tag, System.Memory<System.Byte> buffer) => throw null;
            public System.IO.MemoryStream GetStream(string tag, System.Byte[] buffer, int offset, int count) => throw null;
            public System.IO.MemoryStream GetStream(string tag) => throw null;
            public System.IO.MemoryStream GetStream(System.Memory<System.Byte> buffer) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag, int requiredSize, bool asContiguousBuffer) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag, int requiredSize) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag, System.Memory<System.Byte> buffer) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag, System.Byte[] buffer, int offset, int count) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id, string tag) => throw null;
            public System.IO.MemoryStream GetStream(System.Guid id) => throw null;
            public System.IO.MemoryStream GetStream(System.Byte[] buffer) => throw null;
            public System.IO.MemoryStream GetStream() => throw null;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler LargeBufferCreated;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.LargeBufferDiscardedEventHandler LargeBufferDiscarded;
            // Generated from `ServiceStack.Text.RecyclableMemoryStreamManager+LargeBufferDiscardedEventHandler` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate void LargeBufferDiscardedEventHandler(ServiceStack.Text.RecyclableMemoryStreamManager.Events.MemoryStreamDiscardReason reason);


            public int LargeBufferMultiple { get => throw null; }
            public System.Int64 LargeBuffersFree { get => throw null; }
            public System.Int64 LargePoolFreeSize { get => throw null; }
            public System.Int64 LargePoolInUseSize { get => throw null; }
            public int MaximumBufferSize { get => throw null; }
            public System.Int64 MaximumFreeLargePoolBytes { get => throw null; set => throw null; }
            public System.Int64 MaximumFreeSmallPoolBytes { get => throw null; set => throw null; }
            public System.Int64 MaximumStreamCapacity { get => throw null; set => throw null; }
            public RecyclableMemoryStreamManager(int blockSize, int largeBufferMultiple, int maximumBufferSize, bool useExponentialLargeBuffer) => throw null;
            public RecyclableMemoryStreamManager(int blockSize, int largeBufferMultiple, int maximumBufferSize) => throw null;
            public RecyclableMemoryStreamManager() => throw null;
            public System.Int64 SmallBlocksFree { get => throw null; }
            public System.Int64 SmallPoolFreeSize { get => throw null; }
            public System.Int64 SmallPoolInUseSize { get => throw null; }
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler StreamConvertedToArray;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler StreamCreated;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler StreamDisposed;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.EventHandler StreamFinalized;
            public event ServiceStack.Text.RecyclableMemoryStreamManager.StreamLengthReportHandler StreamLength;
            // Generated from `ServiceStack.Text.RecyclableMemoryStreamManager+StreamLengthReportHandler` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate void StreamLengthReportHandler(System.Int64 bytes);


            public bool ThrowExceptionOnToArray { get => throw null; set => throw null; }
            public event ServiceStack.Text.RecyclableMemoryStreamManager.UsageReportEventHandler UsageReport;
            // Generated from `ServiceStack.Text.RecyclableMemoryStreamManager+UsageReportEventHandler` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate void UsageReportEventHandler(System.Int64 smallPoolInUseBytes, System.Int64 smallPoolFreeBytes, System.Int64 largePoolInUseBytes, System.Int64 largePoolFreeBytes);


            public bool UseExponentialLargeBuffer { get => throw null; }
            public bool UseMultipleLargeBuffer { get => throw null; }
        }

        // Generated from `ServiceStack.Text.ReflectionOptimizer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public abstract class ReflectionOptimizer
        {
            public abstract ServiceStack.EmptyCtorDelegate CreateConstructor(System.Type type);
            public abstract ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.PropertyInfo propertyInfo);
            public abstract ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.FieldInfo fieldInfo);
            public abstract ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.PropertyInfo propertyInfo);
            public abstract ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.FieldInfo fieldInfo);
            public abstract ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.PropertyInfo propertyInfo);
            public abstract ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.FieldInfo fieldInfo);
            public abstract ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.PropertyInfo propertyInfo);
            public abstract ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.FieldInfo fieldInfo);
            public abstract ServiceStack.SetMemberRefDelegate<T> CreateSetterRef<T>(System.Reflection.FieldInfo fieldInfo);
            public static ServiceStack.Text.ReflectionOptimizer Instance;
            public abstract bool IsDynamic(System.Reflection.Assembly assembly);
            protected ReflectionOptimizer() => throw null;
            public abstract System.Type UseType(System.Type type);
        }

        // Generated from `ServiceStack.Text.RuntimeReflectionOptimizer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RuntimeReflectionOptimizer : ServiceStack.Text.ReflectionOptimizer
        {
            public override ServiceStack.EmptyCtorDelegate CreateConstructor(System.Type type) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate<T> CreateGetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.GetMemberDelegate CreateGetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate<T> CreateSetter<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.PropertyInfo propertyInfo) => throw null;
            public override ServiceStack.SetMemberDelegate CreateSetter(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override ServiceStack.SetMemberRefDelegate<T> CreateSetterRef<T>(System.Reflection.FieldInfo fieldInfo) => throw null;
            public override bool IsDynamic(System.Reflection.Assembly assembly) => throw null;
            public static ServiceStack.Text.RuntimeReflectionOptimizer Provider { get => throw null; }
            public override System.Type UseType(System.Type type) => throw null;
        }

        // Generated from `ServiceStack.Text.RuntimeSerializableAttribute` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RuntimeSerializableAttribute : System.Attribute
        {
            public RuntimeSerializableAttribute() => throw null;
        }

        // Generated from `ServiceStack.Text.StringBuilderCache` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class StringBuilderCache
        {
            public static System.Text.StringBuilder Allocate() => throw null;
            public static void Free(System.Text.StringBuilder sb) => throw null;
            public static string ReturnAndFree(System.Text.StringBuilder sb) => throw null;
        }

        // Generated from `ServiceStack.Text.StringBuilderCacheAlt` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class StringBuilderCacheAlt
        {
            public static System.Text.StringBuilder Allocate() => throw null;
            public static void Free(System.Text.StringBuilder sb) => throw null;
            public static string ReturnAndFree(System.Text.StringBuilder sb) => throw null;
        }

        // Generated from `ServiceStack.Text.StringSpanExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class StringSpanExtensions
        {
            public static System.ReadOnlySpan<System.Char> Advance(this System.ReadOnlySpan<System.Char> text, int to) => throw null;
            public static System.ReadOnlySpan<System.Char> AdvancePastChar(this System.ReadOnlySpan<System.Char> literal, System.Char delim) => throw null;
            public static System.ReadOnlySpan<System.Char> AdvancePastWhitespace(this System.ReadOnlySpan<System.Char> literal) => throw null;
            public static System.Text.StringBuilder Append(this System.Text.StringBuilder sb, System.ReadOnlySpan<System.Char> value) => throw null;
            public static bool CompareIgnoreCase(this System.ReadOnlySpan<System.Char> value, System.ReadOnlySpan<System.Char> text) => throw null;
            public static int CountOccurrencesOf(this System.ReadOnlySpan<System.Char> value, System.Char needle) => throw null;
            public static bool EndsWith(this System.ReadOnlySpan<System.Char> value, string other, System.StringComparison comparison) => throw null;
            public static bool EndsWith(this System.ReadOnlySpan<System.Char> value, string other) => throw null;
            public static bool EndsWithIgnoreCase(this System.ReadOnlySpan<System.Char> value, System.ReadOnlySpan<System.Char> other) => throw null;
            public static bool EqualTo(this System.ReadOnlySpan<System.Char> value, string other) => throw null;
            public static bool EqualTo(this System.ReadOnlySpan<System.Char> value, System.ReadOnlySpan<System.Char> other) => throw null;
            public static bool EqualsIgnoreCase(this System.ReadOnlySpan<System.Char> value, System.ReadOnlySpan<System.Char> other) => throw null;
            public static bool EqualsOrdinal(this System.ReadOnlySpan<System.Char> value, string other) => throw null;
            public static System.ReadOnlySpan<System.Char> FromCsvField(this System.ReadOnlySpan<System.Char> text) => throw null;
            public static System.ReadOnlyMemory<System.Char> FromUtf8(this System.ReadOnlySpan<System.Byte> value) => throw null;
            public static string FromUtf8Bytes(this System.ReadOnlySpan<System.Byte> value) => throw null;
            public static System.Char GetChar(this System.ReadOnlySpan<System.Char> value, int index) => throw null;
            public static System.ReadOnlySpan<System.Char> GetExtension(this System.ReadOnlySpan<System.Char> filePath) => throw null;
            public static int IndexOf(this System.ReadOnlySpan<System.Char> value, string other) => throw null;
            public static int IndexOf(this System.ReadOnlySpan<System.Char> value, string needle, int start) => throw null;
            public static bool IsNullOrEmpty(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static bool IsNullOrWhiteSpace(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static int LastIndexOf(this System.ReadOnlySpan<System.Char> value, string other) => throw null;
            public static int LastIndexOf(this System.ReadOnlySpan<System.Char> value, string needle, int start) => throw null;
            public static System.ReadOnlySpan<System.Char> LastLeftPart(this System.ReadOnlySpan<System.Char> strVal, string needle) => throw null;
            public static System.ReadOnlySpan<System.Char> LastLeftPart(this System.ReadOnlySpan<System.Char> strVal, System.Char needle) => throw null;
            public static System.ReadOnlySpan<System.Char> LastRightPart(this System.ReadOnlySpan<System.Char> strVal, string needle) => throw null;
            public static System.ReadOnlySpan<System.Char> LastRightPart(this System.ReadOnlySpan<System.Char> strVal, System.Char needle) => throw null;
            public static System.ReadOnlySpan<System.Char> LeftPart(this System.ReadOnlySpan<System.Char> strVal, string needle) => throw null;
            public static System.ReadOnlySpan<System.Char> LeftPart(this System.ReadOnlySpan<System.Char> strVal, System.Char needle) => throw null;
            public static System.ReadOnlySpan<System.Char> ParentDirectory(this System.ReadOnlySpan<System.Char> filePath) => throw null;
            public static System.Byte[] ParseBase64(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static bool ParseBoolean(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.Byte ParseByte(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.Decimal ParseDecimal(this System.ReadOnlySpan<System.Char> value, bool allowThousands) => throw null;
            public static System.Decimal ParseDecimal(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static double ParseDouble(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static float ParseFloat(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.Guid ParseGuid(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.Int16 ParseInt16(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static int ParseInt32(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.Int64 ParseInt64(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.SByte ParseSByte(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static object ParseSignedInteger(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.UInt16 ParseUInt16(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.UInt32 ParseUInt32(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.UInt64 ParseUInt64(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.ReadOnlySpan<System.Char> RightPart(this System.ReadOnlySpan<System.Char> strVal, string needle) => throw null;
            public static System.ReadOnlySpan<System.Char> RightPart(this System.ReadOnlySpan<System.Char> strVal, System.Char needle) => throw null;
            public static System.ReadOnlySpan<System.Char> SafeSlice(this System.ReadOnlySpan<System.Char> value, int startIndex, int length) => throw null;
            public static System.ReadOnlySpan<System.Char> SafeSlice(this System.ReadOnlySpan<System.Char> value, int startIndex) => throw null;
            public static System.ReadOnlySpan<System.Char> SafeSubstring(this System.ReadOnlySpan<System.Char> value, int startIndex, int length) => throw null;
            public static System.ReadOnlySpan<System.Char> SafeSubstring(this System.ReadOnlySpan<System.Char> value, int startIndex) => throw null;
            public static void SplitOnFirst(this System.ReadOnlySpan<System.Char> strVal, string needle, out System.ReadOnlySpan<System.Char> first, out System.ReadOnlySpan<System.Char> last) => throw null;
            public static void SplitOnFirst(this System.ReadOnlySpan<System.Char> strVal, System.Char needle, out System.ReadOnlySpan<System.Char> first, out System.ReadOnlySpan<System.Char> last) => throw null;
            public static void SplitOnLast(this System.ReadOnlySpan<System.Char> strVal, string needle, out System.ReadOnlySpan<System.Char> first, out System.ReadOnlySpan<System.Char> last) => throw null;
            public static void SplitOnLast(this System.ReadOnlySpan<System.Char> strVal, System.Char needle, out System.ReadOnlySpan<System.Char> first, out System.ReadOnlySpan<System.Char> last) => throw null;
            public static bool StartsWith(this System.ReadOnlySpan<System.Char> value, string other, System.StringComparison comparison) => throw null;
            public static bool StartsWith(this System.ReadOnlySpan<System.Char> value, string other) => throw null;
            public static bool StartsWithIgnoreCase(this System.ReadOnlySpan<System.Char> value, System.ReadOnlySpan<System.Char> other) => throw null;
            public static System.ReadOnlySpan<System.Char> Subsegment(this System.ReadOnlySpan<System.Char> text, int startPos, int length) => throw null;
            public static System.ReadOnlySpan<System.Char> Subsegment(this System.ReadOnlySpan<System.Char> text, int startPos) => throw null;
            public static string Substring(this System.ReadOnlySpan<System.Char> value, int pos, int length) => throw null;
            public static string Substring(this System.ReadOnlySpan<System.Char> value, int pos) => throw null;
            public static string SubstringWithEllipsis(this System.ReadOnlySpan<System.Char> value, int startIndex, int length) => throw null;
            public static System.Collections.Generic.List<string> ToStringList(this System.Collections.Generic.IEnumerable<System.ReadOnlyMemory<System.Char>> from) => throw null;
            public static System.ReadOnlyMemory<System.Byte> ToUtf8(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.Byte[] ToUtf8Bytes(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.ReadOnlySpan<System.Char> TrimEnd(this System.ReadOnlySpan<System.Char> value, params System.Char[] trimChars) => throw null;
            public static bool TryParseBoolean(this System.ReadOnlySpan<System.Char> value, out bool result) => throw null;
            public static bool TryParseDecimal(this System.ReadOnlySpan<System.Char> value, out System.Decimal result) => throw null;
            public static bool TryParseDouble(this System.ReadOnlySpan<System.Char> value, out double result) => throw null;
            public static bool TryParseFloat(this System.ReadOnlySpan<System.Char> value, out float result) => throw null;
            public static bool TryReadLine(this System.ReadOnlySpan<System.Char> text, out System.ReadOnlySpan<System.Char> line, ref int startIndex) => throw null;
            public static bool TryReadPart(this System.ReadOnlySpan<System.Char> text, string needle, out System.ReadOnlySpan<System.Char> part, ref int startIndex) => throw null;
            public static string Value(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.ReadOnlySpan<System.Char> WithoutBom(this System.ReadOnlySpan<System.Char> value) => throw null;
            public static System.ReadOnlySpan<System.Byte> WithoutBom(this System.ReadOnlySpan<System.Byte> value) => throw null;
            public static System.ReadOnlySpan<System.Char> WithoutExtension(this System.ReadOnlySpan<System.Char> filePath) => throw null;
            public static System.Threading.Tasks.Task WriteAsync(this System.IO.Stream stream, System.ReadOnlySpan<System.Char> value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        }

        // Generated from `ServiceStack.Text.StringTextExtensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class StringTextExtensions
        {
            public static object To(this string value, System.Type type) => throw null;
            public static T To<T>(this string value, T defaultValue) => throw null;
            public static T To<T>(this string value) => throw null;
            public static T ToOrDefaultValue<T>(this string value) => throw null;
        }

        // Generated from `ServiceStack.Text.StringWriterCache` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class StringWriterCache
        {
            public static System.IO.StringWriter Allocate() => throw null;
            public static void Free(System.IO.StringWriter writer) => throw null;
            public static string ReturnAndFree(System.IO.StringWriter writer) => throw null;
        }

        // Generated from `ServiceStack.Text.StringWriterCacheAlt` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class StringWriterCacheAlt
        {
            public static System.IO.StringWriter Allocate() => throw null;
            public static void Free(System.IO.StringWriter writer) => throw null;
            public static string ReturnAndFree(System.IO.StringWriter writer) => throw null;
        }

        // Generated from `ServiceStack.Text.SystemTime` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class SystemTime
        {
            public static System.DateTime Now { get => throw null; }
            public static System.Func<System.DateTime> UtcDateTimeResolver;
            public static System.DateTime UtcNow { get => throw null; }
        }

        // Generated from `ServiceStack.Text.TextCase` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public enum TextCase
        {
            CamelCase,
            Default,
            PascalCase,
            SnakeCase,
        }

        // Generated from `ServiceStack.Text.TimeSpanHandler` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public enum TimeSpanHandler
        {
            DurationFormat,
            StandardFormat,
        }

        // Generated from `ServiceStack.Text.Tracer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class Tracer
        {
            // Generated from `ServiceStack.Text.Tracer+ConsoleTracer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class ConsoleTracer : ServiceStack.Text.ITracer
            {
                public ConsoleTracer() => throw null;
                public void WriteDebug(string format, params object[] args) => throw null;
                public void WriteDebug(string error) => throw null;
                public void WriteError(string format, params object[] args) => throw null;
                public void WriteError(string error) => throw null;
                public void WriteError(System.Exception ex) => throw null;
                public void WriteWarning(string warning) => throw null;
                public void WriteWarning(string format, params object[] args) => throw null;
            }


            public static ServiceStack.Text.ITracer Instance;
            // Generated from `ServiceStack.Text.Tracer+NullTracer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class NullTracer : ServiceStack.Text.ITracer
            {
                public NullTracer() => throw null;
                public void WriteDebug(string format, params object[] args) => throw null;
                public void WriteDebug(string error) => throw null;
                public void WriteError(string format, params object[] args) => throw null;
                public void WriteError(string error) => throw null;
                public void WriteError(System.Exception ex) => throw null;
                public void WriteWarning(string warning) => throw null;
                public void WriteWarning(string format, params object[] args) => throw null;
            }


            public Tracer() => throw null;
        }

        // Generated from `ServiceStack.Text.TracerExceptions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class TracerExceptions
        {
            public static T Trace<T>(this T ex) where T : System.Exception => throw null;
        }

        // Generated from `ServiceStack.Text.TranslateListWithConvertibleElements<,>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class TranslateListWithConvertibleElements<TFrom, TTo>
        {
            public static object LateBoundTranslateToGenericICollection(object fromList, System.Type toInstanceOfType) => throw null;
            public TranslateListWithConvertibleElements() => throw null;
            public static System.Collections.Generic.ICollection<TTo> TranslateToGenericICollection(System.Collections.Generic.ICollection<TFrom> fromList, System.Type toInstanceOfType) => throw null;
        }

        // Generated from `ServiceStack.Text.TranslateListWithElements` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class TranslateListWithElements
        {
            public static object TranslateToConvertibleGenericICollectionCache(object from, System.Type toInstanceOfType, System.Type fromElementType) => throw null;
            public static object TranslateToGenericICollectionCache(object from, System.Type toInstanceOfType, System.Type elementType) => throw null;
            public static object TryTranslateCollections(System.Type fromPropertyType, System.Type toPropertyType, object fromValue) => throw null;
        }

        // Generated from `ServiceStack.Text.TranslateListWithElements<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class TranslateListWithElements<T>
        {
            public static object CreateInstance(System.Type toInstanceOfType) => throw null;
            public static object LateBoundTranslateToGenericICollection(object fromList, System.Type toInstanceOfType) => throw null;
            public TranslateListWithElements() => throw null;
            public static System.Collections.Generic.ICollection<T> TranslateToGenericICollection(System.Collections.IEnumerable fromList, System.Type toInstanceOfType) => throw null;
            public static System.Collections.IList TranslateToIList(System.Collections.IList fromList, System.Type toInstanceOfType) => throw null;
        }

        // Generated from `ServiceStack.Text.TypeConfig<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class TypeConfig<T>
        {
            public static bool EnableAnonymousFieldSetters { get => throw null; set => throw null; }
            public static System.Reflection.FieldInfo[] Fields { get => throw null; set => throw null; }
            public static bool IsUserType { get => throw null; set => throw null; }
            public static System.Func<object, string, object, object> OnDeserializing { get => throw null; set => throw null; }
            public static System.Reflection.PropertyInfo[] Properties { get => throw null; set => throw null; }
            public static void Reset() => throw null;
        }

        // Generated from `ServiceStack.Text.TypeSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class TypeSerializer
        {
            public static bool CanCreateFromString(System.Type type) => throw null;
            public static T Clone<T>(T value) => throw null;
            public static object DeserializeFromReader(System.IO.TextReader reader, System.Type type) => throw null;
            public static T DeserializeFromReader<T>(System.IO.TextReader reader) => throw null;
            public static object DeserializeFromSpan(System.Type type, System.ReadOnlySpan<System.Char> value) => throw null;
            public static T DeserializeFromSpan<T>(System.ReadOnlySpan<System.Char> value) => throw null;
            public static object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public static T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public static System.Threading.Tasks.Task<object> DeserializeFromStreamAsync(System.Type type, System.IO.Stream stream) => throw null;
            public static System.Threading.Tasks.Task<T> DeserializeFromStreamAsync<T>(System.IO.Stream stream) => throw null;
            public static object DeserializeFromString(string value, System.Type type) => throw null;
            public static T DeserializeFromString<T>(string value) => throw null;
            public const string DoubleQuoteString = default;
            public static string Dump<T>(this T instance) => throw null;
            public static string Dump(this System.Delegate fn) => throw null;
            public static bool HasCircularReferences(object value) => throw null;
            public static string IndentJson(this string json) => throw null;
            public static System.Action<object> OnSerialize { get => throw null; set => throw null; }
            public static void Print(this string text, params object[] args) => throw null;
            public static void Print(this int intValue) => throw null;
            public static void Print(this System.Int64 longValue) => throw null;
            public static void PrintDump<T>(this T instance) => throw null;
            public static string SerializeAndFormat<T>(this T instance) => throw null;
            public static void SerializeToStream<T>(T value, System.IO.Stream stream) => throw null;
            public static void SerializeToStream(object value, System.Type type, System.IO.Stream stream) => throw null;
            public static string SerializeToString<T>(T value) => throw null;
            public static string SerializeToString(object value, System.Type type) => throw null;
            public static void SerializeToWriter<T>(T value, System.IO.TextWriter writer) => throw null;
            public static void SerializeToWriter(object value, System.Type type, System.IO.TextWriter writer) => throw null;
            public static System.Collections.Generic.Dictionary<string, string> ToStringDictionary(this object obj) => throw null;
            public static System.Text.UTF8Encoding UTF8Encoding { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Text.TypeSerializer<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class TypeSerializer<T> : ServiceStack.Text.ITypeSerializer<T>
        {
            public bool CanCreateFromString(System.Type type) => throw null;
            public T DeserializeFromReader(System.IO.TextReader reader) => throw null;
            public T DeserializeFromString(string value) => throw null;
            public string SerializeToString(T value) => throw null;
            public void SerializeToWriter(T value, System.IO.TextWriter writer) => throw null;
            public TypeSerializer() => throw null;
        }

        // Generated from `ServiceStack.Text.XmlSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class XmlSerializer
        {
            public static T DeserializeFromReader<T>(System.IO.TextReader reader) => throw null;
            public static object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public static T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public static object DeserializeFromString(string xml, System.Type type) => throw null;
            public static T DeserializeFromString<T>(string xml) => throw null;
            public static ServiceStack.Text.XmlSerializer Instance;
            public static void SerializeToStream(object obj, System.IO.Stream stream) => throw null;
            public static string SerializeToString<T>(T from) => throw null;
            public static void SerializeToWriter<T>(T value, System.IO.TextWriter writer) => throw null;
            public static System.Xml.XmlReaderSettings XmlReaderSettings;
            public XmlSerializer(bool omitXmlDeclaration = default(bool), int maxCharsInDocument = default(int)) => throw null;
            public static System.Xml.XmlWriterSettings XmlWriterSettings;
        }

        namespace Common
        {
            // Generated from `ServiceStack.Text.Common.ConvertInstanceDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate object ConvertInstanceDelegate(object obj, System.Type type);

            // Generated from `ServiceStack.Text.Common.ConvertObjectDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate object ConvertObjectDelegate(object fromObject);

            // Generated from `ServiceStack.Text.Common.DateTimeSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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
                public static System.Func<string, System.Exception, System.DateTime> OnParseErrorFn { get => throw null; set => throw null; }
                public static System.DateTime ParseDateTime(string dateTimeStr) => throw null;
                public static System.DateTimeOffset ParseDateTimeOffset(string dateTimeOffsetStr) => throw null;
                public static System.DateTime? ParseManual(string dateTimeStr, System.DateTimeKind dateKind) => throw null;
                public static System.DateTime? ParseManual(string dateTimeStr) => throw null;
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
                public static string ToXsdTimeSpanString(System.TimeSpan? timeSpan) => throw null;
                public static string ToXsdTimeSpanString(System.TimeSpan timeSpan) => throw null;
                public const string UnspecifiedOffset = default;
                public const string UtcOffset = default;
                public const string WcfJsonPrefix = default;
                public const System.Char WcfJsonSuffix = default;
                public static void WriteWcfJsonDate(System.IO.TextWriter writer, System.DateTime dateTime) => throw null;
                public static void WriteWcfJsonDateTimeOffset(System.IO.TextWriter writer, System.DateTimeOffset dateTimeOffset) => throw null;
                public const string XsdDateTimeFormat = default;
                public const string XsdDateTimeFormat3F = default;
                public const string XsdDateTimeFormatSeconds = default;
            }

            // Generated from `ServiceStack.Text.Common.DeserializationErrorDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate void DeserializationErrorDelegate(object instance, System.Type propertyType, string propertyName, string propertyValueStr, System.Exception ex);

            // Generated from `ServiceStack.Text.Common.DeserializeArrayWithElements<,>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class DeserializeArrayWithElements<T, TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static T[] ParseGenericArray(string value, ServiceStack.Text.Common.ParseStringDelegate elementParseFn) => throw null;
                public static T[] ParseGenericArray(System.ReadOnlySpan<System.Char> value, ServiceStack.Text.Common.ParseStringSpanDelegate elementParseFn) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.DeserializeArrayWithElements<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class DeserializeArrayWithElements<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static System.Func<string, ServiceStack.Text.Common.ParseStringDelegate, object> GetParseFn(System.Type type) => throw null;
                public static ServiceStack.Text.Common.DeserializeArrayWithElements<TSerializer>.ParseArrayOfElementsDelegate GetParseStringSpanFn(System.Type type) => throw null;
                // Generated from `ServiceStack.Text.Common.DeserializeArrayWithElements<>+ParseArrayOfElementsDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public delegate object ParseArrayOfElementsDelegate(System.ReadOnlySpan<System.Char> value, ServiceStack.Text.Common.ParseStringSpanDelegate parseFn);


            }

            // Generated from `ServiceStack.Text.Common.DeserializeBuiltin<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class DeserializeBuiltin<T>
            {
                public static ServiceStack.Text.Common.ParseStringDelegate Parse { get => throw null; }
                public static ServiceStack.Text.Common.ParseStringSpanDelegate ParseStringSpan { get => throw null; }
            }

            // Generated from `ServiceStack.Text.Common.DeserializeDictionary<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class DeserializeDictionary<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static ServiceStack.Text.Common.ParseStringDelegate GetParseMethod(System.Type type) => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanMethod(System.Type type) => throw null;
                public static System.Collections.Generic.IDictionary<TKey, TValue> ParseDictionary<TKey, TValue>(string value, System.Type createMapType, ServiceStack.Text.Common.ParseStringDelegate parseKeyFn, ServiceStack.Text.Common.ParseStringDelegate parseValueFn) => throw null;
                public static System.Collections.Generic.IDictionary<TKey, TValue> ParseDictionary<TKey, TValue>(System.ReadOnlySpan<System.Char> value, System.Type createMapType, ServiceStack.Text.Common.ParseStringSpanDelegate parseKeyFn, ServiceStack.Text.Common.ParseStringSpanDelegate parseValueFn) => throw null;
                public static object ParseDictionaryType(string value, System.Type createMapType, System.Type[] argTypes, ServiceStack.Text.Common.ParseStringDelegate keyParseFn, ServiceStack.Text.Common.ParseStringDelegate valueParseFn) => throw null;
                public static object ParseDictionaryType(System.ReadOnlySpan<System.Char> value, System.Type createMapType, System.Type[] argTypes, ServiceStack.Text.Common.ParseStringSpanDelegate keyParseFn, ServiceStack.Text.Common.ParseStringSpanDelegate valueParseFn) => throw null;
                public static System.Collections.IDictionary ParseIDictionary(string value, System.Type dictType) => throw null;
                public static System.Collections.IDictionary ParseIDictionary(System.ReadOnlySpan<System.Char> value, System.Type dictType) => throw null;
                public static T ParseInheritedJsonObject<T>(System.ReadOnlySpan<System.Char> value) where T : ServiceStack.Text.JsonObject, new() => throw null;
                public static ServiceStack.Text.JsonObject ParseJsonObject(string value) => throw null;
                public static ServiceStack.Text.JsonObject ParseJsonObject(System.ReadOnlySpan<System.Char> value) => throw null;
                public static System.Collections.Generic.Dictionary<string, string> ParseStringDictionary(string value) => throw null;
                public static System.Collections.Generic.Dictionary<string, string> ParseStringDictionary(System.ReadOnlySpan<System.Char> value) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.DeserializeList<,>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class DeserializeList<T, TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static ServiceStack.Text.Common.ParseStringDelegate GetParseFn() => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn() => throw null;
                public static ServiceStack.Text.Common.ParseStringDelegate Parse { get => throw null; }
                public static ServiceStack.Text.Common.ParseStringSpanDelegate ParseStringSpan { get => throw null; }
            }

            // Generated from `ServiceStack.Text.Common.DeserializeListWithElements<,>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class DeserializeListWithElements<T, TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static System.Collections.Generic.ICollection<T> ParseGenericList(string value, System.Type createListType, ServiceStack.Text.Common.ParseStringDelegate parseFn) => throw null;
                public static System.Collections.Generic.ICollection<T> ParseGenericList(System.ReadOnlySpan<System.Char> value, System.Type createListType, ServiceStack.Text.Common.ParseStringSpanDelegate parseFn) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.DeserializeListWithElements<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class DeserializeListWithElements<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static System.Func<string, System.Type, ServiceStack.Text.Common.ParseStringDelegate, object> GetListTypeParseFn(System.Type createListType, System.Type elementType, ServiceStack.Text.Common.ParseStringDelegate parseFn) => throw null;
                public static ServiceStack.Text.Common.DeserializeListWithElements<TSerializer>.ParseListDelegate GetListTypeParseStringSpanFn(System.Type createListType, System.Type elementType, ServiceStack.Text.Common.ParseStringSpanDelegate parseFn) => throw null;
                public static System.Collections.Generic.List<System.Byte> ParseByteList(string value) => throw null;
                public static System.Collections.Generic.List<System.Byte> ParseByteList(System.ReadOnlySpan<System.Char> value) => throw null;
                public static System.Collections.Generic.List<int> ParseIntList(string value) => throw null;
                public static System.Collections.Generic.List<int> ParseIntList(System.ReadOnlySpan<System.Char> value) => throw null;
                // Generated from `ServiceStack.Text.Common.DeserializeListWithElements<>+ParseListDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public delegate object ParseListDelegate(System.ReadOnlySpan<System.Char> value, System.Type createListType, ServiceStack.Text.Common.ParseStringSpanDelegate parseFn);


                public static System.Collections.Generic.List<string> ParseStringList(string value) => throw null;
                public static System.Collections.Generic.List<string> ParseStringList(System.ReadOnlySpan<System.Char> value) => throw null;
                public static System.ReadOnlySpan<System.Char> StripList(System.ReadOnlySpan<System.Char> value) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.DeserializeStringSpanDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate object DeserializeStringSpanDelegate(System.Type type, System.ReadOnlySpan<System.Char> source);

            // Generated from `ServiceStack.Text.Common.DeserializeType<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class DeserializeType<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static System.Type ExtractType(string strType) => throw null;
                public static System.Type ExtractType(System.ReadOnlySpan<System.Char> strType) => throw null;
                public static object ObjectStringToType(System.ReadOnlySpan<System.Char> strType) => throw null;
                public static object ParseAbstractType<T>(System.ReadOnlySpan<System.Char> value) => throw null;
                public static object ParsePrimitive(string value) => throw null;
                public static object ParsePrimitive(System.ReadOnlySpan<System.Char> value) => throw null;
                public static object ParseQuotedPrimitive(string value) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.DeserializeTypeExensions` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class DeserializeTypeExensions
            {
                public static bool Has(this ServiceStack.Text.ParseAsType flags, ServiceStack.Text.ParseAsType flag) => throw null;
                public static object ParseNumber(this System.ReadOnlySpan<System.Char> value, bool bestFit) => throw null;
                public static object ParseNumber(this System.ReadOnlySpan<System.Char> value) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.DeserializeTypeUtils` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class DeserializeTypeUtils
            {
                public DeserializeTypeUtils() => throw null;
                public static ServiceStack.Text.Common.ParseStringDelegate GetParseMethod(System.Type type) => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanMethod(System.Type type) => throw null;
                public static System.Reflection.ConstructorInfo GetTypeStringConstructor(System.Type type) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.ITypeSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface ITypeSerializer
            {
                bool EatItemSeperatorOrMapEndChar(string value, ref int i);
                bool EatItemSeperatorOrMapEndChar(System.ReadOnlySpan<System.Char> value, ref int i);
                string EatMapKey(string value, ref int i);
                System.ReadOnlySpan<System.Char> EatMapKey(System.ReadOnlySpan<System.Char> value, ref int i);
                bool EatMapKeySeperator(string value, ref int i);
                bool EatMapKeySeperator(System.ReadOnlySpan<System.Char> value, ref int i);
                bool EatMapStartChar(string value, ref int i);
                bool EatMapStartChar(System.ReadOnlySpan<System.Char> value, ref int i);
                string EatTypeValue(string value, ref int i);
                System.ReadOnlySpan<System.Char> EatTypeValue(System.ReadOnlySpan<System.Char> value, ref int i);
                string EatValue(string value, ref int i);
                System.ReadOnlySpan<System.Char> EatValue(System.ReadOnlySpan<System.Char> value, ref int i);
                void EatWhitespace(string value, ref int i);
                void EatWhitespace(System.ReadOnlySpan<System.Char> value, ref int i);
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
                string ParseString(System.ReadOnlySpan<System.Char> value);
                string TypeAttrInObject { get; }
                string UnescapeSafeString(string value);
                System.ReadOnlySpan<System.Char> UnescapeSafeString(System.ReadOnlySpan<System.Char> value);
                string UnescapeString(string value);
                System.ReadOnlySpan<System.Char> UnescapeString(System.ReadOnlySpan<System.Char> value);
                object UnescapeStringAsObject(System.ReadOnlySpan<System.Char> value);
                void WriteBool(System.IO.TextWriter writer, object boolValue);
                void WriteBuiltIn(System.IO.TextWriter writer, object value);
                void WriteByte(System.IO.TextWriter writer, object byteValue);
                void WriteBytes(System.IO.TextWriter writer, object oByteValue);
                void WriteChar(System.IO.TextWriter writer, object charValue);
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
                void WriteNullableDateTime(System.IO.TextWriter writer, object dateTime);
                void WriteNullableDateTimeOffset(System.IO.TextWriter writer, object dateTimeOffset);
                void WriteNullableGuid(System.IO.TextWriter writer, object oValue);
                void WriteNullableTimeSpan(System.IO.TextWriter writer, object dateTimeOffset);
                void WriteObjectString(System.IO.TextWriter writer, object value);
                void WritePropertyName(System.IO.TextWriter writer, string value);
                void WriteRawString(System.IO.TextWriter writer, string value);
                void WriteSByte(System.IO.TextWriter writer, object sbyteValue);
                void WriteString(System.IO.TextWriter writer, string value);
                void WriteTimeSpan(System.IO.TextWriter writer, object dateTimeOffset);
                void WriteUInt16(System.IO.TextWriter writer, object intValue);
                void WriteUInt32(System.IO.TextWriter writer, object uintValue);
                void WriteUInt64(System.IO.TextWriter writer, object ulongValue);
            }

            // Generated from `ServiceStack.Text.Common.JsReader<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class JsReader<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public ServiceStack.Text.Common.ParseStringDelegate GetParseFn<T>() => throw null;
                public ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn<T>() => throw null;
                public static void InitAot<T>() => throw null;
                public JsReader() => throw null;
            }

            // Generated from `ServiceStack.Text.Common.JsWriter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class JsWriter
            {
                public static void AssertAllowedRuntimeType(System.Type type) => throw null;
                public static System.Char[] CsvChars;
                public const string EmptyMap = default;
                public static System.Char[] EscapeChars;
                public const string EscapedQuoteString = default;
                public static ServiceStack.Text.Common.ITypeSerializer GetTypeSerializer<TSerializer>() => throw null;
                public static bool HasAnyEscapeChars(string value) => throw null;
                public const System.Char ItemSeperator = default;
                public const string ItemSeperatorString = default;
                public const System.Char LineFeedChar = default;
                public const System.Char ListEndChar = default;
                public const System.Char ListStartChar = default;
                public const System.Char MapEndChar = default;
                public const System.Char MapKeySeperator = default;
                public const string MapKeySeperatorString = default;
                public const string MapNullValue = default;
                public const System.Char MapStartChar = default;
                public const System.Char QuoteChar = default;
                public const string QuoteString = default;
                public const System.Char ReturnChar = default;
                public static bool ShouldAllowRuntimeType(System.Type type) => throw null;
                public const string TypeAttr = default;
                public static void WriteDynamic(System.Action callback) => throw null;
                public static void WriteEnumFlags(System.IO.TextWriter writer, object enumFlagValue) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.JsWriter<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class JsWriter<TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public ServiceStack.Text.Common.WriteObjectDelegate GetSpecialWriteFn(System.Type type) => throw null;
                public ServiceStack.Text.Common.WriteObjectDelegate GetValueTypeToStringMethod(System.Type type) => throw null;
                public ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn<T>() => throw null;
                public static void InitAot<T>() => throw null;
                public JsWriter() => throw null;
                public System.Collections.Generic.Dictionary<System.Type, ServiceStack.Text.Common.WriteObjectDelegate> SpecialTypes;
                public void WriteType(System.IO.TextWriter writer, object value) => throw null;
                public void WriteValue(System.IO.TextWriter writer, object value) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.ObjectDeserializerDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate object ObjectDeserializerDelegate(System.ReadOnlySpan<System.Char> value);

            // Generated from `ServiceStack.Text.Common.ParseStringDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate object ParseStringDelegate(string stringValue);

            // Generated from `ServiceStack.Text.Common.ParseStringSpanDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate object ParseStringSpanDelegate(System.ReadOnlySpan<System.Char> value);

            // Generated from `ServiceStack.Text.Common.StaticParseMethod<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class StaticParseMethod<T>
            {
                public static ServiceStack.Text.Common.ParseStringDelegate Parse { get => throw null; }
                public static ServiceStack.Text.Common.ParseStringSpanDelegate ParseStringSpan { get => throw null; }
            }

            // Generated from `ServiceStack.Text.Common.ToStringDictionaryMethods<,,>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class ToStringDictionaryMethods<TKey, TValue, TSerializer> where TSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static void WriteGenericIDictionary(System.IO.TextWriter writer, System.Collections.Generic.IDictionary<TKey, TValue> map, ServiceStack.Text.Common.WriteObjectDelegate writeKeyFn, ServiceStack.Text.Common.WriteObjectDelegate writeValueFn) => throw null;
                public static void WriteIDictionary(System.IO.TextWriter writer, object oMap, ServiceStack.Text.Common.WriteObjectDelegate writeKeyFn, ServiceStack.Text.Common.WriteObjectDelegate writeValueFn) => throw null;
            }

            // Generated from `ServiceStack.Text.Common.WriteListsOfElements<,>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

            // Generated from `ServiceStack.Text.Common.WriteListsOfElements<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

            // Generated from `ServiceStack.Text.Common.WriteObjectDelegate` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public delegate void WriteObjectDelegate(System.IO.TextWriter writer, object obj);

        }
        namespace Controller
        {
            // Generated from `ServiceStack.Text.Controller.CommandProcessor` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class CommandProcessor
            {
                public CommandProcessor(object[] controllers) => throw null;
                public void Invoke(string commandUri) => throw null;
            }

            // Generated from `ServiceStack.Text.Controller.PathInfo` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class PathInfo
            {
                public string ActionName { get => throw null; set => throw null; }
                public System.Collections.Generic.List<string> Arguments { get => throw null; set => throw null; }
                public string ControllerName { get => throw null; set => throw null; }
                public string FirstArgument { get => throw null; }
                public T GetArgumentValue<T>(int index) => throw null;
                public System.Collections.Generic.Dictionary<string, string> Options { get => throw null; set => throw null; }
                public static ServiceStack.Text.Controller.PathInfo Parse(string pathUri) => throw null;
                public PathInfo(string actionName, params string[] arguments) => throw null;
                public PathInfo(string actionName, System.Collections.Generic.List<string> arguments, System.Collections.Generic.Dictionary<string, string> options) => throw null;
            }

        }
        namespace Json
        {
            // Generated from `ServiceStack.Text.Json.JsonReader` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class JsonReader
            {
                public static void InitAot<T>() => throw null;
                public static ServiceStack.Text.Common.JsReader<ServiceStack.Text.Json.JsonTypeSerializer> Instance;
            }

            // Generated from `ServiceStack.Text.Json.JsonTypeSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public struct JsonTypeSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public static string ConvertFromUtf32(int utf32) => throw null;
                public bool EatItemSeperatorOrMapEndChar(string value, ref int i) => throw null;
                public bool EatItemSeperatorOrMapEndChar(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public string EatMapKey(string value, ref int i) => throw null;
                public System.ReadOnlySpan<System.Char> EatMapKey(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public bool EatMapKeySeperator(string value, ref int i) => throw null;
                public bool EatMapKeySeperator(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public bool EatMapStartChar(string value, ref int i) => throw null;
                public bool EatMapStartChar(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public string EatTypeValue(string value, ref int i) => throw null;
                public System.ReadOnlySpan<System.Char> EatTypeValue(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public string EatValue(string value, ref int i) => throw null;
                public System.ReadOnlySpan<System.Char> EatValue(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public void EatWhitespace(string value, ref int i) => throw null;
                public void EatWhitespace(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
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
                public static bool IsEmptyMap(System.ReadOnlySpan<System.Char> value, int i = default(int)) => throw null;
                // Stub generator skipped constructor 
                public ServiceStack.Text.Common.ObjectDeserializerDelegate ObjectDeserializer { get => throw null; set => throw null; }
                public string ParseRawString(string value) => throw null;
                public string ParseString(string value) => throw null;
                public string ParseString(System.ReadOnlySpan<System.Char> value) => throw null;
                public string TypeAttrInObject { get => throw null; }
                public static string Unescape(string input, bool removeQuotes) => throw null;
                public static string Unescape(string input) => throw null;
                public static System.ReadOnlySpan<System.Char> Unescape(System.ReadOnlySpan<System.Char> input, bool removeQuotes, System.Char quoteChar) => throw null;
                public static System.ReadOnlySpan<System.Char> Unescape(System.ReadOnlySpan<System.Char> input, bool removeQuotes) => throw null;
                public static System.ReadOnlySpan<System.Char> Unescape(System.ReadOnlySpan<System.Char> input) => throw null;
                public static System.ReadOnlySpan<System.Char> UnescapeJsString(System.ReadOnlySpan<System.Char> json, System.Char quoteChar, bool removeQuotes, ref int index) => throw null;
                public static System.ReadOnlySpan<System.Char> UnescapeJsString(System.ReadOnlySpan<System.Char> json, System.Char quoteChar) => throw null;
                public string UnescapeSafeString(string value) => throw null;
                public System.ReadOnlySpan<System.Char> UnescapeSafeString(System.ReadOnlySpan<System.Char> value) => throw null;
                public string UnescapeString(string value) => throw null;
                public System.ReadOnlySpan<System.Char> UnescapeString(System.ReadOnlySpan<System.Char> value) => throw null;
                public object UnescapeStringAsObject(System.ReadOnlySpan<System.Char> value) => throw null;
                public void WriteBool(System.IO.TextWriter writer, object boolValue) => throw null;
                public void WriteBuiltIn(System.IO.TextWriter writer, object value) => throw null;
                public void WriteByte(System.IO.TextWriter writer, object byteValue) => throw null;
                public void WriteBytes(System.IO.TextWriter writer, object oByteValue) => throw null;
                public void WriteChar(System.IO.TextWriter writer, object charValue) => throw null;
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
                public void WriteNullableDateTime(System.IO.TextWriter writer, object dateTime) => throw null;
                public void WriteNullableDateTimeOffset(System.IO.TextWriter writer, object dateTimeOffset) => throw null;
                public void WriteNullableGuid(System.IO.TextWriter writer, object oValue) => throw null;
                public void WriteNullableTimeSpan(System.IO.TextWriter writer, object oTimeSpan) => throw null;
                public void WriteObjectString(System.IO.TextWriter writer, object value) => throw null;
                public void WritePropertyName(System.IO.TextWriter writer, string value) => throw null;
                public void WriteRawString(System.IO.TextWriter writer, string value) => throw null;
                public void WriteSByte(System.IO.TextWriter writer, object sbyteValue) => throw null;
                public void WriteString(System.IO.TextWriter writer, string value) => throw null;
                public void WriteTimeSpan(System.IO.TextWriter writer, object oTimeSpan) => throw null;
                public void WriteUInt16(System.IO.TextWriter writer, object intValue) => throw null;
                public void WriteUInt32(System.IO.TextWriter writer, object uintValue) => throw null;
                public void WriteUInt64(System.IO.TextWriter writer, object ulongValue) => throw null;
            }

            // Generated from `ServiceStack.Text.Json.JsonUtils` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class JsonUtils
            {
                public const System.Char BackspaceChar = default;
                public const System.Char CarriageReturnChar = default;
                public const System.Char EscapeChar = default;
                public const string False = default;
                public const System.Char FormFeedChar = default;
                public static void IntToHex(int intValue, System.Char[] hex) => throw null;
                public static bool IsJsArray(string value) => throw null;
                public static bool IsJsArray(System.ReadOnlySpan<System.Char> value) => throw null;
                public static bool IsJsObject(string value) => throw null;
                public static bool IsJsObject(System.ReadOnlySpan<System.Char> value) => throw null;
                public static bool IsWhiteSpace(System.Char c) => throw null;
                public const System.Char LineFeedChar = default;
                public const System.Int64 MaxInteger = default;
                public const System.Int64 MinInteger = default;
                public const string Null = default;
                public const System.Char QuoteChar = default;
                public const System.Char SpaceChar = default;
                public const System.Char TabChar = default;
                public const string True = default;
                public static System.Char[] WhiteSpaceChars;
                public static void WriteString(System.IO.TextWriter writer, string value) => throw null;
            }

            // Generated from `ServiceStack.Text.Json.JsonWriter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class JsonWriter
            {
                public static void InitAot<T>() => throw null;
                public static ServiceStack.Text.Common.JsWriter<ServiceStack.Text.Json.JsonTypeSerializer> Instance;
            }

            // Generated from `ServiceStack.Text.Json.JsonWriter<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class JsonWriter<T>
            {
                public static ServiceStack.Text.Json.TypeInfo GetTypeInfo() => throw null;
                public static void Refresh() => throw null;
                public static void Reset() => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate WriteFn() => throw null;
                public static void WriteObject(System.IO.TextWriter writer, object value) => throw null;
                public static void WriteRootObject(System.IO.TextWriter writer, object value) => throw null;
            }

            // Generated from `ServiceStack.Text.Json.TypeInfo` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class TypeInfo
            {
                public TypeInfo() => throw null;
            }

        }
        namespace Jsv
        {
            // Generated from `ServiceStack.Text.Jsv.JsvReader` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class JsvReader
            {
                public static ServiceStack.Text.Common.ParseStringDelegate GetParseFn(System.Type type) => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseSpanFn(System.Type type) => throw null;
                public static ServiceStack.Text.Common.ParseStringSpanDelegate GetParseStringSpanFn(System.Type type) => throw null;
                public static void InitAot<T>() => throw null;
            }

            // Generated from `ServiceStack.Text.Jsv.JsvTypeSerializer` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public struct JsvTypeSerializer : ServiceStack.Text.Common.ITypeSerializer
            {
                public bool EatItemSeperatorOrMapEndChar(string value, ref int i) => throw null;
                public bool EatItemSeperatorOrMapEndChar(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public string EatMapKey(string value, ref int i) => throw null;
                public System.ReadOnlySpan<System.Char> EatMapKey(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public bool EatMapKeySeperator(string value, ref int i) => throw null;
                public bool EatMapKeySeperator(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public bool EatMapStartChar(string value, ref int i) => throw null;
                public bool EatMapStartChar(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public string EatTypeValue(string value, ref int i) => throw null;
                public System.ReadOnlySpan<System.Char> EatTypeValue(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public string EatValue(string value, ref int i) => throw null;
                public System.ReadOnlySpan<System.Char> EatValue(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
                public void EatWhitespace(string value, ref int i) => throw null;
                public void EatWhitespace(System.ReadOnlySpan<System.Char> value, ref int i) => throw null;
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
                // Stub generator skipped constructor 
                public ServiceStack.Text.Common.ObjectDeserializerDelegate ObjectDeserializer { get => throw null; set => throw null; }
                public string ParseRawString(string value) => throw null;
                public string ParseString(string value) => throw null;
                public string ParseString(System.ReadOnlySpan<System.Char> value) => throw null;
                public string TypeAttrInObject { get => throw null; }
                public string UnescapeSafeString(string value) => throw null;
                public System.ReadOnlySpan<System.Char> UnescapeSafeString(System.ReadOnlySpan<System.Char> value) => throw null;
                public string UnescapeString(string value) => throw null;
                public System.ReadOnlySpan<System.Char> UnescapeString(System.ReadOnlySpan<System.Char> value) => throw null;
                public object UnescapeStringAsObject(System.ReadOnlySpan<System.Char> value) => throw null;
                public void WriteBool(System.IO.TextWriter writer, object boolValue) => throw null;
                public void WriteBuiltIn(System.IO.TextWriter writer, object value) => throw null;
                public void WriteByte(System.IO.TextWriter writer, object byteValue) => throw null;
                public void WriteBytes(System.IO.TextWriter writer, object oByteValue) => throw null;
                public void WriteChar(System.IO.TextWriter writer, object charValue) => throw null;
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
                public void WriteNullableDateTime(System.IO.TextWriter writer, object dateTime) => throw null;
                public void WriteNullableDateTimeOffset(System.IO.TextWriter writer, object dateTimeOffset) => throw null;
                public void WriteNullableGuid(System.IO.TextWriter writer, object oValue) => throw null;
                public void WriteNullableTimeSpan(System.IO.TextWriter writer, object oTimeSpan) => throw null;
                public void WriteObjectString(System.IO.TextWriter writer, object value) => throw null;
                public void WritePropertyName(System.IO.TextWriter writer, string value) => throw null;
                public void WriteRawString(System.IO.TextWriter writer, string value) => throw null;
                public void WriteSByte(System.IO.TextWriter writer, object sbyteValue) => throw null;
                public void WriteString(System.IO.TextWriter writer, string value) => throw null;
                public void WriteTimeSpan(System.IO.TextWriter writer, object oTimeSpan) => throw null;
                public void WriteUInt16(System.IO.TextWriter writer, object intValue) => throw null;
                public void WriteUInt32(System.IO.TextWriter writer, object uintValue) => throw null;
                public void WriteUInt64(System.IO.TextWriter writer, object ulongValue) => throw null;
            }

            // Generated from `ServiceStack.Text.Jsv.JsvWriter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class JsvWriter
            {
                public static ServiceStack.Text.Common.WriteObjectDelegate GetValueTypeToStringMethod(System.Type type) => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate GetWriteFn(System.Type type) => throw null;
                public static void InitAot<T>() => throw null;
                public static ServiceStack.Text.Common.JsWriter<ServiceStack.Text.Jsv.JsvTypeSerializer> Instance;
                public static void WriteLateBoundObject(System.IO.TextWriter writer, object value) => throw null;
            }

            // Generated from `ServiceStack.Text.Jsv.JsvWriter<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class JsvWriter<T>
            {
                public static void Refresh() => throw null;
                public static void Reset() => throw null;
                public static ServiceStack.Text.Common.WriteObjectDelegate WriteFn() => throw null;
                public static void WriteObject(System.IO.TextWriter writer, object value) => throw null;
                public static void WriteRootObject(System.IO.TextWriter writer, object value) => throw null;
            }

        }
        namespace Pools
        {
            // Generated from `ServiceStack.Text.Pools.BufferPool` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class BufferPool
            {
                public const int BUFFER_LENGTH = default;
                public static void Flush() => throw null;
                public static System.Byte[] GetBuffer(int minSize) => throw null;
                public static System.Byte[] GetBuffer() => throw null;
                public static System.Byte[] GetCachedBuffer(int minSize) => throw null;
                public static void ReleaseBufferToPool(ref System.Byte[] buffer) => throw null;
                public static void ResizeAndFlushLeft(ref System.Byte[] buffer, int toFitAtLeastBytes, int copyFromIndex, int copyBytes) => throw null;
            }

            // Generated from `ServiceStack.Text.Pools.CharPool` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class CharPool
            {
                public const int BUFFER_LENGTH = default;
                public static void Flush() => throw null;
                public static System.Char[] GetBuffer(int minSize) => throw null;
                public static System.Char[] GetBuffer() => throw null;
                public static System.Char[] GetCachedBuffer(int minSize) => throw null;
                public static void ReleaseBufferToPool(ref System.Char[] buffer) => throw null;
                public static void ResizeAndFlushLeft(ref System.Char[] buffer, int toFitAtLeastchars, int copyFromIndex, int copychars) => throw null;
            }

            // Generated from `ServiceStack.Text.Pools.ObjectPool<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class ObjectPool<T> where T : class
            {
                public T Allocate() => throw null;
                // Generated from `ServiceStack.Text.Pools.ObjectPool<>+Factory` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
                public delegate T Factory();


                public void ForgetTrackedObject(T old, T replacement = default(T)) => throw null;
                public void Free(T obj) => throw null;
                public ObjectPool(ServiceStack.Text.Pools.ObjectPool<T>.Factory factory, int size) => throw null;
                public ObjectPool(ServiceStack.Text.Pools.ObjectPool<T>.Factory factory) => throw null;
            }

            // Generated from `ServiceStack.Text.Pools.PooledObject<>` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public struct PooledObject<T> : System.IDisposable where T : class
            {
                public static ServiceStack.Text.Pools.PooledObject<System.Text.StringBuilder> Create(ServiceStack.Text.Pools.ObjectPool<System.Text.StringBuilder> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.Stack<TItem>> Create<TItem>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.Stack<TItem>> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.Queue<TItem>> Create<TItem>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.Queue<TItem>> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.List<TItem>> Create<TItem>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.List<TItem>> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.HashSet<TItem>> Create<TItem>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.HashSet<TItem>> pool) => throw null;
                public static ServiceStack.Text.Pools.PooledObject<System.Collections.Generic.Dictionary<TKey, TValue>> Create<TKey, TValue>(ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.Dictionary<TKey, TValue>> pool) => throw null;
                public void Dispose() => throw null;
                public T Object { get => throw null; }
                public PooledObject(ServiceStack.Text.Pools.ObjectPool<T> pool, System.Func<ServiceStack.Text.Pools.ObjectPool<T>, T> allocator, System.Action<ServiceStack.Text.Pools.ObjectPool<T>, T> releaser) => throw null;
                // Stub generator skipped constructor 
            }

            // Generated from `ServiceStack.Text.Pools.SharedPools` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class SharedPools
            {
                public static ServiceStack.Text.Pools.ObjectPool<System.Byte[]> AsyncByteArray;
                public static ServiceStack.Text.Pools.ObjectPool<T> BigDefault<T>() where T : class, new() => throw null;
                public static ServiceStack.Text.Pools.ObjectPool<System.Byte[]> ByteArray;
                public const int ByteBufferSize = default;
                public static ServiceStack.Text.Pools.ObjectPool<T> Default<T>() where T : class, new() => throw null;
                public static ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.HashSet<string>> StringHashSet;
                public static ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.Dictionary<string, T>> StringIgnoreCaseDictionary<T>() => throw null;
                public static ServiceStack.Text.Pools.ObjectPool<System.Collections.Generic.HashSet<string>> StringIgnoreCaseHashSet;
            }

            // Generated from `ServiceStack.Text.Pools.StringBuilderPool` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public static class StringBuilderPool
            {
                public static System.Text.StringBuilder Allocate() => throw null;
                public static void Free(System.Text.StringBuilder builder) => throw null;
                public static string ReturnAndFree(System.Text.StringBuilder builder) => throw null;
            }

        }
        namespace Support
        {
            // Generated from `ServiceStack.Text.Support.DoubleConverter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class DoubleConverter
            {
                public DoubleConverter() => throw null;
                public static string ToExactString(double d) => throw null;
            }

            // Generated from `ServiceStack.Text.Support.TimeSpanConverter` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class TimeSpanConverter
            {
                public static System.TimeSpan FromXsdDuration(string xsdDuration) => throw null;
                public TimeSpanConverter() => throw null;
                public static string ToXsdDuration(System.TimeSpan timeSpan) => throw null;
            }

            // Generated from `ServiceStack.Text.Support.TypePair` in `ServiceStack.Text, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public class TypePair
            {
                public System.Type[] Arg2 { get => throw null; set => throw null; }
                public System.Type[] Args1 { get => throw null; set => throw null; }
                public override bool Equals(object obj) => throw null;
                public bool Equals(ServiceStack.Text.Support.TypePair other) => throw null;
                public override int GetHashCode() => throw null;
                public TypePair(System.Type[] arg1, System.Type[] arg2) => throw null;
            }

        }
    }
}
