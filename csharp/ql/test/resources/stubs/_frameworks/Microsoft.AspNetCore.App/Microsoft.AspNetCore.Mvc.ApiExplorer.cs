// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace ApiExplorer
            {
                public static partial class ApiDescriptionExtensions
                {
                    public static T GetProperty<T>(this Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription apiDescription) => throw null;
                    public static void SetProperty<T>(this Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription apiDescription, T value) => throw null;
                }
                public class ApiDescriptionGroup
                {
                    public ApiDescriptionGroup(string groupName, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription> items) => throw null;
                    public string GroupName { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription> Items { get => throw null; }
                }
                public class ApiDescriptionGroupCollection
                {
                    public ApiDescriptionGroupCollection(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroup> items, int version) => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroup> Items { get => throw null; }
                    public int Version { get => throw null; }
                }
                public class ApiDescriptionGroupCollectionProvider : Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionGroupCollectionProvider
                {
                    public Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroupCollection ApiDescriptionGroups { get => throw null; }
                    public ApiDescriptionGroupCollectionProvider(Microsoft.AspNetCore.Mvc.Infrastructure.IActionDescriptorCollectionProvider actionDescriptorCollectionProvider, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionProvider> apiDescriptionProviders) => throw null;
                }
                public class DefaultApiDescriptionProvider : Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionProvider
                {
                    public DefaultApiDescriptionProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> optionsAccessor, Microsoft.AspNetCore.Routing.IInlineConstraintResolver constraintResolver, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultTypeMapper mapper, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Routing.RouteOptions> routeOptions) => throw null;
                    public void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionProviderContext context) => throw null;
                    public void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionProviderContext context) => throw null;
                    public int Order { get => throw null; }
                }
                public interface IApiDescriptionGroupCollectionProvider
                {
                    Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroupCollection ApiDescriptionGroups { get; }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class EndpointMetadataApiExplorerServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddEndpointsApiExplorer(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }
            public static partial class MvcApiExplorerMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddApiExplorer(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
            }
        }
    }
}
