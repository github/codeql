// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.RewriteBuilderExtensions` in `Microsoft.AspNetCore.Rewrite, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RewriteBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRewriter(this Microsoft.AspNetCore.Builder.IApplicationBuilder app, Microsoft.AspNetCore.Rewrite.RewriteOptions options) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRewriter(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

        }
        namespace Rewrite
        {
            // Generated from `Microsoft.AspNetCore.Rewrite.ApacheModRewriteOptionsExtensions` in `Microsoft.AspNetCore.Rewrite, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ApacheModRewriteOptionsExtensions
            {
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddApacheModRewrite(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, System.IO.TextReader reader) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddApacheModRewrite(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, Microsoft.Extensions.FileProviders.IFileProvider fileProvider, string filePath) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Rewrite.IISUrlRewriteOptionsExtensions` in `Microsoft.AspNetCore.Rewrite, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class IISUrlRewriteOptionsExtensions
            {
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddIISUrlRewrite(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, System.IO.TextReader reader, bool alwaysUseManagedServerVariables = default(bool)) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddIISUrlRewrite(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, Microsoft.Extensions.FileProviders.IFileProvider fileProvider, string filePath, bool alwaysUseManagedServerVariables = default(bool)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Rewrite.IRule` in `Microsoft.AspNetCore.Rewrite, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRule
            {
                void ApplyRule(Microsoft.AspNetCore.Rewrite.RewriteContext context);
            }

            // Generated from `Microsoft.AspNetCore.Rewrite.RewriteContext` in `Microsoft.AspNetCore.Rewrite, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RewriteContext
            {
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set => throw null; }
                public Microsoft.Extensions.Logging.ILogger Logger { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.Rewrite.RuleResult Result { get => throw null; set => throw null; }
                public RewriteContext() => throw null;
                public Microsoft.Extensions.FileProviders.IFileProvider StaticFileProvider { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Rewrite.RewriteMiddleware` in `Microsoft.AspNetCore.Rewrite, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RewriteMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public RewriteMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.Hosting.IWebHostEnvironment hostingEnvironment, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Rewrite.RewriteOptions> options) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Rewrite.RewriteOptions` in `Microsoft.AspNetCore.Rewrite, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RewriteOptions
            {
                public RewriteOptions() => throw null;
                public System.Collections.Generic.IList<Microsoft.AspNetCore.Rewrite.IRule> Rules { get => throw null; }
                public Microsoft.Extensions.FileProviders.IFileProvider StaticFileProvider { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Rewrite.RewriteOptionsExtensions` in `Microsoft.AspNetCore.Rewrite, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RewriteOptionsExtensions
            {
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions Add(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, System.Action<Microsoft.AspNetCore.Rewrite.RewriteContext> applyRule) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions Add(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, Microsoft.AspNetCore.Rewrite.IRule rule) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirect(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, string regex, string replacement, int statusCode) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirect(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, string regex, string replacement) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToHttps(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, int statusCode, int? sslPort) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToHttps(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, int statusCode) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToHttps(this Microsoft.AspNetCore.Rewrite.RewriteOptions options) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToHttpsPermanent(this Microsoft.AspNetCore.Rewrite.RewriteOptions options) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToNonWww(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, params string[] domains) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToNonWww(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, int statusCode, params string[] domains) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToNonWww(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, int statusCode) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToNonWww(this Microsoft.AspNetCore.Rewrite.RewriteOptions options) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToNonWwwPermanent(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, params string[] domains) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToNonWwwPermanent(this Microsoft.AspNetCore.Rewrite.RewriteOptions options) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToWww(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, params string[] domains) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToWww(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, int statusCode, params string[] domains) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToWww(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, int statusCode) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToWww(this Microsoft.AspNetCore.Rewrite.RewriteOptions options) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToWwwPermanent(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, params string[] domains) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRedirectToWwwPermanent(this Microsoft.AspNetCore.Rewrite.RewriteOptions options) => throw null;
                public static Microsoft.AspNetCore.Rewrite.RewriteOptions AddRewrite(this Microsoft.AspNetCore.Rewrite.RewriteOptions options, string regex, string replacement, bool skipRemainingRules) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Rewrite.RuleResult` in `Microsoft.AspNetCore.Rewrite, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public enum RuleResult
            {
                ContinueRules,
                EndResponse,
                SkipRemainingRules,
            }

        }
    }
}
