// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace Cors
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Cors.CorsAuthorizationFilter` in `Microsoft.AspNetCore.Mvc.Cors, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CorsAuthorizationFilter : Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IAsyncAuthorizationFilter
                {
                    public CorsAuthorizationFilter(Microsoft.AspNetCore.Cors.Infrastructure.ICorsService corsService, Microsoft.AspNetCore.Cors.Infrastructure.ICorsPolicyProvider policyProvider, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public CorsAuthorizationFilter(Microsoft.AspNetCore.Cors.Infrastructure.ICorsService corsService, Microsoft.AspNetCore.Cors.Infrastructure.ICorsPolicyProvider policyProvider) => throw null;
                    public System.Threading.Tasks.Task OnAuthorizationAsync(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext context) => throw null;
                    public int Order { get => throw null; }
                    public string PolicyName { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Cors.ICorsAuthorizationFilter` in `Microsoft.AspNetCore.Mvc.Cors, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface ICorsAuthorizationFilter : Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IAsyncAuthorizationFilter
                {
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.MvcCorsMvcCoreBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Cors, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcCorsMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddCors(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddCors(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder ConfigureCors(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Cors.Infrastructure.CorsOptions> setupAction) => throw null;
            }

        }
    }
}
