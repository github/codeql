// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.RequestDecompressionBuilderExtensions` in `Microsoft.AspNetCore.RequestDecompression, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RequestDecompressionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRequestDecompression(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }

        }
        namespace RequestDecompression
        {
            // Generated from `Microsoft.AspNetCore.RequestDecompression.IDecompressionProvider` in `Microsoft.AspNetCore.RequestDecompression, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDecompressionProvider
            {
                System.IO.Stream GetDecompressionStream(System.IO.Stream stream);
            }

            // Generated from `Microsoft.AspNetCore.RequestDecompression.IRequestDecompressionProvider` in `Microsoft.AspNetCore.RequestDecompression, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IRequestDecompressionProvider
            {
                System.IO.Stream GetDecompressionStream(Microsoft.AspNetCore.Http.HttpContext context);
            }

            // Generated from `Microsoft.AspNetCore.RequestDecompression.RequestDecompressionOptions` in `Microsoft.AspNetCore.RequestDecompression, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class RequestDecompressionOptions
            {
                public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.RequestDecompression.IDecompressionProvider> DecompressionProviders { get => throw null; }
                public RequestDecompressionOptions() => throw null;
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.RequestDecompressionServiceExtensions` in `Microsoft.AspNetCore.RequestDecompression, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class RequestDecompressionServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRequestDecompression(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRequestDecompression(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.RequestDecompression.RequestDecompressionOptions> configureOptions) => throw null;
            }

        }
    }
}
