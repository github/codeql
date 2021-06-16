// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.HubEndpointConventionBuilder` in `Microsoft.AspNetCore.SignalR, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HubEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IHubEndpointConventionBuilder, Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.HubEndpointRouteBuilderExtensions` in `Microsoft.AspNetCore.SignalR, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HubEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.HubEndpointConventionBuilder MapHub<THub>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Action<Microsoft.AspNetCore.Http.Connections.HttpConnectionDispatcherOptions> configureOptions) where THub : Microsoft.AspNetCore.SignalR.Hub => throw null;
                public static Microsoft.AspNetCore.Builder.HubEndpointConventionBuilder MapHub<THub>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) where THub : Microsoft.AspNetCore.SignalR.Hub => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.IHubEndpointConventionBuilder` in `Microsoft.AspNetCore.SignalR, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IHubEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
            }

        }
        namespace SignalR
        {
            // Generated from `Microsoft.AspNetCore.SignalR.GetHttpContextExtensions` in `Microsoft.AspNetCore.SignalR, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class GetHttpContextExtensions
            {
                public static Microsoft.AspNetCore.Http.HttpContext GetHttpContext(this Microsoft.AspNetCore.SignalR.HubConnectionContext connection) => throw null;
                public static Microsoft.AspNetCore.Http.HttpContext GetHttpContext(this Microsoft.AspNetCore.SignalR.HubCallerContext connection) => throw null;
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.SignalRDependencyInjectionExtensions` in `Microsoft.AspNetCore.SignalR, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60; Microsoft.AspNetCore.SignalR.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static partial class SignalRDependencyInjectionExtensions
            {
                public static Microsoft.AspNetCore.SignalR.ISignalRServerBuilder AddHubOptions<THub>(this Microsoft.AspNetCore.SignalR.ISignalRServerBuilder signalrBuilder, System.Action<Microsoft.AspNetCore.SignalR.HubOptions<THub>> configure) where THub : Microsoft.AspNetCore.SignalR.Hub => throw null;
                public static Microsoft.AspNetCore.SignalR.ISignalRServerBuilder AddSignalR(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.SignalR.HubOptions> configure) => throw null;
                public static Microsoft.AspNetCore.SignalR.ISignalRServerBuilder AddSignalR(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
