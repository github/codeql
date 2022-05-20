// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.WebSocketMiddlewareExtensions` in `Microsoft.AspNetCore.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class WebSocketMiddlewareExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWebSockets(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.WebSocketOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWebSockets(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.WebSocketOptions` in `Microsoft.AspNetCore.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class WebSocketOptions
            {
                public System.Collections.Generic.IList<string> AllowedOrigins { get => throw null; }
                public System.TimeSpan KeepAliveInterval { get => throw null; set => throw null; }
                public int ReceiveBufferSize { get => throw null; set => throw null; }
                public WebSocketOptions() => throw null;
            }

        }
        namespace WebSockets
        {
            // Generated from `Microsoft.AspNetCore.WebSockets.ExtendedWebSocketAcceptContext` in `Microsoft.AspNetCore.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ExtendedWebSocketAcceptContext : Microsoft.AspNetCore.Http.WebSocketAcceptContext
            {
                public ExtendedWebSocketAcceptContext() => throw null;
                public System.TimeSpan? KeepAliveInterval { get => throw null; set => throw null; }
                public int? ReceiveBufferSize { get => throw null; set => throw null; }
                public override string SubProtocol { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.WebSockets.WebSocketMiddleware` in `Microsoft.AspNetCore.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class WebSocketMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public WebSocketMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.WebSocketOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.WebSockets.WebSocketsDependencyInjectionExtensions` in `Microsoft.AspNetCore.WebSockets, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class WebSocketsDependencyInjectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddWebSockets(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Builder.WebSocketOptions> configure) => throw null;
            }

        }
    }
}
