// This file contains auto-generated code.

namespace Microsoft
{
    namespace JSInterop
    {
        // Generated from `Microsoft.JSInterop.DotNetObjectReference` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public static class DotNetObjectReference
        {
            public static Microsoft.JSInterop.DotNetObjectReference<TValue> Create<TValue>(TValue value) where TValue : class => throw null;
        }

        // Generated from `Microsoft.JSInterop.DotNetObjectReference<>` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public class DotNetObjectReference<TValue> : System.IDisposable where TValue : class
        {
            public void Dispose() => throw null;
            public TValue Value { get => throw null; }
        }

        // Generated from `Microsoft.JSInterop.IJSInProcessObjectReference` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public interface IJSInProcessObjectReference : System.IDisposable, System.IAsyncDisposable, Microsoft.JSInterop.IJSObjectReference
        {
            TValue Invoke<TValue>(string identifier, params object[] args);
        }

        // Generated from `Microsoft.JSInterop.IJSInProcessRuntime` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public interface IJSInProcessRuntime : Microsoft.JSInterop.IJSRuntime
        {
            TResult Invoke<TResult>(string identifier, params object[] args);
        }

        // Generated from `Microsoft.JSInterop.IJSObjectReference` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public interface IJSObjectReference : System.IAsyncDisposable
        {
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args);
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args);
        }

        // Generated from `Microsoft.JSInterop.IJSRuntime` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public interface IJSRuntime
        {
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args);
            System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args);
        }

        // Generated from `Microsoft.JSInterop.IJSUnmarshalledObjectReference` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public interface IJSUnmarshalledObjectReference : System.IDisposable, System.IAsyncDisposable, Microsoft.JSInterop.IJSObjectReference, Microsoft.JSInterop.IJSInProcessObjectReference
        {
            TResult InvokeUnmarshalled<TResult>(string identifier);
            TResult InvokeUnmarshalled<T0, TResult>(string identifier, T0 arg0);
            TResult InvokeUnmarshalled<T0, T1, TResult>(string identifier, T0 arg0, T1 arg1);
            TResult InvokeUnmarshalled<T0, T1, T2, TResult>(string identifier, T0 arg0, T1 arg1, T2 arg2);
        }

        // Generated from `Microsoft.JSInterop.IJSUnmarshalledRuntime` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public interface IJSUnmarshalledRuntime
        {
            TResult InvokeUnmarshalled<TResult>(string identifier);
            TResult InvokeUnmarshalled<T0, TResult>(string identifier, T0 arg0);
            TResult InvokeUnmarshalled<T0, T1, TResult>(string identifier, T0 arg0, T1 arg1);
            TResult InvokeUnmarshalled<T0, T1, T2, TResult>(string identifier, T0 arg0, T1 arg1, T2 arg2);
        }

        // Generated from `Microsoft.JSInterop.JSCallResultType` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public enum JSCallResultType
        {
            Default,
            JSObjectReference,
        }

        // Generated from `Microsoft.JSInterop.JSException` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public class JSException : System.Exception
        {
            public JSException(string message, System.Exception innerException) => throw null;
            public JSException(string message) => throw null;
        }

        // Generated from `Microsoft.JSInterop.JSInProcessObjectReferenceExtensions` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public static class JSInProcessObjectReferenceExtensions
        {
            public static void InvokeVoid(this Microsoft.JSInterop.IJSInProcessObjectReference jsObjectReference, string identifier, params object[] args) => throw null;
        }

        // Generated from `Microsoft.JSInterop.JSInProcessRuntime` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public abstract class JSInProcessRuntime : Microsoft.JSInterop.JSRuntime, Microsoft.JSInterop.IJSRuntime, Microsoft.JSInterop.IJSInProcessRuntime
        {
            public TValue Invoke<TValue>(string identifier, params object[] args) => throw null;
            protected virtual string InvokeJS(string identifier, string argsJson) => throw null;
            protected abstract string InvokeJS(string identifier, string argsJson, Microsoft.JSInterop.JSCallResultType resultType, System.Int64 targetInstanceId);
            protected JSInProcessRuntime() => throw null;
        }

        // Generated from `Microsoft.JSInterop.JSInProcessRuntimeExtensions` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public static class JSInProcessRuntimeExtensions
        {
            public static void InvokeVoid(this Microsoft.JSInterop.IJSInProcessRuntime jsRuntime, string identifier, params object[] args) => throw null;
        }

        // Generated from `Microsoft.JSInterop.JSInvokableAttribute` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public class JSInvokableAttribute : System.Attribute
        {
            public string Identifier { get => throw null; }
            public JSInvokableAttribute(string identifier) => throw null;
            public JSInvokableAttribute() => throw null;
        }

        // Generated from `Microsoft.JSInterop.JSObjectReferenceExtensions` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public static class JSObjectReferenceExtensions
        {
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSObjectReference jsObjectReference, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
        }

        // Generated from `Microsoft.JSInterop.JSRuntime` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public abstract class JSRuntime : Microsoft.JSInterop.IJSRuntime
        {
            protected virtual void BeginInvokeJS(System.Int64 taskId, string identifier, string argsJson) => throw null;
            protected abstract void BeginInvokeJS(System.Int64 taskId, string identifier, string argsJson, Microsoft.JSInterop.JSCallResultType resultType, System.Int64 targetInstanceId);
            protected System.TimeSpan? DefaultAsyncTimeout { get => throw null; set => throw null; }
            protected internal abstract void EndInvokeDotNet(Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo invocationInfo, Microsoft.JSInterop.Infrastructure.DotNetInvocationResult invocationResult);
            public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args) => throw null;
            public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args) => throw null;
            protected JSRuntime() => throw null;
            protected internal System.Text.Json.JsonSerializerOptions JsonSerializerOptions { get => throw null; }
        }

        // Generated from `Microsoft.JSInterop.JSRuntimeExtensions` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public static class JSRuntimeExtensions
        {
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.TimeSpan timeout, params object[] args) => throw null;
            public static System.Threading.Tasks.ValueTask InvokeVoidAsync(this Microsoft.JSInterop.IJSRuntime jsRuntime, string identifier, System.Threading.CancellationToken cancellationToken, params object[] args) => throw null;
        }

        namespace Implementation
        {
            // Generated from `Microsoft.JSInterop.Implementation.JSInProcessObjectReference` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class JSInProcessObjectReference : Microsoft.JSInterop.Implementation.JSObjectReference, System.IDisposable, System.IAsyncDisposable, Microsoft.JSInterop.IJSObjectReference, Microsoft.JSInterop.IJSInProcessObjectReference
            {
                public void Dispose() => throw null;
                public TValue Invoke<TValue>(string identifier, params object[] args) => throw null;
                protected internal JSInProcessObjectReference(Microsoft.JSInterop.JSInProcessRuntime jsRuntime, System.Int64 id) : base(default(Microsoft.JSInterop.JSRuntime), default(System.Int64)) => throw null;
            }

            // Generated from `Microsoft.JSInterop.Implementation.JSObjectReference` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class JSObjectReference : System.IAsyncDisposable, Microsoft.JSInterop.IJSObjectReference
            {
                public System.Threading.Tasks.ValueTask DisposeAsync() => throw null;
                protected internal System.Int64 Id { get => throw null; }
                public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, object[] args) => throw null;
                public System.Threading.Tasks.ValueTask<TValue> InvokeAsync<TValue>(string identifier, System.Threading.CancellationToken cancellationToken, object[] args) => throw null;
                protected internal JSObjectReference(Microsoft.JSInterop.JSRuntime jsRuntime, System.Int64 id) => throw null;
                protected void ThrowIfDisposed() => throw null;
            }

        }
        namespace Infrastructure
        {
            // Generated from `Microsoft.JSInterop.Infrastructure.DotNetDispatcher` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DotNetDispatcher
            {
                public static void BeginInvokeDotNet(Microsoft.JSInterop.JSRuntime jsRuntime, Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo invocationInfo, string argsJson) => throw null;
                public static void EndInvokeJS(Microsoft.JSInterop.JSRuntime jsRuntime, string arguments) => throw null;
                public static string Invoke(Microsoft.JSInterop.JSRuntime jsRuntime, Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo invocationInfo, string argsJson) => throw null;
            }

            // Generated from `Microsoft.JSInterop.Infrastructure.DotNetInvocationInfo` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct DotNetInvocationInfo
            {
                public string AssemblyName { get => throw null; }
                public string CallId { get => throw null; }
                public DotNetInvocationInfo(string assemblyName, string methodIdentifier, System.Int64 dotNetObjectId, string callId) => throw null;
                // Stub generator skipped constructor 
                public System.Int64 DotNetObjectId { get => throw null; }
                public string MethodIdentifier { get => throw null; }
            }

            // Generated from `Microsoft.JSInterop.Infrastructure.DotNetInvocationResult` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public struct DotNetInvocationResult
            {
                public DotNetInvocationResult(object result) => throw null;
                public DotNetInvocationResult(System.Exception exception, string errorKind) => throw null;
                // Stub generator skipped constructor 
                public string ErrorKind { get => throw null; }
                public System.Exception Exception { get => throw null; }
                public object Result { get => throw null; }
                public bool Success { get => throw null; }
            }

            // Generated from `Microsoft.JSInterop.Infrastructure.IDotNetObjectReference` in `Microsoft.JSInterop, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            internal interface IDotNetObjectReference : System.IDisposable
            {
            }

        }
    }
}
