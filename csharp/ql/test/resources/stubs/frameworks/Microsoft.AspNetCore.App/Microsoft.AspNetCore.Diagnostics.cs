// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.DeveloperExceptionPageExtensions` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DeveloperExceptionPageExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDeveloperExceptionPage(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.DeveloperExceptionPageOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseDeveloperExceptionPage(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.DeveloperExceptionPageOptions` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DeveloperExceptionPageOptions
            {
                public DeveloperExceptionPageOptions() => throw null;
                public Microsoft.Extensions.FileProviders.IFileProvider FileProvider { get => throw null; set => throw null; }
                public int SourceCodeLineCount { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Builder.ExceptionHandlerExtensions` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ExceptionHandlerExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseExceptionHandler(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string errorHandlingPath) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseExceptionHandler(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configure) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseExceptionHandler(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.ExceptionHandlerOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseExceptionHandler(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.ExceptionHandlerOptions` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ExceptionHandlerOptions
            {
                public bool AllowStatusCode404Response { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Http.RequestDelegate ExceptionHandler { get => throw null; set => throw null; }
                public ExceptionHandlerOptions() => throw null;
                public Microsoft.AspNetCore.Http.PathString ExceptionHandlingPath { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Builder.StatusCodePagesExtensions` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class StatusCodePagesExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStatusCodePages(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string contentType, string bodyFormat) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStatusCodePages(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Func<Microsoft.AspNetCore.Diagnostics.StatusCodeContext, System.Threading.Tasks.Task> handler) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStatusCodePages(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> configuration) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStatusCodePages(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.StatusCodePagesOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStatusCodePages(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStatusCodePagesWithReExecute(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string pathFormat, string queryFormat = default(string)) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseStatusCodePagesWithRedirects(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string locationFormat) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.StatusCodePagesOptions` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StatusCodePagesOptions
            {
                public System.Func<Microsoft.AspNetCore.Diagnostics.StatusCodeContext, System.Threading.Tasks.Task> HandleAsync { get => throw null; set => throw null; }
                public StatusCodePagesOptions() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.WelcomePageExtensions` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class WelcomePageExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWelcomePage(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, string path) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWelcomePage(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Http.PathString path) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWelcomePage(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Builder.WelcomePageOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseWelcomePage(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.WelcomePageOptions` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class WelcomePageOptions
            {
                public Microsoft.AspNetCore.Http.PathString Path { get => throw null; set => throw null; }
                public WelcomePageOptions() => throw null;
            }

        }
        namespace Diagnostics
        {
            // Generated from `Microsoft.AspNetCore.Diagnostics.DeveloperExceptionPageMiddleware` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class DeveloperExceptionPageMiddleware
            {
                public DeveloperExceptionPageMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.DeveloperExceptionPageOptions> options, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnvironment, System.Diagnostics.DiagnosticSource diagnosticSource, System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Diagnostics.IDeveloperPageExceptionFilter> filters) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.ExceptionHandlerFeature` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ExceptionHandlerFeature : Microsoft.AspNetCore.Diagnostics.IExceptionHandlerPathFeature, Microsoft.AspNetCore.Diagnostics.IExceptionHandlerFeature
            {
                public System.Exception Error { get => throw null; set => throw null; }
                public ExceptionHandlerFeature() => throw null;
                public string Path { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.ExceptionHandlerMiddleware` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ExceptionHandlerMiddleware
            {
                public ExceptionHandlerMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.ExceptionHandlerOptions> options, System.Diagnostics.DiagnosticListener diagnosticListener) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.StatusCodeContext` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StatusCodeContext
            {
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; }
                public Microsoft.AspNetCore.Http.RequestDelegate Next { get => throw null; }
                public Microsoft.AspNetCore.Builder.StatusCodePagesOptions Options { get => throw null; }
                public StatusCodeContext(Microsoft.AspNetCore.Http.HttpContext context, Microsoft.AspNetCore.Builder.StatusCodePagesOptions options, Microsoft.AspNetCore.Http.RequestDelegate next) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.StatusCodePagesFeature` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StatusCodePagesFeature : Microsoft.AspNetCore.Diagnostics.IStatusCodePagesFeature
            {
                public bool Enabled { get => throw null; set => throw null; }
                public StatusCodePagesFeature() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.StatusCodePagesMiddleware` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StatusCodePagesMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public StatusCodePagesMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.StatusCodePagesOptions> options) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.StatusCodeReExecuteFeature` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class StatusCodeReExecuteFeature : Microsoft.AspNetCore.Diagnostics.IStatusCodeReExecuteFeature
            {
                public string OriginalPath { get => throw null; set => throw null; }
                public string OriginalPathBase { get => throw null; set => throw null; }
                public string OriginalQueryString { get => throw null; set => throw null; }
                public StatusCodeReExecuteFeature() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Diagnostics.WelcomePageMiddleware` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class WelcomePageMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public WelcomePageMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.WelcomePageOptions> options) => throw null;
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.ExceptionHandlerServiceCollectionExtensions` in `Microsoft.AspNetCore.Diagnostics, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ExceptionHandlerServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddExceptionHandler<TService>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Builder.ExceptionHandlerOptions, TService> configureOptions) where TService : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddExceptionHandler(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.Builder.ExceptionHandlerOptions> configureOptions) => throw null;
            }

        }
    }
}
