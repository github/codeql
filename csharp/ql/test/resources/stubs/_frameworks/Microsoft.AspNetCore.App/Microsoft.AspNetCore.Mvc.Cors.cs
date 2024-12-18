// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Mvc.Cors, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace Cors
            {
                public class CorsAuthorizationFilter : Microsoft.AspNetCore.Mvc.Filters.IAsyncAuthorizationFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
                {
                    public CorsAuthorizationFilter(Microsoft.AspNetCore.Cors.Infrastructure.ICorsService corsService, Microsoft.AspNetCore.Cors.Infrastructure.ICorsPolicyProvider policyProvider) => throw null;
                    public CorsAuthorizationFilter(Microsoft.AspNetCore.Cors.Infrastructure.ICorsService corsService, Microsoft.AspNetCore.Cors.Infrastructure.ICorsPolicyProvider policyProvider, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public System.Threading.Tasks.Task OnAuthorizationAsync(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext context) => throw null;
                    public int Order { get => throw null; }
                    public string PolicyName { get => throw null; set { } }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class MvcCorsMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddCors(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddCors(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder ConfigureCors(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions> setupAction) => throw null;
            }
        }
    }
}
