// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Server.IIS, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Builder
        {
            public class IISServerOptions
            {
                public bool AllowSynchronousIO { get => throw null; set => throw null; }
                public string AuthenticationDisplayName { get => throw null; set => throw null; }
                public bool AutomaticAuthentication { get => throw null; set => throw null; }
                public IISServerOptions() => throw null;
                public int MaxRequestBodyBufferSize { get => throw null; set => throw null; }
                public System.Int64? MaxRequestBodySize { get => throw null; set => throw null; }
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
                public class BadHttpRequestException : Microsoft.AspNetCore.Http.BadHttpRequestException
                {
                    internal BadHttpRequestException(string message, int statusCode, Microsoft.AspNetCore.Server.IIS.RequestRejectionReason reason) : base(default(string)) => throw null;
                    public int StatusCode { get => throw null; }
                }

                public static class HttpContextExtensions
                {
                    public static string GetIISServerVariable(this Microsoft.AspNetCore.Http.HttpContext context, string variableName) => throw null;
                }

                public class IISServerDefaults
                {
                    public const string AuthenticationScheme = default;
                    public IISServerDefaults() => throw null;
                }

                internal enum RequestRejectionReason : int
                {
                }

                namespace Core
                {
                    public class IISServerAuthenticationHandler : Microsoft.AspNetCore.Authentication.IAuthenticationHandler
                    {
                        public System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync() => throw null;
                        public System.Threading.Tasks.Task ChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                        public System.Threading.Tasks.Task ForbidAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                        public IISServerAuthenticationHandler() => throw null;
                        public System.Threading.Tasks.Task InitializeAsync(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    }

                    public class ThrowingWasUpgradedWriteOnlyStream : Microsoft.AspNetCore.Server.IIS.Core.WriteOnlyStream
                    {
                        public override void Flush() => throw null;
                        public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                        public override void SetLength(System.Int64 value) => throw null;
                        public ThrowingWasUpgradedWriteOnlyStream() => throw null;
                        public override void Write(System.Byte[] buffer, int offset, int count) => throw null;
                        public override System.Threading.Tasks.Task WriteAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                    }

                    public abstract class WriteOnlyStream : System.IO.Stream
                    {
                        public override bool CanRead { get => throw null; }
                        public override bool CanSeek { get => throw null; }
                        public override bool CanWrite { get => throw null; }
                        public override System.Int64 Length { get => throw null; }
                        public override System.Int64 Position { get => throw null; set => throw null; }
                        public override int Read(System.Byte[] buffer, int offset, int count) => throw null;
                        public override System.Threading.Tasks.Task<int> ReadAsync(System.Byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                        public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<System.Byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                        public override int ReadTimeout { get => throw null; set => throw null; }
                        public override System.Int64 Seek(System.Int64 offset, System.IO.SeekOrigin origin) => throw null;
                        public override void SetLength(System.Int64 value) => throw null;
                        protected WriteOnlyStream() => throw null;
                    }

                }
            }
        }
    }
}
