// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Mvc.Core, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public sealed class ControllerActionEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
                public void Finally(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> finalConvention) => throw null;
            }
            public static partial class ControllerEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.ControllerActionEndpointConventionBuilder MapAreaControllerRoute(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string name, string areaName, string pattern, object defaults = default(object), object constraints = default(object), object dataTokens = default(object)) => throw null;
                public static Microsoft.AspNetCore.Builder.ControllerActionEndpointConventionBuilder MapControllerRoute(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string name, string pattern, object defaults = default(object), object constraints = default(object), object dataTokens = default(object)) => throw null;
                public static Microsoft.AspNetCore.Builder.ControllerActionEndpointConventionBuilder MapControllers(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints) => throw null;
                public static Microsoft.AspNetCore.Builder.ControllerActionEndpointConventionBuilder MapDefaultControllerRoute(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints) => throw null;
                public static void MapDynamicControllerRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static void MapDynamicControllerRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, object state) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static void MapDynamicControllerRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, object state, int order) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToAreaController(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string action, string controller, string area) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToAreaController(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string action, string controller, string area) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToController(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string action, string controller) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToController(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string action, string controller) => throw null;
            }
            public static partial class MvcApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMvc(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMvc(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Action<Microsoft.AspNetCore.Routing.IRouteBuilder> configureRoutes) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMvcWithDefaultRoute(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }
            public static partial class MvcAreaRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapAreaRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string areaName, string template) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapAreaRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string areaName, string template, object defaults) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapAreaRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string areaName, string template, object defaults, object constraints) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapAreaRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string areaName, string template, object defaults, object constraints, object dataTokens) => throw null;
            }
        }
        namespace Mvc
        {
            public class AcceptedAtActionResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public string ActionName { get => throw null; set { } }
                public string ControllerName { get => throw null; set { } }
                public AcceptedAtActionResult(string actionName, string controllerName, object routeValues, object value) : base(default(object)) => throw null;
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set { } }
            }
            public class AcceptedAtRouteResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public AcceptedAtRouteResult(object routeValues, object value) : base(default(object)) => throw null;
                public AcceptedAtRouteResult(string routeName, object routeValues, object value) : base(default(object)) => throw null;
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string RouteName { get => throw null; set { } }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set { } }
            }
            public class AcceptedResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public AcceptedResult() : base(default(object)) => throw null;
                public AcceptedResult(string location, object value) : base(default(object)) => throw null;
                public AcceptedResult(System.Uri locationUri, object value) : base(default(object)) => throw null;
                public string Location { get => throw null; set { } }
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = true, Inherited = true)]
            public sealed class AcceptVerbsAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IActionHttpMethodProvider, Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider
            {
                public AcceptVerbsAttribute(string method) => throw null;
                public AcceptVerbsAttribute(params string[] methods) => throw null;
                public System.Collections.Generic.IEnumerable<string> HttpMethods { get => throw null; }
                public string Name { get => throw null; set { } }
                public int Order { get => throw null; set { } }
                int? Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider.Order { get => throw null; }
                public string Route { get => throw null; set { } }
                string Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider.Template { get => throw null; }
            }
            namespace ActionConstraints
            {
                [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = true)]
                public abstract class ActionMethodSelectorAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata
                {
                    public bool Accept(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintContext context) => throw null;
                    protected ActionMethodSelectorAttribute() => throw null;
                    public abstract bool IsValidForRequest(Microsoft.AspNetCore.Routing.RouteContext routeContext, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor action);
                    public int Order { get => throw null; set { } }
                }
                public class HttpMethodActionConstraint : Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata
                {
                    public virtual bool Accept(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintContext context) => throw null;
                    public HttpMethodActionConstraint(System.Collections.Generic.IEnumerable<string> httpMethods) => throw null;
                    public static readonly int HttpMethodConstraintOrder;
                    public System.Collections.Generic.IEnumerable<string> HttpMethods { get => throw null; }
                    public int Order { get => throw null; }
                }
            }
            [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
            public class ActionContextAttribute : System.Attribute
            {
                public ActionContextAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = true)]
            public sealed class ActionNameAttribute : System.Attribute
            {
                public ActionNameAttribute(string name) => throw null;
                public string Name { get => throw null; }
            }
            public abstract class ActionResult : Microsoft.AspNetCore.Mvc.IActionResult
            {
                protected ActionResult() => throw null;
                public virtual void ExecuteResult(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public virtual System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
            }
            public sealed class ActionResult<TValue> : Microsoft.AspNetCore.Mvc.Infrastructure.IConvertToActionResult
            {
                Microsoft.AspNetCore.Mvc.IActionResult Microsoft.AspNetCore.Mvc.Infrastructure.IConvertToActionResult.Convert() => throw null;
                public ActionResult(TValue value) => throw null;
                public ActionResult(Microsoft.AspNetCore.Mvc.ActionResult result) => throw null;
                public static implicit operator Microsoft.AspNetCore.Mvc.ActionResult<TValue>(TValue value) => throw null;
                public static implicit operator Microsoft.AspNetCore.Mvc.ActionResult<TValue>(Microsoft.AspNetCore.Mvc.ActionResult result) => throw null;
                public Microsoft.AspNetCore.Mvc.ActionResult Result { get => throw null; }
                public TValue Value { get => throw null; }
            }
            public class AntiforgeryValidationFailedResult : Microsoft.AspNetCore.Mvc.BadRequestResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Core.Infrastructure.IAntiforgeryValidationFailedResult
            {
                public AntiforgeryValidationFailedResult() => throw null;
            }
            public class ApiBehaviorOptions : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>, System.Collections.IEnumerable
            {
                public System.Collections.Generic.IDictionary<int, Microsoft.AspNetCore.Mvc.ClientErrorData> ClientErrorMapping { get => throw null; }
                public ApiBehaviorOptions() => throw null;
                public bool DisableImplicitFromServicesParameters { get => throw null; set { } }
                System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public System.Func<Microsoft.AspNetCore.Mvc.ActionContext, Microsoft.AspNetCore.Mvc.IActionResult> InvalidModelStateResponseFactory { get => throw null; set { } }
                public bool SuppressConsumesConstraintForFormFileParameters { get => throw null; set { } }
                public bool SuppressInferBindingSourcesForParameters { get => throw null; set { } }
                public bool SuppressMapClientErrors { get => throw null; set { } }
                public bool SuppressModelStateInvalidFilter { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)5, AllowMultiple = false, Inherited = true)]
            public class ApiControllerAttribute : Microsoft.AspNetCore.Mvc.ControllerAttribute, Microsoft.AspNetCore.Mvc.Infrastructure.IApiBehaviorMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
                public ApiControllerAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = true)]
            public sealed class ApiConventionMethodAttribute : System.Attribute
            {
                public System.Type ConventionType { get => throw null; }
                public ApiConventionMethodAttribute(System.Type conventionType, string methodName) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)5, AllowMultiple = true, Inherited = true)]
            public sealed class ApiConventionTypeAttribute : System.Attribute
            {
                public System.Type ConventionType { get => throw null; }
                public ApiConventionTypeAttribute(System.Type conventionType) => throw null;
            }
            public class ApiDescriptionActionData
            {
                public ApiDescriptionActionData() => throw null;
                public string GroupName { get => throw null; set { } }
            }
            namespace ApiExplorer
            {
                [System.AttributeUsage((System.AttributeTargets)2112, AllowMultiple = false, Inherited = false)]
                public sealed class ApiConventionNameMatchAttribute : System.Attribute
                {
                    public ApiConventionNameMatchAttribute(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionNameMatchBehavior matchBehavior) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionNameMatchBehavior MatchBehavior { get => throw null; }
                }
                public enum ApiConventionNameMatchBehavior
                {
                    Any = 0,
                    Exact = 1,
                    Prefix = 2,
                    Suffix = 3,
                }
                public sealed class ApiConventionResult
                {
                    public ApiConventionResult(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider> responseMetadataProviders) => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider> ResponseMetadataProviders { get => throw null; }
                }
                [System.AttributeUsage((System.AttributeTargets)2048, AllowMultiple = false, Inherited = false)]
                public sealed class ApiConventionTypeMatchAttribute : System.Attribute
                {
                    public ApiConventionTypeMatchAttribute(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionTypeMatchBehavior matchBehavior) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionTypeMatchBehavior MatchBehavior { get => throw null; }
                }
                public enum ApiConventionTypeMatchBehavior
                {
                    Any = 0,
                    AssignableFrom = 1,
                }
                public interface IApiDefaultResponseMetadataProvider : Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }
                public interface IApiDescriptionGroupNameProvider
                {
                    string GroupName { get; }
                }
                public interface IApiDescriptionVisibilityProvider
                {
                    bool IgnoreApi { get; }
                }
                public interface IApiRequestFormatMetadataProvider
                {
                    System.Collections.Generic.IReadOnlyList<string> GetSupportedContentTypes(string contentType, System.Type objectType);
                }
                public interface IApiRequestMetadataProvider : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes);
                }
                public interface IApiResponseMetadataProvider : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes);
                    int StatusCode { get; }
                    System.Type Type { get; }
                }
                public interface IApiResponseTypeMetadataProvider
                {
                    System.Collections.Generic.IReadOnlyList<string> GetSupportedContentTypes(string contentType, System.Type objectType);
                }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class ApiExplorerSettingsAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionGroupNameProvider, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionVisibilityProvider
            {
                public ApiExplorerSettingsAttribute() => throw null;
                public string GroupName { get => throw null; set { } }
                public bool IgnoreApi { get => throw null; set { } }
            }
            namespace ApplicationModels
            {
                public class ActionModel : Microsoft.AspNetCore.Mvc.ApplicationModels.IApiExplorerModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IFilterModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    public System.Reflection.MethodInfo ActionMethod { get => throw null; }
                    public string ActionName { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel ApiExplorer { get => throw null; set { } }
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel Controller { get => throw null; set { } }
                    public ActionModel(System.Reflection.MethodInfo actionMethod, System.Collections.Generic.IReadOnlyList<object> attributes) => throw null;
                    public ActionModel(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel other) => throw null;
                    public string DisplayName { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    string Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.Name { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModel> Parameters { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public Microsoft.AspNetCore.Routing.IOutboundParameterTransformer RouteParameterTransformer { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.SelectorModel> Selectors { get => throw null; }
                }
                public class ApiConventionApplicationModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public ApiConventionApplicationModelConvention(Microsoft.AspNetCore.Mvc.ProducesErrorResponseTypeAttribute defaultErrorResponseType) => throw null;
                    public Microsoft.AspNetCore.Mvc.ProducesErrorResponseTypeAttribute DefaultErrorResponseType { get => throw null; }
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }
                public class ApiExplorerModel
                {
                    public ApiExplorerModel() => throw null;
                    public ApiExplorerModel(Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel other) => throw null;
                    public string GroupName { get => throw null; set { } }
                    public bool? IsVisible { get => throw null; set { } }
                }
                public class ApiVisibilityConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public ApiVisibilityConvention() => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }
                public class ApplicationModel : Microsoft.AspNetCore.Mvc.ApplicationModels.IApiExplorerModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IFilterModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel ApiExplorer { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel> Controllers { get => throw null; }
                    public ApplicationModel() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                }
                public class ApplicationModelProviderContext
                {
                    public System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> ControllerTypes { get => throw null; }
                    public ApplicationModelProviderContext(System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> controllerTypes) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModel Result { get => throw null; }
                }
                public class AttributeRouteModel
                {
                    public Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider Attribute { get => throw null; }
                    public static Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel CombineAttributeRouteModel(Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel left, Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel right) => throw null;
                    public static string CombineTemplates(string prefix, string template) => throw null;
                    public AttributeRouteModel() => throw null;
                    public AttributeRouteModel(Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider templateProvider) => throw null;
                    public AttributeRouteModel(Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel other) => throw null;
                    public bool IsAbsoluteTemplate { get => throw null; }
                    public static bool IsOverridePattern(string template) => throw null;
                    public string Name { get => throw null; set { } }
                    public int? Order { get => throw null; set { } }
                    public static string ReplaceTokens(string template, System.Collections.Generic.IDictionary<string, string> values) => throw null;
                    public static string ReplaceTokens(string template, System.Collections.Generic.IDictionary<string, string> values, Microsoft.AspNetCore.Routing.IOutboundParameterTransformer routeTokenTransformer) => throw null;
                    public bool SuppressLinkGeneration { get => throw null; set { } }
                    public bool SuppressPathMatching { get => throw null; set { } }
                    public string Template { get => throw null; set { } }
                }
                public class ClientErrorResultFilterConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public ClientErrorResultFilterConvention() => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }
                public class ConsumesConstraintForFormFileParameterConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public ConsumesConstraintForFormFileParameterConvention() => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }
                public class ControllerModel : Microsoft.AspNetCore.Mvc.ApplicationModels.IApiExplorerModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IFilterModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel> Actions { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel ApiExplorer { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModel Application { get => throw null; set { } }
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public string ControllerName { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PropertyModel> ControllerProperties { get => throw null; }
                    public System.Reflection.TypeInfo ControllerType { get => throw null; }
                    public ControllerModel(System.Reflection.TypeInfo controllerType, System.Collections.Generic.IReadOnlyList<object> attributes) => throw null;
                    public ControllerModel(Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel other) => throw null;
                    public string DisplayName { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    string Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.Name { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.SelectorModel> Selectors { get => throw null; }
                }
                public interface IActionModelConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action);
                }
                public interface IApiExplorerModel
                {
                    Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel ApiExplorer { get; set; }
                }
                public interface IApplicationModelConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModel application);
                }
                public interface IApplicationModelProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModelProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModelProviderContext context);
                    int Order { get; }
                }
                public interface IBindingModel
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get; set; }
                }
                public interface ICommonModel : Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    System.Collections.Generic.IReadOnlyList<object> Attributes { get; }
                    System.Reflection.MemberInfo MemberInfo { get; }
                    string Name { get; }
                }
                public interface IControllerModelConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel controller);
                }
                public interface IFilterModel
                {
                    System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get; }
                }
                public class InferParameterBindingInfoConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public InferParameterBindingInfoConvention(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider) => throw null;
                    public InferParameterBindingInfoConvention(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider, Microsoft.Extensions.DependencyInjection.IServiceProviderIsService serviceProviderIsService) => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }
                public class InvalidModelStateFilterConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public InvalidModelStateFilterConvention() => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }
                public interface IParameterModelBaseConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase parameter);
                }
                public interface IParameterModelConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModel parameter);
                }
                public interface IPropertyModel
                {
                    System.Collections.Generic.IDictionary<object, object> Properties { get; }
                }
                public class ParameterModel : Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel Action { get => throw null; set { } }
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public ParameterModel(System.Reflection.ParameterInfo parameterInfo, System.Collections.Generic.IReadOnlyList<object> attributes) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public ParameterModel(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModel other) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public string DisplayName { get => throw null; }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public System.Reflection.ParameterInfo ParameterInfo { get => throw null; }
                    public string ParameterName { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                }
                public abstract class ParameterModelBase : Microsoft.AspNetCore.Mvc.ApplicationModels.IBindingModel
                {
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get => throw null; set { } }
                    protected ParameterModelBase(System.Type parameterType, System.Collections.Generic.IReadOnlyList<object> attributes) => throw null;
                    protected ParameterModelBase(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase other) => throw null;
                    public string Name { get => throw null; set { } }
                    public System.Type ParameterType { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                }
                public class PropertyModel : Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase, Microsoft.AspNetCore.Mvc.ApplicationModels.IBindingModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel Controller { get => throw null; set { } }
                    public PropertyModel(System.Reflection.PropertyInfo propertyInfo, System.Collections.Generic.IReadOnlyList<object> attributes) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public PropertyModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PropertyModel other) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public System.Reflection.PropertyInfo PropertyInfo { get => throw null; }
                    public string PropertyName { get => throw null; set { } }
                }
                public class RouteTokenTransformerConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public RouteTokenTransformerConvention(Microsoft.AspNetCore.Routing.IOutboundParameterTransformer parameterTransformer) => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }
                public class SelectorModel
                {
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata> ActionConstraints { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel AttributeRouteModel { get => throw null; set { } }
                    public SelectorModel() => throw null;
                    public SelectorModel(Microsoft.AspNetCore.Mvc.ApplicationModels.SelectorModel other) => throw null;
                    public System.Collections.Generic.IList<object> EndpointMetadata { get => throw null; }
                }
            }
            namespace ApplicationParts
            {
                public abstract class ApplicationPart
                {
                    protected ApplicationPart() => throw null;
                    public abstract string Name { get; }
                }
                [System.AttributeUsage((System.AttributeTargets)1, AllowMultiple = true)]
                public sealed class ApplicationPartAttribute : System.Attribute
                {
                    public string AssemblyName { get => throw null; }
                    public ApplicationPartAttribute(string assemblyName) => throw null;
                }
                public abstract class ApplicationPartFactory
                {
                    protected ApplicationPartFactory() => throw null;
                    public static Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartFactory GetApplicationPartFactory(System.Reflection.Assembly assembly) => throw null;
                    public abstract System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetApplicationParts(System.Reflection.Assembly assembly);
                }
                public class ApplicationPartManager
                {
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> ApplicationParts { get => throw null; }
                    public ApplicationPartManager() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider> FeatureProviders { get => throw null; }
                    public void PopulateFeature<TFeature>(TFeature feature) => throw null;
                }
                public class AssemblyPart : Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart, Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationPartTypeProvider
                {
                    public System.Reflection.Assembly Assembly { get => throw null; }
                    public AssemblyPart(System.Reflection.Assembly assembly) => throw null;
                    public override string Name { get => throw null; }
                    public System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> Types { get => throw null; }
                }
                public class DefaultApplicationPartFactory : Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartFactory
                {
                    public DefaultApplicationPartFactory() => throw null;
                    public override System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetApplicationParts(System.Reflection.Assembly assembly) => throw null;
                    public static System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetDefaultApplicationParts(System.Reflection.Assembly assembly) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ApplicationParts.DefaultApplicationPartFactory Instance { get => throw null; }
                }
                public interface IApplicationFeatureProvider
                {
                }
                public interface IApplicationFeatureProvider<TFeature> : Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider
                {
                    void PopulateFeature(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> parts, TFeature feature);
                }
                public interface IApplicationPartTypeProvider
                {
                    System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> Types { get; }
                }
                public interface ICompilationReferencesProvider
                {
                    System.Collections.Generic.IEnumerable<string> GetReferencePaths();
                }
                public class NullApplicationPartFactory : Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartFactory
                {
                    public NullApplicationPartFactory() => throw null;
                    public override System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetApplicationParts(System.Reflection.Assembly assembly) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)1, AllowMultiple = false)]
                public sealed class ProvideApplicationPartFactoryAttribute : System.Attribute
                {
                    public ProvideApplicationPartFactoryAttribute(System.Type factoryType) => throw null;
                    public ProvideApplicationPartFactoryAttribute(string factoryTypeName) => throw null;
                    public System.Type GetFactoryType() => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)1, AllowMultiple = true)]
                public sealed class RelatedAssemblyAttribute : System.Attribute
                {
                    public string AssemblyFileName { get => throw null; }
                    public RelatedAssemblyAttribute(string assemblyFileName) => throw null;
                    public static System.Collections.Generic.IReadOnlyList<System.Reflection.Assembly> GetRelatedAssemblies(System.Reflection.Assembly assembly, bool throwOnError) => throw null;
                }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class AreaAttribute : Microsoft.AspNetCore.Mvc.Routing.RouteValueAttribute
            {
                public AreaAttribute(string areaName) : base(default(string), default(string)) => throw null;
            }
            namespace Authorization
            {
                public class AllowAnonymousFilter : Microsoft.AspNetCore.Mvc.Authorization.IAllowAnonymousFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    public AllowAnonymousFilter() => throw null;
                }
                public class AuthorizeFilter : Microsoft.AspNetCore.Mvc.Filters.IAsyncAuthorizationFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizeData> AuthorizeData { get => throw null; }
                    Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Microsoft.AspNetCore.Mvc.Filters.IFilterFactory.CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                    public AuthorizeFilter() => throw null;
                    public AuthorizeFilter(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy) => throw null;
                    public AuthorizeFilter(Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider policyProvider, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizeData> authorizeData) => throw null;
                    public AuthorizeFilter(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizeData> authorizeData) => throw null;
                    public AuthorizeFilter(string policy) => throw null;
                    bool Microsoft.AspNetCore.Mvc.Filters.IFilterFactory.IsReusable { get => throw null; }
                    public virtual System.Threading.Tasks.Task OnAuthorizationAsync(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext context) => throw null;
                    public Microsoft.AspNetCore.Authorization.AuthorizationPolicy Policy { get => throw null; }
                    public Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider PolicyProvider { get => throw null; }
                }
            }
            public class BadRequestObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public BadRequestObjectResult(object error) : base(default(object)) => throw null;
                public BadRequestObjectResult(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) : base(default(object)) => throw null;
            }
            public class BadRequestResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public BadRequestResult() : base(default(int)) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2052, AllowMultiple = false, Inherited = true)]
            public class BindAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider
            {
                public BindAttribute(params string[] include) => throw null;
                public string[] Include { get => throw null; }
                string Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider.Name { get => throw null; }
                public string Prefix { get => throw null; set { } }
                public System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
            public class BindPropertiesAttribute : System.Attribute
            {
                public BindPropertiesAttribute() => throw null;
                public bool SupportsGet { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
            public class BindPropertyAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBinderTypeProviderMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IRequestPredicateProvider
            {
                public System.Type BinderType { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set { } }
                public BindPropertyAttribute() => throw null;
                public string Name { get => throw null; set { } }
                System.Func<Microsoft.AspNetCore.Mvc.ActionContext, bool> Microsoft.AspNetCore.Mvc.ModelBinding.IRequestPredicateProvider.RequestPredicate { get => throw null; }
                public bool SupportsGet { get => throw null; set { } }
            }
            public class CacheProfile
            {
                public CacheProfile() => throw null;
                public int? Duration { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.ResponseCacheLocation? Location { get => throw null; set { } }
                public bool? NoStore { get => throw null; set { } }
                public string VaryByHeader { get => throw null; set { } }
                public string[] VaryByQueryKeys { get => throw null; set { } }
            }
            public class ChallengeResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public System.Collections.Generic.IList<string> AuthenticationSchemes { get => throw null; set { } }
                public ChallengeResult() => throw null;
                public ChallengeResult(string authenticationScheme) => throw null;
                public ChallengeResult(System.Collections.Generic.IList<string> authenticationSchemes) => throw null;
                public ChallengeResult(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ChallengeResult(string authenticationScheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ChallengeResult(System.Collections.Generic.IList<string> authenticationSchemes, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
            }
            public class ClientErrorData
            {
                public ClientErrorData() => throw null;
                public string Link { get => throw null; set { } }
                public string Title { get => throw null; set { } }
            }
            public enum CompatibilityVersion
            {
                Version_2_0 = 0,
                Version_2_1 = 1,
                Version_2_2 = 2,
                Version_3_0 = 3,
                Latest = 2147483647,
            }
            public class ConflictObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public ConflictObjectResult(object error) : base(default(object)) => throw null;
                public ConflictObjectResult(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) : base(default(object)) => throw null;
            }
            public class ConflictResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public ConflictResult() : base(default(int)) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class ConsumesAttribute : System.Attribute, Microsoft.AspNetCore.Http.Metadata.IAcceptsMetadata, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiRequestMetadataProvider, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IResourceFilter
            {
                public bool Accept(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintContext context) => throw null;
                public static readonly int ConsumesActionConstraintOrder;
                public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection ContentTypes { get => throw null; set { } }
                System.Collections.Generic.IReadOnlyList<string> Microsoft.AspNetCore.Http.Metadata.IAcceptsMetadata.ContentTypes { get => throw null; }
                public ConsumesAttribute(string contentType, params string[] otherContentTypes) => throw null;
                public ConsumesAttribute(System.Type requestType, string contentType, params string[] otherContentTypes) => throw null;
                public bool IsOptional { get => throw null; set { } }
                public void OnResourceExecuted(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext context) => throw null;
                public void OnResourceExecuting(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext context) => throw null;
                int Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint.Order { get => throw null; }
                System.Type Microsoft.AspNetCore.Http.Metadata.IAcceptsMetadata.RequestType { get => throw null; }
                public void SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
            }
            public class ContentResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult
            {
                public string Content { get => throw null; set { } }
                public string ContentType { get => throw null; set { } }
                public ContentResult() => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public int? StatusCode { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
            public class ControllerAttribute : System.Attribute
            {
                public ControllerAttribute() => throw null;
            }
            public abstract class ControllerBase
            {
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(System.Uri uri) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(string uri) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(string uri, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(System.Uri uri, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, string controllerName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, string controllerName, object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, string controllerName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(string routeName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(string routeName, object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(string routeName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.BadRequestResult BadRequest() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(object error) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(params string[] authenticationSchemes) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ConflictResult Conflict() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ConflictObjectResult Conflict(object error) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ConflictObjectResult Conflict(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                public Microsoft.AspNetCore.Mvc.ControllerContext ControllerContext { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Mvc.CreatedResult Created() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedResult Created(string uri, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedResult Created(System.Uri uri, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtActionResult CreatedAtAction(string actionName, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtActionResult CreatedAtAction(string actionName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtActionResult CreatedAtAction(string actionName, string controllerName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtRouteResult CreatedAtRoute(string routeName, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtRouteResult CreatedAtRoute(object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtRouteResult CreatedAtRoute(string routeName, object routeValues, object value) => throw null;
                protected ControllerBase() => throw null;
                public static Microsoft.AspNetCore.Mvc.EmptyResult Empty { get => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType, string fileDownloadName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType, string fileDownloadName, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(byte[] fileContents, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
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
                public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderFactory ModelBinderFactory { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.NoContentResult NoContent() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.NotFoundResult NotFound() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.NotFoundObjectResult NotFound(object value) => throw null;
                public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IObjectModelValidator ObjectValidator { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Mvc.OkResult Ok() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.OkObjectResult Ok(object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ObjectResult Problem(string detail = default(string), string instance = default(string), int? statusCode = default(int?), string title = default(string), string type = default(string)) => throw null;
                public Microsoft.AspNetCore.Mvc.Infrastructure.ProblemDetailsFactory ProblemDetailsFactory { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Mvc.RedirectResult Redirect(string url) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanent(string url) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPermanentPreserveMethod(string url) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectResult RedirectPreserveMethod(string url) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction() => throw null;
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
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, string fragment) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPage(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, string fragment) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanentPreserveMethod(string pageName, string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePreserveMethod(string pageName, string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
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
                public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal, string authenticationScheme) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, string authenticationScheme) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
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
                public virtual Microsoft.AspNetCore.Mvc.UnauthorizedObjectResult Unauthorized(object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.UnprocessableEntityResult UnprocessableEntity() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.UnprocessableEntityObjectResult UnprocessableEntity(object error) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.UnprocessableEntityObjectResult UnprocessableEntity(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public Microsoft.AspNetCore.Mvc.IUrlHelper Url { get => throw null; set { } }
                public System.Security.Claims.ClaimsPrincipal User { get => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.ActionResult ValidationProblem(Microsoft.AspNetCore.Mvc.ValidationProblemDetails descriptor) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ActionResult ValidationProblem(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelStateDictionary) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ActionResult ValidationProblem() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ActionResult ValidationProblem(string detail = default(string), string instance = default(string), int? statusCode = default(int?), string title = default(string), string type = default(string), Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelStateDictionary = default(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary)) => throw null;
            }
            public class ControllerContext : Microsoft.AspNetCore.Mvc.ActionContext
            {
                public Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor ActionDescriptor { get => throw null; set { } }
                public ControllerContext() => throw null;
                public ControllerContext(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public virtual System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> ValueProviderFactories { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
            public class ControllerContextAttribute : System.Attribute
            {
                public ControllerContextAttribute() => throw null;
            }
            namespace Controllers
            {
                public class ControllerActionDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor
                {
                    public virtual string ActionName { get => throw null; set { } }
                    public string ControllerName { get => throw null; set { } }
                    public System.Reflection.TypeInfo ControllerTypeInfo { get => throw null; set { } }
                    public ControllerActionDescriptor() => throw null;
                    public override string DisplayName { get => throw null; set { } }
                    public System.Reflection.MethodInfo MethodInfo { get => throw null; set { } }
                }
                public class ControllerActivatorProvider : Microsoft.AspNetCore.Mvc.Controllers.IControllerActivatorProvider
                {
                    public System.Func<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor) => throw null;
                    public System.Func<Microsoft.AspNetCore.Mvc.ControllerContext, object, System.Threading.Tasks.ValueTask> CreateAsyncReleaser(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor) => throw null;
                    public System.Action<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor) => throw null;
                    public ControllerActivatorProvider(Microsoft.AspNetCore.Mvc.Controllers.IControllerActivator controllerActivator) => throw null;
                }
                public class ControllerBoundPropertyDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor, Microsoft.AspNetCore.Mvc.Infrastructure.IPropertyInfoParameterDescriptor
                {
                    public ControllerBoundPropertyDescriptor() => throw null;
                    public System.Reflection.PropertyInfo PropertyInfo { get => throw null; set { } }
                }
                public class ControllerFeature
                {
                    public System.Collections.Generic.IList<System.Reflection.TypeInfo> Controllers { get => throw null; }
                    public ControllerFeature() => throw null;
                }
                public class ControllerFeatureProvider : Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider<Microsoft.AspNetCore.Mvc.Controllers.ControllerFeature>, Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider
                {
                    public ControllerFeatureProvider() => throw null;
                    protected virtual bool IsController(System.Reflection.TypeInfo typeInfo) => throw null;
                    public void PopulateFeature(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> parts, Microsoft.AspNetCore.Mvc.Controllers.ControllerFeature feature) => throw null;
                }
                public class ControllerParameterDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor, Microsoft.AspNetCore.Mvc.Infrastructure.IParameterInfoParameterDescriptor
                {
                    public ControllerParameterDescriptor() => throw null;
                    public System.Reflection.ParameterInfo ParameterInfo { get => throw null; set { } }
                }
                public interface IControllerActivator
                {
                    object Create(Microsoft.AspNetCore.Mvc.ControllerContext context);
                    void Release(Microsoft.AspNetCore.Mvc.ControllerContext context, object controller);
                    virtual System.Threading.Tasks.ValueTask ReleaseAsync(Microsoft.AspNetCore.Mvc.ControllerContext context, object controller) => throw null;
                }
                public interface IControllerActivatorProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor);
                    virtual System.Func<Microsoft.AspNetCore.Mvc.ControllerContext, object, System.Threading.Tasks.ValueTask> CreateAsyncReleaser(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor) => throw null;
                    System.Action<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor);
                }
                public interface IControllerFactory
                {
                    object CreateController(Microsoft.AspNetCore.Mvc.ControllerContext context);
                    void ReleaseController(Microsoft.AspNetCore.Mvc.ControllerContext context, object controller);
                    virtual System.Threading.Tasks.ValueTask ReleaseControllerAsync(Microsoft.AspNetCore.Mvc.ControllerContext context, object controller) => throw null;
                }
                public interface IControllerFactoryProvider
                {
                    virtual System.Func<Microsoft.AspNetCore.Mvc.ControllerContext, object, System.Threading.Tasks.ValueTask> CreateAsyncControllerReleaser(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor) => throw null;
                    System.Func<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateControllerFactory(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor);
                    System.Action<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateControllerReleaser(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor);
                }
                public class ServiceBasedControllerActivator : Microsoft.AspNetCore.Mvc.Controllers.IControllerActivator
                {
                    public object Create(Microsoft.AspNetCore.Mvc.ControllerContext actionContext) => throw null;
                    public ServiceBasedControllerActivator() => throw null;
                    public virtual void Release(Microsoft.AspNetCore.Mvc.ControllerContext context, object controller) => throw null;
                }
            }
            namespace Core
            {
                namespace Infrastructure
                {
                    public interface IAntiforgeryValidationFailedResult : Microsoft.AspNetCore.Mvc.IActionResult
                    {
                    }
                }
            }
            public class CreatedAtActionResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public string ActionName { get => throw null; set { } }
                public string ControllerName { get => throw null; set { } }
                public CreatedAtActionResult(string actionName, string controllerName, object routeValues, object value) : base(default(object)) => throw null;
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set { } }
            }
            public class CreatedAtRouteResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public CreatedAtRouteResult(object routeValues, object value) : base(default(object)) => throw null;
                public CreatedAtRouteResult(string routeName, object routeValues, object value) : base(default(object)) => throw null;
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string RouteName { get => throw null; set { } }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set { } }
            }
            public class CreatedResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public CreatedResult() : base(default(object)) => throw null;
                public CreatedResult(string location, object value) : base(default(object)) => throw null;
                public CreatedResult(System.Uri location, object value) : base(default(object)) => throw null;
                public string Location { get => throw null; set { } }
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
            }
            public static class DefaultApiConventions
            {
                public static void Create(object model) => throw null;
                public static void Delete(object id) => throw null;
                public static void Edit(object id, object model) => throw null;
                public static void Find(object id) => throw null;
                public static void Get(object id) => throw null;
                public static void Post(object model) => throw null;
                public static void Put(object id, object model) => throw null;
                public static void Update(object id, object model) => throw null;
            }
            namespace Diagnostics
            {
                public sealed class AfterActionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterActionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterActionFilterOnActionExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext ActionExecutedContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterActionFilterOnActionExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext actionExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterActionFilterOnActionExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext ActionExecutingContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterActionFilterOnActionExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext actionExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterActionFilterOnActionExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext ActionExecutedContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterActionFilterOnActionExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext actionExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterActionResultEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterActionResultEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.IActionResult result) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterAuthorizationFilterOnAuthorizationEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext AuthorizationContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterAuthorizationFilterOnAuthorizationEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext authorizationContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterControllerActionMethodEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> Arguments { get => throw null; }
                    public object Controller { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterControllerActionMethodEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IReadOnlyDictionary<string, object> arguments, object controller, Microsoft.AspNetCore.Mvc.IActionResult result) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterExceptionFilterOnExceptionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterExceptionFilterOnExceptionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ExceptionContext exceptionContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.ExceptionContext ExceptionContext { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterResourceFilterOnResourceExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterResourceFilterOnResourceExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext resourceExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext ResourceExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterResourceFilterOnResourceExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterResourceFilterOnResourceExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext resourceExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext ResourceExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterResourceFilterOnResourceExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterResourceFilterOnResourceExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext resourceExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext ResourceExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterResultFilterOnResultExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterResultFilterOnResultExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext resultExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext ResultExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterResultFilterOnResultExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterResultFilterOnResultExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext resultExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext ResultExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class AfterResultFilterOnResultExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public AfterResultFilterOnResultExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext resultExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext ResultExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeActionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeActionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeActionFilterOnActionExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext ActionExecutedContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeActionFilterOnActionExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext actionExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeActionFilterOnActionExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext ActionExecutingContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeActionFilterOnActionExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext actionExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeActionFilterOnActionExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext ActionExecutingContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeActionFilterOnActionExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext actionExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeActionResultEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeActionResultEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.IActionResult result) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeAuthorizationFilterOnAuthorizationEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext AuthorizationContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeAuthorizationFilterOnAuthorizationEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext authorizationContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeControllerActionMethodEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> ActionArguments { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public object Controller { get => throw null; }
                    protected override sealed int Count { get => throw null; }
                    public BeforeControllerActionMethodEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IReadOnlyDictionary<string, object> actionArguments, object controller) => throw null;
                    public const string EventName = default;
                    protected override sealed System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeExceptionFilterOnException : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeExceptionFilterOnException(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ExceptionContext exceptionContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.ExceptionContext ExceptionContext { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeResourceFilterOnResourceExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeResourceFilterOnResourceExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext resourceExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext ResourceExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeResourceFilterOnResourceExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeResourceFilterOnResourceExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext resourceExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext ResourceExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeResourceFilterOnResourceExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeResourceFilterOnResourceExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext resourceExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext ResourceExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeResultFilterOnResultExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeResultFilterOnResultExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext resultExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext ResultExecutedContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeResultFilterOnResultExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeResultFilterOnResultExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext resultExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext ResultExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public sealed class BeforeResultFilterOnResultExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public BeforeResultFilterOnResultExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext resultExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext ResultExecutingContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }
                public abstract class EventData : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    protected abstract int Count { get; }
                    int System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>.Count { get => throw null; }
                    protected EventData() => throw null;
                    public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerator
                    {
                        public System.Collections.Generic.KeyValuePair<string, object> Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        void System.Collections.IEnumerator.Reset() => throw null;
                    }
                    protected const string EventNamespace = default;
                    System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    System.Collections.Generic.KeyValuePair<string, object> System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>.this[int index] { get => throw null; }
                    protected abstract System.Collections.Generic.KeyValuePair<string, object> this[int index] { get; }
                }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class DisableRequestSizeLimitAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Http.Metadata.IRequestSizeLimitMetadata
            {
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public DisableRequestSizeLimitAttribute() => throw null;
                public bool IsReusable { get => throw null; }
                long? Microsoft.AspNetCore.Http.Metadata.IRequestSizeLimitMetadata.MaxRequestBodySize { get => throw null; }
                public int Order { get => throw null; set { } }
            }
            public class EmptyResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public EmptyResult() => throw null;
                public override void ExecuteResult(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
            }
            public class FileContentResult : Microsoft.AspNetCore.Mvc.FileResult
            {
                public FileContentResult(byte[] fileContents, string contentType) : base(default(string)) => throw null;
                public FileContentResult(byte[] fileContents, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) : base(default(string)) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public byte[] FileContents { get => throw null; set { } }
            }
            public abstract class FileResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public string ContentType { get => throw null; }
                protected FileResult(string contentType) => throw null;
                public bool EnableRangeProcessing { get => throw null; set { } }
                public Microsoft.Net.Http.Headers.EntityTagHeaderValue EntityTag { get => throw null; set { } }
                public string FileDownloadName { get => throw null; set { } }
                public System.DateTimeOffset? LastModified { get => throw null; set { } }
            }
            public class FileStreamResult : Microsoft.AspNetCore.Mvc.FileResult
            {
                public FileStreamResult(System.IO.Stream fileStream, string contentType) : base(default(string)) => throw null;
                public FileStreamResult(System.IO.Stream fileStream, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) : base(default(string)) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public System.IO.Stream FileStream { get => throw null; set { } }
            }
            namespace Filters
            {
                [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
                public abstract class ActionFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IActionFilter, Microsoft.AspNetCore.Mvc.Filters.IAsyncActionFilter, Microsoft.AspNetCore.Mvc.Filters.IAsyncResultFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IResultFilter
                {
                    protected ActionFilterAttribute() => throw null;
                    public virtual void OnActionExecuted(Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext context) => throw null;
                    public virtual void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnActionExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ActionExecutionDelegate next) => throw null;
                    public virtual void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context) => throw null;
                    public virtual void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnResultExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ResultExecutionDelegate next) => throw null;
                    public int Order { get => throw null; set { } }
                }
                [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
                public abstract class ExceptionFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IAsyncExceptionFilter, Microsoft.AspNetCore.Mvc.Filters.IExceptionFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
                {
                    protected ExceptionFilterAttribute() => throw null;
                    public virtual void OnException(Microsoft.AspNetCore.Mvc.Filters.ExceptionContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnExceptionAsync(Microsoft.AspNetCore.Mvc.Filters.ExceptionContext context) => throw null;
                    public int Order { get => throw null; set { } }
                }
                public class FilterCollection : System.Collections.ObjectModel.Collection<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>
                {
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Add<TFilterType>() where TFilterType : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Add(System.Type filterType) => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Add<TFilterType>(int order) where TFilterType : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Add(System.Type filterType, int order) => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata AddService<TFilterType>() where TFilterType : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata AddService(System.Type filterType) => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata AddService<TFilterType>(int order) where TFilterType : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata AddService(System.Type filterType, int order) => throw null;
                    public FilterCollection() => throw null;
                }
                public static class FilterScope
                {
                    public static readonly int Action;
                    public static readonly int Controller;
                    public static readonly int First;
                    public static readonly int Global;
                    public static readonly int Last;
                }
                [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
                public abstract class ResultFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IAsyncResultFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IResultFilter
                {
                    protected ResultFilterAttribute() => throw null;
                    public virtual void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context) => throw null;
                    public virtual void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnResultExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ResultExecutionDelegate next) => throw null;
                    public int Order { get => throw null; set { } }
                }
            }
            public class ForbidResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public System.Collections.Generic.IList<string> AuthenticationSchemes { get => throw null; set { } }
                public ForbidResult() => throw null;
                public ForbidResult(string authenticationScheme) => throw null;
                public ForbidResult(System.Collections.Generic.IList<string> authenticationSchemes) => throw null;
                public ForbidResult(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ForbidResult(string authenticationScheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ForbidResult(System.Collections.Generic.IList<string> authenticationSchemes, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class FormatFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public FormatFilterAttribute() => throw null;
                public bool IsReusable { get => throw null; }
            }
            namespace Formatters
            {
                public class FormatFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IResourceFilter, Microsoft.AspNetCore.Mvc.Filters.IResultFilter
                {
                    public FormatFilter(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public virtual string GetFormat(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                    public void OnResourceExecuted(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext context) => throw null;
                    public void OnResourceExecuting(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext context) => throw null;
                    public void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context) => throw null;
                    public void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context) => throw null;
                }
                public class FormatterMappings
                {
                    public bool ClearMediaTypeMappingForFormat(string format) => throw null;
                    public FormatterMappings() => throw null;
                    public string GetMediaTypeMappingForFormat(string format) => throw null;
                    public void SetMediaTypeMappingForFormat(string format, string contentType) => throw null;
                    public void SetMediaTypeMappingForFormat(string format, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                }
                public class HttpNoContentOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter
                {
                    public bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context) => throw null;
                    public HttpNoContentOutputFormatter() => throw null;
                    public bool TreatNullValueAsNoContent { get => throw null; set { } }
                    public System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                }
                public abstract class InputFormatter : Microsoft.AspNetCore.Mvc.ApiExplorer.IApiRequestFormatMetadataProvider, Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter
                {
                    public virtual bool CanRead(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context) => throw null;
                    protected virtual bool CanReadType(System.Type type) => throw null;
                    protected InputFormatter() => throw null;
                    protected virtual object GetDefaultValueForType(System.Type modelType) => throw null;
                    public virtual System.Collections.Generic.IReadOnlyList<string> GetSupportedContentTypes(string contentType, System.Type objectType) => throw null;
                    public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context) => throw null;
                    public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context);
                    public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection SupportedMediaTypes { get => throw null; }
                }
                public struct MediaType
                {
                    public Microsoft.Extensions.Primitives.StringSegment Charset { get => throw null; }
                    public static Microsoft.AspNetCore.Mvc.Formatters.MediaTypeSegmentWithQuality CreateMediaTypeSegmentWithQuality(string mediaType, int start) => throw null;
                    public MediaType(string mediaType) => throw null;
                    public MediaType(Microsoft.Extensions.Primitives.StringSegment mediaType) => throw null;
                    public MediaType(string mediaType, int offset, int? length) => throw null;
                    public System.Text.Encoding Encoding { get => throw null; }
                    public static System.Text.Encoding GetEncoding(string mediaType) => throw null;
                    public static System.Text.Encoding GetEncoding(Microsoft.Extensions.Primitives.StringSegment mediaType) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment GetParameter(string parameterName) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment GetParameter(Microsoft.Extensions.Primitives.StringSegment parameterName) => throw null;
                    public bool HasWildcard { get => throw null; }
                    public bool IsSubsetOf(Microsoft.AspNetCore.Mvc.Formatters.MediaType set) => throw null;
                    public bool MatchesAllSubTypes { get => throw null; }
                    public bool MatchesAllSubTypesWithoutSuffix { get => throw null; }
                    public bool MatchesAllTypes { get => throw null; }
                    public static string ReplaceEncoding(string mediaType, System.Text.Encoding encoding) => throw null;
                    public static string ReplaceEncoding(Microsoft.Extensions.Primitives.StringSegment mediaType, System.Text.Encoding encoding) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment SubType { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment SubTypeSuffix { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment SubTypeWithoutSuffix { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment Type { get => throw null; }
                }
                public class MediaTypeCollection : System.Collections.ObjectModel.Collection<string>
                {
                    public void Add(Microsoft.Net.Http.Headers.MediaTypeHeaderValue item) => throw null;
                    public MediaTypeCollection() => throw null;
                    public void Insert(int index, Microsoft.Net.Http.Headers.MediaTypeHeaderValue item) => throw null;
                    public bool Remove(Microsoft.Net.Http.Headers.MediaTypeHeaderValue item) => throw null;
                }
                public struct MediaTypeSegmentWithQuality
                {
                    public MediaTypeSegmentWithQuality(Microsoft.Extensions.Primitives.StringSegment mediaType, double quality) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment MediaType { get => throw null; }
                    public double Quality { get => throw null; }
                    public override string ToString() => throw null;
                }
                public abstract class OutputFormatter : Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseTypeMetadataProvider, Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter
                {
                    public virtual bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context) => throw null;
                    protected virtual bool CanWriteType(System.Type type) => throw null;
                    protected OutputFormatter() => throw null;
                    public virtual System.Collections.Generic.IReadOnlyList<string> GetSupportedContentTypes(string contentType, System.Type objectType) => throw null;
                    public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection SupportedMediaTypes { get => throw null; }
                    public virtual System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                    public abstract System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context);
                    public virtual void WriteResponseHeaders(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                }
                public class StreamOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter
                {
                    public bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context) => throw null;
                    public StreamOutputFormatter() => throw null;
                    public System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                }
                public class StringOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextOutputFormatter
                {
                    public override bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context) => throw null;
                    public StringOutputFormatter() => throw null;
                    public override System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.Text.Encoding encoding) => throw null;
                }
                public class SystemTextJsonInputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextInputFormatter, Microsoft.AspNetCore.Mvc.Formatters.IInputFormatterExceptionPolicy
                {
                    public SystemTextJsonInputFormatter(Microsoft.AspNetCore.Mvc.JsonOptions options, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Mvc.Formatters.SystemTextJsonInputFormatter> logger) => throw null;
                    Microsoft.AspNetCore.Mvc.Formatters.InputFormatterExceptionPolicy Microsoft.AspNetCore.Mvc.Formatters.IInputFormatterExceptionPolicy.ExceptionPolicy { get => throw null; }
                    public override sealed System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context, System.Text.Encoding encoding) => throw null;
                    public System.Text.Json.JsonSerializerOptions SerializerOptions { get => throw null; }
                }
                public class SystemTextJsonOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextOutputFormatter
                {
                    public SystemTextJsonOutputFormatter(System.Text.Json.JsonSerializerOptions jsonSerializerOptions) => throw null;
                    public System.Text.Json.JsonSerializerOptions SerializerOptions { get => throw null; }
                    public override sealed System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.Text.Encoding selectedEncoding) => throw null;
                }
                public abstract class TextInputFormatter : Microsoft.AspNetCore.Mvc.Formatters.InputFormatter
                {
                    protected TextInputFormatter() => throw null;
                    public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context) => throw null;
                    public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context, System.Text.Encoding encoding);
                    protected System.Text.Encoding SelectCharacterEncoding(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context) => throw null;
                    public System.Collections.Generic.IList<System.Text.Encoding> SupportedEncodings { get => throw null; }
                    protected static readonly System.Text.Encoding UTF16EncodingLittleEndian;
                    protected static readonly System.Text.Encoding UTF8EncodingWithoutBOM;
                }
                public abstract class TextOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.OutputFormatter
                {
                    protected TextOutputFormatter() => throw null;
                    public virtual System.Text.Encoding SelectCharacterEncoding(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                    public System.Collections.Generic.IList<System.Text.Encoding> SupportedEncodings { get => throw null; }
                    public override System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                    public override sealed System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                    public abstract System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.Text.Encoding selectedEncoding);
                }
            }
            [System.AttributeUsage((System.AttributeTargets)2176, AllowMultiple = false, Inherited = true)]
            public class FromBodyAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Http.Metadata.IFromBodyMetadata
            {
                bool Microsoft.AspNetCore.Http.Metadata.IFromBodyMetadata.AllowEmpty { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromBodyAttribute() => throw null;
                public Microsoft.AspNetCore.Mvc.ModelBinding.EmptyBodyBehavior EmptyBodyBehavior { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)2176, AllowMultiple = false, Inherited = true)]
            public class FromFormAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Http.Metadata.IFromFormMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromFormAttribute() => throw null;
                public string Name { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)2176, AllowMultiple = false, Inherited = true)]
            public class FromHeaderAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Http.Metadata.IFromHeaderMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromHeaderAttribute() => throw null;
                public string Name { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)2176, AllowMultiple = false, Inherited = true)]
            public class FromQueryAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Http.Metadata.IFromQueryMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromQueryAttribute() => throw null;
                public string Name { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)2176, AllowMultiple = false, Inherited = true)]
            public class FromRouteAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Http.Metadata.IFromRouteMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromRouteAttribute() => throw null;
                public string Name { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)2176, AllowMultiple = false, Inherited = true)]
            public class FromServicesAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Http.Metadata.IFromServiceMetadata
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromServicesAttribute() => throw null;
            }
            public class HttpDeleteAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpDeleteAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpDeleteAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }
            public class HttpGetAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpGetAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpGetAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }
            public class HttpHeadAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpHeadAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpHeadAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }
            public class HttpOptionsAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpOptionsAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpOptionsAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }
            public class HttpPatchAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpPatchAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpPatchAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }
            public class HttpPostAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpPostAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpPostAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }
            public class HttpPutAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpPutAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpPutAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }
            public interface IDesignTimeMvcBuilderConfiguration
            {
                void ConfigureMvc(Microsoft.Extensions.DependencyInjection.IMvcBuilder builder);
            }
            namespace Infrastructure
            {
                public class ActionContextAccessor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionContextAccessor
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; set { } }
                    public ActionContextAccessor() => throw null;
                }
                public class ActionDescriptorCollection
                {
                    public ActionDescriptorCollection(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> items, int version) => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> Items { get => throw null; }
                    public int Version { get => throw null; }
                }
                public abstract class ActionDescriptorCollectionProvider : Microsoft.AspNetCore.Mvc.Infrastructure.IActionDescriptorCollectionProvider
                {
                    public abstract Microsoft.AspNetCore.Mvc.Infrastructure.ActionDescriptorCollection ActionDescriptors { get; }
                    protected ActionDescriptorCollectionProvider() => throw null;
                    public abstract Microsoft.Extensions.Primitives.IChangeToken GetChangeToken();
                }
                [System.AttributeUsage((System.AttributeTargets)2176, AllowMultiple = false, Inherited = false)]
                public sealed class ActionResultObjectValueAttribute : System.Attribute
                {
                    public ActionResultObjectValueAttribute() => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)2048, AllowMultiple = false, Inherited = false)]
                public sealed class ActionResultStatusCodeAttribute : System.Attribute
                {
                    public ActionResultStatusCodeAttribute() => throw null;
                }
                public class AmbiguousActionException : System.InvalidOperationException
                {
                    public AmbiguousActionException(string message) => throw null;
                    protected AmbiguousActionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class CompatibilitySwitch<TValue> : Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch where TValue : struct
                {
                    public CompatibilitySwitch(string name) => throw null;
                    public CompatibilitySwitch(string name, TValue initialValue) => throw null;
                    public bool IsValueSet { get => throw null; }
                    public string Name { get => throw null; }
                    public TValue Value { get => throw null; set { } }
                    object Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch.Value { get => throw null; set { } }
                }
                public abstract class ConfigureCompatibilityOptions<TOptions> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : class, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>
                {
                    protected ConfigureCompatibilityOptions(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.Infrastructure.MvcCompatibilityOptions> compatibilityOptions) => throw null;
                    protected abstract System.Collections.Generic.IReadOnlyDictionary<string, object> DefaultValues { get; }
                    public virtual void PostConfigure(string name, TOptions options) => throw null;
                    protected Microsoft.AspNetCore.Mvc.CompatibilityVersion Version { get => throw null; }
                }
                public class ContentResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.ContentResult>
                {
                    public ContentResultExecutor(Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Mvc.Infrastructure.ContentResultExecutor> logger, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory httpResponseStreamWriterFactory) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.ContentResult result) => throw null;
                }
                public class DefaultOutputFormatterSelector : Microsoft.AspNetCore.Mvc.Infrastructure.OutputFormatterSelector
                {
                    public DefaultOutputFormatterSelector(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public override Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter SelectFormatter(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter> formatters, Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
                public sealed class DefaultStatusCodeAttribute : System.Attribute
                {
                    public DefaultStatusCodeAttribute(int statusCode) => throw null;
                    public int StatusCode { get => throw null; }
                }
                public class FileContentResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.FileResultExecutorBase, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.FileContentResult>
                {
                    public FileContentResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.Extensions.Logging.ILogger)) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileContentResult result) => throw null;
                    protected virtual System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileContentResult result, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, long rangeLength) => throw null;
                }
                public class FileResultExecutorBase
                {
                    protected const int BufferSize = 65536;
                    protected static Microsoft.Extensions.Logging.ILogger CreateLogger<T>(Microsoft.Extensions.Logging.ILoggerFactory factory) => throw null;
                    public FileResultExecutorBase(Microsoft.Extensions.Logging.ILogger logger) => throw null;
                    protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                    protected virtual (Microsoft.Net.Http.Headers.RangeItemHeaderValue range, long rangeLength, bool serveBody) SetHeadersAndLog(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileResult result, long? fileLength, bool enableRangeProcessing, System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue etag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                    protected static System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Http.HttpContext context, System.IO.Stream fileStream, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, long rangeLength) => throw null;
                }
                public class FileStreamResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.FileResultExecutorBase, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.FileStreamResult>
                {
                    public FileStreamResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.Extensions.Logging.ILogger)) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileStreamResult result) => throw null;
                    protected virtual System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileStreamResult result, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, long rangeLength) => throw null;
                }
                public interface IActionContextAccessor
                {
                    Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get; set; }
                }
                public interface IActionDescriptorChangeProvider
                {
                    Microsoft.Extensions.Primitives.IChangeToken GetChangeToken();
                }
                public interface IActionDescriptorCollectionProvider
                {
                    Microsoft.AspNetCore.Mvc.Infrastructure.ActionDescriptorCollection ActionDescriptors { get; }
                }
                public interface IActionInvokerFactory
                {
                    Microsoft.AspNetCore.Mvc.Abstractions.IActionInvoker CreateInvoker(Microsoft.AspNetCore.Mvc.ActionContext actionContext);
                }
                public interface IActionResultExecutor<TResult> where TResult : Microsoft.AspNetCore.Mvc.IActionResult
                {
                    System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, TResult result);
                }
                public interface IActionResultTypeMapper
                {
                    Microsoft.AspNetCore.Mvc.IActionResult Convert(object value, System.Type returnType);
                    System.Type GetResultDataType(System.Type returnType);
                }
                public interface IActionSelector
                {
                    Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor SelectBestCandidate(Microsoft.AspNetCore.Routing.RouteContext context, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> candidates);
                    System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> SelectCandidates(Microsoft.AspNetCore.Routing.RouteContext context);
                }
                public interface IApiBehaviorMetadata : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }
                public interface IClientErrorActionResult : Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult
                {
                }
                public interface IClientErrorFactory
                {
                    Microsoft.AspNetCore.Mvc.IActionResult GetClientError(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.Infrastructure.IClientErrorActionResult clientError);
                }
                public interface ICompatibilitySwitch
                {
                    bool IsValueSet { get; }
                    string Name { get; }
                    object Value { get; set; }
                }
                public interface IConvertToActionResult
                {
                    Microsoft.AspNetCore.Mvc.IActionResult Convert();
                }
                public interface IHttpRequestStreamReaderFactory
                {
                    System.IO.TextReader CreateReader(System.IO.Stream stream, System.Text.Encoding encoding);
                }
                public interface IHttpResponseStreamWriterFactory
                {
                    System.IO.TextWriter CreateWriter(System.IO.Stream stream, System.Text.Encoding encoding);
                }
                public interface IParameterInfoParameterDescriptor
                {
                    System.Reflection.ParameterInfo ParameterInfo { get; }
                }
                public interface IPropertyInfoParameterDescriptor
                {
                    System.Reflection.PropertyInfo PropertyInfo { get; }
                }
                public interface IStatusCodeActionResult : Microsoft.AspNetCore.Mvc.IActionResult
                {
                    int? StatusCode { get; }
                }
                public class LocalRedirectResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.LocalRedirectResult>
                {
                    public LocalRedirectResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.LocalRedirectResult result) => throw null;
                }
                public class ModelStateInvalidFilter : Microsoft.AspNetCore.Mvc.Filters.IActionFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
                {
                    public ModelStateInvalidFilter(Microsoft.AspNetCore.Mvc.ApiBehaviorOptions apiBehaviorOptions, Microsoft.Extensions.Logging.ILogger logger) => throw null;
                    public bool IsReusable { get => throw null; }
                    public void OnActionExecuted(Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext context) => throw null;
                    public void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context) => throw null;
                    public int Order { get => throw null; }
                }
                public class MvcCompatibilityOptions
                {
                    public Microsoft.AspNetCore.Mvc.CompatibilityVersion CompatibilityVersion { get => throw null; set { } }
                    public MvcCompatibilityOptions() => throw null;
                }
                public class ObjectResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.ObjectResult>
                {
                    public ObjectResultExecutor(Microsoft.AspNetCore.Mvc.Infrastructure.OutputFormatterSelector formatterSelector, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> mvcOptions) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.ObjectResult result) => throw null;
                    protected Microsoft.AspNetCore.Mvc.Infrastructure.OutputFormatterSelector FormatterSelector { get => throw null; }
                    protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                    protected System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextWriter> WriterFactory { get => throw null; }
                }
                public abstract class OutputFormatterSelector
                {
                    protected OutputFormatterSelector() => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter SelectFormatter(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter> formatters, Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection mediaTypes);
                }
                public class PhysicalFileResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.FileResultExecutorBase, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.PhysicalFileResult>
                {
                    public PhysicalFileResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.Extensions.Logging.ILogger)) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.PhysicalFileResult result) => throw null;
                    protected class FileMetadata
                    {
                        public FileMetadata() => throw null;
                        public bool Exists { get => throw null; set { } }
                        public System.DateTimeOffset LastModified { get => throw null; set { } }
                        public long Length { get => throw null; set { } }
                    }
                    protected virtual Microsoft.AspNetCore.Mvc.Infrastructure.PhysicalFileResultExecutor.FileMetadata GetFileInfo(string path) => throw null;
                    protected virtual System.IO.Stream GetFileStream(string path) => throw null;
                    protected virtual System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.PhysicalFileResult result, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, long rangeLength) => throw null;
                }
                public abstract class ProblemDetailsFactory
                {
                    public abstract Microsoft.AspNetCore.Mvc.ProblemDetails CreateProblemDetails(Microsoft.AspNetCore.Http.HttpContext httpContext, int? statusCode = default(int?), string title = default(string), string type = default(string), string detail = default(string), string instance = default(string));
                    public abstract Microsoft.AspNetCore.Mvc.ValidationProblemDetails CreateValidationProblemDetails(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelStateDictionary, int? statusCode = default(int?), string title = default(string), string type = default(string), string detail = default(string), string instance = default(string));
                    protected ProblemDetailsFactory() => throw null;
                }
                public class RedirectResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.RedirectResult>
                {
                    public RedirectResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.RedirectResult result) => throw null;
                }
                public class RedirectToActionResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.RedirectToActionResult>
                {
                    public RedirectToActionResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.RedirectToActionResult result) => throw null;
                }
                public class RedirectToPageResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.RedirectToPageResult>
                {
                    public RedirectToPageResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.RedirectToPageResult result) => throw null;
                }
                public class RedirectToRouteResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.RedirectToRouteResult>
                {
                    public RedirectToRouteResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.RedirectToRouteResult result) => throw null;
                }
                public class VirtualFileResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.FileResultExecutorBase, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.VirtualFileResult>
                {
                    public VirtualFileResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnvironment) : base(default(Microsoft.Extensions.Logging.ILogger)) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.VirtualFileResult result) => throw null;
                    protected virtual System.IO.Stream GetFileStream(Microsoft.Extensions.FileProviders.IFileInfo fileInfo) => throw null;
                    protected virtual System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.VirtualFileResult result, Microsoft.Extensions.FileProviders.IFileInfo fileInfo, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, long rangeLength) => throw null;
                }
            }
            public interface IRequestFormLimitsPolicy : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
            }
            public interface IRequestSizePolicy : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
            }
            public class JsonOptions
            {
                public bool AllowInputFormatterExceptionMessages { get => throw null; set { } }
                public JsonOptions() => throw null;
                public System.Text.Json.JsonSerializerOptions JsonSerializerOptions { get => throw null; }
            }
            public class JsonResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult
            {
                public string ContentType { get => throw null; set { } }
                public JsonResult(object value) => throw null;
                public JsonResult(object value, object serializerSettings) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public object SerializerSettings { get => throw null; set { } }
                public int? StatusCode { get => throw null; set { } }
                public object Value { get => throw null; set { } }
            }
            public class LocalRedirectResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public LocalRedirectResult(string localUrl) => throw null;
                public LocalRedirectResult(string localUrl, bool permanent) => throw null;
                public LocalRedirectResult(string localUrl, bool permanent, bool preserveMethod) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public bool Permanent { get => throw null; set { } }
                public bool PreserveMethod { get => throw null; set { } }
                public string Url { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
            public class MiddlewareFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
            {
                public System.Type ConfigurationType { get => throw null; }
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public MiddlewareFilterAttribute(System.Type configurationType) => throw null;
                public bool IsReusable { get => throw null; }
                public int Order { get => throw null; set { } }
            }
            public class MiddlewareFilterAttribute<T> : Microsoft.AspNetCore.Mvc.MiddlewareFilterAttribute
            {
                public MiddlewareFilterAttribute() : base(default(System.Type)) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)2204, AllowMultiple = false, Inherited = true)]
            public class ModelBinderAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBinderTypeProviderMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider
            {
                public System.Type BinderType { get => throw null; set { } }
                public virtual Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set { } }
                public ModelBinderAttribute() => throw null;
                public ModelBinderAttribute(System.Type binderType) => throw null;
                public string Name { get => throw null; set { } }
            }
            public class ModelBinderAttribute<TBinder> : Microsoft.AspNetCore.Mvc.ModelBinderAttribute where TBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
            {
                public ModelBinderAttribute() => throw null;
            }
            namespace ModelBinding
            {
                namespace Binders
                {
                    public class ArrayModelBinder<TElement> : Microsoft.AspNetCore.Mvc.ModelBinding.Binders.CollectionModelBinder<TElement>
                    {
                        public override bool CanCreateInstance(System.Type targetType) => throw null;
                        protected override object ConvertToCollectionType(System.Type targetType, System.Collections.Generic.IEnumerable<TElement> collection) => throw null;
                        protected override void CopyToModel(object target, System.Collections.Generic.IEnumerable<TElement> sourceCollection) => throw null;
                        protected override object CreateEmptyCollection(System.Type targetType) => throw null;
                        public ArrayModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public ArrayModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public ArrayModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes, Microsoft.AspNetCore.Mvc.MvcOptions mvcOptions) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                    }
                    public class ArrayModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public ArrayModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class BinderTypeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public BinderTypeModelBinder(System.Type binderType) => throw null;
                    }
                    public class BinderTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public BinderTypeModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class BodyModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public BodyModelBinder(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory) => throw null;
                        public BodyModelBinder(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public BodyModelBinder(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                    }
                    public class BodyModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public BodyModelBinderProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory) => throw null;
                        public BodyModelBinderProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public BodyModelBinderProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class ByteArrayModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public ByteArrayModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }
                    public class ByteArrayModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public ByteArrayModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class CancellationTokenModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public CancellationTokenModelBinder() => throw null;
                    }
                    public class CancellationTokenModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public CancellationTokenModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class CollectionModelBinder<TElement> : Microsoft.AspNetCore.Mvc.ModelBinding.ICollectionModelBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        protected void AddErrorIfBindingRequired(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public virtual System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public virtual bool CanCreateInstance(System.Type targetType) => throw null;
                        protected virtual object ConvertToCollectionType(System.Type targetType, System.Collections.Generic.IEnumerable<TElement> collection) => throw null;
                        protected virtual void CopyToModel(object target, System.Collections.Generic.IEnumerable<TElement> sourceCollection) => throw null;
                        protected virtual object CreateEmptyCollection(System.Type targetType) => throw null;
                        protected object CreateInstance(System.Type targetType) => throw null;
                        public CollectionModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public CollectionModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes) => throw null;
                        public CollectionModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes, Microsoft.AspNetCore.Mvc.MvcOptions mvcOptions) => throw null;
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder ElementBinder { get => throw null; }
                        protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                    }
                    public class CollectionModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public CollectionModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public sealed class ComplexObjectModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                    }
                    public class ComplexObjectModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public ComplexObjectModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class ComplexTypeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        protected virtual System.Threading.Tasks.Task BindProperty(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        protected virtual bool CanBindProperty(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata propertyMetadata) => throw null;
                        protected virtual object CreateModel(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public ComplexTypeModelBinder(System.Collections.Generic.IDictionary<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder> propertyBinders, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public ComplexTypeModelBinder(System.Collections.Generic.IDictionary<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder> propertyBinders, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes) => throw null;
                        protected virtual void SetProperty(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext, string modelName, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata propertyMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult result) => throw null;
                    }
                    public class ComplexTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public ComplexTypeModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class DateTimeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public DateTimeModelBinder(System.Globalization.DateTimeStyles supportedStyles, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }
                    public class DateTimeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public DateTimeModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class DecimalModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public DecimalModelBinder(System.Globalization.NumberStyles supportedStyles, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }
                    public class DictionaryModelBinder<TKey, TValue> : Microsoft.AspNetCore.Mvc.ModelBinding.Binders.CollectionModelBinder<System.Collections.Generic.KeyValuePair<TKey, TValue>>
                    {
                        public override System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public override bool CanCreateInstance(System.Type targetType) => throw null;
                        protected override object ConvertToCollectionType(System.Type targetType, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>> collection) => throw null;
                        protected override object CreateEmptyCollection(System.Type targetType) => throw null;
                        public DictionaryModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder keyBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder valueBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public DictionaryModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder keyBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder valueBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public DictionaryModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder keyBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder valueBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes, Microsoft.AspNetCore.Mvc.MvcOptions mvcOptions) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                    }
                    public class DictionaryModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public DictionaryModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class DoubleModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public DoubleModelBinder(System.Globalization.NumberStyles supportedStyles, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }
                    public class EnumTypeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.Binders.SimpleTypeModelBinder
                    {
                        protected override void CheckModel(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult valueProviderResult, object model) => throw null;
                        public EnumTypeModelBinder(bool suppressBindingUndefinedValueToEnumType, System.Type modelType, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(System.Type), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                    }
                    public class EnumTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public EnumTypeModelBinderProvider(Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class FloatingPointTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public FloatingPointTypeModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class FloatModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public FloatModelBinder(System.Globalization.NumberStyles supportedStyles, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }
                    public class FormCollectionModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public FormCollectionModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }
                    public class FormCollectionModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public FormCollectionModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class FormFileModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public FormFileModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }
                    public class FormFileModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public FormFileModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class HeaderModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public HeaderModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public HeaderModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder innerModelBinder) => throw null;
                    }
                    public class HeaderModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public HeaderModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class KeyValuePairModelBinder<TKey, TValue> : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public KeyValuePairModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder keyBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder valueBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }
                    public class KeyValuePairModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public KeyValuePairModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class ServicesModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public ServicesModelBinder() => throw null;
                    }
                    public class ServicesModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public ServicesModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public class SimpleTypeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        protected virtual void CheckModel(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult valueProviderResult, object model) => throw null;
                        public SimpleTypeModelBinder(System.Type type, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }
                    public class SimpleTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public SimpleTypeModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                    public sealed class TryParseModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public TryParseModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }
                }
                public enum BindingBehavior
                {
                    Optional = 0,
                    Never = 1,
                    Required = 2,
                }
                [System.AttributeUsage((System.AttributeTargets)2180, AllowMultiple = false, Inherited = true)]
                public class BindingBehaviorAttribute : System.Attribute
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehavior Behavior { get => throw null; }
                    public BindingBehaviorAttribute(Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehavior behavior) => throw null;
                }
                public abstract class BindingSourceValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                    public abstract bool ContainsPrefix(string prefix);
                    public BindingSourceValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key);
                }
                [System.AttributeUsage((System.AttributeTargets)2180, AllowMultiple = false, Inherited = true)]
                public sealed class BindNeverAttribute : Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehaviorAttribute
                {
                    public BindNeverAttribute() : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehavior)) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)2180, AllowMultiple = false, Inherited = true)]
                public sealed class BindRequiredAttribute : Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehaviorAttribute
                {
                    public BindRequiredAttribute() : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehavior)) => throw null;
                }
                public class CompositeValueProvider : System.Collections.ObjectModel.Collection<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider>, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IEnumerableValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IKeyRewriterValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    public virtual bool ContainsPrefix(string prefix) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.ModelBinding.CompositeValueProvider> CreateAsync(Microsoft.AspNetCore.Mvc.ControllerContext controllerContext) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.ModelBinding.CompositeValueProvider> CreateAsync(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> factories) => throw null;
                    public CompositeValueProvider() => throw null;
                    public CompositeValueProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider> valueProviders) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter() => throw null;
                    public virtual System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected override void InsertItem(int index, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider item) => throw null;
                    protected override void SetItem(int index, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider item) => throw null;
                }
                public class DefaultModelBindingContext : Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext
                {
                    public override Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; set { } }
                    public override string BinderModelName { get => throw null; set { } }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set { } }
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext CreateBindingContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo bindingInfo, string modelName) => throw null;
                    public DefaultModelBindingContext() => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext.NestedScope EnterNestedScope(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, string fieldName, string modelName, object model) => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext.NestedScope EnterNestedScope() => throw null;
                    protected override void ExitNestedScope() => throw null;
                    public override string FieldName { get => throw null; set { } }
                    public override bool IsTopLevelObject { get => throw null; set { } }
                    public override object Model { get => throw null; set { } }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; set { } }
                    public override string ModelName { get => throw null; set { } }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider OriginalValueProvider { get => throw null; set { } }
                    public override System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get => throw null; set { } }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult Result { get => throw null; set { } }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary ValidationState { get => throw null; set { } }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider ValueProvider { get => throw null; set { } }
                }
                public class DefaultPropertyFilterProvider<TModel> : Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider where TModel : class
                {
                    public DefaultPropertyFilterProvider() => throw null;
                    public virtual string Prefix { get => throw null; }
                    public virtual System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get => throw null; }
                    public virtual System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression<System.Func<TModel, object>>> PropertyIncludeExpressions { get => throw null; }
                }
                public class EmptyModelMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelMetadataProvider
                {
                    public EmptyModelMetadataProvider() : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider)) => throw null;
                }
                public sealed class FormFileValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    public bool ContainsPrefix(string prefix) => throw null;
                    public FormFileValueProvider(Microsoft.AspNetCore.Http.IFormFileCollection files) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                }
                public sealed class FormFileValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public FormFileValueProviderFactory() => throw null;
                }
                public class FormValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSourceValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IEnumerableValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    public override bool ContainsPrefix(string prefix) => throw null;
                    public FormValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, Microsoft.AspNetCore.Http.IFormCollection values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                    public System.Globalization.CultureInfo Culture { get => throw null; }
                    public virtual System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.PrefixContainer PrefixContainer { get => throw null; }
                }
                public class FormValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public FormValueProviderFactory() => throw null;
                }
                public interface IBindingSourceValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource);
                }
                public interface ICollectionModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                {
                    bool CanCreateInstance(System.Type targetType);
                }
                public interface IEnumerableValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix);
                }
                public interface IKeyRewriterValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter();
                }
                public interface IModelBinderFactory
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder CreateBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderFactoryContext context);
                }
                public class JQueryFormValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.JQueryValueProvider
                {
                    public JQueryFormValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues> values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource), default(System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>), default(System.Globalization.CultureInfo)) => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                }
                public class JQueryFormValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public JQueryFormValueProviderFactory() => throw null;
                }
                public class JQueryQueryStringValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.JQueryValueProvider
                {
                    public JQueryQueryStringValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues> values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource), default(System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>), default(System.Globalization.CultureInfo)) => throw null;
                }
                public class JQueryQueryStringValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public JQueryQueryStringValueProviderFactory() => throw null;
                }
                public abstract class JQueryValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSourceValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IEnumerableValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IKeyRewriterValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    public override bool ContainsPrefix(string prefix) => throw null;
                    protected JQueryValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues> values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                    public System.Globalization.CultureInfo Culture { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter() => throw null;
                    public System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.PrefixContainer PrefixContainer { get => throw null; }
                }
                namespace Metadata
                {
                    public class BindingMetadata
                    {
                        public string BinderModelName { get => throw null; set { } }
                        public System.Type BinderType { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set { } }
                        public System.Reflection.ConstructorInfo BoundConstructor { get => throw null; set { } }
                        public BindingMetadata() => throw null;
                        public bool IsBindingAllowed { get => throw null; set { } }
                        public bool IsBindingRequired { get => throw null; set { } }
                        public bool? IsReadOnly { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider ModelBindingMessageProvider { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider PropertyFilterProvider { get => throw null; set { } }
                    }
                    public class BindingMetadataProviderContext
                    {
                        public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadata BindingMetadata { get => throw null; }
                        public BindingMetadataProviderContext(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key, Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes attributes) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity Key { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> ParameterAttributes { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> PropertyAttributes { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> TypeAttributes { get => throw null; }
                    }
                    public class BindingSourceMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IBindingMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                        public void CreateBindingMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadataProviderContext context) => throw null;
                        public BindingSourceMetadataProvider(System.Type type, Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                        public System.Type Type { get => throw null; }
                    }
                    public class DefaultMetadataDetails
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadata BindingMetadata { get => throw null; set { } }
                        public System.Func<object[], object> BoundConstructorInvoker { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata[] BoundConstructorParameters { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ContainerMetadata { get => throw null; set { } }
                        public DefaultMetadataDetails(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key, Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes attributes) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadata DisplayMetadata { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity Key { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes ModelAttributes { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata[] Properties { get => throw null; set { } }
                        public System.Func<object, object> PropertyGetter { get => throw null; set { } }
                        public System.Action<object, object> PropertySetter { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadata ValidationMetadata { get => throw null; set { } }
                    }
                    public class DefaultModelBindingMessageProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelBindingMessageProvider
                    {
                        public override System.Func<string, string, string> AttemptedValueIsInvalidAccessor { get => throw null; }
                        public DefaultModelBindingMessageProvider() => throw null;
                        public DefaultModelBindingMessageProvider(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider originalProvider) => throw null;
                        public override System.Func<string, string> MissingBindRequiredValueAccessor { get => throw null; }
                        public override System.Func<string> MissingKeyOrValueAccessor { get => throw null; }
                        public override System.Func<string> MissingRequestBodyRequiredValueAccessor { get => throw null; }
                        public override System.Func<string, string> NonPropertyAttemptedValueIsInvalidAccessor { get => throw null; }
                        public override System.Func<string> NonPropertyUnknownValueIsInvalidAccessor { get => throw null; }
                        public override System.Func<string> NonPropertyValueMustBeANumberAccessor { get => throw null; }
                        public void SetAttemptedValueIsInvalidAccessor(System.Func<string, string, string> attemptedValueIsInvalidAccessor) => throw null;
                        public void SetMissingBindRequiredValueAccessor(System.Func<string, string> missingBindRequiredValueAccessor) => throw null;
                        public void SetMissingKeyOrValueAccessor(System.Func<string> missingKeyOrValueAccessor) => throw null;
                        public void SetMissingRequestBodyRequiredValueAccessor(System.Func<string> missingRequestBodyRequiredValueAccessor) => throw null;
                        public void SetNonPropertyAttemptedValueIsInvalidAccessor(System.Func<string, string> nonPropertyAttemptedValueIsInvalidAccessor) => throw null;
                        public void SetNonPropertyUnknownValueIsInvalidAccessor(System.Func<string> nonPropertyUnknownValueIsInvalidAccessor) => throw null;
                        public void SetNonPropertyValueMustBeANumberAccessor(System.Func<string> nonPropertyValueMustBeANumberAccessor) => throw null;
                        public void SetUnknownValueIsInvalidAccessor(System.Func<string, string> unknownValueIsInvalidAccessor) => throw null;
                        public void SetValueIsInvalidAccessor(System.Func<string, string> valueIsInvalidAccessor) => throw null;
                        public void SetValueMustBeANumberAccessor(System.Func<string, string> valueMustBeANumberAccessor) => throw null;
                        public void SetValueMustNotBeNullAccessor(System.Func<string, string> valueMustNotBeNullAccessor) => throw null;
                        public override System.Func<string, string> UnknownValueIsInvalidAccessor { get => throw null; }
                        public override System.Func<string, string> ValueIsInvalidAccessor { get => throw null; }
                        public override System.Func<string, string> ValueMustBeANumberAccessor { get => throw null; }
                        public override System.Func<string, string> ValueMustNotBeNullAccessor { get => throw null; }
                    }
                    public class DefaultModelMetadata : Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata
                    {
                        public override System.Collections.Generic.IReadOnlyDictionary<object, object> AdditionalValues { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes Attributes { get => throw null; }
                        public override string BinderModelName { get => throw null; }
                        public override System.Type BinderType { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadata BindingMetadata { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata BoundConstructor { get => throw null; }
                        public override System.Func<object[], object> BoundConstructorInvoker { get => throw null; }
                        public override System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> BoundConstructorParameters { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ContainerMetadata { get => throw null; }
                        public override bool ConvertEmptyStringToNull { get => throw null; }
                        public DefaultModelMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider provider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider detailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails details) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity)) => throw null;
                        public DefaultModelMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider provider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider detailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails details, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider modelBindingMessageProvider) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity)) => throw null;
                        public override string DataTypeName { get => throw null; }
                        public override string Description { get => throw null; }
                        public override string DisplayFormatString { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadata DisplayMetadata { get => throw null; }
                        public override string DisplayName { get => throw null; }
                        public override string EditFormatString { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ElementMetadata { get => throw null; }
                        public override System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<Microsoft.AspNetCore.Mvc.ModelBinding.EnumGroupAndName, string>> EnumGroupedDisplayNamesAndValues { get => throw null; }
                        public override System.Collections.Generic.IReadOnlyDictionary<string, string> EnumNamesAndValues { get => throw null; }
                        public override System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> GetMetadataForProperties(System.Type modelType) => throw null;
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForType(System.Type modelType) => throw null;
                        public override bool HasNonDefaultEditFormat { get => throw null; }
                        public override bool? HasValidators { get => throw null; }
                        public override bool HideSurroundingHtml { get => throw null; }
                        public override bool HtmlEncode { get => throw null; }
                        public override bool IsBindingAllowed { get => throw null; }
                        public override bool IsBindingRequired { get => throw null; }
                        public override bool IsEnum { get => throw null; }
                        public override bool IsFlagsEnum { get => throw null; }
                        public override bool IsReadOnly { get => throw null; }
                        public override bool IsRequired { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelBindingMessageProvider ModelBindingMessageProvider { get => throw null; }
                        public override string NullDisplayText { get => throw null; }
                        public override int Order { get => throw null; }
                        public override string Placeholder { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelPropertyCollection Properties { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider PropertyFilterProvider { get => throw null; }
                        public override System.Func<object, object> PropertyGetter { get => throw null; }
                        public override System.Action<object, object> PropertySetter { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IPropertyValidationFilter PropertyValidationFilter { get => throw null; }
                        public override bool ShowForDisplay { get => throw null; }
                        public override bool ShowForEdit { get => throw null; }
                        public override string SimpleDisplayProperty { get => throw null; }
                        public override string TemplateHint { get => throw null; }
                        public override bool ValidateChildren { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadata ValidationMetadata { get => throw null; }
                        public override System.Collections.Generic.IReadOnlyList<object> ValidatorMetadata { get => throw null; }
                    }
                    public class DefaultModelMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadataProvider
                    {
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata CreateModelMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails entry) => throw null;
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails CreateParameterDetails(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key) => throw null;
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails[] CreatePropertyDetails(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key) => throw null;
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails CreateTypeDetails(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key) => throw null;
                        public DefaultModelMetadataProvider(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider detailsProvider) => throw null;
                        public DefaultModelMetadataProvider(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider detailsProvider, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> optionsAccessor) => throw null;
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider DetailsProvider { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForConstructor(System.Reflection.ConstructorInfo constructorInfo, System.Type modelType) => throw null;
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForParameter(System.Reflection.ParameterInfo parameter) => throw null;
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForParameter(System.Reflection.ParameterInfo parameter, System.Type modelType) => throw null;
                        public override System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> GetMetadataForProperties(System.Type modelType) => throw null;
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForProperty(System.Reflection.PropertyInfo propertyInfo, System.Type modelType) => throw null;
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForType(System.Type modelType) => throw null;
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider ModelBindingMessageProvider { get => throw null; }
                    }
                    public class DisplayMetadata
                    {
                        public System.Collections.Generic.IDictionary<object, object> AdditionalValues { get => throw null; }
                        public bool ConvertEmptyStringToNull { get => throw null; set { } }
                        public DisplayMetadata() => throw null;
                        public string DataTypeName { get => throw null; set { } }
                        public System.Func<string> Description { get => throw null; set { } }
                        public string DisplayFormatString { get => throw null; set { } }
                        public System.Func<string> DisplayFormatStringProvider { get => throw null; set { } }
                        public System.Func<string> DisplayName { get => throw null; set { } }
                        public string EditFormatString { get => throw null; set { } }
                        public System.Func<string> EditFormatStringProvider { get => throw null; set { } }
                        public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<Microsoft.AspNetCore.Mvc.ModelBinding.EnumGroupAndName, string>> EnumGroupedDisplayNamesAndValues { get => throw null; set { } }
                        public System.Collections.Generic.IReadOnlyDictionary<string, string> EnumNamesAndValues { get => throw null; set { } }
                        public bool HasNonDefaultEditFormat { get => throw null; set { } }
                        public bool HideSurroundingHtml { get => throw null; set { } }
                        public bool HtmlEncode { get => throw null; set { } }
                        public bool IsEnum { get => throw null; set { } }
                        public bool IsFlagsEnum { get => throw null; set { } }
                        public string NullDisplayText { get => throw null; set { } }
                        public System.Func<string> NullDisplayTextProvider { get => throw null; set { } }
                        public int Order { get => throw null; set { } }
                        public System.Func<string> Placeholder { get => throw null; set { } }
                        public bool ShowForDisplay { get => throw null; set { } }
                        public bool ShowForEdit { get => throw null; set { } }
                        public string SimpleDisplayProperty { get => throw null; set { } }
                        public string TemplateHint { get => throw null; set { } }
                    }
                    public class DisplayMetadataProviderContext
                    {
                        public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                        public DisplayMetadataProviderContext(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key, Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes attributes) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadata DisplayMetadata { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity Key { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> PropertyAttributes { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> TypeAttributes { get => throw null; }
                    }
                    public class ExcludeBindingMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IBindingMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                    {
                        public void CreateBindingMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadataProviderContext context) => throw null;
                        public ExcludeBindingMetadataProvider(System.Type type) => throw null;
                    }
                    public interface IBindingMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                    {
                        void CreateBindingMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadataProviderContext context);
                    }
                    public interface ICompositeMetadataDetailsProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IBindingMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IDisplayMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IValidationMetadataProvider
                    {
                    }
                    public interface IDisplayMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                    {
                        void CreateDisplayMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadataProviderContext context);
                    }
                    public interface IMetadataDetailsProvider
                    {
                    }
                    public interface IValidationMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                    {
                        void CreateValidationMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadataProviderContext context);
                    }
                    public static partial class MetadataDetailsProviderExtensions
                    {
                        public static void RemoveType<TMetadataDetailsProvider>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider> list) where TMetadataDetailsProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider => throw null;
                        public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider> list, System.Type type) => throw null;
                    }
                    public sealed class SystemTextJsonValidationMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IDisplayMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IValidationMetadataProvider
                    {
                        public void CreateDisplayMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadataProviderContext context) => throw null;
                        public void CreateValidationMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadataProviderContext context) => throw null;
                        public SystemTextJsonValidationMetadataProvider() => throw null;
                        public SystemTextJsonValidationMetadataProvider(System.Text.Json.JsonNamingPolicy namingPolicy) => throw null;
                    }
                    public class ValidationMetadata
                    {
                        public ValidationMetadata() => throw null;
                        public bool? HasValidators { get => throw null; set { } }
                        public bool? IsRequired { get => throw null; set { } }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IPropertyValidationFilter PropertyValidationFilter { get => throw null; set { } }
                        public bool? ValidateChildren { get => throw null; set { } }
                        public string ValidationModelName { get => throw null; set { } }
                        public System.Collections.Generic.IList<object> ValidatorMetadata { get => throw null; }
                    }
                    public class ValidationMetadataProviderContext
                    {
                        public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                        public ValidationMetadataProviderContext(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key, Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes attributes) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity Key { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> ParameterAttributes { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> PropertyAttributes { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> TypeAttributes { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadata ValidationMetadata { get => throw null; }
                    }
                }
                public class ModelAttributes
                {
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForParameter(System.Reflection.ParameterInfo parameterInfo) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForParameter(System.Reflection.ParameterInfo parameterInfo, System.Type modelType) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForProperty(System.Type type, System.Reflection.PropertyInfo property) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForProperty(System.Type containerType, System.Reflection.PropertyInfo property, System.Type modelType) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForType(System.Type type) => throw null;
                    public System.Collections.Generic.IReadOnlyList<object> ParameterAttributes { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<object> PropertyAttributes { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<object> TypeAttributes { get => throw null; }
                }
                public class ModelBinderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderFactory
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder CreateBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderFactoryContext context) => throw null;
                    public ModelBinderFactory(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> options, System.IServiceProvider serviceProvider) => throw null;
                }
                public class ModelBinderFactoryContext
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get => throw null; set { } }
                    public object CacheToken { get => throw null; set { } }
                    public ModelBinderFactoryContext() => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; set { } }
                }
                public static partial class ModelBinderProviderExtensions
                {
                    public static void RemoveType<TModelBinderProvider>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider> list) where TModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider => throw null;
                    public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider> list, System.Type type) => throw null;
                }
                public static partial class ModelMetadataProviderExtensions
                {
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForProperty(this Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider provider, System.Type containerType, string propertyName) => throw null;
                }
                public static class ModelNames
                {
                    public static string CreateIndexModelName(string parentName, int index) => throw null;
                    public static string CreateIndexModelName(string parentName, string index) => throw null;
                    public static string CreatePropertyModelName(string prefix, string propertyName) => throw null;
                }
                public abstract class ObjectModelValidator : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IObjectModelValidator
                {
                    public ObjectModelValidator(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> validatorProviders) => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor GetValidationVisitor(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider validatorProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorCache validatorCache, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState);
                    public virtual void Validate(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState, string prefix, object model) => throw null;
                    public virtual void Validate(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState, string prefix, object model, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata) => throw null;
                    public virtual void Validate(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState, string prefix, object model, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object container) => throw null;
                }
                public class ParameterBinder
                {
                    public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult> BindModelAsync(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder modelBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor parameter, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object value) => throw null;
                    public virtual System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult> BindModelAsync(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder modelBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor parameter, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object value, object container) => throw null;
                    public ParameterBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderFactory modelBinderFactory, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IObjectModelValidator validator, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> mvcOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                }
                public class PrefixContainer
                {
                    public bool ContainsPrefix(string prefix) => throw null;
                    public PrefixContainer(System.Collections.Generic.ICollection<string> values) => throw null;
                    public System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                }
                public class QueryStringValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSourceValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IEnumerableValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    public override bool ContainsPrefix(string prefix) => throw null;
                    public QueryStringValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, Microsoft.AspNetCore.Http.IQueryCollection values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                    public System.Globalization.CultureInfo Culture { get => throw null; }
                    public virtual System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.PrefixContainer PrefixContainer { get => throw null; }
                }
                public class QueryStringValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public QueryStringValueProviderFactory() => throw null;
                }
                public class RouteValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSourceValueProvider
                {
                    public override bool ContainsPrefix(string key) => throw null;
                    public RouteValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, Microsoft.AspNetCore.Routing.RouteValueDictionary values) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                    public RouteValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, Microsoft.AspNetCore.Routing.RouteValueDictionary values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                    protected System.Globalization.CultureInfo Culture { get => throw null; }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.PrefixContainer PrefixContainer { get => throw null; }
                }
                public class RouteValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public RouteValueProviderFactory() => throw null;
                }
                public class SuppressChildValidationMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IValidationMetadataProvider
                {
                    public void CreateValidationMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadataProviderContext context) => throw null;
                    public SuppressChildValidationMetadataProvider(System.Type type) => throw null;
                    public SuppressChildValidationMetadataProvider(string fullTypeName) => throw null;
                    public string FullTypeName { get => throw null; }
                    public System.Type Type { get => throw null; }
                }
                public class UnsupportedContentTypeException : System.Exception
                {
                    public UnsupportedContentTypeException(string message) => throw null;
                }
                public class UnsupportedContentTypeFilter : Microsoft.AspNetCore.Mvc.Filters.IActionFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
                {
                    public UnsupportedContentTypeFilter() => throw null;
                    public void OnActionExecuted(Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext context) => throw null;
                    public void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context) => throw null;
                    public int Order { get => throw null; set { } }
                }
                namespace Validation
                {
                    public class ClientValidatorCache
                    {
                        public ClientValidatorCache() => throw null;
                        public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator> GetValidators(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider validatorProvider) => throw null;
                    }
                    public class CompositeClientModelValidatorProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider
                    {
                        public void CreateValidators(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorProviderContext context) => throw null;
                        public CompositeClientModelValidatorProvider(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider> providers) => throw null;
                        public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider> ValidatorProviders { get => throw null; }
                    }
                    public class CompositeModelValidatorProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider
                    {
                        public void CreateValidators(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidatorProviderContext context) => throw null;
                        public CompositeModelValidatorProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> providers) => throw null;
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> ValidatorProviders { get => throw null; }
                    }
                    public interface IMetadataBasedModelValidatorProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider
                    {
                        bool HasValidators(System.Type modelType, System.Collections.Generic.IList<object> validatorMetadata);
                    }
                    public interface IObjectModelValidator
                    {
                        void Validate(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState, string prefix, object model);
                    }
                    public static partial class ModelValidatorProviderExtensions
                    {
                        public static void RemoveType<TModelValidatorProvider>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> list) where TModelValidatorProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider => throw null;
                        public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> list, System.Type type) => throw null;
                    }
                    [System.AttributeUsage((System.AttributeTargets)2180, AllowMultiple = false, Inherited = true)]
                    public sealed class ValidateNeverAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IPropertyValidationFilter
                    {
                        public ValidateNeverAttribute() => throw null;
                        public bool ShouldValidateEntry(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry entry, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry parentEntry) => throw null;
                    }
                    public class ValidationVisitor
                    {
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorCache Cache { get => throw null; }
                        protected object Container { get => throw null; set { } }
                        protected Microsoft.AspNetCore.Mvc.ActionContext Context { get => throw null; }
                        public ValidationVisitor(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider validatorProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorCache validatorCache, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState) => throw null;
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry GetValidationEntry(object model) => throw null;
                        protected string Key { get => throw null; set { } }
                        public int? MaxValidationDepth { get => throw null; set { } }
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; set { } }
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get => throw null; }
                        protected object Model { get => throw null; set { } }
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                        protected struct StateManager : System.IDisposable
                        {
                            public StateManager(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor visitor, object newModel) => throw null;
                            public void Dispose() => throw null;
                            public static Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor.StateManager Recurse(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor visitor, string key, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object model, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy strategy) => throw null;
                        }
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy Strategy { get => throw null; set { } }
                        protected virtual void SuppressValidation(string key) => throw null;
                        public bool Validate(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model) => throw null;
                        public virtual bool Validate(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model, bool alwaysValidateAtTopLevel) => throw null;
                        public virtual bool Validate(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model, bool alwaysValidateAtTopLevel, object container) => throw null;
                        public bool ValidateComplexTypesIfChildValidationFails { get => throw null; set { } }
                        protected virtual bool ValidateNode() => throw null;
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary ValidationState { get => throw null; }
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider ValidatorProvider { get => throw null; }
                        protected virtual bool Visit(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model) => throw null;
                        protected virtual bool VisitChildren(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy strategy) => throw null;
                        protected virtual bool VisitComplexType(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy defaultStrategy) => throw null;
                        protected virtual bool VisitSimpleType() => throw null;
                    }
                    public class ValidatorCache
                    {
                        public ValidatorCache() => throw null;
                        public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidator> GetValidators(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider validatorProvider) => throw null;
                    }
                }
                public static partial class ValueProviderFactoryExtensions
                {
                    public static void RemoveType<TValueProviderFactory>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> list) where TValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory => throw null;
                    public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> list, System.Type type) => throw null;
                }
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
            public class ModelMetadataTypeAttribute : System.Attribute
            {
                public ModelMetadataTypeAttribute(System.Type type) => throw null;
                public System.Type MetadataType { get => throw null; }
            }
            public class ModelMetadataTypeAttribute<T> : Microsoft.AspNetCore.Mvc.ModelMetadataTypeAttribute
            {
                public ModelMetadataTypeAttribute() : base(default(System.Type)) => throw null;
            }
            public class MvcOptions : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>, System.Collections.IEnumerable
            {
                public bool AllowEmptyInputInBodyModelBinding { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.CacheProfile> CacheProfiles { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> Conventions { get => throw null; }
                public MvcOptions() => throw null;
                public bool EnableActionInvokers { get => throw null; set { } }
                public bool EnableEndpointRouting { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.Filters.FilterCollection Filters { get => throw null; }
                public Microsoft.AspNetCore.Mvc.Formatters.FormatterMappings FormatterMappings { get => throw null; }
                System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public Microsoft.AspNetCore.Mvc.Formatters.FormatterCollection<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> InputFormatters { get => throw null; }
                public int MaxIAsyncEnumerableBufferLimit { get => throw null; set { } }
                public int MaxModelBindingCollectionSize { get => throw null; set { } }
                public int MaxModelBindingRecursionDepth { get => throw null; set { } }
                public int MaxModelValidationErrors { get => throw null; set { } }
                public int? MaxValidationDepth { get => throw null; set { } }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider> ModelBinderProviders { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider ModelBindingMessageProvider { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider> ModelMetadataDetailsProviders { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> ModelValidatorProviders { get => throw null; }
                public Microsoft.AspNetCore.Mvc.Formatters.FormatterCollection<Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter> OutputFormatters { get => throw null; }
                public bool RequireHttpsPermanent { get => throw null; set { } }
                public bool RespectBrowserAcceptHeader { get => throw null; set { } }
                public bool ReturnHttpNotAcceptable { get => throw null; set { } }
                public int? SslPort { get => throw null; set { } }
                public bool SuppressAsyncSuffixInActionNames { get => throw null; set { } }
                public bool SuppressImplicitRequiredAttributeForNonNullableReferenceTypes { get => throw null; set { } }
                public bool SuppressInputFormatterBuffering { get => throw null; set { } }
                public bool SuppressOutputFormatterBuffering { get => throw null; set { } }
                public bool ValidateComplexTypesIfChildValidationFails { get => throw null; set { } }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> ValueProviderFactories { get => throw null; }
            }
            public class NoContentResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public NoContentResult() : base(default(int)) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = true)]
            public sealed class NonActionAttribute : System.Attribute
            {
                public NonActionAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
            public sealed class NonControllerAttribute : System.Attribute
            {
                public NonControllerAttribute() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
            public class NonViewComponentAttribute : System.Attribute
            {
                public NonViewComponentAttribute() => throw null;
            }
            public class NotFoundObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public NotFoundObjectResult(object value) : base(default(object)) => throw null;
            }
            public class NotFoundResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public NotFoundResult() : base(default(int)) => throw null;
            }
            public class ObjectResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult
            {
                public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection ContentTypes { get => throw null; set { } }
                public ObjectResult(object value) => throw null;
                public System.Type DeclaredType { get => throw null; set { } }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Mvc.Formatters.FormatterCollection<Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter> Formatters { get => throw null; set { } }
                public virtual void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public int? StatusCode { get => throw null; set { } }
                public object Value { get => throw null; set { } }
            }
            public class OkObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public OkObjectResult(object value) : base(default(object)) => throw null;
            }
            public class OkResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public OkResult() : base(default(int)) => throw null;
            }
            public class PhysicalFileResult : Microsoft.AspNetCore.Mvc.FileResult
            {
                public PhysicalFileResult(string fileName, string contentType) : base(default(string)) => throw null;
                public PhysicalFileResult(string fileName, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) : base(default(string)) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string FileName { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class ProducesAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IResultFilter
            {
                public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection ContentTypes { get => throw null; set { } }
                public ProducesAttribute(System.Type type) => throw null;
                public ProducesAttribute(string contentType, params string[] additionalContentTypes) => throw null;
                public virtual void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context) => throw null;
                public virtual void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context) => throw null;
                public int Order { get => throw null; set { } }
                public void SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
                public int StatusCode { get => throw null; }
                public System.Type Type { get => throw null; set { } }
            }
            public class ProducesAttribute<T> : Microsoft.AspNetCore.Mvc.ProducesAttribute
            {
                public ProducesAttribute() : base(default(System.Type)) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = true)]
            public sealed class ProducesDefaultResponseTypeAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDefaultResponseMetadataProvider, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
                public ProducesDefaultResponseTypeAttribute() => throw null;
                public ProducesDefaultResponseTypeAttribute(System.Type type) => throw null;
                void Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider.SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
                public int StatusCode { get => throw null; }
                public System.Type Type { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)69, AllowMultiple = false, Inherited = true)]
            public sealed class ProducesErrorResponseTypeAttribute : System.Attribute
            {
                public ProducesErrorResponseTypeAttribute(System.Type type) => throw null;
                public System.Type Type { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
            public class ProducesResponseTypeAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
                public ProducesResponseTypeAttribute(int statusCode) => throw null;
                public ProducesResponseTypeAttribute(System.Type type, int statusCode) => throw null;
                public ProducesResponseTypeAttribute(System.Type type, int statusCode, string contentType, params string[] additionalContentTypes) => throw null;
                void Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider.SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
                public int StatusCode { get => throw null; set { } }
                public System.Type Type { get => throw null; set { } }
            }
            public class ProducesResponseTypeAttribute<T> : Microsoft.AspNetCore.Mvc.ProducesResponseTypeAttribute
            {
                public ProducesResponseTypeAttribute(int statusCode) : base(default(int)) => throw null;
                public ProducesResponseTypeAttribute(int statusCode, string contentType, params string[] additionalContentTypes) : base(default(int)) => throw null;
            }
            public class RedirectResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult
            {
                public RedirectResult(string url) => throw null;
                public RedirectResult(string url, bool permanent) => throw null;
                public RedirectResult(string url, bool permanent, bool preserveMethod) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public bool Permanent { get => throw null; set { } }
                public bool PreserveMethod { get => throw null; set { } }
                public string Url { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set { } }
            }
            public class RedirectToActionResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult
            {
                public string ActionName { get => throw null; set { } }
                public string ControllerName { get => throw null; set { } }
                public RedirectToActionResult(string actionName, string controllerName, object routeValues) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, bool permanent) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, bool permanent, bool preserveMethod) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, bool permanent, string fragment) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, bool permanent, bool preserveMethod, string fragment) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string Fragment { get => throw null; set { } }
                public bool Permanent { get => throw null; set { } }
                public bool PreserveMethod { get => throw null; set { } }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set { } }
            }
            public class RedirectToPageResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult
            {
                public RedirectToPageResult(string pageName) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler) => throw null;
                public RedirectToPageResult(string pageName, object routeValues) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, bool permanent) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, bool permanent, bool preserveMethod) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, bool permanent, string fragment) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, bool permanent, bool preserveMethod, string fragment) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string Fragment { get => throw null; set { } }
                public string Host { get => throw null; set { } }
                public string PageHandler { get => throw null; set { } }
                public string PageName { get => throw null; set { } }
                public bool Permanent { get => throw null; set { } }
                public bool PreserveMethod { get => throw null; set { } }
                public string Protocol { get => throw null; set { } }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set { } }
            }
            public class RedirectToRouteResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult
            {
                public RedirectToRouteResult(object routeValues) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues, bool permanent) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues, bool permanent, bool preserveMethod) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues, string fragment) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues, bool permanent, string fragment) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues, bool permanent, bool preserveMethod, string fragment) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string Fragment { get => throw null; set { } }
                public bool Permanent { get => throw null; set { } }
                public bool PreserveMethod { get => throw null; set { } }
                public string RouteName { get => throw null; set { } }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class RequestFormLimitsAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
            {
                public bool BufferBody { get => throw null; set { } }
                bool? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.BufferBody { get => throw null; }
                public long BufferBodyLengthLimit { get => throw null; set { } }
                long? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.BufferBodyLengthLimit { get => throw null; }
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public RequestFormLimitsAttribute() => throw null;
                public bool IsReusable { get => throw null; }
                public int KeyLengthLimit { get => throw null; set { } }
                int? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.KeyLengthLimit { get => throw null; }
                public int MemoryBufferThreshold { get => throw null; set { } }
                int? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.MemoryBufferThreshold { get => throw null; }
                public long MultipartBodyLengthLimit { get => throw null; set { } }
                long? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.MultipartBodyLengthLimit { get => throw null; }
                public int MultipartBoundaryLengthLimit { get => throw null; set { } }
                int? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.MultipartBoundaryLengthLimit { get => throw null; }
                public int MultipartHeadersCountLimit { get => throw null; set { } }
                int? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.MultipartHeadersCountLimit { get => throw null; }
                public int MultipartHeadersLengthLimit { get => throw null; set { } }
                int? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.MultipartHeadersLengthLimit { get => throw null; }
                public int Order { get => throw null; set { } }
                public int ValueCountLimit { get => throw null; set { } }
                int? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.ValueCountLimit { get => throw null; }
                public int ValueLengthLimit { get => throw null; set { } }
                int? Microsoft.AspNetCore.Http.Metadata.IFormOptionsMetadata.ValueLengthLimit { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class RequestSizeLimitAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Http.Metadata.IRequestSizeLimitMetadata
            {
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public RequestSizeLimitAttribute(long bytes) => throw null;
                public bool IsReusable { get => throw null; }
                long? Microsoft.AspNetCore.Http.Metadata.IRequestSizeLimitMetadata.MaxRequestBodySize { get => throw null; }
                public int Order { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)68, Inherited = true, AllowMultiple = false)]
            public class RequireHttpsAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IAuthorizationFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
            {
                public RequireHttpsAttribute() => throw null;
                protected virtual void HandleNonHttpsRequest(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext filterContext) => throw null;
                public virtual void OnAuthorization(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext filterContext) => throw null;
                public int Order { get => throw null; set { } }
                public bool Permanent { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public class ResponseCacheAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
            {
                public string CacheProfileName { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public ResponseCacheAttribute() => throw null;
                public int Duration { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.CacheProfile GetCacheProfile(Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                public bool IsReusable { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ResponseCacheLocation Location { get => throw null; set { } }
                public bool NoStore { get => throw null; set { } }
                public int Order { get => throw null; set { } }
                public string VaryByHeader { get => throw null; set { } }
                public string[] VaryByQueryKeys { get => throw null; set { } }
            }
            public enum ResponseCacheLocation
            {
                Any = 0,
                Client = 1,
                None = 2,
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
            public class RouteAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider
            {
                public RouteAttribute(string template) => throw null;
                public string Name { get => throw null; set { } }
                public int Order { get => throw null; set { } }
                int? Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider.Order { get => throw null; }
                public string Template { get => throw null; }
            }
            namespace Routing
            {
                public abstract class DynamicRouteValueTransformer
                {
                    protected DynamicRouteValueTransformer() => throw null;
                    public virtual System.Threading.Tasks.ValueTask<System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint>> FilterAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary values, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public object State { get => throw null; set { } }
                    public abstract System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Routing.RouteValueDictionary> TransformAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary values);
                }
                [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = true, Inherited = true)]
                public abstract class HttpMethodAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IActionHttpMethodProvider, Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider
                {
                    public HttpMethodAttribute(System.Collections.Generic.IEnumerable<string> httpMethods) => throw null;
                    public HttpMethodAttribute(System.Collections.Generic.IEnumerable<string> httpMethods, string template) => throw null;
                    public System.Collections.Generic.IEnumerable<string> HttpMethods { get => throw null; }
                    public string Name { get => throw null; set { } }
                    public int Order { get => throw null; set { } }
                    int? Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider.Order { get => throw null; }
                    public string Template { get => throw null; }
                }
                public interface IActionHttpMethodProvider
                {
                    System.Collections.Generic.IEnumerable<string> HttpMethods { get; }
                }
                public interface IRouteTemplateProvider
                {
                    string Name { get; }
                    int? Order { get; }
                    string Template { get; }
                }
                public interface IRouteValueProvider
                {
                    string RouteKey { get; }
                    string RouteValue { get; }
                }
                public interface IUrlHelperFactory
                {
                    Microsoft.AspNetCore.Mvc.IUrlHelper GetUrlHelper(Microsoft.AspNetCore.Mvc.ActionContext context);
                }
                public class KnownRouteValueConstraint : Microsoft.AspNetCore.Routing.IParameterPolicy, Microsoft.AspNetCore.Routing.IRouteConstraint
                {
                    public KnownRouteValueConstraint(Microsoft.AspNetCore.Mvc.Infrastructure.IActionDescriptorCollectionProvider actionDescriptorCollectionProvider) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
                public abstract class RouteValueAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IRouteValueProvider
                {
                    protected RouteValueAttribute(string routeKey, string routeValue) => throw null;
                    public string RouteKey { get => throw null; }
                    public string RouteValue { get => throw null; }
                }
                public class UrlHelper : Microsoft.AspNetCore.Mvc.Routing.UrlHelperBase
                {
                    public override string Action(Microsoft.AspNetCore.Mvc.Routing.UrlActionContext actionContext) => throw null;
                    public UrlHelper(Microsoft.AspNetCore.Mvc.ActionContext actionContext) : base(default(Microsoft.AspNetCore.Mvc.ActionContext)) => throw null;
                    protected virtual string GenerateUrl(string protocol, string host, Microsoft.AspNetCore.Routing.VirtualPathData pathData, string fragment) => throw null;
                    protected virtual Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPathData(string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                    protected Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    protected Microsoft.AspNetCore.Routing.IRouter Router { get => throw null; }
                    public override string RouteUrl(Microsoft.AspNetCore.Mvc.Routing.UrlRouteContext routeContext) => throw null;
                }
                public abstract class UrlHelperBase : Microsoft.AspNetCore.Mvc.IUrlHelper
                {
                    public abstract string Action(Microsoft.AspNetCore.Mvc.Routing.UrlActionContext actionContext);
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    protected Microsoft.AspNetCore.Routing.RouteValueDictionary AmbientValues { get => throw null; }
                    public virtual string Content(string contentPath) => throw null;
                    protected UrlHelperBase(Microsoft.AspNetCore.Mvc.ActionContext actionContext) => throw null;
                    protected string GenerateUrl(string protocol, string host, string virtualPath, string fragment) => throw null;
                    protected string GenerateUrl(string protocol, string host, string path) => throw null;
                    protected Microsoft.AspNetCore.Routing.RouteValueDictionary GetValuesDictionary(object values) => throw null;
                    public virtual bool IsLocalUrl(string url) => throw null;
                    public virtual string Link(string routeName, object values) => throw null;
                    public abstract string RouteUrl(Microsoft.AspNetCore.Mvc.Routing.UrlRouteContext routeContext);
                }
                public class UrlHelperFactory : Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory
                {
                    public UrlHelperFactory() => throw null;
                    public Microsoft.AspNetCore.Mvc.IUrlHelper GetUrlHelper(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                }
            }
            public sealed class SerializableError : System.Collections.Generic.Dictionary<string, object>
            {
                public SerializableError() => throw null;
                public SerializableError(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
            public class ServiceFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
            {
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public ServiceFilterAttribute(System.Type type) => throw null;
                public bool IsReusable { get => throw null; set { } }
                public int Order { get => throw null; set { } }
                public System.Type ServiceType { get => throw null; }
            }
            public class ServiceFilterAttribute<TFilter> : Microsoft.AspNetCore.Mvc.ServiceFilterAttribute where TFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
                public ServiceFilterAttribute() : base(default(System.Type)) => throw null;
            }
            public class SignInResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public string AuthenticationScheme { get => throw null; set { } }
                public SignInResult(System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public SignInResult(string authenticationScheme, System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public SignInResult(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public SignInResult(string authenticationScheme, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; set { } }
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
            }
            public class SignOutResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Http.IResult
            {
                public System.Collections.Generic.IList<string> AuthenticationSchemes { get => throw null; set { } }
                public SignOutResult() => throw null;
                public SignOutResult(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public SignOutResult(string authenticationScheme) => throw null;
                public SignOutResult(System.Collections.Generic.IList<string> authenticationSchemes) => throw null;
                public SignOutResult(string authenticationScheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public SignOutResult(System.Collections.Generic.IList<string> authenticationSchemes, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                System.Threading.Tasks.Task Microsoft.AspNetCore.Http.IResult.ExecuteAsync(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set { } }
            }
            public class StatusCodeResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IClientErrorActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult
            {
                public StatusCodeResult(int statusCode) => throw null;
                public override void ExecuteResult(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public int StatusCode { get => throw null; }
                int? Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult.StatusCode { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
            public class TypeFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
            {
                public object[] Arguments { get => throw null; set { } }
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public TypeFilterAttribute(System.Type type) => throw null;
                public System.Type ImplementationType { get => throw null; }
                public bool IsReusable { get => throw null; set { } }
                public int Order { get => throw null; set { } }
            }
            public class TypeFilterAttribute<TFilter> : Microsoft.AspNetCore.Mvc.TypeFilterAttribute where TFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
                public TypeFilterAttribute() : base(default(System.Type)) => throw null;
            }
            public class UnauthorizedObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public UnauthorizedObjectResult(object value) : base(default(object)) => throw null;
            }
            public class UnauthorizedResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public UnauthorizedResult() : base(default(int)) => throw null;
            }
            public class UnprocessableEntityObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public UnprocessableEntityObjectResult(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) : base(default(object)) => throw null;
                public UnprocessableEntityObjectResult(object error) : base(default(object)) => throw null;
            }
            public class UnprocessableEntityResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public UnprocessableEntityResult() : base(default(int)) => throw null;
            }
            public class UnsupportedMediaTypeResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public UnsupportedMediaTypeResult() : base(default(int)) => throw null;
            }
            public static partial class UrlHelperExtensions
            {
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, object values) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller, object values) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller, object values, string protocol) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller, object values, string protocol, string host) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller, object values, string protocol, string host, string fragment) => throw null;
                public static string ActionLink(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action = default(string), string controller = default(string), object values = default(object), string protocol = default(string), string host = default(string), string fragment = default(string)) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, object values) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler, object values) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler, object values, string protocol) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler, object values, string protocol, string host) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler, object values, string protocol, string host, string fragment) => throw null;
                public static string PageLink(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName = default(string), string pageHandler = default(string), object values = default(object), string protocol = default(string), string host = default(string), string fragment = default(string)) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, object values) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName, object values) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName, object values, string protocol) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName, object values, string protocol, string host) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName, object values, string protocol, string host, string fragment) => throw null;
            }
            public class ValidationProblemDetails : Microsoft.AspNetCore.Http.HttpValidationProblemDetails
            {
                public ValidationProblemDetails() => throw null;
                public ValidationProblemDetails(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public ValidationProblemDetails(System.Collections.Generic.IDictionary<string, string[]> errors) => throw null;
                public System.Collections.Generic.IDictionary<string, string[]> Errors { get => throw null; set { } }
            }
            namespace ViewFeatures
            {
                public interface IKeepTempDataResult : Microsoft.AspNetCore.Mvc.IActionResult
                {
                }
            }
            public class VirtualFileResult : Microsoft.AspNetCore.Mvc.FileResult
            {
                public VirtualFileResult(string fileName, string contentType) : base(default(string)) => throw null;
                public VirtualFileResult(string fileName, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) : base(default(string)) => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string FileName { get => throw null; set { } }
                public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; set { } }
            }
        }
        namespace Routing
        {
            public static partial class ControllerLinkGeneratorExtensions
            {
                public static string GetPathByAction(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string action = default(string), string controller = default(string), object values = default(object), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByAction(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string action, string controller, object values = default(object), Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByAction(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string action = default(string), string controller = default(string), object values = default(object), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByAction(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string action, string controller, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }
            public static partial class PageLinkGeneratorExtensions
            {
                public static string GetPathByPage(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string page = default(string), string handler = default(string), object values = default(object), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByPage(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string page, string handler = default(string), object values = default(object), Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByPage(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string page = default(string), string handler = default(string), object values = default(object), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByPage(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string page, string handler, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class ApplicationModelConventionExtensions
            {
                public static void Add(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IControllerModelConvention controllerModelConvention) => throw null;
                public static void Add(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention actionModelConvention) => throw null;
                public static void Add(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IParameterModelConvention parameterModelConvention) => throw null;
                public static void Add(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IParameterModelBaseConvention parameterModelConvention) => throw null;
                public static void RemoveType<TApplicationModelConvention>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> list) where TApplicationModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention => throw null;
                public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> list, System.Type type) => throw null;
            }
            public interface IMvcBuilder
            {
                Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager PartManager { get; }
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }
            public interface IMvcCoreBuilder
            {
                Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager PartManager { get; }
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }
            public static partial class MvcCoreMvcBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddApplicationPart(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Reflection.Assembly assembly) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddControllersAsServices(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddFormatterMappings(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Formatters.FormatterMappings> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddJsonOptions(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.JsonOptions> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddMvcOptions(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.MvcOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder ConfigureApiBehaviorOptions(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.ApiBehaviorOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder ConfigureApplicationPartManager(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder SetCompatibilityVersion(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, Microsoft.AspNetCore.Mvc.CompatibilityVersion version) => throw null;
            }
            public static partial class MvcCoreMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddApplicationPart(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Reflection.Assembly assembly) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddAuthorization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddAuthorization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Authorization.AuthorizationOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddControllersAsServices(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddFormatterMappings(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddFormatterMappings(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Formatters.FormatterMappings> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddJsonOptions(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.JsonOptions> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcOptions(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.MvcOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder ConfigureApiBehaviorOptions(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.ApiBehaviorOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder ConfigureApplicationPartManager(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder SetCompatibilityVersion(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, Microsoft.AspNetCore.Mvc.CompatibilityVersion version) => throw null;
            }
            public static partial class MvcCoreServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Mvc.MvcOptions> setupAction) => throw null;
            }
        }
    }
}
