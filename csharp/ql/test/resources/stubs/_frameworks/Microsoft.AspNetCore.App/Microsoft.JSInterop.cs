// This file contains auto-generated code.
// Generated from `Microsoft.JSInterop, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace JSInterop
    {
        public static class DotNetObjectReference
        {
            public static Microsoft.JSInterop.DotNetObjectReference<TValue> Create<TValue>(TValue value) where TValue : class => throw null;
        }
        public sealed class DotNetObjectReference<TValue> : System.IDisposable where TValue : class
        {
            public void Dispose() => throw null;
            public TValue Value { get => throw null; }
        }
        public sealed class DotNetStreamReference : System.IDisposable
        {
            public DotNetStreamReference(System.IO.Stream stream, bool leaveOpen = default(bool)) => throw null;
            public void Dispose() => throw null;
            public bool LeaveOpen { get => throw null; }
            public System.IO.Stream Stream { get => throw null; }
        }
        public interface IJSInProcessObjectReference : System.IAsyncDisposable, System.IDisposable, Microsoft.JSInterop.IJSObjectReference
        {
            TValue Invoke<TValue>(string identifier, params object[] args);
        }
        public interface IJSInProcessRuntime : Microsoft.JSInterop.IJSRuntime
        {
            TResult Invoke<TResult>(string identifier, params object[] args);
        }
        public interface IJSObjectReference : System.IAsyncDisposable
        {
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args);
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args);
        }
        public interface IJSRuntime
        {
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args);
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args);
        }
        public interface IJSStreamReference : System.IAsyncDisposable
        {
            long Length { get; }
            System.Threading.Tasks.ValueTask<System.IO.Stream> OpenReadStreamAsync(long maxAllowedSize = default(long), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        }
        public interface IJSUnmarshalledObjectReference : System.IAsyncDisposable, System.IDisposable, Microsoft.JSInterop.IJSInProcessObjectReference, Microsoft.JSInterop.IJSObjectReference
        {
            TResult InvokeUnmarshalled<TResult>(string identifier);
            TResult InvokeUnmarshalled<T0, TResult>(string identifier, T0 arg0);
            TResult InvokeUnmarshalled<T0, T1, TResult>(string identifier, T0 arg0, T1 arg1);
            TResult InvokeUnmarshalled<T0, T1, T2, TResult>(string identifier, T0 arg0, T1 arg1, T2 arg2);
        }
        public interface IJSUnmarshalledRuntime
        {
            TResult InvokeUnmarshalled<TResult>(string identifier);
            TResult InvokeUnmarshalled<T0, TResult>(string identifier, T0 arg0);
            TResult InvokeUnmarshalled<T0, T1, TResult>(string identifier, T0 arg0, T1 arg1);
            TResult InvokeUnmarshalled<T0, T1, T2, TResult>(string identifier, T0 arg0, T1 arg1, T2 arg2);
        }
        namespace Implementation
        {
            public class JSInProcessObjectReference : Microsoft.JSInterop.Implementation.JSObjectReference, System.IAsyncDisposable, System.IDisposable, Microsoft.JSInterop.IJSInProcessObjectReference, Microsoft.JSInterop.IJSObjectReference
            {
                protected JSInProcessObjectReference(Microsoft.JSInterop.JSInProcessRuntime jsRuntime, long id) : base(default(Microsoft.JSInterop.JSRuntime), default(long)) => throw null;
                public void Dispose() => throw null;
                public TValue Invoke<TValue>(string identifier, params object[] args) => throw null;
            }
            public class JSObjectReference : System.IAsyncDisposable, Microsoft.JSInterop.IJSObjectReference
            {
                protected JSObjectReference(Microsoft.JSInterop.JSRuntime jsRuntime, long id) => throw null;
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                protected long Id { get => throw null; }
                public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args) => throw null;
                public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args) => throw null;
                protected void ThrowIfDisposed() => throw null;
            }
            public static class JSObjectReferenceJsonWorker
            {
                public static long ReadJSObjectReferenceIdentifier(ref System.Text.Json.Utf8JsonReader reader) => throw null;
                public static void WriteJSObjectReference(System.Text.Json.Utf8JsonWriter writer, Microsoft.JSInterop.Implementation.JSObjectReference objectReference) => throw null;
            }
            public sealed class JSStreamReference : Microsoft.JSInterop.Implementation.JSObjectReference, System.IAsyncDisposable, Microsoft.JSInterop.IJSStreamReference
            {
                public long Length { get => throw null; }
                System.Threading.Tasks.ValueTask<System.IO.Stream> Microsoft.JSInterop.IJSStreamReference.OpenReadStreamAsync(long maxAllowedSize, System.Threading.CancellationToken cancellationToken) => throw null;
                internal JSStreamReference() : base(default(Microsoft.JSInterop.JSRuntime), default(long)) { }
            }
        }
        namespace Infrastructure
        {
            public static class DotNetDispatcher
            {
                public static void BeginInvokeDotNet(Microsoft.JSInterop.JSRuntime jsRuntime, Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo invocationInfo, string argsJson) => throw null;
                public static void EndInvokeJS(Microsoft.JSInterop.JSRuntime jsRuntime, string arguments) => throw null;
                public static string Invoke(Microsoft.JSInterop.JSRuntime jsRuntime, in Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo invocationInfo, string argsJson) => throw null;
                public static void ReceiveByteArray(Microsoft.JSInterop.JSRuntime jsRuntime, int id, byte[] data) => throw null;
            }
            public struct DotNetInvocationInfo
            {
                public string AssemblyName { get => throw null; }
                public string CallId { get => throw null; }
                public DotNetInvocationInfo(string assemblyName, string methodIdentifier, long dotNetObjectId, string callId) => throw null;
                public long DotNetObjectId { get => throw null; }
                public string MethodIdentifier { get => throw null; }
            }
            public struct DotNetInvocationResult
            {
                public string ErrorKind { get => throw null; }
                public System.Exception Exception { get => throw null; }
                public string ResultJson { get => throw null; }
                public bool Success { get => throw null; }
            }
            public interface IJSVoidResult
            {
            }
        }
        public enum JSCallResultType
        {
            Default = 0,
            JSObjectReference = 1,
            JSStreamReference = 2,
            JSVoidResult = 3,
        }
        public sealed class JSDisconnectedException : System.Exception
        {
            public JSDisconnectedException(string message) => throw null;
        }
        public class JSException : System.Exception
        {
            public JSException(string message) => throw null;
            public JSException(string message, System.Exception innerException) => throw null;
        }
        public static partial class JSInProcessObjectReferenceExtensions
        {
            public static void InvokeVoid(this Microsoft.JSInterop.IJSInProcessObjectReference jsObjectReference, string identifier, params object[] args) => throw null;
        }
        public abstract class JSInProcessRuntime : Microsoft.JSInterop.JSRuntime, Microsoft.JSInterop.IJSInProcessRuntime, Microsoft.JSInterop.IJSRuntime
        {
            protected JSInProcessRuntime() => throw null;
            public TValue Invoke<TValue>(string identifier, params object[] args) => throw null;
            protected virtual string InvokeJS(string identifier, string argsJson) => throw null;
            protected abstract string InvokeJS(string identifier, string argsJson, Microsoft.JSInterop.JSCallResultType resultType, long targetInstanceId);
        }
        public static partial class JSInProcessRuntimeExtensions
        {
            public static void InvokeVoid(this Microsoft.JSInterop.IJSInProcessRuntime jsRuntime, string identifier, params object[] args) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = true)]
        public sealed class JSInvokableAttribute : System.Attribute
        {
            public JSInvokableAttribute() => throw null;
            public JSInvokableAttribute(string identifier) => throw null;
            public string Identifier { get => throw null; }
        }
        public static partial class JSObjectReferenceExtensions
        {
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
        }
        public abstract class JSRuntime : System.IDisposable, Microsoft.JSInterop.IJSRuntime
        {
            protected virtual void BeginInvokeJS(long taskId, string identifier, string argsJson) => throw null;
            protected abstract void BeginInvokeJS(long taskId, string identifier, string argsJson, Microsoft.JSInterop.JSCallResultType resultType, long targetInstanceId);
            protected JSRuntime() => throw null;
            protected System.TimeSpan? DefaultAsyncTimeout { get => throw null; set { } }
            public void Dispose() => throw null;
            protected abstract void EndInvokeDotNet(Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo invocationInfo, in Microsoft.JSInterop.Infrastructure.DotNetInvocationResult invocationResult);
            public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args) => throw null;
            public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args) => throw null;
            protected System.Text.Json.JsonSerializerOptions JsonSerializerOptions { get => throw null; }
            protected virtual System.Threading.Tasks.Task<System.IO.Stream> ReadJSDataAsStreamAsync(Microsoft.JSInterop.IJSStreamReference jsStreamReference, long totalLength, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected virtual void ReceiveByteArray(int id, byte[] data) => throw null;
            protected virtual void SendByteArray(int id, byte[] data) => throw null;
            protected virtual System.Threading.Tasks.Task TransmitStreamAsync(long streamId, Microsoft.JSInterop.DotNetStreamReference dotNetStreamReference) => throw null;
        }
        public static partial class JSRuntimeExtensions
        {
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
        }
    }
}
