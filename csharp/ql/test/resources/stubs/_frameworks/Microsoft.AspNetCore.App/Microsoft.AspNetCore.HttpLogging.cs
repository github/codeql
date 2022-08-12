// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            // Generated from `Microsoft.AspNetCore.Builder.HttpLoggingBuilderExtensions` in `Microsoft.AspNetCore.HttpLogging, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpLoggingBuilderExtensions
            {
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseHttpLogging(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
                public static Microsoft.AspNetCore.Builder.IApplicationBuilder UseW3CLogging(this Microsoft.AspNetCore.Builder.IApplicationBuilder app) => throw null;
            }

        }
        namespace HttpLogging
        {
            // Generated from `Microsoft.AspNetCore.HttpLogging.HttpLoggingFields` in `Microsoft.AspNetCore.HttpLogging, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            [System.Flags]
            public enum HttpLoggingFields
            {
                All,
                None,
                Request,
                RequestBody,
                RequestHeaders,
                RequestMethod,
                RequestPath,
                RequestProperties,
                RequestPropertiesAndHeaders,
                RequestProtocol,
                RequestQuery,
                RequestScheme,
                RequestTrailers,
                Response,
                ResponseBody,
                ResponseHeaders,
                ResponsePropertiesAndHeaders,
                ResponseStatusCode,
                ResponseTrailers,
            }

            // Generated from `Microsoft.AspNetCore.HttpLogging.HttpLoggingOptions` in `Microsoft.AspNetCore.HttpLogging, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

            // Generated from `Microsoft.AspNetCore.HttpLogging.MediaTypeOptions` in `Microsoft.AspNetCore.HttpLogging, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class MediaTypeOptions
            {
                public void AddBinary(Microsoft.Net.Http.Headers.MediaTypeHeaderValue mediaType) => throw null;
                public void AddBinary(string contentType) => throw null;
                public void AddText(string contentType) => throw null;
                public void AddText(string contentType, System.Text.Encoding encoding) => throw null;
                public void Clear() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.HttpLogging.W3CLoggerOptions` in `Microsoft.AspNetCore.HttpLogging, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class W3CLoggerOptions
            {
                public string FileName { get => throw null; set => throw null; }
                public int? FileSizeLimit { get => throw null; set => throw null; }
                public System.TimeSpan FlushInterval { get => throw null; set => throw null; }
                public string LogDirectory { get => throw null; set => throw null; }
                public Microsoft.AspNetCore.HttpLogging.W3CLoggingFields LoggingFields { get => throw null; set => throw null; }
                public int? RetainedFileCountLimit { get => throw null; set => throw null; }
                public W3CLoggerOptions() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.HttpLogging.W3CLoggingFields` in `Microsoft.AspNetCore.HttpLogging, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            [System.Flags]
            public enum W3CLoggingFields
            {
                All,
                ClientIpAddress,
                ConnectionInfoFields,
                Cookie,
                Date,
                Host,
                Method,
                None,
                ProtocolStatus,
                ProtocolVersion,
                Referer,
                Request,
                RequestHeaders,
                ServerIpAddress,
                ServerName,
                ServerPort,
                Time,
                TimeTaken,
                UriQuery,
                UriStem,
                UserAgent,
                UserName,
            }

        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            // Generated from `Microsoft.Extensions.DependencyInjection.HttpLoggingServicesExtensions` in `Microsoft.AspNetCore.HttpLogging, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class HttpLoggingServicesExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHttpLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpLogging.HttpLoggingOptions> configureOptions) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddW3CLogging(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.AspNetCore.HttpLogging.W3CLoggerOptions> configureOptions) => throw null;
            }

        }
    }
}
