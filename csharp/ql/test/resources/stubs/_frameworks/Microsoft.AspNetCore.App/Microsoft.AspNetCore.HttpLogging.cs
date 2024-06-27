// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.HttpLogging, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static partial class HttpLoggingBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHttpLogging(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseW3CLogging(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }
            public static partial class HttpLoggingEndpointConventionBuilderExtensions
            {
                public static TBuilder WithHttpLogging<TBuilder>(this TBuilder builder, Microsoft.AspNetCore.HttpLogging.HttpLoggingFields loggingFields, int? requestBodyLogLimit = default(int?), int? responseBodyLogLimit = default(int?)) where TBuilder : Microsoft.AspNetCore.Builder.IEndpointConventionBuilder => throw null;
            }
        }
        namespace HttpLogging
        {
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
            public sealed class HttpLoggingAttribute : System.Attribute
            {
                public HttpLoggingAttribute(Microsoft.AspNetCore.HttpLogging.HttpLoggingFields loggingFields) => throw null;
                public bool IsRequestBodyLogLimitSet { get => throw null; }
                public bool IsResponseBodyLogLimitSet { get => throw null; }
                public Microsoft.AspNetCore.HttpLogging.HttpLoggingFields LoggingFields { get => throw null; }
                public int RequestBodyLogLimit { get => throw null; set { } }
                public int ResponseBodyLogLimit { get => throw null; set { } }
            }
            [System.Flags]
            public enum HttpLoggingFields : long
            {
                None = 0,
                RequestPath = 1,
                RequestQuery = 2,
                RequestProtocol = 4,
                RequestMethod = 8,
                RequestScheme = 16,
                ResponseStatusCode = 32,
                RequestHeaders = 64,
                ResponseHeaders = 128,
                RequestTrailers = 256,
                ResponseTrailers = 512,
                RequestBody = 1024,
                ResponseBody = 2048,
                Duration = 4096,
                RequestProperties = 29,
                RequestPropertiesAndHeaders = 93,
                ResponsePropertiesAndHeaders = 160,
                Request = 1117,
                Response = 2208,
                All = 7421,
            }
            public sealed class HttpLoggingInterceptorContext
            {
                public void AddParameter(string key, object value) => throw null;
                public HttpLoggingInterceptorContext() => throw null;
                public void Disable(Microsoft.AspNetCore.HttpLogging.HttpLoggingFields fields) => throw null;
                public void Enable(Microsoft.AspNetCore.HttpLogging.HttpLoggingFields fields) => throw null;
                public Microsoft.AspNetCore.Http.HttpContext HttpContext { get => throw null; set { } }
                public bool IsAnyEnabled(Microsoft.AspNetCore.HttpLogging.HttpLoggingFields fields) => throw null;
                public Microsoft.AspNetCore.HttpLogging.HttpLoggingFields LoggingFields { get => throw null; set { } }
                public System.Collections.Generic.IList<System.Collections.Generic.KeyValuePair<string, object>> Parameters { get => throw null; }
                public int RequestBodyLogLimit { get => throw null; set { } }
                public int ResponseBodyLogLimit { get => throw null; set { } }
                public bool TryDisable(Microsoft.AspNetCore.HttpLogging.HttpLoggingFields fields) => throw null;
            }
            public sealed class HttpLoggingOptions
            {
                public bool CombineLogs { get => throw null; set { } }
                public HttpLoggingOptions() => throw null;
                public Microsoft.AspNetCore.HttpLogging.HttpLoggingFields LoggingFields { get => throw null; set { } }
                public Microsoft.AspNetCore.HttpLogging.MediaTypeOptions MediaTypeOptions { get => throw null; }
                public int RequestBodyLogLimit { get => throw null; set { } }
                public System.Collections.Generic.ISet<string> RequestHeaders { get => throw null; }
                public int ResponseBodyLogLimit { get => throw null; set { } }
                public System.Collections.Generic.ISet<string> ResponseHeaders { get => throw null; }
            }
            public interface IHttpLoggingInterceptor
            {
                System.Threading.Tasks.ValueTask OnRequestAsync(Microsoft.AspNetCore.HttpLogging.HttpLoggingInterceptorContext logContext);
                System.Threading.Tasks.ValueTask OnResponseAsync(Microsoft.AspNetCore.HttpLogging.HttpLoggingInterceptorContext logContext);
            }
            public sealed class MediaTypeOptions
            {
                public void AddBinary(Microsoft.Net.Http.Headers.MediaTypeHeaderValue mediaType) => throw null;
                public void AddBinary(string contentType) => throw null;
                public void AddText(string contentType) => throw null;
                public void AddText(string contentType, System.Text.Encoding encoding) => throw null;
                public void Clear() => throw null;
            }
            public sealed class W3CLoggerOptions
            {
                public System.Collections.Generic.ISet<string> AdditionalRequestHeaders { get => throw null; }
                public W3CLoggerOptions() => throw null;
                public string FileName { get => throw null; set { } }
                public int? FileSizeLimit { get => throw null; set { } }
                public System.TimeSpan FlushInterval { get => throw null; set { } }
                public string LogDirectory { get => throw null; set { } }
                public Microsoft.AspNetCore.HttpLogging.W3CLoggingFields LoggingFields { get => throw null; set { } }
                public int? RetainedFileCountLimit { get => throw null; set { } }
            }
            [System.Flags]
            public enum W3CLoggingFields : long
            {
                None = 0,
                Date = 1,
                Time = 2,
                ClientIpAddress = 4,
                UserName = 8,
                ServerName = 16,
                ServerIpAddress = 32,
                ServerPort = 64,
                Method = 128,
                UriStem = 256,
                UriQuery = 512,
                ProtocolStatus = 1024,
                TimeTaken = 2048,
                ProtocolVersion = 4096,
                Host = 8192,
                UserAgent = 16384,
                Cookie = 32768,
                Referer = 65536,
                ConnectionInfoFields = 100,
                RequestHeaders = 90112,
                Request = 95104,
                All = 131071,
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class HttpLoggingServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHttpLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpLogging.HttpLoggingOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHttpLoggingInterceptor<T>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where T : class, Microsoft.AspNetCore.HttpLogging.IHttpLoggingInterceptor => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddW3CLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpLogging.W3CLoggerOptions> configureOptions) => throw null;
            }
        }
    }
}
