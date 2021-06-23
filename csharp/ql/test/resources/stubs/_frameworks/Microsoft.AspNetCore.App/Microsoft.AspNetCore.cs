// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        // Generated from `Microsoft.AspNetCore.WebHost` in `Microsoft.AspNetCore, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
        public static class WebHost
        {
            public static Microsoft.AspNetCore.Hosting.IWebHostBuilder CreateDefaultBuilder<TStartup>(string[] args) where TStartup : class => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHostBuilder CreateDefaultBuilder(string[] args) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHostBuilder CreateDefaultBuilder() => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost Start(string url, System.Action<Microsoft.AspNetCore.Routing.IRouteBuilder> routeBuilder) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost Start(string url, Microsoft.AspNetCore.Http.RequestDelegate app) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost Start(System.Action<Microsoft.AspNetCore.Routing.IRouteBuilder> routeBuilder) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost Start(Microsoft.AspNetCore.Http.RequestDelegate app) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost StartWith(string url, System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> app) => throw null;
            public static Microsoft.AspNetCore.Hosting.IWebHost StartWith(System.Action<Microsoft.AspNetCore.Builder.IApplicationBuilder> app) => throw null;
        }

    }
    namespace Extensions
    {
        namespace Hosting
        {
            // Generated from `Microsoft.Extensions.Hosting.GenericHostBuilderExtensions` in `Microsoft.AspNetCore, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class GenericHostBuilderExtensions
            {
                public static Microsoft.Extensions.Hosting.IHostBuilder ConfigureWebHostDefaults(this Microsoft.Extensions.Hosting.IHostBuilder builder, System.Action<Microsoft.AspNetCore.Hosting.IWebHostBuilder> configure) => throw null;
            }

        }
    }
}
