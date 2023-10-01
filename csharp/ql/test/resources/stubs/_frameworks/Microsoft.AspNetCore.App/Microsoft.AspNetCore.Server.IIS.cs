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
                namespace Core
                {
                    public class IISServerAuthenticationHandler : Microsoft.AspNetCore.Authentication.IAuthenticationHandler
                    {
                        public System.Threading.Tasks.Task<Microsoft.AspNetCore.Authentication.AuthenticateResult> AuthenticateAsync() => throw null;
                        public System.Threading.Tasks.Task ChallengeAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                        public IISServerAuthenticationHandler() => throw null;
                        public System.Threading.Tasks.Task ForbidAsync(Microsoft.AspNetCore.Authentication.AuthenticationProperties properties) => throw null;
                        public System.Threading.Tasks.Task InitializeAsync(Microsoft.AspNetCore.Authentication.AuthenticationScheme scheme, Microsoft.AspNetCore.Http.HttpContext context) => throw null;
                    }
                    public class ThrowingWasUpgradedWriteOnlyStream : Microsoft.AspNetCore.Server.IIS.Core.WriteOnlyStream
                    {
                        public ThrowingWasUpgradedWriteOnlyStream() => throw null;
                        public override void Flush() => throw null;
                        public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                        public override void SetLength(long value) => throw null;
                        public override void Write(byte[] buffer, int offset, int count) => throw null;
                        public override System.Threading.Tasks.Task WriteAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                    }
                    public abstract class WriteOnlyStream : System.IO.Stream
                    {
                        public override bool CanRead { get => throw null; }
                        public override bool CanSeek { get => throw null; }
                        public override bool CanWrite { get => throw null; }
                        protected WriteOnlyStream() => throw null;
                        public override long Length { get => throw null; }
                        public override long Position { get => throw null; set { } }
                        public override int Read(byte[] buffer, int offset, int count) => throw null;
                        public override System.Threading.Tasks.Task<int> ReadAsync(byte[] buffer, int offset, int count, System.Threading.CancellationToken cancellationToken) => throw null;
                        public override System.Threading.Tasks.ValueTask<int> ReadAsync(System.Memory<byte> buffer, System.Threading.CancellationToken cancellationToken) => throw null;
                        public override int ReadTimeout { get => throw null; set { } }
                        public override long Seek(long offset, System.IO.SeekOrigin origin) => throw null;
                        public override void SetLength(long value) => throw null;
                    }
                }
                public static partial class HttpContextExtensions
                {
                    public static string GetIISServerVariable(this Microsoft.AspNetCore.Http.HttpContext context, string variableName) => throw null;
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
