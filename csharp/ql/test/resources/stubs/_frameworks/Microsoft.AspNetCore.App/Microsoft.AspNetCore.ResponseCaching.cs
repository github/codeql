// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.ResponseCaching, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class ResponseCachingExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseResponseCaching(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }
        }
        namespace ResponseCaching
        {
            public class ResponseCachingFeature : Microsoft.AspNetCore.ResponseCaching.IResponseCachingFeature
            {
                public ResponseCachingFeature() => throw null;
                public string[] VaryByQueryKeys { get => throw null; set { } }
            }
            public class ResponseCachingMiddleware
            {
                public ResponseCachingMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCaching.ResponseCachingOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.ObjectPool.ObjectPoolProvider poolProvider) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
            }
            public class ResponseCachingOptions
            {
                public ResponseCachingOptions() => throw null;
                public long MaximumBodySize { get => throw null; set { } }
                public long SizeLimit { get => throw null; set { } }
                public bool UseCaseSensitivePaths { get => throw null; set { } }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class ResponseCachingServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddResponseCaching(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddResponseCaching(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.ResponseCaching.ResponseCachingOptions> configureOptions) => throw null;
            }
        }
    }
}
