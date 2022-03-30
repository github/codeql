// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.HostFilteringBuilderExtensions` in `Microsoft.AspNetCore.HostFiltering, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HostFilteringBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHostFiltering(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.HostFilteringServicesExtensions` in `Microsoft.AspNetCore.HostFiltering, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HostFilteringServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHostFiltering(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HostFiltering.HostFilteringOptions> configureOptions) => throw null;
            }

        }
        namespace HostFiltering
        {
            // Generated from `Microsoft.AspNetCore.HostFiltering.HostFilteringMiddleware` in `Microsoft.AspNetCore.HostFiltering, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HostFilteringMiddleware
            {
                public HostFilteringMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.HostFiltering.HostFilteringMiddleware> logger, Microsoft.Extensions.Options.IOptionsMonitor<Microsoft.AspNetCore.HostFiltering.HostFilteringOptions> optionsMonitor) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.HostFiltering.HostFilteringOptions` in `Microsoft.AspNetCore.HostFiltering, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
