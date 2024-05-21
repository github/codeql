// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.WebSockets, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class WebSocketMiddlewareExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWebSockets(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWebSockets(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.WebSocketOptions options) => throw null;
            }
            public class WebSocketOptions
            {
                public System.Collections.Generic.IList<string> AllowedOrigins { get => throw null; }
                public WebSocketOptions() => throw null;
                public System.TimeSpan KeepAliveInterval { get => throw null; set { } }
                public int ReceiveBufferSize { get => throw null; set { } }
            }
        }
        namespace WebSockets
        {
            public class ExtendedWebSocketAcceptContext : Microsoft.AspNetCore.Http.WebSocketAcceptContext
            {
                public ExtendedWebSocketAcceptContext() => throw null;
                public System.TimeSpan? KeepAliveInterval { get => throw null; set { } }
                public int? ReceiveBufferSize { get => throw null; set { } }
                public override string SubProtocol { get => throw null; set { } }
            }
            public class WebSocketMiddleware
            {
                public WebSocketMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.WebSocketOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }
            public static partial class WebSocketsDependencyInjectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddWebSockets(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Builder.WebSocketOptions> configure) => throw null;
            }
        }
    }
}
