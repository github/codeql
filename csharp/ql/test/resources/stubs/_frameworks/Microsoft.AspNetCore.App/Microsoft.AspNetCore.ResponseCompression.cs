// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.ResponseCompressionBuilderExtensions` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ResponseCompressionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseResponseCompression(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Builder.ResponseCompressionServicesExtensions` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ResponseCompressionServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddResponseCompression(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.ResponseCompression.ResponseCompressionOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddResponseCompression(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
            }

        }
        namespace ResponseCompression
        {
            // Generated from `Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProvider` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BrotliCompressionProvider : Microsoft.AspNetCore.ResponseCompression.ICompressionProvider
            {
                public BrotliCompressionProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions> options) => throw null;
                public System.IO.Stream CreateStream(System.IO.Stream outputStream) => throw null;
                public string EncodingName { get => throw null; }
                public bool SupportsFlush { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class BrotliCompressionProviderOptions : Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions>
            {
                public BrotliCompressionProviderOptions() => throw null;
                public System.IO.Compression.CompressionLevel Level { get => throw null; set => throw null; }
                Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions>.Value { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.CompressionProviderCollection` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class CompressionProviderCollection : System.Collections.ObjectModel.Collection<Microsoft.AspNetCore.ResponseCompression.ICompressionProvider>
            {
                public void Add<TCompressionProvider>() where TCompressionProvider : Microsoft.AspNetCore.ResponseCompression.ICompressionProvider => throw null;
                public void Add(System.Type providerType) => throw null;
                public CompressionProviderCollection() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.GzipCompressionProvider` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class GzipCompressionProvider : Microsoft.AspNetCore.ResponseCompression.ICompressionProvider
            {
                public System.IO.Stream CreateStream(System.IO.Stream outputStream) => throw null;
                public string EncodingName { get => throw null; }
                public GzipCompressionProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions> options) => throw null;
                public bool SupportsFlush { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class GzipCompressionProviderOptions : Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions>
            {
                public GzipCompressionProviderOptions() => throw null;
                public System.IO.Compression.CompressionLevel Level { get => throw null; set => throw null; }
                Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions>.Value { get => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.ICompressionProvider` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ICompressionProvider
            {
                System.IO.Stream CreateStream(System.IO.Stream outputStream);
                string EncodingName { get; }
                bool SupportsFlush { get; }
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.IResponseCompressionProvider` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IResponseCompressionProvider
            {
                bool CheckRequestAcceptsCompression(Microsoft.AspNetCore.Http.HttpContext context);
                Microsoft.AspNetCore.ResponseCompression.ICompressionProvider GetCompressionProvider(Microsoft.AspNetCore.Http.HttpContext context);
                bool ShouldCompressResponse(Microsoft.AspNetCore.Http.HttpContext context);
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.ResponseCompressionDefaults` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResponseCompressionDefaults
            {
                public static System.Collections.Generic.IEnumerable<string> MimeTypes;
                public ResponseCompressionDefaults() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.ResponseCompressionMiddleware` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResponseCompressionMiddleware
            {
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public ResponseCompressionMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.ResponseCompression.IResponseCompressionProvider provider) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.ResponseCompressionOptions` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResponseCompressionOptions
            {
                public bool EnableForHttps { get => throw null; set => throw null; }
                public System.Collections.Generic.IEnumerable<string> ExcludedMimeTypes { get => throw null; set => throw null; }
                public System.Collections.Generic.IEnumerable<string> MimeTypes { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.ResponseCompression.CompressionProviderCollection Providers { get => throw null; }
                public ResponseCompressionOptions() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.ResponseCompression.ResponseCompressionProvider` in `Microsoft.AspNetCore.ResponseCompression, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class ResponseCompressionProvider : Microsoft.AspNetCore.ResponseCompression.IResponseCompressionProvider
            {
                public bool CheckRequestAcceptsCompression(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public virtual Microsoft.AspNetCore.ResponseCompression.ICompressionProvider GetCompressionProvider(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public ResponseCompressionProvider(System.IServiceProvider services, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.ResponseCompressionOptions> options) => throw null;
                public virtual bool ShouldCompressResponse(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }

        }
    }
}
