// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.PageActionEndpointConventionBuilder` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class PageActionEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.RazorPagesEndpointRouteBuilderExtensions` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RazorPagesEndpointRouteBuilderExtensions
            {
                public static void MapDynamicPageRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, object state, int order) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static void MapDynamicPageRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, object state) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static void MapDynamicPageRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToAreaPage(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string page, string area) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToAreaPage(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string page, string area) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToPage(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string page) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToPage(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string page) => throw null;
                public static Microsoft.AspNetCore.Builder.PageActionEndpointConventionBuilder MapRazorPages(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints) => throw null;
            }

        }
        namespace Mvc
        {
            namespace ApplicationModels
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelConvention` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageApplicationModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel model);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelPartsProvider` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageApplicationModelPartsProvider
                {
                    Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel CreateHandlerModel(System.Reflection.MethodInfo method);
                    Microsoft.AspNetCore.Mvc.ApplicationModels.PageParameterModel CreateParameterModel(System.Reflection.ParameterInfo parameter);
                    Microsoft.AspNetCore.Mvc.ApplicationModels.PagePropertyModel CreatePropertyModel(System.Reflection.PropertyInfo property);
                    bool IsHandler(System.Reflection.MethodInfo methodInfo);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelProvider` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageApplicationModelProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModelProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModelProviderContext context);
                    int Order { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageConvention
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IPageHandlerModelConvention` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageHandlerModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel model);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelConvention` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageRouteModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel model);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelProvider` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageRouteModelProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModelProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModelProviderContext context);
                    int Order { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageApplicationModel
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor ActionDescriptor { get => throw null; }
                    public string AreaName { get => throw null; }
                    public System.Reflection.TypeInfo DeclaredModelType { get => throw null; }
                    public System.Collections.Generic.IList<object> EndpointMetadata { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel> HandlerMethods { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PagePropertyModel> HandlerProperties { get => throw null; }
                    public System.Reflection.TypeInfo HandlerType { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<object> HandlerTypeAttributes { get => throw null; }
                    public System.Reflection.TypeInfo ModelType { get => throw null; set => throw null; }
                    public PageApplicationModel(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor, System.Reflection.TypeInfo handlerType, System.Collections.Generic.IReadOnlyList<object> handlerAttributes) => throw null;
                    public PageApplicationModel(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor, System.Reflection.TypeInfo declaredModelType, System.Reflection.TypeInfo handlerType, System.Collections.Generic.IReadOnlyList<object> handlerAttributes) => throw null;
                    public PageApplicationModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel other) => throw null;
                    public System.Reflection.TypeInfo PageType { get => throw null; set => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public string RelativePath { get => throw null; }
                    public string RouteTemplate { get => throw null; }
                    public string ViewEnginePath { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModelProviderContext` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageApplicationModelProviderContext
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel PageApplicationModel { get => throw null; set => throw null; }
                    public PageApplicationModelProviderContext(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor descriptor, System.Reflection.TypeInfo pageTypeInfo) => throw null;
                    public System.Reflection.TypeInfo PageType { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageConventionCollection : System.Collections.ObjectModel.Collection<Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention>
                {
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelConvention AddAreaFolderApplicationModelConvention(string areaName, string folderPath, System.Action<Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel> action) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelConvention AddAreaFolderRouteModelConvention(string areaName, string folderPath, System.Action<Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel> action) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelConvention AddAreaPageApplicationModelConvention(string areaName, string pageName, System.Action<Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel> action) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelConvention AddAreaPageRouteModelConvention(string areaName, string pageName, System.Action<Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel> action) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelConvention AddFolderApplicationModelConvention(string folderPath, System.Action<Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel> action) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelConvention AddFolderRouteModelConvention(string folderPath, System.Action<Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel> action) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelConvention AddPageApplicationModelConvention(string pageName, System.Action<Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel> action) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelConvention AddPageRouteModelConvention(string pageName, System.Action<Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel> action) => throw null;
                    public PageConventionCollection(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention> conventions) => throw null;
                    public PageConventionCollection() => throw null;
                    public void RemoveType<TPageConvention>() where TPageConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention => throw null;
                    public void RemoveType(System.Type pageConventionType) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageHandlerModel : Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel
                {
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public string HandlerName { get => throw null; set => throw null; }
                    public string HttpMethod { get => throw null; set => throw null; }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public System.Reflection.MethodInfo MethodInfo { get => throw null; }
                    public string Name { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel Page { get => throw null; set => throw null; }
                    public PageHandlerModel(System.Reflection.MethodInfo handlerMethod, System.Collections.Generic.IReadOnlyList<object> attributes) => throw null;
                    public PageHandlerModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel other) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PageParameterModel> Parameters { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PageParameterModel` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageParameterModel : Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IBindingModel
                {
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel Handler { get => throw null; set => throw null; }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public PageParameterModel(System.Reflection.ParameterInfo parameterInfo, System.Collections.Generic.IReadOnlyList<object> attributes) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public PageParameterModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PageParameterModel other) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public System.Reflection.ParameterInfo ParameterInfo { get => throw null; }
                    public string ParameterName { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PagePropertyModel` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PagePropertyModel : Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel
                {
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel Page { get => throw null; set => throw null; }
                    public PagePropertyModel(System.Reflection.PropertyInfo propertyInfo, System.Collections.Generic.IReadOnlyList<object> attributes) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public PagePropertyModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PagePropertyModel other) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public System.Reflection.PropertyInfo PropertyInfo { get => throw null; }
                    public string PropertyName { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteMetadata` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageRouteMetadata
                {
                    public string PageRoute { get => throw null; }
                    public PageRouteMetadata(string pageRoute, string routeTemplate) => throw null;
                    public string RouteTemplate { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageRouteModel
                {
                    public string AreaName { get => throw null; }
                    public PageRouteModel(string relativePath, string viewEnginePath, string areaName) => throw null;
                    public PageRouteModel(string relativePath, string viewEnginePath) => throw null;
                    public PageRouteModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel other) => throw null;
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public string RelativePath { get => throw null; }
                    public Microsoft.AspNetCore.Routing.IOutboundParameterTransformer RouteParameterTransformer { get => throw null; set => throw null; }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.SelectorModel> Selectors { get => throw null; }
                    public string ViewEnginePath { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModelProviderContext` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageRouteModelProviderContext
                {
                    public PageRouteModelProviderContext() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel> RouteModels { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteTransformerConvention` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageRouteTransformerConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelConvention, Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel model) => throw null;
                    public PageRouteTransformerConvention(Microsoft.AspNetCore.Routing.IOutboundParameterTransformer parameterTransformer) => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel action) => throw null;
                }

            }
            namespace Diagnostics
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterHandlerMethodEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterHandlerMethodEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public AfterHandlerMethodEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IReadOnlyDictionary<string, object> arguments, Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor handlerMethodDescriptor, object instance, Microsoft.AspNetCore.Mvc.IActionResult result) => throw null;
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> Arguments { get => throw null; }
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethodDescriptor { get => throw null; }
                    public object Instance { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterPageFilterOnPageHandlerExecutedEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterPageFilterOnPageHandlerExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterPageFilterOnPageHandlerExecutedEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext handlerExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext HandlerExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterPageFilterOnPageHandlerExecutingEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterPageFilterOnPageHandlerExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterPageFilterOnPageHandlerExecutingEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext handlerExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext HandlerExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterPageFilterOnPageHandlerExecutionEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterPageFilterOnPageHandlerExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterPageFilterOnPageHandlerExecutionEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext handlerExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext HandlerExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterPageFilterOnPageHandlerSelectedEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterPageFilterOnPageHandlerSelectedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterPageFilterOnPageHandlerSelectedEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext handlerSelectedContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext HandlerSelectedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterPageFilterOnPageHandlerSelectionEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterPageFilterOnPageHandlerSelectionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterPageFilterOnPageHandlerSelectionEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext handlerSelectedContext, Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext HandlerSelectedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeHandlerMethodEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeHandlerMethodEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> Arguments { get => throw null; }
                    public BeforeHandlerMethodEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IReadOnlyDictionary<string, object> arguments, Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor handlerMethodDescriptor, object instance) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethodDescriptor { get => throw null; }
                    public object Instance { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforePageFilterOnPageHandlerExecutedEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforePageFilterOnPageHandlerExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforePageFilterOnPageHandlerExecutedEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext handlerExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext HandlerExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforePageFilterOnPageHandlerExecutingEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforePageFilterOnPageHandlerExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforePageFilterOnPageHandlerExecutingEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext handlerExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext HandlerExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforePageFilterOnPageHandlerExecutionEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforePageFilterOnPageHandlerExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforePageFilterOnPageHandlerExecutionEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext handlerExecutionContext, Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext HandlerExecutionContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforePageFilterOnPageHandlerSelectedEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforePageFilterOnPageHandlerSelectedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforePageFilterOnPageHandlerSelectedEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext handlerSelectedContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext HandlerSelectedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforePageFilterOnPageHandlerSelectionEventData` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforePageFilterOnPageHandlerSelectionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforePageFilterOnPageHandlerSelectionEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext handlerSelectedContext, Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext HandlerSelectedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

            }
            namespace Filters
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAsyncPageFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnPageHandlerExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutionDelegate next);
                    System.Threading.Tasks.Task OnPageHandlerSelectionAsync(Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IPageFilter` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnPageHandlerExecuted(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext context);
                    void OnPageHandlerExecuting(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext context);
                    void OnPageHandlerSelected(Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageHandlerExecutedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public virtual bool Canceled { get => throw null; set => throw null; }
                    public virtual System.Exception Exception { get => throw null; set => throw null; }
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set => throw null; }
                    public virtual bool ExceptionHandled { get => throw null; set => throw null; }
                    public virtual object HandlerInstance { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethod { get => throw null; }
                    public PageHandlerExecutedContext(Microsoft.AspNetCore.Mvc.RazorPages.PageContext pageContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor handlerMethod, object handlerInstance) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageHandlerExecutingContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public virtual System.Collections.Generic.IDictionary<string, object> HandlerArguments { get => throw null; }
                    public virtual object HandlerInstance { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethod { get => throw null; }
                    public PageHandlerExecutingContext(Microsoft.AspNetCore.Mvc.RazorPages.PageContext pageContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor handlerMethod, System.Collections.Generic.IDictionary<string, object> handlerArguments, object handlerInstance) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutionDelegate` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public delegate System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext> PageHandlerExecutionDelegate();

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageHandlerSelectedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public virtual object HandlerInstance { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethod { get => throw null; set => throw null; }
                    public PageHandlerSelectedContext(Microsoft.AspNetCore.Mvc.RazorPages.PageContext pageContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, object handlerInstance) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                }

            }
            namespace RazorPages
            {
                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CompiledPageActionDescriptor : Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor
                {
                    public CompiledPageActionDescriptor(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor) => throw null;
                    public CompiledPageActionDescriptor() => throw null;
                    public System.Reflection.TypeInfo DeclaredModelTypeInfo { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.Endpoint Endpoint { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor> HandlerMethods { get => throw null; set => throw null; }
                    public System.Reflection.TypeInfo HandlerTypeInfo { get => throw null; set => throw null; }
                    public System.Reflection.TypeInfo ModelTypeInfo { get => throw null; set => throw null; }
                    public System.Reflection.TypeInfo PageTypeInfo { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.IPageActivatorProvider` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageActivatorProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                    System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.IPageFactoryProvider` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageFactoryProvider
                {
                    System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object> CreatePageDisposer(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                    System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object> CreatePageFactory(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.IPageModelActivatorProvider` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageModelActivatorProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                    System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.IPageModelFactoryProvider` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPageModelFactoryProvider
                {
                    System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateModelDisposer(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                    System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateModelFactory(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.NonHandlerAttribute` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NonHandlerAttribute : System.Attribute
                {
                    public NonHandlerAttribute() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Page` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class Page : Microsoft.AspNetCore.Mvc.RazorPages.PageBase
                {
                    protected Page() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageActionDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor
                {
                    public string AreaName { get => throw null; set => throw null; }
                    public override string DisplayName { get => throw null; set => throw null; }
                    public PageActionDescriptor(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor other) => throw null;
                    public PageActionDescriptor() => throw null;
                    public string RelativePath { get => throw null; set => throw null; }
                    public string ViewEnginePath { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.PageBase` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class PageBase : Microsoft.AspNetCore.Mvc.Razor.RazorPageBase
                {
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestResult BadRequest() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(object error) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                    public override void BeginContext(int position, int length, bool isLiteral) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content) => throw null;
                    public override void EndContext() => throw null;
                    public override void EnsureRenderedBodyOrSections() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid() => throw null;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirect(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPermanent(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPermanentPreserveMethod(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPreserveMethod(string localUrl) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.NotFoundResult NotFound() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.NotFoundObjectResult NotFound(object value) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.PageResult Page() => throw null;
                    protected PageBase() => throw null;
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageContext PageContext { get => throw null; set => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.PartialViewResult Partial(string viewName, object model) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PartialViewResult Partial(string viewName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult Redirect(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanent(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanentPreserveMethod(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPreserveMethod(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanentPreserveMethod(string actionName = default(string), string controllerName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPreserveMethod(string actionName = default(string), string controllerName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanentPreserveMethod(string pageName = default(string), string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePreserveMethod(string pageName = default(string), string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanentPreserveMethod(string routeName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePreserveMethod(string routeName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public Microsoft.AspNetCore.Http.HttpRequest Request { get => throw null; }
                    public Microsoft.AspNetCore.Http.HttpResponse Response { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal, string authenticationScheme) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string authenticationScheme) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.StatusCodeResult StatusCode(int statusCode) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ObjectResult StatusCode(int statusCode, object value) => throw null;
                    public virtual System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider) where TModel : class => throw null;
                    public virtual System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix) where TModel : class => throw null;
                    public virtual System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model) where TModel : class => throw null;
                    public virtual System.Threading.Tasks.Task<bool> TryUpdateModelAsync(object model, System.Type modelType, string prefix) => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, params System.Linq.Expressions.Expression<System.Func<TModel, object>>[] includeExpressions) where TModel : class => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) where TModel : class => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, params System.Linq.Expressions.Expression<System.Func<TModel, object>>[] includeExpressions) where TModel : class => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) where TModel : class => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync(object model, System.Type modelType, string prefix, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) => throw null;
                    public virtual bool TryValidateModel(object model, string prefix) => throw null;
                    public virtual bool TryValidateModel(object model) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.UnauthorizedResult Unauthorized() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName, object arguments) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType, object arguments) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType) => throw null;
                    public override Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.PageContext` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageContext : Microsoft.AspNetCore.Mvc.ActionContext
                {
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; set => throw null; }
                    public PageContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext) => throw null;
                    public PageContext() => throw null;
                    public virtual System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> ValueProviderFactories { get => throw null; set => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set => throw null; }
                    public virtual System.Collections.Generic.IList<System.Func<Microsoft.AspNetCore.Mvc.Razor.IRazorPage>> ViewStartFactories { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.PageContextAttribute` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageContextAttribute : System.Attribute
                {
                    public PageContextAttribute() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.PageModel` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class PageModel : Microsoft.AspNetCore.Mvc.Filters.IPageFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter
                {
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestResult BadRequest() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(object error) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid() => throw null;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirect(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPermanent(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPermanentPreserveMethod(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPreserveMethod(string localUrl) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.NotFoundResult NotFound() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.NotFoundObjectResult NotFound(object value) => throw null;
                    public virtual void OnPageHandlerExecuted(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext context) => throw null;
                    public virtual void OnPageHandlerExecuting(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnPageHandlerExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutionDelegate next) => throw null;
                    public virtual void OnPageHandlerSelected(Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnPageHandlerSelectionAsync(Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext context) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.PageResult Page() => throw null;
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageContext PageContext { get => throw null; set => throw null; }
                    protected PageModel() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PartialViewResult Partial(string viewName, object model) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PartialViewResult Partial(string viewName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType) => throw null;
                    protected internal Microsoft.AspNetCore.Mvc.RedirectResult Redirect(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanent(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanentPreserveMethod(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPreserveMethod(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanentPreserveMethod(string actionName = default(string), string controllerName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPreserveMethod(string actionName = default(string), string controllerName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanentPreserveMethod(string pageName = default(string), string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePreserveMethod(string pageName = default(string), string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanentPreserveMethod(string routeName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePreserveMethod(string routeName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public Microsoft.AspNetCore.Http.HttpRequest Request { get => throw null; }
                    public Microsoft.AspNetCore.Http.HttpResponse Response { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal, string authenticationScheme) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string authenticationScheme) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.StatusCodeResult StatusCode(int statusCode) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ObjectResult StatusCode(int statusCode, object value) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; set => throw null; }
                    protected internal System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, params System.Linq.Expressions.Expression<System.Func<TModel, object>>[] includeExpressions) where TModel : class => throw null;
                    protected internal System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) where TModel : class => throw null;
                    protected internal System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, params System.Linq.Expressions.Expression<System.Func<TModel, object>>[] includeExpressions) where TModel : class => throw null;
                    protected internal System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) where TModel : class => throw null;
                    protected internal System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider) where TModel : class => throw null;
                    protected internal System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name) where TModel : class => throw null;
                    protected internal System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model) where TModel : class => throw null;
                    protected internal System.Threading.Tasks.Task<bool> TryUpdateModelAsync(object model, System.Type modelType, string name, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) => throw null;
                    protected internal System.Threading.Tasks.Task<bool> TryUpdateModelAsync(object model, System.Type modelType, string name) => throw null;
                    public virtual bool TryValidateModel(object model, string name) => throw null;
                    public virtual bool TryValidateModel(object model) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.UnauthorizedResult Unauthorized() => throw null;
                    public Microsoft.AspNetCore.Mvc.IUrlHelper Url { get => throw null; set => throw null; }
                    public System.Security.Claims.ClaimsPrincipal User { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName, object arguments) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType, object arguments) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.PageResult` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PageResult : Microsoft.AspNetCore.Mvc.ActionResult
                {
                    public string ContentType { get => throw null; set => throw null; }
                    public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                    public object Model { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageBase Page { get => throw null; set => throw null; }
                    public PageResult() => throw null;
                    public int? StatusCode { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.RazorPagesOptions` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorPagesOptions : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>
                {
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection Conventions { get => throw null; set => throw null; }
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                    public RazorPagesOptions() => throw null;
                    public string RootDirectory { get => throw null; set => throw null; }
                }

                namespace Infrastructure
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class HandlerMethodDescriptor
                    {
                        public HandlerMethodDescriptor() => throw null;
                        public string HttpMethod { get => throw null; set => throw null; }
                        public System.Reflection.MethodInfo MethodInfo { get => throw null; set => throw null; }
                        public string Name { get => throw null; set => throw null; }
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerParameterDescriptor> Parameters { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerParameterDescriptor` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class HandlerParameterDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor, Microsoft.AspNetCore.Mvc.Infrastructure.IParameterInfoParameterDescriptor
                    {
                        public HandlerParameterDescriptor() => throw null;
                        public System.Reflection.ParameterInfo ParameterInfo { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.IPageHandlerMethodSelector` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IPageHandlerMethodSelector
                    {
                        Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor Select(Microsoft.AspNetCore.Mvc.RazorPages.PageContext context);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.IPageLoader` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IPageLoader
                    {
                        Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor Load(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.PageActionDescriptorProvider` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class PageActionDescriptorProvider : Microsoft.AspNetCore.Mvc.Abstractions.IActionDescriptorProvider
                    {
                        protected System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel> BuildModel() => throw null;
                        public void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context) => throw null;
                        public void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context) => throw null;
                        public int Order { get => throw null; set => throw null; }
                        public PageActionDescriptorProvider(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelProvider> pageRouteModelProviders, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> mvcOptionsAccessor, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.RazorPages.RazorPagesOptions> pagesOptionsAccessor) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.PageBoundPropertyDescriptor` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class PageBoundPropertyDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor, Microsoft.AspNetCore.Mvc.Infrastructure.IPropertyInfoParameterDescriptor
                    {
                        public PageBoundPropertyDescriptor() => throw null;
                        public System.Reflection.PropertyInfo Property { get => throw null; set => throw null; }
                        System.Reflection.PropertyInfo Microsoft.AspNetCore.Mvc.Infrastructure.IPropertyInfoParameterDescriptor.PropertyInfo { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.PageLoader` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public abstract class PageLoader : Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.IPageLoader
                    {
                        Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.IPageLoader.Load(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor) => throw null;
                        public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor> LoadAsync(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor);
                        protected PageLoader() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.PageModelAttribute` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class PageModelAttribute : System.Attribute
                    {
                        public PageModelAttribute() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.PageResultExecutor` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class PageResultExecutor : Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor
                    {
                        public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.RazorPages.PageContext pageContext, Microsoft.AspNetCore.Mvc.RazorPages.PageResult result) => throw null;
                        public PageResultExecutor(Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory, Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine compositeViewEngine, Microsoft.AspNetCore.Mvc.Razor.IRazorViewEngine razorViewEngine, Microsoft.AspNetCore.Mvc.Razor.IRazorPageActivator razorPageActivator, System.Diagnostics.DiagnosticListener diagnosticListener, System.Text.Encodings.Web.HtmlEncoder htmlEncoder) : base(default(Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory), default(Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine), default(System.Diagnostics.DiagnosticListener)) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.PageViewLocationExpander` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class PageViewLocationExpander : Microsoft.AspNetCore.Mvc.Razor.IViewLocationExpander
                    {
                        public System.Collections.Generic.IEnumerable<string> ExpandViewLocations(Microsoft.AspNetCore.Mvc.Razor.ViewLocationExpanderContext context, System.Collections.Generic.IEnumerable<string> viewLocations) => throw null;
                        public PageViewLocationExpander() => throw null;
                        public void PopulateValues(Microsoft.AspNetCore.Mvc.Razor.ViewLocationExpanderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.RazorPageAdapter` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class RazorPageAdapter : Microsoft.AspNetCore.Mvc.Razor.IRazorPage
                    {
                        public Microsoft.AspNetCore.Html.IHtmlContent BodyContent { get => throw null; set => throw null; }
                        public void EnsureRenderedBodyOrSections() => throw null;
                        public System.Threading.Tasks.Task ExecuteAsync() => throw null;
                        public bool IsLayoutBeingRendered { get => throw null; set => throw null; }
                        public string Layout { get => throw null; set => throw null; }
                        public string Path { get => throw null; set => throw null; }
                        public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate> PreviousSectionWriters { get => throw null; set => throw null; }
                        public RazorPageAdapter(Microsoft.AspNetCore.Mvc.Razor.RazorPageBase page, System.Type modelType) => throw null;
                        public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate> SectionWriters { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.RazorPageAttribute` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class RazorPageAttribute : Microsoft.AspNetCore.Mvc.Razor.Compilation.RazorViewAttribute
                    {
                        public RazorPageAttribute(string path, System.Type viewType, string routeTemplate) : base(default(string), default(System.Type)) => throw null;
                        public string RouteTemplate { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.ServiceBasedPageModelActivatorProvider` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ServiceBasedPageModelActivatorProvider : Microsoft.AspNetCore.Mvc.RazorPages.IPageModelActivatorProvider
                    {
                        public System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor) => throw null;
                        public System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor) => throw null;
                        public ServiceBasedPageModelActivatorProvider() => throw null;
                    }

                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.MvcRazorPagesMvcBuilderExtensions` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcRazorPagesMvcBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddRazorPagesOptions(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.RazorPages.RazorPagesOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder WithRazorPagesAtContentRoot(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder WithRazorPagesRoot(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, string rootDirectory) => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.MvcRazorPagesMvcCoreBuilderExtensions` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcRazorPagesMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddRazorPages(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.RazorPages.RazorPagesOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddRazorPages(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder WithRazorPagesRoot(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, string rootDirectory) => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.PageConventionCollectionExtensions` in `Microsoft.AspNetCore.Mvc.RazorPages, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class PageConventionCollectionExtensions
            {
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection Add(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IParameterModelBaseConvention convention) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AddAreaPageRoute(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string pageName, string route) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AddPageRoute(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string pageName, string route) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AllowAnonymousToAreaFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string folderPath) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AllowAnonymousToAreaPage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string pageName) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AllowAnonymousToFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string folderPath) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AllowAnonymousToPage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string pageName) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeAreaFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string folderPath, string policy) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeAreaFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string folderPath) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeAreaPage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string pageName, string policy) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeAreaPage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string pageName) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string folderPath, string policy) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string folderPath) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizePage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string pageName, string policy) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizePage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string pageName) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection ConfigureFilter(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelConvention ConfigureFilter(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, System.Func<Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> factory) => throw null;
            }

        }
    }
}
