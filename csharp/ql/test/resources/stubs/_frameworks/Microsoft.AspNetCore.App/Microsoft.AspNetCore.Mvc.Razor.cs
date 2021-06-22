// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace ApplicationParts
            {
                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.CompiledRazorAssemblyApplicationPartFactory` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CompiledRazorAssemblyApplicationPartFactory : Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartFactory
                {
                    public CompiledRazorAssemblyApplicationPartFactory() => throw null;
                    public override System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetApplicationParts(System.Reflection.Assembly assembly) => throw null;
                    public static System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> GetDefaultApplicationParts(System.Reflection.Assembly assembly) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.CompiledRazorAssemblyPart` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class CompiledRazorAssemblyPart : Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart, Microsoft.AspNetCore.Mvc.ApplicationParts.IRazorCompiledItemProvider
                {
                    public System.Reflection.Assembly Assembly { get => throw null; }
                    System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItem> Microsoft.AspNetCore.Mvc.ApplicationParts.IRazorCompiledItemProvider.CompiledItems { get => throw null; }
                    public CompiledRazorAssemblyPart(System.Reflection.Assembly assembly) => throw null;
                    public override string Name { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.ApplicationParts.IRazorCompiledItemProvider` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRazorCompiledItemProvider
                {
                    System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItem> CompiledItems { get; }
                }

            }
            namespace Diagnostics
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.AfterViewPageEventData` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class AfterViewPageEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public AfterViewPageEventData(Microsoft.AspNetCore.Mvc.Razor.IRazorPage page, Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Razor.IRazorPage Page { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Diagnostics.BeforeViewPageEventData` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class BeforeViewPageEventData : Microsoft.AspNetCore.Mvc.Diagnostics.EventData
                {
                    public Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor ActionDescriptor { get => throw null; }
                    public BeforeViewPageEventData(Microsoft.AspNetCore.Mvc.Razor.IRazorPage page, Microsoft.AspNetCore.Mvc.Rendering.ViewContext viewContext, Microsoft.AspNetCore.Mvc.Abstractions.ActionDescriptor actionDescriptor, Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                    protected override int Count { get => throw null; }
                    public const string EventName = default;
                    public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                    protected override System.Collections.Generic.KeyValuePair<string, object> this[int index] { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Razor.IRazorPage Page { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; }
                }

            }
            namespace Razor
            {
                // Generated from `Microsoft.AspNetCore.Mvc.Razor.HelperResult` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class HelperResult : Microsoft.AspNetCore.Html.IHtmlContent
                {
                    public HelperResult(System.Func<System.IO.TextWriter, System.Threading.Tasks.Task> asyncAction) => throw null;
                    public System.Func<System.IO.TextWriter, System.Threading.Tasks.Task> WriteAction { get => throw null; }
                    public virtual void WriteTo(System.IO.TextWriter writer, System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.IModelTypeProvider` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                internal interface IModelTypeProvider
                {
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.IRazorPage` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRazorPage
                {
                    Microsoft.AspNetCore.Html.IHtmlContent BodyContent { get; set; }
                    void EnsureRenderedBodyOrSections();
                    System.Threading.Tasks.Task ExecuteAsync();
                    bool IsLayoutBeingRendered { get; set; }
                    string Layout { get; set; }
                    string Path { get; set; }
                    System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate> PreviousSectionWriters { get; set; }
                    System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate> SectionWriters { get; }
                    Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get; set; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.IRazorPageActivator` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRazorPageActivator
                {
                    void Activate(Microsoft.AspNetCore.Mvc.Razor.IRazorPage page, Microsoft.AspNetCore.Mvc.Rendering.ViewContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.IRazorPageFactoryProvider` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRazorPageFactoryProvider
                {
                    Microsoft.AspNetCore.Mvc.Razor.RazorPageFactoryResult CreateFactory(string relativePath);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.IRazorViewEngine` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IRazorViewEngine : Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine
                {
                    Microsoft.AspNetCore.Mvc.Razor.RazorPageResult FindPage(Microsoft.AspNetCore.Mvc.ActionContext context, string pageName);
                    string GetAbsolutePath(string executingFilePath, string pagePath);
                    Microsoft.AspNetCore.Mvc.Razor.RazorPageResult GetPage(string executingFilePath, string pagePath);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.ITagHelperActivator` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITagHelperActivator
                {
                    TTagHelper Create<TTagHelper>(Microsoft.AspNetCore.Mvc.Rendering.ViewContext context) where TTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.ITagHelperFactory` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITagHelperFactory
                {
                    TTagHelper CreateTagHelper<TTagHelper>(Microsoft.AspNetCore.Mvc.Rendering.ViewContext context) where TTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.ITagHelperInitializer<>` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface ITagHelperInitializer<TTagHelper> where TTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper
                {
                    void Initialize(TTagHelper helper, Microsoft.AspNetCore.Mvc.Rendering.ViewContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.IViewLocationExpander` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IViewLocationExpander
                {
                    System.Collections.Generic.IEnumerable<string> ExpandViewLocations(Microsoft.AspNetCore.Mvc.Razor.ViewLocationExpanderContext context, System.Collections.Generic.IEnumerable<string> viewLocations);
                    void PopulateValues(Microsoft.AspNetCore.Mvc.Razor.ViewLocationExpanderContext context);
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpander` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class LanguageViewLocationExpander : Microsoft.AspNetCore.Mvc.Razor.IViewLocationExpander
                {
                    public virtual System.Collections.Generic.IEnumerable<string> ExpandViewLocations(Microsoft.AspNetCore.Mvc.Razor.ViewLocationExpanderContext context, System.Collections.Generic.IEnumerable<string> viewLocations) => throw null;
                    public LanguageViewLocationExpander(Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat format) => throw null;
                    public LanguageViewLocationExpander() => throw null;
                    public void PopulateValues(Microsoft.AspNetCore.Mvc.Razor.ViewLocationExpanderContext context) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.LanguageViewLocationExpanderFormat` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum LanguageViewLocationExpanderFormat
                {
                    SubFolder,
                    Suffix,
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RazorPage` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class RazorPage : Microsoft.AspNetCore.Mvc.Razor.RazorPageBase
                {
                    public override void BeginContext(int position, int length, bool isLiteral) => throw null;
                    public Microsoft.AspNetCore.Http.HttpContext Context { get => throw null; }
                    public override void DefineSection(string name, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate section) => throw null;
                    public override void EndContext() => throw null;
                    public override void EnsureRenderedBodyOrSections() => throw null;
                    public void IgnoreBody() => throw null;
                    public void IgnoreSection(string sectionName) => throw null;
                    public bool IsSectionDefined(string name) => throw null;
                    protected RazorPage() => throw null;
                    protected virtual Microsoft.AspNetCore.Html.IHtmlContent RenderBody() => throw null;
                    public Microsoft.AspNetCore.Html.HtmlString RenderSection(string name, bool required) => throw null;
                    public Microsoft.AspNetCore.Html.HtmlString RenderSection(string name) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.HtmlString> RenderSectionAsync(string name, bool required) => throw null;
                    public System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.HtmlString> RenderSectionAsync(string name) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RazorPage<>` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class RazorPage<TModel> : Microsoft.AspNetCore.Mvc.Razor.RazorPage
                {
                    public TModel Model { get => throw null; }
                    protected RazorPage() => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary<TModel> ViewData { get => throw null; set => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RazorPageActivator` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorPageActivator : Microsoft.AspNetCore.Mvc.Razor.IRazorPageActivator
                {
                    public void Activate(Microsoft.AspNetCore.Mvc.Razor.IRazorPage page, Microsoft.AspNetCore.Mvc.Rendering.ViewContext context) => throw null;
                    public RazorPageActivator(Microsoft.AspNetCore.Mvc.ModelBinding.IModelMetadataProvider metadataProvider, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory, Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper jsonHelper, System.Diagnostics.DiagnosticSource diagnosticSource, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider modelExpressionProvider) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RazorPageBase` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class RazorPageBase : Microsoft.AspNetCore.Mvc.Razor.IRazorPage
                {
                    public void AddHtmlAttributeValue(string prefix, int prefixOffset, object value, int valueOffset, int valueLength, bool isLiteral) => throw null;
                    public void BeginAddHtmlAttributeValues(Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext executionContext, string attributeName, int attributeValuesCount, Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle attributeValueStyle) => throw null;
                    public abstract void BeginContext(int position, int length, bool isLiteral);
                    public virtual void BeginWriteAttribute(string name, string prefix, int prefixOffset, string suffix, int suffixOffset, int attributeValuesCount) => throw null;
                    public void BeginWriteTagHelperAttribute() => throw null;
                    public Microsoft.AspNetCore.Html.IHtmlContent BodyContent { get => throw null; set => throw null; }
                    public TTagHelper CreateTagHelper<TTagHelper>() where TTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper => throw null;
                    public virtual void DefineSection(string name, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate section) => throw null;
                    protected void DefineSection(string name, System.Func<object, System.Threading.Tasks.Task> section) => throw null;
                    public System.Diagnostics.DiagnosticSource DiagnosticSource { get => throw null; set => throw null; }
                    public void EndAddHtmlAttributeValues(Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext executionContext) => throw null;
                    public abstract void EndContext();
                    public Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContent EndTagHelperWritingScope() => throw null;
                    public virtual void EndWriteAttribute() => throw null;
                    public string EndWriteTagHelperAttribute() => throw null;
                    public abstract void EnsureRenderedBodyOrSections();
                    public abstract System.Threading.Tasks.Task ExecuteAsync();
                    public virtual System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.HtmlString> FlushAsync() => throw null;
                    public virtual string Href(string contentPath) => throw null;
                    public System.Text.Encodings.Web.HtmlEncoder HtmlEncoder { get => throw null; set => throw null; }
                    public string InvalidTagHelperIndexerAssignment(string attributeName, string tagHelperTypeName, string propertyName) => throw null;
                    public bool IsLayoutBeingRendered { get => throw null; set => throw null; }
                    public string Layout { get => throw null; set => throw null; }
                    public virtual System.IO.TextWriter Output { get => throw null; }
                    public string Path { get => throw null; set => throw null; }
                    protected internal virtual System.IO.TextWriter PopWriter() => throw null;
                    public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate> PreviousSectionWriters { get => throw null; set => throw null; }
                    protected internal virtual void PushWriter(System.IO.TextWriter writer) => throw null;
                    protected RazorPageBase() => throw null;
                    public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate> SectionWriters { get => throw null; }
                    public virtual Microsoft.AspNetCore.Html.HtmlString SetAntiforgeryCookieAndHeader() => throw null;
                    public void StartTagHelperWritingScope(System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ITempDataDictionary TempData { get => throw null; }
                    public virtual System.Security.Claims.ClaimsPrincipal User { get => throw null; }
                    public dynamic ViewBag { get => throw null; }
                    public virtual Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set => throw null; }
                    public virtual void Write(string value) => throw null;
                    public virtual void Write(object value) => throw null;
                    public void WriteAttributeValue(string prefix, int prefixOffset, object value, int valueOffset, int valueLength, bool isLiteral) => throw null;
                    public virtual void WriteLiteral(string value) => throw null;
                    public virtual void WriteLiteral(object value) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RazorPageFactoryResult` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct RazorPageFactoryResult
                {
                    public System.Func<Microsoft.AspNetCore.Mvc.Razor.IRazorPage> RazorPageFactory { get => throw null; }
                    public RazorPageFactoryResult(Microsoft.AspNetCore.Mvc.Razor.Compilation.CompiledViewDescriptor viewDescriptor, System.Func<Microsoft.AspNetCore.Mvc.Razor.IRazorPage> razorPageFactory) => throw null;
                    // Stub generator skipped constructor 
                    public bool Success { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Razor.Compilation.CompiledViewDescriptor ViewDescriptor { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RazorPageResult` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public struct RazorPageResult
                {
                    public string Name { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Razor.IRazorPage Page { get => throw null; }
                    public RazorPageResult(string name, System.Collections.Generic.IEnumerable<string> searchedLocations) => throw null;
                    public RazorPageResult(string name, Microsoft.AspNetCore.Mvc.Razor.IRazorPage page) => throw null;
                    // Stub generator skipped constructor 
                    public System.Collections.Generic.IEnumerable<string> SearchedLocations { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RazorView` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorView : Microsoft.AspNetCore.Mvc.ViewEngines.IView
                {
                    public string Path { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Razor.IRazorPage RazorPage { get => throw null; }
                    public RazorView(Microsoft.AspNetCore.Mvc.Razor.IRazorViewEngine viewEngine, Microsoft.AspNetCore.Mvc.Razor.IRazorPageActivator pageActivator, System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Razor.IRazorPage> viewStartPages, Microsoft.AspNetCore.Mvc.Razor.IRazorPage razorPage, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, System.Diagnostics.DiagnosticListener diagnosticListener) => throw null;
                    public virtual System.Threading.Tasks.Task RenderAsync(Microsoft.AspNetCore.Mvc.Rendering.ViewContext context) => throw null;
                    public System.Collections.Generic.IReadOnlyList<Microsoft.AspNetCore.Mvc.Razor.IRazorPage> ViewStartPages { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RazorViewEngine` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorViewEngine : Microsoft.AspNetCore.Mvc.ViewEngines.IViewEngine, Microsoft.AspNetCore.Mvc.Razor.IRazorViewEngine
                {
                    public Microsoft.AspNetCore.Mvc.Razor.RazorPageResult FindPage(Microsoft.AspNetCore.Mvc.ActionContext context, string pageName) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult FindView(Microsoft.AspNetCore.Mvc.ActionContext context, string viewName, bool isMainPage) => throw null;
                    public string GetAbsolutePath(string executingFilePath, string pagePath) => throw null;
                    public static string GetNormalizedRouteValue(Microsoft.AspNetCore.Mvc.ActionContext context, string key) => throw null;
                    public Microsoft.AspNetCore.Mvc.Razor.RazorPageResult GetPage(string executingFilePath, string pagePath) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewEngines.ViewEngineResult GetView(string executingFilePath, string viewPath, bool isMainPage) => throw null;
                    public RazorViewEngine(Microsoft.AspNetCore.Mvc.Razor.IRazorPageFactoryProvider pageFactory, Microsoft.AspNetCore.Mvc.Razor.IRazorPageActivator pageActivator, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.Razor.RazorViewEngineOptions> optionsAccessor, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, System.Diagnostics.DiagnosticListener diagnosticListener) => throw null;
                    public static string ViewExtension;
                    protected Microsoft.Extensions.Caching.Memory.IMemoryCache ViewLookupCache { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RazorViewEngineOptions` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class RazorViewEngineOptions
                {
                    public System.Collections.Generic.IList<string> AreaPageViewLocationFormats { get => throw null; }
                    public System.Collections.Generic.IList<string> AreaViewLocationFormats { get => throw null; }
                    public System.Collections.Generic.IList<string> PageViewLocationFormats { get => throw null; }
                    public RazorViewEngineOptions() => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Razor.IViewLocationExpander> ViewLocationExpanders { get => throw null; }
                    public System.Collections.Generic.IList<string> ViewLocationFormats { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.RenderAsyncDelegate` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public delegate System.Threading.Tasks.Task RenderAsyncDelegate();

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.TagHelperInitializer<>` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class TagHelperInitializer<TTagHelper> : Microsoft.AspNetCore.Mvc.Razor.ITagHelperInitializer<TTagHelper> where TTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper
                {
                    public void Initialize(TTagHelper helper, Microsoft.AspNetCore.Mvc.Rendering.ViewContext context) => throw null;
                    public TagHelperInitializer(System.Action<TTagHelper, Microsoft.AspNetCore.Mvc.Rendering.ViewContext> action) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Mvc.Razor.ViewLocationExpanderContext` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class ViewLocationExpanderContext
                {
                    public Microsoft.AspNetCore.Mvc.ActionContext ActionContext { get => throw null; }
                    public string AreaName { get => throw null; }
                    public string ControllerName { get => throw null; }
                    public bool IsMainPage { get => throw null; }
                    public string PageName { get => throw null; }
                    public System.Collections.Generic.IDictionary<string, string> Values { get => throw null; set => throw null; }
                    public ViewLocationExpanderContext(Microsoft.AspNetCore.Mvc.ActionContext actionContext, string viewName, string controllerName, string areaName, string pageName, bool isMainPage) => throw null;
                    public string ViewName { get => throw null; }
                }

                namespace Compilation
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.Compilation.CompiledViewDescriptor` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class CompiledViewDescriptor
                    {
                        public CompiledViewDescriptor(Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItem item, Microsoft.AspNetCore.Mvc.Razor.Compilation.RazorViewAttribute attribute) => throw null;
                        public CompiledViewDescriptor(Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItem item) => throw null;
                        public CompiledViewDescriptor() => throw null;
                        public System.Collections.Generic.IList<Microsoft.Extensions.Primitives.IChangeToken> ExpirationTokens { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItem Item { get => throw null; set => throw null; }
                        public string RelativePath { get => throw null; set => throw null; }
                        public System.Type Type { get => throw null; }
                        public Microsoft.AspNetCore.Mvc.Razor.Compilation.RazorViewAttribute ViewAttribute { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.Compilation.IViewCompiler` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IViewCompiler
                    {
                        System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Razor.Compilation.CompiledViewDescriptor> CompileAsync(string relativePath);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.Compilation.IViewCompilerProvider` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface IViewCompilerProvider
                    {
                        Microsoft.AspNetCore.Mvc.Razor.Compilation.IViewCompiler GetCompiler();
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.Compilation.RazorViewAttribute` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class RazorViewAttribute : System.Attribute
                    {
                        public string Path { get => throw null; }
                        public RazorViewAttribute(string path, System.Type viewType) => throw null;
                        public System.Type ViewType { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.Compilation.ViewsFeature` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ViewsFeature
                    {
                        public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Razor.Compilation.CompiledViewDescriptor> ViewDescriptors { get => throw null; }
                        public ViewsFeature() => throw null;
                    }

                }
                namespace Infrastructure
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.Infrastructure.TagHelperMemoryCacheProvider` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class TagHelperMemoryCacheProvider
                    {
                        public Microsoft.Extensions.Caching.Memory.IMemoryCache Cache { get => throw null; set => throw null; }
                        public TagHelperMemoryCacheProvider() => throw null;
                    }

                }
                namespace Internal
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class RazorInjectAttribute : System.Attribute
                    {
                        public RazorInjectAttribute() => throw null;
                    }

                }
                namespace TagHelpers
                {
                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.TagHelpers.BodyTagHelper` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class BodyTagHelper : Microsoft.AspNetCore.Mvc.Razor.TagHelpers.TagHelperComponentTagHelper
                    {
                        public BodyTagHelper(Microsoft.AspNetCore.Mvc.Razor.TagHelpers.ITagHelperComponentManager manager, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.AspNetCore.Mvc.Razor.TagHelpers.ITagHelperComponentManager), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.TagHelpers.HeadTagHelper` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class HeadTagHelper : Microsoft.AspNetCore.Mvc.Razor.TagHelpers.TagHelperComponentTagHelper
                    {
                        public HeadTagHelper(Microsoft.AspNetCore.Mvc.Razor.TagHelpers.ITagHelperComponentManager manager, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) : base(default(Microsoft.AspNetCore.Mvc.Razor.TagHelpers.ITagHelperComponentManager), default(Microsoft.Extensions.Logging.ILoggerFactory)) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.TagHelpers.ITagHelperComponentManager` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface ITagHelperComponentManager
                    {
                        System.Collections.Generic.ICollection<Microsoft.AspNetCore.Razor.TagHelpers.ITagHelperComponent> Components { get; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.TagHelpers.ITagHelperComponentPropertyActivator` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public interface ITagHelperComponentPropertyActivator
                    {
                        void Activate(Microsoft.AspNetCore.Mvc.Rendering.ViewContext context, Microsoft.AspNetCore.Razor.TagHelpers.ITagHelperComponent tagHelperComponent);
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.TagHelpers.TagHelperComponentTagHelper` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public abstract class TagHelperComponentTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                    {
                        public override void Init(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context) => throw null;
                        public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                        public Microsoft.AspNetCore.Mvc.Razor.TagHelpers.ITagHelperComponentPropertyActivator PropertyActivator { get => throw null; set => throw null; }
                        public TagHelperComponentTagHelper(Microsoft.AspNetCore.Mvc.Razor.TagHelpers.ITagHelperComponentManager manager, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.TagHelpers.TagHelperFeature` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class TagHelperFeature
                    {
                        public TagHelperFeature() => throw null;
                        public System.Collections.Generic.IList<System.Reflection.TypeInfo> TagHelpers { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.TagHelpers.TagHelperFeatureProvider` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class TagHelperFeatureProvider : Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider<Microsoft.AspNetCore.Mvc.Razor.TagHelpers.TagHelperFeature>, Microsoft.AspNetCore.Mvc.ApplicationParts.IApplicationFeatureProvider
                    {
                        protected virtual bool IncludePart(Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart part) => throw null;
                        protected virtual bool IncludeType(System.Reflection.TypeInfo type) => throw null;
                        public void PopulateFeature(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPart> parts, Microsoft.AspNetCore.Mvc.Razor.TagHelpers.TagHelperFeature feature) => throw null;
                        public TagHelperFeatureProvider() => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class UrlResolutionTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                    {
                        protected System.Text.Encodings.Web.HtmlEncoder HtmlEncoder { get => throw null; }
                        public override int Order { get => throw null; }
                        public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                        protected void ProcessUrlAttribute(string attributeName, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                        protected bool TryResolveUrl(string url, out string resolvedUrl) => throw null;
                        protected bool TryResolveUrl(string url, out Microsoft.AspNetCore.Html.IHtmlContent resolvedUrl) => throw null;
                        protected Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory UrlHelperFactory { get => throw null; }
                        public UrlResolutionTagHelper(Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory, System.Text.Encodings.Web.HtmlEncoder htmlEncoder) => throw null;
                        public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set => throw null; }
                    }

                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.MvcRazorMvcBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcRazorMvcBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddRazorOptions(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Razor.RazorViewEngineOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddTagHelpersAsServices(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder InitializeTagHelper<TTagHelper>(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<TTagHelper, Microsoft.AspNetCore.Mvc.Rendering.ViewContext> initialize) where TTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper => throw null;
            }

            // Generated from `Microsoft.Extensions.DependencyInjection.MvcRazorMvcCoreBuilderExtensions` in `Microsoft.AspNetCore.Mvc.Razor, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class MvcRazorMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddRazorViewEngine(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Razor.RazorViewEngineOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddRazorViewEngine(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddTagHelpersAsServices(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder InitializeTagHelper<TTagHelper>(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<TTagHelper, Microsoft.AspNetCore.Mvc.Rendering.ViewContext> initialize) where TTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.ITagHelper => throw null;
            }

        }
    }
}
