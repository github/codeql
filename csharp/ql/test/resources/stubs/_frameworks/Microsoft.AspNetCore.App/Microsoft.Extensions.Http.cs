// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Http, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class HttpClientBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddDefaultLogger(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpMessageHandler(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Func<System.IServiceProvider, System.Net.Http.DelegatingHandler> configureHandler) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpMessageHandler(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Func<System.Net.Http.DelegatingHandler> configureHandler) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpMessageHandler<THandler>(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder) where THandler : System.Net.Http.DelegatingHandler => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddLogger(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Func<System.IServiceProvider, Microsoft.Extensions.Http.Logging.IHttpClientLogger> httpClientLoggerFactory, bool wrapHandlersPipeline = default(bool)) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddLogger<TLogger>(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, bool wrapHandlersPipeline = default(bool)) where TLogger : Microsoft.Extensions.Http.Logging.IHttpClientLogger => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddTypedClient<TClient>(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder) where TClient : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddTypedClient<TClient>(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Func<System.Net.Http.HttpClient, System.IServiceProvider, TClient> factory) where TClient : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddTypedClient<TClient>(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Func<System.Net.Http.HttpClient, TClient> factory) where TClient : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddTypedClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder ConfigureAdditionalHttpMessageHandlers(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Action<System.Collections.Generic.IList<System.Net.Http.DelegatingHandler>, System.IServiceProvider> configureAdditionalHandlers) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder ConfigureHttpClient(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Action<System.IServiceProvider, System.Net.Http.HttpClient> configureClient) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder ConfigureHttpClient(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Action<System.Net.Http.HttpClient> configureClient) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder ConfigureHttpMessageHandlerBuilder(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Action<Microsoft.Extensions.Http.HttpMessageHandlerBuilder> configureBuilder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder ConfigurePrimaryHttpMessageHandler(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Func<System.IServiceProvider, System.Net.Http.HttpMessageHandler> configureHandler) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder ConfigurePrimaryHttpMessageHandler(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Func<System.Net.Http.HttpMessageHandler> configureHandler) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder ConfigurePrimaryHttpMessageHandler<THandler>(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder) where THandler : System.Net.Http.HttpMessageHandler => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder ConfigurePrimaryHttpMessageHandler(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Action<System.Net.Http.HttpMessageHandler, System.IServiceProvider> configureHandler) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder RedactLoggedHeaders(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Collections.Generic.IEnumerable<string> redactedLoggedHeaderNames) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder RedactLoggedHeaders(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Func<string, bool> shouldRedactHeaderValue) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder RemoveAllLoggers(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder SetHandlerLifetime(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.TimeSpan handlerLifetime) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder UseSocketsHttpHandler(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Action<System.Net.Http.SocketsHttpHandler, System.IServiceProvider> configureHandler = default(System.Action<System.Net.Http.SocketsHttpHandler, System.IServiceProvider>)) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder UseSocketsHttpHandler(this Microsoft.Extensions.DependencyInjection.IHttpClientBuilder builder, System.Action<Microsoft.Extensions.DependencyInjection.ISocketsHttpHandlerBuilder> configureBuilder) => throw null;
            }
            public static partial class HttpClientFactoryServiceCollectionExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection AddHttpClient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<System.IServiceProvider, System.Net.Http.HttpClient> configureClient) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<System.Net.Http.HttpClient> configureClient) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TClient : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<System.IServiceProvider, System.Net.Http.HttpClient> configureClient) where TClient : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<System.Net.Http.HttpClient> configureClient) where TClient : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name) where TClient : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<System.IServiceProvider, System.Net.Http.HttpClient> configureClient) where TClient : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<System.Net.Http.HttpClient> configureClient) where TClient : class => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<System.IServiceProvider, System.Net.Http.HttpClient> configureClient) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<System.Net.Http.HttpClient> configureClient) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.Net.Http.HttpClient, System.IServiceProvider, TImplementation> factory) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Func<System.Net.Http.HttpClient, TImplementation> factory) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<System.IServiceProvider, System.Net.Http.HttpClient> configureClient) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Action<System.Net.Http.HttpClient> configureClient) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Func<System.Net.Http.HttpClient, System.IServiceProvider, TImplementation> factory) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddHttpClient<TClient, TImplementation>(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string name, System.Func<System.Net.Http.HttpClient, TImplementation> factory) where TClient : class where TImplementation : class, TClient => throw null;
                public static Microsoft.Extensions.DependencyInjection.IServiceCollection ConfigureHttpClientDefaults(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, System.Action<Microsoft.Extensions.DependencyInjection.IHttpClientBuilder> configure) => throw null;
            }
            public interface IHttpClientBuilder
            {
                string Name { get; }
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }
            public interface ISocketsHttpHandlerBuilder
            {
                string Name { get; }
                Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
            }
            public static partial class SocketsHttpHandlerBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.ISocketsHttpHandlerBuilder Configure(this Microsoft.Extensions.DependencyInjection.ISocketsHttpHandlerBuilder builder, System.Action<System.Net.Http.SocketsHttpHandler, System.IServiceProvider> configure) => throw null;
                public static Microsoft.Extensions.DependencyInjection.ISocketsHttpHandlerBuilder Configure(this Microsoft.Extensions.DependencyInjection.ISocketsHttpHandlerBuilder builder, Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
            }
        }
        namespace Http
        {
            public class HttpClientFactoryOptions
            {
                public HttpClientFactoryOptions() => throw null;
                public System.TimeSpan HandlerLifetime { get => throw null; set { } }
                public System.Collections.Generic.IList<System.Action<System.Net.Http.HttpClient>> HttpClientActions { get => throw null; }
                public System.Collections.Generic.IList<System.Action<Microsoft.Extensions.Http.HttpMessageHandlerBuilder>> HttpMessageHandlerBuilderActions { get => throw null; }
                public System.Func<string, bool> ShouldRedactHeaderValue { get => throw null; set { } }
                public bool SuppressHandlerScope { get => throw null; set { } }
            }
            public abstract class HttpMessageHandlerBuilder
            {
                public abstract System.Collections.Generic.IList<System.Net.Http.DelegatingHandler> AdditionalHandlers { get; }
                public abstract System.Net.Http.HttpMessageHandler Build();
                protected static System.Net.Http.HttpMessageHandler CreateHandlerPipeline(System.Net.Http.HttpMessageHandler primaryHandler, System.Collections.Generic.IEnumerable<System.Net.Http.DelegatingHandler> additionalHandlers) => throw null;
                protected HttpMessageHandlerBuilder() => throw null;
                public abstract string Name { get; set; }
                public abstract System.Net.Http.HttpMessageHandler PrimaryHandler { get; set; }
                public virtual System.IServiceProvider Services { get => throw null; }
            }
            public interface IHttpMessageHandlerBuilderFilter
            {
                System.Action<Microsoft.Extensions.Http.HttpMessageHandlerBuilder> Configure(System.Action<Microsoft.Extensions.Http.HttpMessageHandlerBuilder> next);
            }
            public interface ITypedHttpClientFactory<TClient>
            {
                TClient CreateClient(System.Net.Http.HttpClient httpClient);
            }
            namespace Logging
            {
                public interface IHttpClientAsyncLogger : Microsoft.Extensions.Http.Logging.IHttpClientLogger
                {
                    System.Threading.Tasks.ValueTask LogRequestFailedAsync(object context, System.Net.Http.HttpRequestMessage request, System.Net.Http.HttpResponseMessage response, System.Exception exception, System.TimeSpan elapsed, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    System.Threading.Tasks.ValueTask<object> LogRequestStartAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                    System.Threading.Tasks.ValueTask LogRequestStopAsync(object context, System.Net.Http.HttpRequestMessage request, System.Net.Http.HttpResponseMessage response, System.TimeSpan elapsed, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                }
                public interface IHttpClientLogger
                {
                    void LogRequestFailed(object context, System.Net.Http.HttpRequestMessage request, System.Net.Http.HttpResponseMessage response, System.Exception exception, System.TimeSpan elapsed);
                    object LogRequestStart(System.Net.Http.HttpRequestMessage request);
                    void LogRequestStop(object context, System.Net.Http.HttpRequestMessage request, System.Net.Http.HttpResponseMessage response, System.TimeSpan elapsed);
                }
                public class LoggingHttpMessageHandler : System.Net.Http.DelegatingHandler
                {
                    public LoggingHttpMessageHandler(Microsoft.Extensions.Logging.ILogger logger) => throw null;
                    public LoggingHttpMessageHandler(Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Http.HttpClientFactoryOptions options) => throw null;
                    protected override System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                }
                public class LoggingScopeHttpMessageHandler : System.Net.Http.DelegatingHandler
                {
                    public LoggingScopeHttpMessageHandler(Microsoft.Extensions.Logging.ILogger logger) => throw null;
                    public LoggingScopeHttpMessageHandler(Microsoft.Extensions.Logging.ILogger logger, Microsoft.Extensions.Http.HttpClientFactoryOptions options) => throw null;
                    protected override System.Threading.Tasks.Task<System.Net.Http.HttpResponseMessage> SendAsync(System.Net.Http.HttpRequestMessage request, System.Threading.CancellationToken cancellationToken) => throw null;
                }
            }
        }
    }
}
namespace System
{
    namespace Net
    {
        namespace Http
        {
            public static partial class HttpClientFactoryExtensions
            {
                public static System.Net.Http.HttpClient CreateClient(this System.Net.Http.IHttpClientFactory factory) => throw null;
            }
            public static partial class HttpMessageHandlerFactoryExtensions
            {
                public static System.Net.Http.HttpMessageHandler CreateHandler(this System.Net.Http.IHttpMessageHandlerFactory factory) => throw null;
            }
            public interface IHttpClientFactory
            {
                System.Net.Http.HttpClient CreateClient(string name);
            }
            public interface IHttpMessageHandlerFactory
            {
                System.Net.Http.HttpMessageHandler CreateHandler(string name);
            }
        }
    }
}
