// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilder` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConnectionEndpointRouteBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilderExtensions` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ConnectionEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilder MapConnectionHandler<TConnectionHandler>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Action<Microsoft.AspNetCore.Http.Connections.HttpConnectionDispatcherOptions> configureOptions) where TConnectionHandler : Microsoft.AspNetCore.Connections.ConnectionHandler => throw null;
                public static Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilder MapConnectionHandler<TConnectionHandler>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) where TConnectionHandler : Microsoft.AspNetCore.Connections.ConnectionHandler => throw null;
                public static Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilder MapConnections(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Action<Microsoft.AspNetCore.Connections.IConnectionBuilder> configure) => throw null;
                public static Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilder MapConnections(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.Connections.HttpConnectionDispatcherOptions options, System.Action<Microsoft.AspNetCore.Connections.IConnectionBuilder> configure) => throw null;
            }

        }
        namespace Http
        {
            namespace Connections
            {
                // Generated from `Microsoft.AspNetCore.Http.Connections.ConnectionOptions` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ConnectionOptions
                {
                    public ConnectionOptions() => throw null;
                    public System.TimeSpan? DisconnectTimeout { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.ConnectionOptionsSetup` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ConnectionOptionsSetup : Microsoft.Extensions.Options.IConfigureOptions<Microsoft.AspNetCore.Http.Connections.ConnectionOptions>
                {
                    public void Configure(Microsoft.AspNetCore.Http.Connections.ConnectionOptions options) => throw null;
                    public ConnectionOptionsSetup() => throw null;
                    public static System.TimeSpan DefaultDisconectTimeout;
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.HttpConnectionContextExtensions` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class HttpConnectionContextExtensions
                {
                    public static Microsoft.AspNetCore.Http.HttpContext GetHttpContext(this Microsoft.AspNetCore.Connections.ConnectionContext connection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.HttpConnectionDispatcherOptions` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpConnectionDispatcherOptions
                {
                    public System.Int64 ApplicationMaxBufferSize { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Authorization.IAuthorizeData> AuthorizationData { get => throw null; }
                    public HttpConnectionDispatcherOptions() => throw null;
                    public Microsoft.AspNetCore.Http.Connections.LongPollingOptions LongPolling { get => throw null; }
                    public int MinimumProtocolVersion { get => throw null; set => throw null; }
                    public System.Int64 TransportMaxBufferSize { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.Connections.HttpTransportType Transports { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.Connections.WebSocketOptions WebSockets { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.LongPollingOptions` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class LongPollingOptions
                {
                    public LongPollingOptions() => throw null;
                    public System.TimeSpan PollTimeout { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.NegotiateMetadata` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NegotiateMetadata
                {
                    public NegotiateMetadata() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Http.Connections.WebSocketOptions` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class WebSocketOptions
                {
                    public System.TimeSpan CloseTimeout { get => throw null; set => throw null; }
                    public System.Func<System.Collections.Generic.IList<string>, string> SubProtocolSelector { get => throw null; set => throw null; }
                    public WebSocketOptions() => throw null;
                }

                namespace Features
                {
                    // Generated from `Microsoft.AspNetCore.Http.Connections.Features.IHttpContextFeature` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IHttpContextFeature
                    {
                        Microsoft.AspNetCore.Http.HttpContext HttpContext { get; set; }
                    }

                    // Generated from `Microsoft.AspNetCore.Http.Connections.Features.IHttpTransportFeature` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IHttpTransportFeature
                    {
                        Microsoft.AspNetCore.Http.Connections.HttpTransportType TransportType { get; }
                    }

                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.ConnectionsDependencyInjectionExtensions` in `Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ConnectionsDependencyInjectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddConnections(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Http.Connections.ConnectionOptions> options) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddConnections(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
namespace System
{
    namespace Threading
    {
        namespace Tasks
        {
            /* Duplicate type 'TaskExtensions' is not stubbed in this assembly 'Microsoft.AspNetCore.Http.Connections, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'. */

        }
    }
}
