// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Server.Kestrel.Core, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            public static partial class KestrelServerOptionsSystemdExtensions
            {
                public static Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions UseSystemd(this Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions options) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions UseSystemd(this Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions options, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
            }
            public static partial class ListenOptionsConnectionLoggingExtensions
            {
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseConnectionLogging(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseConnectionLogging(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string loggerName) => throw null;
            }
            public static partial class ListenOptionsHttpsExtensions
            {
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string fileName) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string fileName, string password) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string fileName, string password, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject, bool allowInvalid) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject, bool allowInvalid, System.Security.Cryptography.X509Certificates.StoreLocation location) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject, bool allowInvalid, System.Security.Cryptography.X509Certificates.StoreLocation location, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.X509Certificate2 serverCertificate) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.X509Certificate2 serverCertificate, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions httpsOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Net.Security.ServerOptionsSelectionCallback serverOptionsSelectionCallback, object state) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Net.Security.ServerOptionsSelectionCallback serverOptionsSelectionCallback, object state, System.TimeSpan handshakeTimeout) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, Microsoft.AspNetCore.Server.Kestrel.Https.TlsHandshakeCallbackOptions callbackOptions) => throw null;
            }
        }
        namespace Server
        {
            namespace Kestrel
            {
                namespace Core
                {
                    public sealed class BadHttpRequestException : Microsoft.AspNetCore.Http.BadHttpRequestException
                    {
                        public int StatusCode { get => throw null; }
                        internal BadHttpRequestException() : base(default(string)) { }
                    }
                    namespace Features
                    {
                        public interface IConnectionTimeoutFeature
                        {
                            void CancelTimeout();
                            void ResetTimeout(System.TimeSpan timeSpan);
                            void SetTimeout(System.TimeSpan timeSpan);
                        }
                        public interface IDecrementConcurrentConnectionCountFeature
                        {
                            void ReleaseConnection();
                        }
                        public interface IHttp2StreamIdFeature
                        {
                            int StreamId { get; }
                        }
                        public interface IHttpMinRequestBodyDataRateFeature
                        {
                            Microsoft.AspNetCore.Server.Kestrel.Core.MinDataRate MinDataRate { get; set; }
                        }
                        public interface IHttpMinResponseDataRateFeature
                        {
                            Microsoft.AspNetCore.Server.Kestrel.Core.MinDataRate MinDataRate { get; set; }
                        }
                        public interface ISslStreamFeature
                        {
                            System.Net.Security.SslStream SslStream { get; }
                        }
                        public interface ITlsApplicationProtocolFeature
                        {
                            System.ReadOnlyMemory<byte> ApplicationProtocol { get; }
                        }
                    }
                    public class Http2Limits
                    {
                        public Http2Limits() => throw null;
                        public int HeaderTableSize { get => throw null; set { } }
                        public int InitialConnectionWindowSize { get => throw null; set { } }
                        public int InitialStreamWindowSize { get => throw null; set { } }
                        public System.TimeSpan KeepAlivePingDelay { get => throw null; set { } }
                        public System.TimeSpan KeepAlivePingTimeout { get => throw null; set { } }
                        public int MaxFrameSize { get => throw null; set { } }
                        public int MaxRequestHeaderFieldSize { get => throw null; set { } }
                        public int MaxStreamsPerConnection { get => throw null; set { } }
                    }
                    public class Http3Limits
                    {
                        public Http3Limits() => throw null;
                        public int MaxRequestHeaderFieldSize { get => throw null; set { } }
                    }
                    [System.Flags]
                    public enum HttpProtocols
                    {
                        None = 0,
                        Http1 = 1,
                        Http2 = 2,
                        Http1AndHttp2 = 3,
                        Http3 = 4,
                        Http1AndHttp2AndHttp3 = 7,
                    }
                    namespace Internal
                    {
                        namespace Http
                        {
                            public enum HttpMethod : byte
                            {
                                Get = 0,
                                Put = 1,
                                Delete = 2,
                                Post = 3,
                                Head = 4,
                                Trace = 5,
                                Patch = 6,
                                Connect = 7,
                                Options = 8,
                                Custom = 9,
                                None = 255,
                            }
                            public class HttpParser<TRequestHandler> where TRequestHandler : Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpHeadersHandler, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpRequestLineHandler
                            {
                                public HttpParser() => throw null;
                                public HttpParser(bool showErrorDetails) => throw null;
                                public bool ParseHeaders(TRequestHandler handler, ref System.Buffers.SequenceReader<byte> reader) => throw null;
                                public bool ParseRequestLine(TRequestHandler handler, ref System.Buffers.SequenceReader<byte> reader) => throw null;
                            }
                            public enum HttpScheme
                            {
                                Unknown = -1,
                                Http = 0,
                                Https = 1,
                            }
                            public enum HttpVersion : sbyte
                            {
                                Unknown = -1,
                                Http10 = 0,
                                Http11 = 1,
                                Http2 = 2,
                                Http3 = 3,
                            }
                            public struct HttpVersionAndMethod
                            {
                                public HttpVersionAndMethod(Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpMethod method, int methodEnd) => throw null;
                                public Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpMethod Method { get => throw null; }
                                public int MethodEnd { get => throw null; }
                                public Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpVersion Version { get => throw null; set { } }
                            }
                            public interface IHttpHeadersHandler
                            {
                                void OnHeader(System.ReadOnlySpan<byte> name, System.ReadOnlySpan<byte> value);
                                void OnHeadersComplete(bool endStream);
                                void OnStaticIndexedHeader(int index);
                                void OnStaticIndexedHeader(int index, System.ReadOnlySpan<byte> value);
                            }
                            public interface IHttpRequestLineHandler
                            {
                                void OnStartLine(Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpVersionAndMethod versionAndMethod, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.TargetOffsetPathLength targetPath, System.Span<byte> startLine);
                            }
                            public struct TargetOffsetPathLength
                            {
                                public TargetOffsetPathLength(int offset, int length, bool isEncoded) => throw null;
                                public bool IsEncoded { get => throw null; }
                                public int Length { get => throw null; }
                                public int Offset { get => throw null; }
                            }
                        }
                    }
                    public class KestrelServer : System.IDisposable, Microsoft.AspNetCore.Hosting.Server.IServer
                    {
                        public KestrelServer(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions> options, Microsoft.AspNetCore.Connections.IConnectionListenerFactory transportFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public void Dispose() => throw null;
                        public Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions Options { get => throw null; }
                        public System.Threading.Tasks.Task StartAsync<TContext>(Microsoft.AspNetCore.Hosting.Server.IHttpApplication<TContext> application, System.Threading.CancellationToken cancellationToken) => throw null;
                        public System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    }
                    public class KestrelServerLimits
                    {
                        public KestrelServerLimits() => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.Core.Http2Limits Http2 { get => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.Http3Limits Http3 { get => throw null; }
                        public System.TimeSpan KeepAliveTimeout { get => throw null; set { } }
                        public long? MaxConcurrentConnections { get => throw null; set { } }
                        public long? MaxConcurrentUpgradedConnections { get => throw null; set { } }
                        public long? MaxRequestBodySize { get => throw null; set { } }
                        public long? MaxRequestBufferSize { get => throw null; set { } }
                        public int MaxRequestHeaderCount { get => throw null; set { } }
                        public int MaxRequestHeadersTotalSize { get => throw null; set { } }
                        public int MaxRequestLineSize { get => throw null; set { } }
                        public long? MaxResponseBufferSize { get => throw null; set { } }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.MinDataRate MinRequestBodyDataRate { get => throw null; set { } }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.MinDataRate MinResponseDataRate { get => throw null; set { } }
                        public System.TimeSpan RequestHeadersTimeout { get => throw null; set { } }
                    }
                    public class KestrelServerOptions
                    {
                        public bool AddServerHeader { get => throw null; set { } }
                        public bool AllowAlternateSchemes { get => throw null; set { } }
                        public bool AllowHostHeaderOverride { get => throw null; set { } }
                        public bool AllowResponseHeaderCompression { get => throw null; set { } }
                        public bool AllowSynchronousIO { get => throw null; set { } }
                        public System.IServiceProvider ApplicationServices { get => throw null; set { } }
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader ConfigurationLoader { get => throw null; set { } }
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Configure() => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Configure(Microsoft.Extensions.Configuration.IConfiguration config) => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Configure(Microsoft.Extensions.Configuration.IConfiguration config, bool reloadOnChange) => throw null;
                        public void ConfigureEndpointDefaults(System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configureOptions) => throw null;
                        public void ConfigureHttpsDefaults(System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                        public KestrelServerOptions() => throw null;
                        public bool DisableStringReuse { get => throw null; set { } }
                        public bool EnableAltSvc { get => throw null; set { } }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerLimits Limits { get => throw null; }
                        public void Listen(System.Net.IPAddress address, int port) => throw null;
                        public void Listen(System.Net.IPAddress address, int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void Listen(System.Net.IPEndPoint endPoint) => throw null;
                        public void Listen(System.Net.EndPoint endPoint) => throw null;
                        public void Listen(System.Net.IPEndPoint endPoint, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void Listen(System.Net.EndPoint endPoint, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenAnyIP(int port) => throw null;
                        public void ListenAnyIP(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenHandle(ulong handle) => throw null;
                        public void ListenHandle(ulong handle, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenLocalhost(int port) => throw null;
                        public void ListenLocalhost(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenNamedPipe(string pipeName) => throw null;
                        public void ListenNamedPipe(string pipeName, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenUnixSocket(string socketPath) => throw null;
                        public void ListenUnixSocket(string socketPath, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public System.Func<string, System.Text.Encoding> RequestHeaderEncodingSelector { get => throw null; set { } }
                        public System.Func<string, System.Text.Encoding> ResponseHeaderEncodingSelector { get => throw null; set { } }
                    }
                    public class ListenOptions : Microsoft.AspNetCore.Connections.IConnectionBuilder, Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder
                    {
                        public System.IServiceProvider ApplicationServices { get => throw null; }
                        public Microsoft.AspNetCore.Connections.ConnectionDelegate Build() => throw null;
                        Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder.Build() => throw null;
                        protected Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions Clone(System.Net.IPAddress address) => throw null;
                        public bool DisableAltSvcHeader { get => throw null; set { } }
                        public System.Net.EndPoint EndPoint { get => throw null; }
                        public ulong FileHandle { get => throw null; }
                        public System.Net.IPEndPoint IPEndPoint { get => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions KestrelServerOptions { get => throw null; }
                        public string PipeName { get => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.HttpProtocols Protocols { get => throw null; set { } }
                        public string SocketPath { get => throw null; }
                        public override string ToString() => throw null;
                        public Microsoft.AspNetCore.Connections.IConnectionBuilder Use(System.Func<Microsoft.AspNetCore.Connections.ConnectionDelegate, Microsoft.AspNetCore.Connections.ConnectionDelegate> middleware) => throw null;
                        Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder.Use(System.Func<Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate, Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate> middleware) => throw null;
                    }
                    public class MinDataRate
                    {
                        public double BytesPerSecond { get => throw null; }
                        public MinDataRate(double bytesPerSecond, System.TimeSpan gracePeriod) => throw null;
                        public System.TimeSpan GracePeriod { get => throw null; }
                        public override string ToString() => throw null;
                    }
                }
                public class EndpointConfiguration
                {
                    public Microsoft.Extensions.Configuration.IConfigurationSection ConfigSection { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions HttpsOptions { get => throw null; }
                    public bool IsHttps { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions ListenOptions { get => throw null; }
                }
                namespace Https
                {
                    public static class CertificateLoader
                    {
                        public static System.Security.Cryptography.X509Certificates.X509Certificate2 LoadFromStoreCert(string subject, string storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation, bool allowInvalid) => throw null;
                    }
                    public enum ClientCertificateMode
                    {
                        NoCertificate = 0,
                        AllowCertificate = 1,
                        RequireCertificate = 2,
                        DelayCertificate = 3,
                    }
                    public class HttpsConnectionAdapterOptions
                    {
                        public void AllowAnyClientCertificate() => throw null;
                        public bool CheckCertificateRevocation { get => throw null; set { } }
                        public Microsoft.AspNetCore.Server.Kestrel.Https.ClientCertificateMode ClientCertificateMode { get => throw null; set { } }
                        public System.Func<System.Security.Cryptography.X509Certificates.X509Certificate2, System.Security.Cryptography.X509Certificates.X509Chain, System.Net.Security.SslPolicyErrors, bool> ClientCertificateValidation { get => throw null; set { } }
                        public HttpsConnectionAdapterOptions() => throw null;
                        public System.TimeSpan HandshakeTimeout { get => throw null; set { } }
                        public System.Action<Microsoft.AspNetCore.Connections.ConnectionContext, System.Net.Security.SslServerAuthenticationOptions> OnAuthenticate { get => throw null; set { } }
                        public System.Security.Cryptography.X509Certificates.X509Certificate2 ServerCertificate { get => throw null; set { } }
                        public System.Security.Cryptography.X509Certificates.X509Certificate2Collection ServerCertificateChain { get => throw null; set { } }
                        public System.Func<Microsoft.AspNetCore.Connections.ConnectionContext, string, System.Security.Cryptography.X509Certificates.X509Certificate2> ServerCertificateSelector { get => throw null; set { } }
                        public System.Security.Authentication.SslProtocols SslProtocols { get => throw null; set { } }
                    }
                    public class TlsHandshakeCallbackContext
                    {
                        public bool AllowDelayedClientCertificateNegotation { get => throw null; set { } }
                        public System.Threading.CancellationToken CancellationToken { get => throw null; }
                        public System.Net.Security.SslClientHelloInfo ClientHelloInfo { get => throw null; }
                        public Microsoft.AspNetCore.Connections.ConnectionContext Connection { get => throw null; }
                        public TlsHandshakeCallbackContext() => throw null;
                        public System.Net.Security.SslStream SslStream { get => throw null; }
                        public object State { get => throw null; }
                    }
                    public class TlsHandshakeCallbackOptions
                    {
                        public TlsHandshakeCallbackOptions() => throw null;
                        public System.TimeSpan HandshakeTimeout { get => throw null; set { } }
                        public System.Func<Microsoft.AspNetCore.Server.Kestrel.Https.TlsHandshakeCallbackContext, System.Threading.Tasks.ValueTask<System.Net.Security.SslServerAuthenticationOptions>> OnConnection { get => throw null; set { } }
                        public object OnConnectionState { get => throw null; set { } }
                    }
                }
                public class KestrelConfigurationLoader
                {
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader AnyIPEndpoint(int port) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader AnyIPEndpoint(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(string name, System.Action<Microsoft.AspNetCore.Server.Kestrel.EndpointConfiguration> configureOptions) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPAddress address, int port) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPAddress address, int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPEndPoint endPoint) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPEndPoint endPoint, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader HandleEndpoint(ulong handle) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader HandleEndpoint(ulong handle, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public void Load() => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader LocalhostEndpoint(int port) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader LocalhostEndpoint(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions Options { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader UnixSocketEndpoint(string socketPath) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader UnixSocketEndpoint(string socketPath, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                }
            }
        }
    }
}
