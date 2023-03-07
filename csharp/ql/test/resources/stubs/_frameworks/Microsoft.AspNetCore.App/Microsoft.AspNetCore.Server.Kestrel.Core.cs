// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Server.Kestrel.Core, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            public static class KestrelServerOptionsSystemdExtensions
            {
                public static Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions UseSystemd(this Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions options) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions UseSystemd(this Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions options, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
            }

            public static class ListenOptionsConnectionLoggingExtensions
            {
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseConnectionLogging(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseConnectionLogging(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string loggerName) => throw null;
            }

            public static class ListenOptionsHttpsExtensions
            {
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions httpsOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Net.Security.ServerOptionsSelectionCallback serverOptionsSelectionCallback, object state) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Net.Security.ServerOptionsSelectionCallback serverOptionsSelectionCallback, object state, System.TimeSpan handshakeTimeout) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject, bool allowInvalid) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject, bool allowInvalid, System.Security.Cryptography.X509Certificates.StoreLocation location) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject, bool allowInvalid, System.Security.Cryptography.X509Certificates.StoreLocation location, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, Microsoft.AspNetCore.Server.Kestrel.Https.TlsHandshakeCallbackOptions callbackOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.X509Certificate2 serverCertificate) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.X509Certificate2 serverCertificate, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string fileName) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string fileName, string password) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string fileName, string password, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
            }

        }
        namespace Server
        {
            namespace Kestrel
            {
                public class EndpointConfiguration
                {
                    public Microsoft.Extensions.Configuration.IConfigurationSection ConfigSection { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions HttpsOptions { get => throw null; }
                    public bool IsHttps { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions ListenOptions { get => throw null; }
                }

                public class KestrelConfigurationLoader
                {
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader AnyIPEndpoint(int port) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader AnyIPEndpoint(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPAddress address, int port) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPAddress address, int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPEndPoint endPoint) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPEndPoint endPoint, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(string name, System.Action<Microsoft.AspNetCore.Server.Kestrel.EndpointConfiguration> configureOptions) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader HandleEndpoint(System.UInt64 handle) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader HandleEndpoint(System.UInt64 handle, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public void Load() => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader LocalhostEndpoint(int port) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader LocalhostEndpoint(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions Options { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader UnixSocketEndpoint(string socketPath) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader UnixSocketEndpoint(string socketPath, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                }

                namespace Core
                {
                    public class BadHttpRequestException : Microsoft.AspNetCore.Http.BadHttpRequestException
                    {
                        internal BadHttpRequestException(string message, int statusCode, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.RequestRejectionReason reason) : base(default(string)) => throw null;
                        internal BadHttpRequestException(string message, int statusCode, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.RequestRejectionReason reason, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpMethod? requiredMethod) : base(default(string)) => throw null;
                        public int StatusCode { get => throw null; }
                    }

                    public class Http2Limits
                    {
                        public int HeaderTableSize { get => throw null; set => throw null; }
                        public Http2Limits() => throw null;
                        public int InitialConnectionWindowSize { get => throw null; set => throw null; }
                        public int InitialStreamWindowSize { get => throw null; set => throw null; }
                        public System.TimeSpan KeepAlivePingDelay { get => throw null; set => throw null; }
                        public System.TimeSpan KeepAlivePingTimeout { get => throw null; set => throw null; }
                        public int MaxFrameSize { get => throw null; set => throw null; }
                        public int MaxRequestHeaderFieldSize { get => throw null; set => throw null; }
                        public int MaxStreamsPerConnection { get => throw null; set => throw null; }
                    }

                    public class Http3Limits
                    {
                        public Http3Limits() => throw null;
                        public int MaxRequestHeaderFieldSize { get => throw null; set => throw null; }
                    }

                    [System.Flags]
                    public enum HttpProtocols : int
                    {
                        Http1 = 1,
                        Http1AndHttp2 = 3,
                        Http1AndHttp2AndHttp3 = 7,
                        Http2 = 2,
                        Http3 = 4,
                        None = 0,
                    }

                    public class KestrelServer : Microsoft.AspNetCore.Hosting.Server.IServer, System.IDisposable
                    {
                        public void Dispose() => throw null;
                        public Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get => throw null; }
                        public KestrelServer(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions> options, Microsoft.AspNetCore.Connections.IConnectionListenerFactory transportFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions Options { get => throw null; }
                        public System.Threading.Tasks.Task StartAsync<TContext>(Microsoft.AspNetCore.Hosting.Server.IHttpApplication<TContext> application, System.Threading.CancellationToken cancellationToken) => throw null;
                        public System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    }

                    public class KestrelServerLimits
                    {
                        public Microsoft.AspNetCore.Server.Kestrel.Core.Http2Limits Http2 { get => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.Http3Limits Http3 { get => throw null; }
                        public System.TimeSpan KeepAliveTimeout { get => throw null; set => throw null; }
                        public KestrelServerLimits() => throw null;
                        public System.Int64? MaxConcurrentConnections { get => throw null; set => throw null; }
                        public System.Int64? MaxConcurrentUpgradedConnections { get => throw null; set => throw null; }
                        public System.Int64? MaxRequestBodySize { get => throw null; set => throw null; }
                        public System.Int64? MaxRequestBufferSize { get => throw null; set => throw null; }
                        public int MaxRequestHeaderCount { get => throw null; set => throw null; }
                        public int MaxRequestHeadersTotalSize { get => throw null; set => throw null; }
                        public int MaxRequestLineSize { get => throw null; set => throw null; }
                        public System.Int64? MaxResponseBufferSize { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.MinDataRate MinRequestBodyDataRate { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.MinDataRate MinResponseDataRate { get => throw null; set => throw null; }
                        public System.TimeSpan RequestHeadersTimeout { get => throw null; set => throw null; }
                    }

                    public class KestrelServerOptions
                    {
                        public bool AddServerHeader { get => throw null; set => throw null; }
                        public bool AllowAlternateSchemes { get => throw null; set => throw null; }
                        public bool AllowResponseHeaderCompression { get => throw null; set => throw null; }
                        public bool AllowSynchronousIO { get => throw null; set => throw null; }
                        public System.IServiceProvider ApplicationServices { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader ConfigurationLoader { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Configure() => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Configure(Microsoft.Extensions.Configuration.IConfiguration config) => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Configure(Microsoft.Extensions.Configuration.IConfiguration config, bool reloadOnChange) => throw null;
                        public void ConfigureEndpointDefaults(System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configureOptions) => throw null;
                        public void ConfigureHttpsDefaults(System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                        public bool DisableStringReuse { get => throw null; set => throw null; }
                        public bool EnableAltSvc { get => throw null; set => throw null; }
                        public KestrelServerOptions() => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerLimits Limits { get => throw null; }
                        public void Listen(System.Net.EndPoint endPoint) => throw null;
                        public void Listen(System.Net.EndPoint endPoint, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void Listen(System.Net.IPAddress address, int port) => throw null;
                        public void Listen(System.Net.IPAddress address, int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void Listen(System.Net.IPEndPoint endPoint) => throw null;
                        public void Listen(System.Net.IPEndPoint endPoint, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenAnyIP(int port) => throw null;
                        public void ListenAnyIP(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenHandle(System.UInt64 handle) => throw null;
                        public void ListenHandle(System.UInt64 handle, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenLocalhost(int port) => throw null;
                        public void ListenLocalhost(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenUnixSocket(string socketPath) => throw null;
                        public void ListenUnixSocket(string socketPath, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public System.Func<string, System.Text.Encoding> RequestHeaderEncodingSelector { get => throw null; set => throw null; }
                        public System.Func<string, System.Text.Encoding> ResponseHeaderEncodingSelector { get => throw null; set => throw null; }
                    }

                    public class ListenOptions : Microsoft.AspNetCore.Connections.IConnectionBuilder, Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder
                    {
                        public System.IServiceProvider ApplicationServices { get => throw null; }
                        public Microsoft.AspNetCore.Connections.ConnectionDelegate Build() => throw null;
                        Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder.Build() => throw null;
                        public bool DisableAltSvcHeader { get => throw null; set => throw null; }
                        public System.Net.EndPoint EndPoint { get => throw null; set => throw null; }
                        public System.UInt64 FileHandle { get => throw null; }
                        public System.Net.IPEndPoint IPEndPoint { get => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions KestrelServerOptions { get => throw null; set => throw null; }
                        internal ListenOptions(System.Net.EndPoint endPoint) => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.Core.HttpProtocols Protocols { get => throw null; set => throw null; }
                        public string SocketPath { get => throw null; }
                        public override string ToString() => throw null;
                        public Microsoft.AspNetCore.Connections.IConnectionBuilder Use(System.Func<Microsoft.AspNetCore.Connections.ConnectionDelegate, Microsoft.AspNetCore.Connections.ConnectionDelegate> middleware) => throw null;
                        Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder Microsoft.AspNetCore.Connections.IMultiplexedConnectionBuilder.Use(System.Func<Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate, Microsoft.AspNetCore.Connections.MultiplexedConnectionDelegate> middleware) => throw null;
                    }

                    public class MinDataRate
                    {
                        public double BytesPerSecond { get => throw null; }
                        public System.TimeSpan GracePeriod { get => throw null; }
                        public MinDataRate(double bytesPerSecond, System.TimeSpan gracePeriod) => throw null;
                        public override string ToString() => throw null;
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

                        public interface ITlsApplicationProtocolFeature
                        {
                            System.ReadOnlyMemory<System.Byte> ApplicationProtocol { get; }
                        }

                    }
                    namespace Internal
                    {
                        namespace Http
                        {
                            public enum HttpMethod : byte
                            {
                                Connect = 7,
                                Custom = 9,
                                Delete = 2,
                                Get = 0,
                                Head = 4,
                                None = 255,
                                Options = 8,
                                Patch = 6,
                                Post = 3,
                                Put = 1,
                                Trace = 5,
                            }

                            public class HttpParser<TRequestHandler> where TRequestHandler : Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpHeadersHandler, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpRequestLineHandler
                            {
                                public HttpParser() => throw null;
                                public HttpParser(bool showErrorDetails) => throw null;
                                public bool ParseHeaders(TRequestHandler handler, ref System.Buffers.SequenceReader<System.Byte> reader) => throw null;
                                public bool ParseRequestLine(TRequestHandler handler, ref System.Buffers.SequenceReader<System.Byte> reader) => throw null;
                            }

                            public enum HttpScheme : int
                            {
                                Http = 0,
                                Https = 1,
                                Unknown = -1,
                            }

                            public enum HttpVersion : sbyte
                            {
                                Http10 = 0,
                                Http11 = 1,
                                Http2 = 2,
                                Http3 = 3,
                                Unknown = -1,
                            }

                            public struct HttpVersionAndMethod
                            {
                                // Stub generator skipped constructor 
                                public HttpVersionAndMethod(Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpMethod method, int methodEnd) => throw null;
                                public Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpMethod Method { get => throw null; }
                                public int MethodEnd { get => throw null; }
                                public Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpVersion Version { get => throw null; set => throw null; }
                            }

                            public interface IHttpHeadersHandler
                            {
                                void OnHeader(System.ReadOnlySpan<System.Byte> name, System.ReadOnlySpan<System.Byte> value);
                                void OnHeadersComplete(bool endStream);
                                void OnStaticIndexedHeader(int index);
                                void OnStaticIndexedHeader(int index, System.ReadOnlySpan<System.Byte> value);
                            }

                            internal interface IHttpParser<TRequestHandler> where TRequestHandler : Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpHeadersHandler, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpRequestLineHandler
                            {
                            }

                            public interface IHttpRequestLineHandler
                            {
                                void OnStartLine(Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpVersionAndMethod versionAndMethod, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.TargetOffsetPathLength targetPath, System.Span<System.Byte> startLine);
                            }

                            internal enum RequestRejectionReason : int
                            {
                            }

                            public struct TargetOffsetPathLength
                            {
                                public bool IsEncoded { get => throw null; }
                                public int Length { get => throw null; }
                                public int Offset { get => throw null; }
                                // Stub generator skipped constructor 
                                public TargetOffsetPathLength(int offset, int length, bool isEncoded) => throw null;
                            }

                        }
                    }
                }
                namespace Https
                {
                    public static class CertificateLoader
                    {
                        public static System.Security.Cryptography.X509Certificates.X509Certificate2 LoadFromStoreCert(string subject, string storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation, bool allowInvalid) => throw null;
                    }

                    public enum ClientCertificateMode : int
                    {
                        AllowCertificate = 1,
                        DelayCertificate = 3,
                        NoCertificate = 0,
                        RequireCertificate = 2,
                    }

                    public class HttpsConnectionAdapterOptions
                    {
                        public void AllowAnyClientCertificate() => throw null;
                        public bool CheckCertificateRevocation { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Https.ClientCertificateMode ClientCertificateMode { get => throw null; set => throw null; }
                        public System.Func<System.Security.Cryptography.X509Certificates.X509Certificate2, System.Security.Cryptography.X509Certificates.X509Chain, System.Net.Security.SslPolicyErrors, bool> ClientCertificateValidation { get => throw null; set => throw null; }
                        public System.TimeSpan HandshakeTimeout { get => throw null; set => throw null; }
                        public HttpsConnectionAdapterOptions() => throw null;
                        public System.Action<Microsoft.AspNetCore.Connections.ConnectionContext, System.Net.Security.SslServerAuthenticationOptions> OnAuthenticate { get => throw null; set => throw null; }
                        public System.Security.Cryptography.X509Certificates.X509Certificate2 ServerCertificate { get => throw null; set => throw null; }
                        public System.Security.Cryptography.X509Certificates.X509Certificate2Collection ServerCertificateChain { get => throw null; set => throw null; }
                        public System.Func<Microsoft.AspNetCore.Connections.ConnectionContext, string, System.Security.Cryptography.X509Certificates.X509Certificate2> ServerCertificateSelector { get => throw null; set => throw null; }
                        public System.Security.Authentication.SslProtocols SslProtocols { get => throw null; set => throw null; }
                    }

                    public class TlsHandshakeCallbackContext
                    {
                        public bool AllowDelayedClientCertificateNegotation { get => throw null; set => throw null; }
                        public System.Threading.CancellationToken CancellationToken { get => throw null; set => throw null; }
                        public System.Net.Security.SslClientHelloInfo ClientHelloInfo { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Connections.ConnectionContext Connection { get => throw null; set => throw null; }
                        public System.Net.Security.SslStream SslStream { get => throw null; set => throw null; }
                        public object State { get => throw null; set => throw null; }
                        public TlsHandshakeCallbackContext() => throw null;
                    }

                    public class TlsHandshakeCallbackOptions
                    {
                        public System.TimeSpan HandshakeTimeout { get => throw null; set => throw null; }
                        public System.Func<Microsoft.AspNetCore.Server.Kestrel.Https.TlsHandshakeCallbackContext, System.Threading.Tasks.ValueTask<System.Net.Security.SslServerAuthenticationOptions>> OnConnection { get => throw null; set => throw null; }
                        public object OnConnectionState { get => throw null; set => throw null; }
                        public TlsHandshakeCallbackOptions() => throw null;
                    }

                }
            }
        }
    }
}
