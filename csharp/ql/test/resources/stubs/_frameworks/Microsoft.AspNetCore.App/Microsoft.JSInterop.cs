// This file contains auto-generated code.
// Generated from `Microsoft.JSInterop, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace JSInterop
    {
        public static class DotNetObjectReference
        {
            public static Microsoft.JSInterop.DotNetObjectReference<TValue> Create<TValue>(TValue value) where TValue : class => throw null;
        }

        public class DotNetObjectReference<TValue> : System.IDisposable where TValue : class
        {
            public void Dispose() => throw null;
            public TValue Value { get => throw null; }
        }

        public class DotNetStreamReference : System.IDisposable
        {
            public void Dispose() => throw null;
            public DotNetStreamReference(System.IO.Stream stream, bool leaveOpen = default(bool)) => throw null;
            public bool LeaveOpen { get => throw null; }
            public System.IO.Stream Stream { get => throw null; }
        }

        public interface IJSInProcessObjectReference : Microsoft.JSInterop.IJSObjectReference, System.IAsyncDisposable, System.IDisposable
        {
            TValue Invoke<TValue>(string identifier, params object[] args);
        }

        public interface IJSInProcessRuntime : Microsoft.JSInterop.IJSRuntime
        {
            TResult Invoke<TResult>(string identifier, params object[] args);
        }

        public interface IJSObjectReference : System.IAsyncDisposable
        {
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args);
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args);
        }

        public interface IJSRuntime
        {
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args);
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args);
        }

        public interface IJSStreamReference : System.IAsyncDisposable
        {
            System.Int64 Length { get; }
            System.Threading.Tasks.ValueTask<System.IO.Stream> OpenReadStreamAsync(System.Int64 maxAllowedSize = default(System.Int64), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        }

        public interface IJSUnmarshalledObjectReference : Microsoft.JSInterop.IJSInProcessObjectReference, Microsoft.JSInterop.IJSObjectReference, System.IAsyncDisposable, System.IDisposable
        {
            TResult InvokeUnmarshalled<T0, T1, T2, TResult>(string identifier, T0 arg0, T1 arg1, T2 arg2);
            TResult InvokeUnmarshalled<T0, T1, TResult>(string identifier, T0 arg0, T1 arg1);
            TResult InvokeUnmarshalled<T0, TResult>(string identifier, T0 arg0);
            TResult InvokeUnmarshalled<TResult>(string identifier);
        }

        public interface IJSUnmarshalledRuntime
        {
            TResult InvokeUnmarshalled<T0, T1, T2, TResult>(string identifier, T0 arg0, T1 arg1, T2 arg2);
            TResult InvokeUnmarshalled<T0, T1, TResult>(string identifier, T0 arg0, T1 arg1);
            TResult InvokeUnmarshalled<T0, TResult>(string identifier, T0 arg0);
            TResult InvokeUnmarshalled<TResult>(string identifier);
        }

        public enum JSCallResultType : int
        {
            Default = 0,
            JSObjectReference = 1,
            JSStreamReference = 2,
            JSVoidResult = 3,
        }

        public class JSDisconnectedException : System.Exception
        {
            public JSDisconnectedException(string message) => throw null;
        }

        public class JSException : System.Exception
        {
            public JSException(string message) => throw null;
            public JSException(string message, System.Exception innerException) => throw null;
        }

        public static class JSInProcessObjectReferenceExtensions
        {
            public static void InvokeVoid(this Microsoft.JSInterop.IJSInProcessObjectReference jsObjectReference, string identifier, params object[] args) => throw null;
        }

        public abstract class JSInProcessRuntime : Microsoft.JSInterop.JSRuntime, Microsoft.JSInterop.IJSInProcessRuntime, Microsoft.JSInterop.IJSRuntime
        {
            public TValue Invoke<TValue>(string identifier, params object[] args) => throw null;
            protected virtual string InvokeJS(string identifier, string argsJson) => throw null;
            protected abstract string InvokeJS(string identifier, string argsJson, Microsoft.JSInterop.JSCallResultType resultType, System.Int64 targetInstanceId);
            protected JSInProcessRuntime() => throw null;
        }

        public static class JSInProcessRuntimeExtensions
        {
            public static void InvokeVoid(this Microsoft.JSInterop.IJSInProcessRuntime jsRuntime, string identifier, params object[] args) => throw null;
        }

        public class JSInvokableAttribute : System.Attribute
        {
            public string Identifier { get => throw null; }
            public JSInvokableAttribute() => throw null;
            public JSInvokableAttribute(string identifier) => throw null;
        }

        public static class JSObjectReferenceExtensions
        {
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, params object[] args) => throw null;
        }

        public abstract class JSRuntime : Microsoft.JSInterop.IJSRuntime, System.IDisposable
        {
            protected virtual void BeginInvokeJS(System.Int64 taskId, string identifier, string argsJson) => throw null;
            protected abstract void BeginInvokeJS(System.Int64 taskId, string identifier, string argsJson, Microsoft.JSInterop.JSCallResultType resultType, System.Int64 targetInstanceId);
            protected System.TimeSpan? DefaultAsyncTimeout { get => throw null; set => throw null; }
            public void Dispose() => throw null;
            protected internal abstract void EndInvokeDotNet(Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo invocationInfo, Microsoft.JSInterop.Infrastructure.DotNetInvocationResult invocationResult);
            public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args) => throw null;
            public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args) => throw null;
            protected JSRuntime() => throw null;
            protected internal System.Text.Json.JsonSerializerOptions JsonSerializerOptions { get => throw null; }
            protected internal virtual System.Threading.Tasks.Task<System.IO.Stream> ReadJSDataAsStreamAsync(Microsoft.JSInterop.IJSStreamReference jsStreamReference, System.Int64 totalLength, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected internal virtual void ReceiveByteArray(int id, System.Byte[] data) => throw null;
            protected internal virtual void SendByteArray(int id, System.Byte[] data) => throw null;
            protected internal virtual System.Threading.Tasks.Task TransmitStreamAsync(System.Int64 streamId, Microsoft.JSInterop.DotNetStreamReference dotNetStreamReference) => throw null;
        }

        public static class JSRuntimeExtensions
        {
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, params object[] args) => throw null;
        }

        namespace Implementation
        {
            public class JSInProcessObjectReference : Microsoft.JSInterop.Implementation.JSObjectReference, Microsoft.JSInterop.IJSInProcessObjectReference, Microsoft.JSInterop.IJSObjectReference, System.IAsyncDisposable, System.IDisposable
            {
                public void Dispose() => throw null;
                public TValue Invoke<TValue>(string identifier, params object[] args) => throw null;
                protected internal JSInProcessObjectReference(Microsoft.JSInterop.JSInProcessRuntime jsRuntime, System.Int64 id) : base(default(Microsoft.JSInterop.JSRuntime), default(System.Int64)) => throw null;
            }

            public class JSObjectReference : Microsoft.JSInterop.IJSObjectReference, System.IAsyncDisposable
            {
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                protected internal System.Int64 Id { get => throw null; }
                public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args) => throw null;
                public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args) => throw null;
                protected internal JSObjectReference(Microsoft.JSInterop.JSRuntime jsRuntime, System.Int64 id) => throw null;
                protected void ThrowIfDisposed() => throw null;
            }

            public static class JSObjectReferenceJsonWorker
            {
                public static System.Int64 ReadJSObjectReferenceIdentifier(ref System.Text.Json.Utf8JsonReader reader) => throw null;
                public static void WriteJSObjectReference(System.Text.Json.Utf8JsonWriter writer, Microsoft.JSInterop.Implementation.JSObjectReference objectReference) => throw null;
            }

            public class JSStreamReference : Microsoft.JSInterop.Implementation.JSObjectReference, Microsoft.JSInterop.IJSStreamReference, System.IAsyncDisposable
            {
                internal JSStreamReference(Microsoft.JSInterop.JSRuntime jsRuntime, System.Int64 id, System.Int64 totalLength) : base(default(Microsoft.JSInterop.JSRuntime), default(System.Int64)) => throw null;
                public System.Int64 Length { get => throw null; }
                System.Threading.Tasks.ValueTask<System.IO.Stream> Microsoft.JSInterop.IJSStreamReference.OpenReadStreamAsync(System.Int64 maxAllowedSize, System.Threading.CancellationToken cancellationToken) => throw null;
            }

        }
        namespace Infrastructure
        {
            public static class DotNetDispatcher
            {
                public static void BeginInvokeDotNet(Microsoft.JSInterop.JSRuntime jsRuntime, Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo invocationInfo, string argsJson) => throw null;
                public static void EndInvokeJS(Microsoft.JSInterop.JSRuntime jsRuntime, string arguments) => throw null;
                public static string Invoke(Microsoft.JSInterop.JSRuntime jsRuntime, Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo invocationInfo, string argsJson) => throw null;
                public static void ReceiveByteArray(Microsoft.JSInterop.JSRuntime jsRuntime, int id, System.Byte[] data) => throw null;
            }

            public struct DotNetInvocationInfo
            {
                public string AssemblyName { get => throw null; }
                public string CallId { get => throw null; }
                // Stub generator skipped constructor 
                public DotNetInvocationInfo(string assemblyName, string methodIdentifier, System.Int64 dotNetObjectId, string callId) => throw null;
                public System.Int64 DotNetObjectId { get => throw null; }
                public string MethodIdentifier { get => throw null; }
            }

            public struct DotNetInvocationResult
            {
                // Stub generator skipped constructor 
                public string ErrorKind { get => throw null; }
                public System.Exception Exception { get => throw null; }
                public string ResultJson { get => throw null; }
                public bool Success { get => throw null; }
            }

            internal interface IDotNetObjectReference : System.IDisposable
            {
            }

            public interface IJSVoidResult
            {
            }

        }
    }
}
