// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Mvc.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace Abstractions
            {
                public class ActionDescriptor
                {
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata> ActionConstraints { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.Routing.AttributeRouteInfo AttributeRouteInfo { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor> BoundProperties { get => throw null; set { } }
                    public ActionDescriptor() => throw null;
                    public virtual string DisplayName { get => throw null; set { } }
                    public System.Collections.Generic.IList<object> EndpointMetadata { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.FilterDescriptor> FilterDescriptors { get => throw null; set { } }
                    public string Id { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor> Parameters { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; set { } }
                }
                public static partial class ActionDescriptorExtensions
                {
                    public static T GetProperty<T>(this Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor) => throw null;
                    public static void SetProperty<T>(this Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, T value) => throw null;
                }
                public class ActionDescriptorProviderContext
                {
                    public ActionDescriptorProviderContext() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> Results { get => throw null; }
                }
                public class ActionInvokerProviderContext
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public ActionInvokerProviderContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext) => throw null;
                    public Microsoft.AspNetCore.Mvc.Abstractions.IActionInvoker Result { get => throw null; set { } }
                }
                public interface IActionDescriptorProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptorProviderContext context);
                    int Order { get; }
                }
                public interface IActionInvoker
                {
                    System.Threading.Tasks.Task InvokeAsync();
                }
                public interface IActionInvokerProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.Abstractions.ActionInvokerProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.Abstractions.ActionInvokerProviderContext context);
                    int Order { get; }
                }
                public class ParameterDescriptor
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get => throw null; set { } }
                    public ParameterDescriptor() => throw null;
                    public string Name { get => throw null; set { } }
                    public System.Type ParameterType { get => throw null; set { } }
                }
            }
            namespace ActionConstraints
            {
                public class ActionConstraintContext
                {
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ActionConstraints.ActionSelectorCandidate> Candidates { get => throw null; set { } }
                    public ActionConstraintContext() => throw null;
                    public Microsoft.AspNetCore.Mvc.ActionConstraints.ActionSelectorCandidate CurrentCandidate { get => throw null; set { } }
                    public Microsoft.AspNetCore.Routing.RouteContext RouteContext { get => throw null; set { } }
                }
                public class ActionConstraintItem
                {
                    public Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint Constraint { get => throw null; set { } }
                    public ActionConstraintItem(Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata metadata) => throw null;
                    public bool IsReusable { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata Metadata { get => throw null; }
                }
                public class ActionConstraintProviderContext
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor Action { get => throw null; }
                    public ActionConstraintProviderContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor action, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintItem> items) => throw null;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintItem> Results { get => throw null; }
                }
                public struct ActionSelectorCandidate
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor Action { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint> Constraints { get => throw null; }
                    public ActionSelectorCandidate(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor action, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint> constraints) => throw null;
                }
                public interface IActionConstraint : Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata
                {
                    bool Accept(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintContext context);
                    int Order { get; }
                }
                public interface IActionConstraintFactory : Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata
                {
                    Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint CreateInstance(System.IServiceProvider services);
                    bool IsReusable { get; }
                }
                public interface IActionConstraintMetadata
                {
                }
                public interface IActionConstraintProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintProviderContext context);
                    int Order { get; }
                }
            }
            public class ActionContext
            {
                public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; set { } }
                public ActionContext() => throw null;
                public ActionContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext) => throw null;
                public ActionContext(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor) => throw null;
                public ActionContext(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; set { } }
            }
            namespace ApiExplorer
            {
                public class ApiDescription
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; set { } }
                    public ApiDescription() => throw null;
                    public string GroupName { get => throw null; set { } }
                    public string HttpMethod { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiParameterDescription> ParameterDescriptions { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public string RelativePath { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiRequestFormat> SupportedRequestFormats { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiResponseType> SupportedResponseTypes { get => throw null; }
                }
                public class ApiDescriptionProviderContext
                {
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> Actions { get => throw null; }
                    public ApiDescriptionProviderContext(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> actions) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescription> Results { get => throw null; }
                }
                public class ApiParameterDescription
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get => throw null; set { } }
                    public ApiParameterDescription() => throw null;
                    public object DefaultValue { get => throw null; set { } }
                    public bool IsRequired { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; set { } }
                    public string Name { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor ParameterDescriptor { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ApiExplorer.ApiParameterRouteInfo RouteInfo { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Source { get => throw null; set { } }
                    public System.Type Type { get => throw null; set { } }
                }
                public class ApiParameterRouteInfo
                {
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Routing.IRouteConstraint> Constraints { get => throw null; set { } }
                    public ApiParameterRouteInfo() => throw null;
                    public object DefaultValue { get => throw null; set { } }
                    public bool IsOptional { get => throw null; set { } }
                }
                public class ApiRequestFormat
                {
                    public ApiRequestFormat() => throw null;
                    public Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter Formatter { get => throw null; set { } }
                    public string MediaType { get => throw null; set { } }
                }
                public class ApiResponseFormat
                {
                    public ApiResponseFormat() => throw null;
                    public Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter Formatter { get => throw null; set { } }
                    public string MediaType { get => throw null; set { } }
                }
                public class ApiResponseType
                {
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApiExplorer.ApiResponseFormat> ApiResponseFormats { get => throw null; set { } }
                    public ApiResponseType() => throw null;
                    public bool IsDefaultResponse { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; set { } }
                    public int StatusCode { get => throw null; set { } }
                    public System.Type Type { get => throw null; set { } }
                }
                public interface IApiDescriptionProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiDescriptionProviderContext context);
                    int Order { get; }
                }
            }
            namespace Authorization
            {
                public interface IAllowAnonymousFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }
            }
            namespace Filters
            {
                public class ActionExecutedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual bool Canceled { get => throw null; set { } }
                    public virtual object Controller { get => throw null; }
                    public ActionExecutedContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, object controller) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual System.Exception Exception { get => throw null; set { } }
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set { } }
                    public virtual bool ExceptionHandled { get => throw null; set { } }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set { } }
                }
                public class ActionExecutingContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual System.Collections.Generic.IDictionary<string, object> ActionArguments { get => throw null; }
                    public virtual object Controller { get => throw null; }
                    public ActionExecutingContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, System.Collections.Generic.IDictionary<string, object> actionArguments, object controller) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set { } }
                }
                public delegate System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext> ActionExecutionDelegate();
                public class AuthorizationFilterContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public AuthorizationFilterContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set { } }
                }
                public class ExceptionContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public ExceptionContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual System.Exception Exception { get => throw null; set { } }
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set { } }
                    public virtual bool ExceptionHandled { get => throw null; set { } }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set { } }
                }
                public abstract class FilterContext : Microsoft.AspNetCore.Mvc.ActionContext
                {
                    public FilterContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters) => throw null;
                    public virtual System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    public TMetadata FindEffectivePolicy<TMetadata>() where TMetadata : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public bool IsEffectivePolicy<TMetadata>(TMetadata policy) where TMetadata : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                }
                public class FilterDescriptor
                {
                    public FilterDescriptor(Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter, int filterScope) => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public int Order { get => throw null; set { } }
                    public int Scope { get => throw null; }
                }
                public class FilterItem
                {
                    public FilterItem(Microsoft.AspNetCore.Mvc.Filters.FilterDescriptor descriptor) => throw null;
                    public FilterItem(Microsoft.AspNetCore.Mvc.Filters.FilterDescriptor descriptor, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.FilterDescriptor Descriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; set { } }
                    public bool IsReusable { get => throw null; set { } }
                }
                public class FilterProviderContext
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; set { } }
                    public FilterProviderContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.FilterItem> items) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.FilterItem> Results { get => throw null; set { } }
                }
                public interface IActionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnActionExecuted(Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext context);
                    void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context);
                }
                public interface IAlwaysRunResultFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IResultFilter
                {
                }
                public interface IAsyncActionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnActionExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ActionExecutionDelegate next);
                }
                public interface IAsyncAlwaysRunResultFilter : Microsoft.AspNetCore.Mvc.Filters.IAsyncResultFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }
                public interface IAsyncAuthorizationFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnAuthorizationAsync(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext context);
                }
                public interface IAsyncExceptionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnExceptionAsync(Microsoft.AspNetCore.Mvc.Filters.ExceptionContext context);
                }
                public interface IAsyncResourceFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnResourceExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutionDelegate next);
                }
                public interface IAsyncResultFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    System.Threading.Tasks.Task OnResultExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ResultExecutionDelegate next);
                }
                public interface IAuthorizationFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnAuthorization(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext context);
                }
                public interface IExceptionFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnException(Microsoft.AspNetCore.Mvc.Filters.ExceptionContext context);
                }
                public interface IFilterContainer
                {
                    Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata FilterDefinition { get; set; }
                }
                public interface IFilterFactory : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider);
                    bool IsReusable { get; }
                }
                public interface IFilterMetadata
                {
                }
                public interface IFilterProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.Filters.FilterProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.Filters.FilterProviderContext context);
                    int Order { get; }
                }
                public interface IOrderedFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    int Order { get; }
                }
                public interface IResourceFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnResourceExecuted(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext context);
                    void OnResourceExecuting(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext context);
                }
                public interface IResultFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context);
                    void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context);
                }
                public class ResourceExecutedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual bool Canceled { get => throw null; set { } }
                    public ResourceExecutedContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual System.Exception Exception { get => throw null; set { } }
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set { } }
                    public virtual bool ExceptionHandled { get => throw null; set { } }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set { } }
                }
                public class ResourceExecutingContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public ResourceExecutingContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> valueProviderFactories) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> ValueProviderFactories { get => throw null; }
                }
                public delegate System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext> ResourceExecutionDelegate();
                public class ResultExecutedContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual bool Canceled { get => throw null; set { } }
                    public virtual object Controller { get => throw null; }
                    public ResultExecutedContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, Microsoft.AspNetCore.Mvc.IActionResult result, object controller) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual System.Exception Exception { get => throw null; set { } }
                    public virtual System.Runtime.ExceptionServices.ExceptionDispatchInfo ExceptionDispatchInfo { get => throw null; set { } }
                    public virtual bool ExceptionHandled { get => throw null; set { } }
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                }
                public class ResultExecutingContext : Microsoft.AspNetCore.Mvc.Filters.FilterContext
                {
                    public virtual bool Cancel { get => throw null; set { } }
                    public virtual object Controller { get => throw null; }
                    public ResultExecutingContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> filters, Microsoft.AspNetCore.Mvc.IActionResult result, object controller) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>)) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; set { } }
                }
                public delegate System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext> ResultExecutionDelegate();
            }
            namespace Formatters
            {
                public class FormatterCollection<TFormatter> : System.Collections.ObjectModel.Collection<TFormatter>
                {
                    public FormatterCollection() => throw null;
                    public FormatterCollection(System.Collections.Generic.IList<TFormatter> list) => throw null;
                    public void RemoveType<T>() where T : TFormatter => throw null;
                    public void RemoveType(System.Type formatterType) => throw null;
                }
                public interface IInputFormatter
                {
                    bool CanRead(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context);
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context);
                }
                public interface IInputFormatterExceptionPolicy
                {
                    Microsoft.AspNetCore.Mvc.Formatters.InputFormatterExceptionPolicy ExceptionPolicy { get; }
                }
                public class InputFormatterContext
                {
                    public InputFormatterContext(Microsoft.AspNetCore.Http.HttpContext httpContext, string modelName, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextReader> readerFactory) => throw null;
                    public InputFormatterContext(Microsoft.AspNetCore.Http.HttpContext httpContext, string modelName, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextReader> readerFactory, bool treatEmptyInputAsDefaultValue) => throw null;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; }
                    public string ModelName { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                    public System.Type ModelType { get => throw null; }
                    public System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextReader> ReaderFactory { get => throw null; }
                    public bool TreatEmptyInputAsDefaultValue { get => throw null; }
                }
                public class InputFormatterException : System.Exception
                {
                    public InputFormatterException() => throw null;
                    public InputFormatterException(string message) => throw null;
                    public InputFormatterException(string message, System.Exception innerException) => throw null;
                }
                public enum InputFormatterExceptionPolicy
                {
                    AllExceptions = 0,
                    MalformedInputExceptions = 1,
                }
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
                public interface IOutputFormatter
                {
                    bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context);
                    System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context);
                }
                public abstract class OutputFormatterCanWriteContext
                {
                    public virtual Microsoft.Extensions.Primitives.StringSegment ContentType { get => throw null; set { } }
                    public virtual bool ContentTypeIsServerDefined { get => throw null; set { } }
                    protected OutputFormatterCanWriteContext(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    public virtual Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set { } }
                    public virtual object Object { get => throw null; set { } }
                    public virtual System.Type ObjectType { get => throw null; set { } }
                }
                public class OutputFormatterWriteContext : Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext
                {
                    public OutputFormatterWriteContext(Microsoft.AspNetCore.Http.HttpContext httpContext, System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextWriter> writerFactory, System.Type objectType, object @object) : base(default(Microsoft.AspNetCore.Http.HttpContext)) => throw null;
                    public virtual System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextWriter> WriterFactory { get => throw null; set { } }
                }
            }
            public interface IActionResult
            {
                System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context);
            }
            public interface IUrlHelper
            {
                string Action(Microsoft.AspNetCore.Mvc.Routing.UrlActionContext actionContext);
                Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get; }
                string Content(string contentPath);
                bool IsLocalUrl(string url);
                string Link(string routeName, object values);
                string RouteUrl(Microsoft.AspNetCore.Mvc.Routing.UrlRouteContext routeContext);
            }
            namespace ModelBinding
            {
                public class BindingInfo
                {
                    public string BinderModelName { get => throw null; set { } }
                    public System.Type BinderType { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set { } }
                    public BindingInfo() => throw null;
                    public BindingInfo(Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo other) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.EmptyBodyBehavior EmptyBodyBehavior { get => throw null; set { } }
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo GetBindingInfo(System.Collections.Generic.IEnumerable<object> attributes) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo GetBindingInfo(System.Collections.Generic.IEnumerable<object> attributes, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider PropertyFilterProvider { get => throw null; set { } }
                    public System.Func<Microsoft.AspNetCore.Mvc.ActionContext, bool> RequestPredicate { get => throw null; set { } }
                    public object ServiceKey { get => throw null; set { } }
                    public bool TryApplyBindingInfo(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata) => throw null;
                }
                public class BindingSource : System.IEquatable<Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource>
                {
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Body;
                    public virtual bool CanAcceptDataFrom(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public BindingSource(string id, string displayName, bool isGreedy, bool isFromRequest) => throw null;
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Custom;
                    public string DisplayName { get => throw null; }
                    public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource other) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Form;
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource FormFile;
                    public override int GetHashCode() => throw null;
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Header;
                    public string Id { get => throw null; }
                    public bool IsFromRequest { get => throw null; }
                    public bool IsGreedy { get => throw null; }
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource ModelBinding;
                    public static bool operator ==(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource s1, Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource s2) => throw null;
                    public static bool operator !=(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource s1, Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource s2) => throw null;
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Path;
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Query;
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Services;
                    public static readonly Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource Special;
                }
                public class CompositeBindingSource : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource
                {
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource> BindingSources { get => throw null; }
                    public override bool CanAcceptDataFrom(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.CompositeBindingSource Create(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource> bindingSources, string displayName) => throw null;
                    internal CompositeBindingSource() : base(default(string), default(string), default(bool), default(bool)) { }
                }
                public enum EmptyBodyBehavior
                {
                    Default = 0,
                    Allow = 1,
                    Disallow = 2,
                }
                public struct EnumGroupAndName
                {
                    public EnumGroupAndName(string group, string name) => throw null;
                    public EnumGroupAndName(string group, System.Func<string> name) => throw null;
                    public string Group { get => throw null; }
                    public string Name { get => throw null; }
                }
                public interface IBinderTypeProviderMetadata : Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
                {
                    System.Type BinderType { get; }
                }
                public interface IBindingSourceMetadata
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get; }
                }
                public interface IModelBinder
                {
                    System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext);
                }
                public interface IModelBinderProvider
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context);
                }
                public interface IModelMetadataProvider
                {
                    System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> GetMetadataForProperties(System.Type modelType);
                    Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForType(System.Type modelType);
                }
                public interface IModelNameProvider
                {
                    string Name { get; }
                }
                public interface IPropertyFilterProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get; }
                }
                public interface IRequestPredicateProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.ActionContext, bool> RequestPredicate { get; }
                }
                public interface IValueProvider
                {
                    bool ContainsPrefix(string prefix);
                    Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key);
                }
                public interface IValueProviderFactory
                {
                    System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context);
                }
                namespace Metadata
                {
                    public abstract class ModelBindingMessageProvider
                    {
                        public virtual System.Func<string, string, string> AttemptedValueIsInvalidAccessor { get => throw null; }
                        protected ModelBindingMessageProvider() => throw null;
                        public virtual System.Func<string, string> MissingBindRequiredValueAccessor { get => throw null; }
                        public virtual System.Func<string> MissingKeyOrValueAccessor { get => throw null; }
                        public virtual System.Func<string> MissingRequestBodyRequiredValueAccessor { get => throw null; }
                        public virtual System.Func<string, string> NonPropertyAttemptedValueIsInvalidAccessor { get => throw null; }
                        public virtual System.Func<string> NonPropertyUnknownValueIsInvalidAccessor { get => throw null; }
                        public virtual System.Func<string> NonPropertyValueMustBeANumberAccessor { get => throw null; }
                        public virtual System.Func<string, string> UnknownValueIsInvalidAccessor { get => throw null; }
                        public virtual System.Func<string, string> ValueIsInvalidAccessor { get => throw null; }
                        public virtual System.Func<string, string> ValueMustBeANumberAccessor { get => throw null; }
                        public virtual System.Func<string, string> ValueMustNotBeNullAccessor { get => throw null; }
                    }
                    public struct ModelMetadataIdentity : System.IEquatable<Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity>
                    {
                        public System.Reflection.ConstructorInfo ConstructorInfo { get => throw null; }
                        public System.Type ContainerType { get => throw null; }
                        public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity other) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForConstructor(System.Reflection.ConstructorInfo constructor, System.Type modelType) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForParameter(System.Reflection.ParameterInfo parameter) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForParameter(System.Reflection.ParameterInfo parameter, System.Type modelType) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForProperty(System.Type modelType, string name, System.Type containerType) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForProperty(System.Reflection.PropertyInfo propertyInfo, System.Type modelType, System.Type containerType) => throw null;
                        public static Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity ForType(System.Type modelType) => throw null;
                        public override int GetHashCode() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataKind MetadataKind { get => throw null; }
                        public System.Type ModelType { get => throw null; }
                        public string Name { get => throw null; }
                        public System.Reflection.ParameterInfo ParameterInfo { get => throw null; }
                        public System.Reflection.PropertyInfo PropertyInfo { get => throw null; }
                    }
                    public enum ModelMetadataKind
                    {
                        Type = 0,
                        Property = 1,
                        Parameter = 2,
                        Constructor = 3,
                    }
                }
                public abstract class ModelBinderProviderContext
                {
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder CreateBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata);
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder CreateBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo bindingInfo) => throw null;
                    protected ModelBinderProviderContext() => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get; }
                    public virtual System.IServiceProvider Services { get => throw null; }
                }
                public abstract class ModelBindingContext
                {
                    public abstract Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get; set; }
                    public abstract string BinderModelName { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get; set; }
                    protected ModelBindingContext() => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext.NestedScope EnterNestedScope(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, string fieldName, string modelName, object model);
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext.NestedScope EnterNestedScope();
                    protected abstract void ExitNestedScope();
                    public abstract string FieldName { get; set; }
                    public virtual Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public abstract bool IsTopLevelObject { get; set; }
                    public abstract object Model { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get; set; }
                    public abstract string ModelName { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get; set; }
                    public virtual System.Type ModelType { get => throw null; }
                    public struct NestedScope : System.IDisposable
                    {
                        public NestedScope(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext context) => throw null;
                        public void Dispose() => throw null;
                    }
                    public string OriginalModelName { get => throw null; set { } }
                    public abstract System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult Result { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary ValidationState { get; set; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider ValueProvider { get; set; }
                }
                public struct ModelBindingResult : System.IEquatable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult>
                {
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult other) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult Failed() => throw null;
                    public override int GetHashCode() => throw null;
                    public bool IsModelSet { get => throw null; }
                    public object Model { get => throw null; }
                    public static bool operator ==(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult x, Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult y) => throw null;
                    public static bool operator !=(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult x, Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult y) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult Success(object model) => throw null;
                    public override string ToString() => throw null;
                }
                public class ModelError
                {
                    public ModelError(System.Exception exception) => throw null;
                    public ModelError(System.Exception exception, string errorMessage) => throw null;
                    public ModelError(string errorMessage) => throw null;
                    public string ErrorMessage { get => throw null; }
                    public System.Exception Exception { get => throw null; }
                }
                public class ModelErrorCollection : System.Collections.ObjectModel.Collection<Microsoft.AspNetCore.Mvc.ModelBinding.ModelError>
                {
                    public void Add(System.Exception exception) => throw null;
                    public void Add(string errorMessage) => throw null;
                    public ModelErrorCollection() => throw null;
                }
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
                    protected ModelMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity identity) => throw null;
                    public abstract string DataTypeName { get; }
                    public static readonly int DefaultOrder;
                    public abstract string Description { get; }
                    public abstract string DisplayFormatString { get; }
                    public abstract string DisplayName { get; }
                    public abstract string EditFormatString { get; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ElementMetadata { get; }
                    public System.Type ElementType { get => throw null; }
                    public abstract System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<Microsoft.AspNetCore.Mvc.ModelBinding.EnumGroupAndName, string>> EnumGroupedDisplayNamesAndValues { get; }
                    public abstract System.Collections.Generic.IReadOnlyDictionary<string, string> EnumNamesAndValues { get; }
                    public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata other) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public string GetDisplayName() => throw null;
                    public override int GetHashCode() => throw null;
                    public virtual System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> GetMetadataForProperties(System.Type modelType) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForType(System.Type modelType) => throw null;
                    public abstract bool HasNonDefaultEditFormat { get; }
                    public virtual bool? HasValidators { get => throw null; }
                    public abstract bool HideSurroundingHtml { get; }
                    public abstract bool HtmlEncode { get; }
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity Identity { get => throw null; }
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
                public abstract class ModelMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider
                {
                    protected ModelMetadataProvider() => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForConstructor(System.Reflection.ConstructorInfo constructor, System.Type modelType) => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForParameter(System.Reflection.ParameterInfo parameter);
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForParameter(System.Reflection.ParameterInfo parameter, System.Type modelType) => throw null;
                    public abstract System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> GetMetadataForProperties(System.Type modelType);
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForProperty(System.Reflection.PropertyInfo propertyInfo, System.Type modelType) => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForType(System.Type modelType);
                }
                public class ModelPropertyCollection : System.Collections.ObjectModel.ReadOnlyCollection<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata>
                {
                    public ModelPropertyCollection(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> properties) : base(default(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata>)) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata this[string propertyName] { get => throw null; }
                }
                public class ModelStateDictionary : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>, System.Collections.Generic.IReadOnlyDictionary<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>
                {
                    public void AddModelError(string key, System.Exception exception, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata) => throw null;
                    public void AddModelError(string key, string errorMessage) => throw null;
                    public void Clear() => throw null;
                    public void ClearValidationState(string key) => throw null;
                    public bool ContainsKey(string key) => throw null;
                    public int Count { get => throw null; }
                    public ModelStateDictionary() => throw null;
                    public ModelStateDictionary(int maxAllowedErrors) => throw null;
                    public ModelStateDictionary(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary) => throw null;
                    public static readonly int DefaultMaxAllowedErrors;
                    public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>, System.Collections.IEnumerator
                    {
                        public Enumerator(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary, string prefix) => throw null;
                        public System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry> Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        public void Reset() => throw null;
                    }
                    public int ErrorCount { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.PrefixEnumerable FindKeysWithPrefix(string prefix) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.Enumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelValidationState GetFieldValidationState(string key) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelValidationState GetValidationState(string key) => throw null;
                    public bool HasReachedMaxErrors { get => throw null; }
                    public bool IsValid { get => throw null; }
                    public struct KeyEnumerable : System.Collections.Generic.IEnumerable<string>, System.Collections.IEnumerable
                    {
                        public KeyEnumerable(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.KeyEnumerator GetEnumerator() => throw null;
                        System.Collections.Generic.IEnumerator<string> System.Collections.Generic.IEnumerable<string>.GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    }
                    public struct KeyEnumerator : System.IDisposable, System.Collections.Generic.IEnumerator<string>, System.Collections.IEnumerator
                    {
                        public KeyEnumerator(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary, string prefix) => throw null;
                        public string Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        public void Reset() => throw null;
                    }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.KeyEnumerable Keys { get => throw null; }
                    System.Collections.Generic.IEnumerable<string> System.Collections.Generic.IReadOnlyDictionary<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>.Keys { get => throw null; }
                    public void MarkFieldSkipped(string key) => throw null;
                    public void MarkFieldValid(string key) => throw null;
                    public int MaxAllowedErrors { get => throw null; set { } }
                    public void Merge(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary) => throw null;
                    public struct PrefixEnumerable : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>, System.Collections.IEnumerable
                    {
                        public PrefixEnumerable(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary, string prefix) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.Enumerator GetEnumerator() => throw null;
                        System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>>.GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    }
                    public bool Remove(string key) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry Root { get => throw null; }
                    public void SetModelValue(string key, object rawValue, string attemptedValue) => throw null;
                    public void SetModelValue(string key, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult valueProviderResult) => throw null;
                    public static bool StartsWithPrefix(string prefix, string key) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry this[string key] { get => throw null; }
                    public bool TryAddModelError(string key, System.Exception exception, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata) => throw null;
                    public bool TryAddModelError(string key, string errorMessage) => throw null;
                    public bool TryAddModelException(string key, System.Exception exception) => throw null;
                    public bool TryGetValue(string key, out Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry value) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelValidationState ValidationState { get => throw null; }
                    public struct ValueEnumerable : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>, System.Collections.IEnumerable
                    {
                        public ValueEnumerable(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.ValueEnumerator GetEnumerator() => throw null;
                        System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>.GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    }
                    public struct ValueEnumerator : System.IDisposable, System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>, System.Collections.IEnumerator
                    {
                        public ValueEnumerator(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary dictionary, string prefix) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        public void Reset() => throw null;
                    }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary.ValueEnumerable Values { get => throw null; }
                    System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry> System.Collections.Generic.IReadOnlyDictionary<string, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry>.Values { get => throw null; }
                }
                public abstract class ModelStateEntry
                {
                    public string AttemptedValue { get => throw null; set { } }
                    public abstract System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry> Children { get; }
                    protected ModelStateEntry() => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelErrorCollection Errors { get => throw null; }
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateEntry GetModelStateForProperty(string propertyName);
                    public abstract bool IsContainerNode { get; }
                    public object RawValue { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelValidationState ValidationState { get => throw null; set { } }
                }
                public enum ModelValidationState
                {
                    Unvalidated = 0,
                    Invalid = 1,
                    Valid = 2,
                    Skipped = 3,
                }
                public class TooManyModelErrorsException : System.Exception
                {
                    public TooManyModelErrorsException(string message) => throw null;
                }
                namespace Validation
                {
                    public class ClientModelValidationContext : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase
                    {
                        public System.Collections.Generic.IDictionary<string, string> Attributes { get => throw null; }
                        public ClientModelValidationContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, System.Collections.Generic.IDictionary<string, string> attributes) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata), default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider)) => throw null;
                    }
                    public class ClientValidatorItem
                    {
                        public ClientValidatorItem() => throw null;
                        public ClientValidatorItem(object validatorMetadata) => throw null;
                        public bool IsReusable { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator Validator { get => throw null; set { } }
                        public object ValidatorMetadata { get => throw null; }
                    }
                    public class ClientValidatorProviderContext
                    {
                        public ClientValidatorProviderContext(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorItem> items) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; }
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorItem> Results { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> ValidatorMetadata { get => throw null; }
                    }
                    public interface IClientModelValidator
                    {
                        void AddValidation(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context);
                    }
                    public interface IClientModelValidatorProvider
                    {
                        void CreateValidators(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorProviderContext context);
                    }
                    public interface IModelValidator
                    {
                        System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationResult> Validate(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContext context);
                    }
                    public interface IModelValidatorProvider
                    {
                        void CreateValidators(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidatorProviderContext context);
                    }
                    public interface IPropertyValidationFilter
                    {
                        bool ShouldValidateEntry(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry entry, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry parentEntry);
                    }
                    public interface IValidationStrategy
                    {
                        System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry> GetChildren(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model);
                    }
                    public class ModelValidationContext : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidationContextBase
                    {
                        public object Container { get => throw null; }
                        public ModelValidationContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, object container, object model) : base(default(Microsoft.AspNetCore.Mvc.ActionContext), default(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata), default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider)) => throw null;
                        public object Model { get => throw null; }
                    }
                    public class ModelValidationContextBase
                    {
                        public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                        public ModelValidationContextBase(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; }
                    }
                    public class ModelValidationResult
                    {
                        public ModelValidationResult(string memberName, string message) => throw null;
                        public string MemberName { get => throw null; }
                        public string Message { get => throw null; }
                    }
                    public class ModelValidatorProviderContext
                    {
                        public ModelValidatorProviderContext(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorItem> items) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; set { } }
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorItem> Results { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> ValidatorMetadata { get => throw null; }
                    }
                    public struct ValidationEntry
                    {
                        public ValidationEntry(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model) => throw null;
                        public ValidationEntry(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, System.Func<object> modelAccessor) => throw null;
                        public string Key { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; }
                        public object Model { get => throw null; }
                    }
                    public class ValidationStateDictionary : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>>, System.Collections.Generic.IDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>>, System.Collections.Generic.IReadOnlyDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>
                    {
                        public void Add(System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> item) => throw null;
                        public void Add(object key, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry value) => throw null;
                        public void Clear() => throw null;
                        public bool Contains(System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> item) => throw null;
                        public bool ContainsKey(object key) => throw null;
                        public void CopyTo(System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>[] array, int arrayIndex) => throw null;
                        public int Count { get => throw null; }
                        public ValidationStateDictionary() => throw null;
                        public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>> GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                        public bool IsReadOnly { get => throw null; }
                        Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry System.Collections.Generic.IDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>.this[object key] { get => throw null; set { } }
                        Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry System.Collections.Generic.IReadOnlyDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>.this[object key] { get => throw null; }
                        public System.Collections.Generic.ICollection<object> Keys { get => throw null; }
                        System.Collections.Generic.IEnumerable<object> System.Collections.Generic.IReadOnlyDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>.Keys { get => throw null; }
                        public bool Remove(System.Collections.Generic.KeyValuePair<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> item) => throw null;
                        public bool Remove(object key) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry this[object key] { get => throw null; set { } }
                        public bool TryGetValue(object key, out Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry value) => throw null;
                        public System.Collections.Generic.ICollection<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> Values { get => throw null; }
                        System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry> System.Collections.Generic.IReadOnlyDictionary<object, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry>.Values { get => throw null; }
                    }
                    public class ValidationStateEntry
                    {
                        public ValidationStateEntry() => throw null;
                        public string Key { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy Strategy { get => throw null; set { } }
                        public bool SuppressValidation { get => throw null; set { } }
                    }
                    public class ValidatorItem
                    {
                        public ValidatorItem() => throw null;
                        public ValidatorItem(object validatorMetadata) => throw null;
                        public bool IsReusable { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidator Validator { get => throw null; set { } }
                        public object ValidatorMetadata { get => throw null; }
                    }
                }
                public sealed class ValueProviderException : System.Exception
                {
                    public ValueProviderException(string message) => throw null;
                    public ValueProviderException(string message, System.Exception innerException) => throw null;
                }
                public class ValueProviderFactoryContext
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public ValueProviderFactoryContext(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider> ValueProviders { get => throw null; }
                }
                public struct ValueProviderResult : System.Collections.Generic.IEnumerable<string>, System.Collections.IEnumerable, System.IEquatable<Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult>
                {
                    public ValueProviderResult(Microsoft.Extensions.Primitives.StringValues values) => throw null;
                    public ValueProviderResult(Microsoft.Extensions.Primitives.StringValues values, System.Globalization.CultureInfo culture) => throw null;
                    public System.Globalization.CultureInfo Culture { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult other) => throw null;
                    public string FirstValue { get => throw null; }
                    public System.Collections.Generic.IEnumerator<string> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    public int Length { get => throw null; }
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult None;
                    public static bool operator ==(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult x, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult y) => throw null;
                    public static explicit operator string(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult result) => throw null;
                    public static explicit operator string[](Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult result) => throw null;
                    public static bool operator !=(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult x, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult y) => throw null;
                    public override string ToString() => throw null;
                    public Microsoft.Extensions.Primitives.StringValues Values { get => throw null; }
                }
            }
            namespace Routing
            {
                public class AttributeRouteInfo
                {
                    public AttributeRouteInfo() => throw null;
                    public string Name { get => throw null; set { } }
                    public int Order { get => throw null; set { } }
                    public bool SuppressLinkGeneration { get => throw null; set { } }
                    public bool SuppressPathMatching { get => throw null; set { } }
                    public string Template { get => throw null; set { } }
                }
                public class UrlActionContext
                {
                    public string Action { get => throw null; set { } }
                    public string Controller { get => throw null; set { } }
                    public UrlActionContext() => throw null;
                    public string Fragment { get => throw null; set { } }
                    public string Host { get => throw null; set { } }
                    public string Protocol { get => throw null; set { } }
                    public object Values { get => throw null; set { } }
                }
                public class UrlRouteContext
                {
                    public UrlRouteContext() => throw null;
                    public string Fragment { get => throw null; set { } }
                    public string Host { get => throw null; set { } }
                    public string Protocol { get => throw null; set { } }
                    public string RouteName { get => throw null; set { } }
                    public object Values { get => throw null; set { } }
                }
            }
        }
    }
}
