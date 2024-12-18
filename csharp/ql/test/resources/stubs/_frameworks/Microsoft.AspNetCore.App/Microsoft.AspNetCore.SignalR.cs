// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.SignalR, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public sealed class HubEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder, Microsoft.AspNetCore.Builder.IHubEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                public void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finalConvention) => throw null;
            }
            public static partial class HubEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.HubEndpointConventionBuilder MapHub<THub>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) where THub : Microsoft.AspNetCore.SignalR.Hub => throw null;
                public static Microsoft.AspNetCore.Builder.HubEndpointConventionBuilder MapHub<THub>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Action<Microsoft.AspNetCore.Http.Connections.HttpConnectionDispatcherOptions> configureOptions) where THub : Microsoft.AspNetCore.SignalR.Hub => throw null;
            }
            public interface IHubEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
            }
        }
        namespace SignalR
        {
            public static partial class GetHttpContextExtensions
            {
                public static Microsoft.AspNetCore.Http.HttpContext GetHttpContext(this Microsoft.AspNetCore.SignalR.HubCallerContext connection) => throw null;
                public static Microsoft.AspNetCore.Http.HttpContext GetHttpContext(this Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class SignalRDependencyInjectionExtensions
            {
                public static Microsoft.AspNetCore.SignalR.ISignalRServerBuilder AddHubOptions<THub>(this Microsoft.AspNetCore.SignalR.ISignalRServerBuilder signalrBuilder, System.Action<Microsoft.AspNetCore.SignalR.HubOptions<THub>> configure) where THub : Microsoft.AspNetCore.SignalR.Hub => throw null;
                public static Microsoft.AspNetCore.SignalR.ISignalRServerBuilder AddSignalR(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.AspNetCore.SignalR.ISignalRServerBuilder AddSignalR(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.SignalR.HubOptions> configure) => throw null;
            }
        }
    }
}
