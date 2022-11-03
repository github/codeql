// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.IISOptions` in `Microsoft.AspNetCore.Server.IISIntegration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IISOptions
            {
                public string AuthenticationDisplayName { get => throw null; set => throw null; }
                public bool AutomaticAuthentication { get => throw null; set => throw null; }
                public bool ForwardClientCertificate { get => throw null; set => throw null; }
                public IISOptions() => throw null;
            }

        }
        namespace Hosting
        {
            // Generated from `Microsoft.AspNetCore.Hosting.WebHostBuilderIISExtensions` in `Microsoft.AspNetCore.Server.IIS, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60; Microsoft.AspNetCore.Server.IISIntegration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static partial class WebHostBuilderIISExtensions
            {
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseIISIntegration(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder) => throw null;
            }

        }
        namespace Server
        {
            namespace IISIntegration
            {
                // Generated from `Microsoft.AspNetCore.Server.IISIntegration.IISDefaults` in `Microsoft.AspNetCore.Server.IISIntegration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class IISDefaults
                {
                    public const string AuthenticationScheme = default;
                    public IISDefaults() => throw null;
                    public const string Negotiate = default;
                    public const string Ntlm = default;
                }

                // Generated from `Microsoft.AspNetCore.Server.IISIntegration.IISHostingStartup` in `Microsoft.AspNetCore.Server.IISIntegration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class IISHostingStartup : Microsoft.AspNetCore.Hosting.IHostingStartup
                {
                    public void Configure(Microsoft.AspNetCore.Hosting.IWebHostBuilder builder) => throw null;
                    public IISHostingStartup() => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Server.IISIntegration.IISMiddleware` in `Microsoft.AspNetCore.Server.IISIntegration, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class IISMiddleware
                {
                    public IISMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.IISOptions> options, string pairingToken, bool isWebsocketsSupported, Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider authentication, Microsoft.Extensions.Hosting.IHostApplicationLifetime applicationLifetime) => throw null;
                    public IISMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Builder.IISOptions> options, string pairingToken, Microsoft.AspNetCore.Authentication.IAuthenticationSchemeProvider authentication, Microsoft.Extensions.Hosting.IHostApplicationLifetime applicationLifetime) => throw null;
                    public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext httpContext) => throw null;
                }

            }
        }
    }
}
