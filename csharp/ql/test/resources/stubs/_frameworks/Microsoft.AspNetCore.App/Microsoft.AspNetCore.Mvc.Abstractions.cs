// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            // Generated from `Microsoft.AspNetCore.Mvc.ActionContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ActionContext
            {
                public ActionContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext) => throw null;
                public ActionContext(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public ActionContext(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor) => throw null;
                public ActionContext() => throw null;
                public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.IActionResult` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IActionResult
            {
                System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context);
            }

            // Generated from `Microsoft.AspNetCore.Mvc.IUrlHelper` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IUrlHelper
            {
                string Action(Microsoft.AspNetCore.Mvc.Routing.UrlActionContext actionContext);
                Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get; }
                string Content(string contentPath);
                bool IsLocalUrl(string url);
                string Link(string routeName, object values);
                string RouteUrl(Microsoft.AspNetCore.Mvc.Routing.UrlRouteContext routeContext);
            }

            namespace Abstractions
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionDescriptor
                {
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata> ActionConstraints { get => throw null; set => throw null; }
                    public ActionDescriptor() => throw null;
                    public Microsoft.AspNetCore.Mvc.Routing.AttributeRouteInfo AttributeRouteInfo { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor> BoundProperties { get => throw null; set => throw null; }
                    public virtual string DisplayName { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<object> EndpointMetadata { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.FilterDescriptor> FilterDescriptors { get => throw null; set => throw null; }
                    public string Id { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor> Parameters { get => throw null; set => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; set => throw null; }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorExtensions` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class ActionDescriptorExtensions
                {
                    public static T GetProperty<T>(this Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor) => throw null;
                    public static void SetProperty<T>(this Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, T value) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionDescriptorProviderContext
                {
                    public ActionDescriptorProviderContext() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> Results { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Abstractions.ActionInvokerProviderContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionInvokerProviderContext
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public ActionInvokerProviderContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext) => throw null;
                    public Microsoft.AspNetCore.Mvc.Abstractions.IActionInvoker Result { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Abstractions.IActionDescriptorProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionDescriptorProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context);
                    int Order { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Abstractions.IActionInvoker` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionInvoker
                {
                    System.Threading.Tasks.Task InvokeAsync();
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Abstractions.IActionInvokerProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionInvokerProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.Abstractions.ActionInvokerProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.Abstractions.ActionInvokerProviderContext context);
                    int Order { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ParameterDescriptor
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get => throw null; set => throw null; }
                    public string Name { get => throw null; set => throw null; }
                    public ParameterDescriptor() => throw null;
                    public System.Type ParameterType { get => throw null; set => throw null; }
                }

            }
            namespace ActionConstraints
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionConstraintContext
                {
                    public ActionConstraintContext() => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ActionConstraints.ActionSelectorCandidate> Candidates { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ActionConstraints.ActionSelectorCandidate CurrentCandidate { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteContext RouteContext { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintItem` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionConstraintItem
                {
                    public ActionConstraintItem(Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata metadata) => throw null;
                    public Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint Constraint { get => throw null; set => throw null; }
                    public bool IsReusable { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata Metadata { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintProviderContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionConstraintProviderContext
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor Action { get => throw null; }
                    public ActionConstraintProviderContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor action, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintItem> items) => throw null;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintItem> Results { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.ActionSelectorCandidate` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct ActionSelectorCandidate
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor Action { get => throw null; }
                    public ActionSelectorCandidate(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor action, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint> constraints) => throw null;
                    // Stub generator skipped constructor 
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint> Constraints { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionConstraint : Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata
                {
                    bool Accept(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintContext context);
                    int Order { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintFactory` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionConstraintFactory : Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata
                {
                    Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint CreateInstance(System.IServiceProvider services);
                    bool IsReusable { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionConstraintMetadata
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionConstraintProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintProviderContext context);
                    int Order { get; }
                }

            }
            namespace ApiExplorer
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiDescription
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; set => throw null; }
                    public ApiDescription() => throw null;
                    public string GroupName { get => throw null; set => throw null; }
                    public string HttpMethod { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiParameterDescription> ParameterDescriptions { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public string RelativePath { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiRequestFormat> SupportedRequestFormats { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiResponseType> SupportedResponseTypes { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionProviderContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiDescriptionProviderContext
                {
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> Actions { get => throw null; }
                    public ApiDescriptionProviderContext(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> actions) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription> Results { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiParameterDescription` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiParameterDescription
                {
                    public ApiParameterDescription() => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get => throw null; set => throw null; }
                    public object DefaultValue { get => throw null; set => throw null; }
                    public bool IsRequired { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; set => throw null; }
                    public string Name { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor ParameterDescriptor { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApiExplorer.ApiParameterRouteInfo RouteInfo { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Source { get => throw null; set => throw null; }
                    public System.Type Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiParameterRouteInfo` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiParameterRouteInfo
                {
                    public ApiParameterRouteInfo() => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; set => throw null; }
                    public object DefaultValue { get => throw null; set => throw null; }
                    public bool IsOptional { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiRequestFormat` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiRequestFormat
                {
                    public ApiRequestFormat() => throw null;
                    public Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter Formatter { get => throw null; set => throw null; }
                    public string MediaType { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiResponseFormat` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiResponseFormat
                {
                    public ApiResponseFormat() => throw null;
                    public Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter Formatter { get => throw null; set => throw null; }
                    public string MediaType { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiResponseType` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiResponseType
                {
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiResponseFormat> ApiResponseFormats { get => throw null; set => throw null; }
                    public ApiResponseType() => throw null;
                    public bool IsDefaultResponse { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; set => throw null; }
                    public int StatusCode { get => throw null; set => throw null; }
                    public System.Type Type { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiDescriptionProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionProviderContext context);
                    int Order { get; }
                }

            }
            namespace Authorization
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Authorization.IAllowAnonymousFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAllowAnonymousFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }

            }
            namespace Filters
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionExecutedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public ActionExecutedContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, object controller) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual bool Canceled { get => throw null; set => throw null; }
                    public virtual object Controller { get => throw null; }
                    public virtual System.Exception Exception { get => throw null; set => throw null; }
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set => throw null; }
                    public virtual bool ExceptionHandled { get => throw null; set => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionExecutingContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual System.Collections.Generic.IDictionary<string, object> ActionArguments { get => throw null; }
                    public ActionExecutingContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, System.Collections.Generic.IDictionary<string, object> actionArguments, object controller) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual object Controller { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ActionExecutionDelegate` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public delegate System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext> ActionExecutionDelegate();

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AuthorizationFilterContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public AuthorizationFilterContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ExceptionContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ExceptionContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual System.Exception Exception { get => throw null; set => throw null; }
                    public ExceptionContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set => throw null; }
                    public virtual bool ExceptionHandled { get => throw null; set => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.FilterContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class FilterContext : Microsoft.AspNetCore.Mvc.ActionContext
                {
                    public FilterContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters) => throw null;
                    public virtual System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    public TMetadata FindEffectivePolicy<TMetadata>() where TMetadata : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public bool IsEffectivePolicy<TMetadata>(TMetadata policy) where TMetadata : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.FilterDescriptor` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FilterDescriptor
                {
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public FilterDescriptor(Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter, int filterScope) => throw null;
                    public int Order { get => throw null; set => throw null; }
                    public int Scope { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.FilterItem` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FilterItem
                {
                    public Microsoft.AspNetCore.Mvc.Filters.FilterDescriptor Descriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; set => throw null; }
                    public FilterItem(Microsoft.AspNetCore.Mvc.Filters.FilterDescriptor descriptor, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public FilterItem(Microsoft.AspNetCore.Mvc.Filters.FilterDescriptor descriptor) => throw null;
                    public bool IsReusable { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.FilterProviderContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FilterProviderContext
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; set => throw null; }
                    public FilterProviderContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.FilterItem> items) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.FilterItem> Results { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IActionFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnActionExecuted(Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext context);
                    void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAlwaysRunResultFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAlwaysRunResultFilter : Microsoft.AspNetCore.Mvc.Filters.IResultFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAsyncActionFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAsyncActionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnActionExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ActionExecutionDelegate next);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAsyncAlwaysRunResultFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAsyncAlwaysRunResultFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IAsyncResultFilter
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAsyncAuthorizationFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAsyncAuthorizationFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnAuthorizationAsync(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAsyncExceptionFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAsyncExceptionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnExceptionAsync(Microsoft.AspNetCore.Mvc.Filters.ExceptionContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAsyncResourceFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAsyncResourceFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnResourceExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutionDelegate next);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAsyncResultFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAsyncResultFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnResultExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ResultExecutionDelegate next);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IAuthorizationFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IAuthorizationFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnAuthorization(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IExceptionFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IExceptionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnException(Microsoft.AspNetCore.Mvc.Filters.ExceptionContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IFilterContainer` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFilterContainer
                {
                    Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata FilterDefinition { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IFilterFactory` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFilterFactory : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider);
                    bool IsReusable { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFilterMetadata
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IFilterProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFilterProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.Filters.FilterProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.Filters.FilterProviderContext context);
                    int Order { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IOrderedFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    int Order { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IResourceFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IResourceFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnResourceExecuted(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext context);
                    void OnResourceExecuting(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.IResultFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IResultFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context);
                    void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ResourceExecutedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual bool Canceled { get => throw null; set => throw null; }
                    public virtual System.Exception Exception { get => throw null; set => throw null; }
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set => throw null; }
                    public virtual bool ExceptionHandled { get => throw null; set => throw null; }
                    public ResourceExecutedContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ResourceExecutingContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public ResourceExecutingContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> valueProviderFactories) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> ValueProviderFactories { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ResourceExecutionDelegate` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public delegate System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext> ResourceExecutionDelegate();

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ResultExecutedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual bool Canceled { get => throw null; set => throw null; }
                    public virtual object Controller { get => throw null; }
                    public virtual System.Exception Exception { get => throw null; set => throw null; }
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set => throw null; }
                    public virtual bool ExceptionHandled { get => throw null; set => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                    public ResultExecutedContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, Microsoft.AspNetCore.Mvc.IActionResult result, object controller) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ResultExecutingContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual bool Cancel { get => throw null; set => throw null; }
                    public virtual object Controller { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set => throw null; }
                    public ResultExecutingContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, Microsoft.AspNetCore.Mvc.IActionResult result, object controller) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ResultExecutionDelegate` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public delegate System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext> ResultExecutionDelegate();

            }
            namespace Formatters
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.FormatterCollection<>` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FormatterCollection<TFormatter> : System.Collections.ObjectModel.Collection<TFormatter>
                {
                    public FormatterCollection(System.Collections.Generic.IList<TFormatter> list) => throw null;
                    public FormatterCollection() => throw null;
                    public void RemoveType<T>() where T : TFormatter => throw null;
                    public void RemoveType(System.Type formatterType) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IInputFormatter
                {
                    bool CanRead(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context);
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.IInputFormatterExceptionPolicy` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IInputFormatterExceptionPolicy
                {
                    Microsoft.AspNetCore.Mvc.Formatters.InputFormatterExceptionPolicy ExceptionPolicy { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IOutputFormatter
                {
                    bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context);
                    System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputFormatterContext
                {
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public InputFormatterContext(Microsoft.AspNetCore.Http.HttpContext httpContext, string modelName, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextReader> readerFactory, bool treatEmptyInputAsDefaultValue) => throw null;
                    public InputFormatterContext(Microsoft.AspNetCore.Http.HttpContext httpContext, string modelName, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextReader> readerFactory) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; }
                    public string ModelName { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                    public System.Type ModelType { get => throw null; }
                    public System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextReader> ReaderFactory { get => throw null; }
                    public bool TreatEmptyInputAsDefaultValue { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.InputFormatterException` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputFormatterException : System.Exception
                {
                    public InputFormatterException(string message, System.Exception innerException) => throw null;
                    public InputFormatterException(string message) => throw null;
                    public InputFormatterException() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.InputFormatterExceptionPolicy` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum InputFormatterExceptionPolicy
                {
                    AllExceptions,
                    MalformedInputExceptions,
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InputFormatterResult
                {
                    public static Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult Failure() => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> FailureAsync() => throw null;
                    public bool HasError { get => throw null; }
                    public bool IsModelSet { get => throw null; }
                    public object Model { get => throw null; }
                    public static Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult NoValue() => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> NoValueAsync() => throw null;
                    public static Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult Success(object model) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> SuccessAsync(object model) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class OutputFormatterCanWriteContext
                {
                    public virtual Microsoft.Extensions.Primitives.StringSegment ContentType { get => throw null; set => throw null; }
                    public virtual bool ContentTypeIsServerDefined { get => throw null; set => throw null; }
                    public virtual Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set => throw null; }
                    public virtual object Object { get => throw null; set => throw null; }
                    public virtual System.Type ObjectType { get => throw null; set => throw null; }
                    protected OutputFormatterCanWriteContext(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class OutputFormatterWriteContext : Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext
                {
                    public OutputFormatterWriteContext(Microsoft.AspNetCore.Http.HttpContext httpContext, System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextWriter> writerFactory, System.Type objectType, object @object) : base(default(Microsoft.AspNetCore.Http.HttpContext)) => throw null;
                    public virtual System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextWriter> WriterFactory { get => throw null; set => throw null; }
                }

            }
            namespace ModelBinding
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BindingInfo
                {
                    public string BinderModelName { get => throw null; set => throw null; }
                    public System.Type BinderType { get => throw null; set => throw null; }
                    public BindingInfo(Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo other) => throw null;
                    public BindingInfo() => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.EmptyBodyBehavior EmptyBodyBehavior { get => throw null; set => throw null; }
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo GetBindingInfo(System.Collections.Generic.IEnumerable<object> attributes, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo GetBindingInfo(System.Collections.Generic.IEnumerable<object> attributes) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider PropertyFilterProvider { get => throw null; set => throw null; }
                    public System.Func<Microsoft.AspNetCore.Mvc.ActionContext, bool> RequestPredicate { get => throw null; set => throw null; }
                    public bool TryApplyBindingInfo(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BindingSource : System.IEquatable<Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource>
                {
                    public static bool operator !=(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource s1, Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource s2) => throw null;
                    public static bool operator ==(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource s1, Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource s2) => throw null;
                    public BindingSource(string id, string displayName, bool isGreedy, bool isFromRequest) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Body;
                    public virtual bool CanAcceptDataFrom(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Custom;
                    public string DisplayName { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource other) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Form;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource FormFile;
                    public override int GetHashCode() => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Header;
                    public string Id { get => throw null; }
                    public bool IsFromRequest { get => throw null; }
                    public bool IsGreedy { get => throw null; }
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource ModelBinding;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Path;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Query;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Services;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Special;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.CompositeBindingSource` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CompositeBindingSource : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource
                {
                    private CompositeBindingSource() : base(default(string), default(string), default(bool), default(bool)) => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource> BindingSources { get => throw null; }
                    public override bool CanAcceptDataFrom(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.CompositeBindingSource Create(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource> bindingSources, string displayName) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.EmptyBodyBehavior` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum EmptyBodyBehavior
                {
                    Allow,
                    Default,
                    Disallow,
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.EnumGroupAndName` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct EnumGroupAndName
                {
                    public EnumGroupAndName(string group, string name) => throw null;
                    public EnumGroupAndName(string group, System.Func<string> name) => throw null;
                    // Stub generator skipped constructor 
                    public string Group { get => throw null; }
                    public string Name { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IBinderTypeProviderMetadata` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IBinderTypeProviderMetadata : Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
                {
                    System.Type BinderType { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IBindingSourceMetadata
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IConfigureEmptyBodyBehavior` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface IConfigureEmptyBodyBehavior
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.EmptyBodyBehavior EmptyBodyBehavior { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IModelBinder
                {
                    System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IModelBinderProvider
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IModelMetadataProvider
                {
                    System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> GetMetadataForProperties(System.Type modelType);
                    Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForType(System.Type modelType);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IModelNameProvider
                {
                    string Name { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPropertyFilterProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IRequestPredicateProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRequestPredicateProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.ActionContext, bool> RequestPredicate { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IValueProvider
                {
                    bool ContainsPrefix(string prefix);
                    Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IValueProviderFactory
                {
                    System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ModelBinderProviderContext
                {
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get; }
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder CreateBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo bindingInfo) => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder CreateBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata);
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get; }
                    protected ModelBinderProviderContext() => throw null;
                    public virtual System.IServiceProvider Services { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ModelBindingContext
                {
                    public abstract Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get; set; }
                    public abstract string BinderModelName { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext.NestedScope EnterNestedScope(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, string fieldName, string modelName, object model);
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext.NestedScope EnterNestedScope();
                    protected abstract void ExitNestedScope();
                    public abstract string FieldName { get; set; }
                    public virtual Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public abstract bool IsTopLevelObject { get; set; }
                    public abstract object Model { get; set; }
                    protected ModelBindingContext() => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get; set; }
                    public abstract string ModelName { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get; set; }
                    public virtual System.Type ModelType { get => throw null; }
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext+NestedScope` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct NestedScope : System.IDisposable
                    {
                        public void Dispose() => throw null;
                        public NestedScope(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext context) => throw null;
                        // Stub generator skipped constructor 
                    }


                    public string OriginalModelName { get => throw null; set => throw null; }
                    public abstract System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult Result { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary ValidationState { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider ValueProvider { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct ModelBindingResult : System.IEquatable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult>
                {
                    public static bool operator !=(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult x, Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult y) => throw null;
                    public static bool operator ==(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult x, Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult y) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult other) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult Failed() => throw null;
                    public override int GetHashCode() => throw null;
                    public bool IsModelSet { get => throw null; }
                    public object Model { get => throw null; }
                    // Stub generator skipped constructor 
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult Success(object model) => throw null;
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelError` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ModelError
                {
                    public string ErrorMessage { get => throw null; }
                    public System.Exception Exception { get => throw null; }
                    public ModelError(string errorMessage) => throw null;
                    public ModelError(System.Exception exception, string errorMessage) => throw null;
                    public ModelError(System.Exception exception) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelErrorCollection` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ModelErrorCollection : System.Collections.ObjectModel.Collection<Microsoft.AspNetCore.Mvc.ModelBinding.ModelError>
                {
                    public void Add(string errorMessage) => throw null;
                    public void Add(System.Exception exception) => throw null;
                    public ModelErrorCollection() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ModelMetadata : System.IEquatable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata>, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider
                {
                    public abstract System.Collections.Generic.IReadOnlyDictionary<object, object> AdditionalValues { get; }
                    public abstract string BinderModelName { get; }
                    public abstract System.Type BinderType { get; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get; }
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata BoundConstructor { get => throw null; }
                    public virtual System.Func<object[], object> BoundConstructorInvoker { get => throw null; }
                    public virtual System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> BoundConstructorParameters { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ContainerMetadata { get => throw null; }
                    public System.Type ContainerType { get => throw null; }
                    public abstract bool ConvertEmptyStringToNull { get; }
                    public abstract string DataTypeName { get; }
                    public static int DefaultOrder;
                    public abstract string Description { get; }
                    public abstract string DisplayFormatString { get; }
                    public abstract string DisplayName { get; }
                    public abstract string EditFormatString { get; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ElementMetadata { get; }
                    public System.Type ElementType { get => throw null; }
                    public abstract System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<Microsoft.AspNetCore.Mvc.ModelBinding.EnumGroupAndName, string>> EnumGroupedDisplayNamesAndValues { get; }
                    public abstract System.Collections.Generic.IReadOnlyDictionary<string, string> EnumNamesAndValues { get; }
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata other) => throw null;
                    public string GetDisplayName() => throw null;
                    public override int GetHashCode() => throw null;
                    public virtual System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> GetMetadataForProperties(System.Type modelType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForType(System.Type modelType) => throw null;
                    public abstract bool HasNonDefaultEditFormat { get; }
                    public virtual bool? HasValidators { get => throw null; }
                    public abstract bool HideSurroundingHtml { get; }
                    public abstract bool HtmlEncode { get; }
                    protected internal Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity Identity { get => throw null; }
                    public abstract bool IsBindingAllowed { get; }
                    public abstract bool IsBindingRequired { get; }
                    public bool IsCollectionType { get => throw null; }
                    public bool IsComplexType { get => throw null; }
                    public abstract bool IsEnum { get; }
                    public bool IsEnumerableType { get => throw null; }
                    public abstract bool IsFlagsEnum { get; }
                    public bool IsNullableValueType { get => throw null; }
                    public abstract bool IsReadOnly { get; }
                    public bool IsReferenceOrNullableType { get => throw null; }
                    public abstract bool IsRequired { get; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataKind MetadataKind { get => throw null; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelBindingMessageProvider ModelBindingMessageProvider { get; }
                    protected ModelMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity identity) => throw null;
                    public System.Type ModelType { get => throw null; }
                    public string Name { get => throw null; }
                    public abstract string NullDisplayText { get; }
                    public abstract int Order { get; }
                    public string ParameterName { get => throw null; }
                    public abstract string Placeholder { get; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelPropertyCollection Properties { get; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider PropertyFilterProvider { get; }
                    public abstract System.Func<object, object> PropertyGetter { get; }
                    public string PropertyName { get => throw null; }
                    public abstract System.Action<object, object> PropertySetter { get; }
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IPropertyValidationFilter PropertyValidationFilter { get => throw null; }
                    public abstract bool ShowForDisplay { get; }
                    public abstract bool ShowForEdit { get; }
                    public abstract string SimpleDisplayProperty { get; }
                    public abstract string TemplateHint { get; }
                    public System.Type UnderlyingOrModelType { get => throw null; }
                    public abstract bool ValidateChildren { get; }
                    public abstract System.Collections.Generic.IReadOnlyList<object> ValidatorMetadata { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadataProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ModelMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider
                {
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForConstructor(System.Reflection.ConstructorInfo constructor, System.Type modelType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForParameter(System.Reflection.ParameterInfo parameter, System.Type modelType) => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForParameter(System.Reflection.ParameterInfo parameter);
                    public abstract System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> GetMetadataForProperties(System.Type modelType);
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForProperty(System.Reflection.PropertyInfo propertyInfo, System.Type modelType) => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForType(System.Type modelType);
                    protected ModelMetadataProvider() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelPropertyCollection` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ModelPropertyCollection : System.Collections.ObjectModel.ReadOnlyCollection<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata>
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata this[string propertyName] { get => throw null; }
                    public ModelPropertyCollection(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> properties) : base(default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata>)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ModelStateDictionary : System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyDictionary<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>
                {
                    public void AddModelError(string key, string errorMessage) => throw null;
                    public void AddModelError(string key, System.Exception exception, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata) => throw null;
                    public void Clear() => throw null;
                    public void ClearValidationState(string key) => throw null;
                    public bool ContainsKey(string key) => throw null;
                    public int Count { get => throw null; }
                    public static int DefaultMaxAllowedErrors;
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary+Enumerator` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>
                    {
                        public System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry> Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public Enumerator(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary, string prefix) => throw null;
                        // Stub generator skipped constructor 
                        public bool MoveNext() => throw null;
                        public void Reset() => throw null;
                    }


                    public int ErrorCount { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.PrefixEnumerable FindKeysWithPrefix(string prefix) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.Enumerator GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>.GetEnumerator() => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelValidationState GetFieldValidationState(string key) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelValidationState GetValidationState(string key) => throw null;
                    public bool HasReachedMaxErrors { get => throw null; }
                    public bool IsValid { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry this[string key] { get => throw null; }
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary+KeyEnumerable` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct KeyEnumerable : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<string>
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.KeyEnumerator GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                        System.Collections.Generic.IEnumerator<string> System.Collections.Generic.IEnumerable<string>.GetEnumerator() => throw null;
                        public KeyEnumerable(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary) => throw null;
                        // Stub generator skipped constructor 
                    }


                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary+KeyEnumerator` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct KeyEnumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<string>
                    {
                        public string Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public KeyEnumerator(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary, string prefix) => throw null;
                        // Stub generator skipped constructor 
                        public bool MoveNext() => throw null;
                        public void Reset() => throw null;
                    }


                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.KeyEnumerable Keys { get => throw null; }
                    System.Collections.Generic.IEnumerable<string> System.Collections.Generic.IReadOnlyDictionary<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>.Keys { get => throw null; }
                    public void MarkFieldSkipped(string key) => throw null;
                    public void MarkFieldValid(string key) => throw null;
                    public int MaxAllowedErrors { get => throw null; set => throw null; }
                    public void Merge(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary) => throw null;
                    public ModelStateDictionary(int maxAllowedErrors) => throw null;
                    public ModelStateDictionary(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary) => throw null;
                    public ModelStateDictionary() => throw null;
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary+PrefixEnumerable` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct PrefixEnumerable : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.Enumerator GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                        System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>.GetEnumerator() => throw null;
                        public PrefixEnumerable(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary, string prefix) => throw null;
                        // Stub generator skipped constructor 
                    }


                    public bool Remove(string key) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry Root { get => throw null; }
                    public void SetModelValue(string key, object rawValue, string attemptedValue) => throw null;
                    public void SetModelValue(string key, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult valueProviderResult) => throw null;
                    public static bool StartsWithPrefix(string prefix, string key) => throw null;
                    public bool TryAddModelError(string key, string errorMessage) => throw null;
                    public bool TryAddModelError(string key, System.Exception exception, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata) => throw null;
                    public bool TryAddModelException(string key, System.Exception exception) => throw null;
                    public bool TryGetValue(string key, out Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry value) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelValidationState ValidationState { get => throw null; }
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary+ValueEnumerable` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct ValueEnumerable : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.ValueEnumerator GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                        System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>.GetEnumerator() => throw null;
                        public ValueEnumerable(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary) => throw null;
                        // Stub generator skipped constructor 
                    }


                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary+ValueEnumerator` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct ValueEnumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        public void Reset() => throw null;
                        public ValueEnumerator(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary, string prefix) => throw null;
                        // Stub generator skipped constructor 
                    }


                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.ValueEnumerable Values { get => throw null; }
                    System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry> System.Collections.Generic.IReadOnlyDictionary<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>.Values { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ModelStateEntry
                {
                    public string AttemptedValue { get => throw null; set => throw null; }
                    public abstract System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry> Children { get; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelErrorCollection Errors { get => throw null; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry GetModelStateForProperty(string propertyName);
                    public abstract bool IsContainerNode { get; }
                    protected ModelStateEntry() => throw null;
                    public object RawValue { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelValidationState ValidationState { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelValidationState` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum ModelValidationState
                {
                    Invalid,
                    Skipped,
                    Unvalidated,
                    Valid,
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.TooManyModelErrorsException` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TooManyModelErrorsException : System.Exception
                {
                    public TooManyModelErrorsException(string message) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderException` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ValueProviderException : System.Exception
                {
                    public ValueProviderException(string message, System.Exception innerException) => throw null;
                    public ValueProviderException(string message) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ValueProviderFactoryContext
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public ValueProviderFactoryContext(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider> ValueProviders { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct ValueProviderResult : System.IEquatable<Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult>, System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<string>
                {
                    public static bool operator !=(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult x, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult y) => throw null;
                    public static bool operator ==(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult x, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult y) => throw null;
                    public System.Globalization.CultureInfo Culture { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult other) => throw null;
                    public string FirstValue { get => throw null; }
                    public System.Collections.Generic.IEnumerator<string> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    public int Length { get => throw null; }
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult None;
                    public override string ToString() => throw null;
                    public ValueProviderResult(Microsoft.Extensions.Primitives.StringValues values, System.Globalization.CultureInfo culture) => throw null;
                    public ValueProviderResult(Microsoft.Extensions.Primitives.StringValues values) => throw null;
                    // Stub generator skipped constructor 
                    public Microsoft.Extensions.Primitives.StringValues Values { get => throw null; }
                    public static explicit operator string[](Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult result) => throw null;
                    public static explicit operator string(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult result) => throw null;
                }

                namespace Metadata
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelBindingMessageProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public abstract class ModelBindingMessageProvider
                    {
                        public virtual System.Func<string, string, string> AttemptedValueIsInvalidAccessor { get => throw null; }
                        public virtual System.Func<string, string> MissingBindRequiredValueAccessor { get => throw null; }
                        public virtual System.Func<string> MissingKeyOrValueAccessor { get => throw null; }
                        public virtual System.Func<string> MissingRequestBodyRequiredValueAccessor { get => throw null; }
                        protected ModelBindingMessageProvider() => throw null;
                        public virtual System.Func<string, string> NonPropertyAttemptedValueIsInvalidAccessor { get => throw null; }
                        public virtual System.Func<string> NonPropertyUnknownValueIsInvalidAccessor { get => throw null; }
                        public virtual System.Func<string> NonPropertyValueMustBeANumberAccessor { get => throw null; }
                        public virtual System.Func<string, string> UnknownValueIsInvalidAccessor { get => throw null; }
                        public virtual System.Func<string, string> ValueIsInvalidAccessor { get => throw null; }
                        public virtual System.Func<string, string> ValueMustBeANumberAccessor { get => throw null; }
                        public virtual System.Func<string, string> ValueMustNotBeNullAccessor { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct ModelMetadataIdentity : System.IEquatable<Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity>
                    {
                        public System.Reflection.ConstructorInfo ConstructorInfo { get => throw null; }
                        public System.Type ContainerType { get => throw null; }
                        public override bool Equals(object obj) => throw null;
                        public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity other) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForConstructor(System.Reflection.ConstructorInfo constructor, System.Type modelType) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForParameter(System.Reflection.ParameterInfo parameter, System.Type modelType) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForParameter(System.Reflection.ParameterInfo parameter) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForProperty(System.Type modelType, string name, System.Type containerType) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForProperty(System.Reflection.PropertyInfo propertyInfo, System.Type modelType, System.Type containerType) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForType(System.Type modelType) => throw null;
                        public override int GetHashCode() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataKind MetadataKind { get => throw null; }
                        // Stub generator skipped constructor 
                        public System.Type ModelType { get => throw null; }
                        public string Name { get => throw null; }
                        public System.Reflection.ParameterInfo ParameterInfo { get => throw null; }
                        public System.Reflection.PropertyInfo PropertyInfo { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataKind` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public enum ModelMetadataKind
                    {
                        Constructor,
                        Parameter,
                        Property,
                        Type,
                    }

                }
                namespace Validation
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ClientModelValidationContext : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase
                    {
                        public System.Collections.Generic.IDictionary<string, string> Attributes { get => throw null; }
                        public ClientModelValidationContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, System.Collections.Generic.IDictionary<string, string> attributes) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata), default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider)) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorItem` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ClientValidatorItem
                    {
                        public ClientValidatorItem(object validatorMetadata) => throw null;
                        public ClientValidatorItem() => throw null;
                        public bool IsReusable { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator Validator { get => throw null; set => throw null; }
                        public object ValidatorMetadata { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorProviderContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ClientValidatorProviderContext
                    {
                        public ClientValidatorProviderContext(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorItem> items) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; }
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorItem> Results { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> ValidatorMetadata { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IClientModelValidator
                    {
                        void AddValidation(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IClientModelValidatorProvider
                    {
                        void CreateValidators(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorProviderContext context);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidator` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IModelValidator
                    {
                        System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationResult> Validate(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContext context);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IModelValidatorProvider
                    {
                        void CreateValidators(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidatorProviderContext context);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IPropertyValidationFilter` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IPropertyValidationFilter
                    {
                        bool ShouldValidateEntry(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry entry, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry parentEntry);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IValidationStrategy
                    {
                        System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry> GetChildren(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ModelValidationContext : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase
                    {
                        public object Container { get => throw null; }
                        public object Model { get => throw null; }
                        public ModelValidationContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, object container, object model) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata), default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider)) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ModelValidationContextBase
                    {
                        public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; }
                        public ModelValidationContextBase(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationResult` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ModelValidationResult
                    {
                        public string MemberName { get => throw null; }
                        public string Message { get => throw null; }
                        public ModelValidationResult(string memberName, string message) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidatorProviderContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ModelValidatorProviderContext
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; set => throw null; }
                        public ModelValidatorProviderContext(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorItem> items) => throw null;
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorItem> Results { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> ValidatorMetadata { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct ValidationEntry
                    {
                        public string Key { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; }
                        public object Model { get => throw null; }
                        public ValidationEntry(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model) => throw null;
                        public ValidationEntry(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, System.Func<object> modelAccessor) => throw null;
                        // Stub generator skipped constructor 
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ValidationStateDictionary : System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>>, System.Collections.Generic.IDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>>
                    {
                        public void Add(object key, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry value) => throw null;
                        public void Add(System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> item) => throw null;
                        public void Clear() => throw null;
                        public bool Contains(System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> item) => throw null;
                        public bool ContainsKey(object key) => throw null;
                        public void CopyTo(System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>[] array, int arrayIndex) => throw null;
                        public int Count { get => throw null; }
                        public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>> GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                        public bool IsReadOnly { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry this[object key] { get => throw null; set => throw null; }
                        Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry System.Collections.Generic.IReadOnlyDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>.this[object key] { get => throw null; }
                        Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry System.Collections.Generic.IDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>.this[object key] { get => throw null; set => throw null; }
                        public System.Collections.Generic.ICollection<object> Keys { get => throw null; }
                        System.Collections.Generic.IEnumerable<object> System.Collections.Generic.IReadOnlyDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>.Keys { get => throw null; }
                        public bool Remove(object key) => throw null;
                        public bool Remove(System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> item) => throw null;
                        public bool TryGetValue(object key, out Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry value) => throw null;
                        public ValidationStateDictionary() => throw null;
                        public System.Collections.Generic.ICollection<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> Values { get => throw null; }
                        System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> System.Collections.Generic.IReadOnlyDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>.Values { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ValidationStateEntry
                    {
                        public string Key { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy Strategy { get => throw null; set => throw null; }
                        public bool SuppressValidation { get => throw null; set => throw null; }
                        public ValidationStateEntry() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorItem` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ValidatorItem
                    {
                        public bool IsReusable { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidator Validator { get => throw null; set => throw null; }
                        public ValidatorItem(object validatorMetadata) => throw null;
                        public ValidatorItem() => throw null;
                        public object ValidatorMetadata { get => throw null; }
                    }

                }
            }
            namespace Routing
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Routing.AttributeRouteInfo` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AttributeRouteInfo
                {
                    public AttributeRouteInfo() => throw null;
                    public string Name { get => throw null; set => throw null; }
                    public int Order { get => throw null; set => throw null; }
                    public bool SuppressLinkGeneration { get => throw null; set => throw null; }
                    public bool SuppressPathMatching { get => throw null; set => throw null; }
                    public string Template { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.UrlActionContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UrlActionContext
                {
                    public string Action { get => throw null; set => throw null; }
                    public string Controller { get => throw null; set => throw null; }
                    public string Fragment { get => throw null; set => throw null; }
                    public string Host { get => throw null; set => throw null; }
                    public string Protocol { get => throw null; set => throw null; }
                    public UrlActionContext() => throw null;
                    public object Values { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.UrlRouteContext` in `Microsoft.AspNetCore.Mvc.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UrlRouteContext
                {
                    public string Fragment { get => throw null; set => throw null; }
                    public string Host { get => throw null; set => throw null; }
                    public string Protocol { get => throw null; set => throw null; }
                    public string RouteName { get => throw null; set => throw null; }
                    public UrlRouteContext() => throw null;
                    public object Values { get => throw null; set => throw null; }
                }

            }
        }
    }
}
