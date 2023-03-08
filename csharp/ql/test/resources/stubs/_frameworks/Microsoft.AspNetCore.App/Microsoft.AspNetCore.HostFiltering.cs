// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.HostFiltering, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static class HostFilteringBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHostFiltering(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            public static class HostFilteringServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHostFiltering(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HostFiltering.HostFilteringOptions> configureOptions) => throw null;
            }

        }
        namespace HostFiltering
        {
            public class HostFilteringMiddleware
            {
                public HostFilteringMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.HostFiltering.HostFilteringMiddleware> logger, Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.HostFiltering.HostFilteringOptions> optionsMonitor) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            public class HostFilteringOptions
            {
                public bool AllowEmptyHosts { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<string> AllowedHosts { get => throw null; set => throw null; }
                public HostFilteringOptions() => throw null;
                public bool IncludeFailureMessage { get => throw null; set => throw null; }
            }

        }
    }
}
