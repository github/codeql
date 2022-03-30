// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.DefaultFilesExtensions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DefaultFilesExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDefaultFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string requestPath) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDefaultFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.DefaultFilesOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDefaultFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.DefaultFilesOptions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultFilesOptions : Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptionsBase
            {
                public System.Collections.Generic.IList<string> DefaultFileNames { get => throw null; set => throw null; }
                public DefaultFilesOptions(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions sharedOptions) : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public DefaultFilesOptions() : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.DirectoryBrowserExtensions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DirectoryBrowserExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDirectoryBrowser(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string requestPath) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDirectoryBrowser(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.DirectoryBrowserOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDirectoryBrowser(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.DirectoryBrowserOptions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DirectoryBrowserOptions : Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptionsBase
            {
                public DirectoryBrowserOptions(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions sharedOptions) : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public DirectoryBrowserOptions() : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public Microsoft.AspNetCore.StaticFiles.IDirectoryFormatter Formatter { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Builder.FileServerExtensions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class FileServerExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseFileServer(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string requestPath) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseFileServer(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, bool enableDirectoryBrowsing) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseFileServer(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.FileServerOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseFileServer(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.FileServerOptions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FileServerOptions : Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptionsBase
            {
                public Microsoft.AspNetCore.Builder.DefaultFilesOptions DefaultFilesOptions { get => throw null; }
                public Microsoft.AspNetCore.Builder.DirectoryBrowserOptions DirectoryBrowserOptions { get => throw null; }
                public bool EnableDefaultFiles { get => throw null; set => throw null; }
                public bool EnableDirectoryBrowsing { get => throw null; set => throw null; }
                public FileServerOptions() : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public Microsoft.AspNetCore.Builder.StaticFileOptions StaticFileOptions { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Builder.StaticFileExtensions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class StaticFileExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStaticFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string requestPath) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStaticFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.StaticFileOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStaticFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.StaticFileOptions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StaticFileOptions : Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptionsBase
            {
                public Microsoft.AspNetCore.StaticFiles.IContentTypeProvider ContentTypeProvider { get => throw null; set => throw null; }
                public string DefaultContentType { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.Features.HttpsCompressionMode HttpsCompression { get => throw null; set => throw null; }
                public System.Action<Microsoft.AspNetCore.StaticFiles.StaticFileResponseContext> OnPrepareResponse { get => throw null; set => throw null; }
                public bool ServeUnknownFileTypes { get => throw null; set => throw null; }
                public StaticFileOptions(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions sharedOptions) : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public StaticFileOptions() : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.StaticFilesEndpointRouteBuilderExtensions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class StaticFilesEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToFile(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string filePath, Microsoft.AspNetCore.Builder.StaticFileOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToFile(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string filePath) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToFile(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string filePath, Microsoft.AspNetCore.Builder.StaticFileOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToFile(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string filePath) => throw null;
            }

        }
        namespace StaticFiles
        {
            // Generated from `Microsoft.AspNetCore.StaticFiles.DefaultFilesMiddleware` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DefaultFilesMiddleware
            {
                public DefaultFilesMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnv, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.DefaultFilesOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.StaticFiles.DirectoryBrowserMiddleware` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DirectoryBrowserMiddleware
            {
                public DirectoryBrowserMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnv, System.Text.Encodings.Web.HtmlEncoder encoder, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.DirectoryBrowserOptions> options) => throw null;
                public DirectoryBrowserMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnv, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.DirectoryBrowserOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.StaticFiles.FileExtensionContentTypeProvider` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class FileExtensionContentTypeProvider : Microsoft.AspNetCore.StaticFiles.IContentTypeProvider
            {
                public FileExtensionContentTypeProvider(System.Collections.Generic.IDictionary<string, string> mapping) => throw null;
                public FileExtensionContentTypeProvider() => throw null;
                public System.Collections.Generic.IDictionary<string, string> Mappings { get => throw null; }
                public bool TryGetContentType(string subpath, out string contentType) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.StaticFiles.HtmlDirectoryFormatter` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class HtmlDirectoryFormatter : Microsoft.AspNetCore.StaticFiles.IDirectoryFormatter
            {
                public virtual System.Threading.Tasks.Task GenerateContentAsync(Microsoft.AspNetCore.Http.HttpContext context, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo> contents) => throw null;
                public HtmlDirectoryFormatter(System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.StaticFiles.IContentTypeProvider` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IContentTypeProvider
            {
                bool TryGetContentType(string subpath, out string contentType);
            }

            // Generated from `Microsoft.AspNetCore.StaticFiles.IDirectoryFormatter` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDirectoryFormatter
            {
                System.Threading.Tasks.Task GenerateContentAsync(Microsoft.AspNetCore.Http.HttpContext context, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo> contents);
            }

            // Generated from `Microsoft.AspNetCore.StaticFiles.StaticFileMiddleware` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StaticFileMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public StaticFileMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnv, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.StaticFileOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.StaticFiles.StaticFileResponseContext` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StaticFileResponseContext
            {
                public Microsoft.AspNetCore.Http.HttpContext Context { get => throw null; }
                public Microsoft.Extensions.FileProviders.IFileInfo File { get => throw null; }
                public StaticFileResponseContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.Extensions.FileProviders.IFileInfo file) => throw null;
                public StaticFileResponseContext() => throw null;
            }

            namespace Infrastructure
            {
                // Generated from `Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class SharedOptions
                {
                    public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; set => throw null; }
                    public bool RedirectToAppendTrailingSlash { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.PathString RequestPath { get => throw null; set => throw null; }
                    public SharedOptions() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptionsBase` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public abstract class SharedOptionsBase
                {
                    public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; set => throw null; }
                    public bool RedirectToAppendTrailingSlash { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.PathString RequestPath { get => throw null; set => throw null; }
                    protected Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions SharedOptions { get => throw null; }
                    protected SharedOptionsBase(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions sharedOptions) => throw null;
                }

            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.DirectoryBrowserServiceExtensions` in `Microsoft.AspNetCore.StaticFiles, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DirectoryBrowserServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddDirectoryBrowser(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
