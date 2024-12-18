// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Diagnostics.HealthChecks, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class HealthCheckApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, int port) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, string port) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, int port, Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHealthChecks(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path, string port, Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions options) => throw null;
            }
            public static partial class HealthCheckEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapHealthChecks(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapHealthChecks(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions options) => throw null;
            }
        }
        namespace Diagnostics
        {
            namespace HealthChecks
            {
                public class HealthCheckMiddleware
                {
                    public HealthCheckMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions> healthCheckOptions, Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckService healthCheckService) => throw null;
                    public System.Threading.Tasks.Task InvokeAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                }
                public class HealthCheckOptions
                {
                    public bool AllowCachingResponses { get => throw null; set { } }
                    public HealthCheckOptions() => throw null;
                    public System.Func<Microsoft.Extensions.Diagnostics.HealthChecks.HealthCheckRegistration, bool> Predicate { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Http.HttpContext, Microsoft.Extensions.Diagnostics.HealthChecks.HealthReport, System.Threading.Tasks.Task> ResponseWriter { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus, int> ResultStatusCodes { get => throw null; set { } }
                }
            }
        }
    }
}
