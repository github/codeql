// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Hosting
        {
            // Generated from `Microsoft.AspNetCore.Hosting.KestrelServerOptionsSystemdExtensions` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class KestrelServerOptionsSystemdExtensions
            {
                public static Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions UseSystemd(this Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions options, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions UseSystemd(this Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions options) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Hosting.ListenOptionsConnectionLoggingExtensions` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ListenOptionsConnectionLoggingExtensions
            {
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseConnectionLogging(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string loggerName) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseConnectionLogging(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Hosting.ListenOptionsHttpsExtensions` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class ListenOptionsHttpsExtensions
            {
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string fileName, string password, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string fileName, string password) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, string fileName) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.X509Certificate2 serverCertificate, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.X509Certificate2 serverCertificate) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject, bool allowInvalid, System.Security.Cryptography.X509Certificates.StoreLocation location, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject, bool allowInvalid, System.Security.Cryptography.X509Certificates.StoreLocation location) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject, bool allowInvalid) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Security.Cryptography.X509Certificates.StoreName storeName, string subject) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Net.Security.ServerOptionsSelectionCallback serverOptionsSelectionCallback, object state, System.TimeSpan handshakeTimeout) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Net.Security.ServerOptionsSelectionCallback serverOptionsSelectionCallback, object state) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions, Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions httpsOptions) => throw null;
                public static Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions UseHttps(this Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions listenOptions) => throw null;
            }

        }
        namespace Server
        {
            namespace Kestrel
            {
                // Generated from `Microsoft.AspNetCore.Server.Kestrel.EndpointConfiguration` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class EndpointConfiguration
                {
                    public Microsoft.Extensions.Configuration.IConfigurationSection ConfigSection { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions HttpsOptions { get => throw null; }
                    public bool IsHttps { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions ListenOptions { get => throw null; }
                }

                // Generated from `Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public class KestrelConfigurationLoader
                {
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader AnyIPEndpoint(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader AnyIPEndpoint(int port) => throw null;
                    public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; set => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(string name, System.Action<Microsoft.AspNetCore.Server.Kestrel.EndpointConfiguration> configureOptions) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPEndPoint endPoint, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPEndPoint endPoint) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPAddress address, int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Endpoint(System.Net.IPAddress address, int port) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader HandleEndpoint(System.UInt64 handle, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader HandleEndpoint(System.UInt64 handle) => throw null;
                    public void Load() => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader LocalhostEndpoint(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader LocalhostEndpoint(int port) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions Options { get => throw null; }
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader UnixSocketEndpoint(string socketPath, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                    public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader UnixSocketEndpoint(string socketPath) => throw null;
                }

                namespace Core
                {
                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.BadHttpRequestException` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class BadHttpRequestException : Microsoft.AspNetCore.Http.BadHttpRequestException
                    {
                        internal BadHttpRequestException(string message, int statusCode, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.RequestRejectionReason reason, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpMethod? requiredMethod) : base(default(string)) => throw null;
                        internal BadHttpRequestException(string message, int statusCode, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.RequestRejectionReason reason) : base(default(string)) => throw null;
                        public int StatusCode { get => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Http2Limits` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Http3Limits` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class Http3Limits
                    {
                        public int HeaderTableSize { get => throw null; set => throw null; }
                        public Http3Limits() => throw null;
                        public int MaxRequestHeaderFieldSize { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.HttpProtocols` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    [System.Flags]
                    public enum HttpProtocols
                    {
                        Http1,
                        Http1AndHttp2,
                        Http1AndHttp2AndHttp3,
                        Http2,
                        Http3,
                        None,
                    }

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServer` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class KestrelServer : System.IDisposable, Microsoft.AspNetCore.Hosting.Server.IServer
                    {
                        public void Dispose() => throw null;
                        public Microsoft.AspNetCore.Http.Features.IFeatureCollection Features { get => throw null; }
                        public KestrelServer(Microsoft.Extensions.Options.IOptions<Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions> options, Microsoft.AspNetCore.Connections.IConnectionListenerFactory transportFactory, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions Options { get => throw null; }
                        public System.Threading.Tasks.Task StartAsync<TContext>(Microsoft.AspNetCore.Hosting.Server.IHttpApplication<TContext> application, System.Threading.CancellationToken cancellationToken) => throw null;
                        public System.Threading.Tasks.Task StopAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerLimits` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class KestrelServerOptions
                    {
                        public bool AddServerHeader { get => throw null; set => throw null; }
                        public bool AllowResponseHeaderCompression { get => throw null; set => throw null; }
                        public bool AllowSynchronousIO { get => throw null; set => throw null; }
                        public System.IServiceProvider ApplicationServices { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader ConfigurationLoader { get => throw null; set => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Configure(Microsoft.Extensions.Configuration.IConfiguration config, bool reloadOnChange) => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Configure(Microsoft.Extensions.Configuration.IConfiguration config) => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.KestrelConfigurationLoader Configure() => throw null;
                        public void ConfigureEndpointDefaults(System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configureOptions) => throw null;
                        public void ConfigureHttpsDefaults(System.Action<Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions> configureOptions) => throw null;
                        public bool DisableStringReuse { get => throw null; set => throw null; }
                        public bool EnableAltSvc { get => throw null; set => throw null; }
                        public KestrelServerOptions() => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerLimits Limits { get => throw null; }
                        public void Listen(System.Net.IPEndPoint endPoint, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void Listen(System.Net.IPEndPoint endPoint) => throw null;
                        public void Listen(System.Net.IPAddress address, int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void Listen(System.Net.IPAddress address, int port) => throw null;
                        public void Listen(System.Net.EndPoint endPoint, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void Listen(System.Net.EndPoint endPoint) => throw null;
                        public void ListenAnyIP(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenAnyIP(int port) => throw null;
                        public void ListenHandle(System.UInt64 handle, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenHandle(System.UInt64 handle) => throw null;
                        public void ListenLocalhost(int port, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenLocalhost(int port) => throw null;
                        public void ListenUnixSocket(string socketPath, System.Action<Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions> configure) => throw null;
                        public void ListenUnixSocket(string socketPath) => throw null;
                        public System.Func<string, System.Text.Encoding> RequestHeaderEncodingSelector { get => throw null; set => throw null; }
                    }

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.ListenOptions` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class ListenOptions : Microsoft.AspNetCore.Connections.IConnectionBuilder
                    {
                        public System.IServiceProvider ApplicationServices { get => throw null; }
                        public Microsoft.AspNetCore.Connections.ConnectionDelegate Build() => throw null;
                        public System.Net.EndPoint EndPoint { get => throw null; set => throw null; }
                        public System.UInt64 FileHandle { get => throw null; }
                        public System.Net.IPEndPoint IPEndPoint { get => throw null; }
                        public Microsoft.AspNetCore.Server.Kestrel.Core.KestrelServerOptions KestrelServerOptions { get => throw null; set => throw null; }
                        internal ListenOptions(System.Net.EndPoint endPoint) => throw null;
                        public Microsoft.AspNetCore.Server.Kestrel.Core.HttpProtocols Protocols { get => throw null; set => throw null; }
                        public string SocketPath { get => throw null; }
                        public override string ToString() => throw null;
                        public Microsoft.AspNetCore.Connections.IConnectionBuilder Use(System.Func<Microsoft.AspNetCore.Connections.ConnectionDelegate, Microsoft.AspNetCore.Connections.ConnectionDelegate> middleware) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.MinDataRate` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public class MinDataRate
                    {
                        public double BytesPerSecond { get => throw null; }
                        public System.TimeSpan GracePeriod { get => throw null; }
                        public MinDataRate(double bytesPerSecond, System.TimeSpan gracePeriod) => throw null;
                    }

                    namespace Features
                    {
                        // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Features.IConnectionTimeoutFeature` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        public interface IConnectionTimeoutFeature
                        {
                            void CancelTimeout();
                            void ResetTimeout(System.TimeSpan timeSpan);
                            void SetTimeout(System.TimeSpan timeSpan);
                        }

                        // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Features.IDecrementConcurrentConnectionCountFeature` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        public interface IDecrementConcurrentConnectionCountFeature
                        {
                            void ReleaseConnection();
                        }

                        // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Features.IHttp2StreamIdFeature` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        public interface IHttp2StreamIdFeature
                        {
                            int StreamId { get; }
                        }

                        // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Features.IHttpMinRequestBodyDataRateFeature` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        public interface IHttpMinRequestBodyDataRateFeature
                        {
                            Microsoft.AspNetCore.Server.Kestrel.Core.MinDataRate MinDataRate { get; set; }
                        }

                        // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Features.IHttpMinResponseDataRateFeature` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        public interface IHttpMinResponseDataRateFeature
                        {
                            Microsoft.AspNetCore.Server.Kestrel.Core.MinDataRate MinDataRate { get; set; }
                        }

                        // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Features.ITlsApplicationProtocolFeature` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                        public interface ITlsApplicationProtocolFeature
                        {
                            System.ReadOnlyMemory<System.Byte> ApplicationProtocol { get; }
                        }

                    }
                    namespace Internal
                    {
                        namespace Http
                        {
                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpMethod` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            public enum HttpMethod
                            {
                                Connect,
                                Custom,
                                Delete,
                                Get,
                                Head,
                                None,
                                Options,
                                Patch,
                                Post,
                                Put,
                                Trace,
                            }

                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpParser<>` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            public class HttpParser<TRequestHandler> where TRequestHandler : Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpRequestLineHandler, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpHeadersHandler
                            {
                                public HttpParser(bool showErrorDetails) => throw null;
                                public HttpParser() => throw null;
                                public bool ParseHeaders(TRequestHandler handler, ref System.Buffers.SequenceReader<System.Byte> reader) => throw null;
                                public bool ParseRequestLine(TRequestHandler handler, ref System.Buffers.SequenceReader<System.Byte> reader) => throw null;
                            }

                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpScheme` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            public enum HttpScheme
                            {
                                Http,
                                Https,
                                Unknown,
                            }

                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpVersion` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            public enum HttpVersion
                            {
                                Http10,
                                Http11,
                                Http2,
                                Http3,
                                Unknown,
                            }

                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpVersionAndMethod` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            public struct HttpVersionAndMethod
                            {
                                public HttpVersionAndMethod(Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpMethod method, int methodEnd) => throw null;
                                // Stub generator skipped constructor 
                                public Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpMethod Method { get => throw null; }
                                public int MethodEnd { get => throw null; }
                                public Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpVersion Version { get => throw null; set => throw null; }
                            }

                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpHeadersHandler` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            public interface IHttpHeadersHandler
                            {
                                void OnHeader(System.ReadOnlySpan<System.Byte> name, System.ReadOnlySpan<System.Byte> value);
                                void OnHeadersComplete(bool endStream);
                                void OnStaticIndexedHeader(int index, System.ReadOnlySpan<System.Byte> value);
                                void OnStaticIndexedHeader(int index);
                            }

                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpParser<>` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            internal interface IHttpParser<TRequestHandler> where TRequestHandler : Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpRequestLineHandler, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpHeadersHandler
                            {
                            }

                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.IHttpRequestLineHandler` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            public interface IHttpRequestLineHandler
                            {
                                void OnStartLine(Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.HttpVersionAndMethod versionAndMethod, Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.TargetOffsetPathLength targetPath, System.Span<System.Byte> startLine);
                            }

                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.RequestRejectionReason` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            internal enum RequestRejectionReason
                            {
                            }

                            // Generated from `Microsoft.AspNetCore.Server.Kestrel.Core.Internal.Http.TargetOffsetPathLength` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                            public struct TargetOffsetPathLength
                            {
                                public bool IsEncoded { get => throw null; }
                                public int Length { get => throw null; }
                                public int Offset { get => throw null; }
                                public TargetOffsetPathLength(int offset, int length, bool isEncoded) => throw null;
                                // Stub generator skipped constructor 
                            }

                        }
                    }
                }
                namespace Https
                {
                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Https.CertificateLoader` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public static class CertificateLoader
                    {
                        public static System.Security.Cryptography.X509Certificates.X509Certificate2 LoadFromStoreCert(string subject, string storeName, System.Security.Cryptography.X509Certificates.StoreLocation storeLocation, bool allowInvalid) => throw null;
                    }

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Https.ClientCertificateMode` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                    public enum ClientCertificateMode
                    {
                        AllowCertificate,
                        NoCertificate,
                        RequireCertificate,
                    }

                    // Generated from `Microsoft.AspNetCore.Server.Kestrel.Https.HttpsConnectionAdapterOptions` in `Microsoft.AspNetCore.Server.Kestrel.Core, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
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
                        public System.Func<Microsoft.AspNetCore.Connections.ConnectionContext, string, System.Security.Cryptography.X509Certificates.X509Certificate2> ServerCertificateSelector { get => throw null; set => throw null; }
                        public System.Security.Authentication.SslProtocols SslProtocols { get => throw null; set => throw null; }
                    }

                }
            }
        }
    }
}
