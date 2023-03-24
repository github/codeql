// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Mvc.ViewFeatures, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            public class AutoValidateAntiforgeryTokenAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
            {
                public AutoValidateAntiforgeryTokenAttribute() => throw null;
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public bool IsReusable { get => throw null; }
                public int Order { get => throw null; set => throw null; }
            }

            public abstract class Controller : Microsoft.AspNetCore.Mvc.ControllerBase, Microsoft.AspNetCore.Mvc.Filters.IActionFilter, Microsoft.AspNetCore.Mvc.Filters.IAsyncActionFilter, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, System.IDisposable
            {
                protected Controller() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.JsonResult Json(object data) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.JsonResult Json(object data, object serializerSettings) => throw null;
                public virtual void OnActionExecuted(Microsoft.AspNetCore.Mvc.Filters.ActionExecutedContext context) => throw null;
                public virtual void OnActionExecuting(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context) => throw null;
                public virtual System.Threading.Tasks.Task OnActionExecutionAsync(Microsoft.AspNetCore.Mvc.Filters.ActionExecutingContext context, Microsoft.AspNetCore.Mvc.Filters.ActionExecutionDelegate next) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PartialViewResult PartialView() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PartialViewResult PartialView(object model) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PartialViewResult PartialView(string viewName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.PartialViewResult PartialView(string viewName, object model) => throw null;
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; set => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.ViewResult View() => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ViewResult View(object model) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ViewResult View(string viewName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ViewResult View(string viewName, object model) => throw null;
                public dynamic ViewBag { get => throw null; }
                public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(System.Type componentType, object arguments) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName) => throw null;
                public virtual Microsoft.AspNetCore.Mvc.ViewComponentResult ViewComponent(string componentName, object arguments) => throw null;
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set => throw null; }
            }

            public class CookieTempDataProviderOptions
            {
                public Microsoft.AspNetCore.Http.CookieBuilder Cookie { get => throw null; set => throw null; }
                public CookieTempDataProviderOptions() => throw null;
            }

            public interface IViewComponentHelper
            {
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> InvokeAsync(System.Type componentType, object arguments);
                System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> InvokeAsync(string name, object arguments);
            }

            public interface IViewComponentResult
            {
                void Execute(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context);
                System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context);
            }

            public class IgnoreAntiforgeryTokenAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter, Microsoft.AspNetCore.Mvc.ViewFeatures.IAntiforgeryPolicy
            {
                public IgnoreAntiforgeryTokenAttribute() => throw null;
                public int Order { get => throw null; set => throw null; }
            }

            public class MvcViewOptions : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>, System.Collections.IEnumerable
            {
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidatorProvider> ClientModelValidatorProviders { get => throw null; }
                System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public Microsoft.AspNetCore.Mvc.ViewFeatures.HtmlHelperOptions HtmlHelperOptions { get => throw null; set => throw null; }
                public MvcViewOptions() => throw null;
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine> ViewEngines { get => throw null; }
            }

            public class PageRemoteAttribute : Microsoft.AspNetCore.Mvc.RemoteAttributeBase
            {
                protected override string GetUrl(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context) => throw null;
                public string PageHandler { get => throw null; set => throw null; }
                public string PageName { get => throw null; set => throw null; }
                public PageRemoteAttribute() => throw null;
            }

            public class PartialViewResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult
            {
                public string ContentType { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public object Model { get => throw null; }
                public PartialViewResult() => throw null;
                public int? StatusCode { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine ViewEngine { get => throw null; set => throw null; }
                public string ViewName { get => throw null; set => throw null; }
            }

            public class RemoteAttribute : Microsoft.AspNetCore.Mvc.RemoteAttributeBase
            {
                protected override string GetUrl(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context) => throw null;
                protected RemoteAttribute() => throw null;
                public RemoteAttribute(string routeName) => throw null;
                public RemoteAttribute(string action, string controller) => throw null;
                public RemoteAttribute(string action, string controller, string areaName) => throw null;
                protected string RouteName { get => throw null; set => throw null; }
            }

            public abstract class RemoteAttributeBase : System.ComponentModel.DataAnnotations.ValidationAttribute, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.IClientModelValidator
            {
                public virtual void AddValidation(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context) => throw null;
                public string AdditionalFields { get => throw null; set => throw null; }
                public string FormatAdditionalFieldsForClientValidation(string property) => throw null;
                public override string FormatErrorMessage(string name) => throw null;
                public static string FormatPropertyForClientValidation(string property) => throw null;
                protected abstract string GetUrl(Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientModelValidationContext context);
                public string HttpMethod { get => throw null; set => throw null; }
                public override bool IsValid(object value) => throw null;
                protected RemoteAttributeBase() => throw null;
                protected Microsoft.AspNetCore.Routing.RouteValueDictionary RouteData { get => throw null; }
            }

            public class SkipStatusCodePagesAttribute : System.Attribute, Microsoft.AspNetCore.Http.Metadata.ISkipStatusCodePagesMetadata, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IResourceFilter
            {
                public void OnResourceExecuted(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutedContext context) => throw null;
                public void OnResourceExecuting(Microsoft.AspNetCore.Mvc.Filters.ResourceExecutingContext context) => throw null;
                public SkipStatusCodePagesAttribute() => throw null;
            }

            public class TempDataAttribute : System.Attribute
            {
                public string Key { get => throw null; set => throw null; }
                public TempDataAttribute() => throw null;
            }

            public class ValidateAntiForgeryTokenAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
            {
                public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                public bool IsReusable { get => throw null; }
                public int Order { get => throw null; set => throw null; }
                public ValidateAntiForgeryTokenAttribute() => throw null;
            }

            public abstract class ViewComponent
            {
                public Microsoft.AspNetCore.Mvc.ViewComponents.ContentViewComponentResult Content(string content) => throw null;
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                public Microsoft.AspNetCore.Http.HttpRequest Request { get => throw null; }
                public Microsoft.AspNetCore.Routing.RouteData RouteData { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; }
                public Microsoft.AspNetCore.Mvc.IUrlHelper Url { get => throw null; set => throw null; }
                public System.Security.Principal.IPrincipal User { get => throw null; }
                public System.Security.Claims.ClaimsPrincipal UserClaimsPrincipal { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewComponents.ViewViewComponentResult View() => throw null;
                public Microsoft.AspNetCore.Mvc.ViewComponents.ViewViewComponentResult View(string viewName) => throw null;
                public Microsoft.AspNetCore.Mvc.ViewComponents.ViewViewComponentResult View<TModel>(TModel model) => throw null;
                public Microsoft.AspNetCore.Mvc.ViewComponents.ViewViewComponentResult View<TModel>(string viewName, TModel model) => throw null;
                public dynamic ViewBag { get => throw null; }
                protected ViewComponent() => throw null;
                public Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext ViewComponentContext { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine ViewEngine { get => throw null; set => throw null; }
            }

            public class ViewComponentAttribute : System.Attribute
            {
                public string Name { get => throw null; set => throw null; }
                public ViewComponentAttribute() => throw null;
            }

            public class ViewComponentResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult
            {
                public object Arguments { get => throw null; set => throw null; }
                public string ContentType { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public object Model { get => throw null; }
                public int? StatusCode { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; set => throw null; }
                public string ViewComponentName { get => throw null; set => throw null; }
                public ViewComponentResult() => throw null;
                public System.Type ViewComponentType { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set => throw null; }
            }

            public class ViewDataAttribute : System.Attribute
            {
                public string Key { get => throw null; set => throw null; }
                public ViewDataAttribute() => throw null;
            }

            public class ViewResult : Microsoft.AspNetCore.Mvc.ActionResult, Microsoft.AspNetCore.Mvc.IActionResult, Microsoft.AspNetCore.Mvc.Infrastructure.IStatusCodeActionResult
            {
                public string ContentType { get => throw null; set => throw null; }
                public override System.Threading.Tasks.Task ExecuteResultAsync(Microsoft.AspNetCore.Mvc.ActionContext context) => throw null;
                public object Model { get => throw null; }
                public int? StatusCode { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine ViewEngine { get => throw null; set => throw null; }
                public string ViewName { get => throw null; set => throw null; }
                public ViewResult() => throw null;
            }

            namespace Diagnostics
            {
                public class AfterViewComponentEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterViewComponentEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext viewComponentContext, Microsoft.AspNetCore.Mvc.IViewComponentResult viewComponentResult, object viewComponent) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public object ViewComponent { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext ViewComponentContext { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.IViewComponentResult ViewComponentResult { get => throw null; }
                }

                public class AfterViewEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public AfterViewEventData(Microsoft.AspNetCore.Mvc.ViewEngines.IView view, Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewEngines.IView View { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; }
                }

                public class BeforeViewComponentEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeViewComponentEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext viewComponentContext, object viewComponent) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public object ViewComponent { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext ViewComponentContext { get => throw null; }
                }

                public class BeforeViewEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public BeforeViewEventData(Microsoft.AspNetCore.Mvc.ViewEngines.IView view, Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewEngines.IView View { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; }
                }

                public class ViewComponentAfterViewExecuteEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewEngines.IView View { get => throw null; }
                    public ViewComponentAfterViewExecuteEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext viewComponentContext, Microsoft.AspNetCore.Mvc.ViewEngines.IView view) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext ViewComponentContext { get => throw null; }
                }

                public class ViewComponentBeforeViewExecuteEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewEngines.IView View { get => throw null; }
                    public ViewComponentBeforeViewExecuteEventData(Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext viewComponentContext, Microsoft.AspNetCore.Mvc.ViewEngines.IView view) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext ViewComponentContext { get => throw null; }
                }

                public class ViewFoundEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public bool IsMainPage { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ActionResult Result { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewEngines.IView View { get => throw null; }
                    public ViewFoundEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, bool isMainPage, Microsoft.AspNetCore.Mvc.ActionResult result, string viewName, Microsoft.AspNetCore.Mvc.ViewEngines.IView view) => throw null;
                    public string ViewName { get => throw null; }
                }

                public class ViewNotFoundEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public bool IsMainPage { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ActionResult Result { get => throw null; }
                    public System.Collections.Generic.IEnumerable<string> SearchedLocations { get => throw null; }
                    public string ViewName { get => throw null; }
                    public ViewNotFoundEventData(Microsoft.AspNetCore.Mvc.ActionContext actionContext, bool isMainPage, Microsoft.AspNetCore.Mvc.ActionResult result, string viewName, System.Collections.Generic.IEnumerable<string> searchedLocations) => throw null;
                }

            }
            namespace ModelBinding
            {
                public static class ModelStateDictionaryExtensions
                {
                    public static void AddModelError<TModel>(this Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, System.Linq.Expressions.Expression<System.Func<TModel, object>> expression, System.Exception exception, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata) => throw null;
                    public static void AddModelError<TModel>(this Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, System.Linq.Expressions.Expression<System.Func<TModel, object>> expression, string errorMessage) => throw null;
                    public static bool Remove<TModel>(this Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, System.Linq.Expressions.Expression<System.Func<TModel, object>> expression) => throw null;
                    public static void RemoveAll<TModel>(this Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, System.Linq.Expressions.Expression<System.Func<TModel, object>> expression) => throw null;
                    public static void TryAddModelException<TModel>(this Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, System.Linq.Expressions.Expression<System.Func<TModel, object>> expression, System.Exception exception) => throw null;
                }

            }
            namespace Rendering
            {
                public enum CheckBoxHiddenInputRenderMode : int
                {
                    EndOfForm = 2,
                    Inline = 1,
                    None = 0,
                }

                public enum FormInputRenderMode : int
                {
                    AlwaysUseCurrentCulture = 1,
                    DetectCultureFromInputType = 0,
                }

                public enum FormMethod : int
                {
                    Get = 0,
                    Post = 1,
                }

                public enum Html5DateRenderingMode : int
                {
                    CurrentCulture = 1,
                    Rfc3339 = 0,
                }

                public static class HtmlHelperComponentExtensions
                {
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> RenderComponentAsync(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, System.Type componentType, Microsoft.AspNetCore.Mvc.Rendering.RenderMode renderMode, object parameters) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> RenderComponentAsync<TComponent>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, Microsoft.AspNetCore.Mvc.Rendering.RenderMode renderMode) where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> RenderComponentAsync<TComponent>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, Microsoft.AspNetCore.Mvc.Rendering.RenderMode renderMode, object parameters) where TComponent : Microsoft.AspNetCore.Components.IComponent => throw null;
                }

                public static class HtmlHelperDisplayExtensions
                {
                    public static Microsoft.AspNetCore.Html.IHtmlContent Display(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Display(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Display(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string templateName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Display(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string templateName, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Display(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string templateName, string htmlFieldName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName, string htmlFieldName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string templateName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string templateName, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string templateName, string htmlFieldName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DisplayForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string templateName, string htmlFieldName, object additionalViewData) => throw null;
                }

                public static class HtmlHelperDisplayNameExtensions
                {
                    public static string DisplayNameFor<TModelItem, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<System.Collections.Generic.IEnumerable<TModelItem>> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModelItem, TResult>> expression) => throw null;
                    public static string DisplayNameForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper) => throw null;
                }

                public static class HtmlHelperEditorExtensions
                {
                    public static Microsoft.AspNetCore.Html.IHtmlContent Editor(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Editor(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Editor(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string templateName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Editor(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string templateName, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Editor(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string templateName, string htmlFieldName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName, string htmlFieldName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string templateName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string templateName, object additionalViewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string templateName, string htmlFieldName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent EditorForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string templateName, string htmlFieldName, object additionalViewData) => throw null;
                }

                public static class HtmlHelperFormExtensions
                {
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, bool? antiforgery, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, bool? antiforgery) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, object routeValues) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string actionName, string controllerName) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string actionName, string controllerName, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string actionName, string controllerName, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string actionName, string controllerName, object routeValues) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string actionName, string controllerName, object routeValues, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, object routeValues) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, object routeValues, bool? antiforgery) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string routeName) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string routeName, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string routeName, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string routeName, bool? antiforgery) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string routeName, object routeValues) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string routeName, object routeValues, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method) => throw null;
                }

                public static class HtmlHelperInputExtensions
                {
                    public static Microsoft.AspNetCore.Html.IHtmlContent CheckBox(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent CheckBox(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, bool isChecked) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent CheckBox(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent CheckBoxFor<TModel>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, bool>> expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Hidden(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Hidden(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object value) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent HiddenFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Password(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Password(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object value) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent PasswordFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent RadioButton(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object value) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent RadioButton(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object value, bool isChecked) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent RadioButton(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object value, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent RadioButtonFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object value) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextArea(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextArea(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextArea(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string value) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextArea(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string value, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextAreaFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextAreaFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextBox(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextBox(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object value) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextBox(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object value, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextBox(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object value, string format) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextBoxFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextBoxFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent TextBoxFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string format) => throw null;
                }

                public static class HtmlHelperLabelExtensions
                {
                    public static Microsoft.AspNetCore.Html.IHtmlContent Label(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Label(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string labelText) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent LabelFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent LabelFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent LabelFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string labelText) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent LabelForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent LabelForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent LabelForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string labelText) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent LabelForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string labelText, object htmlAttributes) => throw null;
                }

                public static class HtmlHelperLinkExtensions
                {
                    public static Microsoft.AspNetCore.Html.IHtmlContent ActionLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper helper, string linkText, string actionName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ActionLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper helper, string linkText, string actionName, object routeValues) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ActionLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper helper, string linkText, string actionName, object routeValues, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ActionLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper helper, string linkText, string actionName, string controllerName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ActionLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper helper, string linkText, string actionName, string controllerName, object routeValues) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ActionLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper helper, string linkText, string actionName, string controllerName, object routeValues, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent RouteLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string linkText, object routeValues) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent RouteLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string linkText, object routeValues, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent RouteLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string linkText, string routeName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent RouteLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string linkText, string routeName, object routeValues) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent RouteLink(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string linkText, string routeName, object routeValues, object htmlAttributes) => throw null;
                }

                public static class HtmlHelperNameExtensions
                {
                    public static string IdForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper) => throw null;
                    public static string NameForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper) => throw null;
                }

                public static class HtmlHelperPartialExtensions
                {
                    public static Microsoft.AspNetCore.Html.IHtmlContent Partial(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Partial(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Partial(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, object model) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent Partial(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, object model, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> PartialAsync(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> PartialAsync(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> PartialAsync(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, object model) => throw null;
                    public static void RenderPartial(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName) => throw null;
                    public static void RenderPartial(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData) => throw null;
                    public static void RenderPartial(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, object model) => throw null;
                    public static void RenderPartial(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, object model, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData) => throw null;
                    public static System.Threading.Tasks.Task RenderPartialAsync(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName) => throw null;
                    public static System.Threading.Tasks.Task RenderPartialAsync(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData) => throw null;
                    public static System.Threading.Tasks.Task RenderPartialAsync(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string partialViewName, object model) => throw null;
                }

                public static class HtmlHelperSelectExtensions
                {
                    public static Microsoft.AspNetCore.Html.IHtmlContent DropDownList(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DropDownList(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DropDownList(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DropDownList(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, string optionLabel) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DropDownList(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string optionLabel) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DropDownListFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DropDownListFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent DropDownListFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, string optionLabel) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ListBox(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ListBox(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ListBoxFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList) => throw null;
                }

                public static class HtmlHelperValidationExtensions
                {
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationMessage(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationMessage(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationMessage(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string message) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationMessage(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string message, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationMessage(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression, string message, string tag) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationMessageFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationMessageFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string message) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationMessageFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string message, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationMessageFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string message, string tag) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, bool excludePropertyErrors) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, bool excludePropertyErrors, string message) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, bool excludePropertyErrors, string message, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, bool excludePropertyErrors, string message, string tag) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string message) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string message, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string message, object htmlAttributes, string tag) => throw null;
                    public static Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string message, string tag) => throw null;
                }

                public static class HtmlHelperValueExtensions
                {
                    public static string Value(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string expression) => throw null;
                    public static string ValueFor<TModel, TResult>(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel> htmlHelper, System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public static string ValueForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper) => throw null;
                    public static string ValueForModel(this Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper htmlHelper, string format) => throw null;
                }

                public interface IHtmlHelper
                {
                    Microsoft.AspNetCore.Html.IHtmlContent ActionLink(string linkText, string actionName, string controllerName, string protocol, string hostname, string fragment, object routeValues, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent AntiForgeryToken();
                    Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(string actionName, string controllerName, object routeValues, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, bool? antiforgery, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(string routeName, object routeValues, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, bool? antiforgery, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent CheckBox(string expression, bool? isChecked, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent Display(string expression, string templateName, string htmlFieldName, object additionalViewData);
                    string DisplayName(string expression);
                    string DisplayText(string expression);
                    Microsoft.AspNetCore.Html.IHtmlContent DropDownList(string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, string optionLabel, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent Editor(string expression, string templateName, string htmlFieldName, object additionalViewData);
                    string Encode(object value);
                    string Encode(string value);
                    void EndForm();
                    string FormatValue(object value, string format);
                    string GenerateIdFromName(string fullName);
                    System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> GetEnumSelectList(System.Type enumType);
                    System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> GetEnumSelectList<TEnum>() where TEnum : struct;
                    Microsoft.AspNetCore.Html.IHtmlContent Hidden(string expression, object value, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.Html5DateRenderingMode Html5DateRenderingMode { get; set; }
                    string Id(string expression);
                    string IdAttributeDotReplacement { get; }
                    Microsoft.AspNetCore.Html.IHtmlContent Label(string expression, string labelText, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent ListBox(string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get; }
                    string Name(string expression);
                    System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> PartialAsync(string partialViewName, object model, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData);
                    Microsoft.AspNetCore.Html.IHtmlContent Password(string expression, object value, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent RadioButton(string expression, object value, bool? isChecked, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent Raw(object value);
                    Microsoft.AspNetCore.Html.IHtmlContent Raw(string value);
                    System.Threading.Tasks.Task RenderPartialAsync(string partialViewName, object model, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData);
                    Microsoft.AspNetCore.Html.IHtmlContent RouteLink(string linkText, string routeName, string protocol, string hostName, string fragment, object routeValues, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get; }
                    Microsoft.AspNetCore.Html.IHtmlContent TextArea(string expression, string value, int rows, int columns, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent TextBox(string expression, object value, string format, object htmlAttributes);
                    System.Text.Encodings.Web.UrlEncoder UrlEncoder { get; }
                    Microsoft.AspNetCore.Html.IHtmlContent ValidationMessage(string expression, string message, object htmlAttributes, string tag);
                    Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(bool excludePropertyErrors, string message, object htmlAttributes, string tag);
                    string Value(string expression, string format);
                    dynamic ViewBag { get; }
                    Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get; }
                    Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get; }
                }

                public interface IHtmlHelper<TModel> : Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper
                {
                    Microsoft.AspNetCore.Html.IHtmlContent CheckBoxFor(System.Linq.Expressions.Expression<System.Func<TModel, bool>> expression, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent DisplayFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName, string htmlFieldName, object additionalViewData);
                    string DisplayNameFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression);
                    string DisplayNameForInnerType<TModelItem, TResult>(System.Linq.Expressions.Expression<System.Func<TModelItem, TResult>> expression);
                    string DisplayTextFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression);
                    Microsoft.AspNetCore.Html.IHtmlContent DropDownListFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, string optionLabel, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent EditorFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName, string htmlFieldName, object additionalViewData);
                    string Encode(object value);
                    string Encode(string value);
                    Microsoft.AspNetCore.Html.IHtmlContent HiddenFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object htmlAttributes);
                    string IdFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression);
                    Microsoft.AspNetCore.Html.IHtmlContent LabelFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string labelText, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent ListBoxFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, object htmlAttributes);
                    string NameFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression);
                    Microsoft.AspNetCore.Html.IHtmlContent PasswordFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent RadioButtonFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object value, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent Raw(object value);
                    Microsoft.AspNetCore.Html.IHtmlContent Raw(string value);
                    Microsoft.AspNetCore.Html.IHtmlContent TextAreaFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, int rows, int columns, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent TextBoxFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string format, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent ValidationMessageFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string message, object htmlAttributes, string tag);
                    string ValueFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string format);
                    Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary<TModel> ViewData { get; }
                }

                public interface IJsonHelper
                {
                    Microsoft.AspNetCore.Html.IHtmlContent Serialize(object value);
                }

                public class MultiSelectList : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem>, System.Collections.IEnumerable
                {
                    public string DataGroupField { get => throw null; }
                    public string DataTextField { get => throw null; }
                    public string DataValueField { get => throw null; }
                    public virtual System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public System.Collections.IEnumerable Items { get => throw null; }
                    public MultiSelectList(System.Collections.IEnumerable items) => throw null;
                    public MultiSelectList(System.Collections.IEnumerable items, System.Collections.IEnumerable selectedValues) => throw null;
                    public MultiSelectList(System.Collections.IEnumerable items, string dataValueField, string dataTextField) => throw null;
                    public MultiSelectList(System.Collections.IEnumerable items, string dataValueField, string dataTextField, System.Collections.IEnumerable selectedValues) => throw null;
                    public MultiSelectList(System.Collections.IEnumerable items, string dataValueField, string dataTextField, System.Collections.IEnumerable selectedValues, string dataGroupField) => throw null;
                    public System.Collections.IEnumerable SelectedValues { get => throw null; }
                }

                public class MvcForm : System.IDisposable
                {
                    public void Dispose() => throw null;
                    public void EndForm() => throw null;
                    protected virtual void GenerateEndForm() => throw null;
                    public MvcForm(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, System.Text.Encodings.Web.HtmlEncoder htmlEncoder) => throw null;
                }

                public enum RenderMode : int
                {
                    Server = 2,
                    ServerPrerendered = 3,
                    Static = 1,
                    WebAssembly = 4,
                    WebAssemblyPrerendered = 5,
                }

                public class SelectList : Microsoft.AspNetCore.Mvc.Rendering.MultiSelectList
                {
                    public SelectList(System.Collections.IEnumerable items) : base(default(System.Collections.IEnumerable)) => throw null;
                    public SelectList(System.Collections.IEnumerable items, object selectedValue) : base(default(System.Collections.IEnumerable)) => throw null;
                    public SelectList(System.Collections.IEnumerable items, string dataValueField, string dataTextField) : base(default(System.Collections.IEnumerable)) => throw null;
                    public SelectList(System.Collections.IEnumerable items, string dataValueField, string dataTextField, object selectedValue) : base(default(System.Collections.IEnumerable)) => throw null;
                    public SelectList(System.Collections.IEnumerable items, string dataValueField, string dataTextField, object selectedValue, string dataGroupField) : base(default(System.Collections.IEnumerable)) => throw null;
                    public object SelectedValue { get => throw null; }
                }

                public class SelectListGroup
                {
                    public bool Disabled { get => throw null; set => throw null; }
                    public string Name { get => throw null; set => throw null; }
                    public SelectListGroup() => throw null;
                }

                public class SelectListItem
                {
                    public bool Disabled { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.SelectListGroup Group { get => throw null; set => throw null; }
                    public SelectListItem() => throw null;
                    public SelectListItem(string text, string value) => throw null;
                    public SelectListItem(string text, string value, bool selected) => throw null;
                    public SelectListItem(string text, string value, bool selected, bool disabled) => throw null;
                    public bool Selected { get => throw null; set => throw null; }
                    public string Text { get => throw null; set => throw null; }
                    public string Value { get => throw null; set => throw null; }
                }

                public class TagBuilder : Microsoft.AspNetCore.Html.IHtmlContent
                {
                    public void AddCssClass(string value) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.AttributeDictionary Attributes { get => throw null; }
                    public static string CreateSanitizedId(string name, string invalidCharReplacement) => throw null;
                    public void GenerateId(string name, string invalidCharReplacement) => throw null;
                    public bool HasInnerHtml { get => throw null; }
                    public Microsoft.AspNetCore.Html.IHtmlContentBuilder InnerHtml { get => throw null; }
                    public void MergeAttribute(string key, string value) => throw null;
                    public void MergeAttribute(string key, string value, bool replaceExisting) => throw null;
                    public void MergeAttributes<TKey, TValue>(System.Collections.Generic.IDictionary<TKey, TValue> attributes) => throw null;
                    public void MergeAttributes<TKey, TValue>(System.Collections.Generic.IDictionary<TKey, TValue> attributes, bool replaceExisting) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent RenderBody() => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent RenderEndTag() => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent RenderSelfClosingTag() => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent RenderStartTag() => throw null;
                    public TagBuilder(Microsoft.AspNetCore.Mvc.Rendering.TagBuilder tagBuilder) => throw null;
                    public TagBuilder(string tagName) => throw null;
                    public string TagName { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.TagRenderMode TagRenderMode { get => throw null; set => throw null; }
                    public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                }

                public enum TagRenderMode : int
                {
                    EndTag = 2,
                    Normal = 0,
                    SelfClosing = 3,
                    StartTag = 1,
                }

                public static class ViewComponentHelperExtensions
                {
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> InvokeAsync(this Microsoft.AspNetCore.Mvc.IViewComponentHelper helper, System.Type componentType) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> InvokeAsync(this Microsoft.AspNetCore.Mvc.IViewComponentHelper helper, string name) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> InvokeAsync<TComponent>(this Microsoft.AspNetCore.Mvc.IViewComponentHelper helper) => throw null;
                    public static System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> InvokeAsync<TComponent>(this Microsoft.AspNetCore.Mvc.IViewComponentHelper helper, object arguments) => throw null;
                }

                public class ViewContext : Microsoft.AspNetCore.Mvc.ActionContext
                {
                    public Microsoft.AspNetCore.Mvc.Rendering.CheckBoxHiddenInputRenderMode CheckBoxHiddenInputRenderMode { get => throw null; set => throw null; }
                    public bool ClientValidationEnabled { get => throw null; set => throw null; }
                    public string ExecutingFilePath { get => throw null; set => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.ViewFeatures.FormContext FormContext { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.FormContext GetFormContextForClientValidation() => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.Html5DateRenderingMode Html5DateRenderingMode { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; set => throw null; }
                    public string ValidationMessageElement { get => throw null; set => throw null; }
                    public string ValidationSummaryMessageElement { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewEngines.IView View { get => throw null; set => throw null; }
                    public dynamic ViewBag { get => throw null; }
                    public ViewContext() => throw null;
                    public ViewContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ViewEngines.IView view, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData, Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary tempData, System.IO.TextWriter writer, Microsoft.AspNetCore.Mvc.ViewFeatures.HtmlHelperOptions htmlHelperOptions) => throw null;
                    public ViewContext(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewEngines.IView view, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData, System.IO.TextWriter writer) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set => throw null; }
                    public System.IO.TextWriter Writer { get => throw null; set => throw null; }
                }

            }
            namespace ViewComponents
            {
                public class ContentViewComponentResult : Microsoft.AspNetCore.Mvc.IViewComponentResult
                {
                    public string Content { get => throw null; }
                    public ContentViewComponentResult(string content) => throw null;
                    public void Execute(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context) => throw null;
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context) => throw null;
                }

                public class DefaultViewComponentDescriptorCollectionProvider : Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentDescriptorCollectionProvider
                {
                    public DefaultViewComponentDescriptorCollectionProvider(Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentDescriptorProvider descriptorProvider) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptorCollection ViewComponents { get => throw null; }
                }

                public class DefaultViewComponentDescriptorProvider : Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentDescriptorProvider
                {
                    public DefaultViewComponentDescriptorProvider(Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager partManager) => throw null;
                    protected virtual System.Collections.Generic.IEnumerable<System.Reflection.TypeInfo> GetCandidateTypes() => throw null;
                    public virtual System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptor> GetViewComponents() => throw null;
                }

                public class DefaultViewComponentFactory : Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentFactory
                {
                    public object CreateViewComponent(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context) => throw null;
                    public DefaultViewComponentFactory(Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentActivator activator) => throw null;
                    public void ReleaseViewComponent(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context, object component) => throw null;
                    public System.Threading.Tasks.ValueTask ReleaseViewComponentAsync(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context, object component) => throw null;
                }

                public class DefaultViewComponentHelper : Microsoft.AspNetCore.Mvc.IViewComponentHelper, Microsoft.AspNetCore.Mvc.ViewFeatures.IViewContextAware
                {
                    public void Contextualize(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext) => throw null;
                    public DefaultViewComponentHelper(Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentDescriptorCollectionProvider descriptorProvider, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentSelector selector, Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentInvokerFactory invokerFactory, Microsoft.AspNetCore.Mvc.ViewFeatures.Buffers.IViewBufferScope viewBufferScope) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> InvokeAsync(System.Type componentType, object arguments) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> InvokeAsync(string name, object arguments) => throw null;
                }

                public class DefaultViewComponentSelector : Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentSelector
                {
                    public DefaultViewComponentSelector(Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentDescriptorCollectionProvider descriptorProvider) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptor SelectComponent(string componentName) => throw null;
                }

                public class HtmlContentViewComponentResult : Microsoft.AspNetCore.Mvc.IViewComponentResult
                {
                    public Microsoft.AspNetCore.Html.IHtmlContent EncodedContent { get => throw null; }
                    public void Execute(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context) => throw null;
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context) => throw null;
                    public HtmlContentViewComponentResult(Microsoft.AspNetCore.Html.IHtmlContent encodedContent) => throw null;
                }

                public interface IViewComponentActivator
                {
                    object Create(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context);
                    void Release(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context, object viewComponent);
                    System.Threading.Tasks.ValueTask ReleaseAsync(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context, object viewComponent) => throw null;
                }

                public interface IViewComponentDescriptorCollectionProvider
                {
                    Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptorCollection ViewComponents { get; }
                }

                public interface IViewComponentDescriptorProvider
                {
                    System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptor> GetViewComponents();
                }

                public interface IViewComponentFactory
                {
                    object CreateViewComponent(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context);
                    void ReleaseViewComponent(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context, object component);
                    System.Threading.Tasks.ValueTask ReleaseViewComponentAsync(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context, object component) => throw null;
                }

                public interface IViewComponentInvoker
                {
                    System.Threading.Tasks.Task InvokeAsync(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context);
                }

                public interface IViewComponentInvokerFactory
                {
                    Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentInvoker CreateInstance(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context);
                }

                public interface IViewComponentSelector
                {
                    Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptor SelectComponent(string componentName);
                }

                public class ServiceBasedViewComponentActivator : Microsoft.AspNetCore.Mvc.ViewComponents.IViewComponentActivator
                {
                    public object Create(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context) => throw null;
                    public virtual void Release(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context, object viewComponent) => throw null;
                    public ServiceBasedViewComponentActivator() => throw null;
                }

                public class ViewComponentContext
                {
                    public System.Collections.Generic.IDictionary<string, object> Arguments { get => throw null; set => throw null; }
                    public System.Text.Encodings.Web.HtmlEncoder HtmlEncoder { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; }
                    public ViewComponentContext() => throw null;
                    public ViewComponentContext(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptor viewComponentDescriptor, System.Collections.Generic.IDictionary<string, object> arguments, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, System.IO.TextWriter writer) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptor ViewComponentDescriptor { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; }
                    public System.IO.TextWriter Writer { get => throw null; }
                }

                public class ViewComponentContextAttribute : System.Attribute
                {
                    public ViewComponentContextAttribute() => throw null;
                }

                public static class ViewComponentConventions
                {
                    public static string GetComponentFullName(System.Reflection.TypeInfo componentType) => throw null;
                    public static string GetComponentName(System.Reflection.TypeInfo componentType) => throw null;
                    public static bool IsComponent(System.Reflection.TypeInfo typeInfo) => throw null;
                    public static string ViewComponentSuffix;
                }

                public class ViewComponentDescriptor
                {
                    public string DisplayName { get => throw null; set => throw null; }
                    public string FullName { get => throw null; set => throw null; }
                    public string Id { get => throw null; set => throw null; }
                    public System.Reflection.MethodInfo MethodInfo { get => throw null; set => throw null; }
                    public System.Collections.Generic.IReadOnlyList<System.Reflection.ParameterInfo> Parameters { get => throw null; set => throw null; }
                    public string ShortName { get => throw null; set => throw null; }
                    public System.Reflection.TypeInfo TypeInfo { get => throw null; set => throw null; }
                    public ViewComponentDescriptor() => throw null;
                }

                public class ViewComponentDescriptorCollection
                {
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptor> Items { get => throw null; }
                    public int Version { get => throw null; }
                    public ViewComponentDescriptorCollection(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentDescriptor> items, int version) => throw null;
                }

                public class ViewComponentFeature
                {
                    public ViewComponentFeature() => throw null;
                    public System.Collections.Generic.IList<System.Reflection.TypeInfo> ViewComponents { get => throw null; }
                }

                public class ViewComponentFeatureProvider : Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider, Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider<Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentFeature>
                {
                    public void PopulateFeature(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> parts, Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentFeature feature) => throw null;
                    public ViewComponentFeatureProvider() => throw null;
                }

                public class ViewViewComponentResult : Microsoft.AspNetCore.Mvc.IViewComponentResult
                {
                    public void Execute(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context) => throw null;
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ViewComponents.ViewComponentContext context) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine ViewEngine { get => throw null; set => throw null; }
                    public string ViewName { get => throw null; set => throw null; }
                    public ViewViewComponentResult() => throw null;
                }

            }
            namespace ViewEngines
            {
                public class CompositeViewEngine : Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine, Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine
                {
                    public CompositeViewEngine(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcViewOptions> optionsAccessor) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult FindView(Microsoft.AspNetCore.Mvc.ActionContext context, string viewName, bool isMainPage) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult GetView(string executingFilePath, string viewPath, bool isMainPage) => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine> ViewEngines { get => throw null; }
                }

                public interface ICompositeViewEngine : Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine
                {
                    System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine> ViewEngines { get; }
                }

                public interface IView
                {
                    string Path { get; }
                    System.Threading.Tasks.Task RenderAsync(Microsoft.AspNetCore.Mvc.Rendering.ViewContext context);
                }

                public interface IViewEngine
                {
                    Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult FindView(Microsoft.AspNetCore.Mvc.ActionContext context, string viewName, bool isMainPage);
                    Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult GetView(string executingFilePath, string viewPath, bool isMainPage);
                }

                public class ViewEngineResult
                {
                    public Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult EnsureSuccessful(System.Collections.Generic.IEnumerable<string> originalLocations) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult Found(string viewName, Microsoft.AspNetCore.Mvc.ViewEngines.IView view) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult NotFound(string viewName, System.Collections.Generic.IEnumerable<string> searchedLocations) => throw null;
                    public System.Collections.Generic.IEnumerable<string> SearchedLocations { get => throw null; }
                    public bool Success { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewEngines.IView View { get => throw null; }
                    public string ViewName { get => throw null; }
                }

            }
            namespace ViewFeatures
            {
                public static class AntiforgeryExtensions
                {
                    public static Microsoft.AspNetCore.Html.IHtmlContent GetHtml(this Microsoft.AspNetCore.Antiforgery.IAntiforgery antiforgery, Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                }

                public class AttributeDictionary : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.Generic.IDictionary<string, string>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.Generic.IReadOnlyDictionary<string, string>, System.Collections.IEnumerable
                {
                    public struct Enumerator : System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.IEnumerator, System.IDisposable
                    {
                        public System.Collections.Generic.KeyValuePair<string, string> Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        // Stub generator skipped constructor 
                        public Enumerator(Microsoft.AspNetCore.Mvc.ViewFeatures.AttributeDictionary attributes) => throw null;
                        public bool MoveNext() => throw null;
                        public void Reset() => throw null;
                    }


                    public void Add(System.Collections.Generic.KeyValuePair<string, string> item) => throw null;
                    public void Add(string key, string value) => throw null;
                    public AttributeDictionary() => throw null;
                    public void Clear() => throw null;
                    public bool Contains(System.Collections.Generic.KeyValuePair<string, string> item) => throw null;
                    public bool ContainsKey(string key) => throw null;
                    public void CopyTo(System.Collections.Generic.KeyValuePair<string, string>[] array, int arrayIndex) => throw null;
                    public int Count { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.AttributeDictionary.Enumerator GetEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, string>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public string this[string key] { get => throw null; set => throw null; }
                    public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                    System.Collections.Generic.IEnumerable<string> System.Collections.Generic.IReadOnlyDictionary<string, string>.Keys { get => throw null; }
                    public bool Remove(System.Collections.Generic.KeyValuePair<string, string> item) => throw null;
                    public bool Remove(string key) => throw null;
                    public bool TryGetValue(string key, out string value) => throw null;
                    public System.Collections.Generic.ICollection<string> Values { get => throw null; }
                    System.Collections.Generic.IEnumerable<string> System.Collections.Generic.IReadOnlyDictionary<string, string>.Values { get => throw null; }
                }

                public class CookieTempDataProvider : Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataProvider
                {
                    public static string CookieName;
                    public CookieTempDataProvider(Microsoft.AspNetCore.DataProtection.IDataProtectionProvider dataProtectionProvider, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.CookieTempDataProviderOptions> options, Microsoft.AspNetCore.Mvc.ViewFeatures.Infrastructure.TempDataSerializer tempDataSerializer) => throw null;
                    public System.Collections.Generic.IDictionary<string, object> LoadTempData(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    public void SaveTempData(Microsoft.AspNetCore.Http.HttpContext context, System.Collections.Generic.IDictionary<string, object> values) => throw null;
                }

                public class DefaultHtmlGenerator : Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator
                {
                    protected virtual void AddMaxLengthAttribute(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData, Microsoft.AspNetCore.Mvc.Rendering.TagBuilder tagBuilder, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression) => throw null;
                    protected virtual void AddPlaceholderAttribute(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData, Microsoft.AspNetCore.Mvc.Rendering.TagBuilder tagBuilder, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression) => throw null;
                    protected virtual void AddValidationAttributes(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.Rendering.TagBuilder tagBuilder, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression) => throw null;
                    protected bool AllowRenderingMaxLengthAttribute { get => throw null; }
                    public DefaultHtmlGenerator(Microsoft.AspNetCore.Antiforgery.IAntiforgery antiforgery, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcViewOptions> optionsAccessor, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, Microsoft.AspNetCore.Mvc.ViewFeatures.ValidationHtmlAttributeProvider validationAttributeProvider) => throw null;
                    public string Encode(object value) => throw null;
                    public string Encode(string value) => throw null;
                    public string FormatValue(object value, string format) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateActionLink(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string linkText, string actionName, string controllerName, string protocol, string hostname, string fragment, object routeValues, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateAntiforgery(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateCheckBox(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, bool? isChecked, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateForm(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string actionName, string controllerName, object routeValues, string method, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateFormCore(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string action, string method, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent GenerateGroupsAndOptions(string optionLabel, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateHidden(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, bool useViewData, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateHiddenForCheckbox(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression) => throw null;
                    protected virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateInput(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.InputType inputType, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, bool useViewData, bool isChecked, bool setId, bool isExplicitValue, string format, System.Collections.Generic.IDictionary<string, object> htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateLabel(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, string labelText, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateLink(string linkText, string url, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GeneratePageForm(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string pageName, string pageHandler, object routeValues, string fragment, string method, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GeneratePageLink(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string linkText, string pageName, string pageHandler, string protocol, string hostname, string fragment, object routeValues, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GeneratePassword(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateRadioButton(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, bool? isChecked, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateRouteForm(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string routeName, object routeValues, string method, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateRouteLink(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string linkText, string routeName, string protocol, string hostName, string fragment, object routeValues, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateSelect(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string optionLabel, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, System.Collections.Generic.ICollection<string> currentValues, bool allowMultiple, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateSelect(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string optionLabel, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, bool allowMultiple, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateTextArea(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, int rows, int columns, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateTextBox(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, string format, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateValidationMessage(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, string message, string tag, object htmlAttributes) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateValidationSummary(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, bool excludePropertyErrors, string message, string headerTag, object htmlAttributes) => throw null;
                    public virtual System.Collections.Generic.ICollection<string> GetCurrentValues(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, bool allowMultiple) => throw null;
                    public string IdAttributeDotReplacement { get => throw null; }
                }

                public static class DefaultHtmlGeneratorExtensions
                {
                    public static Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateForm(this Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator, Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string actionName, string controllerName, string fragment, object routeValues, string method, object htmlAttributes) => throw null;
                    public static Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateRouteForm(this Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator, Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string routeName, object routeValues, string fragment, string method, object htmlAttributes) => throw null;
                }

                public class DefaultValidationHtmlAttributeProvider : Microsoft.AspNetCore.Mvc.ViewFeatures.ValidationHtmlAttributeProvider
                {
                    public override void AddValidationAttributes(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, System.Collections.Generic.IDictionary<string, string> attributes) => throw null;
                    public DefaultValidationHtmlAttributeProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcViewOptions> optionsAccessor, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Validation.ClientValidatorCache clientValidatorCache) => throw null;
                }

                public class FormContext
                {
                    public bool CanRenderAtEndOfForm { get => throw null; set => throw null; }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Html.IHtmlContent> EndOfFormContent { get => throw null; }
                    public FormContext() => throw null;
                    public System.Collections.Generic.IDictionary<string, object> FormData { get => throw null; }
                    public bool HasAntiforgeryToken { get => throw null; set => throw null; }
                    public bool HasEndOfFormContent { get => throw null; }
                    public bool HasFormData { get => throw null; }
                    public bool RenderedField(string fieldName) => throw null;
                    public void RenderedField(string fieldName, bool value) => throw null;
                }

                public class HtmlHelper : Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper, Microsoft.AspNetCore.Mvc.ViewFeatures.IViewContextAware
                {
                    public Microsoft.AspNetCore.Html.IHtmlContent ActionLink(string linkText, string actionName, string controllerName, string protocol, string hostname, string fragment, object routeValues, object htmlAttributes) => throw null;
                    public static System.Collections.Generic.IDictionary<string, object> AnonymousObjectToHtmlAttributes(object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent AntiForgeryToken() => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginForm(string actionName, string controllerName, object routeValues, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, bool? antiforgery, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.MvcForm BeginRouteForm(string routeName, object routeValues, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, bool? antiforgery, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent CheckBox(string expression, bool? isChecked, object htmlAttributes) => throw null;
                    public virtual void Contextualize(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext) => throw null;
                    protected virtual Microsoft.AspNetCore.Mvc.Rendering.MvcForm CreateForm() => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent Display(string expression, string templateName, string htmlFieldName, object additionalViewData) => throw null;
                    public string DisplayName(string expression) => throw null;
                    public string DisplayText(string expression) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent DropDownList(string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, string optionLabel, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent Editor(string expression, string templateName, string htmlFieldName, object additionalViewData) => throw null;
                    public string Encode(object value) => throw null;
                    public string Encode(string value) => throw null;
                    public void EndForm() => throw null;
                    public string FormatValue(object value, string format) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateCheckBox(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, bool? isChecked, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateDisplay(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string htmlFieldName, string templateName, object additionalViewData) => throw null;
                    protected virtual string GenerateDisplayName(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression) => throw null;
                    protected virtual string GenerateDisplayText(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer) => throw null;
                    protected Microsoft.AspNetCore.Html.IHtmlContent GenerateDropDown(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, string optionLabel, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateEditor(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string htmlFieldName, string templateName, object additionalViewData) => throw null;
                    protected virtual Microsoft.AspNetCore.Mvc.Rendering.MvcForm GenerateForm(string actionName, string controllerName, object routeValues, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, bool? antiforgery, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateHidden(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, bool useViewData, object htmlAttributes) => throw null;
                    protected virtual string GenerateId(string expression) => throw null;
                    public string GenerateIdFromName(string fullName) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateLabel(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, string labelText, object htmlAttributes) => throw null;
                    protected Microsoft.AspNetCore.Html.IHtmlContent GenerateListBox(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, object htmlAttributes) => throw null;
                    protected virtual string GenerateName(string expression) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GeneratePassword(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateRadioButton(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, bool? isChecked, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Mvc.Rendering.MvcForm GenerateRouteForm(string routeName, object routeValues, Microsoft.AspNetCore.Mvc.Rendering.FormMethod method, bool? antiforgery, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateTextArea(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, int rows, int columns, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateTextBox(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, string format, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateValidationMessage(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, string message, string tag, object htmlAttributes) => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent GenerateValidationSummary(bool excludePropertyErrors, string message, object htmlAttributes, string tag) => throw null;
                    protected virtual string GenerateValue(string expression, object value, string format, bool useViewData) => throw null;
                    protected virtual System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> GetEnumSelectList(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata) => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> GetEnumSelectList(System.Type enumType) => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> GetEnumSelectList<TEnum>() where TEnum : struct => throw null;
                    public static string GetFormMethodString(Microsoft.AspNetCore.Mvc.Rendering.FormMethod method) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent Hidden(string expression, object value, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.Html5DateRenderingMode Html5DateRenderingMode { get => throw null; set => throw null; }
                    public HtmlHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator htmlGenerator, Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine viewEngine, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ViewFeatures.Buffers.IViewBufferScope bufferScope, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, System.Text.Encodings.Web.UrlEncoder urlEncoder) => throw null;
                    public string Id(string expression) => throw null;
                    public string IdAttributeDotReplacement { get => throw null; }
                    public Microsoft.AspNetCore.Html.IHtmlContent Label(string expression, string labelText, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent ListBox(string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider MetadataProvider { get => throw null; }
                    public string Name(string expression) => throw null;
                    public static System.Collections.Generic.IDictionary<string, object> ObjectToDictionary(object value) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> PartialAsync(string partialViewName, object model, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent Password(string expression, object value, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent RadioButton(string expression, object value, bool? isChecked, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent Raw(object value) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent Raw(string value) => throw null;
                    public System.Threading.Tasks.Task RenderPartialAsync(string partialViewName, object model, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData) => throw null;
                    protected virtual System.Threading.Tasks.Task RenderPartialCoreAsync(string partialViewName, object model, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData, System.IO.TextWriter writer) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent RouteLink(string linkText, string routeName, string protocol, string hostName, string fragment, object routeValues, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; }
                    public Microsoft.AspNetCore.Html.IHtmlContent TextArea(string expression, string value, int rows, int columns, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent TextBox(string expression, object value, string format, object htmlAttributes) => throw null;
                    public System.Text.Encodings.Web.UrlEncoder UrlEncoder { get => throw null; }
                    public static string ValidationInputCssClassName;
                    public static string ValidationInputValidCssClassName;
                    public Microsoft.AspNetCore.Html.IHtmlContent ValidationMessage(string expression, string message, object htmlAttributes, string tag) => throw null;
                    public static string ValidationMessageCssClassName;
                    public static string ValidationMessageValidCssClassName;
                    public Microsoft.AspNetCore.Html.IHtmlContent ValidationSummary(bool excludePropertyErrors, string message, object htmlAttributes, string tag) => throw null;
                    public static string ValidationSummaryCssClassName;
                    public static string ValidationSummaryValidCssClassName;
                    public string Value(string expression, string format) => throw null;
                    public dynamic ViewBag { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; }
                }

                public class HtmlHelper<TModel> : Microsoft.AspNetCore.Mvc.ViewFeatures.HtmlHelper, Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper, Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<TModel>
                {
                    public Microsoft.AspNetCore.Html.IHtmlContent CheckBoxFor(System.Linq.Expressions.Expression<System.Func<TModel, bool>> expression, object htmlAttributes) => throw null;
                    public override void Contextualize(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent DisplayFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName, string htmlFieldName, object additionalViewData) => throw null;
                    public string DisplayNameFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public string DisplayNameForInnerType<TModelItem, TResult>(System.Linq.Expressions.Expression<System.Func<TModelItem, TResult>> expression) => throw null;
                    public string DisplayTextFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent DropDownListFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, string optionLabel, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent EditorFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string templateName, string htmlFieldName, object additionalViewData) => throw null;
                    protected string GetExpressionName<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetModelExplorer<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent HiddenFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object htmlAttributes) => throw null;
                    public HtmlHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator htmlGenerator, Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine viewEngine, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ViewFeatures.Buffers.IViewBufferScope bufferScope, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, System.Text.Encodings.Web.UrlEncoder urlEncoder, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpressionProvider modelExpressionProvider) : base(default(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator), default(Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine), default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider), default(Microsoft.AspNetCore.Mvc.ViewFeatures.Buffers.IViewBufferScope), default(System.Text.Encodings.Web.HtmlEncoder), default(System.Text.Encodings.Web.UrlEncoder)) => throw null;
                    public string IdFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent LabelFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string labelText, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent ListBoxFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, object htmlAttributes) => throw null;
                    public string NameFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent PasswordFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent RadioButtonFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, object value, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent TextAreaFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, int rows, int columns, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent TextBoxFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string format, object htmlAttributes) => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent ValidationMessageFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string message, object htmlAttributes, string tag) => throw null;
                    public string ValueFor<TResult>(System.Linq.Expressions.Expression<System.Func<TModel, TResult>> expression, string format) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary<TModel> ViewData { get => throw null; }
                }

                public class HtmlHelperOptions
                {
                    public Microsoft.AspNetCore.Mvc.Rendering.CheckBoxHiddenInputRenderMode CheckBoxHiddenInputRenderMode { get => throw null; set => throw null; }
                    public bool ClientValidationEnabled { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.FormInputRenderMode FormInputRenderMode { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.Html5DateRenderingMode Html5DateRenderingMode { get => throw null; set => throw null; }
                    public HtmlHelperOptions() => throw null;
                    public string IdAttributeDotReplacement { get => throw null; set => throw null; }
                    public string ValidationMessageElement { get => throw null; set => throw null; }
                    public string ValidationSummaryMessageElement { get => throw null; set => throw null; }
                }

                public interface IAntiforgeryPolicy : Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata
                {
                }

                public interface IFileVersionProvider
                {
                    string AddFileVersionToPath(Microsoft.AspNetCore.Http.PathString requestPathBase, string path);
                }

                public interface IHtmlGenerator
                {
                    string Encode(object value);
                    string Encode(string value);
                    string FormatValue(object value, string format);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateActionLink(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string linkText, string actionName, string controllerName, string protocol, string hostname, string fragment, object routeValues, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent GenerateAntiforgery(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateCheckBox(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, bool? isChecked, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateForm(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string actionName, string controllerName, object routeValues, string method, object htmlAttributes);
                    Microsoft.AspNetCore.Html.IHtmlContent GenerateGroupsAndOptions(string optionLabel, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateHidden(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, bool useViewData, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateHiddenForCheckbox(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateLabel(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, string labelText, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GeneratePageForm(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string pageName, string pageHandler, object routeValues, string fragment, string method, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GeneratePageLink(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string linkText, string pageName, string pageHandler, string protocol, string hostname, string fragment, object routeValues, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GeneratePassword(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateRadioButton(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, bool? isChecked, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateRouteForm(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string routeName, object routeValues, string method, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateRouteLink(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string linkText, string routeName, string protocol, string hostName, string fragment, object routeValues, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateSelect(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string optionLabel, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, System.Collections.Generic.ICollection<string> currentValues, bool allowMultiple, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateSelect(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string optionLabel, string expression, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> selectList, bool allowMultiple, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateTextArea(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, int rows, int columns, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateTextBox(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, object value, string format, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateValidationMessage(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, string message, string tag, object htmlAttributes);
                    Microsoft.AspNetCore.Mvc.Rendering.TagBuilder GenerateValidationSummary(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, bool excludePropertyErrors, string message, string headerTag, object htmlAttributes);
                    System.Collections.Generic.ICollection<string> GetCurrentValues(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, bool allowMultiple);
                    string IdAttributeDotReplacement { get; }
                }

                public interface IModelExpressionProvider
                {
                    Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpression CreateModelExpression<TModel, TValue>(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary<TModel> viewData, System.Linq.Expressions.Expression<System.Func<TModel, TValue>> expression);
                }

                public interface ITempDataDictionary : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IDictionary<string, object>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable
                {
                    void Keep();
                    void Keep(string key);
                    void Load();
                    object Peek(string key);
                    void Save();
                }

                public interface ITempDataDictionaryFactory
                {
                    Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary GetTempData(Microsoft.AspNetCore.Http.HttpContext context);
                }

                public interface ITempDataProvider
                {
                    System.Collections.Generic.IDictionary<string, object> LoadTempData(Microsoft.AspNetCore.Http.HttpContext context);
                    void SaveTempData(Microsoft.AspNetCore.Http.HttpContext context, System.Collections.Generic.IDictionary<string, object> values);
                }

                public interface IViewContextAware
                {
                    void Contextualize(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext);
                }

                public enum InputType : int
                {
                    CheckBox = 0,
                    Hidden = 1,
                    Password = 2,
                    Radio = 3,
                    Text = 4,
                }

                public class ModelExplorer
                {
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer Container { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetExplorerForExpression(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, System.Func<object, object> modelAccessor) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetExplorerForExpression(Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object model) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetExplorerForExpression(System.Type modelType, System.Func<object, object> modelAccessor) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetExplorerForExpression(System.Type modelType, object model) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetExplorerForModel(object model) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetExplorerForProperty(string name) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetExplorerForProperty(string name, System.Func<object, object> modelAccessor) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetExplorerForProperty(string name, object model) => throw null;
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; }
                    public object Model { get => throw null; }
                    public ModelExplorer(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer container, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, System.Func<object, object> modelAccessor) => throw null;
                    public ModelExplorer(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer container, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object model) => throw null;
                    public ModelExplorer(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata metadata, object model) => throw null;
                    public System.Type ModelType { get => throw null; }
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer> Properties { get => throw null; }
                }

                public static class ModelExplorerExtensions
                {
                    public static string GetSimpleDisplayText(this Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer) => throw null;
                }

                public class ModelExpression
                {
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata Metadata { get => throw null; }
                    public object Model { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer ModelExplorer { get => throw null; }
                    public ModelExpression(string name, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer) => throw null;
                    public string Name { get => throw null; }
                }

                public class ModelExpressionProvider : Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider
                {
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpression CreateModelExpression<TModel, TValue>(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary<TModel> viewData, System.Linq.Expressions.Expression<System.Func<TModel, TValue>> expression) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpression CreateModelExpression<TModel>(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary<TModel> viewData, string expression) => throw null;
                    public string GetExpressionText<TModel, TValue>(System.Linq.Expressions.Expression<System.Func<TModel, TValue>> expression) => throw null;
                    public ModelExpressionProvider(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider) => throw null;
                }

                public static class ModelMetadataProviderExtensions
                {
                    public static Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer GetModelExplorerForType(this Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider provider, System.Type modelType, object model) => throw null;
                }

                public class PartialViewResultExecutor : Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.PartialViewResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ViewEngines.IView view, Microsoft.AspNetCore.Mvc.PartialViewResult viewResult) => throw null;
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.PartialViewResult result) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult FindView(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.PartialViewResult viewResult) => throw null;
                    protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                    public PartialViewResultExecutor(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcViewOptions> viewOptions, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory, Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine viewEngine, Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionaryFactory tempDataFactory, System.Diagnostics.DiagnosticListener diagnosticListener, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider) : base(default(Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory), default(Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine), default(System.Diagnostics.DiagnosticListener)) => throw null;
                }

                public class SaveTempDataAttribute : System.Attribute, Microsoft.AspNetCore.Mvc.Filters.IFilterFactory, Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata, Microsoft.AspNetCore.Mvc.Filters.IOrderedFilter
                {
                    public Microsoft.AspNetCore.Mvc.Filters.IFilterMetadata CreateInstance(System.IServiceProvider serviceProvider) => throw null;
                    public bool IsReusable { get => throw null; }
                    public int Order { get => throw null; set => throw null; }
                    public SaveTempDataAttribute() => throw null;
                }

                public class SessionStateTempDataProvider : Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataProvider
                {
                    public virtual System.Collections.Generic.IDictionary<string, object> LoadTempData(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    public virtual void SaveTempData(Microsoft.AspNetCore.Http.HttpContext context, System.Collections.Generic.IDictionary<string, object> values) => throw null;
                    public SessionStateTempDataProvider(Microsoft.AspNetCore.Mvc.ViewFeatures.Infrastructure.TempDataSerializer tempDataSerializer) => throw null;
                }

                public class StringHtmlContent : Microsoft.AspNetCore.Html.IHtmlContent
                {
                    public StringHtmlContent(string input) => throw null;
                    public void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                }

                public class TempDataDictionary : Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IDictionary<string, object>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable
                {
                    void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Add(System.Collections.Generic.KeyValuePair<string, object> keyValuePair) => throw null;
                    public void Add(string key, object value) => throw null;
                    public void Clear() => throw null;
                    bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Contains(System.Collections.Generic.KeyValuePair<string, object> keyValuePair) => throw null;
                    public bool ContainsKey(string key) => throw null;
                    public bool ContainsValue(object value) => throw null;
                    void System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.CopyTo(System.Collections.Generic.KeyValuePair<string, object>[] array, int index) => throw null;
                    public int Count { get => throw null; }
                    public System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.IsReadOnly { get => throw null; }
                    public object this[string key] { get => throw null; set => throw null; }
                    public void Keep() => throw null;
                    public void Keep(string key) => throw null;
                    public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                    public void Load() => throw null;
                    public object Peek(string key) => throw null;
                    bool System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>.Remove(System.Collections.Generic.KeyValuePair<string, object> keyValuePair) => throw null;
                    public bool Remove(string key) => throw null;
                    public void Save() => throw null;
                    public TempDataDictionary(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataProvider provider) => throw null;
                    public bool TryGetValue(string key, out object value) => throw null;
                    public System.Collections.Generic.ICollection<object> Values { get => throw null; }
                }

                public class TempDataDictionaryFactory : Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionaryFactory
                {
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary GetTempData(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    public TempDataDictionaryFactory(Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataProvider provider) => throw null;
                }

                public class TemplateInfo
                {
                    public bool AddVisited(object value) => throw null;
                    public object FormattedModelValue { get => throw null; set => throw null; }
                    public string GetFullHtmlFieldName(string partialFieldName) => throw null;
                    public string HtmlFieldPrefix { get => throw null; set => throw null; }
                    public int TemplateDepth { get => throw null; }
                    public TemplateInfo() => throw null;
                    public TemplateInfo(Microsoft.AspNetCore.Mvc.ViewFeatures.TemplateInfo original) => throw null;
                    public bool Visited(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer) => throw null;
                }

                public delegate bool TryGetValueDelegate(object dictionary, string key, out object value);

                public static class TryGetValueProvider
                {
                    public static Microsoft.AspNetCore.Mvc.ViewFeatures.TryGetValueDelegate CreateInstance(System.Type targetType) => throw null;
                }

                public abstract class ValidationHtmlAttributeProvider
                {
                    public virtual void AddAndTrackValidationAttributes(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, string expression, System.Collections.Generic.IDictionary<string, string> attributes) => throw null;
                    public abstract void AddValidationAttributes(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, System.Collections.Generic.IDictionary<string, string> attributes);
                    protected ValidationHtmlAttributeProvider() => throw null;
                }

                public class ViewComponentResultExecutor : Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.ViewComponentResult>
                {
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.ViewComponentResult result) => throw null;
                    public ViewComponentResultExecutor(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcViewOptions> mvcHelperOptions, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider, Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionaryFactory tempDataDictionaryFactory, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory) => throw null;
                }

                public class ViewContextAttribute : System.Attribute
                {
                    public ViewContextAttribute() => throw null;
                }

                public class ViewDataDictionary : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.Generic.IDictionary<string, object>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>, System.Collections.IEnumerable
                {
                    public void Add(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                    public void Add(string key, object value) => throw null;
                    public void Clear() => throw null;
                    public bool Contains(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                    public bool ContainsKey(string key) => throw null;
                    public void CopyTo(System.Collections.Generic.KeyValuePair<string, object>[] array, int arrayIndex) => throw null;
                    public int Count { get => throw null; }
                    public object Eval(string expression) => throw null;
                    public string Eval(string expression, string format) => throw null;
                    public static string FormatValue(object value, string format) => throw null;
                    System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, object>> System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataInfo GetViewDataInfo(string expression) => throw null;
                    public bool IsReadOnly { get => throw null; }
                    public object this[string index] { get => throw null; set => throw null; }
                    public System.Collections.Generic.ICollection<string> Keys { get => throw null; }
                    public object Model { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer ModelExplorer { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelMetadata ModelMetadata { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary ModelState { get => throw null; }
                    public bool Remove(System.Collections.Generic.KeyValuePair<string, object> item) => throw null;
                    public bool Remove(string key) => throw null;
                    protected virtual void SetModel(object value) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.TemplateInfo TemplateInfo { get => throw null; }
                    public bool TryGetValue(string key, out object value) => throw null;
                    public System.Collections.Generic.ICollection<object> Values { get => throw null; }
                    internal ViewDataDictionary(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider) => throw null;
                    public ViewDataDictionary(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) => throw null;
                    protected ViewDataDictionary(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState, System.Type declaredModelType) => throw null;
                    protected ViewDataDictionary(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, System.Type declaredModelType) => throw null;
                    public ViewDataDictionary(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary source) => throw null;
                    protected ViewDataDictionary(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary source, System.Type declaredModelType) => throw null;
                    protected ViewDataDictionary(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary source, object model, System.Type declaredModelType) => throw null;
                }

                public class ViewDataDictionary<TModel> : Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary
                {
                    public TModel Model { get => throw null; set => throw null; }
                    internal ViewDataDictionary(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider)) => throw null;
                    public ViewDataDictionary(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.ModelStateDictionary modelState) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider)) => throw null;
                    public ViewDataDictionary(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary source) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider)) => throw null;
                    public ViewDataDictionary(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary source, object model) : base(default(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider)) => throw null;
                }

                public class ViewDataDictionaryAttribute : System.Attribute
                {
                    public ViewDataDictionaryAttribute() => throw null;
                }

                public class ViewDataDictionaryControllerPropertyActivator
                {
                    public void Activate(Microsoft.AspNetCore.Mvc.ControllerContext actionContext, object controller) => throw null;
                    public System.Action<Microsoft.AspNetCore.Mvc.ControllerContext, object> GetActivatorDelegate(Microsoft.AspNetCore.Mvc.Controllers.ControllerActionDescriptor actionDescriptor) => throw null;
                    public ViewDataDictionaryControllerPropertyActivator(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider) => throw null;
                }

                public static class ViewDataEvaluator
                {
                    public static Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataInfo Eval(Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData, string expression) => throw null;
                    public static Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataInfo Eval(object indexableObject, string expression) => throw null;
                }

                public class ViewDataInfo
                {
                    public object Container { get => throw null; }
                    public System.Reflection.PropertyInfo PropertyInfo { get => throw null; }
                    public object Value { get => throw null; set => throw null; }
                    public ViewDataInfo(object container, System.Reflection.PropertyInfo propertyInfo) => throw null;
                    public ViewDataInfo(object container, System.Reflection.PropertyInfo propertyInfo, System.Func<object> valueAccessor) => throw null;
                    public ViewDataInfo(object container, object value) => throw null;
                }

                public class ViewExecutor
                {
                    public static string DefaultContentType;
                    protected System.Diagnostics.DiagnosticListener DiagnosticListener { get => throw null; }
                    public virtual System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ViewEngines.IView view, Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary viewData, Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary tempData, string contentType, int? statusCode) => throw null;
                    protected System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, string contentType, int? statusCode) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider ModelMetadataProvider { get => throw null; }
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionaryFactory TempDataFactory { get => throw null; }
                    protected Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine ViewEngine { get => throw null; }
                    protected ViewExecutor(Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory, Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine viewEngine, System.Diagnostics.DiagnosticListener diagnosticListener) => throw null;
                    public ViewExecutor(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcViewOptions> viewOptions, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory, Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine viewEngine, Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionaryFactory tempDataFactory, System.Diagnostics.DiagnosticListener diagnosticListener, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider) => throw null;
                    protected Microsoft.AspNetCore.Mvc.MvcViewOptions ViewOptions { get => throw null; }
                    protected Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory WriterFactory { get => throw null; }
                }

                public class ViewResultExecutor : Microsoft.AspNetCore.Mvc.ViewFeatures.ViewExecutor, Microsoft.AspNetCore.Mvc.Infrastructure.IActionResultExecutor<Microsoft.AspNetCore.Mvc.ViewResult>
                {
                    public System.Threading.Tasks.Task ExecuteAsync(Microsoft.AspNetCore.Mvc.ActionContext context, Microsoft.AspNetCore.Mvc.ViewResult result) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult FindView(Microsoft.AspNetCore.Mvc.ActionContext actionContext, Microsoft.AspNetCore.Mvc.ViewResult viewResult) => throw null;
                    protected Microsoft.Extensions.Logging.ILogger Logger { get => throw null; }
                    public ViewResultExecutor(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.MvcViewOptions> viewOptions, Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory writerFactory, Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine viewEngine, Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionaryFactory tempDataFactory, System.Diagnostics.DiagnosticListener diagnosticListener, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider modelMetadataProvider) : base(default(Microsoft.AspNetCore.Mvc.Infrastructure.IHttpResponseStreamWriterFactory), default(Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine), default(System.Diagnostics.DiagnosticListener)) => throw null;
                }

                namespace Buffers
                {
                    public interface IViewBufferScope
                    {
                        System.IO.TextWriter CreateWriter(System.IO.TextWriter writer);
                        Microsoft.AspNetCore.Mvc.ViewFeatures.Buffers.ViewBufferValue[] GetPage(int pageSize);
                        void ReturnSegment(Microsoft.AspNetCore.Mvc.ViewFeatures.Buffers.ViewBufferValue[] segment);
                    }

                    public struct ViewBufferValue
                    {
                        public object Value { get => throw null; }
                        // Stub generator skipped constructor 
                        public ViewBufferValue(Microsoft.AspNetCore.Html.IHtmlContent content) => throw null;
                        public ViewBufferValue(string value) => throw null;
                    }

                }
                namespace Infrastructure
                {
                    public abstract class TempDataSerializer
                    {
                        public virtual bool CanSerializeType(System.Type type) => throw null;
                        public abstract System.Collections.Generic.IDictionary<string, object> Deserialize(System.Byte[] unprotectedData);
                        public abstract System.Byte[] Serialize(System.Collections.Generic.IDictionary<string, object> values);
                        protected TempDataSerializer() => throw null;
                    }

                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static class MvcViewFeaturesMvcBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddCookieTempDataProvider(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddCookieTempDataProvider(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.CookieTempDataProviderOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddSessionStateTempDataProvider(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddViewComponentsAsServices(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddViewOptions(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.MvcViewOptions> setupAction) => throw null;
            }

            public static class MvcViewFeaturesMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddCookieTempDataProvider(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddCookieTempDataProvider(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.CookieTempDataProviderOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddViews(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddViews(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.MvcViewOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder ConfigureViews(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.MvcViewOptions> setupAction) => throw null;
            }

        }
    }
}
