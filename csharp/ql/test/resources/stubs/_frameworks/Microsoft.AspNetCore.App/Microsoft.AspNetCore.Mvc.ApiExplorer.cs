// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace ApiExplorer
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionExtensions` in `Microsoft.AspNetCore.Mvc.ApiExplorer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class ApiDescriptionExtensions
                {
                    public static T GetProperty<T>(this Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription apiDescription) => throw null;
                    public static void SetProperty<T>(this Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription apiDescription, T value) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroup` in `Microsoft.AspNetCore.Mvc.ApiExplorer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiDescriptionGroup
                {
                    public ApiDescriptionGroup(string groupName, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription> items) => throw null;
                    public string GroupName { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription> Items { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroupCollection` in `Microsoft.AspNetCore.Mvc.ApiExplorer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiDescriptionGroupCollection
                {
                    public ApiDescriptionGroupCollection(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroup> items, int version) => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroup> Items { get => throw null; }
                    public int Version { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroupCollectionProvider` in `Microsoft.AspNetCore.Mvc.ApiExplorer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiDescriptionGroupCollectionProvider : Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionGroupCollectionProvider
                {
                    public ApiDescriptionGroupCollectionProvider(Microsoft.AspNetCore.Mvc.Infrastructure.IActionDescriptorCollectionProvider actionDescriptorCollectionProvider, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionProvider> apiDescriptionProviders) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionGroupCollection ApiDescriptionGroups { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.DefaultApiDescriptionProvider` in `Microsoft.AspNetCore.Mvc.ApiExplorer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DefaultApiDescriptionProvider : Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionProvider
                {
                    public DefaultApiDescriptionProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> optionsAccessor, Microsoft.AspNetCore.Routing.IInlineConstraintResolver constraintResolver, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultTypeMapper mapper, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Routing.RouteOptions> routeOptions) => throw null;
                    public void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionProviderContext context) => throw null;
                    public void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionProviderContext context) => throw null;
                    public int Order { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionGroupCollectionProvider` in `Microsoft.AspNetCore.Mvc.ApiExplorer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
            // Generated from `Microsoft.Extensions.DependencyInjection.MvcApiExplorerMvcCoreBuilderExtensions` in `Microsoft.AspNetCore.Mvc.ApiExplorer, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcApiExplorerMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddApiExplorer(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
            }

        }
    }
}
