// This file contains auto-generated code.
// Generated from `System.ClientModel, Version=1.5.1.0, Culture=neutral, PublicKeyToken=92742159e12e44c8`.
namespace System
{
    namespace ClientModel
    {
        public class ApiKeyCredential
        {
            public ApiKeyCredential(string key) => throw null;
            public void Deconstruct(out string key) => throw null;
            public void Update(string key) => throw null;
        }
        public abstract class AsyncCollectionResult<T> : System.ClientModel.Primitives.AsyncCollectionResult, System.Collections.Generic.IAsyncEnumerable<T>
        {
            protected AsyncCollectionResult() => throw null;
            public System.Collections.Generic.IAsyncEnumerator<T> GetAsyncEnumerator(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            protected abstract System.Collections.Generic.IAsyncEnumerable<T> GetValuesFromPageAsync(System.ClientModel.ClientResult page);
        }
        public abstract class AuthenticationTokenProvider
        {
            public abstract System.ClientModel.Primitives.GetTokenOptions CreateTokenOptions(System.Collections.Generic.IReadOnlyDictionary<string, object> properties);
            protected AuthenticationTokenProvider() => throw null;
            public abstract System.ClientModel.Primitives.AuthenticationToken GetToken(System.ClientModel.Primitives.GetTokenOptions options, System.Threading.CancellationToken cancellationToken);
            public abstract System.Threading.Tasks.ValueTask<System.ClientModel.Primitives.AuthenticationToken> GetTokenAsync(System.ClientModel.Primitives.GetTokenOptions options, System.Threading.CancellationToken cancellationToken);
        }
        public abstract class BinaryContent : System.IDisposable
        {
            public static System.ClientModel.BinaryContent Create(System.BinaryData value) => throw null;
            public static System.ClientModel.BinaryContent Create<T>(T model, System.ClientModel.Primitives.ModelReaderWriterOptions options = default(System.ClientModel.Primitives.ModelReaderWriterOptions)) where T : System.ClientModel.Primitives.IPersistableModel<T> => throw null;
            public static System.ClientModel.BinaryContent Create(System.IO.Stream stream) => throw null;
            public static System.ClientModel.BinaryContent CreateJson<T>(T jsonSerializable, System.Text.Json.JsonSerializerOptions options = default(System.Text.Json.JsonSerializerOptions)) => throw null;
            public static System.ClientModel.BinaryContent CreateJson<T>(T jsonSerializable, System.Text.Json.Serialization.Metadata.JsonTypeInfo<T> jsonTypeInfo) => throw null;
            public static System.ClientModel.BinaryContent CreateJson(string jsonString, bool validate = default(bool)) => throw null;
            protected BinaryContent() => throw null;
            public abstract void Dispose();
            public string MediaType { get => throw null; set { } }
            public abstract bool TryComputeLength(out long length);
            public abstract void WriteTo(System.IO.Stream stream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            public abstract System.Threading.Tasks.Task WriteToAsync(System.IO.Stream stream, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
        }
        public class ClientResult
        {
            protected ClientResult(System.ClientModel.Primitives.PipelineResponse response) => throw null;
            public static System.ClientModel.ClientResult<T> FromOptionalValue<T>(T value, System.ClientModel.Primitives.PipelineResponse response) => throw null;
            public static System.ClientModel.ClientResult FromResponse(System.ClientModel.Primitives.PipelineResponse response) => throw null;
            public static System.ClientModel.ClientResult<T> FromValue<T>(T value, System.ClientModel.Primitives.PipelineResponse response) => throw null;
            public System.ClientModel.Primitives.PipelineResponse GetRawResponse() => throw null;
        }
        public class ClientResult<T> : System.ClientModel.ClientResult
        {
            protected ClientResult(T value, System.ClientModel.Primitives.PipelineResponse response) : base(default(System.ClientModel.Primitives.PipelineResponse)) => throw null;
            public static implicit operator T(System.ClientModel.ClientResult<T> result) => throw null;
            public virtual T Value { get => throw null; }
        }
        public class ClientResultException : System.Exception
        {
            public static System.Threading.Tasks.Task<System.ClientModel.ClientResultException> CreateAsync(System.ClientModel.Primitives.PipelineResponse response, System.Exception innerException = default(System.Exception)) => throw null;
            public ClientResultException(System.ClientModel.Primitives.PipelineResponse response, System.Exception innerException = default(System.Exception)) => throw null;
            public ClientResultException(string message, System.ClientModel.Primitives.PipelineResponse response = default(System.ClientModel.Primitives.PipelineResponse), System.Exception innerException = default(System.Exception)) => throw null;
            public System.ClientModel.Primitives.PipelineResponse GetRawResponse() => throw null;
            public int Status { get => throw null; set { } }
        }
        public abstract class CollectionResult<T> : System.ClientModel.Primitives.CollectionResult, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable
        {
            protected CollectionResult() => throw null;
            public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            protected abstract System.Collections.Generic.IEnumerable<T> GetValuesFromPage(System.ClientModel.ClientResult page);
        }
        public class ContinuationToken
        {
            protected ContinuationToken() => throw null;
            protected ContinuationToken(System.BinaryData bytes) => throw null;
            public static System.ClientModel.ContinuationToken FromBytes(System.BinaryData bytes) => throw null;
            public virtual System.BinaryData ToBytes() => throw null;
        }
        namespace Primitives
        {
            public static partial class ActivityExtensions
            {
                public static System.Diagnostics.Activity MarkClientActivityFailed(this System.Diagnostics.Activity activity, System.Exception exception) => throw null;
                public static System.Diagnostics.Activity StartClientActivity(this System.Diagnostics.ActivitySource activitySource, System.ClientModel.Primitives.ClientPipelineOptions options, string name, System.Diagnostics.ActivityKind kind = default(System.Diagnostics.ActivityKind), System.Diagnostics.ActivityContext parentContext = default(System.Diagnostics.ActivityContext), System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> tags = default(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>>)) => throw null;
            }
            public class ApiKeyAuthenticationPolicy : System.ClientModel.Primitives.AuthenticationPolicy
            {
                public static System.ClientModel.Primitives.ApiKeyAuthenticationPolicy CreateBasicAuthorizationPolicy(System.ClientModel.ApiKeyCredential credential) => throw null;
                public static System.ClientModel.Primitives.ApiKeyAuthenticationPolicy CreateBearerAuthorizationPolicy(System.ClientModel.ApiKeyCredential credential) => throw null;
                public static System.ClientModel.Primitives.ApiKeyAuthenticationPolicy CreateHeaderApiKeyPolicy(System.ClientModel.ApiKeyCredential credential, string headerName, string keyPrefix = default(string)) => throw null;
                public override sealed void Process(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
                public override sealed System.Threading.Tasks.ValueTask ProcessAsync(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
            }
            public abstract class AsyncCollectionResult
            {
                protected AsyncCollectionResult() => throw null;
                public abstract System.ClientModel.ContinuationToken GetContinuationToken(System.ClientModel.ClientResult page);
                public abstract System.Collections.Generic.IAsyncEnumerable<System.ClientModel.ClientResult> GetRawPagesAsync();
            }
            public abstract class AuthenticationPolicy : System.ClientModel.Primitives.PipelinePolicy
            {
                protected AuthenticationPolicy() => throw null;
            }
            public class AuthenticationToken
            {
                public AuthenticationToken(string tokenValue, string tokenType, System.DateTimeOffset expiresOn, System.DateTimeOffset? refreshOn = default(System.DateTimeOffset?)) => throw null;
                public System.DateTimeOffset? ExpiresOn { get => throw null; }
                public System.DateTimeOffset? RefreshOn { get => throw null; }
                public string TokenType { get => throw null; }
                public string TokenValue { get => throw null; }
            }
            public class BearerTokenPolicy : System.ClientModel.Primitives.AuthenticationPolicy
            {
                public BearerTokenPolicy(System.ClientModel.AuthenticationTokenProvider tokenProvider, System.Collections.Generic.IEnumerable<System.Collections.Generic.IReadOnlyDictionary<string, object>> contexts) => throw null;
                public BearerTokenPolicy(System.ClientModel.AuthenticationTokenProvider tokenProvider, string scope) => throw null;
                public override void Process(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
                public override System.Threading.Tasks.ValueTask ProcessAsync(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
            }
            public class ClientCache
            {
                public ClientCache(int maxSize) => throw null;
                public T GetClient<T>(object clientId, System.Func<T> createClient) where T : class => throw null;
            }
            public struct ClientConnection
            {
                public object Credential { get => throw null; }
                public System.ClientModel.Primitives.CredentialKind CredentialKind { get => throw null; }
                public ClientConnection(string id, string locator, object credential, System.ClientModel.Primitives.CredentialKind credentialKind) => throw null;
                public ClientConnection(string id, string locator) => throw null;
                public string Id { get => throw null; }
                public string Locator { get => throw null; }
                public override string ToString() => throw null;
                public bool TryGetLocatorAsUri(out System.Uri uri) => throw null;
            }
            public class ClientConnectionCollection : System.Collections.ObjectModel.KeyedCollection<string, System.ClientModel.Primitives.ClientConnection>
            {
                public void AddRange(System.Collections.Generic.IEnumerable<System.ClientModel.Primitives.ClientConnection> connections) => throw null;
                public ClientConnectionCollection() => throw null;
                protected override string GetKeyForItem(System.ClientModel.Primitives.ClientConnection item) => throw null;
            }
            public abstract class ClientConnectionProvider
            {
                protected ClientConnectionProvider(int maxCacheSize) => throw null;
                public abstract System.Collections.Generic.IEnumerable<System.ClientModel.Primitives.ClientConnection> GetAllConnections();
                public abstract System.ClientModel.Primitives.ClientConnection GetConnection(string connectionId);
                public System.ClientModel.Primitives.ClientCache Subclients { get => throw null; }
            }
            [System.Flags]
            public enum ClientErrorBehaviors
            {
                Default = 0,
                NoThrow = 1,
            }
            public class ClientLoggingOptions
            {
                public System.Collections.Generic.IList<string> AllowedHeaderNames { get => throw null; }
                public System.Collections.Generic.IList<string> AllowedQueryParameters { get => throw null; }
                protected void AssertNotFrozen() => throw null;
                public ClientLoggingOptions() => throw null;
                public bool? EnableLogging { get => throw null; set { } }
                public bool? EnableMessageContentLogging { get => throw null; set { } }
                public bool? EnableMessageLogging { get => throw null; set { } }
                public virtual void Freeze() => throw null;
                public Microsoft.Extensions.Logging.ILoggerFactory LoggerFactory { get => throw null; set { } }
                public int? MessageContentSizeLimit { get => throw null; set { } }
            }
            public sealed class ClientPipeline
            {
                public static System.ClientModel.Primitives.ClientPipeline Create(System.ClientModel.Primitives.ClientPipelineOptions options = default(System.ClientModel.Primitives.ClientPipelineOptions)) => throw null;
                public static System.ClientModel.Primitives.ClientPipeline Create(System.ClientModel.Primitives.ClientPipelineOptions options, System.ReadOnlySpan<System.ClientModel.Primitives.PipelinePolicy> perCallPolicies, System.ReadOnlySpan<System.ClientModel.Primitives.PipelinePolicy> perTryPolicies, System.ReadOnlySpan<System.ClientModel.Primitives.PipelinePolicy> beforeTransportPolicies) => throw null;
                public System.ClientModel.Primitives.PipelineMessage CreateMessage() => throw null;
                public void Send(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                public System.Threading.Tasks.ValueTask SendAsync(System.ClientModel.Primitives.PipelineMessage message) => throw null;
            }
            public class ClientPipelineOptions
            {
                public void AddPolicy(System.ClientModel.Primitives.PipelinePolicy policy, System.ClientModel.Primitives.PipelinePosition position) => throw null;
                protected void AssertNotFrozen() => throw null;
                public System.ClientModel.Primitives.ClientLoggingOptions ClientLoggingOptions { get => throw null; set { } }
                public ClientPipelineOptions() => throw null;
                public bool? EnableDistributedTracing { get => throw null; set { } }
                public virtual void Freeze() => throw null;
                public System.ClientModel.Primitives.PipelinePolicy MessageLoggingPolicy { get => throw null; set { } }
                public System.TimeSpan? NetworkTimeout { get => throw null; set { } }
                public System.ClientModel.Primitives.PipelinePolicy RetryPolicy { get => throw null; set { } }
                public System.ClientModel.Primitives.PipelineTransport Transport { get => throw null; set { } }
            }
            public class ClientRetryPolicy : System.ClientModel.Primitives.PipelinePolicy
            {
                public ClientRetryPolicy(int maxRetries = default(int)) => throw null;
                public ClientRetryPolicy(int maxRetries, bool enableLogging, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public static System.ClientModel.Primitives.ClientRetryPolicy Default { get => throw null; }
                protected virtual System.TimeSpan GetNextDelay(System.ClientModel.Primitives.PipelineMessage message, int tryCount) => throw null;
                protected virtual void OnRequestSent(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                protected virtual System.Threading.Tasks.ValueTask OnRequestSentAsync(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                protected virtual void OnSendingRequest(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                protected virtual System.Threading.Tasks.ValueTask OnSendingRequestAsync(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                protected virtual void OnTryComplete(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                public override sealed void Process(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
                public override sealed System.Threading.Tasks.ValueTask ProcessAsync(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
                protected virtual bool ShouldRetry(System.ClientModel.Primitives.PipelineMessage message, System.Exception exception) => throw null;
                protected virtual System.Threading.Tasks.ValueTask<bool> ShouldRetryAsync(System.ClientModel.Primitives.PipelineMessage message, System.Exception exception) => throw null;
                protected virtual void Wait(System.TimeSpan time, System.Threading.CancellationToken cancellationToken) => throw null;
                protected virtual System.Threading.Tasks.Task WaitAsync(System.TimeSpan time, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            public abstract class CollectionResult
            {
                protected CollectionResult() => throw null;
                public abstract System.ClientModel.ContinuationToken GetContinuationToken(System.ClientModel.ClientResult page);
                public abstract System.Collections.Generic.IEnumerable<System.ClientModel.ClientResult> GetRawPages();
            }
            public enum CredentialKind
            {
                None = 0,
                ApiKeyString = 1,
                TokenCredential = 2,
            }
            public class GetTokenOptions
            {
                public const string AuthorizationUrlPropertyName = default;
                public GetTokenOptions(System.Collections.Generic.IReadOnlyDictionary<string, object> properties) => throw null;
                public System.Collections.Generic.IReadOnlyDictionary<string, object> Properties { get => throw null; }
                public const string RefreshUrlPropertyName = default;
                public const string ScopesPropertyName = default;
                public const string TokenUrlPropertyName = default;
            }
            public class HttpClientPipelineTransport : System.ClientModel.Primitives.PipelineTransport, System.IDisposable
            {
                protected override System.ClientModel.Primitives.PipelineMessage CreateMessageCore() => throw null;
                public HttpClientPipelineTransport() => throw null;
                public HttpClientPipelineTransport(System.Net.Http.HttpClient client) => throw null;
                public HttpClientPipelineTransport(System.Net.Http.HttpClient client, bool enableLogging, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                protected virtual void OnReceivedResponse(System.ClientModel.Primitives.PipelineMessage message, System.Net.Http.HttpResponseMessage httpResponse) => throw null;
                protected virtual void OnSendingRequest(System.ClientModel.Primitives.PipelineMessage message, System.Net.Http.HttpRequestMessage httpRequest) => throw null;
                protected override sealed void ProcessCore(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                protected override sealed System.Threading.Tasks.ValueTask ProcessCoreAsync(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                public static System.ClientModel.Primitives.HttpClientPipelineTransport Shared { get => throw null; }
            }
            public interface IJsonModel<T> : System.ClientModel.Primitives.IPersistableModel<T>
            {
                T Create(ref System.Text.Json.Utf8JsonReader reader, System.ClientModel.Primitives.ModelReaderWriterOptions options);
                void Write(System.Text.Json.Utf8JsonWriter writer, System.ClientModel.Primitives.ModelReaderWriterOptions options);
            }
            public interface IPersistableModel<T>
            {
                T Create(System.BinaryData data, System.ClientModel.Primitives.ModelReaderWriterOptions options);
                string GetFormatFromOptions(System.ClientModel.Primitives.ModelReaderWriterOptions options);
                System.BinaryData Write(System.ClientModel.Primitives.ModelReaderWriterOptions options);
            }
            public class JsonModelConverter : System.Text.Json.Serialization.JsonConverter<System.ClientModel.Primitives.IJsonModel<object>>
            {
                public override bool CanConvert(System.Type typeToConvert) => throw null;
                public JsonModelConverter() => throw null;
                public JsonModelConverter(System.ClientModel.Primitives.ModelReaderWriterOptions options) => throw null;
                public JsonModelConverter(System.ClientModel.Primitives.ModelReaderWriterOptions options, System.ClientModel.Primitives.ModelReaderWriterContext context) => throw null;
                public override System.ClientModel.Primitives.IJsonModel<object> Read(ref System.Text.Json.Utf8JsonReader reader, System.Type typeToConvert, System.Text.Json.JsonSerializerOptions options) => throw null;
                public override void Write(System.Text.Json.Utf8JsonWriter writer, System.ClientModel.Primitives.IJsonModel<object> value, System.Text.Json.JsonSerializerOptions options) => throw null;
            }
            public class MessageLoggingPolicy : System.ClientModel.Primitives.PipelinePolicy
            {
                public MessageLoggingPolicy(System.ClientModel.Primitives.ClientLoggingOptions options = default(System.ClientModel.Primitives.ClientLoggingOptions)) => throw null;
                public static System.ClientModel.Primitives.MessageLoggingPolicy Default { get => throw null; }
                public override sealed void Process(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
                public override sealed System.Threading.Tasks.ValueTask ProcessAsync(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
            }
            public static class ModelReaderWriter
            {
                public static T Read<T>(System.BinaryData data, System.ClientModel.Primitives.ModelReaderWriterOptions options = default(System.ClientModel.Primitives.ModelReaderWriterOptions)) where T : System.ClientModel.Primitives.IPersistableModel<T> => throw null;
                public static T Read<T>(System.BinaryData data, System.ClientModel.Primitives.ModelReaderWriterOptions options, System.ClientModel.Primitives.ModelReaderWriterContext context) => throw null;
                public static object Read(System.BinaryData data, System.Type returnType, System.ClientModel.Primitives.ModelReaderWriterOptions options = default(System.ClientModel.Primitives.ModelReaderWriterOptions)) => throw null;
                public static object Read(System.BinaryData data, System.Type returnType, System.ClientModel.Primitives.ModelReaderWriterOptions options, System.ClientModel.Primitives.ModelReaderWriterContext context) => throw null;
                public static System.BinaryData Write<T>(T model, System.ClientModel.Primitives.ModelReaderWriterOptions options = default(System.ClientModel.Primitives.ModelReaderWriterOptions)) where T : System.ClientModel.Primitives.IPersistableModel<T> => throw null;
                public static System.BinaryData Write(object model, System.ClientModel.Primitives.ModelReaderWriterOptions options = default(System.ClientModel.Primitives.ModelReaderWriterOptions)) => throw null;
                public static System.BinaryData Write<T>(T model, System.ClientModel.Primitives.ModelReaderWriterOptions options, System.ClientModel.Primitives.ModelReaderWriterContext context) => throw null;
                public static System.BinaryData Write(object model, System.ClientModel.Primitives.ModelReaderWriterOptions options, System.ClientModel.Primitives.ModelReaderWriterContext context) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true)]
            public class ModelReaderWriterBuildableAttribute : System.Attribute
            {
                public ModelReaderWriterBuildableAttribute(System.Type type) => throw null;
            }
            public abstract class ModelReaderWriterContext
            {
                protected ModelReaderWriterContext() => throw null;
                public System.ClientModel.Primitives.ModelReaderWriterTypeBuilder GetTypeBuilder(System.Type type) => throw null;
                public bool TryGetTypeBuilder(System.Type type, out System.ClientModel.Primitives.ModelReaderWriterTypeBuilder builder) => throw null;
                protected virtual bool TryGetTypeBuilderCore(System.Type type, out System.ClientModel.Primitives.ModelReaderWriterTypeBuilder builder) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)1)]
            public sealed class ModelReaderWriterContextTypeAttribute : System.Attribute
            {
                public ModelReaderWriterContextTypeAttribute(System.Type contextType) => throw null;
            }
            public class ModelReaderWriterOptions
            {
                public ModelReaderWriterOptions(string format) => throw null;
                public string Format { get => throw null; }
                public static System.ClientModel.Primitives.ModelReaderWriterOptions Json { get => throw null; }
                public static System.ClientModel.Primitives.ModelReaderWriterOptions Xml { get => throw null; }
            }
            public abstract class ModelReaderWriterTypeBuilder
            {
                protected virtual void AddItem(object collectionBuilder, object item) => throw null;
                protected virtual void AddItemWithKey(object collectionBuilder, string key, object item) => throw null;
                protected abstract System.Type BuilderType { get; }
                protected virtual object ConvertCollectionBuilder(object collectionBuilder) => throw null;
                protected abstract object CreateInstance();
                protected ModelReaderWriterTypeBuilder() => throw null;
                protected virtual System.Collections.IEnumerable GetItems(object collection) => throw null;
                protected virtual System.Type ItemType { get => throw null; }
            }
            public abstract class OperationResult
            {
                protected OperationResult(System.ClientModel.Primitives.PipelineResponse response) => throw null;
                public System.ClientModel.Primitives.PipelineResponse GetRawResponse() => throw null;
                public bool HasCompleted { get => throw null; set { } }
                public abstract System.ClientModel.ContinuationToken RehydrationToken { get; set; }
                protected void SetRawResponse(System.ClientModel.Primitives.PipelineResponse response) => throw null;
                public abstract System.ClientModel.ClientResult UpdateStatus(System.ClientModel.Primitives.RequestOptions options = default(System.ClientModel.Primitives.RequestOptions));
                public abstract System.Threading.Tasks.ValueTask<System.ClientModel.ClientResult> UpdateStatusAsync(System.ClientModel.Primitives.RequestOptions options = default(System.ClientModel.Primitives.RequestOptions));
                public virtual void WaitForCompletion(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.ValueTask WaitForCompletionAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4)]
            public sealed class PersistableModelProxyAttribute : System.Attribute
            {
                public PersistableModelProxyAttribute(System.Type proxyType) => throw null;
                public System.Type ProxyType { get => throw null; }
            }
            public class PipelineMessage : System.IDisposable
            {
                public void Apply(System.ClientModel.Primitives.RequestOptions options) => throw null;
                public bool BufferResponse { get => throw null; set { } }
                public System.Threading.CancellationToken CancellationToken { get => throw null; set { } }
                protected PipelineMessage(System.ClientModel.Primitives.PipelineRequest request) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.ClientModel.Primitives.PipelineResponse ExtractResponse() => throw null;
                public System.TimeSpan? NetworkTimeout { get => throw null; set { } }
                public System.ClientModel.Primitives.PipelineRequest Request { get => throw null; }
                public System.ClientModel.Primitives.PipelineResponse Response { get => throw null; set { } }
                public System.ClientModel.Primitives.PipelineMessageClassifier ResponseClassifier { get => throw null; set { } }
                public void SetProperty(System.Type key, object value) => throw null;
                public bool TryGetProperty(System.Type key, out object value) => throw null;
            }
            public abstract class PipelineMessageClassifier
            {
                public static System.ClientModel.Primitives.PipelineMessageClassifier Create(System.ReadOnlySpan<ushort> successStatusCodes) => throw null;
                protected PipelineMessageClassifier() => throw null;
                public static System.ClientModel.Primitives.PipelineMessageClassifier Default { get => throw null; }
                public abstract bool TryClassify(System.ClientModel.Primitives.PipelineMessage message, out bool isError);
                public abstract bool TryClassify(System.ClientModel.Primitives.PipelineMessage message, System.Exception exception, out bool isRetriable);
            }
            public abstract class PipelinePolicy
            {
                protected PipelinePolicy() => throw null;
                public abstract void Process(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex);
                public abstract System.Threading.Tasks.ValueTask ProcessAsync(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex);
                protected static void ProcessNext(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
                protected static System.Threading.Tasks.ValueTask ProcessNextAsync(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
            }
            public enum PipelinePosition
            {
                PerCall = 0,
                PerTry = 1,
                BeforeTransport = 2,
            }
            public abstract class PipelineRequest : System.IDisposable
            {
                public System.ClientModel.BinaryContent Content { get => throw null; set { } }
                protected abstract System.ClientModel.BinaryContent ContentCore { get; set; }
                protected PipelineRequest() => throw null;
                public abstract void Dispose();
                public System.ClientModel.Primitives.PipelineRequestHeaders Headers { get => throw null; }
                protected abstract System.ClientModel.Primitives.PipelineRequestHeaders HeadersCore { get; }
                public string Method { get => throw null; set { } }
                protected abstract string MethodCore { get; set; }
                public System.Uri Uri { get => throw null; set { } }
                protected abstract System.Uri UriCore { get; set; }
            }
            public abstract class PipelineRequestHeaders : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.IEnumerable
            {
                public abstract void Add(string name, string value);
                protected PipelineRequestHeaders() => throw null;
                public abstract System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, string>> GetEnumerator();
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public abstract bool Remove(string name);
                public abstract void Set(string name, string value);
                public abstract bool TryGetValue(string name, out string value);
                public abstract bool TryGetValues(string name, out System.Collections.Generic.IEnumerable<string> values);
            }
            public abstract class PipelineResponse : System.IDisposable
            {
                public abstract System.BinaryData BufferContent(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.ValueTask<System.BinaryData> BufferContentAsync(System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.BinaryData Content { get; }
                public abstract System.IO.Stream ContentStream { get; set; }
                protected PipelineResponse() => throw null;
                public abstract void Dispose();
                public System.ClientModel.Primitives.PipelineResponseHeaders Headers { get => throw null; }
                protected abstract System.ClientModel.Primitives.PipelineResponseHeaders HeadersCore { get; }
                public virtual bool IsError { get => throw null; }
                protected virtual bool IsErrorCore { get => throw null; set { } }
                public abstract string ReasonPhrase { get; }
                public abstract int Status { get; }
            }
            public abstract class PipelineResponseHeaders : System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.IEnumerable
            {
                protected PipelineResponseHeaders() => throw null;
                public abstract System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<string, string>> GetEnumerator();
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public abstract bool TryGetValue(string name, out string value);
                public abstract bool TryGetValues(string name, out System.Collections.Generic.IEnumerable<string> values);
            }
            public abstract class PipelineTransport : System.ClientModel.Primitives.PipelinePolicy
            {
                public System.ClientModel.Primitives.PipelineMessage CreateMessage() => throw null;
                protected abstract System.ClientModel.Primitives.PipelineMessage CreateMessageCore();
                protected PipelineTransport() => throw null;
                protected PipelineTransport(bool enableLogging, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                public void Process(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                public override sealed void Process(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
                public System.Threading.Tasks.ValueTask ProcessAsync(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                public override sealed System.Threading.Tasks.ValueTask ProcessAsync(System.ClientModel.Primitives.PipelineMessage message, System.Collections.Generic.IReadOnlyList<System.ClientModel.Primitives.PipelinePolicy> pipeline, int currentIndex) => throw null;
                protected abstract void ProcessCore(System.ClientModel.Primitives.PipelineMessage message);
                protected abstract System.Threading.Tasks.ValueTask ProcessCoreAsync(System.ClientModel.Primitives.PipelineMessage message);
            }
            public class RequestOptions
            {
                public void AddHeader(string name, string value) => throw null;
                public void AddPolicy(System.ClientModel.Primitives.PipelinePolicy policy, System.ClientModel.Primitives.PipelinePosition position) => throw null;
                protected virtual void Apply(System.ClientModel.Primitives.PipelineMessage message) => throw null;
                protected void AssertNotFrozen() => throw null;
                public bool BufferResponse { get => throw null; set { } }
                public System.Threading.CancellationToken CancellationToken { get => throw null; set { } }
                public RequestOptions() => throw null;
                public System.ClientModel.Primitives.ClientErrorBehaviors ErrorOptions { get => throw null; set { } }
                public virtual void Freeze() => throw null;
                public void SetHeader(string name, string value) => throw null;
            }
        }
    }
}
