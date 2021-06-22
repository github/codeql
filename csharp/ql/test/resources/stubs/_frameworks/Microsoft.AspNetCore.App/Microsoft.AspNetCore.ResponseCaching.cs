// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.ResponseCachingExtensions` in `Microsoft.AspNetCore.ResponseCaching, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ResponseCachingExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseResponseCaching(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

        }
        namespace ResponseCaching
        {
            // Generated from `Microsoft.AspNetCore.ResponseCaching.ResponseCachingFeature` in `Microsoft.AspNetCore.ResponseCaching, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResponseCachingFeature : Microsoft.AspNetCore.ResponseCaching.IResponseCachingFeature
            {
                public ResponseCachingFeature() => throw null;
                public string[] VaryByQueryKeys { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.ResponseCaching.ResponseCachingMiddleware` in `Microsoft.AspNetCore.ResponseCaching, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResponseCachingMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public ResponseCachingMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCaching.ResponseCachingOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.ObjectPool.ObjectPoolProvider poolProvider) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.ResponseCaching.ResponseCachingOptions` in `Microsoft.AspNetCore.ResponseCaching, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResponseCachingOptions
            {
                public System.Int64 MaximumBodySize { get => throw null; set => throw null; }
                public ResponseCachingOptions() => throw null;
                public System.Int64 SizeLimit { get => throw null; set => throw null; }
                public bool UseCaseSensitivePaths { get => throw null; set => throw null; }
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.ResponseCachingServicesExtensions` in `Microsoft.AspNetCore.ResponseCaching, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ResponseCachingServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddResponseCaching(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.ResponseCaching.ResponseCachingOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddResponseCaching(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
