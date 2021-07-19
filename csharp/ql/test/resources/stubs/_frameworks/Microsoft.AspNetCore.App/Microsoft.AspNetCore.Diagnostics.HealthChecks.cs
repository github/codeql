// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.HealthCheckApplicationBuilderExtensions` in `Microsoft.AspNetCore.Diagnostics.HealthChecks, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HealthCheckApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, string port, Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, string port) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, int port, Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, int port) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.HealthCheckEndpointRouteBuilderExtensions` in `Microsoft.AspNetCore.Diagnostics.HealthChecks, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HealthCheckEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapHealthChecks(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapHealthChecks(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) => throw null;
            }

        }
        namespace Diagnostics
        {
            namespace HealthChecks
            {
                // Generated from `Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckMiddleware` in `Microsoft.AspNetCore.Diagnostics.HealthChecks, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HealthCheckMiddleware
                {
                    public HealthCheckMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions> healthCheckOptions, Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckService healthCheckService) => throw null;
                    public System.Threading.Tasks.Task InvokeAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions` in `Microsoft.AspNetCore.Diagnostics.HealthChecks, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HealthCheckOptions
                {
                    public bool AllowCachingResponses { get => throw null; set => throw null; }
                    public HealthCheckOptions() => throw null;
                    public System.Func<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckRegistration, bool> Predicate { get => throw null; set => throw null; }
                    public System.Func<Microsoft.AspNetCore.Http.HttpContext, Microsoft.Extensions.Diagnostics.HealthChecks.HealthReport, System.Threading.Tasks.Task> ResponseWriter { get => throw null; set => throw null; }
                    public System.Collections.Generic.IDictionary<Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus, int> ResultStatusCodes { get => throw null; set => throw null; }
                }

            }
        }
    }
}
