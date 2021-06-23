// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.ControllerActionEndpointConventionBuilder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ControllerActionEndpointConventionBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder
            {
                public void Add(System.Action<Microsoft.AspNetCore.Builder.EndpointBuilder> convention) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.ControllerEndpointRouteBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ControllerEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.ControllerActionEndpointConventionBuilder MapAreaControllerRoute(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string name, string areaName, string pattern, object defaults = default(object), object constraints = default(object), object dataTokens = default(object)) => throw null;
                public static Microsoft.AspNetCore.Builder.ControllerActionEndpointConventionBuilder MapControllerRoute(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string name, string pattern, object defaults = default(object), object constraints = default(object), object dataTokens = default(object)) => throw null;
                public static Microsoft.AspNetCore.Builder.ControllerActionEndpointConventionBuilder MapControllers(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints) => throw null;
                public static Microsoft.AspNetCore.Builder.ControllerActionEndpointConventionBuilder MapDefaultControllerRoute(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints) => throw null;
                public static void MapDynamicControllerRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, object state, int order) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static void MapDynamicControllerRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, object state) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static void MapDynamicControllerRoute<TTransformer>(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern) where TTransformer : Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToAreaController(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string action, string controller, string area) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToAreaController(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string action, string controller, string area) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToController(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string action, string controller) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToController(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string action, string controller) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.MvcApplicationBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcApplicationBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMvc(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Action<Microsoft.AspNetCore.Routing.IRouteBuilder> configureRoutes) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMvc(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseMvcWithDefaultRoute(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.MvcAreaRouteBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcAreaRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapAreaRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string areaName, string template, object defaults, object constraints, object dataTokens) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapAreaRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string areaName, string template, object defaults, object constraints) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapAreaRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string areaName, string template, object defaults) => throw null;
                public static Microsoft.AspNetCore.Routing.IRouteBuilder MapAreaRoute(this Microsoft.AspNetCore.Routing.IRouteBuilder routeBuilder, string name, string areaName, string template) => throw null;
            }

        }
        namespace Mvc
        {
            // Generated from `Microsoft.AspNetCore.Mvc.AcceptVerbsAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AcceptVerbsAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider, Microsoft.AspNetCore.Mvc.Routing.IActionHttpMethodProvider
            {
                public AcceptVerbsAttribute(string method) => throw null;
                public AcceptVerbsAttribute(params string[] methods) => throw null;
                public System.Collections.Generic.IEnumerable<string> HttpMethods { get => throw null; }
                public string Name { get => throw null; set => throw null; }
                public int Order { get => throw null; set => throw null; }
                int? Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider.Order { get => throw null; }
                public string Route { get => throw null; set => throw null; }
                string Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider.Template { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.AcceptedAtActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AcceptedAtActionResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public AcceptedAtActionResult(string actionName, string controllerName, object routeValues, object value) : base(default(object)) => throw null;
                public string ActionName { get => throw null; set => throw null; }
                public string ControllerName { get => throw null; set => throw null; }
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AcceptedAtRouteResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public AcceptedAtRouteResult(string routeName, object routeValues, object value) : base(default(object)) => throw null;
                public AcceptedAtRouteResult(object routeValues, object value) : base(default(object)) => throw null;
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string RouteName { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.AcceptedResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AcceptedResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public AcceptedResult(string location, object value) : base(default(object)) => throw null;
                public AcceptedResult(System.Uri locationUri, object value) : base(default(object)) => throw null;
                public AcceptedResult() : base(default(object)) => throw null;
                public string Location { get => throw null; set => throw null; }
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ActionContextAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ActionContextAttribute : System.Attribute
            {
                public ActionContextAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ActionNameAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ActionNameAttribute : System.Attribute
            {
                public ActionNameAttribute(string name) => throw null;
                public string Name { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class ActionResult : Microsoft.AspNetCore.Mvc.IActionResult
            {
                protected ActionResult() => throw null;
                public virtual void ExecuteResult(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public virtual System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ActionResult<>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ActionResult<TValue> : Microsoft.AspNetCore.Mvc.Infrastructure.IConvertToActionResult
            {
                public ActionResult(TValue value) => throw null;
                public ActionResult(Microsoft.AspNetCore.Mvc.ActionResult result) => throw null;
                Microsoft.AspNetCore.Mvc.IActionResult Microsoft.AspNetCore.Mvc.Infrastructure.IConvertToActionResult.Convert() => throw null;
                public Microsoft.AspNetCore.Mvc.ActionResult Result { get => throw null; }
                public TValue Value { get => throw null; }
                public static implicit operator Microsoft.AspNetCore.Mvc.ActionResult<TValue>(TValue value) => throw null;
                public static implicit operator Microsoft.AspNetCore.Mvc.ActionResult<TValue>(Microsoft.AspNetCore.Mvc.ActionResult result) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.AntiforgeryValidationFailedResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AntiforgeryValidationFailedResult : Microsoft.AspNetCore.Mvc.BadRequestResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Core.Infrastructure.IAntiforgeryValidationFailedResult
            {
                public AntiforgeryValidationFailedResult() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ApiBehaviorOptions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ApiBehaviorOptions : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>
            {
                public ApiBehaviorOptions() => throw null;
                public System.Collections.Generic.IDictionary<int, Microsoft.AspNetCore.Mvc.ClientErrorData> ClientErrorMapping { get => throw null; }
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                public System.Func<Microsoft.AspNetCore.Mvc.ActionContext, Microsoft.AspNetCore.Mvc.IActionResult> InvalidModelStateResponseFactory { get => throw null; set => throw null; }
                public bool SuppressConsumesConstraintForFormFileParameters { get => throw null; set => throw null; }
                public bool SuppressInferBindingSourcesForParameters { get => throw null; set => throw null; }
                public bool SuppressMapClientErrors { get => throw null; set => throw null; }
                public bool SuppressModelStateInvalidFilter { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ApiControllerAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ApiControllerAttribute : Microsoft.AspNetCore.Mvc.ControllerAttribute, Microsoft.AspNetCore.Mvc.Infrastructure.IApiBehaviorMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
                public ApiControllerAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ApiConventionMethodAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ApiConventionMethodAttribute : System.Attribute
            {
                public ApiConventionMethodAttribute(System.Type conventionType, string methodName) => throw null;
                public System.Type ConventionType { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ApiConventionTypeAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ApiConventionTypeAttribute : System.Attribute
            {
                public ApiConventionTypeAttribute(System.Type conventionType) => throw null;
                public System.Type ConventionType { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ApiDescriptionActionData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ApiDescriptionActionData
            {
                public ApiDescriptionActionData() => throw null;
                public string GroupName { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorerSettingsAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ApiExplorerSettingsAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionVisibilityProvider, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionGroupNameProvider
            {
                public ApiExplorerSettingsAttribute() => throw null;
                public string GroupName { get => throw null; set => throw null; }
                public bool IgnoreApi { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.AreaAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class AreaAttribute : Microsoft.AspNetCore.Mvc.Routing.RouteValueAttribute
            {
                public AreaAttribute(string areaName) : base(default(string), default(string)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.BadRequestObjectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BadRequestObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public BadRequestObjectResult(object error) : base(default(object)) => throw null;
                public BadRequestObjectResult(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) : base(default(object)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.BadRequestResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BadRequestResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public BadRequestResult() : base(default(int)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.BindAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BindAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider
            {
                public BindAttribute(params string[] include) => throw null;
                public string[] Include { get => throw null; }
                string Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider.Name { get => throw null; }
                public string Prefix { get => throw null; set => throw null; }
                public System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.BindPropertiesAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BindPropertiesAttribute : System.Attribute
            {
                public BindPropertiesAttribute() => throw null;
                public bool SupportsGet { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.BindPropertyAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BindPropertyAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IRequestPredicateProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IBinderTypeProviderMetadata
            {
                public BindPropertyAttribute() => throw null;
                public System.Type BinderType { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                System.Func<Microsoft.AspNetCore.Mvc.ActionContext, bool> Microsoft.AspNetCore.Mvc.ModelBinding.IRequestPredicateProvider.RequestPredicate { get => throw null; }
                public bool SupportsGet { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.CacheProfile` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CacheProfile
            {
                public CacheProfile() => throw null;
                public int? Duration { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ResponseCacheLocation? Location { get => throw null; set => throw null; }
                public bool? NoStore { get => throw null; set => throw null; }
                public string VaryByHeader { get => throw null; set => throw null; }
                public string[] VaryByQueryKeys { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ChallengeResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ChallengeResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public System.Collections.Generic.IList<string> AuthenticationSchemes { get => throw null; set => throw null; }
                public ChallengeResult(string authenticationScheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ChallengeResult(string authenticationScheme) => throw null;
                public ChallengeResult(System.Collections.Generic.IList<string> authenticationSchemes, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ChallengeResult(System.Collections.Generic.IList<string> authenticationSchemes) => throw null;
                public ChallengeResult(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ChallengeResult() => throw null;
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ClientErrorData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ClientErrorData
            {
                public ClientErrorData() => throw null;
                public string Link { get => throw null; set => throw null; }
                public string Title { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.CompatibilityVersion` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum CompatibilityVersion
            {
                Latest,
                Version_2_0,
                Version_2_1,
                Version_2_2,
                Version_3_0,
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ConflictObjectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConflictObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public ConflictObjectResult(object error) : base(default(object)) => throw null;
                public ConflictObjectResult(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) : base(default(object)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ConflictResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConflictResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public ConflictResult() : base(default(int)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ConsumesAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ConsumesAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IResourceFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiRequestMetadataProvider, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint
            {
                public bool Accept(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintContext context) => throw null;
                public static int ConsumesActionConstraintOrder;
                public ConsumesAttribute(string contentType, params string[] otherContentTypes) => throw null;
                public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection ContentTypes { get => throw null; set => throw null; }
                public void OnResourceExecuted(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext context) => throw null;
                public void OnResourceExecuting(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext context) => throw null;
                int Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint.Order { get => throw null; }
                public void SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ContentResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ContentResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult, Microsoft.AspNetCore.Mvc.IActionResult
            {
                public string Content { get => throw null; set => throw null; }
                public ContentResult() => throw null;
                public string ContentType { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public int? StatusCode { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ControllerAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ControllerAttribute : System.Attribute
            {
                public ControllerAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ControllerBase` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class ControllerBase
            {
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(string uri, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(string uri) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(System.Uri uri, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted(System.Uri uri) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedResult Accepted() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, string controllerName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, string controllerName, object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, string controllerName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtActionResult AcceptedAtAction(string actionName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(string routeName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(string routeName, object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(string routeName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.AcceptedAtRouteResult AcceptedAtRoute(object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.BadRequestResult BadRequest() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(object error) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.BadRequestObjectResult BadRequest(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(params string[] authenticationSchemes) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ChallengeResult Challenge() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ConflictResult Conflict() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ConflictObjectResult Conflict(object error) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ConflictObjectResult Conflict(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType, System.Text.Encoding contentEncoding) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, string contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ContentResult Content(string content) => throw null;
                protected ControllerBase() => throw null;
                public Microsoft.AspNetCore.Mvc.ControllerContext ControllerContext { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.CreatedResult Created(string uri, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedResult Created(System.Uri uri, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtActionResult CreatedAtAction(string actionName, string controllerName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtActionResult CreatedAtAction(string actionName, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtActionResult CreatedAtAction(string actionName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtRouteResult CreatedAtRoute(string routeName, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtRouteResult CreatedAtRoute(string routeName, object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.CreatedAtRouteResult CreatedAtRoute(object routeValues, object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, string fileDownloadName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.VirtualFileResult File(string virtualPath, string contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, string fileDownloadName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileStreamResult File(System.IO.Stream fileStream, string contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType, string fileDownloadName, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType, string fileDownloadName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.FileContentResult File(System.Byte[] fileContents, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
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
                public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderFactory ModelBinderFactory { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.NoContentResult NoContent() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.NotFoundResult NotFound() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.NotFoundObjectResult NotFound(object value) => throw null;
                public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IObjectModelValidator ObjectValidator { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.OkResult Ok() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.OkObjectResult Ok(object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, string fileDownloadName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag, bool enableRangeProcessing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType, System.DateTimeOffset? lastModified, Microsoft.Net.Http.Headers.EntityTagHeaderValue entityTag) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PhysicalFileResult PhysicalFile(string physicalPath, string contentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ObjectResult Problem(string detail = default(string), string instance = default(string), int? statusCode = default(int?), string title = default(string), string type = default(string)) => throw null;
                public Microsoft.AspNetCore.Mvc.Infrastructure.ProblemDetailsFactory ProblemDetailsFactory { get => throw null; set => throw null; }
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
                public virtual Microsoft.AspNetCore.Mvc.RedirectToActionResult RedirectToAction() => throw null;
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
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, string fragment) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, string pageHandler) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName, object routeValues) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanent(string pageName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePermanentPreserveMethod(string pageName, string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.RedirectToPageResult RedirectToPagePreserveMethod(string pageName, string pageHandler = default(string), object routeValues = default(object), string fragment = default(string)) => throw null;
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
                public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignInResult SignIn(System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut(params string[] authenticationSchemes) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties, params string[] authenticationSchemes) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.SignOutResult SignOut() => throw null;
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
                public virtual Microsoft.AspNetCore.Mvc.UnauthorizedObjectResult Unauthorized(object value) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.UnprocessableEntityResult UnprocessableEntity() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.UnprocessableEntityObjectResult UnprocessableEntity(object error) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.UnprocessableEntityObjectResult UnprocessableEntity(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public Microsoft.AspNetCore.Mvc.IUrlHelper Url { get => throw null; set => throw null; }
                public System.Security.Claims.ClaimsPrincipal User { get => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.ActionResult ValidationProblem(string detail = default(string), string instance = default(string), int? statusCode = default(int?), string title = default(string), string type = default(string), Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelStateDictionary = default(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary)) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ActionResult ValidationProblem(Microsoft.AspNetCore.Mvc.ValidationProblemDetails descriptor) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ActionResult ValidationProblem(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelStateDictionary) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ActionResult ValidationProblem() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ControllerContext` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ControllerContext : Microsoft.AspNetCore.Mvc.ActionContext
            {
                public Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor ActionDescriptor { get => throw null; set => throw null; }
                public ControllerContext(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public ControllerContext() => throw null;
                public virtual System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> ValueProviderFactories { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ControllerContextAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ControllerContextAttribute : System.Attribute
            {
                public ControllerContextAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.CreatedAtActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CreatedAtActionResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public string ActionName { get => throw null; set => throw null; }
                public string ControllerName { get => throw null; set => throw null; }
                public CreatedAtActionResult(string actionName, string controllerName, object routeValues, object value) : base(default(object)) => throw null;
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.CreatedAtRouteResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CreatedAtRouteResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public CreatedAtRouteResult(string routeName, object routeValues, object value) : base(default(object)) => throw null;
                public CreatedAtRouteResult(object routeValues, object value) : base(default(object)) => throw null;
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string RouteName { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.CreatedResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CreatedResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public CreatedResult(string location, object value) : base(default(object)) => throw null;
                public CreatedResult(System.Uri location, object value) : base(default(object)) => throw null;
                public string Location { get => throw null; set => throw null; }
                public override void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.DefaultApiConventions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

            // Generated from `Microsoft.AspNetCore.Mvc.DisableRequestSizeLimitAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DisableRequestSizeLimitAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory
            {
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public DisableRequestSizeLimitAttribute() => throw null;
                public bool IsReusable { get => throw null; }
                public int Order { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.EmptyResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class EmptyResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public EmptyResult() => throw null;
                public override void ExecuteResult(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FileContentResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FileContentResult : Microsoft.AspNetCore.Mvc.FileResult
            {
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public FileContentResult(System.Byte[] fileContents, string contentType) : base(default(string)) => throw null;
                public FileContentResult(System.Byte[] fileContents, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) : base(default(string)) => throw null;
                public System.Byte[] FileContents { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FileResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class FileResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public string ContentType { get => throw null; }
                public bool EnableRangeProcessing { get => throw null; set => throw null; }
                public Microsoft.Net.Http.Headers.EntityTagHeaderValue EntityTag { get => throw null; set => throw null; }
                public string FileDownloadName { get => throw null; set => throw null; }
                protected FileResult(string contentType) => throw null;
                public System.DateTimeOffset? LastModified { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FileStreamResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FileStreamResult : Microsoft.AspNetCore.Mvc.FileResult
            {
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public System.IO.Stream FileStream { get => throw null; set => throw null; }
                public FileStreamResult(System.IO.Stream fileStream, string contentType) : base(default(string)) => throw null;
                public FileStreamResult(System.IO.Stream fileStream, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) : base(default(string)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ForbidResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ForbidResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public System.Collections.Generic.IList<string> AuthenticationSchemes { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public ForbidResult(string authenticationScheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ForbidResult(string authenticationScheme) => throw null;
                public ForbidResult(System.Collections.Generic.IList<string> authenticationSchemes, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ForbidResult(System.Collections.Generic.IList<string> authenticationSchemes) => throw null;
                public ForbidResult(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public ForbidResult() => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FormatFilterAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FormatFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory
            {
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public FormatFilterAttribute() => throw null;
                public bool IsReusable { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FromBodyAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FromBodyAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ModelBinding.EmptyBodyBehavior EmptyBodyBehavior { get => throw null; set => throw null; }
                public FromBodyAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FromFormAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FromFormAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromFormAttribute() => throw null;
                public string Name { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FromHeaderAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FromHeaderAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromHeaderAttribute() => throw null;
                public string Name { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FromQueryAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FromQueryAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromQueryAttribute() => throw null;
                public string Name { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FromRouteAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FromRouteAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromRouteAttribute() => throw null;
                public string Name { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.FromServicesAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FromServicesAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata
            {
                public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                public FromServicesAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.HttpDeleteAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpDeleteAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpDeleteAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpDeleteAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.HttpGetAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpGetAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpGetAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpGetAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.HttpHeadAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpHeadAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpHeadAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpHeadAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.HttpOptionsAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpOptionsAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpOptionsAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpOptionsAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.HttpPatchAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpPatchAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpPatchAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpPatchAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.HttpPostAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpPostAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpPostAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpPostAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.HttpPutAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HttpPutAttribute : Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute
            {
                public HttpPutAttribute(string template) : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                public HttpPutAttribute() : base(default(System.Collections.Generic.IEnumerable<string>)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.IDesignTimeMvcBuilderConfiguration` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDesignTimeMvcBuilderConfiguration
            {
                void ConfigureMvc(Microsoft.Extensions.DependencyInjection.IMvcBuilder builder);
            }

            // Generated from `Microsoft.AspNetCore.Mvc.IRequestFormLimitsPolicy` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRequestFormLimitsPolicy : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
            }

            // Generated from `Microsoft.AspNetCore.Mvc.IRequestSizePolicy` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRequestSizePolicy : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
            {
            }

            // Generated from `Microsoft.AspNetCore.Mvc.JsonOptions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class JsonOptions
            {
                public JsonOptions() => throw null;
                public System.Text.Json.JsonSerializerOptions JsonSerializerOptions { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.JsonResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class JsonResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult, Microsoft.AspNetCore.Mvc.IActionResult
            {
                public string ContentType { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public JsonResult(object value, object serializerSettings) => throw null;
                public JsonResult(object value) => throw null;
                public object SerializerSettings { get => throw null; set => throw null; }
                public int? StatusCode { get => throw null; set => throw null; }
                public object Value { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.LocalRedirectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class LocalRedirectResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public LocalRedirectResult(string localUrl, bool permanent, bool preserveMethod) => throw null;
                public LocalRedirectResult(string localUrl, bool permanent) => throw null;
                public LocalRedirectResult(string localUrl) => throw null;
                public bool Permanent { get => throw null; set => throw null; }
                public bool PreserveMethod { get => throw null; set => throw null; }
                public string Url { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.MiddlewareFilterAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class MiddlewareFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory
            {
                public System.Type ConfigurationType { get => throw null; }
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public bool IsReusable { get => throw null; }
                public MiddlewareFilterAttribute(System.Type configurationType) => throw null;
                public int Order { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ModelBinderAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ModelBinderAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.IModelNameProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IBinderTypeProviderMetadata
            {
                public System.Type BinderType { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set => throw null; }
                public ModelBinderAttribute(System.Type binderType) => throw null;
                public ModelBinderAttribute() => throw null;
                public string Name { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ModelMetadataTypeAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ModelMetadataTypeAttribute : System.Attribute
            {
                public System.Type MetadataType { get => throw null; }
                public ModelMetadataTypeAttribute(System.Type type) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.MvcOptions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class MvcOptions : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>
            {
                public bool AllowEmptyInputInBodyModelBinding { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.CacheProfile> CacheProfiles { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> Conventions { get => throw null; }
                public bool EnableEndpointRouting { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.Filters.FilterCollection Filters { get => throw null; }
                public Microsoft.AspNetCore.Mvc.Formatters.FormatterMappings FormatterMappings { get => throw null; }
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                public Microsoft.AspNetCore.Mvc.Formatters.FormatterCollection<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> InputFormatters { get => throw null; }
                public int MaxIAsyncEnumerableBufferLimit { get => throw null; set => throw null; }
                public int MaxModelBindingCollectionSize { get => throw null; set => throw null; }
                public int MaxModelBindingRecursionDepth { get => throw null; set => throw null; }
                public int MaxModelValidationErrors { get => throw null; set => throw null; }
                public int? MaxValidationDepth { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider> ModelBinderProviders { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider ModelBindingMessageProvider { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider> ModelMetadataDetailsProviders { get => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> ModelValidatorProviders { get => throw null; }
                public MvcOptions() => throw null;
                public Microsoft.AspNetCore.Mvc.Formatters.FormatterCollection<Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter> OutputFormatters { get => throw null; }
                public bool RequireHttpsPermanent { get => throw null; set => throw null; }
                public bool RespectBrowserAcceptHeader { get => throw null; set => throw null; }
                public bool ReturnHttpNotAcceptable { get => throw null; set => throw null; }
                public int? SslPort { get => throw null; set => throw null; }
                public bool SuppressAsyncSuffixInActionNames { get => throw null; set => throw null; }
                public bool SuppressImplicitRequiredAttributeForNonNullableReferenceTypes { get => throw null; set => throw null; }
                public bool SuppressInputFormatterBuffering { get => throw null; set => throw null; }
                public bool SuppressOutputFormatterBuffering { get => throw null; set => throw null; }
                public bool ValidateComplexTypesIfChildValidationFails { get => throw null; set => throw null; }
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> ValueProviderFactories { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.NoContentResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NoContentResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public NoContentResult() : base(default(int)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.NonActionAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NonActionAttribute : System.Attribute
            {
                public NonActionAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.NonControllerAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NonControllerAttribute : System.Attribute
            {
                public NonControllerAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.NonViewComponentAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NonViewComponentAttribute : System.Attribute
            {
                public NonViewComponentAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.NotFoundObjectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NotFoundObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public NotFoundObjectResult(object value) : base(default(object)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.NotFoundResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class NotFoundResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public NotFoundResult() : base(default(int)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ObjectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ObjectResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult, Microsoft.AspNetCore.Mvc.IActionResult
            {
                public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection ContentTypes { get => throw null; set => throw null; }
                public System.Type DeclaredType { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Mvc.Formatters.FormatterCollection<Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter> Formatters { get => throw null; set => throw null; }
                public ObjectResult(object value) => throw null;
                public virtual void OnFormatting(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public int? StatusCode { get => throw null; set => throw null; }
                public object Value { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.OkObjectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class OkObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public OkObjectResult(object value) : base(default(object)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.OkResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class OkResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public OkResult() : base(default(int)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.PhysicalFileResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class PhysicalFileResult : Microsoft.AspNetCore.Mvc.FileResult
            {
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string FileName { get => throw null; set => throw null; }
                public PhysicalFileResult(string fileName, string contentType) : base(default(string)) => throw null;
                public PhysicalFileResult(string fileName, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) : base(default(string)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ProblemDetails` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ProblemDetails
            {
                public string Detail { get => throw null; set => throw null; }
                public System.Collections.Generic.IDictionary<string, object> Extensions { get => throw null; }
                public string Instance { get => throw null; set => throw null; }
                public ProblemDetails() => throw null;
                public int? Status { get => throw null; set => throw null; }
                public string Title { get => throw null; set => throw null; }
                public string Type { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ProducesAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ProducesAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IResultFilter, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider
            {
                public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection ContentTypes { get => throw null; set => throw null; }
                public virtual void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context) => throw null;
                public virtual void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context) => throw null;
                public int Order { get => throw null; set => throw null; }
                public ProducesAttribute(string contentType, params string[] additionalContentTypes) => throw null;
                public ProducesAttribute(System.Type type) => throw null;
                public void SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
                public int StatusCode { get => throw null; }
                public System.Type Type { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ProducesDefaultResponseTypeAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ProducesDefaultResponseTypeAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDefaultResponseMetadataProvider
            {
                public ProducesDefaultResponseTypeAttribute(System.Type type) => throw null;
                public ProducesDefaultResponseTypeAttribute() => throw null;
                void Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider.SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
                public int StatusCode { get => throw null; }
                public System.Type Type { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ProducesErrorResponseTypeAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ProducesErrorResponseTypeAttribute : System.Attribute
            {
                public ProducesErrorResponseTypeAttribute(System.Type type) => throw null;
                public System.Type Type { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ProducesResponseTypeAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ProducesResponseTypeAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider
            {
                public ProducesResponseTypeAttribute(int statusCode) => throw null;
                public ProducesResponseTypeAttribute(System.Type type, int statusCode) => throw null;
                void Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider.SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
                public int StatusCode { get => throw null; set => throw null; }
                public System.Type Type { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.RedirectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RedirectResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult, Microsoft.AspNetCore.Mvc.IActionResult
            {
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public bool Permanent { get => throw null; set => throw null; }
                public bool PreserveMethod { get => throw null; set => throw null; }
                public RedirectResult(string url, bool permanent, bool preserveMethod) => throw null;
                public RedirectResult(string url, bool permanent) => throw null;
                public RedirectResult(string url) => throw null;
                public string Url { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.RedirectToActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RedirectToActionResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult, Microsoft.AspNetCore.Mvc.IActionResult
            {
                public string ActionName { get => throw null; set => throw null; }
                public string ControllerName { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string Fragment { get => throw null; set => throw null; }
                public bool Permanent { get => throw null; set => throw null; }
                public bool PreserveMethod { get => throw null; set => throw null; }
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, string fragment) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, bool permanent, string fragment) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, bool permanent, bool preserveMethod, string fragment) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, bool permanent, bool preserveMethod) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues, bool permanent) => throw null;
                public RedirectToActionResult(string actionName, string controllerName, object routeValues) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.RedirectToPageResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RedirectToPageResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult, Microsoft.AspNetCore.Mvc.IActionResult
            {
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string Fragment { get => throw null; set => throw null; }
                public string Host { get => throw null; set => throw null; }
                public string PageHandler { get => throw null; set => throw null; }
                public string PageName { get => throw null; set => throw null; }
                public bool Permanent { get => throw null; set => throw null; }
                public bool PreserveMethod { get => throw null; set => throw null; }
                public string Protocol { get => throw null; set => throw null; }
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, string fragment) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, bool permanent, string fragment) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, bool permanent, bool preserveMethod, string fragment) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, bool permanent, bool preserveMethod) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues, bool permanent) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler, object routeValues) => throw null;
                public RedirectToPageResult(string pageName, string pageHandler) => throw null;
                public RedirectToPageResult(string pageName, object routeValues) => throw null;
                public RedirectToPageResult(string pageName) => throw null;
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.RedirectToRouteResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RedirectToRouteResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult, Microsoft.AspNetCore.Mvc.IActionResult
            {
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string Fragment { get => throw null; set => throw null; }
                public bool Permanent { get => throw null; set => throw null; }
                public bool PreserveMethod { get => throw null; set => throw null; }
                public RedirectToRouteResult(string routeName, object routeValues, string fragment) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues, bool permanent, string fragment) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues, bool permanent, bool preserveMethod, string fragment) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues, bool permanent, bool preserveMethod) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues, bool permanent) => throw null;
                public RedirectToRouteResult(string routeName, object routeValues) => throw null;
                public RedirectToRouteResult(object routeValues) => throw null;
                public string RouteName { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Routing.RouteValueDictionary RouteValues { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper UrlHelper { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.RequestFormLimitsAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RequestFormLimitsAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory
            {
                public bool BufferBody { get => throw null; set => throw null; }
                public System.Int64 BufferBodyLengthLimit { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public bool IsReusable { get => throw null; }
                public int KeyLengthLimit { get => throw null; set => throw null; }
                public int MemoryBufferThreshold { get => throw null; set => throw null; }
                public System.Int64 MultipartBodyLengthLimit { get => throw null; set => throw null; }
                public int MultipartBoundaryLengthLimit { get => throw null; set => throw null; }
                public int MultipartHeadersCountLimit { get => throw null; set => throw null; }
                public int MultipartHeadersLengthLimit { get => throw null; set => throw null; }
                public int Order { get => throw null; set => throw null; }
                public RequestFormLimitsAttribute() => throw null;
                public int ValueCountLimit { get => throw null; set => throw null; }
                public int ValueLengthLimit { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.RequestSizeLimitAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RequestSizeLimitAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory
            {
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public bool IsReusable { get => throw null; }
                public int Order { get => throw null; set => throw null; }
                public RequestSizeLimitAttribute(System.Int64 bytes) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.RequireHttpsAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RequireHttpsAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IAuthorizationFilter
            {
                protected virtual void HandleNonHttpsRequest(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext filterContext) => throw null;
                public virtual void OnAuthorization(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext filterContext) => throw null;
                public int Order { get => throw null; set => throw null; }
                public bool Permanent { get => throw null; set => throw null; }
                public RequireHttpsAttribute() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ResponseCacheAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResponseCacheAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory
            {
                public string CacheProfileName { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public int Duration { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.CacheProfile GetCacheProfile(Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                public bool IsReusable { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ResponseCacheLocation Location { get => throw null; set => throw null; }
                public bool NoStore { get => throw null; set => throw null; }
                public int Order { get => throw null; set => throw null; }
                public ResponseCacheAttribute() => throw null;
                public string VaryByHeader { get => throw null; set => throw null; }
                public string[] VaryByQueryKeys { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ResponseCacheLocation` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum ResponseCacheLocation
            {
                Any,
                Client,
                None,
            }

            // Generated from `Microsoft.AspNetCore.Mvc.RouteAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RouteAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider
            {
                public string Name { get => throw null; set => throw null; }
                public int Order { get => throw null; set => throw null; }
                int? Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider.Order { get => throw null; }
                public RouteAttribute(string template) => throw null;
                public string Template { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.SerializableError` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SerializableError : System.Collections.Generic.Dictionary<string, object>
            {
                public SerializableError(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public SerializableError() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ServiceFilterAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ServiceFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory
            {
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public bool IsReusable { get => throw null; set => throw null; }
                public int Order { get => throw null; set => throw null; }
                public ServiceFilterAttribute(System.Type type) => throw null;
                public System.Type ServiceType { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Mvc.SignInResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SignInResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public string AuthenticationScheme { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public System.Security.Claims.ClaimsPrincipal Principal { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set => throw null; }
                public SignInResult(string authenticationScheme, System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public SignInResult(string authenticationScheme, System.Security.Claims.ClaimsPrincipal principal) => throw null;
                public SignInResult(System.Security.Claims.ClaimsPrincipal principal, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public SignInResult(System.Security.Claims.ClaimsPrincipal principal) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.SignOutResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class SignOutResult : Microsoft.AspNetCore.Mvc.ActionResult
            {
                public System.Collections.Generic.IList<string> AuthenticationSchemes { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public Microsoft.AspNetCore.Authentication.AuthenticationProperties Properties { get => throw null; set => throw null; }
                public SignOutResult(string authenticationScheme, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public SignOutResult(string authenticationScheme) => throw null;
                public SignOutResult(System.Collections.Generic.IList<string> authenticationSchemes, Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public SignOutResult(System.Collections.Generic.IList<string> authenticationSchemes) => throw null;
                public SignOutResult(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                public SignOutResult() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.StatusCodeResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StatusCodeResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IClientErrorActionResult, Microsoft.AspNetCore.Mvc.IActionResult
            {
                public override void ExecuteResult(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public int StatusCode { get => throw null; }
                int? Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult.StatusCode { get => throw null; }
                public StatusCodeResult(int statusCode) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.TypeFilterAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class TypeFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory
            {
                public object[] Arguments { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public System.Type ImplementationType { get => throw null; }
                public bool IsReusable { get => throw null; set => throw null; }
                public int Order { get => throw null; set => throw null; }
                public TypeFilterAttribute(System.Type type) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.UnauthorizedObjectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class UnauthorizedObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public UnauthorizedObjectResult(object value) : base(default(object)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.UnauthorizedResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class UnauthorizedResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public UnauthorizedResult() : base(default(int)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.UnprocessableEntityObjectResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class UnprocessableEntityObjectResult : Microsoft.AspNetCore.Mvc.ObjectResult
            {
                public UnprocessableEntityObjectResult(object error) : base(default(object)) => throw null;
                public UnprocessableEntityObjectResult(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) : base(default(object)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.UnprocessableEntityResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class UnprocessableEntityResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public UnprocessableEntityResult() : base(default(int)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.UnsupportedMediaTypeResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class UnsupportedMediaTypeResult : Microsoft.AspNetCore.Mvc.StatusCodeResult
            {
                public UnsupportedMediaTypeResult() : base(default(int)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.UrlHelperExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class UrlHelperExtensions
            {
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller, object values, string protocol, string host, string fragment) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller, object values, string protocol, string host) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller, object values, string protocol) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller, object values) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, string controller) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action, object values) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action) => throw null;
                public static string Action(this Microsoft.AspNetCore.Mvc.IUrlHelper helper) => throw null;
                public static string ActionLink(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string action = default(string), string controller = default(string), object values = default(object), string protocol = default(string), string host = default(string), string fragment = default(string)) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler, object values, string protocol, string host, string fragment) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler, object values, string protocol, string host) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler, object values, string protocol) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler, object values) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, string pageHandler) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName, object values) => throw null;
                public static string Page(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName) => throw null;
                public static string PageLink(this Microsoft.AspNetCore.Mvc.IUrlHelper urlHelper, string pageName = default(string), string pageHandler = default(string), object values = default(object), string protocol = default(string), string host = default(string), string fragment = default(string)) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName, object values, string protocol, string host, string fragment) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName, object values, string protocol, string host) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName, object values, string protocol) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName, object values) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, string routeName) => throw null;
                public static string RouteUrl(this Microsoft.AspNetCore.Mvc.IUrlHelper helper, object values) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.ValidationProblemDetails` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ValidationProblemDetails : Microsoft.AspNetCore.Mvc.ProblemDetails
            {
                public System.Collections.Generic.IDictionary<string, string[]> Errors { get => throw null; }
                public ValidationProblemDetails(System.Collections.Generic.IDictionary<string, string[]> errors) => throw null;
                public ValidationProblemDetails(Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                public ValidationProblemDetails() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Mvc.VirtualFileResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class VirtualFileResult : Microsoft.AspNetCore.Mvc.FileResult
            {
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public string FileName { get => throw null; set => throw null; }
                public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; set => throw null; }
                public VirtualFileResult(string fileName, string contentType) : base(default(string)) => throw null;
                public VirtualFileResult(string fileName, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) : base(default(string)) => throw null;
            }

            namespace ActionConstraints
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.ActionMethodSelectorAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ActionMethodSelectorAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint
                {
                    public bool Accept(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintContext context) => throw null;
                    protected ActionMethodSelectorAttribute() => throw null;
                    public abstract bool IsValidForRequest(Microsoft.AspNetCore.Routing.RouteContext routeContext, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor action);
                    public int Order { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.HttpMethodActionConstraint` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpMethodActionConstraint : Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint
                {
                    public virtual bool Accept(Microsoft.AspNetCore.Mvc.ActionConstraints.ActionConstraintContext context) => throw null;
                    public HttpMethodActionConstraint(System.Collections.Generic.IEnumerable<string> httpMethods) => throw null;
                    public static int HttpMethodConstraintOrder;
                    public System.Collections.Generic.IEnumerable<string> HttpMethods { get => throw null; }
                    public int Order { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ActionConstraints.IConsumesActionConstraint` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface IConsumesActionConstraint : Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata, Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraint
                {
                }

            }
            namespace ApiExplorer
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionNameMatchAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiConventionNameMatchAttribute : System.Attribute
                {
                    public ApiConventionNameMatchAttribute(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionNameMatchBehavior matchBehavior) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionNameMatchBehavior MatchBehavior { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionNameMatchBehavior` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum ApiConventionNameMatchBehavior
                {
                    Any,
                    Exact,
                    Prefix,
                    Suffix,
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiConventionResult
                {
                    public ApiConventionResult(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider> responseMetadataProviders) => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider> ResponseMetadataProviders { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionTypeMatchAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiConventionTypeMatchAttribute : System.Attribute
                {
                    public ApiConventionTypeMatchAttribute(Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionTypeMatchBehavior matchBehavior) => throw null;
                    public Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionTypeMatchBehavior MatchBehavior { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.ApiConventionTypeMatchBehavior` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum ApiConventionTypeMatchBehavior
                {
                    Any,
                    AssignableFrom,
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDefaultResponseMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiDefaultResponseMetadataProvider : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionGroupNameProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiDescriptionGroupNameProvider
                {
                    string GroupName { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.IApiDescriptionVisibilityProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiDescriptionVisibilityProvider
                {
                    bool IgnoreApi { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.IApiRequestFormatMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiRequestFormatMetadataProvider
                {
                    System.Collections.Generic.IReadOnlyList<string> GetSupportedContentTypes(string contentType, System.Type objectType);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.IApiRequestMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiRequestMetadataProvider : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiResponseMetadataProvider : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    void SetContentTypes(Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes);
                    int StatusCode { get; }
                    System.Type Type { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseTypeMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiResponseTypeMetadataProvider
                {
                    System.Collections.Generic.IReadOnlyList<string> GetSupportedContentTypes(string contentType, System.Type objectType);
                }

            }
            namespace ApplicationModels
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionModel : Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IFilterModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IApiExplorerModel
                {
                    public System.Reflection.MethodInfo ActionMethod { get => throw null; }
                    public ActionModel(System.Reflection.MethodInfo actionMethod, System.Collections.Generic.IReadOnlyList<object> attributes) => throw null;
                    public ActionModel(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel other) => throw null;
                    public string ActionName { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel ApiExplorer { get => throw null; set => throw null; }
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel Controller { get => throw null; set => throw null; }
                    public string DisplayName { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    string Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.Name { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModel> Parameters { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public Microsoft.AspNetCore.Routing.IOutboundParameterTransformer RouteParameterTransformer { get => throw null; set => throw null; }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.SelectorModel> Selectors { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ApiConventionApplicationModelConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiConventionApplicationModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public ApiConventionApplicationModelConvention(Microsoft.AspNetCore.Mvc.ProducesErrorResponseTypeAttribute defaultErrorResponseType) => throw null;
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public Microsoft.AspNetCore.Mvc.ProducesErrorResponseTypeAttribute DefaultErrorResponseType { get => throw null; }
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiExplorerModel
                {
                    public ApiExplorerModel(Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel other) => throw null;
                    public ApiExplorerModel() => throw null;
                    public string GroupName { get => throw null; set => throw null; }
                    public bool? IsVisible { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ApiVisibilityConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApiVisibilityConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public ApiVisibilityConvention() => throw null;
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApplicationModel : Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IFilterModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IApiExplorerModel
                {
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel ApiExplorer { get => throw null; set => throw null; }
                    public ApplicationModel() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel> Controllers { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModelProviderContext` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApplicationModelProviderContext
                {
                    public ApplicationModelProviderContext(System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> controllerTypes) => throw null;
                    public System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> ControllerTypes { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModel Result { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AttributeRouteModel
                {
                    public Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider Attribute { get => throw null; }
                    public AttributeRouteModel(Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider templateProvider) => throw null;
                    public AttributeRouteModel(Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel other) => throw null;
                    public AttributeRouteModel() => throw null;
                    public static Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel CombineAttributeRouteModel(Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel left, Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel right) => throw null;
                    public static string CombineTemplates(string prefix, string template) => throw null;
                    public bool IsAbsoluteTemplate { get => throw null; }
                    public static bool IsOverridePattern(string template) => throw null;
                    public string Name { get => throw null; set => throw null; }
                    public int? Order { get => throw null; set => throw null; }
                    public static string ReplaceTokens(string template, System.Collections.Generic.IDictionary<string, string> values, Microsoft.AspNetCore.Routing.IOutboundParameterTransformer routeTokenTransformer) => throw null;
                    public static string ReplaceTokens(string template, System.Collections.Generic.IDictionary<string, string> values) => throw null;
                    public bool SuppressLinkGeneration { get => throw null; set => throw null; }
                    public bool SuppressPathMatching { get => throw null; set => throw null; }
                    public string Template { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ClientErrorResultFilterConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ClientErrorResultFilterConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public ClientErrorResultFilterConvention() => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ConsumesConstraintForFormFileParameterConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ConsumesConstraintForFormFileParameterConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public ConsumesConstraintForFormFileParameterConvention() => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ControllerModel : Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IFilterModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IApiExplorerModel
                {
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel> Actions { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel ApiExplorer { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModel Application { get => throw null; set => throw null; }
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public ControllerModel(System.Reflection.TypeInfo controllerType, System.Collections.Generic.IReadOnlyList<object> attributes) => throw null;
                    public ControllerModel(Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel other) => throw null;
                    public string ControllerName { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.PropertyModel> ControllerProperties { get => throw null; }
                    public System.Reflection.TypeInfo ControllerType { get => throw null; }
                    public string DisplayName { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get => throw null; }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    string Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.Name { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.SelectorModel> Selectors { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionModelConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IApiExplorerModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiExplorerModel
                {
                    Microsoft.AspNetCore.Mvc.ApplicationModels.ApiExplorerModel ApiExplorer { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApplicationModelConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModel application);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApplicationModelProvider
                {
                    void OnProvidersExecuted(Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModelProviderContext context);
                    void OnProvidersExecuting(Microsoft.AspNetCore.Mvc.ApplicationModels.ApplicationModelProviderContext context);
                    int Order { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IBindingModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IBindingModel
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ICommonModel : Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel
                {
                    System.Collections.Generic.IReadOnlyList<object> Attributes { get; }
                    System.Reflection.MemberInfo MemberInfo { get; }
                    string Name { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IControllerModelConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IControllerModelConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel controller);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IFilterModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IFilterModel
                {
                    System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata> Filters { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IParameterModelBaseConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IParameterModelBaseConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase parameter);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IParameterModelConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IParameterModelConvention
                {
                    void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModel parameter);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPropertyModel
                {
                    System.Collections.Generic.IDictionary<object, object> Properties { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.InferParameterBindingInfoConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InferParameterBindingInfoConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public InferParameterBindingInfoConvention(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider) => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.InvalidModelStateFilterConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class InvalidModelStateFilterConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public InvalidModelStateFilterConvention() => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ParameterModel : Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel
                {
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel Action { get => throw null; set => throw null; }
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public string DisplayName { get => throw null; }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public System.Reflection.ParameterInfo ParameterInfo { get => throw null; }
                    public ParameterModel(System.Reflection.ParameterInfo parameterInfo, System.Collections.Generic.IReadOnlyList<object> attributes) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public ParameterModel(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModel other) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public string ParameterName { get => throw null; set => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ParameterModelBase : Microsoft.AspNetCore.Mvc.ApplicationModels.IBindingModel
                {
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get => throw null; set => throw null; }
                    public string Name { get => throw null; set => throw null; }
                    protected ParameterModelBase(System.Type parameterType, System.Collections.Generic.IReadOnlyList<object> attributes) => throw null;
                    protected ParameterModelBase(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase other) => throw null;
                    public System.Type ParameterType { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.PropertyModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PropertyModel : Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase, Microsoft.AspNetCore.Mvc.ApplicationModels.IPropertyModel, Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel, Microsoft.AspNetCore.Mvc.ApplicationModels.IBindingModel
                {
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.ControllerModel Controller { get => throw null; set => throw null; }
                    System.Reflection.MemberInfo Microsoft.AspNetCore.Mvc.ApplicationModels.ICommonModel.MemberInfo { get => throw null; }
                    public System.Collections.Generic.IDictionary<object, object> Properties { get => throw null; }
                    public System.Reflection.PropertyInfo PropertyInfo { get => throw null; }
                    public PropertyModel(System.Reflection.PropertyInfo propertyInfo, System.Collections.Generic.IReadOnlyList<object> attributes) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public PropertyModel(Microsoft.AspNetCore.Mvc.ApplicationModels.PropertyModel other) : base(default(Microsoft.AspNetCore.Mvc.ApplicationModels.ParameterModelBase)) => throw null;
                    public string PropertyName { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.RouteTokenTransformerConvention` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RouteTokenTransformerConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention
                {
                    public void Apply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                    public RouteTokenTransformerConvention(Microsoft.AspNetCore.Routing.IOutboundParameterTransformer parameterTransformer) => throw null;
                    protected virtual bool ShouldApply(Microsoft.AspNetCore.Mvc.ApplicationModels.ActionModel action) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationModels.SelectorModel` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class SelectorModel
                {
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ActionConstraints.IActionConstraintMetadata> ActionConstraints { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ApplicationModels.AttributeRouteModel AttributeRouteModel { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<object> EndpointMetadata { get => throw null; }
                    public SelectorModel(Microsoft.AspNetCore.Mvc.ApplicationModels.SelectorModel other) => throw null;
                    public SelectorModel() => throw null;
                }

            }
            namespace ApplicationParts
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ApplicationPart
                {
                    protected ApplicationPart() => throw null;
                    public abstract string Name { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApplicationPartAttribute : System.Attribute
                {
                    public ApplicationPartAttribute(string assemblyName) => throw null;
                    public string AssemblyName { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ApplicationPartFactory
                {
                    protected ApplicationPartFactory() => throw null;
                    public static Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartFactory GetApplicationPartFactory(System.Reflection.Assembly assembly) => throw null;
                    public abstract System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetApplicationParts(System.Reflection.Assembly assembly);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ApplicationPartManager
                {
                    public ApplicationPartManager() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> ApplicationParts { get => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider> FeatureProviders { get => throw null; }
                    public void PopulateFeature<TFeature>(TFeature feature) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.AssemblyPart` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AssemblyPart : Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart, Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationPartTypeProvider
                {
                    public System.Reflection.Assembly Assembly { get => throw null; }
                    public AssemblyPart(System.Reflection.Assembly assembly) => throw null;
                    public override string Name { get => throw null; }
                    public System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> Types { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.DefaultApplicationPartFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DefaultApplicationPartFactory : Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartFactory
                {
                    public DefaultApplicationPartFactory() => throw null;
                    public override System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetApplicationParts(System.Reflection.Assembly assembly) => throw null;
                    public static System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetDefaultApplicationParts(System.Reflection.Assembly assembly) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ApplicationParts.DefaultApplicationPartFactory Instance { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApplicationFeatureProvider
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider<>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApplicationFeatureProvider<TFeature> : Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider
                {
                    void PopulateFeature(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> parts, TFeature feature);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationPartTypeProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApplicationPartTypeProvider
                {
                    System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> Types { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.ICompilationReferencesProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ICompilationReferencesProvider
                {
                    System.Collections.Generic.IEnumerable<string> GetReferencePaths();
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.NullApplicationPartFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class NullApplicationPartFactory : Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartFactory
                {
                    public override System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetApplicationParts(System.Reflection.Assembly assembly) => throw null;
                    public NullApplicationPartFactory() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.ProvideApplicationPartFactoryAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ProvideApplicationPartFactoryAttribute : System.Attribute
                {
                    public System.Type GetFactoryType() => throw null;
                    public ProvideApplicationPartFactoryAttribute(string factoryTypeName) => throw null;
                    public ProvideApplicationPartFactoryAttribute(System.Type factoryType) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.RelatedAssemblyAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RelatedAssemblyAttribute : System.Attribute
                {
                    public string AssemblyFileName { get => throw null; }
                    public static System.Collections.Generic.IReadOnlyList<System.Reflection.Assembly> GetRelatedAssemblies(System.Reflection.Assembly assembly, bool throwOnError) => throw null;
                    public RelatedAssemblyAttribute(string assemblyFileName) => throw null;
                }

            }
            namespace Authorization
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Authorization.AllowAnonymousFilter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AllowAnonymousFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Authorization.IAllowAnonymousFilter
                {
                    public AllowAnonymousFilter() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Authorization.AuthorizeFilter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AuthorizeFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IAsyncAuthorizationFilter
                {
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizeData> AuthorizeData { get => throw null; }
                    public AuthorizeFilter(string policy) => throw null;
                    public AuthorizeFilter(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizeData> authorizeData) => throw null;
                    public AuthorizeFilter(Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider policyProvider, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Authorization.IAuthorizeData> authorizeData) => throw null;
                    public AuthorizeFilter(Microsoft.AspNetCore.Authorization.AuthorizationPolicy policy) => throw null;
                    public AuthorizeFilter() => throw null;
                    Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Microsoft.AspNetCore.Mvc.Filters.IFilterFactory.CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                    bool Microsoft.AspNetCore.Mvc.Filters.IFilterFactory.IsReusable { get => throw null; }
                    public virtual System.Threading.Tasks.Task OnAuthorizationAsync(Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext context) => throw null;
                    public Microsoft.AspNetCore.Authorization.AuthorizationPolicy Policy { get => throw null; }
                    public Microsoft.AspNetCore.Authorization.IAuthorizationPolicyProvider PolicyProvider { get => throw null; }
                }

            }
            namespace Controllers
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ControllerActionDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor
                {
                    public virtual string ActionName { get => throw null; set => throw null; }
                    public ControllerActionDescriptor() => throw null;
                    public string ControllerName { get => throw null; set => throw null; }
                    public System.Reflection.TypeInfo ControllerTypeInfo { get => throw null; set => throw null; }
                    public override string DisplayName { get => throw null; set => throw null; }
                    public System.Reflection.MethodInfo MethodInfo { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.ControllerActivatorProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ControllerActivatorProvider : Microsoft.AspNetCore.Mvc.Controllers.IControllerActivatorProvider
                {
                    public ControllerActivatorProvider(Microsoft.AspNetCore.Mvc.Controllers.IControllerActivator controllerActivator) => throw null;
                    public System.Func<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor) => throw null;
                    public System.Action<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.ControllerBoundPropertyDescriptor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ControllerBoundPropertyDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor, Microsoft.AspNetCore.Mvc.Infrastructure.IPropertyInfoParameterDescriptor
                {
                    public ControllerBoundPropertyDescriptor() => throw null;
                    public System.Reflection.PropertyInfo PropertyInfo { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.ControllerFeature` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ControllerFeature
                {
                    public ControllerFeature() => throw null;
                    public System.Collections.Generic.IList<System.Reflection.TypeInfo> Controllers { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.ControllerFeatureProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ControllerFeatureProvider : Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider<Microsoft.AspNetCore.Mvc.Controllers.ControllerFeature>, Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider
                {
                    public ControllerFeatureProvider() => throw null;
                    protected virtual bool IsController(System.Reflection.TypeInfo typeInfo) => throw null;
                    public void PopulateFeature(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> parts, Microsoft.AspNetCore.Mvc.Controllers.ControllerFeature feature) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.ControllerParameterDescriptor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ControllerParameterDescriptor : Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor, Microsoft.AspNetCore.Mvc.Infrastructure.IParameterInfoParameterDescriptor
                {
                    public ControllerParameterDescriptor() => throw null;
                    public System.Reflection.ParameterInfo ParameterInfo { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.IControllerActivator` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IControllerActivator
                {
                    object Create(Microsoft.AspNetCore.Mvc.ControllerContext context);
                    void Release(Microsoft.AspNetCore.Mvc.ControllerContext context, object controller);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.IControllerActivatorProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IControllerActivatorProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateActivator(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor);
                    System.Action<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateReleaser(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.IControllerFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IControllerFactory
                {
                    object CreateController(Microsoft.AspNetCore.Mvc.ControllerContext context);
                    void ReleaseController(Microsoft.AspNetCore.Mvc.ControllerContext context, object controller);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.IControllerFactoryProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IControllerFactoryProvider
                {
                    System.Func<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateControllerFactory(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor);
                    System.Action<Microsoft.AspNetCore.Mvc.ControllerContext, object> CreateControllerReleaser(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor descriptor);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.IControllerPropertyActivator` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface IControllerPropertyActivator
                {
                    void Activate(Microsoft.AspNetCore.Mvc.ControllerContext context, object controller);
                    System.Action<Microsoft.AspNetCore.Mvc.ControllerContext, object> GetActivatorDelegate(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor actionDescriptor);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Controllers.ServiceBasedControllerActivator` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ServiceBasedControllerActivator : Microsoft.AspNetCore.Mvc.Controllers.IControllerActivator
                {
                    public object Create(Microsoft.AspNetCore.Mvc.ControllerContext actionContext) => throw null;
                    public virtual void Release(Microsoft.AspNetCore.Mvc.ControllerContext context, object controller) => throw null;
                    public ServiceBasedControllerActivator() => throw null;
                }

            }
            namespace Core
            {
                namespace Infrastructure
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.Core.Infrastructure.IAntiforgeryValidationFailedResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IAntiforgeryValidationFailedResult : Microsoft.AspNetCore.Mvc.IActionResult
                    {
                    }

                }
            }
            namespace Diagnostics
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterActionEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterActionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterActionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterActionFilterOnActionExecutedEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterActionFilterOnActionExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext ActionExecutedContext { get => throw null; }
                    public AfterActionFilterOnActionExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext actionExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterActionFilterOnActionExecutingEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterActionFilterOnActionExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext ActionExecutingContext { get => throw null; }
                    public AfterActionFilterOnActionExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext actionExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterActionFilterOnActionExecutionEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterActionFilterOnActionExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext ActionExecutedContext { get => throw null; }
                    public AfterActionFilterOnActionExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext actionExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterActionResultEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterActionResultEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public AfterActionResultEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.IActionResult result) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterAuthorizationFilterOnAuthorizationEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterAuthorizationFilterOnAuthorizationEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterAuthorizationFilterOnAuthorizationEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext authorizationContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext AuthorizationContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterControllerActionMethodEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterControllerActionMethodEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public AfterControllerActionMethodEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IReadOnlyDictionary<string, object> arguments, object controller, Microsoft.AspNetCore.Mvc.IActionResult result) => throw null;
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> Arguments { get => throw null; }
                    public object Controller { get => throw null; }
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterExceptionFilterOnExceptionEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterExceptionFilterOnExceptionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterExceptionFilterOnExceptionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ExceptionContext exceptionContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.ExceptionContext ExceptionContext { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterResourceFilterOnResourceExecutedEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterResourceFilterOnResourceExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterResourceFilterOnResourceExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext resourceExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext ResourceExecutedContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterResourceFilterOnResourceExecutingEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterResourceFilterOnResourceExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterResourceFilterOnResourceExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext resourceExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext ResourceExecutingContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterResourceFilterOnResourceExecutionEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterResourceFilterOnResourceExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterResourceFilterOnResourceExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext resourceExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext ResourceExecutedContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterResultFilterOnResultExecutedEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterResultFilterOnResultExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterResultFilterOnResultExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext resultExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext ResultExecutedContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterResultFilterOnResultExecutingEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterResultFilterOnResultExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterResultFilterOnResultExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext resultExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext ResultExecutingContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterResultFilterOnResultExecutionEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterResultFilterOnResultExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterResultFilterOnResultExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext resultExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext ResultExecutedContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeActionEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeActionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeActionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteData routeData) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeActionFilterOnActionExecutedEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeActionFilterOnActionExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext ActionExecutedContext { get => throw null; }
                    public BeforeActionFilterOnActionExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext actionExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeActionFilterOnActionExecutingEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeActionFilterOnActionExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext ActionExecutingContext { get => throw null; }
                    public BeforeActionFilterOnActionExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext actionExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeActionFilterOnActionExecutionEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeActionFilterOnActionExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext ActionExecutingContext { get => throw null; }
                    public BeforeActionFilterOnActionExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext actionExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeActionResultEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeActionResultEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public BeforeActionResultEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.IActionResult result) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.IActionResult Result { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeAuthorizationFilterOnAuthorizationEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeAuthorizationFilterOnAuthorizationEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext AuthorizationContext { get => throw null; }
                    public BeforeAuthorizationFilterOnAuthorizationEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.AuthorizationFilterContext authorizationContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeControllerActionMethodEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeControllerActionMethodEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public System.Collections.Generic.IReadOnlyDictionary<string, object> ActionArguments { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public BeforeControllerActionMethodEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IReadOnlyDictionary<string, object> actionArguments, object controller) => throw null;
                    public object Controller { get => throw null; }
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeExceptionFilterOnException` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeExceptionFilterOnException : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeExceptionFilterOnException(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ExceptionContext exceptionContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.ExceptionContext ExceptionContext { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeResourceFilterOnResourceExecutedEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeResourceFilterOnResourceExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeResourceFilterOnResourceExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext resourceExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext ResourceExecutedContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeResourceFilterOnResourceExecutingEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeResourceFilterOnResourceExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeResourceFilterOnResourceExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext resourceExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext ResourceExecutingContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeResourceFilterOnResourceExecutionEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeResourceFilterOnResourceExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeResourceFilterOnResourceExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext resourceExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext ResourceExecutingContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeResultFilterOnResultExecutedEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeResultFilterOnResultExecutedEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeResultFilterOnResultExecutedEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext resultExecutedContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext ResultExecutedContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeResultFilterOnResultExecutingEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeResultFilterOnResultExecutingEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeResultFilterOnResultExecutingEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext resultExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext ResultExecutingContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeResultFilterOnResultExecutionEventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeResultFilterOnResultExecutionEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeResultFilterOnResultExecutionEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext resultExecutingContext, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata filter) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Filter { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext ResultExecutingContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.EventData` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class EventData : System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>
                {
                    protected abstract int Count { get; }
                    int System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, object>>.Count { get => throw null; }
                    // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.EventData+Enumerator` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public struct Enumerator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>>
                    {
                        public System.Collections.Generic.KeyValuePair<string, object> Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        // Stub generator skipped constructor 
                        public bool MoveNext() => throw null;
                        void System.Collections.IEnumerator.Reset() => throw null;
                    }


                    protected EventData() => throw null;
                    protected const string EventNamespace = default;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>.GetEnumerator() => throw null;
                    protected abstract System.Collections.Generic.KeyValuePair<string, object> this[int index] { get; }
                    System.Collections.Generic.KeyValuePair<string, object> System.Collections.Generic.IReadOnlyList<System.Collections.Generic.KeyValuePair<string, object>>.this[int index] { get => throw null; }
                }

            }
            namespace Filters
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ActionFilterAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ActionFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IResultFilter, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IAsyncResultFilter, Microsoft.AspNetCore.Mvc.Filters.IAsyncActionFilter, Microsoft.AspNetCore.Mvc.Filters.IActionFilter
                {
                    protected ActionFilterAttribute() => throw null;
                    public virtual void OnActionExecuted(Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext context) => throw null;
                    public virtual void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnActionExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ActionExecutionDelegate next) => throw null;
                    public virtual void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context) => throw null;
                    public virtual void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnResultExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ResultExecutionDelegate next) => throw null;
                    public int Order { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ExceptionFilterAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ExceptionFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IExceptionFilter, Microsoft.AspNetCore.Mvc.Filters.IAsyncExceptionFilter
                {
                    protected ExceptionFilterAttribute() => throw null;
                    public virtual void OnException(Microsoft.AspNetCore.Mvc.Filters.ExceptionContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnExceptionAsync(Microsoft.AspNetCore.Mvc.Filters.ExceptionContext context) => throw null;
                    public int Order { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.FilterCollection` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FilterCollection : System.Collections.ObjectModel.Collection<Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata>
                {
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Add<TFilterType>(int order) where TFilterType : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Add<TFilterType>() where TFilterType : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Add(System.Type filterType, int order) => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata Add(System.Type filterType) => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata AddService<TFilterType>(int order) where TFilterType : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata AddService<TFilterType>() where TFilterType : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata AddService(System.Type filterType, int order) => throw null;
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata AddService(System.Type filterType) => throw null;
                    public FilterCollection() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.FilterScope` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class FilterScope
                {
                    public static int Action;
                    public static int Controller;
                    public static int First;
                    public static int Global;
                    public static int Last;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Filters.ResultFilterAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ResultFilterAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IResultFilter, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IAsyncResultFilter
                {
                    public virtual void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context) => throw null;
                    public virtual void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context) => throw null;
                    public virtual System.Threading.Tasks.Task OnResultExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ResultExecutionDelegate next) => throw null;
                    public int Order { get => throw null; set => throw null; }
                    protected ResultFilterAttribute() => throw null;
                }

            }
            namespace Formatters
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.FormatFilter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FormatFilter : Microsoft.AspNetCore.Mvc.Filters.IResultFilter, Microsoft.AspNetCore.Mvc.Filters.IResourceFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    public FormatFilter(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public virtual string GetFormat(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                    public void OnResourceExecuted(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext context) => throw null;
                    public void OnResourceExecuting(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext context) => throw null;
                    public void OnResultExecuted(Microsoft.AspNetCore.Mvc.Filters.ResultExecutedContext context) => throw null;
                    public void OnResultExecuting(Microsoft.AspNetCore.Mvc.Filters.ResultExecutingContext context) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.FormatterMappings` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FormatterMappings
                {
                    public bool ClearMediaTypeMappingForFormat(string format) => throw null;
                    public FormatterMappings() => throw null;
                    public string GetMediaTypeMappingForFormat(string format) => throw null;
                    public void SetMediaTypeMappingForFormat(string format, string contentType) => throw null;
                    public void SetMediaTypeMappingForFormat(string format, Microsoft.Net.Http.Headers.MediaTypeHeaderValue contentType) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.HttpNoContentOutputFormatter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HttpNoContentOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter
                {
                    public bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context) => throw null;
                    public HttpNoContentOutputFormatter() => throw null;
                    public bool TreatNullValueAsNoContent { get => throw null; set => throw null; }
                    public System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.IFormatFilter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface IFormatFilter : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                    string GetFormat(Microsoft.AspNetCore.Mvc.ActionContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.InputFormatter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class InputFormatter : Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiRequestFormatMetadataProvider
                {
                    public virtual bool CanRead(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context) => throw null;
                    protected virtual bool CanReadType(System.Type type) => throw null;
                    protected virtual object GetDefaultValueForType(System.Type modelType) => throw null;
                    public virtual System.Collections.Generic.IReadOnlyList<string> GetSupportedContentTypes(string contentType, System.Type objectType) => throw null;
                    protected InputFormatter() => throw null;
                    public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context) => throw null;
                    public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context);
                    public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection SupportedMediaTypes { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.MediaType` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct MediaType
                {
                    public Microsoft.Extensions.Primitives.StringSegment Charset { get => throw null; }
                    public static Microsoft.AspNetCore.Mvc.Formatters.MediaTypeSegmentWithQuality CreateMediaTypeSegmentWithQuality(string mediaType, int start) => throw null;
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
                    public MediaType(string mediaType, int offset, int? length) => throw null;
                    public MediaType(string mediaType) => throw null;
                    public MediaType(Microsoft.Extensions.Primitives.StringSegment mediaType) => throw null;
                    // Stub generator skipped constructor 
                    public static string ReplaceEncoding(string mediaType, System.Text.Encoding encoding) => throw null;
                    public static string ReplaceEncoding(Microsoft.Extensions.Primitives.StringSegment mediaType, System.Text.Encoding encoding) => throw null;
                    public Microsoft.Extensions.Primitives.StringSegment SubType { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment SubTypeSuffix { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment SubTypeWithoutSuffix { get => throw null; }
                    public Microsoft.Extensions.Primitives.StringSegment Type { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MediaTypeCollection : System.Collections.ObjectModel.Collection<string>
                {
                    public void Add(Microsoft.Net.Http.Headers.MediaTypeHeaderValue item) => throw null;
                    public void Insert(int index, Microsoft.Net.Http.Headers.MediaTypeHeaderValue item) => throw null;
                    public MediaTypeCollection() => throw null;
                    public bool Remove(Microsoft.Net.Http.Headers.MediaTypeHeaderValue item) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.MediaTypeSegmentWithQuality` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct MediaTypeSegmentWithQuality
                {
                    public Microsoft.Extensions.Primitives.StringSegment MediaType { get => throw null; }
                    public MediaTypeSegmentWithQuality(Microsoft.Extensions.Primitives.StringSegment mediaType, double quality) => throw null;
                    // Stub generator skipped constructor 
                    public double Quality { get => throw null; }
                    public override string ToString() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.OutputFormatter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class OutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter, Microsoft.AspNetCore.Mvc.ApiExplorer.IApiResponseTypeMetadataProvider
                {
                    public virtual bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context) => throw null;
                    protected virtual bool CanWriteType(System.Type type) => throw null;
                    public virtual System.Collections.Generic.IReadOnlyList<string> GetSupportedContentTypes(string contentType, System.Type objectType) => throw null;
                    protected OutputFormatter() => throw null;
                    public Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection SupportedMediaTypes { get => throw null; }
                    public virtual System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                    public abstract System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context);
                    public virtual void WriteResponseHeaders(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.StreamOutputFormatter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class StreamOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter
                {
                    public bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context) => throw null;
                    public StreamOutputFormatter() => throw null;
                    public System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.StringOutputFormatter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class StringOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextOutputFormatter
                {
                    public override bool CanWriteResult(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context) => throw null;
                    public StringOutputFormatter() => throw null;
                    public override System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.Text.Encoding encoding) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.SystemTextJsonInputFormatter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class SystemTextJsonInputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextInputFormatter, Microsoft.AspNetCore.Mvc.Formatters.IInputFormatterExceptionPolicy
                {
                    Microsoft.AspNetCore.Mvc.Formatters.InputFormatterExceptionPolicy Microsoft.AspNetCore.Mvc.Formatters.IInputFormatterExceptionPolicy.ExceptionPolicy { get => throw null; }
                    public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context, System.Text.Encoding encoding) => throw null;
                    public System.Text.Json.JsonSerializerOptions SerializerOptions { get => throw null; }
                    public SystemTextJsonInputFormatter(Microsoft.AspNetCore.Mvc.JsonOptions options, Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Mvc.Formatters.SystemTextJsonInputFormatter> logger) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.SystemTextJsonOutputFormatter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class SystemTextJsonOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextOutputFormatter
                {
                    public System.Text.Json.JsonSerializerOptions SerializerOptions { get => throw null; }
                    public SystemTextJsonOutputFormatter(System.Text.Json.JsonSerializerOptions jsonSerializerOptions) => throw null;
                    public override System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.Text.Encoding selectedEncoding) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.TextInputFormatter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class TextInputFormatter : Microsoft.AspNetCore.Mvc.Formatters.InputFormatter
                {
                    public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context) => throw null;
                    public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context, System.Text.Encoding encoding);
                    protected System.Text.Encoding SelectCharacterEncoding(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context) => throw null;
                    public System.Collections.Generic.IList<System.Text.Encoding> SupportedEncodings { get => throw null; }
                    protected TextInputFormatter() => throw null;
                    protected static System.Text.Encoding UTF16EncodingLittleEndian;
                    protected static System.Text.Encoding UTF8EncodingWithoutBOM;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Formatters.TextOutputFormatter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class TextOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.OutputFormatter
                {
                    public virtual System.Text.Encoding SelectCharacterEncoding(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                    public System.Collections.Generic.IList<System.Text.Encoding> SupportedEncodings { get => throw null; }
                    protected TextOutputFormatter() => throw null;
                    public override System.Threading.Tasks.Task WriteAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                    public override System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context) => throw null;
                    public abstract System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.Text.Encoding selectedEncoding);
                }

            }
            namespace Infrastructure
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ActionContextAccessor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionContextAccessor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionContextAccessor
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; set => throw null; }
                    public ActionContextAccessor() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ActionDescriptorCollection` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionDescriptorCollection
                {
                    public ActionDescriptorCollection(System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> items, int version) => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> Items { get => throw null; }
                    public int Version { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ActionDescriptorCollectionProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ActionDescriptorCollectionProvider : Microsoft.AspNetCore.Mvc.Infrastructure.IActionDescriptorCollectionProvider
                {
                    protected ActionDescriptorCollectionProvider() => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.Infrastructure.ActionDescriptorCollection ActionDescriptors { get; }
                    public abstract Microsoft.Extensions.Primitives.IChangeToken GetChangeToken();
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ActionResultObjectValueAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionResultObjectValueAttribute : System.Attribute
                {
                    public ActionResultObjectValueAttribute() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ActionResultStatusCodeAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ActionResultStatusCodeAttribute : System.Attribute
                {
                    public ActionResultStatusCodeAttribute() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.AmbiguousActionException` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AmbiguousActionException : System.InvalidOperationException
                {
                    public AmbiguousActionException(string message) => throw null;
                    protected AmbiguousActionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.CompatibilitySwitch<>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CompatibilitySwitch<TValue> : Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch where TValue : struct
                {
                    public CompatibilitySwitch(string name, TValue initialValue) => throw null;
                    public CompatibilitySwitch(string name) => throw null;
                    public bool IsValueSet { get => throw null; }
                    public string Name { get => throw null; }
                    public TValue Value { get => throw null; set => throw null; }
                    object Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch.Value { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ConfigureCompatibilityOptions<>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ConfigureCompatibilityOptions<TOptions> : Microsoft.Extensions.Options.IPostConfigureOptions<TOptions> where TOptions : class, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>
                {
                    protected ConfigureCompatibilityOptions(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.Infrastructure.MvcCompatibilityOptions> compatibilityOptions) => throw null;
                    protected abstract System.Collections.Generic.IReadOnlyDictionary<string, object> DefaultValues { get; }
                    public virtual void PostConfigure(string name, TOptions options) => throw null;
                    protected Microsoft.AspNetCore.Mvc.CompatibilityVersion Version { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ContentResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ContentResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.ContentResult>
                {
                    public ContentResultExecutor(Microsoft.Extensions.Logging.ILogger<Microsoft.AspNetCore.Mvc.Infrastructure.ContentResultExecutor> logger, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory httpResponseStreamWriterFactory) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.ContentResult result) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.DefaultOutputFormatterSelector` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DefaultOutputFormatterSelector : Microsoft.AspNetCore.Mvc.Infrastructure.OutputFormatterSelector
                {
                    public DefaultOutputFormatterSelector(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public override Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter SelectFormatter(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter> formatters, Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection contentTypes) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.DefaultStatusCodeAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DefaultStatusCodeAttribute : System.Attribute
                {
                    public DefaultStatusCodeAttribute(int statusCode) => throw null;
                    public int StatusCode { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.FileContentResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FileContentResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.FileResultExecutorBase, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.FileContentResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileContentResult result) => throw null;
                    public FileContentResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.Extensions.Logging.ILogger)) => throw null;
                    protected virtual System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileContentResult result, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, System.Int64 rangeLength) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.FileResultExecutorBase` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FileResultExecutorBase
                {
                    protected const int BufferSize = default;
                    protected static Microsoft.Extensions.Logging.ILogger CreateLogger<T>(Microsoft.Extensions.Logging.ILoggerFactory factory) => throw null;
                    public FileResultExecutorBase(Microsoft.Extensions.Logging.ILogger logger) => throw null;
                    protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                    protected virtual (Microsoft.Net.Http.Headers.RangeItemHeaderValue, System.Int64, bool) SetHeadersAndLog(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileResult result, System.Int64? fileLength, bool enableRangeProcessing, System.DateTimeOffset? lastModified = default(System.DateTimeOffset?), Microsoft.Net.Http.Headers.EntityTagHeaderValue etag = default(Microsoft.Net.Http.Headers.EntityTagHeaderValue)) => throw null;
                    protected static System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Http.HttpContext context, System.IO.Stream fileStream, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, System.Int64 rangeLength) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.FileStreamResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FileStreamResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.FileResultExecutorBase, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.FileStreamResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileStreamResult result) => throw null;
                    public FileStreamResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.Extensions.Logging.ILogger)) => throw null;
                    protected virtual System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.FileStreamResult result, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, System.Int64 rangeLength) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IActionContextAccessor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionContextAccessor
                {
                    Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IActionDescriptorChangeProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionDescriptorChangeProvider
                {
                    Microsoft.Extensions.Primitives.IChangeToken GetChangeToken();
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IActionDescriptorCollectionProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionDescriptorCollectionProvider
                {
                    Microsoft.AspNetCore.Mvc.Infrastructure.ActionDescriptorCollection ActionDescriptors { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IActionInvokerFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionInvokerFactory
                {
                    Microsoft.AspNetCore.Mvc.Abstractions.IActionInvoker CreateInvoker(Microsoft.AspNetCore.Mvc.ActionContext actionContext);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionResultExecutor<TResult> where TResult : Microsoft.AspNetCore.Mvc.IActionResult
                {
                    System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, TResult result);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultTypeMapper` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionResultTypeMapper
                {
                    Microsoft.AspNetCore.Mvc.IActionResult Convert(object value, System.Type returnType);
                    System.Type GetResultDataType(System.Type returnType);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IActionSelector` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionSelector
                {
                    Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor SelectBestCandidate(Microsoft.AspNetCore.Routing.RouteContext context, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> candidates);
                    System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor> SelectCandidates(Microsoft.AspNetCore.Routing.RouteContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IApiBehaviorMetadata` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApiBehaviorMetadata : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IClientErrorActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IClientErrorActionResult : Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult, Microsoft.AspNetCore.Mvc.IActionResult
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IClientErrorFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IClientErrorFactory
                {
                    Microsoft.AspNetCore.Mvc.IActionResult GetClientError(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.Infrastructure.IClientErrorActionResult clientError);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ICompatibilitySwitch
                {
                    bool IsValueSet { get; }
                    string Name { get; }
                    object Value { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IConvertToActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IConvertToActionResult
                {
                    Microsoft.AspNetCore.Mvc.IActionResult Convert();
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpRequestStreamReaderFactory
                {
                    System.IO.TextReader CreateReader(System.IO.Stream stream, System.Text.Encoding encoding);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IHttpResponseStreamWriterFactory
                {
                    System.IO.TextWriter CreateWriter(System.IO.Stream stream, System.Text.Encoding encoding);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IParameterInfoParameterDescriptor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IParameterInfoParameterDescriptor
                {
                    System.Reflection.ParameterInfo ParameterInfo { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IPropertyInfoParameterDescriptor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IPropertyInfoParameterDescriptor
                {
                    System.Reflection.PropertyInfo PropertyInfo { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IStatusCodeActionResult : Microsoft.AspNetCore.Mvc.IActionResult
                {
                    int? StatusCode { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.LocalRedirectResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class LocalRedirectResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.LocalRedirectResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.LocalRedirectResult result) => throw null;
                    public LocalRedirectResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ModelStateInvalidFilter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ModelStateInvalidFilter : Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IActionFilter
                {
                    public bool IsReusable { get => throw null; }
                    public ModelStateInvalidFilter(Microsoft.AspNetCore.Mvc.ApiBehaviorOptions apiBehaviorOptions, Microsoft.Extensions.Logging.ILogger logger) => throw null;
                    public void OnActionExecuted(Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext context) => throw null;
                    public void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context) => throw null;
                    public int Order { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.MvcCompatibilityOptions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class MvcCompatibilityOptions
                {
                    public Microsoft.AspNetCore.Mvc.CompatibilityVersion CompatibilityVersion { get => throw null; set => throw null; }
                    public MvcCompatibilityOptions() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ObjectResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ObjectResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.ObjectResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.ObjectResult result) => throw null;
                    protected Microsoft.AspNetCore.Mvc.Infrastructure.OutputFormatterSelector FormatterSelector { get => throw null; }
                    protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                    public ObjectResultExecutor(Microsoft.AspNetCore.Mvc.Infrastructure.OutputFormatterSelector formatterSelector, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> mvcOptions) => throw null;
                    public ObjectResultExecutor(Microsoft.AspNetCore.Mvc.Infrastructure.OutputFormatterSelector formatterSelector, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    protected System.Func<System.IO.Stream, System.Text.Encoding, System.IO.TextWriter> WriterFactory { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.OutputFormatterSelector` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class OutputFormatterSelector
                {
                    protected OutputFormatterSelector() => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter SelectFormatter(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterCanWriteContext context, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IOutputFormatter> formatters, Microsoft.AspNetCore.Mvc.Formatters.MediaTypeCollection mediaTypes);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.PhysicalFileResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PhysicalFileResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.FileResultExecutorBase, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.PhysicalFileResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.PhysicalFileResult result) => throw null;
                    // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.PhysicalFileResultExecutor+FileMetadata` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    protected class FileMetadata
                    {
                        public bool Exists { get => throw null; set => throw null; }
                        public FileMetadata() => throw null;
                        public System.DateTimeOffset LastModified { get => throw null; set => throw null; }
                        public System.Int64 Length { get => throw null; set => throw null; }
                    }


                    protected virtual Microsoft.AspNetCore.Mvc.Infrastructure.PhysicalFileResultExecutor.FileMetadata GetFileInfo(string path) => throw null;
                    protected virtual System.IO.Stream GetFileStream(string path) => throw null;
                    public PhysicalFileResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.Extensions.Logging.ILogger)) => throw null;
                    protected virtual System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.PhysicalFileResult result, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, System.Int64 rangeLength) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.ProblemDetailsFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ProblemDetailsFactory
                {
                    public abstract Microsoft.AspNetCore.Mvc.ProblemDetails CreateProblemDetails(Microsoft.AspNetCore.Http.HttpContext httpContext, int? statusCode = default(int?), string title = default(string), string type = default(string), string detail = default(string), string instance = default(string));
                    public abstract Microsoft.AspNetCore.Mvc.ValidationProblemDetails CreateValidationProblemDetails(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelStateDictionary, int? statusCode = default(int?), string title = default(string), string type = default(string), string detail = default(string), string instance = default(string));
                    protected ProblemDetailsFactory() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.RedirectResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RedirectResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.RedirectResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.RedirectResult result) => throw null;
                    public RedirectResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.RedirectToActionResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RedirectToActionResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.RedirectToActionResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.RedirectToActionResult result) => throw null;
                    public RedirectToActionResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.RedirectToPageResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RedirectToPageResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.RedirectToPageResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.RedirectToPageResult result) => throw null;
                    public RedirectToPageResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.RedirectToRouteResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RedirectToRouteResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.RedirectToRouteResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.RedirectToRouteResult result) => throw null;
                    public RedirectToRouteResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Infrastructure.VirtualFileResultExecutor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class VirtualFileResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.FileResultExecutorBase, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.VirtualFileResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.VirtualFileResult result) => throw null;
                    protected virtual System.IO.Stream GetFileStream(Microsoft.Extensions.FileProviders.IFileInfo fileInfo) => throw null;
                    public VirtualFileResultExecutor(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnvironment) : base(default(Microsoft.Extensions.Logging.ILogger)) => throw null;
                    protected virtual System.Threading.Tasks.Task WriteFileAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.VirtualFileResult result, Microsoft.Extensions.FileProviders.IFileInfo fileInfo, Microsoft.Net.Http.Headers.RangeItemHeaderValue range, System.Int64 rangeLength) => throw null;
                }

            }
            namespace ModelBinding
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.BindNeverAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BindNeverAttribute : Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehaviorAttribute
                {
                    public BindNeverAttribute() : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehavior)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.BindRequiredAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BindRequiredAttribute : Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehaviorAttribute
                {
                    public BindRequiredAttribute() : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehavior)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehavior` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum BindingBehavior
                {
                    Never,
                    Optional,
                    Required,
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehaviorAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BindingBehaviorAttribute : System.Attribute
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehavior Behavior { get => throw null; }
                    public BindingBehaviorAttribute(Microsoft.AspNetCore.Mvc.ModelBinding.BindingBehavior behavior) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.BindingSourceValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class BindingSourceValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceValueProvider
                {
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                    public BindingSourceValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public abstract bool ContainsPrefix(string prefix);
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.CompositeValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CompositeValueProvider : System.Collections.ObjectModel.Collection<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider>, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IKeyRewriterValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IEnumerableValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceValueProvider
                {
                    public CompositeValueProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider> valueProviders) => throw null;
                    public CompositeValueProvider() => throw null;
                    public virtual bool ContainsPrefix(string prefix) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.ModelBinding.CompositeValueProvider> CreateAsync(Microsoft.AspNetCore.Mvc.ControllerContext controllerContext) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.ModelBinding.CompositeValueProvider> CreateAsync(Microsoft.AspNetCore.Mvc.ActionContext actionContext, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> factories) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter() => throw null;
                    public virtual System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected override void InsertItem(int index, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider item) => throw null;
                    protected override void SetItem(int index, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider item) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.DefaultModelBindingContext` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DefaultModelBindingContext : Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext
                {
                    public override Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; set => throw null; }
                    public override string BinderModelName { get => throw null; set => throw null; }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set => throw null; }
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext CreateBindingContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo bindingInfo, string modelName) => throw null;
                    public DefaultModelBindingContext() => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext.NestedScope EnterNestedScope(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata modelMetadata, string fieldName, string modelName, object model) => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext.NestedScope EnterNestedScope() => throw null;
                    protected override void ExitNestedScope() => throw null;
                    public override string FieldName { get => throw null; set => throw null; }
                    public override bool IsTopLevelObject { get => throw null; set => throw null; }
                    public override object Model { get => throw null; set => throw null; }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; set => throw null; }
                    public override string ModelName { get => throw null; set => throw null; }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider OriginalValueProvider { get => throw null; set => throw null; }
                    public override System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get => throw null; set => throw null; }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult Result { get => throw null; set => throw null; }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary ValidationState { get => throw null; set => throw null; }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider ValueProvider { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.DefaultPropertyFilterProvider<>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class DefaultPropertyFilterProvider<TModel> : Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider where TModel : class
                {
                    public DefaultPropertyFilterProvider() => throw null;
                    public virtual string Prefix { get => throw null; }
                    public virtual System.Func<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, bool> PropertyFilter { get => throw null; }
                    public virtual System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression<System.Func<TModel, object>>> PropertyIncludeExpressions { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.EmptyModelMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EmptyModelMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelMetadataProvider
                {
                    public EmptyModelMetadataProvider() : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.FormFileValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FormFileValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    public bool ContainsPrefix(string prefix) => throw null;
                    public FormFileValueProvider(Microsoft.AspNetCore.Http.IFormFileCollection files) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.FormFileValueProviderFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FormFileValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public FormFileValueProviderFactory() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.FormValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FormValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSourceValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IEnumerableValueProvider
                {
                    public override bool ContainsPrefix(string prefix) => throw null;
                    public System.Globalization.CultureInfo Culture { get => throw null; }
                    public FormValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, Microsoft.AspNetCore.Http.IFormCollection values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                    public virtual System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.PrefixContainer PrefixContainer { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.FormValueProviderFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class FormValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public FormValueProviderFactory() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IBindingSourceValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IBindingSourceValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ICollectionModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ICollectionModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                {
                    bool CanCreateInstance(System.Type targetType);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IEnumerableValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IEnumerableValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IKeyRewriterValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IKeyRewriterValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter();
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IModelBinderFactory
                {
                    Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder CreateBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderFactoryContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.JQueryFormValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class JQueryFormValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.JQueryValueProvider
                {
                    public JQueryFormValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues> values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource), default(System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>), default(System.Globalization.CultureInfo)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.JQueryFormValueProviderFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class JQueryFormValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public JQueryFormValueProviderFactory() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.JQueryQueryStringValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class JQueryQueryStringValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.JQueryValueProvider
                {
                    public JQueryQueryStringValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues> values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource), default(System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues>), default(System.Globalization.CultureInfo)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.JQueryQueryStringValueProviderFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class JQueryQueryStringValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public JQueryQueryStringValueProviderFactory() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.JQueryValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class JQueryValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSourceValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IKeyRewriterValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IEnumerableValueProvider
                {
                    public override bool ContainsPrefix(string prefix) => throw null;
                    public System.Globalization.CultureInfo Culture { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider Filter() => throw null;
                    public System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected JQueryValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, System.Collections.Generic.IDictionary<string, Microsoft.Extensions.Primitives.StringValues> values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.PrefixContainer PrefixContainer { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ModelAttributes
                {
                    public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForParameter(System.Reflection.ParameterInfo parameterInfo, System.Type modelType) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForParameter(System.Reflection.ParameterInfo parameterInfo) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForProperty(System.Type type, System.Reflection.PropertyInfo property) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForProperty(System.Type containerType, System.Reflection.PropertyInfo property, System.Type modelType) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes GetAttributesForType(System.Type type) => throw null;
                    public System.Collections.Generic.IReadOnlyList<object> ParameterAttributes { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<object> PropertyAttributes { get => throw null; }
                    public System.Collections.Generic.IReadOnlyList<object> TypeAttributes { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ModelBinderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderFactory
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder CreateBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderFactoryContext context) => throw null;
                    public ModelBinderFactory(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> options, System.IServiceProvider serviceProvider) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderFactoryContext` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ModelBinderFactoryContext
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.BindingInfo BindingInfo { get => throw null; set => throw null; }
                    public object CacheToken { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; set => throw null; }
                    public ModelBinderFactoryContext() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class ModelBinderProviderExtensions
                {
                    public static void RemoveType<TModelBinderProvider>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider> list) where TModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider => throw null;
                    public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider> list, System.Type type) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadataProviderExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class ModelMetadataProviderExtensions
                {
                    public static Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForProperty(this Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider provider, System.Type containerType, string propertyName) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ModelNames` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class ModelNames
                {
                    public static string CreateIndexModelName(string parentName, string index) => throw null;
                    public static string CreateIndexModelName(string parentName, int index) => throw null;
                    public static string CreatePropertyModelName(string prefix, string propertyName) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ObjectModelValidator` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class ObjectModelValidator : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IObjectModelValidator
                {
                    public abstract Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor GetValidationVisitor(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider validatorProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorCache validatorCache, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState);
                    public ObjectModelValidator(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider, System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> validatorProviders) => throw null;
                    public virtual void Validate(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState, string prefix, object model, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object container) => throw null;
                    public virtual void Validate(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState, string prefix, object model, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata) => throw null;
                    public virtual void Validate(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState, string prefix, object model) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ParameterBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ParameterBinder
                {
                    public virtual System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult> BindModelAsync(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder modelBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor parameter, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object value, object container) => throw null;
                    public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult> BindModelAsync(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder modelBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider valueProvider, Microsoft.AspNetCore.Mvc.Abstractions.ParameterDescriptor parameter, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object value) => throw null;
                    protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                    public ParameterBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderFactory modelBinderFactory, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IObjectModelValidator validator, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> mvcOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.PrefixContainer` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class PrefixContainer
                {
                    public bool ContainsPrefix(string prefix) => throw null;
                    public System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                    public PrefixContainer(System.Collections.Generic.ICollection<string> values) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.QueryStringValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class QueryStringValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSourceValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IValueProvider, Microsoft.AspNetCore.Mvc.ModelBinding.IEnumerableValueProvider
                {
                    public override bool ContainsPrefix(string prefix) => throw null;
                    public System.Globalization.CultureInfo Culture { get => throw null; }
                    public virtual System.Collections.Generic.IDictionary<string, string> GetKeysFromPrefix(string prefix) => throw null;
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.PrefixContainer PrefixContainer { get => throw null; }
                    public QueryStringValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, Microsoft.AspNetCore.Http.IQueryCollection values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.QueryStringValueProviderFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class QueryStringValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public QueryStringValueProviderFactory() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.RouteValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RouteValueProvider : Microsoft.AspNetCore.Mvc.ModelBinding.BindingSourceValueProvider
                {
                    public override bool ContainsPrefix(string key) => throw null;
                    protected System.Globalization.CultureInfo Culture { get => throw null; }
                    public override Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult GetValue(string key) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.PrefixContainer PrefixContainer { get => throw null; }
                    public RouteValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, Microsoft.AspNetCore.Routing.RouteValueDictionary values, System.Globalization.CultureInfo culture) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                    public RouteValueProvider(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource, Microsoft.AspNetCore.Routing.RouteValueDictionary values) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.RouteValueProviderFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RouteValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory
                {
                    public System.Threading.Tasks.Task CreateValueProviderAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryContext context) => throw null;
                    public RouteValueProviderFactory() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.SuppressChildValidationMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class SuppressChildValidationMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IValidationMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                {
                    public void CreateValidationMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadataProviderContext context) => throw null;
                    public string FullTypeName { get => throw null; }
                    public SuppressChildValidationMetadataProvider(string fullTypeName) => throw null;
                    public SuppressChildValidationMetadataProvider(System.Type type) => throw null;
                    public System.Type Type { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.UnsupportedContentTypeException` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UnsupportedContentTypeException : System.Exception
                {
                    public UnsupportedContentTypeException(string message) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.UnsupportedContentTypeFilter` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UnsupportedContentTypeFilter : Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IActionFilter
                {
                    public void OnActionExecuted(Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext context) => throw null;
                    public void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context) => throw null;
                    public int Order { get => throw null; set => throw null; }
                    public UnsupportedContentTypeFilter() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderFactoryExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class ValueProviderFactoryExtensions
                {
                    public static void RemoveType<TValueProviderFactory>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> list) where TValueProviderFactory : Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory => throw null;
                    public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.IValueProviderFactory> list, System.Type type) => throw null;
                }

                namespace Binders
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ArrayModelBinder<>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ArrayModelBinder<TElement> : Microsoft.AspNetCore.Mvc.ModelBinding.Binders.CollectionModelBinder<TElement>
                    {
                        public ArrayModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes, Microsoft.AspNetCore.Mvc.MvcOptions mvcOptions) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public ArrayModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public ArrayModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public override bool CanCreateInstance(System.Type targetType) => throw null;
                        protected override object ConvertToCollectionType(System.Type targetType, System.Collections.Generic.IEnumerable<TElement> collection) => throw null;
                        protected override void CopyToModel(object target, System.Collections.Generic.IEnumerable<TElement> sourceCollection) => throw null;
                        protected override object CreateEmptyCollection(System.Type targetType) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ArrayModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ArrayModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public ArrayModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.BinderTypeModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class BinderTypeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public BinderTypeModelBinder(System.Type binderType) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.BinderTypeModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class BinderTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public BinderTypeModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.BodyModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class BodyModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public BodyModelBinder(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                        public BodyModelBinder(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public BodyModelBinder(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.BodyModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class BodyModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public BodyModelBinderProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                        public BodyModelBinderProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public BodyModelBinderProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.IInputFormatter> formatters, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpRequestStreamReaderFactory readerFactory) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ByteArrayModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ByteArrayModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public ByteArrayModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ByteArrayModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ByteArrayModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public ByteArrayModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.CancellationTokenModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CancellationTokenModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public CancellationTokenModelBinder() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.CancellationTokenModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CancellationTokenModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public CancellationTokenModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.CollectionModelBinder<>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CollectionModelBinder<TElement> : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder, Microsoft.AspNetCore.Mvc.ModelBinding.ICollectionModelBinder
                    {
                        protected void AddErrorIfBindingRequired(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public virtual System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public virtual bool CanCreateInstance(System.Type targetType) => throw null;
                        public CollectionModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes, Microsoft.AspNetCore.Mvc.MvcOptions mvcOptions) => throw null;
                        public CollectionModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes) => throw null;
                        public CollectionModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder elementBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        protected virtual object ConvertToCollectionType(System.Type targetType, System.Collections.Generic.IEnumerable<TElement> collection) => throw null;
                        protected virtual void CopyToModel(object target, System.Collections.Generic.IEnumerable<TElement> sourceCollection) => throw null;
                        protected virtual object CreateEmptyCollection(System.Type targetType) => throw null;
                        protected object CreateInstance(System.Type targetType) => throw null;
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder ElementBinder { get => throw null; }
                        protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.CollectionModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CollectionModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public CollectionModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ComplexObjectModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ComplexObjectModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ComplexObjectModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ComplexObjectModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public ComplexObjectModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ComplexTypeModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ComplexTypeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        protected virtual System.Threading.Tasks.Task BindProperty(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        protected virtual bool CanBindProperty(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata propertyMetadata) => throw null;
                        public ComplexTypeModelBinder(System.Collections.Generic.IDictionary<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder> propertyBinders, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes) => throw null;
                        public ComplexTypeModelBinder(System.Collections.Generic.IDictionary<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder> propertyBinders, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        protected virtual object CreateModel(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        protected virtual void SetProperty(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext, string modelName, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata propertyMetadata, Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingResult result) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ComplexTypeModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ComplexTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public ComplexTypeModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.DateTimeModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DateTimeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public DateTimeModelBinder(System.Globalization.DateTimeStyles supportedStyles, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.DateTimeModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DateTimeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public DateTimeModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.DecimalModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DecimalModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public DecimalModelBinder(System.Globalization.NumberStyles supportedStyles, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.DictionaryModelBinder<,>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DictionaryModelBinder<TKey, TValue> : Microsoft.AspNetCore.Mvc.ModelBinding.Binders.CollectionModelBinder<System.Collections.Generic.KeyValuePair<TKey, TValue>>
                    {
                        public override System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public override bool CanCreateInstance(System.Type targetType) => throw null;
                        protected override object ConvertToCollectionType(System.Type targetType, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>> collection) => throw null;
                        protected override object CreateEmptyCollection(System.Type targetType) => throw null;
                        public DictionaryModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder keyBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder valueBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes, Microsoft.AspNetCore.Mvc.MvcOptions mvcOptions) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public DictionaryModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder keyBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder valueBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, bool allowValidatingTopLevelNodes) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                        public DictionaryModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder keyBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder valueBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.DictionaryModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DictionaryModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public DictionaryModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.DoubleModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DoubleModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public DoubleModelBinder(System.Globalization.NumberStyles supportedStyles, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.EnumTypeModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class EnumTypeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.Binders.SimpleTypeModelBinder
                    {
                        protected override void CheckModel(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult valueProviderResult, object model) => throw null;
                        public EnumTypeModelBinder(bool suppressBindingUndefinedValueToEnumType, System.Type modelType, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(System.Type), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.EnumTypeModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class EnumTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public EnumTypeModelBinderProvider(Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.FloatModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class FloatModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public FloatModelBinder(System.Globalization.NumberStyles supportedStyles, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.FloatingPointTypeModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class FloatingPointTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public FloatingPointTypeModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.FormCollectionModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class FormCollectionModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public FormCollectionModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.FormCollectionModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class FormCollectionModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public FormCollectionModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.FormFileModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class FormFileModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public FormFileModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.FormFileModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class FormFileModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public FormFileModelBinderProvider() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.HeaderModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class HeaderModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public HeaderModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder innerModelBinder) => throw null;
                        public HeaderModelBinder(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.HeaderModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class HeaderModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                        public HeaderModelBinderProvider() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.KeyValuePairModelBinder<,>` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class KeyValuePairModelBinder<TKey, TValue> : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public KeyValuePairModelBinder(Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder keyBinder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder valueBinder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.KeyValuePairModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class KeyValuePairModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                        public KeyValuePairModelBinderProvider() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ServicesModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ServicesModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        public ServicesModelBinder() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.ServicesModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ServicesModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                        public ServicesModelBinderProvider() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.SimpleTypeModelBinder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class SimpleTypeModelBinder : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder
                    {
                        public System.Threading.Tasks.Task BindModelAsync(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext) => throw null;
                        protected virtual void CheckModel(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBindingContext bindingContext, Microsoft.AspNetCore.Mvc.ModelBinding.ValueProviderResult valueProviderResult, object model) => throw null;
                        public SimpleTypeModelBinder(System.Type type, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Binders.SimpleTypeModelBinderProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class SimpleTypeModelBinderProvider : Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinderProvider
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IModelBinder GetBinder(Microsoft.AspNetCore.Mvc.ModelBinding.ModelBinderProviderContext context) => throw null;
                        public SimpleTypeModelBinderProvider() => throw null;
                    }

                }
                namespace Metadata
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadata` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class BindingMetadata
                    {
                        public string BinderModelName { get => throw null; set => throw null; }
                        public System.Type BinderType { get => throw null; set => throw null; }
                        public BindingMetadata() => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; set => throw null; }
                        public System.Reflection.ConstructorInfo BoundConstructor { get => throw null; set => throw null; }
                        public bool IsBindingAllowed { get => throw null; set => throw null; }
                        public bool IsBindingRequired { get => throw null; set => throw null; }
                        public bool? IsReadOnly { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider ModelBindingMessageProvider { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.IPropertyFilterProvider PropertyFilterProvider { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadataProviderContext` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingSourceMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class BindingSourceMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IBindingMetadataProvider
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource BindingSource { get => throw null; }
                        public BindingSourceMetadataProvider(System.Type type, Microsoft.AspNetCore.Mvc.ModelBinding.BindingSource bindingSource) => throw null;
                        public void CreateBindingMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadataProviderContext context) => throw null;
                        public System.Type Type { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DefaultMetadataDetails
                    {
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadata BindingMetadata { get => throw null; set => throw null; }
                        public System.Func<object[], object> BoundConstructorInvoker { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata[] BoundConstructorParameters { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ContainerMetadata { get => throw null; set => throw null; }
                        public DefaultMetadataDetails(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key, Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes attributes) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadata DisplayMetadata { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity Key { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes ModelAttributes { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata[] Properties { get => throw null; set => throw null; }
                        public System.Func<object, object> PropertyGetter { get => throw null; set => throw null; }
                        public System.Action<object, object> PropertySetter { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadata ValidationMetadata { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DefaultModelBindingMessageProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelBindingMessageProvider
                    {
                        public override System.Func<string, string, string> AttemptedValueIsInvalidAccessor { get => throw null; }
                        public DefaultModelBindingMessageProvider(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider originalProvider) => throw null;
                        public DefaultModelBindingMessageProvider() => throw null;
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

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelMetadata` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
                        public override string DataTypeName { get => throw null; }
                        public DefaultModelMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider provider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider detailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails details, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider modelBindingMessageProvider) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity)) => throw null;
                        public DefaultModelMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider provider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider detailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails details) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity)) => throw null;
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

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DefaultModelMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadataProvider
                    {
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata CreateModelMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails entry) => throw null;
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails CreateParameterDetails(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key) => throw null;
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails[] CreatePropertyDetails(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key) => throw null;
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultMetadataDetails CreateTypeDetails(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key) => throw null;
                        public DefaultModelMetadataProvider(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider detailsProvider, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcOptions> optionsAccessor) => throw null;
                        public DefaultModelMetadataProvider(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider detailsProvider) => throw null;
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider DetailsProvider { get => throw null; }
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForConstructor(System.Reflection.ConstructorInfo constructorInfo, System.Type modelType) => throw null;
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForParameter(System.Reflection.ParameterInfo parameter, System.Type modelType) => throw null;
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForParameter(System.Reflection.ParameterInfo parameter) => throw null;
                        public override System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata> GetMetadataForProperties(System.Type modelType) => throw null;
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForProperty(System.Reflection.PropertyInfo propertyInfo, System.Type modelType) => throw null;
                        public override Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata GetMetadataForType(System.Type modelType) => throw null;
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DefaultModelBindingMessageProvider ModelBindingMessageProvider { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadata` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DisplayMetadata
                    {
                        public System.Collections.Generic.IDictionary<object, object> AdditionalValues { get => throw null; }
                        public bool ConvertEmptyStringToNull { get => throw null; set => throw null; }
                        public string DataTypeName { get => throw null; set => throw null; }
                        public System.Func<string> Description { get => throw null; set => throw null; }
                        public string DisplayFormatString { get => throw null; set => throw null; }
                        public System.Func<string> DisplayFormatStringProvider { get => throw null; set => throw null; }
                        public DisplayMetadata() => throw null;
                        public System.Func<string> DisplayName { get => throw null; set => throw null; }
                        public string EditFormatString { get => throw null; set => throw null; }
                        public System.Func<string> EditFormatStringProvider { get => throw null; set => throw null; }
                        public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<Microsoft.AspNetCore.Mvc.ModelBinding.EnumGroupAndName, string>> EnumGroupedDisplayNamesAndValues { get => throw null; set => throw null; }
                        public System.Collections.Generic.IReadOnlyDictionary<string, string> EnumNamesAndValues { get => throw null; set => throw null; }
                        public bool HasNonDefaultEditFormat { get => throw null; set => throw null; }
                        public bool HideSurroundingHtml { get => throw null; set => throw null; }
                        public bool HtmlEncode { get => throw null; set => throw null; }
                        public bool IsEnum { get => throw null; set => throw null; }
                        public bool IsFlagsEnum { get => throw null; set => throw null; }
                        public string NullDisplayText { get => throw null; set => throw null; }
                        public System.Func<string> NullDisplayTextProvider { get => throw null; set => throw null; }
                        public int Order { get => throw null; set => throw null; }
                        public System.Func<string> Placeholder { get => throw null; set => throw null; }
                        public bool ShowForDisplay { get => throw null; set => throw null; }
                        public bool ShowForEdit { get => throw null; set => throw null; }
                        public string SimpleDisplayProperty { get => throw null; set => throw null; }
                        public string TemplateHint { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadataProviderContext` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class DisplayMetadataProviderContext
                    {
                        public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadata DisplayMetadata { get => throw null; }
                        public DisplayMetadataProviderContext(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key, Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes attributes) => throw null;
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity Key { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> PropertyAttributes { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> TypeAttributes { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ExcludeBindingMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ExcludeBindingMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IBindingMetadataProvider
                    {
                        public void CreateBindingMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadataProviderContext context) => throw null;
                        public ExcludeBindingMetadataProvider(System.Type type) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IBindingMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IBindingMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                    {
                        void CreateBindingMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadataProviderContext context);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ICompositeMetadataDetailsProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface ICompositeMetadataDetailsProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IValidationMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IDisplayMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IBindingMetadataProvider
                    {
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IDisplayMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IDisplayMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                    {
                        void CreateDisplayMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.DisplayMetadataProviderContext context);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IMetadataDetailsProvider
                    {
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IValidationMetadataProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IValidationMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                    {
                        void CreateValidationMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadataProviderContext context);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.MetadataDetailsProviderExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public static class MetadataDetailsProviderExtensions
                    {
                        public static void RemoveType<TMetadataDetailsProvider>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider> list) where TMetadataDetailsProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider => throw null;
                        public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider> list, System.Type type) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadata` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ValidationMetadata
                    {
                        public bool? HasValidators { get => throw null; set => throw null; }
                        public bool? IsRequired { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IPropertyValidationFilter PropertyValidationFilter { get => throw null; set => throw null; }
                        public bool? ValidateChildren { get => throw null; set => throw null; }
                        public ValidationMetadata() => throw null;
                        public System.Collections.Generic.IList<object> ValidatorMetadata { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadataProviderContext` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ValidationMetadataProviderContext
                    {
                        public System.Collections.Generic.IReadOnlyList<object> Attributes { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity Key { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> ParameterAttributes { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> PropertyAttributes { get => throw null; }
                        public System.Collections.Generic.IReadOnlyList<object> TypeAttributes { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ValidationMetadata ValidationMetadata { get => throw null; }
                        public ValidationMetadataProviderContext(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.ModelMetadataIdentity key, Microsoft.AspNetCore.Mvc.ModelBinding.ModelAttributes attributes) => throw null;
                    }

                }
                namespace Validation
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorCache` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ClientValidatorCache
                    {
                        public ClientValidatorCache() => throw null;
                        public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator> GetValidators(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider validatorProvider) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.CompositeClientModelValidatorProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CompositeClientModelValidatorProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider
                    {
                        public CompositeClientModelValidatorProvider(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider> providers) => throw null;
                        public void CreateValidators(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorProviderContext context) => throw null;
                        public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider> ValidatorProviders { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.CompositeModelValidatorProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CompositeModelValidatorProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider
                    {
                        public CompositeModelValidatorProvider(System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> providers) => throw null;
                        public void CreateValidators(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidatorProviderContext context) => throw null;
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> ValidatorProviders { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IMetadataBasedModelValidatorProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IMetadataBasedModelValidatorProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider
                    {
                        bool HasValidators(System.Type modelType, System.Collections.Generic.IList<object> validatorMetadata);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IObjectModelValidator` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IObjectModelValidator
                    {
                        void Validate(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState, string prefix, object model);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ModelValidatorProviderExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public static class ModelValidatorProviderExtensions
                    {
                        public static void RemoveType<TModelValidatorProvider>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> list) where TModelValidatorProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider => throw null;
                        public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider> list, System.Type type) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidateNeverAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ValidateNeverAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IPropertyValidationFilter
                    {
                        public bool ShouldValidateEntry(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry entry, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationEntry parentEntry) => throw null;
                        public ValidateNeverAttribute() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ValidationVisitor
                    {
                        public bool AllowShortCircuitingValidationWhenNoValidatorsArePresent { get => throw null; set => throw null; }
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorCache Cache { get => throw null; }
                        protected object Container { get => throw null; set => throw null; }
                        protected Microsoft.AspNetCore.Mvc.ActionContext Context { get => throw null; }
                        protected virtual Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateEntry GetValidationEntry(object model) => throw null;
                        protected string Key { get => throw null; set => throw null; }
                        public int? MaxValidationDepth { get => throw null; set => throw null; }
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; set => throw null; }
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get => throw null; }
                        protected object Model { get => throw null; set => throw null; }
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                        // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor+StateManager` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        protected struct StateManager : System.IDisposable
                        {
                            public void Dispose() => throw null;
                            public static Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor.StateManager Recurse(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor visitor, string key, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object model, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy strategy) => throw null;
                            public StateManager(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationVisitor visitor, object newModel) => throw null;
                            // Stub generator skipped constructor 
                        }


                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy Strategy { get => throw null; set => throw null; }
                        protected virtual void SuppressValidation(string key) => throw null;
                        public virtual bool Validate(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model, bool alwaysValidateAtTopLevel, object container) => throw null;
                        public virtual bool Validate(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model, bool alwaysValidateAtTopLevel) => throw null;
                        public bool Validate(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model) => throw null;
                        public bool ValidateComplexTypesIfChildValidationFails { get => throw null; set => throw null; }
                        protected virtual bool ValidateNode() => throw null;
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary ValidationState { get => throw null; }
                        public ValidationVisitor(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider validatorProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorCache validatorCache, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidationStateDictionary validationState) => throw null;
                        protected Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider ValidatorProvider { get => throw null; }
                        protected virtual bool Visit(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, string key, object model) => throw null;
                        protected virtual bool VisitChildren(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy strategy) => throw null;
                        protected virtual bool VisitComplexType(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IValidationStrategy defaultStrategy) => throw null;
                        protected virtual bool VisitSimpleType() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ValidatorCache` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ValidatorCache
                    {
                        public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidator> GetValidators(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IModelValidatorProvider validatorProvider) => throw null;
                        public ValidatorCache() => throw null;
                    }

                }
            }
            namespace Routing
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Routing.DynamicRouteValueTransformer` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class DynamicRouteValueTransformer
                {
                    protected DynamicRouteValueTransformer() => throw null;
                    public virtual System.Threading.Tasks.ValueTask<System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint>> FilterAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary values, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Http.Endpoint> endpoints) => throw null;
                    public object State { get => throw null; set => throw null; }
                    public abstract System.Threading.Tasks.ValueTask<Microsoft.AspNetCore.Routing.RouteValueDictionary> TransformAsync(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.RouteValueDictionary values);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.HttpMethodAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class HttpMethodAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider, Microsoft.AspNetCore.Mvc.Routing.IActionHttpMethodProvider
                {
                    public HttpMethodAttribute(System.Collections.Generic.IEnumerable<string> httpMethods, string template) => throw null;
                    public HttpMethodAttribute(System.Collections.Generic.IEnumerable<string> httpMethods) => throw null;
                    public System.Collections.Generic.IEnumerable<string> HttpMethods { get => throw null; }
                    public string Name { get => throw null; set => throw null; }
                    public int Order { get => throw null; set => throw null; }
                    int? Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider.Order { get => throw null; }
                    public string Template { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.IActionHttpMethodProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IActionHttpMethodProvider
                {
                    System.Collections.Generic.IEnumerable<string> HttpMethods { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.IRouteTemplateProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRouteTemplateProvider
                {
                    string Name { get; }
                    int? Order { get; }
                    string Template { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.IRouteValueProvider` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRouteValueProvider
                {
                    string RouteKey { get; }
                    string RouteValue { get; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IUrlHelperFactory
                {
                    Microsoft.AspNetCore.Mvc.IUrlHelper GetUrlHelper(Microsoft.AspNetCore.Mvc.ActionContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.KnownRouteValueConstraint` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class KnownRouteValueConstraint : Microsoft.AspNetCore.Routing.IRouteConstraint, Microsoft.AspNetCore.Routing.IParameterPolicy
                {
                    public KnownRouteValueConstraint(Microsoft.AspNetCore.Mvc.Infrastructure.IActionDescriptorCollectionProvider actionDescriptorCollectionProvider) => throw null;
                    public bool Match(Microsoft.AspNetCore.Http.HttpContext httpContext, Microsoft.AspNetCore.Routing.IRouter route, string routeKey, Microsoft.AspNetCore.Routing.RouteValueDictionary values, Microsoft.AspNetCore.Routing.RouteDirection routeDirection) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.RouteValueAttribute` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class RouteValueAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Routing.IRouteValueProvider
                {
                    public string RouteKey { get => throw null; }
                    public string RouteValue { get => throw null; }
                    protected RouteValueAttribute(string routeKey, string routeValue) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.UrlHelper` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UrlHelper : Microsoft.AspNetCore.Mvc.Routing.UrlHelperBase
                {
                    public override string Action(Microsoft.AspNetCore.Mvc.Routing.UrlActionContext actionContext) => throw null;
                    protected virtual string GenerateUrl(string protocol, string host, Microsoft.AspNetCore.Routing.VirtualPathData pathData, string fragment) => throw null;
                    protected virtual Microsoft.AspNetCore.Routing.VirtualPathData GetVirtualPathData(string routeName, Microsoft.AspNetCore.Routing.RouteValueDictionary values) => throw null;
                    protected Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    public override string RouteUrl(Microsoft.AspNetCore.Mvc.Routing.UrlRouteContext routeContext) => throw null;
                    protected Microsoft.AspNetCore.Routing.IRouter Router { get => throw null; }
                    public UrlHelper(Microsoft.AspNetCore.Mvc.ActionContext actionContext) : base(default(Microsoft.AspNetCore.Mvc.ActionContext)) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.UrlHelperBase` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class UrlHelperBase : Microsoft.AspNetCore.Mvc.IUrlHelper
                {
                    public abstract string Action(Microsoft.AspNetCore.Mvc.Routing.UrlActionContext actionContext);
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    protected Microsoft.AspNetCore.Routing.RouteValueDictionary AmbientValues { get => throw null; }
                    public virtual string Content(string contentPath) => throw null;
                    protected string GenerateUrl(string protocol, string host, string virtualPath, string fragment) => throw null;
                    protected string GenerateUrl(string protocol, string host, string path) => throw null;
                    protected Microsoft.AspNetCore.Routing.RouteValueDictionary GetValuesDictionary(object values) => throw null;
                    public virtual bool IsLocalUrl(string url) => throw null;
                    public virtual string Link(string routeName, object values) => throw null;
                    public abstract string RouteUrl(Microsoft.AspNetCore.Mvc.Routing.UrlRouteContext routeContext);
                    protected UrlHelperBase(Microsoft.AspNetCore.Mvc.ActionContext actionContext) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Routing.UrlHelperFactory` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class UrlHelperFactory : Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory
                {
                    public Microsoft.AspNetCore.Mvc.IUrlHelper GetUrlHelper(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                    public UrlHelperFactory() => throw null;
                }

            }
            namespace ViewFeatures
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ViewFeatures.IKeepTempDataResult` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IKeepTempDataResult : Microsoft.AspNetCore.Mvc.IActionResult
                {
                }

            }
        }
        namespace Routing
        {
            // Generated from `Microsoft.AspNetCore.Routing.ControllerLinkGeneratorExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ControllerLinkGeneratorExtensions
            {
                public static string GetPathByAction(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string action, string controller, object values = default(object), Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByAction(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string action = default(string), string controller = default(string), object values = default(object), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByAction(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string action, string controller, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByAction(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string action = default(string), string controller = default(string), object values = default(object), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Routing.PageLinkGeneratorExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class PageLinkGeneratorExtensions
            {
                public static string GetPathByPage(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string page, string handler = default(string), object values = default(object), Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetPathByPage(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string page = default(string), string handler = default(string), object values = default(object), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByPage(this Microsoft.AspNetCore.Routing.LinkGenerator generator, string page, string handler, object values, string scheme, Microsoft.AspNetCore.Http.HostString host, Microsoft.AspNetCore.Http.PathString pathBase = default(Microsoft.AspNetCore.Http.PathString), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
                public static string GetUriByPage(this Microsoft.AspNetCore.Routing.LinkGenerator generator, Microsoft.AspNetCore.Http.HttpContext httpContext, string page = default(string), string handler = default(string), object values = default(object), string scheme = default(string), Microsoft.AspNetCore.Http.HostString? host = default(Microsoft.AspNetCore.Http.HostString?), Microsoft.AspNetCore.Http.PathString? pathBase = default(Microsoft.AspNetCore.Http.PathString?), Microsoft.AspNetCore.Http.FragmentString fragment = default(Microsoft.AspNetCore.Http.FragmentString), Microsoft.AspNetCore.Routing.LinkOptions options = default(Microsoft.AspNetCore.Routing.LinkOptions)) => throw null;
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.ApplicationModelConventionExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ApplicationModelConventionExtensions
            {
                public static void Add(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IParameterModelConvention parameterModelConvention) => throw null;
                public static void Add(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IParameterModelBaseConvention parameterModelConvention) => throw null;
                public static void Add(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IControllerModelConvention controllerModelConvention) => throw null;
                public static void Add(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> conventions, Microsoft.AspNetCore.Mvc.ApplicationModels.IActionModelConvention actionModelConvention) => throw null;
                public static void RemoveType<TApplicationModelConvention>(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> list) where TApplicationModelConvention : Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention => throw null;
                public static void RemoveType(this System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ApplicationModels.IApplicationModelConvention> list, System.Type type) => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.IMvcBuilder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IMvcBuilder
            {
                Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager PartManager { get; }
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IMvcCoreBuilder
            {
                Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager PartManager { get; }
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.MvcCoreMvcBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcCoreMvcBuilderExtensions
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

            // Generated from `Microsoft.Extensions.DependencyInjection.MvcCoreMvcCoreBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcCoreMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddApplicationPart(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Reflection.Assembly assembly) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddAuthorization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Authorization.AuthorizationOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddAuthorization(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddControllersAsServices(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddFormatterMappings(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Formatters.FormatterMappings> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddFormatterMappings(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddJsonOptions(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.JsonOptions> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcOptions(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.MvcOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder ConfigureApiBehaviorOptions(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.ApiBehaviorOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder ConfigureApplicationPartManager(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder SetCompatibilityVersion(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, Microsoft.AspNetCore.Mvc.CompatibilityVersion version) => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.MvcCoreServiceCollectionExtensions` in `Microsoft.AspNetCore.Mvc.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcCoreServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Mvc.MvcOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddMvcCore(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
