// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Http.Connections, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public sealed class ConnectionEndpointRouteBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                public void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finalConvention) => throw null;
            }
            public static partial class ConnectionEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilder MapConnectionHandler<TConnectionHandler>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) where TConnectionHandler : Microsoft.AspNetCore.Connections.ConnectionHandler => throw null;
                public static Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilder MapConnectionHandler<TConnectionHandler>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Action<Microsoft.AspNetCore.Http.Connections.HttpConnectionDispatcherOptions> configureOptions) where TConnectionHandler : Microsoft.AspNetCore.Connections.ConnectionHandler => throw null;
                public static Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilder MapConnections(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, System.Action<Microsoft.AspNetCore.Connections.IConnectionBuilder> configure) => throw null;
                public static Microsoft.AspNetCore.Builder.ConnectionEndpointRouteBuilder MapConnections(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Http.Connections.HttpConnectionDispatcherOptions options, System.Action<Microsoft.AspNetCore.Connections.IConnectionBuilder> configure) => throw null;
            }
        }
        namespace Http
        {
            namespace Connections
            {
                public class ConnectionOptions
                {
                    public ConnectionOptions() => throw null;
                    public System.TimeSpan? DisconnectTimeout { get => throw null; set { } }
                }
                public class ConnectionOptionsSetup : Microsoft.Extensions.Options.IConfigureOptions<Microsoft.AspNetCore.Http.Connections.ConnectionOptions>
                {
                    public void Configure(Microsoft.AspNetCore.Http.Connections.ConnectionOptions options) => throw null;
                    public ConnectionOptionsSetup() => throw null;
                    public static System.TimeSpan DefaultDisconectTimeout;
                }
                namespace Features
                {
                    public interface IHttpContextFeature
                    {
                        Microsoft.AspNetCore.Http.HttpContext HttpContext { get; set; }
                    }
                    public interface IHttpTransportFeature
                    {
                        Microsoft.AspNetCore.Http.Connections.HttpTransportType TransportType { get; }
                    }
                }
                public static partial class HttpConnectionContextExtensions
                {
                    public static Microsoft.AspNetCore.Http.HttpContext GetHttpContext(this Microsoft.AspNetCore.Connections.ConnectionContext connection) => throw null;
                }
                public class HttpConnectionDispatcherOptions
                {
                    public bool AllowStatefulReconnects { get => throw null; set { } }
                    public long ApplicationMaxBufferSize { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Authorization.IAuthorizeData> AuthorizationData { get => throw null; }
                    public bool CloseOnAuthenticationExpiration { get => throw null; set { } }
                    public HttpConnectionDispatcherOptions() => throw null;
                    public Microsoft.AspNetCore.Http.Connections.LongPollingOptions LongPolling { get => throw null; }
                    public int MinimumProtocolVersion { get => throw null; set { } }
                    public long TransportMaxBufferSize { get => throw null; set { } }
                    public Microsoft.AspNetCore.Http.Connections.HttpTransportType Transports { get => throw null; set { } }
                    public System.TimeSpan TransportSendTimeout { get => throw null; set { } }
                    public Microsoft.AspNetCore.Http.Connections.WebSocketOptions WebSockets { get => throw null; }
                }
                public class LongPollingOptions
                {
                    public LongPollingOptions() => throw null;
                    public System.TimeSpan PollTimeout { get => throw null; set { } }
                }
                public class NegotiateMetadata
                {
                    public NegotiateMetadata() => throw null;
                }
                public class WebSocketOptions
                {
                    public System.TimeSpan CloseTimeout { get => throw null; set { } }
                    public WebSocketOptions() => throw null;
                    public System.Func<System.Collections.Generic.IList<string>, string> SubProtocolSelector { get => throw null; set { } }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class ConnectionsDependencyInjectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddConnections(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddConnections(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Http.Connections.ConnectionOptions> options) => throw null;
            }
        }
    }
}
