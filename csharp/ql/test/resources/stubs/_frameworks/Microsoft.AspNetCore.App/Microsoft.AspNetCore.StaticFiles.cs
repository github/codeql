// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.StaticFiles, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static class DefaultFilesExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDefaultFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDefaultFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.DefaultFilesOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDefaultFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string requestPath) => throw null;
            }

            public class DefaultFilesOptions : Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptionsBase
            {
                public System.Collections.Generic.IList<string> DefaultFileNames { get => throw null; set => throw null; }
                public DefaultFilesOptions() : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public DefaultFilesOptions(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions sharedOptions) : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
            }

            public static class DirectoryBrowserExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDirectoryBrowser(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDirectoryBrowser(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.DirectoryBrowserOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDirectoryBrowser(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string requestPath) => throw null;
            }

            public class DirectoryBrowserOptions : Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptionsBase
            {
                public DirectoryBrowserOptions() : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public DirectoryBrowserOptions(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions sharedOptions) : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public Microsoft.AspNetCore.StaticFiles.IDirectoryFormatter Formatter { get => throw null; set => throw null; }
            }

            public static class FileServerExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseFileServer(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseFileServer(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.FileServerOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseFileServer(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, bool enableDirectoryBrowsing) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseFileServer(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string requestPath) => throw null;
            }

            public class FileServerOptions : Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptionsBase
            {
                public Microsoft.AspNetCore.Builder.DefaultFilesOptions DefaultFilesOptions { get => throw null; }
                public Microsoft.AspNetCore.Builder.DirectoryBrowserOptions DirectoryBrowserOptions { get => throw null; }
                public bool EnableDefaultFiles { get => throw null; set => throw null; }
                public bool EnableDirectoryBrowsing { get => throw null; set => throw null; }
                public FileServerOptions() : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public Microsoft.AspNetCore.Builder.StaticFileOptions StaticFileOptions { get => throw null; }
            }

            public static class StaticFileExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStaticFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStaticFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.StaticFileOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStaticFiles(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string requestPath) => throw null;
            }

            public class StaticFileOptions : Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptionsBase
            {
                public Microsoft.AspNetCore.StaticFiles.IContentTypeProvider ContentTypeProvider { get => throw null; set => throw null; }
                public string DefaultContentType { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.Features.HttpsCompressionMode HttpsCompression { get => throw null; set => throw null; }
                public System.Action<Microsoft.AspNetCore.StaticFiles.StaticFileResponseContext> OnPrepareResponse { get => throw null; set => throw null; }
                public bool ServeUnknownFileTypes { get => throw null; set => throw null; }
                public StaticFileOptions() : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
                public StaticFileOptions(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions sharedOptions) : base(default(Microsoft.AspNetCore.StaticFiles.Infrastructure.SharedOptions)) => throw null;
            }

            public static class StaticFilesEndpointRouteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToFile(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string filePath) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToFile(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string filePath, Microsoft.AspNetCore.Builder.StaticFileOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToFile(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string filePath) => throw null;
                public static Microsoft.AspNetCore.Builder.IEndpointConventionBuilder MapFallbackToFile(this Microsoft.AspNetCore.Routing.IEndpointRouteBuilder endpoints, string pattern, string filePath, Microsoft.AspNetCore.Builder.StaticFileOptions options) => throw null;
            }

        }
        namespace StaticFiles
        {
            public class DefaultFilesMiddleware
            {
                public DefaultFilesMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnv, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.DefaultFilesOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            public class DirectoryBrowserMiddleware
            {
                public DirectoryBrowserMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnv, System.Text.Encodings.Web.HtmlEncoder encoder, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.DirectoryBrowserOptions> options) => throw null;
                public DirectoryBrowserMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnv, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.DirectoryBrowserOptions> options) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            public class FileExtensionContentTypeProvider : Microsoft.AspNetCore.StaticFiles.IContentTypeProvider
            {
                public FileExtensionContentTypeProvider() => throw null;
                public FileExtensionContentTypeProvider(System.Collections.Generic.IDictionary<string, string> mapping) => throw null;
                public System.Collections.Generic.IDictionary<string, string> Mappings { get => throw null; }
                public bool TryGetContentType(string subpath, out string contentType) => throw null;
            }

            public class HtmlDirectoryFormatter : Microsoft.AspNetCore.StaticFiles.IDirectoryFormatter
            {
                public virtual System.Threading.Tasks.Task GenerateContentAsync(Microsoft.AspNetCore.Http.HttpContext context, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo> contents) => throw null;
                public HtmlDirectoryFormatter(System.Text.Encodings.Web.HtmlEncoder encoder) => throw null;
            }

            public interface IContentTypeProvider
            {
                bool TryGetContentType(string subpath, out string contentType);
            }

            public interface IDirectoryFormatter
            {
                System.Threading.Tasks.Task GenerateContentAsync(Microsoft.AspNetCore.Http.HttpContext context, System.Collections.Generic.IEnumerable<Microsoft.Extensions.FileProviders.IFileInfo> contents);
            }

            public class StaticFileMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public StaticFileMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnv, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.StaticFileOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
            }

            public class StaticFileResponseContext
            {
                public Microsoft.AspNetCore.Http.HttpContext Context { get => throw null; }
                public Microsoft.Extensions.FileProviders.IFileInfo File { get => throw null; }
                public StaticFileResponseContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.Extensions.FileProviders.IFileInfo file) => throw null;
            }

            namespace Infrastructure
            {
                public class SharedOptions
                {
                    public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; set => throw null; }
                    public bool RedirectToAppendTrailingSlash { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Http.PathString RequestPath { get => throw null; set => throw null; }
                    public SharedOptions() => throw null;
                }

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
            public static class DirectoryBrowserServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddDirectoryBrowser(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
    }
}
