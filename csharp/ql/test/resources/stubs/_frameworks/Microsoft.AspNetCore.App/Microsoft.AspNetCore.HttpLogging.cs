// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.HttpLogging, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public static class HttpLoggingBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHttpLogging(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseW3CLogging(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

        }
        namespace HttpLogging
        {
            [System.Flags]
            public enum HttpLoggingFields : long
            {
                All = 3325,
                None = 0,
                Request = 1117,
                RequestBody = 1024,
                RequestHeaders = 64,
                RequestMethod = 8,
                RequestPath = 1,
                RequestProperties = 29,
                RequestPropertiesAndHeaders = 93,
                RequestProtocol = 4,
                RequestQuery = 2,
                RequestScheme = 16,
                RequestTrailers = 256,
                Response = 2208,
                ResponseBody = 2048,
                ResponseHeaders = 128,
                ResponsePropertiesAndHeaders = 160,
                ResponseStatusCode = 32,
                ResponseTrailers = 512,
            }

            public class HttpLoggingOptions
            {
                public HttpLoggingOptions() => throw null;
                public Microsoft.AspNetCore.HttpLogging.HttpLoggingFields LoggingFields { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.HttpLogging.MediaTypeOptions MediaTypeOptions { get => throw null; }
                public int RequestBodyLogLimit { get => throw null; set => throw null; }
                public System.Collections.Generic.ISet<string> RequestHeaders { get => throw null; }
                public int ResponseBodyLogLimit { get => throw null; set => throw null; }
                public System.Collections.Generic.ISet<string> ResponseHeaders { get => throw null; }
            }

            public class MediaTypeOptions
            {
                public void AddBinary(Microsoft.Net.Http.Headers.MediaTypeHeaderValue mediaType) => throw null;
                public void AddBinary(string contentType) => throw null;
                public void AddText(string contentType) => throw null;
                public void AddText(string contentType, System.Text.Encoding encoding) => throw null;
                public void Clear() => throw null;
            }

            public class W3CLoggerOptions
            {
                public System.Collections.Generic.ISet<string> AdditionalRequestHeaders { get => throw null; }
                public string FileName { get => throw null; set => throw null; }
                public int? FileSizeLimit { get => throw null; set => throw null; }
                public System.TimeSpan FlushInterval { get => throw null; set => throw null; }
                public string LogDirectory { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.HttpLogging.W3CLoggingFields LoggingFields { get => throw null; set => throw null; }
                public int? RetainedFileCountLimit { get => throw null; set => throw null; }
                public W3CLoggerOptions() => throw null;
            }

            [System.Flags]
            public enum W3CLoggingFields : long
            {
                All = 131071,
                ClientIpAddress = 4,
                ConnectionInfoFields = 100,
                Cookie = 32768,
                Date = 1,
                Host = 8192,
                Method = 128,
                None = 0,
                ProtocolStatus = 1024,
                ProtocolVersion = 4096,
                Referer = 65536,
                Request = 95104,
                RequestHeaders = 90112,
                ServerIpAddress = 32,
                ServerName = 16,
                ServerPort = 64,
                Time = 2,
                TimeTaken = 2048,
                UriQuery = 512,
                UriStem = 256,
                UserAgent = 16384,
                UserName = 8,
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static class HttpLoggingServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHttpLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpLogging.HttpLoggingOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddW3CLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpLogging.W3CLoggerOptions> configureOptions) => throw null;
            }

        }
    }
}
