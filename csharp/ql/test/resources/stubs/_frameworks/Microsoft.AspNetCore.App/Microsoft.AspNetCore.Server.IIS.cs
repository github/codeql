// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Server.IIS, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public class IISServerOptions
            {
                public bool AllowSynchronousIO { get => throw null; set { } }
                public string AuthenticationDisplayName { get => throw null; set { } }
                public bool AutomaticAuthentication { get => throw null; set { } }
                public IISServerOptions() => throw null;
                public int MaxRequestBodyBufferSize { get => throw null; set { } }
                public long? MaxRequestBodySize { get => throw null; set { } }
            }
        }
        namespace Hosting
        {
            public static partial class WebHostBuilderIISExtensions
            {
                public static Microsoft.AspNetCore.Hosting.IWebHostBuilder UseIIS(this Microsoft.AspNetCore.Hosting.IWebHostBuilder hostBuilder) => throw null;
            }
        }
        namespace Server
        {
            namespace IIS
            {
                public sealed class BadHttpRequestException : Microsoft.AspNetCore.Http.BadHttpRequestException
                {
                    public int StatusCode { get => throw null; }
                    internal BadHttpRequestException() : base(default(string)) { }
                }
                public static partial class HttpContextExtensions
                {
                    public static string GetIISServerVariable(this Microsoft.AspNetCore.Http.HttpContext context, string variableName) => throw null;
                }
                public interface IIISEnvironmentFeature
                {
                    string AppConfigPath { get; }
                    string ApplicationId { get; }
                    string ApplicationPhysicalPath { get; }
                    string ApplicationVirtualPath { get; }
                    string AppPoolConfigFile { get; }
                    string AppPoolId { get; }
                    System.Version IISVersion { get; }
                    uint SiteId { get; }
                    string SiteName { get; }
                }
                public class IISServerDefaults
                {
                    public const string AuthenticationScheme = default;
                    public IISServerDefaults() => throw null;
                }
            }
        }
    }
}
