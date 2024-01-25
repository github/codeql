// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.ResponseCompression, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class ResponseCompressionBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseResponseCompression(this Microsoft.AspNetCore.Builder.IApplicationBuilder builder) => throw null;
            }
            public static partial class ResponseCompressionServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddResponseCompression(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddResponseCompression(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.ResponseCompression.ResponseCompressionOptions> configureOptions) => throw null;
            }
        }
        namespace ResponseCompression
        {
            public class BrotliCompressionProvider : Microsoft.AspNetCore.ResponseCompression.ICompressionProvider
            {
                public System.IO.Stream CreateStream(System.IO.Stream outputStream) => throw null;
                public BrotliCompressionProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions> options) => throw null;
                public string EncodingName { get => throw null; }
                public bool SupportsFlush { get => throw null; }
            }
            public class BrotliCompressionProviderOptions : Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions>
            {
                public BrotliCompressionProviderOptions() => throw null;
                public System.IO.Compression.CompressionLevel Level { get => throw null; set { } }
                Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.BrotliCompressionProviderOptions>.Value { get => throw null; }
            }
            public class CompressionProviderCollection : System.Collections.ObjectModel.Collection<Microsoft.AspNetCore.ResponseCompression.ICompressionProvider>
            {
                public void Add<TCompressionProvider>() where TCompressionProvider : Microsoft.AspNetCore.ResponseCompression.ICompressionProvider => throw null;
                public void Add(System.Type providerType) => throw null;
                public CompressionProviderCollection() => throw null;
            }
            public class GzipCompressionProvider : Microsoft.AspNetCore.ResponseCompression.ICompressionProvider
            {
                public System.IO.Stream CreateStream(System.IO.Stream outputStream) => throw null;
                public GzipCompressionProvider(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions> options) => throw null;
                public string EncodingName { get => throw null; }
                public bool SupportsFlush { get => throw null; }
            }
            public class GzipCompressionProviderOptions : Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions>
            {
                public GzipCompressionProviderOptions() => throw null;
                public System.IO.Compression.CompressionLevel Level { get => throw null; set { } }
                Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.GzipCompressionProviderOptions>.Value { get => throw null; }
            }
            public interface ICompressionProvider
            {
                System.IO.Stream CreateStream(System.IO.Stream outputStream);
                string EncodingName { get; }
                bool SupportsFlush { get; }
            }
            public interface IResponseCompressionProvider
            {
                bool CheckRequestAcceptsCompression(Microsoft.AspNetCore.Http.HttpContext context);
                Microsoft.AspNetCore.ResponseCompression.ICompressionProvider GetCompressionProvider(Microsoft.AspNetCore.Http.HttpContext context);
                bool ShouldCompressResponse(Microsoft.AspNetCore.Http.HttpContext context);
            }
            public class ResponseCompressionDefaults
            {
                public ResponseCompressionDefaults() => throw null;
                public static readonly System.Collections.Generic.IEnumerable<string> MimeTypes;
            }
            public class ResponseCompressionMiddleware
            {
                public ResponseCompressionMiddleware(Microsoft.AspNetCore.Http.RequestDelegate next, Microsoft.AspNetCore.ResponseCompression.IResponseCompressionProvider provider) => throw null;
                public System.Threading.Tasks.Task Invoke(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }
            public class ResponseCompressionOptions
            {
                public ResponseCompressionOptions() => throw null;
                public bool EnableForHttps { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> ExcludedMimeTypes { get => throw null; set { } }
                public System.Collections.Generic.IEnumerable<string> MimeTypes { get => throw null; set { } }
                public Microsoft.AspNetCore.ResponseCompression.CompressionProviderCollection Providers { get => throw null; }
            }
            public class ResponseCompressionProvider : Microsoft.AspNetCore.ResponseCompression.IResponseCompressionProvider
            {
                public bool CheckRequestAcceptsCompression(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public ResponseCompressionProvider(System.IServiceProvider services, Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.ResponseCompression.ResponseCompressionOptions> options) => throw null;
                public virtual Microsoft.AspNetCore.ResponseCompression.ICompressionProvider GetCompressionProvider(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                public virtual bool ShouldCompressResponse(Microsoft.AspNetCore.Http.HttpContext context) => throw null;
            }
        }
    }
}
