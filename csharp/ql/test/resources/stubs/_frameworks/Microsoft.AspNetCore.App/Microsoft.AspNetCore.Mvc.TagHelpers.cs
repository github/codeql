// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Mvc.TagHelpers, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace Rendering
            {
                public enum ValidationSummary
                {
                    None = 0,
                    ModelOnly = 1,
                    All = 2,
                }
            }
            namespace TagHelpers
            {
                public class AnchorTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public string Action { get => throw null; set { } }
                    public string Area { get => throw null; set { } }
                    public string Controller { get => throw null; set { } }
                    public AnchorTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator) => throw null;
                    public string Fragment { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator Generator { get => throw null; }
                    public string Host { get => throw null; set { } }
                    public override int Order { get => throw null; }
                    public string Page { get => throw null; set { } }
                    public string PageHandler { get => throw null; set { } }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public string Protocol { get => throw null; set { } }
                    public string Route { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                namespace Cache
                {
                    public class CacheTagKey : System.IEquatable<Microsoft.AspNetCore.Mvc.TagHelpers.Cache.CacheTagKey>
                    {
                        public CacheTagKey(Microsoft.AspNetCore.Mvc.TagHelpers.CacheTagHelper tagHelper, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context) => throw null;
                        public CacheTagKey(Microsoft.AspNetCore.Mvc.TagHelpers.DistributedCacheTagHelper tagHelper) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public bool Equals(Microsoft.AspNetCore.Mvc.TagHelpers.Cache.CacheTagKey other) => throw null;
                        public string GenerateHashedKey() => throw null;
                        public string GenerateKey() => throw null;
                        public override int GetHashCode() => throw null;
                    }
                    public class DistributedCacheTagHelperFormatter : Microsoft.AspNetCore.Mvc.TagHelpers.Cache.IDistributedCacheTagHelperFormatter
                    {
                        public DistributedCacheTagHelperFormatter() => throw null;
                        public System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.HtmlString> DeserializeAsync(byte[] value) => throw null;
                        public System.Threading.Tasks.Task<byte[]> SerializeAsync(Microsoft.AspNetCore.Mvc.TagHelpers.Cache.DistributedCacheTagHelperFormattingContext context) => throw null;
                    }
                    public class DistributedCacheTagHelperFormattingContext
                    {
                        public DistributedCacheTagHelperFormattingContext() => throw null;
                        public Microsoft.AspNetCore.Html.HtmlString Html { get => throw null; set { } }
                    }
                    public class DistributedCacheTagHelperService : Microsoft.AspNetCore.Mvc.TagHelpers.Cache.IDistributedCacheTagHelperService
                    {
                        public DistributedCacheTagHelperService(Microsoft.AspNetCore.Mvc.TagHelpers.Cache.IDistributedCacheTagHelperStorage storage, Microsoft.AspNetCore.Mvc.TagHelpers.Cache.IDistributedCacheTagHelperFormatter formatter, System.Text.Encodings.Web.HtmlEncoder HtmlEncoder, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> ProcessContentAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output, Microsoft.AspNetCore.Mvc.TagHelpers.Cache.CacheTagKey key, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options) => throw null;
                    }
                    public class DistributedCacheTagHelperStorage : Microsoft.AspNetCore.Mvc.TagHelpers.Cache.IDistributedCacheTagHelperStorage
                    {
                        public DistributedCacheTagHelperStorage(Microsoft.Extensions.Caching.Distributed.IDistributedCache distributedCache) => throw null;
                        public System.Threading.Tasks.Task<byte[]> GetAsync(string key) => throw null;
                        public System.Threading.Tasks.Task SetAsync(string key, byte[] value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options) => throw null;
                    }
                    public interface IDistributedCacheTagHelperFormatter
                    {
                        System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.HtmlString> DeserializeAsync(byte[] value);
                        System.Threading.Tasks.Task<byte[]> SerializeAsync(Microsoft.AspNetCore.Mvc.TagHelpers.Cache.DistributedCacheTagHelperFormattingContext context);
                    }
                    public interface IDistributedCacheTagHelperService
                    {
                        System.Threading.Tasks.Task<Microsoft.AspNetCore.Html.IHtmlContent> ProcessContentAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output, Microsoft.AspNetCore.Mvc.TagHelpers.Cache.CacheTagKey key, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options);
                    }
                    public interface IDistributedCacheTagHelperStorage
                    {
                        System.Threading.Tasks.Task<byte[]> GetAsync(string key);
                        System.Threading.Tasks.Task SetAsync(string key, byte[] value, Microsoft.Extensions.Caching.Distributed.DistributedCacheEntryOptions options);
                    }
                }
                public class CacheTagHelper : Microsoft.AspNetCore.Mvc.TagHelpers.CacheTagHelperBase
                {
                    public static readonly string CacheKeyPrefix;
                    public CacheTagHelper(Microsoft.AspNetCore.Mvc.TagHelpers.CacheTagHelperMemoryCacheFactory factory, System.Text.Encodings.Web.HtmlEncoder htmlEncoder) : base(default(System.Text.Encodings.Web.HtmlEncoder)) => throw null;
                    protected Microsoft.Extensions.Caching.Memory.IMemoryCache MemoryCache { get => throw null; }
                    public Microsoft.Extensions.Caching.Memory.CacheItemPriority? Priority { get => throw null; set { } }
                    public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                }
                public abstract class CacheTagHelperBase : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public CacheTagHelperBase(System.Text.Encodings.Web.HtmlEncoder htmlEncoder) => throw null;
                    public static readonly System.TimeSpan DefaultExpiration;
                    public bool Enabled { get => throw null; set { } }
                    public System.TimeSpan? ExpiresAfter { get => throw null; set { } }
                    public System.DateTimeOffset? ExpiresOn { get => throw null; set { } }
                    public System.TimeSpan? ExpiresSliding { get => throw null; set { } }
                    protected System.Text.Encodings.Web.HtmlEncoder HtmlEncoder { get => throw null; }
                    public override int Order { get => throw null; }
                    public string VaryBy { get => throw null; set { } }
                    public string VaryByCookie { get => throw null; set { } }
                    public bool VaryByCulture { get => throw null; set { } }
                    public string VaryByHeader { get => throw null; set { } }
                    public string VaryByQuery { get => throw null; set { } }
                    public string VaryByRoute { get => throw null; set { } }
                    public bool VaryByUser { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class CacheTagHelperMemoryCacheFactory
                {
                    public Microsoft.Extensions.Caching.Memory.IMemoryCache Cache { get => throw null; }
                    public CacheTagHelperMemoryCacheFactory(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Mvc.TagHelpers.CacheTagHelperOptions> options) => throw null;
                }
                public class CacheTagHelperOptions
                {
                    public CacheTagHelperOptions() => throw null;
                    public long SizeLimit { get => throw null; set { } }
                }
                public sealed class ComponentTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public System.Type ComponentType { get => throw null; set { } }
                    public ComponentTagHelper() => throw null;
                    public System.Collections.Generic.IDictionary<string, object> Parameters { get => throw null; set { } }
                    public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.RenderMode RenderMode { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class DistributedCacheTagHelper : Microsoft.AspNetCore.Mvc.TagHelpers.CacheTagHelperBase
                {
                    public static readonly string CacheKeyPrefix;
                    public DistributedCacheTagHelper(Microsoft.AspNetCore.Mvc.TagHelpers.Cache.IDistributedCacheTagHelperService distributedCacheService, System.Text.Encodings.Web.HtmlEncoder htmlEncoder) : base(default(System.Text.Encodings.Web.HtmlEncoder)) => throw null;
                    protected Microsoft.Extensions.Caching.Memory.IMemoryCache MemoryCache { get => throw null; }
                    public string Name { get => throw null; set { } }
                    public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                }
                public class EnvironmentTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public EnvironmentTagHelper(Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnvironment) => throw null;
                    public string Exclude { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Hosting.IWebHostEnvironment HostingEnvironment { get => throw null; }
                    public string Include { get => throw null; set { } }
                    public string Names { get => throw null; set { } }
                    public override int Order { get => throw null; }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                }
                public class FormActionTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public string Action { get => throw null; set { } }
                    public string Area { get => throw null; set { } }
                    public string Controller { get => throw null; set { } }
                    public FormActionTagHelper(Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) => throw null;
                    public string Fragment { get => throw null; set { } }
                    public override int Order { get => throw null; }
                    public string Page { get => throw null; set { } }
                    public string PageHandler { get => throw null; set { } }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public string Route { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory UrlHelperFactory { get => throw null; }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class FormTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public string Action { get => throw null; set { } }
                    public bool? Antiforgery { get => throw null; set { } }
                    public string Area { get => throw null; set { } }
                    public string Controller { get => throw null; set { } }
                    public FormTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator) => throw null;
                    public string Fragment { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator Generator { get => throw null; }
                    public string Method { get => throw null; set { } }
                    public override int Order { get => throw null; }
                    public string Page { get => throw null; set { } }
                    public string PageHandler { get => throw null; set { } }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public string Route { get => throw null; set { } }
                    public System.Collections.Generic.IDictionary<string, string> RouteValues { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class GlobbingUrlBuilder
                {
                    public virtual System.Collections.Generic.IReadOnlyList<string> BuildUrlList(string staticUrl, string includePattern, string excludePattern) => throw null;
                    public Microsoft.Extensions.Caching.Memory.IMemoryCache Cache { get => throw null; }
                    public GlobbingUrlBuilder(Microsoft.Extensions.FileProviders.IFileProvider fileProvider, Microsoft.Extensions.Caching.Memory.IMemoryCache cache, Microsoft.AspNetCore.Http.PathString requestPathBase) => throw null;
                    public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; }
                    public Microsoft.AspNetCore.Http.PathString RequestPathBase { get => throw null; }
                }
                public class ImageTagHelper : Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper
                {
                    public bool AppendVersion { get => throw null; set { } }
                    protected Microsoft.Extensions.Caching.Memory.IMemoryCache Cache { get => throw null; }
                    public ImageTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IFileVersionProvider fileVersionProvider, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) : base(default(Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory), default(System.Text.Encodings.Web.HtmlEncoder)) => throw null;
                    public ImageTagHelper(Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnvironment, Microsoft.AspNetCore.Mvc.Razor.Infrastructure.TagHelperMemoryCacheProvider cacheProvider, Microsoft.AspNetCore.Mvc.ViewFeatures.IFileVersionProvider fileVersionProvider, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) : base(default(Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory), default(System.Text.Encodings.Web.HtmlEncoder)) => throw null;
                    protected Microsoft.AspNetCore.Hosting.IWebHostEnvironment HostingEnvironment { get => throw null; }
                    public override int Order { get => throw null; }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public string Src { get => throw null; set { } }
                }
                public class InputTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public InputTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpression For { get => throw null; set { } }
                    public string Format { get => throw null; set { } }
                    public string FormName { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator Generator { get => throw null; }
                    protected string GetInputType(Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExplorer modelExplorer, out string inputTypeHint) => throw null;
                    public string InputTypeName { get => throw null; set { } }
                    public string Name { get => throw null; set { } }
                    public override int Order { get => throw null; }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public string Value { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class LabelTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public LabelTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpression For { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator Generator { get => throw null; }
                    public override int Order { get => throw null; }
                    public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class LinkTagHelper : Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper
                {
                    public bool? AppendVersion { get => throw null; set { } }
                    protected Microsoft.Extensions.Caching.Memory.IMemoryCache Cache { get => throw null; }
                    public LinkTagHelper(Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnvironment, Microsoft.AspNetCore.Mvc.Razor.Infrastructure.TagHelperMemoryCacheProvider cacheProvider, Microsoft.AspNetCore.Mvc.ViewFeatures.IFileVersionProvider fileVersionProvider, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, System.Text.Encodings.Web.JavaScriptEncoder javaScriptEncoder, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) : base(default(Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory), default(System.Text.Encodings.Web.HtmlEncoder)) => throw null;
                    public string FallbackHref { get => throw null; set { } }
                    public string FallbackHrefExclude { get => throw null; set { } }
                    public string FallbackHrefInclude { get => throw null; set { } }
                    public string FallbackTestClass { get => throw null; set { } }
                    public string FallbackTestProperty { get => throw null; set { } }
                    public string FallbackTestValue { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.TagHelpers.GlobbingUrlBuilder GlobbingUrlBuilder { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Hosting.IWebHostEnvironment HostingEnvironment { get => throw null; }
                    public string Href { get => throw null; set { } }
                    public string HrefExclude { get => throw null; set { } }
                    public string HrefInclude { get => throw null; set { } }
                    protected System.Text.Encodings.Web.JavaScriptEncoder JavaScriptEncoder { get => throw null; }
                    public override int Order { get => throw null; }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public bool SuppressFallbackIntegrity { get => throw null; set { } }
                }
                public class OptionTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public OptionTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator Generator { get => throw null; }
                    public override int Order { get => throw null; }
                    public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public string Value { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class PartialTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public PartialTagHelper(Microsoft.AspNetCore.Mvc.ViewEngines.ICompositeViewEngine viewEngine, Microsoft.AspNetCore.Mvc.ViewFeatures.Buffers.IViewBufferScope viewBufferScope) => throw null;
                    public string FallbackName { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpression For { get => throw null; set { } }
                    public object Model { get => throw null; set { } }
                    public string Name { get => throw null; set { } }
                    public bool Optional { get => throw null; set { } }
                    public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ViewDataDictionary ViewData { get => throw null; set { } }
                }
                public class PersistComponentStateTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public PersistComponentStateTagHelper() => throw null;
                    public Microsoft.AspNetCore.Mvc.TagHelpers.PersistenceMode? PersistenceMode { get => throw null; set { } }
                    public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public enum PersistenceMode
                {
                    Server = 0,
                    WebAssembly = 1,
                }
                public class RenderAtEndOfFormTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public RenderAtEndOfFormTagHelper() => throw null;
                    public override void Init(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context) => throw null;
                    public override int Order { get => throw null; }
                    public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class ScriptTagHelper : Microsoft.AspNetCore.Mvc.Razor.TagHelpers.UrlResolutionTagHelper
                {
                    public bool? AppendVersion { get => throw null; set { } }
                    protected Microsoft.Extensions.Caching.Memory.IMemoryCache Cache { get => throw null; }
                    public ScriptTagHelper(Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnvironment, Microsoft.AspNetCore.Mvc.Razor.Infrastructure.TagHelperMemoryCacheProvider cacheProvider, Microsoft.AspNetCore.Mvc.ViewFeatures.IFileVersionProvider fileVersionProvider, System.Text.Encodings.Web.HtmlEncoder htmlEncoder, System.Text.Encodings.Web.JavaScriptEncoder javaScriptEncoder, Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory urlHelperFactory) : base(default(Microsoft.AspNetCore.Mvc.Routing.IUrlHelperFactory), default(System.Text.Encodings.Web.HtmlEncoder)) => throw null;
                    public string FallbackSrc { get => throw null; set { } }
                    public string FallbackSrcExclude { get => throw null; set { } }
                    public string FallbackSrcInclude { get => throw null; set { } }
                    public string FallbackTestExpression { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.TagHelpers.GlobbingUrlBuilder GlobbingUrlBuilder { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Hosting.IWebHostEnvironment HostingEnvironment { get => throw null; }
                    protected System.Text.Encodings.Web.JavaScriptEncoder JavaScriptEncoder { get => throw null; }
                    public override int Order { get => throw null; }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public string Src { get => throw null; set { } }
                    public string SrcExclude { get => throw null; set { } }
                    public string SrcInclude { get => throw null; set { } }
                    public bool SuppressFallbackIntegrity { get => throw null; set { } }
                }
                public class SelectTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public SelectTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpression For { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator Generator { get => throw null; }
                    public override void Init(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context) => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Rendering.SelectListItem> Items { get => throw null; set { } }
                    public string Name { get => throw null; set { } }
                    public override int Order { get => throw null; }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public static partial class TagHelperOutputExtensions
                {
                    public static void AddClass(this Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput tagHelperOutput, string classValue, System.Text.Encodings.Web.HtmlEncoder htmlEncoder) => throw null;
                    public static void CopyHtmlAttribute(this Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput tagHelperOutput, string attributeName, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context) => throw null;
                    public static void MergeAttributes(this Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput tagHelperOutput, Microsoft.AspNetCore.Mvc.Rendering.TagBuilder tagBuilder) => throw null;
                    public static void RemoveClass(this Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput tagHelperOutput, string classValue, System.Text.Encodings.Web.HtmlEncoder htmlEncoder) => throw null;
                    public static void RemoveRange(this Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput tagHelperOutput, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute> attributes) => throw null;
                }
                public class TextAreaTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public TextAreaTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpression For { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator Generator { get => throw null; }
                    public string Name { get => throw null; set { } }
                    public override int Order { get => throw null; }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class ValidationMessageTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public ValidationMessageTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator) => throw null;
                    public Microsoft.AspNetCore.Mvc.ViewFeatures.ModelExpression For { get => throw null; set { } }
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator Generator { get => throw null; }
                    public override int Order { get => throw null; }
                    public override System.Threading.Tasks.Task ProcessAsync(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
                public class ValidationSummaryTagHelper : Microsoft.AspNetCore.Razor.TagHelpers.TagHelper
                {
                    public ValidationSummaryTagHelper(Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator generator) => throw null;
                    protected Microsoft.AspNetCore.Mvc.ViewFeatures.IHtmlGenerator Generator { get => throw null; }
                    public override int Order { get => throw null; }
                    public override void Process(Microsoft.AspNetCore.Razor.TagHelpers.TagHelperContext context, Microsoft.AspNetCore.Razor.TagHelpers.TagHelperOutput output) => throw null;
                    public Microsoft.AspNetCore.Mvc.Rendering.ValidationSummary ValidationSummary { get => throw null; set { } }
                    public Microsoft.AspNetCore.Mvc.Rendering.ViewContext ViewContext { get => throw null; set { } }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class TagHelperServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddCacheTagHelper(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddCacheTagHelperLimits(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.TagHelpers.CacheTagHelperOptions> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddCacheTagHelperLimits(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.TagHelpers.CacheTagHelperOptions> configure) => throw null;
            }
        }
    }
}
