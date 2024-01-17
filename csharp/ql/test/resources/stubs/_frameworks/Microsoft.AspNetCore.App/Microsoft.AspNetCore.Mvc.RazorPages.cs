// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Mvc.RazorPages, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public sealed class PageActionEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                public void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finalConvention) => throw null;
            }
            public static partial class RazorPagesEndpointRouteBuilderExtensions
            {
                public static void MapDynamicPageRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static void MapDynamicPageRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, object state) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static void MapDynamicPageRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, object state, int order) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToAreaPage(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string page, string area) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToAreaPage(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string page, string area) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToPage(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string page) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToPage(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string page) => throw null;
                public static Microsoft.AspNetCore.Builder.PageActionEndpointConventionBuilder MapRazorPages(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints) => throw null;
            }
        }
        namespace Mvc
        {
            namespace ApplicationModels
            {
                public interface IPageApplicationModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel model);
                }
                public interface IPageApplicationModelPartsProvider
                {
                    Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel CreateHandlerModel(System.Reflection.MethodInfo method);
                    Microsoft.AspNetCore.Mvc.ApplicationModels.PageParameterModel CreateParameterModel(System.Reflection.ParameterInfo parameter);
                    Microsoft.AspNetCore.Mvc.ApplicationModels.PagePropertyModel CreatePropertyModel(System.Reflection.PropertyInfo property);
                    bool IsHandler(System.Reflection.MethodInfo methodInfo);
                }
                public interface IPageApplicationModelProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModelProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModelProviderContext context);
                    int Order { get; }
                }
                public interface IPageConvention
                {
                }
                public interface IPageHandlerModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel model);
                }
                public interface IPageRouteModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel model);
                }
                public interface IPageRouteModelProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModelProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModelProviderContext context);
                    int Order { get; }
                }
                public class PageApplicationModel
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor ActionDescriptor { get => throw null; }
                    public string AreaName { get => throw null; }
                    public PageApplicationModel(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor, System.Reflection.TypeInfo handlerType, System.Collections.Generic.IReadOnlyList<object> handlerAttributes) => throw null;
                    public PageApplicationModel(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor, System.Reflection.TypeInfo declaredModelType, System.Reflection.TypeInfo handlerType, System.Collections.Generic.IReadOnlyList<object> handlerAttributes) => throw null;
                    public PageApplicationModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel other) => throw null;
                    public System.Reflection.TypeInfo DeclaredModelType { get => throw null; }
                    public System.Collections.Generic.IList<object> EndpointMetadata { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel> HandlerMethods { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PagePropertyModel> HandlerProperties { get => throw null; }
                    public System.Reflection.TypeInfo HandlerType { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<object> HandlerTypeAttributes { get => throw null; }
                    public System.Reflection.TypeInfo ModelType { get => throw null; set { } }
                    public System.Reflection.TypeInfo PageType { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public string RelativePath { get => throw null; }
                    public string RouteTemplate { get => throw null; }
                    public string ViewEnginePath { get => throw null; }
                }
                public class PageApplicationModelProviderContext
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor ActionDescriptor { get => throw null; }
                    public PageApplicationModelProviderContext(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor descriptor, System.Reflection.TypeInfo pageTypeInfo) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel PageApplicationModel { get => throw null; set { } }
                    public System.Reflection.TypeInfo PageType { get => throw null; }
                }
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
                    public PageConventionCollection() => throw null;
                    public PageConventionCollection(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention> conventions) => throw null;
                    public void RemoveType<TPageConvention>() where TPageConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention => throw null;
                    public void RemoveType(System.Type pageConventionType) => throw null;
                }
                public class PageHandlerModel : Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public PageHandlerModel(System.Reflection.MethodInfo handlerMethod, System.Collections.Generic.IReadOnlyList<object> attributes) => throw null;
                    public PageHandlerModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel other) => throw null;
                    public string HandlerName { get => throw null; set { } }
                    public string HttpMethod { get => throw null; set { } }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public System.Reflection.MethodInfo MethodInfo { get => throw null; }
                    public string Name { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel Page { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PageParameterModel> Parameters { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                }
                public class PageParameterModel : Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase, Microsoft.AspNetCore.Mvc.ApplicationModels.IBindingModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    public PageParameterModel(System.Reflection.ParameterInfo parameterInfo, System.Collections.Generic.IReadOnlyList<object> attributes) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public PageParameterModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PageParameterModel other) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageHandlerModel Handler { get => throw null; set { } }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public System.Reflection.ParameterInfo ParameterInfo { get => throw null; }
                    public string ParameterName { get => throw null; set { } }
                }
                public class PagePropertyModel : Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    public PagePropertyModel(System.Reflection.PropertyInfo propertyInfo, System.Collections.Generic.IReadOnlyList<object> attributes) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public PagePropertyModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PagePropertyModel other) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel Page { get => throw null; set { } }
                    public System.Reflection.PropertyInfo PropertyInfo { get => throw null; }
                    public string PropertyName { get => throw null; set { } }
                }
                public sealed class PageRouteMetadata
                {
                    public PageRouteMetadata(string pageRoute, string routeTemplate) => throw null;
                    public string PageRoute { get => throw null; }
                    public string RouteTemplate { get => throw null; }
                }
                public class PageRouteModel
                {
                    public string AreaName { get => throw null; }
                    public PageRouteModel(string relativePath, string viewEnginePath) => throw null;
                    public PageRouteModel(string relativePath, string viewEnginePath, string areaName) => throw null;
                    public PageRouteModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel other) => throw null;
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public string RelativePath { get => throw null; }
                    public Microsoft.AspNetCore.Routing.IOutboundParameterTransformer RouteParameterTransformer { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.SelectorModel> Selectors { get => throw null; }
                    public string ViewEnginePath { get => throw null; }
                }
                public class PageRouteModelProviderContext
                {
                    public PageRouteModelProviderContext() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel> RouteModels { get => throw null; }
                }
                public class PageRouteTransformerConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IPageConvention, Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel model) => throw null;
                    public PageRouteTransformerConvention(Microsoft.AspNetCore.Routing.IOutboundParameterTransformer parameterTransformer) => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel action) => throw null;
                }
            }
            namespace Diagnostics
            {
                public sealed class AfterHandlerMethodEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> Arguments { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterHandlerMethodEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IReadOnlyDictionary<string, object> arguments, Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor handlerMethodDescriptor, object instance, Microsoft.AspNetCore.Mvc.IActionResult result) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethodDescriptor { get => throw null; }
                    public object Instance { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterPageFilterOnPageHandlerExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterPageFilterOnPageHandlerExecutedEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext handlerExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext HandlerExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterPageFilterOnPageHandlerExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterPageFilterOnPageHandlerExecutingEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext handlerExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext HandlerExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterPageFilterOnPageHandlerExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterPageFilterOnPageHandlerExecutionEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext handlerExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext HandlerExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterPageFilterOnPageHandlerSelectedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterPageFilterOnPageHandlerSelectedEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext handlerSelectedContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext HandlerSelectedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterPageFilterOnPageHandlerSelectionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterPageFilterOnPageHandlerSelectionEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext handlerSelectedContext, Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext HandlerSelectedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeHandlerMethodEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> Arguments { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeHandlerMethodEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IReadOnlyDictionary<string, object> arguments, Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor handlerMethodDescriptor, object instance) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethodDescriptor { get => throw null; }
                    public object Instance { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforePageFilterOnPageHandlerExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforePageFilterOnPageHandlerExecutedEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext handlerExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext HandlerExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforePageFilterOnPageHandlerExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforePageFilterOnPageHandlerExecutingEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext handlerExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext HandlerExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforePageFilterOnPageHandlerExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforePageFilterOnPageHandlerExecutionEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext handlerExecutionContext, Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext HandlerExecutionContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforePageFilterOnPageHandlerSelectedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforePageFilterOnPageHandlerSelectedEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext handlerSelectedContext, Microsoft.AspNetCore.Mvc.Filters.IPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext HandlerSelectedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforePageFilterOnPageHandlerSelectionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforePageFilterOnPageHandlerSelectionEventData(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext handlerSelectedContext, Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext HandlerSelectedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
            }
            namespace Filters
            {
                public interface IAsyncPageFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnPageHandlerExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutionDelegate next);
                    System.Threading.Tasks.Task OnPageHandlerSelectionAsync(Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext context);
                }
                public interface IPageFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnPageHandlerExecuted(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext context);
                    void OnPageHandlerExecuting(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext context);
                    void OnPageHandlerSelected(Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext context);
                }
                public class PageHandlerExecutedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public virtual bool Canceled { get => throw null; set { } }
                    public PageHandlerExecutedContext(Microsoft.AspNetCore.Mvc.RazorPages.PageContext pageContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor handlerMethod, object handlerInstance) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual System.Exception Exception { get => throw null; set { } }
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set { } }
                    public virtual bool ExceptionHandled { get => throw null; set { } }
                    public virtual object HandlerInstance { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethod { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set { } }
                }
                public class PageHandlerExecutingContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public PageHandlerExecutingContext(Microsoft.AspNetCore.Mvc.RazorPages.PageContext pageContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor handlerMethod, System.Collections.Generic.IDictionary<string, object> handlerArguments, object handlerInstance) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual System.Collections.Generic.IDictionary<string, object> HandlerArguments { get => throw null; }
                    public virtual object HandlerInstance { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethod { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set { } }
                }
                public delegate System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext> PageHandlerExecutionDelegate();
                public class PageHandlerSelectedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; }
                    public PageHandlerSelectedContext(Microsoft.AspNetCore.Mvc.RazorPages.PageContext pageContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, object handlerInstance) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual object HandlerInstance { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor HandlerMethod { get => throw null; set { } }
                }
            }
            namespace RazorPages
            {
                public class CompiledPageActionDescriptor : Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor
                {
                    public CompiledPageActionDescriptor() => throw null;
                    public CompiledPageActionDescriptor(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor) => throw null;
                    public System.Reflection.TypeInfo DeclaredModelTypeInfo { get => throw null; set { } }
                    public Microsoft.AspNetCore.Http.Endpoint Endpoint { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor> HandlerMethods { get => throw null; set { } }
                    public System.Reflection.TypeInfo HandlerTypeInfo { get => throw null; set { } }
                    public System.Reflection.TypeInfo ModelTypeInfo { get => throw null; set { } }
                    public System.Reflection.TypeInfo PageTypeInfo { get => throw null; set { } }
                }
                namespace Infrastructure
                {
                    public sealed class CompiledPageActionDescriptorProvider : Microsoft.AspNetCore.Mvc.Abstractions.IActionDescriptorProvider
                    {
                        public CompiledPageActionDescriptorProvider(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelProvider> pageRouteModelProviders, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelProvider> applicationModelProviders, Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager applicationPartManager, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> mvcOptions, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.RazorPages.RazorPagesOptions> pageOptions) => throw null;
                        public void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context) => throw null;
                        public void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context) => throw null;
                        public int Order { get => throw null; }
                    }
                    public class HandlerMethodDescriptor
                    {
                        public HandlerMethodDescriptor() => throw null;
                        public string HttpMethod { get => throw null; set { } }
                        public System.Reflection.MethodInfo MethodInfo { get => throw null; set { } }
                        public string Name { get => throw null; set { } }
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerParameterDescriptor> Parameters { get => throw null; set { } }
                    }
                    public class HandlerParameterDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor, Microsoft.AspNetCore.Mvc.Infrastructure.IParameterInfoParameterDescriptor
                    {
                        public HandlerParameterDescriptor() => throw null;
                        public System.Reflection.ParameterInfo ParameterInfo { get => throw null; set { } }
                    }
                    public interface IPageHandlerMethodSelector
                    {
                        Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.HandlerMethodDescriptor Select(Microsoft.AspNetCore.Mvc.RazorPages.PageContext context);
                    }
                    public interface IPageLoader
                    {
                        Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor Load(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor);
                    }
                    public class PageActionDescriptorProvider : Microsoft.AspNetCore.Mvc.Abstractions.IActionDescriptorProvider
                    {
                        protected System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PageRouteModel> BuildModel() => throw null;
                        public PageActionDescriptorProvider(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationModels.IPageRouteModelProvider> pageRouteModelProviders, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> mvcOptionsAccessor, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.RazorPages.RazorPagesOptions> pagesOptionsAccessor) => throw null;
                        public void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context) => throw null;
                        public void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context) => throw null;
                        public int Order { get => throw null; set { } }
                    }
                    public class PageBoundPropertyDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor, Microsoft.AspNetCore.Mvc.Infrastructure.IPropertyInfoParameterDescriptor
                    {
                        public PageBoundPropertyDescriptor() => throw null;
                        public System.Reflection.PropertyInfo Property { get => throw null; set { } }
                        System.Reflection.PropertyInfo Microsoft.AspNetCore.Mvc.Infrastructure.IPropertyInfoParameterDescriptor.PropertyInfo { get => throw null; }
                    }
                    public abstract class PageLoader : Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.IPageLoader
                    {
                        protected PageLoader() => throw null;
                        Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure.IPageLoader.Load(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor) => throw null;
                        public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor> LoadAsync(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor);
                        public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor> LoadAsync(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor actionDescriptor, Microsoft.AspNetCore.Http.EndpointMetadataCollection endpointMetadata) => throw null;
                    }
                    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
                    public class PageModelAttribute : System.Attribute
                    {
                        public PageModelAttribute() => throw null;
                    }
                    public class PageResultExecutor : Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor
                    {
                        public PageResultExecutor(Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory, Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine compositeViewEngine, Microsoft.AspNetCore.Mvc.Razor.IRazorViewEngine razorViewEngine, Microsoft.AspNetCore.Mvc.Razor.IRazorPageActivator razorPageActivator, System.Diagnostics.DiagnosticListener diagnosticListener, System.Text.Encodings.Web.HtmlEncoder htmlEncoder) : base(default(Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory), default(Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine), default(System.Diagnostics.DiagnosticListener)) => throw null;
                        public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.RazorPages.PageContext pageContext, Microsoft.AspNetCore.Mvc.RazorPages.PageResult result) => throw null;
                    }
                    public class PageViewLocationExpander : Microsoft.AspNetCore.Mvc.Razor.IViewLocationExpander
                    {
                        public PageViewLocationExpander() => throw null;
                        public System.Collections.Generic.IEnumerable<string> ExpandViewLocations(Microsoft.AspNetCore.Mvc.Razor.ViewLocationExpanderContext context, System.Collections.Generic.IEnumerable<string> viewLocations) => throw null;
                        public void PopulateValues(Microsoft.AspNetCore.Mvc.Razor.ViewLocationExpanderContext context) => throw null;
                    }
                    public class RazorPageAdapter : Microsoft.AspNetCore.Mvc.Razor.IRazorPage
                    {
                        public Microsoft.AspNetCore.Html.IHtmlContent BodyContent { get => throw null; set { } }
                        public RazorPageAdapter(Microsoft.AspNetCore.Mvc.Razor.RazorPageBase page, System.Type modelType) => throw null;
                        public void EnsureRenderedBodyOrSections() => throw null;
                        public System.Threading.Tasks.Task ExecuteAsync() => throw null;
                        public bool IsLayoutBeingRendered { get => throw null; set { } }
                        public string Layout { get => throw null; set { } }
                        public string Path { get => throw null; set { } }
                        public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate> PreviousSectionWriters { get => throw null; set { } }
                        public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate> SectionWriters { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                    }
                    public class RazorPageAttribute : Microsoft.AspNetCore.Mvc.Razor.Compilation.RazorViewAttribute
                    {
                        public RazorPageAttribute(string path, System.Type viewType, string routeTemplate) : base(default(string), default(System.Type)) => throw null;
                        public string RouteTemplate { get => throw null; }
                    }
                    public class ServiceBasedPageModelActivatorProvider : Microsoft.AspNetCore.Mvc.RazorPages.IPageModelActivatorProvider
                    {
                        public System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor) => throw null;
                        public System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor) => throw null;
                        public ServiceBasedPageModelActivatorProvider() => throw null;
                    }
                }
                public interface IPageActivatorProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                    virtual System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object, System.Threading.Tasks.ValueTask> CreateAsyncReleaser(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor) => throw null;
                    System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                }
                public interface IPageFactoryProvider
                {
                    virtual System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object, System.Threading.Tasks.ValueTask> CreateAsyncPageDisposer(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor) => throw null;
                    System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object> CreatePageDisposer(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                    System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, Microsoft.AspNetCore.Mvc.Rendering.ViewContext, object> CreatePageFactory(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                }
                public interface IPageModelActivatorProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                    virtual System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object, System.Threading.Tasks.ValueTask> CreateAsyncReleaser(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor) => throw null;
                    System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                }
                public interface IPageModelFactoryProvider
                {
                    virtual System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object, System.Threading.Tasks.ValueTask> CreateAsyncModelDisposer(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor) => throw null;
                    System.Action<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateModelDisposer(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                    System.Func<Microsoft.AspNetCore.Mvc.RazorPages.PageContext, object> CreateModelFactory(Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor descriptor);
                }
                [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = true)]
                public class NonHandlerAttribute : System.Attribute
                {
                    public NonHandlerAttribute() => throw null;
                }
                public abstract class Page : Microsoft.AspNetCore.Mvc.RazorPages.PageBase
                {
                    protected Page() => throw null;
                }
                public class PageActionDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor
                {
                    public string AreaName { get => throw null; set { } }
                    public PageActionDescriptor() => throw null;
                    public PageActionDescriptor(Microsoft.AspNetCore.Mvc.RazorPages.PageActionDescriptor other) => throw null;
                    public override string DisplayName { get => throw null; set { } }
                    public string RelativePath { get => throw null; set { } }
                    public string ViewEnginePath { get => throw null; set { } }
                }
                public abstract class PageBase : Microsoft.AspNetCore.Mvc.Razor.RazorPageBase
                {
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestResult BadRequest() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(object error) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                    public override void BeginContext(int position, int length, bool isLiteral) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                    protected PageBase() => throw null;
                    public override void EndContext() => throw null;
                    public override void EnsureRenderedBodyOrSections() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirect(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPermanent(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPermanentPreserveMethod(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPreserveMethod(string localUrl) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.NotFoundResult NotFound() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.NotFoundObjectResult NotFound(object value) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.PageResult Page() => throw null;
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageContext PageContext { get => throw null; set { } }
                    public virtual Microsoft.AspNetCore.Mvc.PartialViewResult Partial(string viewName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PartialViewResult Partial(string viewName, object model) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult Redirect(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanent(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanentPreserveMethod(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPreserveMethod(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanentPreserveMethod(string actionName = default(string), string controllerName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPreserveMethod(string actionName = default(string), string controllerName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanentPreserveMethod(string pageName = default(string), string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePreserveMethod(string pageName = default(string), string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, object routeValues, string fragment) => throw null;
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
                    public virtual System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model) where TModel : class => throw null;
                    public virtual System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix) where TModel : class => throw null;
                    public virtual System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider) where TModel : class => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, params System.Linq.Expressions.Expression<System.Func<TModel, object>>[] includeExpressions) where TModel : class => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) where TModel : class => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, params System.Linq.Expressions.Expression<System.Func<TModel, object>>[] includeExpressions) where TModel : class => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string prefix, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) where TModel : class => throw null;
                    public virtual System.Threading.Tasks.Task<bool> TryUpdateModelAsync(object model, System.Type modelType, string prefix) => throw null;
                    public System.Threading.Tasks.Task<bool> TryUpdateModelAsync(object model, System.Type modelType, string prefix, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) => throw null;
                    public virtual bool TryValidateModel(object model) => throw null;
                    public virtual bool TryValidateModel(object model, string prefix) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.UnauthorizedResult Unauthorized() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName, object arguments) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType, object arguments) => throw null;
                    public override Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class PageContext : Microsoft.AspNetCore.Mvc.ActionContext
                {
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.CompiledPageActionDescriptor ActionDescriptor { get => throw null; set { } }
                    public PageContext() => throw null;
                    public PageContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext) => throw null;
                    public virtual System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> ValueProviderFactories { get => throw null; set { } }
                    public virtual Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set { } }
                    public virtual System.Collections.Generic.IList<System.Func<Microsoft.AspNetCore.Mvc.Razor.IRazorPage>> ViewStartFactories { get => throw null; set { } }
                }
                [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
                public class PageContextAttribute : System.Attribute
                {
                    public PageContextAttribute() => throw null;
                }
                public abstract class PageModel : Microsoft.AspNetCore.Mvc.Filters.IAsyncPageFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IPageFilter
                {
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestResult BadRequest() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(object error) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                    protected PageModel() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(params string[] authenticationSchemes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ForbidResult Forbid(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirect(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPermanent(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPermanentPreserveMethod(string localUrl) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.LocalRedirectResult LocalRedirectPreserveMethod(string localUrl) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.NotFoundResult NotFound() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.NotFoundObjectResult NotFound(object value) => throw null;
                    public virtual void OnPageHandlerExecuted(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutedContext context) => throw null;
                    public virtual void OnPageHandlerExecuting(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnPageHandlerExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.PageHandlerExecutionDelegate next) => throw null;
                    public virtual void OnPageHandlerSelected(Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnPageHandlerSelectionAsync(Microsoft.AspNetCore.Mvc.Filters.PageHandlerSelectedContext context) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RazorPages.PageResult Page() => throw null;
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageContext PageContext { get => throw null; set { } }
                    public virtual Microsoft.AspNetCore.Mvc.PartialViewResult Partial(string viewName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PartialViewResult Partial(string viewName, object model) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName) => throw null;
                    protected Microsoft.AspNetCore.Mvc.RedirectResult Redirect(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanent(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanentPreserveMethod(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPreserveMethod(string url) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanent(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPermanentPreserveMethod(string actionName = default(string), string controllerName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToActionPreserveMethod(string actionName = default(string), string controllerName = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanentPreserveMethod(string pageName = default(string), string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePreserveMethod(string pageName = default(string), string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoute(string routeName, object routeValues, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, object routeValues) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, string fragment) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.RedirectToRouteResult RedirectToRoutePermanent(string routeName, object routeValues, string fragment) => throw null;
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
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; set { } }
                    protected System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model) where TModel : class => throw null;
                    protected System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name) where TModel : class => throw null;
                    protected System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider) where TModel : class => throw null;
                    protected System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, params System.Linq.Expressions.Expression<System.Func<TModel, object>>[] includeExpressions) where TModel : class => throw null;
                    protected System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) where TModel : class => throw null;
                    protected System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, params System.Linq.Expressions.Expression<System.Func<TModel, object>>[] includeExpressions) where TModel : class => throw null;
                    protected System.Threading.Tasks.Task<bool> TryUpdateModelAsync<TModel>(TModel model, string name, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) where TModel : class => throw null;
                    protected System.Threading.Tasks.Task<bool> TryUpdateModelAsync(object model, System.Type modelType, string name) => throw null;
                    protected System.Threading.Tasks.Task<bool> TryUpdateModelAsync(object model, System.Type modelType, string name, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> propertyFilter) => throw null;
                    public virtual bool TryValidateModel(object model) => throw null;
                    public virtual bool TryValidateModel(object model, string name) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.UnauthorizedResult Unauthorized() => throw null;
                    public Microsoft.AspNetCore.Mvc.IUrlHelper Url { get => throw null; set { } }
                    public System.Security.Claims.ClaimsPrincipal User { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName, object arguments) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType, object arguments) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; }
                }
                public class PageResult : Microsoft.AspNetCore.Mvc.ActionResult
                {
                    public string ContentType { get => throw null; set { } }
                    public PageResult() => throw null;
                    public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                    public object Model { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.RazorPages.PageBase Page { get => throw null; set { } }
                    public int? StatusCode { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set { } }
                }
                public class RazorPagesOptions : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>, System.Collections.IEnumerable
                {
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection Conventions { get => throw null; }
                    public RazorPagesOptions() => throw null;
                    System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public string RootDirectory { get => throw null; set { } }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class MvcRazorPagesMvcBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddRazorPagesOptions(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.RazorPages.RazorPagesOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder WithRazorPagesAtContentRoot(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder WithRazorPagesRoot(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, string rootDirectory) => throw null;
            }
            public static partial class MvcRazorPagesMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddRazorPages(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddRazorPages(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.RazorPages.RazorPagesOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder WithRazorPagesRoot(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, string rootDirectory) => throw null;
            }
            public static partial class PageConventionCollectionExtensions
            {
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection Add(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IParameterModelBaseConvention convention) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AddAreaPageRoute(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string pageName, string route) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AddPageRoute(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string pageName, string route) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AllowAnonymousToAreaFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string folderPath) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AllowAnonymousToAreaPage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string pageName) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AllowAnonymousToFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string folderPath) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AllowAnonymousToPage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string pageName) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeAreaFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string folderPath) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeAreaFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string folderPath, string policy) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeAreaPage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string pageName) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeAreaPage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string areaName, string pageName, string policy) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string folderPath, string policy) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizeFolder(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string folderPath) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizePage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string pageName, string policy) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection AuthorizePage(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, string pageName) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.IPageApplicationModelConvention ConfigureFilter(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, System.Func<Microsoft.AspNetCore.Mvc.ApplicationModels.PageApplicationModel, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> factory) => throw null;
                public static Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection ConfigureFilter(this Microsoft.AspNetCore.Mvc.ApplicationModels.PageConventionCollection conventions, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
            }
        }
    }
}
