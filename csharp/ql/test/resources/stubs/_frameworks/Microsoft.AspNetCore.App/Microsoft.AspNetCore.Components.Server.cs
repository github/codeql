// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Components.Server, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public sealed class ComponentEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder, Microsoft.AspNetCore.Builder.IHubEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                public void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finalConvention) => throw null;
            }
            public static partial class ComponentEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.ComponentEndpointConventionBuilder MapBlazorHub(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints) => throw null;
                public static Microsoft.AspNetCore.Builder.ComponentEndpointConventionBuilder MapBlazorHub(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string path) => throw null;
                public static Microsoft.AspNetCore.Builder.ComponentEndpointConventionBuilder MapBlazorHub(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, System.Action<Microsoft.AspNetCore.Http.Connections.HttpConnectionDispatcherOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Builder.ComponentEndpointConventionBuilder MapBlazorHub(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string path, System.Action<Microsoft.AspNetCore.Http.Connections.HttpConnectionDispatcherOptions> configureOptions) => throw null;
            }
            public static partial class ServerRazorComponentsEndpointConventionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.RazorComponentsEndpointConventionBuilder AddInteractiveServerRenderMode(this Microsoft.AspNetCore.Builder.RazorComponentsEndpointConventionBuilder builder) => throw null;
            }
        }
        namespace Components
        {
            namespace Server
            {
                public sealed class CircuitOptions
                {
                    public CircuitOptions() => throw null;
                    public bool DetailedErrors { get => throw null; set { } }
                    public int DisconnectedCircuitMaxRetained { get => throw null; set { } }
                    public System.TimeSpan DisconnectedCircuitRetentionPeriod { get => throw null; set { } }
                    public System.TimeSpan JSInteropDefaultCallTimeout { get => throw null; set { } }
                    public int MaxBufferedUnacknowledgedRenderBatches { get => throw null; set { } }
                    public Microsoft.AspNetCore.Components.Server.CircuitRootComponentOptions RootComponents { get => throw null; }
                }
                public class CircuitRootComponentOptions : Microsoft.AspNetCore.Components.Web.IJSComponentConfiguration
                {
                    public CircuitRootComponentOptions() => throw null;
                    public Microsoft.AspNetCore.Components.Web.JSComponentConfigurationStore JSComponents { get => throw null; }
                    public int MaxJSRootComponents { get => throw null; set { } }
                }
                namespace Circuits
                {
                    public sealed class Circuit
                    {
                        public string Id { get => throw null; }
                    }
                    public abstract class CircuitHandler
                    {
                        public virtual System.Func<Microsoft.AspNetCore.Components.Server.Circuits.CircuitInboundActivityContext, System.Threading.Tasks.Task> CreateInboundActivityHandler(System.Func<Microsoft.AspNetCore.Components.Server.Circuits.CircuitInboundActivityContext, System.Threading.Tasks.Task> next) => throw null;
                        protected CircuitHandler() => throw null;
                        public virtual System.Threading.Tasks.Task OnCircuitClosedAsync(Microsoft.AspNetCore.Components.Server.Circuits.Circuit circuit, System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual System.Threading.Tasks.Task OnCircuitOpenedAsync(Microsoft.AspNetCore.Components.Server.Circuits.Circuit circuit, System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual System.Threading.Tasks.Task OnConnectionDownAsync(Microsoft.AspNetCore.Components.Server.Circuits.Circuit circuit, System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual System.Threading.Tasks.Task OnConnectionUpAsync(Microsoft.AspNetCore.Components.Server.Circuits.Circuit circuit, System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual int Order { get => throw null; }
                    }
                    public sealed class CircuitInboundActivityContext
                    {
                        public Microsoft.AspNetCore.Components.Server.Circuits.Circuit Circuit { get => throw null; }
                    }
                }
                namespace ProtectedBrowserStorage
                {
                    public abstract class ProtectedBrowserStorage
                    {
                        public System.Threading.Tasks.ValueTask DeleteAsync(string key) => throw null;
                        public System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage.ProtectedBrowserStorageResult<TValue>> GetAsync<TValue>(string key) => throw null;
                        public System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage.ProtectedBrowserStorageResult<TValue>> GetAsync<TValue>(string purpose, string key) => throw null;
                        public System.Threading.Tasks.ValueTask SetAsync(string key, object value) => throw null;
                        public System.Threading.Tasks.ValueTask SetAsync(string purpose, string key, object value) => throw null;
                    }
                    public struct ProtectedBrowserStorageResult<TValue>
                    {
                        public bool Success { get => throw null; }
                        public TValue Value { get => throw null; }
                    }
                    public sealed class ProtectedLocalStorage : Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage.ProtectedBrowserStorage
                    {
                        public ProtectedLocalStorage(Microsoft.JSInterop.IJSRuntime jsRuntime, Microsoft.AspNetCore.DataProtection.IDataProtectionProvider dataProtectionProvider) => throw null;
                    }
                    public sealed class ProtectedSessionStorage : Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage.ProtectedBrowserStorage
                    {
                        public ProtectedSessionStorage(Microsoft.JSInterop.IJSRuntime jsRuntime, Microsoft.AspNetCore.DataProtection.IDataProtectionProvider dataProtectionProvider) => throw null;
                    }
                }
                public abstract class RevalidatingServerAuthenticationStateProvider : Microsoft.AspNetCore.Components.Server.ServerAuthenticationStateProvider, System.IDisposable
                {
                    public RevalidatingServerAuthenticationStateProvider(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    void System.IDisposable.Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    protected abstract System.TimeSpan RevalidationInterval { get; }
                    protected abstract System.Threading.Tasks.Task<bool> ValidateAuthenticationStateAsync(Microsoft.AspNetCore.Components.Authorization.AuthenticationState authenticationState, System.Threading.CancellationToken cancellationToken);
                }
                public class ServerAuthenticationStateProvider : Microsoft.AspNetCore.Components.Authorization.AuthenticationStateProvider, Microsoft.AspNetCore.Components.Authorization.IHostEnvironmentAuthenticationStateProvider
                {
                    public ServerAuthenticationStateProvider() => throw null;
                    public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> GetAuthenticationStateAsync() => throw null;
                    public void SetAuthenticationState(System.Threading.Tasks.Task<Microsoft.AspNetCore.Components.Authorization.AuthenticationState> authenticationStateTask) => throw null;
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class ComponentServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServerSideBlazorBuilder AddServerSideBlazor(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Components.Server.CircuitOptions> configure = default(System.Action<Microsoft.AspNetCore.Components.Server.CircuitOptions>)) => throw null;
            }
            public interface IServerSideBlazorBuilder : Microsoft.Extensions.DependencyInjection.IRazorComponentsBuilder
            {
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
                Microsoft.Extensions.DependencyInjection.IServiceCollection Microsoft.Extensions.DependencyInjection.IRazorComponentsBuilder.Services { get => throw null; }
            }
            public static partial class ServerRazorComponentsBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServerSideBlazorBuilder AddInteractiveServerComponents(this Microsoft.Extensions.DependencyInjection.IRazorComponentsBuilder builder, System.Action<Microsoft.AspNetCore.Components.Server.CircuitOptions> configure = default(System.Action<Microsoft.AspNetCore.Components.Server.CircuitOptions>)) => throw null;
            }
            public static partial class ServerSideBlazorBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServerSideBlazorBuilder AddCircuitOptions(this Microsoft.Extensions.DependencyInjection.IServerSideBlazorBuilder builder, System.Action<Microsoft.AspNetCore.Components.Server.CircuitOptions> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServerSideBlazorBuilder AddHubOptions(this Microsoft.Extensions.DependencyInjection.IServerSideBlazorBuilder builder, System.Action<Microsoft.AspNetCore.SignalR.HubOptions> configure) => throw null;
            }
        }
    }
}
