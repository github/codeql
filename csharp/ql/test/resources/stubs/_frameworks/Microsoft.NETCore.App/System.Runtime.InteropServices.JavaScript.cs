// This file contains auto-generated code.
// Generated from `System.Runtime.InteropServices.JavaScript, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Runtime
    {
        namespace InteropServices
        {
            namespace JavaScript
            {
                public sealed class JSException : System.Exception
                {
                    public JSException(string msg) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)64, Inherited = false, AllowMultiple = false)]
                public sealed class JSExportAttribute : System.Attribute
                {
                    public JSExportAttribute() => throw null;
                }
                public sealed class JSFunctionBinding
                {
                    public static System.Runtime.InteropServices.JavaScript.JSFunctionBinding BindJSFunction(string functionName, string moduleName, System.ReadOnlySpan<System.Runtime.InteropServices.JavaScript.JSMarshalerType> signatures) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSFunctionBinding BindManagedFunction(string fullyQualifiedName, int signatureHash, System.ReadOnlySpan<System.Runtime.InteropServices.JavaScript.JSMarshalerType> signatures) => throw null;
                    public static void InvokeJS(System.Runtime.InteropServices.JavaScript.JSFunctionBinding signature, System.Span<System.Runtime.InteropServices.JavaScript.JSMarshalerArgument> arguments) => throw null;
                }
                public static class JSHost
                {
                    public static System.Runtime.InteropServices.JavaScript.JSObject DotnetInstance { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSObject GlobalThis { get => throw null; }
                    public static System.Threading.Tasks.Task<System.Runtime.InteropServices.JavaScript.JSObject> ImportAsync(string moduleName, string moduleUrl, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)64, Inherited = false, AllowMultiple = false)]
                public sealed class JSImportAttribute : System.Attribute
                {
                    public JSImportAttribute(string functionName) => throw null;
                    public JSImportAttribute(string functionName, string moduleName) => throw null;
                    public string FunctionName { get => throw null; }
                    public string ModuleName { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)10240, Inherited = false, AllowMultiple = false)]
                public sealed class JSMarshalAsAttribute<T> : System.Attribute where T : System.Runtime.InteropServices.JavaScript.JSType
                {
                    public JSMarshalAsAttribute() => throw null;
                }
                public struct JSMarshalerArgument
                {
                    public delegate void ArgumentToJSCallback<T>(ref System.Runtime.InteropServices.JavaScript.JSMarshalerArgument arg, T value);
                    public delegate void ArgumentToManagedCallback<T>(ref System.Runtime.InteropServices.JavaScript.JSMarshalerArgument arg, out T value);
                    public void Initialize() => throw null;
                    public void ToJS(bool value) => throw null;
                    public void ToJS(bool? value) => throw null;
                    public void ToJS(byte value) => throw null;
                    public void ToJS(byte? value) => throw null;
                    public void ToJS(byte[] value) => throw null;
                    public void ToJS(char value) => throw null;
                    public void ToJS(char? value) => throw null;
                    public void ToJS(short value) => throw null;
                    public void ToJS(short? value) => throw null;
                    public void ToJS(int value) => throw null;
                    public void ToJS(int? value) => throw null;
                    public void ToJS(int[] value) => throw null;
                    public void ToJS(long value) => throw null;
                    public void ToJS(long? value) => throw null;
                    public void ToJS(float value) => throw null;
                    public void ToJS(float? value) => throw null;
                    public void ToJS(double value) => throw null;
                    public void ToJS(double? value) => throw null;
                    public void ToJS(double[] value) => throw null;
                    public void ToJS(nint value) => throw null;
                    public void ToJS(nint? value) => throw null;
                    public void ToJS(System.DateTimeOffset value) => throw null;
                    public void ToJS(System.DateTimeOffset? value) => throw null;
                    public void ToJS(System.DateTime value) => throw null;
                    public void ToJS(System.DateTime? value) => throw null;
                    public void ToJS(string value) => throw null;
                    public void ToJS(string[] value) => throw null;
                    public void ToJS(System.Exception value) => throw null;
                    public void ToJS(object value) => throw null;
                    public void ToJS(object[] value) => throw null;
                    public void ToJS(System.Runtime.InteropServices.JavaScript.JSObject value) => throw null;
                    public void ToJS(System.Runtime.InteropServices.JavaScript.JSObject[] value) => throw null;
                    public void ToJS(System.Threading.Tasks.Task value) => throw null;
                    public void ToJS<T>(System.Threading.Tasks.Task<T> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T> marshaler) => throw null;
                    public void ToJS(System.Action value) => throw null;
                    public void ToJS<T>(System.Action<T> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T> arg1Marshaler) => throw null;
                    public void ToJS<T1, T2>(System.Action<T1, T2> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T1> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T2> arg2Marshaler) => throw null;
                    public void ToJS<T1, T2, T3>(System.Action<T1, T2, T3> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T1> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T2> arg2Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T3> arg3Marshaler) => throw null;
                    public void ToJS<TResult>(System.Func<TResult> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<TResult> resMarshaler) => throw null;
                    public void ToJS<T, TResult>(System.Func<T, TResult> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<TResult> resMarshaler) => throw null;
                    public void ToJS<T1, T2, TResult>(System.Func<T1, T2, TResult> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T1> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T2> arg2Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<TResult> resMarshaler) => throw null;
                    public void ToJS<T1, T2, T3, TResult>(System.Func<T1, T2, T3, TResult> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T1> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T2> arg2Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T3> arg3Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<TResult> resMarshaler) => throw null;
                    public unsafe void ToJS(void* value) => throw null;
                    public void ToJS(System.Span<byte> value) => throw null;
                    public void ToJS(System.ArraySegment<byte> value) => throw null;
                    public void ToJS(System.Span<int> value) => throw null;
                    public void ToJS(System.Span<double> value) => throw null;
                    public void ToJS(System.ArraySegment<int> value) => throw null;
                    public void ToJS(System.ArraySegment<double> value) => throw null;
                    public void ToJSBig(long value) => throw null;
                    public void ToJSBig(long? value) => throw null;
                    public void ToManaged(out bool value) => throw null;
                    public void ToManaged(out bool? value) => throw null;
                    public void ToManaged(out byte value) => throw null;
                    public void ToManaged(out byte? value) => throw null;
                    public void ToManaged(out byte[] value) => throw null;
                    public void ToManaged(out char value) => throw null;
                    public void ToManaged(out char? value) => throw null;
                    public void ToManaged(out short value) => throw null;
                    public void ToManaged(out short? value) => throw null;
                    public void ToManaged(out int value) => throw null;
                    public void ToManaged(out int? value) => throw null;
                    public void ToManaged(out int[] value) => throw null;
                    public void ToManaged(out long value) => throw null;
                    public void ToManaged(out long? value) => throw null;
                    public void ToManaged(out float value) => throw null;
                    public void ToManaged(out float? value) => throw null;
                    public void ToManaged(out double value) => throw null;
                    public void ToManaged(out double? value) => throw null;
                    public void ToManaged(out double[] value) => throw null;
                    public void ToManaged(out nint value) => throw null;
                    public void ToManaged(out nint? value) => throw null;
                    public void ToManaged(out System.DateTimeOffset value) => throw null;
                    public void ToManaged(out System.DateTimeOffset? value) => throw null;
                    public void ToManaged(out System.DateTime value) => throw null;
                    public void ToManaged(out System.DateTime? value) => throw null;
                    public void ToManaged(out string value) => throw null;
                    public void ToManaged(out string[] value) => throw null;
                    public void ToManaged(out System.Exception value) => throw null;
                    public void ToManaged(out object value) => throw null;
                    public void ToManaged(out object[] value) => throw null;
                    public void ToManaged(out System.Runtime.InteropServices.JavaScript.JSObject value) => throw null;
                    public void ToManaged(out System.Runtime.InteropServices.JavaScript.JSObject[] value) => throw null;
                    public void ToManaged(out System.Threading.Tasks.Task value) => throw null;
                    public void ToManaged<T>(out System.Threading.Tasks.Task<T> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<T> marshaler) => throw null;
                    public void ToManaged(out System.Action value) => throw null;
                    public void ToManaged<T>(out System.Action<T> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T> arg1Marshaler) => throw null;
                    public void ToManaged<T1, T2>(out System.Action<T1, T2> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T1> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T2> arg2Marshaler) => throw null;
                    public void ToManaged<T1, T2, T3>(out System.Action<T1, T2, T3> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T1> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T2> arg2Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T3> arg3Marshaler) => throw null;
                    public void ToManaged<TResult>(out System.Func<TResult> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<TResult> resMarshaler) => throw null;
                    public void ToManaged<T, TResult>(out System.Func<T, TResult> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<TResult> resMarshaler) => throw null;
                    public void ToManaged<T1, T2, TResult>(out System.Func<T1, T2, TResult> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T1> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T2> arg2Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<TResult> resMarshaler) => throw null;
                    public void ToManaged<T1, T2, T3, TResult>(out System.Func<T1, T2, T3, TResult> value, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T1> arg1Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T2> arg2Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToJSCallback<T3> arg3Marshaler, System.Runtime.InteropServices.JavaScript.JSMarshalerArgument.ArgumentToManagedCallback<TResult> resMarshaler) => throw null;
                    public unsafe void ToManaged(out void* value) => throw null;
                    public void ToManaged(out System.Span<byte> value) => throw null;
                    public void ToManaged(out System.ArraySegment<byte> value) => throw null;
                    public void ToManaged(out System.Span<int> value) => throw null;
                    public void ToManaged(out System.Span<double> value) => throw null;
                    public void ToManaged(out System.ArraySegment<int> value) => throw null;
                    public void ToManaged(out System.ArraySegment<double> value) => throw null;
                    public void ToManagedBig(out long value) => throw null;
                    public void ToManagedBig(out long? value) => throw null;
                }
                public sealed class JSMarshalerType
                {
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Action() => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Action(System.Runtime.InteropServices.JavaScript.JSMarshalerType arg1) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Action(System.Runtime.InteropServices.JavaScript.JSMarshalerType arg1, System.Runtime.InteropServices.JavaScript.JSMarshalerType arg2) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Action(System.Runtime.InteropServices.JavaScript.JSMarshalerType arg1, System.Runtime.InteropServices.JavaScript.JSMarshalerType arg2, System.Runtime.InteropServices.JavaScript.JSMarshalerType arg3) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Array(System.Runtime.InteropServices.JavaScript.JSMarshalerType element) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType ArraySegment(System.Runtime.InteropServices.JavaScript.JSMarshalerType element) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType BigInt64 { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Boolean { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Byte { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Char { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType DateTime { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType DateTimeOffset { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Discard { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Double { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Exception { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Function(System.Runtime.InteropServices.JavaScript.JSMarshalerType result) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Function(System.Runtime.InteropServices.JavaScript.JSMarshalerType arg1, System.Runtime.InteropServices.JavaScript.JSMarshalerType result) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Function(System.Runtime.InteropServices.JavaScript.JSMarshalerType arg1, System.Runtime.InteropServices.JavaScript.JSMarshalerType arg2, System.Runtime.InteropServices.JavaScript.JSMarshalerType result) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Function(System.Runtime.InteropServices.JavaScript.JSMarshalerType arg1, System.Runtime.InteropServices.JavaScript.JSMarshalerType arg2, System.Runtime.InteropServices.JavaScript.JSMarshalerType arg3, System.Runtime.InteropServices.JavaScript.JSMarshalerType result) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Int16 { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Int32 { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Int52 { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType IntPtr { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType JSObject { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Nullable(System.Runtime.InteropServices.JavaScript.JSMarshalerType primitive) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Object { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Single { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Span(System.Runtime.InteropServices.JavaScript.JSMarshalerType element) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType String { get => throw null; }
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Task() => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Task(System.Runtime.InteropServices.JavaScript.JSMarshalerType result) => throw null;
                    public static System.Runtime.InteropServices.JavaScript.JSMarshalerType Void { get => throw null; }
                }
                public class JSObject : System.IDisposable
                {
                    public void Dispose() => throw null;
                    public bool GetPropertyAsBoolean(string propertyName) => throw null;
                    public byte[] GetPropertyAsByteArray(string propertyName) => throw null;
                    public double GetPropertyAsDouble(string propertyName) => throw null;
                    public int GetPropertyAsInt32(string propertyName) => throw null;
                    public System.Runtime.InteropServices.JavaScript.JSObject GetPropertyAsJSObject(string propertyName) => throw null;
                    public string GetPropertyAsString(string propertyName) => throw null;
                    public string GetTypeOfProperty(string propertyName) => throw null;
                    public bool HasProperty(string propertyName) => throw null;
                    public bool IsDisposed { get => throw null; }
                    public void SetProperty(string propertyName, bool value) => throw null;
                    public void SetProperty(string propertyName, int value) => throw null;
                    public void SetProperty(string propertyName, double value) => throw null;
                    public void SetProperty(string propertyName, string value) => throw null;
                    public void SetProperty(string propertyName, System.Runtime.InteropServices.JavaScript.JSObject value) => throw null;
                    public void SetProperty(string propertyName, byte[] value) => throw null;
                }
                public abstract class JSType
                {
                    public sealed class Any : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Array<T> : System.Runtime.InteropServices.JavaScript.JSType where T : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class BigInt : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Boolean : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Date : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Discard : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Error : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Function : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Function<T> : System.Runtime.InteropServices.JavaScript.JSType where T : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Function<T1, T2> : System.Runtime.InteropServices.JavaScript.JSType where T1 : System.Runtime.InteropServices.JavaScript.JSType where T2 : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Function<T1, T2, T3> : System.Runtime.InteropServices.JavaScript.JSType where T1 : System.Runtime.InteropServices.JavaScript.JSType where T2 : System.Runtime.InteropServices.JavaScript.JSType where T3 : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Function<T1, T2, T3, T4> : System.Runtime.InteropServices.JavaScript.JSType where T1 : System.Runtime.InteropServices.JavaScript.JSType where T2 : System.Runtime.InteropServices.JavaScript.JSType where T3 : System.Runtime.InteropServices.JavaScript.JSType where T4 : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class MemoryView : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Number : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Object : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Promise<T> : System.Runtime.InteropServices.JavaScript.JSType where T : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class String : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                    public sealed class Void : System.Runtime.InteropServices.JavaScript.JSType
                    {
                    }
                }
            }
        }
    }
}
