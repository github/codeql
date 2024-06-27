// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.RequestDecompression, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class RequestDecompressionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseRequestDecompression(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }
        }
        namespace RequestDecompression
        {
            public interface IDecompressionProvider
            {
                System.IO.Stream GetDecompressionStream(System.IO.Stream stream);
            }
            public interface IRequestDecompressionProvider
            {
                System.IO.Stream GetDecompressionStream(Microsoft.AspNetCore.Http.HttpContext context);
            }
            public sealed class RequestDecompressionOptions
            {
                public RequestDecompressionOptions() => throw null;
                public System.Collections.Generic.IDictionary<string, Microsoft.AspNetCore.RequestDecompression.IDecompressionProvider> DecompressionProviders { get => throw null; }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class RequestDecompressionServiceExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRequestDecompression(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddRequestDecompression(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.RequestDecompression.RequestDecompressionOptions> configureOptions) => throw null;
            }
        }
    }
}
