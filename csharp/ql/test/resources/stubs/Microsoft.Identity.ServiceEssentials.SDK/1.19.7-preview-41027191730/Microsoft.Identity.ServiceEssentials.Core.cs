// This file contains auto-generated code.
// Generated from `Microsoft.Identity.ServiceEssentials.Core, Version=1.19.6.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class MiseServiceRegistrationExtensions
            {
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration AddMise(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration configuration, Microsoft.Identity.ServiceEssentials.IModuleContainer<Microsoft.Identity.ServiceEssentials.MiseHttpContext> moduleContainer, Microsoft.Identity.ServiceEssentials.ILogScrubber logScrubber, Microsoft.Identity.ServiceEssentials.ITelemetryClient telemetryClient, Microsoft.Identity.ServiceEssentials.IModuleFilter<Microsoft.Identity.ServiceEssentials.MiseHttpContext> moduleFilter, Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<Microsoft.Identity.ServiceEssentials.MiseHttpContext> authenticationTicketProvider, string clientId, string authenticationSectionName = default(string), string miseSectionName = default(string)) => throw null;
            }
        }
    }
    namespace Identity
    {
        namespace ServiceEssentials
        {
            public class AcquireTokenOptions
            {
                public string Authority { get => throw null; set { } }
                public AcquireTokenOptions() => throw null;
                public string TenantId { get => throw null; set { } }
            }
            public class ApplicationInformationContainer : Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer
            {
                public string ClientId { get => throw null; }
                public ApplicationInformationContainer(string clientId) => throw null;
            }
            namespace Attributes
            {
                public interface IMiseAttribute
                {
                }
            }
            public abstract class AuthenticationScheme
            {
                public static readonly Microsoft.Identity.ServiceEssentials.AuthenticationScheme Bearer;
                public static Microsoft.Identity.ServiceEssentials.AuthenticationScheme CreateFromName(string name) => throw null;
                protected AuthenticationScheme(string name) => throw null;
                public static readonly Microsoft.Identity.ServiceEssentials.AuthenticationScheme MSAuth_1_0_AT_POP;
                public static readonly Microsoft.Identity.ServiceEssentials.AuthenticationScheme MSAuth_1_0_PFAT;
                public string Name { get => throw null; }
                public static readonly Microsoft.Identity.ServiceEssentials.AuthenticationScheme PoP;
                public override string ToString() => throw null;
                public static readonly Microsoft.Identity.ServiceEssentials.AuthenticationScheme Unknown;
            }
            public class AuthenticationTicket
            {
                public System.Security.Claims.ClaimsIdentity ActorIdentity { get => throw null; set { } }
                public Microsoft.Identity.ServiceEssentials.AuthenticationScheme AuthenticationScheme { get => throw null; set { } }
                public AuthenticationTicket(System.Security.Claims.ClaimsIdentity subjectIdentity, Microsoft.Identity.ServiceEssentials.AuthenticationScheme authenticationScheme) => throw null;
                public System.Security.Claims.ClaimsIdentity SubjectIdentity { get => throw null; set { } }
            }
            public class AuthenticationTicketProviderResult : Microsoft.Identity.ServiceEssentials.MiseComponentResult
            {
                public Microsoft.Identity.ServiceEssentials.AuthenticationTicket AuthenticationTicket { get => throw null; set { } }
                protected AuthenticationTicketProviderResult() => throw null;
                public static Microsoft.Identity.ServiceEssentials.AuthenticationTicketProviderResult Fail(Microsoft.Identity.ServiceEssentials.IMiseComponent authenticationComponent, Microsoft.Identity.ServiceEssentials.MiseContext context) => throw null;
                public static Microsoft.Identity.ServiceEssentials.AuthenticationTicketProviderResult Fail(Microsoft.Identity.ServiceEssentials.IMiseComponent authenticationComponent, Microsoft.Identity.ServiceEssentials.MiseContext context, System.Exception exception) => throw null;
                public static Microsoft.Identity.ServiceEssentials.AuthenticationTicketProviderResult Success(Microsoft.Identity.ServiceEssentials.IMiseComponent authenticationComponent, Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.AuthenticationTicket authenticationTicket) => throw null;
            }
            namespace Builders
            {
                public class AuthenticationComponentParameterBuilder<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
                {
                    public Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer ApplicationInformationContainer { get => throw null; }
                    public AuthenticationComponentParameterBuilder(Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer applicationInformationContainer) => throw null;
                    public Microsoft.Identity.ServiceEssentials.Builders.ModuleContainerParameterBuilder<TMiseContext> UseAuthenticationComponent(Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<TMiseContext> authenticationComponent) => throw null;
                }
                public class ModuleCollectionBuilder<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
                {
                    public void AddModule(Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> module) => throw null;
                    public System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> Build() => throw null;
                    public ModuleCollectionBuilder() => throw null;
                }
                public class ModuleContainerParameterBuilder<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
                {
                    public Microsoft.Identity.ServiceEssentials.Builders.OptionalParameterBuilder<TMiseContext> ConfigureDefaultModuleCollection(System.Action<Microsoft.Identity.ServiceEssentials.Builders.ModuleCollectionBuilder<TMiseContext>> configureModuleCollection) => throw null;
                    public Microsoft.Identity.ServiceEssentials.Builders.OptionalParameterBuilder<TMiseContext> ConfigureDefaultModuleCollection(Microsoft.Identity.ServiceEssentials.IModuleContainer<TMiseContext> customModuleContainer, System.Action<Microsoft.Identity.ServiceEssentials.Builders.ModuleCollectionBuilder<TMiseContext>> configureModuleCollection) => throw null;
                    public ModuleContainerParameterBuilder(Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<TMiseContext> ticketProvider, Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer applicationInformationContainer) => throw null;
                }
                public class OptionalParameterBuilder<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
                {
                    public Microsoft.Identity.ServiceEssentials.MiseHost<TMiseContext> Build() => throw null;
                    public OptionalParameterBuilder(Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<TMiseContext> ticketProvider, Microsoft.Identity.ServiceEssentials.IModuleContainer<TMiseContext> moduleContainer, Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer applicationInformationContainer) => throw null;
                    public Microsoft.Identity.ServiceEssentials.Builders.OptionalParameterBuilder<TMiseContext> WithLogger(Microsoft.Identity.ServiceEssentials.IMiseLogger logger) => throw null;
                    public Microsoft.Identity.ServiceEssentials.Builders.OptionalParameterBuilder<TMiseContext> WithLogger(Microsoft.Extensions.Logging.ILogger logger) => throw null;
                    public Microsoft.Identity.ServiceEssentials.Builders.OptionalParameterBuilder<TMiseContext> WithLogScrubber(Microsoft.Identity.ServiceEssentials.ILogScrubber logScrubber) => throw null;
                    public Microsoft.Identity.ServiceEssentials.Builders.OptionalParameterBuilder<TMiseContext> WithModuleFilter(Microsoft.Identity.ServiceEssentials.IModuleFilter<TMiseContext> moduleFilter) => throw null;
                    public Microsoft.Identity.ServiceEssentials.Builders.OptionalParameterBuilder<TMiseContext> WithTelemetryClient(Microsoft.Identity.ServiceEssentials.ITelemetryClient telemetryClient) => throw null;
                }
            }
            public class CacheItem<TData> where TData : new()
            {
                public CacheItem() => throw null;
                public CacheItem(string key, TData data, Microsoft.Identity.ServiceEssentials.CacheItemMetadata metadata) => throw null;
                public TData Data { get => throw null; set { } }
                public string Key { get => throw null; set { } }
                public Microsoft.Identity.ServiceEssentials.CacheItemMetadata Metadata { get => throw null; set { } }
            }
            public class CacheItemMetadata
            {
                public System.DateTimeOffset CreationTime { get => throw null; set { } }
                public CacheItemMetadata() => throw null;
                public CacheItemMetadata(System.TimeSpan timeToExpire, System.TimeSpan timeToRemove) => throw null;
                public CacheItemMetadata(System.TimeSpan timeToExpire, System.TimeSpan timeToRemove, System.TimeSpan timeToRefresh) => throw null;
                public CacheItemMetadata(System.TimeSpan timeToExpire, System.TimeSpan timeToRemove, System.DateTimeOffset creationTime) => throw null;
                public CacheItemMetadata(System.TimeSpan timeToExpire, System.TimeSpan timeToRemove, System.TimeSpan timeToRefresh, System.DateTimeOffset creationTime) => throw null;
                public System.TimeSpan TimeToExpire { get => throw null; set { } }
                public System.TimeSpan TimeToRefresh { get => throw null; set { } }
                public System.TimeSpan TimeToRemove { get => throw null; set { } }
            }
            public static class CacheUtils
            {
                public static bool IsValid<TData>(this Microsoft.Identity.ServiceEssentials.CacheItem<TData> cacheItem) where TData : new() => throw null;
                public static bool NeedsRefresh<TData>(this Microsoft.Identity.ServiceEssentials.CacheItem<TData> cacheItem) where TData : new() => throw null;
                public static System.TimeSpan RandomizeBy(this System.TimeSpan timeSpan, System.TimeSpan jitterSpan) => throw null;
            }
            public class ContextAuthenticationTicketProvider<TMiseContext> : Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<TMiseContext>, Microsoft.Identity.ServiceEssentials.IMiseComponent where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                public System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.AuthenticationTicketProviderResult> AuthenticateAsync(TMiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public ContextAuthenticationTicketProvider() => throw null;
                public string Name { get => throw null; set { } }
            }
            public enum DataClassification
            {
                AccessControlData = 0,
                CustomerContent = 10,
                EUII = 20,
                SupportData = 30,
                AccountData = 40,
                PublicPersonalData = 50,
                EUPI = 60,
                OII = 70,
                SystemMetadata = 80,
                PublicNonPersonalData = 90,
            }
            public class DataExchangeItem : Microsoft.Identity.ServiceEssentials.DataResponseItem
            {
                public DataExchangeItem(Microsoft.Identity.ServiceEssentials.DataRequest dataRequest) => throw null;
                public Microsoft.Identity.ServiceEssentials.DataRequest DataRequest { get => throw null; }
                public void FulfillRequest<TDataResponse>(TDataResponse dataResponse, Microsoft.Identity.ServiceEssentials.DataExchangeStatus dataExchangeStatus) where TDataResponse : Microsoft.Identity.ServiceEssentials.DataResponse<TDataResponse>, new() => throw null;
            }
            public abstract class DataExchangeStatus
            {
                public static Microsoft.Identity.ServiceEssentials.DataExchangeStatus CreateFromName(string name) => throw null;
                protected DataExchangeStatus(string name) => throw null;
                public static readonly Microsoft.Identity.ServiceEssentials.DataExchangeStatus Error;
                public static readonly Microsoft.Identity.ServiceEssentials.DataExchangeStatus FreshResponseFound;
                public static readonly Microsoft.Identity.ServiceEssentials.DataExchangeStatus LastKnownGoodResponseFound;
                public string Name { get => throw null; }
                public static readonly Microsoft.Identity.ServiceEssentials.DataExchangeStatus ResponseNotFound;
                public override string ToString() => throw null;
                public static readonly Microsoft.Identity.ServiceEssentials.DataExchangeStatus Unknown;
            }
            public abstract class DataRequest
            {
                protected DataRequest(string requestKey) => throw null;
                public string Key { get => throw null; }
            }
            public static partial class DataRequestAggregatorExtensions
            {
                public static void AddRequest(this Microsoft.Identity.ServiceEssentials.IDataRequestAggregatorBase dataRequestAggregator, Microsoft.Identity.ServiceEssentials.IAggregatedDataProviderBase requester, Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.DataExchangeItem item) => throw null;
            }
            public abstract class DataResponse<T> where T : new()
            {
                protected DataResponse() => throw null;
            }
            public abstract class DataResponseItem
            {
                protected DataResponseItem() => throw null;
                public Microsoft.Identity.ServiceEssentials.DataExchangeStatus DataExchangeStatus { get => throw null; set { } }
                protected object DataResponse { get => throw null; set { } }
                public System.Exception Error { get => throw null; set { } }
                public TDataResponse GetResponseAs<TDataResponse>() where TDataResponse : Microsoft.Identity.ServiceEssentials.DataResponse<TDataResponse>, new() => throw null;
            }
            public class DefaultMiseHttpClientFactory : Microsoft.Identity.ServiceEssentials.IMiseHttpClientFactory
            {
                public DefaultMiseHttpClientFactory() => throw null;
                public System.Net.Http.HttpClient GetHttpClient(string name = default(string)) => throw null;
            }
            namespace Exceptions
            {
                public class MiseAuthenticationTicketProviderException : Microsoft.Identity.ServiceEssentials.Exceptions.MiseException
                {
                    public MiseAuthenticationTicketProviderException() => throw null;
                    public MiseAuthenticationTicketProviderException(string message) => throw null;
                    public MiseAuthenticationTicketProviderException(string message, System.Exception innerException) => throw null;
                    protected MiseAuthenticationTicketProviderException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public override string ToString() => throw null;
                }
                public class MiseCancelledException : Microsoft.Identity.ServiceEssentials.Exceptions.MiseException
                {
                    public MiseCancelledException() => throw null;
                    public MiseCancelledException(string message) => throw null;
                    public MiseCancelledException(string message, System.Exception innerException) => throw null;
                    protected MiseCancelledException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public override string ToString() => throw null;
                }
                public class MiseDataProviderException : Microsoft.Identity.ServiceEssentials.Exceptions.MiseException
                {
                    public MiseDataProviderException() => throw null;
                    public MiseDataProviderException(string message) => throw null;
                    public MiseDataProviderException(string message, System.Exception innerException) => throw null;
                    protected MiseDataProviderException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public override string ToString() => throw null;
                }
                public class MiseDataRequestAggregatorException : Microsoft.Identity.ServiceEssentials.Exceptions.MiseException
                {
                    protected MiseDataRequestAggregatorException() => throw null;
                    public MiseDataRequestAggregatorException(string message) => throw null;
                    public MiseDataRequestAggregatorException(string message, System.Exception innerException) => throw null;
                    protected MiseDataRequestAggregatorException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public override string ToString() => throw null;
                }
                public abstract class MiseException : System.Exception
                {
                    public Microsoft.Identity.ServiceEssentials.IMiseComponent Component { get => throw null; set { } }
                    public string CorrelationId { get => throw null; set { } }
                    protected MiseException() => throw null;
                    protected MiseException(string message) => throw null;
                    protected MiseException(string message, System.Exception innerException) => throw null;
                    protected MiseException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public override string ToString() => throw null;
                }
                public class MiseHostException : Microsoft.Identity.ServiceEssentials.Exceptions.MiseException
                {
                    public MiseHostException() => throw null;
                    public MiseHostException(string message) => throw null;
                    public MiseHostException(string message, System.Exception innerException) => throw null;
                    protected MiseHostException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public override string ToString() => throw null;
                }
                public class MiseModuleException : Microsoft.Identity.ServiceEssentials.Exceptions.MiseException
                {
                    public MiseModuleException() => throw null;
                    public MiseModuleException(string message) => throw null;
                    public MiseModuleException(string message, System.Exception innerException) => throw null;
                    protected MiseModuleException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                    public override string ToString() => throw null;
                }
            }
            public static class HeaderNames
            {
                public const string Authorization = default;
                public const string BrokerVersion = default;
                public const string MiseCorrelationIdHeader = default;
            }
            public class HttpRequestData
            {
                public System.Net.IPAddress ClientIpAddress { get => throw null; set { } }
                public HttpRequestData() => throw null;
                public HttpRequestData(System.Collections.Specialized.NameValueCollection headers) => throw null;
                public System.Collections.Specialized.NameValueCollection Headers { get => throw null; }
                public string Method { get => throw null; set { } }
                public void SetRequestHeaders(System.Collections.Specialized.NameValueCollection headers) => throw null;
                public System.Uri Uri { get => throw null; set { } }
            }
            public class HttpResponse
            {
                public byte[] Body { get => throw null; set { } }
                public string ContentType { get => throw null; set { } }
                public System.Collections.Generic.IReadOnlyCollection<System.Net.Cookie> Cookies { get => throw null; set { } }
                public HttpResponse(int statusCode) => throw null;
                public System.Collections.Generic.IReadOnlyDictionary<string, System.Collections.Generic.IEnumerable<string>> Headers { get => throw null; set { } }
                public System.Threading.Tasks.Task SetResponseAsync(Microsoft.Identity.ServiceEssentials.IResponseAdapter response, Microsoft.Identity.ServiceEssentials.MiseHttpContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent middleware) => throw null;
                public int StatusCode { get => throw null; }
            }
            public class HttpSuccessfulResponseBuilder
            {
                public void AddCookie(System.Net.Cookie cookie) => throw null;
                public void AddHeaders(string key, System.Collections.Generic.IEnumerable<string> headerValues) => throw null;
                public Microsoft.Identity.ServiceEssentials.HttpResponse BuildResponse(int statusCode) => throw null;
                public HttpSuccessfulResponseBuilder() => throw null;
            }
            public interface IAggregatedDataProvider<TRequest, TResponse> : Microsoft.Identity.ServiceEssentials.IAggregatedDataProviderBase, Microsoft.Identity.ServiceEssentials.IDataProvider<TRequest, TResponse>, Microsoft.Identity.ServiceEssentials.IDataProviderBase, Microsoft.Identity.ServiceEssentials.IMiseComponent where TRequest : Microsoft.Identity.ServiceEssentials.DataRequest where TResponse : Microsoft.Identity.ServiceEssentials.DataResponse<TResponse>, new()
            {
            }
            public interface IAggregatedDataProviderBase : Microsoft.Identity.ServiceEssentials.IDataProviderBase, Microsoft.Identity.ServiceEssentials.IMiseComponent
            {
                System.Threading.Tasks.Task HandleAggregationResultsAsync(System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.DataExchangeItem> aggregationResults, Microsoft.Identity.ServiceEssentials.MiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IApplicationInformationContainer
            {
                string ClientId { get; }
            }
            public interface IAuthenticationTicketProvider<TMiseContext> : Microsoft.Identity.ServiceEssentials.IMiseComponent where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.AuthenticationTicketProviderResult> AuthenticateAsync(TMiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface ICorrelationIdProvider<TContext>
            {
                string GetCorrelationId(TContext context);
            }
            public interface IDataProvider<TRequest, TResponse> : Microsoft.Identity.ServiceEssentials.IDataProviderBase, Microsoft.Identity.ServiceEssentials.IMiseComponent where TRequest : Microsoft.Identity.ServiceEssentials.DataRequest where TResponse : Microsoft.Identity.ServiceEssentials.DataResponse<TResponse>, new()
            {
            }
            public interface IDataProviderBase : Microsoft.Identity.ServiceEssentials.IMiseComponent
            {
                System.Threading.Tasks.Task HandleAsync(System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.DataExchangeItem> dataItems, Microsoft.Identity.ServiceEssentials.MiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IDataRequestAggregator<TRequest, TResponse> : Microsoft.Identity.ServiceEssentials.IDataRequestAggregatorBase, Microsoft.Identity.ServiceEssentials.IMiseComponent where TRequest : Microsoft.Identity.ServiceEssentials.DataRequest where TResponse : Microsoft.Identity.ServiceEssentials.DataResponse<TResponse>, new()
            {
            }
            public interface IDataRequestAggregatorBase : Microsoft.Identity.ServiceEssentials.IMiseComponent
            {
                System.Threading.Tasks.Task HandleAsync(System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.DataExchangeItem> dataItems, Microsoft.Identity.ServiceEssentials.MiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IDataRequester<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                System.Collections.Generic.IReadOnlyCollection<Microsoft.Identity.ServiceEssentials.IDataProviderBase> GetDataProviders();
                void RequestData(TMiseContext context);
            }
            public interface IDataRequestExtendedRefresh<TRequest, TData> : Microsoft.Identity.ServiceEssentials.IDataRequestRefresh<TRequest, TData> where TRequest : Microsoft.Identity.ServiceEssentials.DataRequest where TData : new()
            {
                System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.CacheItem<TData>> Fetch(Microsoft.Identity.ServiceEssentials.MiseContext context, TRequest request, System.Threading.CancellationToken cancellationToken);
            }
            public interface IDataRequestRefresh<TRequest, TData> where TRequest : Microsoft.Identity.ServiceEssentials.DataRequest where TData : new()
            {
                System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.CacheItem<TData>> Fetch(Microsoft.Identity.ServiceEssentials.MiseContext context, TRequest request);
            }
            public interface IInitializeWithMiseContext
            {
                void InitializeWithMiseContext(Microsoft.Identity.ServiceEssentials.InitializationContext context);
            }
            public interface IIpAddressProvider<TContext>
            {
                System.Net.IPAddress GetIpAddress(TContext context);
            }
            public interface ILogScrubber
            {
                void ScrubLogArguments(params Microsoft.Identity.ServiceEssentials.LogArgument[] args);
            }
            public interface IMiseAuthorizationHeaderProvider
            {
                System.Threading.Tasks.Task<string> CreateAuthorizationHeaderForAppAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, string scopes, Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions downstreamApiOptions = default(Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<string> CreateAuthorizationHeaderForUserAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions authorizationHeaderProviderOptions = default(Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions), System.Security.Claims.ClaimsPrincipal claimsPrincipal = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IMiseCache : Microsoft.Identity.ServiceEssentials.IMiseComponent
            {
                System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.CacheItem<TData>> GetAsync<TData>(Microsoft.Identity.ServiceEssentials.MiseContext context, string key, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TData : new();
                System.Threading.Tasks.Task<System.Collections.Generic.IReadOnlyCollection<Microsoft.Identity.ServiceEssentials.CacheItem<TData>>> GetAsync<TData>(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IReadOnlyCollection<string> keys, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TData : new();
                System.Threading.Tasks.Task RemoveAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, string key, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task RemoveAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IReadOnlyCollection<string> keys, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task SetAsync<TData>(Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.CacheItem<TData> cacheItem, Microsoft.Identity.ServiceEssentials.SetCause cause = default(Microsoft.Identity.ServiceEssentials.SetCause), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TData : new();
                System.Threading.Tasks.Task SetAsync<TData>(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IReadOnlyCollection<Microsoft.Identity.ServiceEssentials.CacheItem<TData>> cacheItems, Microsoft.Identity.ServiceEssentials.SetCause cause = default(Microsoft.Identity.ServiceEssentials.SetCause), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TData : new();
            }
            public interface IMiseComponent
            {
                string Name { get; set; }
            }
            public interface IMiseComponentStatus
            {
                bool Enabled { get; }
            }
            public interface IMiseExtendedLogger : Microsoft.Identity.ServiceEssentials.IMiseLogger
            {
                void Log(Microsoft.Identity.ServiceEssentials.MiseContext context, string message, Microsoft.Identity.ServiceEssentials.LogSeverityLevel logSeverityLevel);
            }
            public interface IMiseHost<TMiseContext> : Microsoft.Identity.ServiceEssentials.IMiseComponent where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.MiseResult<TMiseContext>> HandleAsync(TMiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.MiseResult<TMiseContext>> HandleAsync(TMiseContext context, Microsoft.Identity.ServiceEssentials.MiseHostOptions<TMiseContext> options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IMiseHttpClientFactory
            {
                System.Net.Http.HttpClient GetHttpClient(string name = default(string));
            }
            public interface IMiseLogger
            {
                bool IsEnabled(Microsoft.Identity.ServiceEssentials.LogSeverityLevel logSeverityLevel);
                void Log(string message, Microsoft.Identity.ServiceEssentials.LogSeverityLevel logSeverityLevel);
            }
            public interface IMiseModule<TMiseContext> : Microsoft.Identity.ServiceEssentials.IMiseComponent, Microsoft.Identity.ServiceEssentials.IMiseComponentStatus, Microsoft.Identity.ServiceEssentials.IPostConfigurable where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.ModuleResult> HandleRequestAsync(TMiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }
            public interface IMiseTokenAcquisition
            {
                System.Threading.Tasks.Task<string> AcquireTokenForClientAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IEnumerable<string> scopes);
                System.Threading.Tasks.Task<string> AcquireTokenForClientAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.ServiceEssentials.AcquireTokenOptions acquireTokenOptions);
            }
            public interface IModuleAssociation
            {
                string CollectionName { get; }
                string ModuleName { get; }
                System.Type ModuleType { get; }
                bool Registered { get; set; }
            }
            public interface IModuleContainer<TMiseContext> : System.ICloneable, Microsoft.Identity.ServiceEssentials.IModuleProvider<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                void RegisterModule(Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> miseModule);
            }
            public interface IModuleContainerConfigurationStrategy<TContext> where TContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                Microsoft.Identity.ServiceEssentials.IModuleContainer<TContext> ConfigureModuleContainer();
            }
            public interface IModuleFilter<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> FilterModules(System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> modules);
            }
            public interface IModuleFilterExtended<TMiseContext> : Microsoft.Identity.ServiceEssentials.IModuleFilter<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> FilterModules(TMiseContext context, System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> modules);
            }
            public interface IModuleProvider<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                System.Collections.Generic.IReadOnlyCollection<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> GetModules(TMiseContext context);
            }
            public interface IMultiLevelCacheSupport
            {
                bool IsMultiLevelCachingEnabled();
            }
            public class InitializationContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                public InitializationContext() => throw null;
                public Microsoft.Identity.ServiceEssentials.ILogScrubber GetLogScrubber() => throw null;
                public Microsoft.Identity.ServiceEssentials.IMiseLogger GetMiseLogger() => throw null;
                public Microsoft.Identity.ServiceEssentials.ITelemetryClient GetTelemetryClient() => throw null;
            }
            public interface IPostConfigurable
            {
                void PostConfigureOptions();
            }
            public interface IResponseAdapter
            {
                System.Action<System.Collections.Generic.IReadOnlyCollection<System.Net.Cookie>> AddCookies { get; }
                System.Action<System.Collections.Generic.IReadOnlyDictionary<string, System.Collections.Generic.IEnumerable<string>>> AddResponseHeaders { get; }
                System.IO.Stream ResponseBody { get; }
                string ResponseContentType { get; set; }
                int ResponseStatusCode { get; set; }
            }
            public interface ITelemetryClient
            {
                void OnEvent(Microsoft.Identity.ServiceEssentials.MiseContext context, string message, string componentName, string componentVersion, string eventId, Microsoft.Identity.ServiceEssentials.LogSeverityLevel severity);
            }
            public class LogArgument
            {
                public string Argument { get => throw null; set { } }
                public LogArgument(string arg, Microsoft.Identity.ServiceEssentials.DataClassification dataClassificationCategory) => throw null;
                public Microsoft.Identity.ServiceEssentials.DataClassification DataClassificationCategory { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public static partial class LoggingExtensions
            {
                public static void LogCritical(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogCriticalWithEventId(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string eventId, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogDebug(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogDebugWithEventId(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string eventId, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogError(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogErrorWithEventId(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string eventId, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogInformation(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogInformationWithEventId(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string eventId, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogTrace(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogTraceWithEventId(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string eventId, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogWarning(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static void LogWarningWithEventId(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string eventId, string messageFormat, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static string Scrub(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent, string format, params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
                public static string Scrub(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.LogArgument arg) => throw null;
            }
            public class LogScrubber : Microsoft.Identity.ServiceEssentials.ILogScrubber
            {
                public LogScrubber() => throw null;
                public Microsoft.Identity.ServiceEssentials.DataClassification MinimumDataClassificationCategory { get => throw null; set { } }
                public void ScrubLogArguments(params Microsoft.Identity.ServiceEssentials.LogArgument[] args) => throw null;
            }
            public enum LogSeverityLevel
            {
                Trace = 0,
                Debug = 1,
                Information = 2,
                Warning = 3,
                Error = 4,
                Critical = 5,
            }
            public static partial class MiseAuthenticationBuilderCoreExtensions
            {
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithCustomAuthenticationComponent(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<Microsoft.Identity.ServiceEssentials.MiseHttpContext> ticketProvider) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithDataProviderAuthentication(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, Microsoft.Identity.ServiceEssentials.IMiseTokenAcquisition tokenAcquisition) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithLogScrubber(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, Microsoft.Identity.ServiceEssentials.ILogScrubber logScrubber) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithLogScrubber(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, string dataClassificationCategorySection = default(string)) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithMiseCache(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, Microsoft.Identity.ServiceEssentials.IMiseCache cache) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithModuleFilter(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, Microsoft.Identity.ServiceEssentials.IModuleFilter<Microsoft.Identity.ServiceEssentials.MiseHttpContext> moduleFilter) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration WithTelemetryClient(this Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, Microsoft.Identity.ServiceEssentials.ITelemetryClient telemetryClient) => throw null;
            }
            public class MiseAuthenticationBuilderWithConfiguration
            {
                public Microsoft.Extensions.Configuration.IConfigurationSection AuthenticationConfigurationSection { get => throw null; }
                public Microsoft.Extensions.Configuration.IConfiguration Configuration { get => throw null; }
                public MiseAuthenticationBuilderWithConfiguration(Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration configuration) => throw null;
                public MiseAuthenticationBuilderWithConfiguration(Microsoft.Extensions.DependencyInjection.IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration configuration, string authenticationSectionName, string miseSectionName) => throw null;
                public Microsoft.Extensions.Configuration.IConfigurationSection MiseConfigurationSection { get => throw null; }
                public Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get => throw null; }
            }
            public class MiseAuthorizationHeaderProvider : Microsoft.Identity.ServiceEssentials.IMiseAuthorizationHeaderProvider, Microsoft.Identity.ServiceEssentials.IMiseComponent
            {
                public System.Threading.Tasks.Task<string> CreateAuthorizationHeaderForAppAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, string scopes, Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions downstreamApiOptions = default(Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task<string> CreateAuthorizationHeaderForUserAsync(Microsoft.Identity.ServiceEssentials.MiseContext context, System.Collections.Generic.IEnumerable<string> scopes, Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions authorizationHeaderProviderOptions = default(Microsoft.Identity.Abstractions.AuthorizationHeaderProviderOptions), System.Security.Claims.ClaimsPrincipal claimsPrincipal = default(System.Security.Claims.ClaimsPrincipal), System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public MiseAuthorizationHeaderProvider(Microsoft.Identity.Abstractions.IAuthorizationHeaderProvider authorizationHeaderProvider) => throw null;
                public string Name { get => throw null; set { } }
            }
            public static class MiseBuilder
            {
                public static Microsoft.Identity.ServiceEssentials.Builders.AuthenticationComponentParameterBuilder<Microsoft.Identity.ServiceEssentials.MiseHttpContext> Create(string clientId) => throw null;
                public static Microsoft.Identity.ServiceEssentials.Builders.AuthenticationComponentParameterBuilder<TMiseContext> Create<TMiseContext>(string clientId) where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext => throw null;
                public static Microsoft.Identity.ServiceEssentials.Builders.AuthenticationComponentParameterBuilder<Microsoft.Identity.ServiceEssentials.MiseHttpContext> Create(Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer applicationInformationContainer) => throw null;
                public static Microsoft.Identity.ServiceEssentials.Builders.AuthenticationComponentParameterBuilder<TMiseContext> Create<TMiseContext>(Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer applicationInformationContainer) where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext => throw null;
            }
            public static partial class MiseCacheExtensions
            {
                public static System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.CacheItem<TData>> GetWithRefreshActionAsync<TRequest, TData>(this Microsoft.Identity.ServiceEssentials.IMiseCache cache, Microsoft.Identity.ServiceEssentials.MiseContext context, string cacheKey, TRequest request, Microsoft.Identity.ServiceEssentials.IDataRequestRefresh<TRequest, TData> fetchRefreshValue, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) where TRequest : Microsoft.Identity.ServiceEssentials.DataRequest where TData : new() => throw null;
            }
            public static partial class MiseComponentExtensions
            {
                public static string GetVersion(this Microsoft.Identity.ServiceEssentials.IMiseComponent miseComponent) => throw null;
            }
            public abstract class MiseComponentResult
            {
                protected MiseComponentResult() => throw null;
                public Microsoft.Identity.ServiceEssentials.Exceptions.MiseException Exception { get => throw null; set { } }
                public Microsoft.Identity.ServiceEssentials.IMiseComponent MiseComponent { get => throw null; set { } }
                public bool Succeeded { get => throw null; set { } }
            }
            public abstract class MiseContext
            {
                public virtual void AddDataRequest<TRequest, TResponse, TMiseContext>(Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> moduleRequester, Microsoft.Identity.ServiceEssentials.IDataProvider<TRequest, TResponse> dataProvider, TRequest dataRequest) where TRequest : Microsoft.Identity.ServiceEssentials.DataRequest where TResponse : Microsoft.Identity.ServiceEssentials.DataResponse<TResponse>, new() where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext => throw null;
                public Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer ApplicationInformation { get => throw null; set { } }
                public Microsoft.Identity.ServiceEssentials.AuthenticationTicket AuthenticationTicket { get => throw null; set { } }
                public string CorrelationId { get => throw null; set { } }
                protected MiseContext() => throw null;
                public virtual Microsoft.Identity.ServiceEssentials.DataResponseItem GetDataResponseItem<TMiseContext>(Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> moduleRequester, string dataRequestKey) where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext => throw null;
                public System.Collections.Generic.IDictionary<string, object> PropertyBag { get => throw null; }
            }
            public static partial class MiseContextExtensions
            {
                public static Microsoft.Identity.ServiceEssentials.AuthenticationTicket GetContextAuthenticationTicket(this Microsoft.Identity.ServiceEssentials.MiseContext context) => throw null;
                public static void SetContextAuthenticationTicket(this Microsoft.Identity.ServiceEssentials.MiseContext context, Microsoft.Identity.ServiceEssentials.AuthenticationTicket authenticationTicket) => throw null;
            }
            public static class MiseDefaults
            {
                public const string AuthenticationConfigurationSectionName = default;
                public const string ContextAuthenticationTicketProviderName = default;
                public const string MiseConfigurationSectionName = default;
            }
            public static class MiseEventIds
            {
                public const string AuthenticationFailed = default;
                public const string AuthenticationSucceeded = default;
                public const string MiseFailed = default;
                public const string MiseSucceeded = default;
                public const string ModuleFailed = default;
                public const string ModuleSucceeded = default;
            }
            public class MiseHost<TMiseContext> : Microsoft.Identity.ServiceEssentials.IMiseComponent, Microsoft.Identity.ServiceEssentials.IMiseHost<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                public Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<TMiseContext> AuthenticationTicketProvider { get => throw null; }
                public MiseHost(Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<TMiseContext> authenticationTicketProvider, Microsoft.Identity.ServiceEssentials.IModuleProvider<TMiseContext> moduleProvider, Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer applicationInformationContainer) => throw null;
                public MiseHost(Microsoft.Identity.ServiceEssentials.IAuthenticationTicketProvider<TMiseContext> authenticationTicketProvider, Microsoft.Identity.ServiceEssentials.IModuleProvider<TMiseContext> moduleProvider, Microsoft.Identity.ServiceEssentials.IMiseLogger logger, Microsoft.Identity.ServiceEssentials.ITelemetryClient telemetryClient, Microsoft.Identity.ServiceEssentials.ILogScrubber logscrubber, Microsoft.Identity.ServiceEssentials.IApplicationInformationContainer applicationInformationContainer) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.MiseResult<TMiseContext>> HandleAsync(TMiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.MiseResult<TMiseContext>> HandleAsync(TMiseContext context, Microsoft.Identity.ServiceEssentials.MiseHostOptions<TMiseContext> options, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public Microsoft.Identity.ServiceEssentials.IMiseLogger Logger { get => throw null; set { } }
                public Microsoft.Identity.ServiceEssentials.ILogScrubber LogScrubber { get => throw null; set { } }
                public Microsoft.Identity.ServiceEssentials.IModuleFilter<TMiseContext> ModuleFilter { get => throw null; set { } }
                public Microsoft.Identity.ServiceEssentials.IModuleProvider<TMiseContext> ModuleProvider { get => throw null; }
                public string Name { get => throw null; set { } }
                public Microsoft.Identity.ServiceEssentials.ITelemetryClient TelemetryClient { get => throw null; set { } }
            }
            public class MiseHostOptions<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                public MiseHostOptions() => throw null;
            }
            public class MiseHttpContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                public MiseHttpContext(Microsoft.Identity.ServiceEssentials.HttpRequestData httpRequestData) => throw null;
                public MiseHttpContext(Microsoft.Identity.ServiceEssentials.HttpRequestData httpRequestData, System.Collections.Generic.IReadOnlyList<Microsoft.Identity.ServiceEssentials.Attributes.IMiseAttribute> miseAttributes) => throw null;
                public System.Collections.Generic.IReadOnlyList<Microsoft.Identity.ServiceEssentials.Attributes.IMiseAttribute> EndpointAttributes { get => throw null; }
                public Microsoft.Identity.ServiceEssentials.HttpRequestData HttpRequestData { get => throw null; set { } }
                public Microsoft.Identity.ServiceEssentials.HttpSuccessfulResponseBuilder HttpSuccessfulResponseBuilder { get => throw null; }
                public Microsoft.Identity.ServiceEssentials.HttpResponse ModuleFailureResponse { get => throw null; set { } }
            }
            public class MiseLogger : Microsoft.IdentityModel.Abstractions.IIdentityLogger, Microsoft.Identity.ServiceEssentials.IMiseLogger
            {
                public MiseLogger(Microsoft.Extensions.Logging.ILogger logger) => throw null;
                public bool IsEnabled(Microsoft.Identity.ServiceEssentials.LogSeverityLevel logSeverityLevel) => throw null;
                public bool IsEnabled(Microsoft.IdentityModel.Abstractions.EventLogLevel eventLogLevel) => throw null;
                public void Log(string message, Microsoft.Identity.ServiceEssentials.LogSeverityLevel severityLevel) => throw null;
                public void Log(Microsoft.IdentityModel.Abstractions.LogEntry entry) => throw null;
            }
            public abstract class MiseModule<TMiseContext, TOptions> : Microsoft.Identity.ServiceEssentials.IMiseComponent, Microsoft.Identity.ServiceEssentials.IMiseComponentStatus, Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>, Microsoft.Identity.ServiceEssentials.IPostConfigurable where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext where TOptions : Microsoft.Identity.ServiceEssentials.MiseModuleOptions, new()
            {
                public bool AuditMode { get => throw null; }
                protected MiseModule(TOptions options) => throw null;
                protected MiseModule(Microsoft.Extensions.Options.IOptionsMonitor<TOptions> options) => throw null;
                public bool Enabled { get => throw null; }
                protected abstract System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.ModuleResult> HandleAsync(TMiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.Task<Microsoft.Identity.ServiceEssentials.ModuleResult> HandleRequestAsync(TMiseContext context, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract string Name { get; set; }
                public TOptions Options { get => throw null; }
                public virtual void PostConfigureOptions() => throw null;
            }
            public abstract class MiseModuleOptions
            {
                public bool AuditMode { get => throw null; set { } }
                protected MiseModuleOptions() => throw null;
                public bool Enabled { get => throw null; set { } }
            }
            public class MiseResult<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                public Microsoft.Identity.ServiceEssentials.AuthenticationTicket AuthenticationTicket { get => throw null; set { } }
                public string CorrelationId { get => throw null; set { } }
                protected MiseResult() => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseResult<TMiseContext> Fail(TMiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent host) => throw null;
                public static Microsoft.Identity.ServiceEssentials.MiseResult<TMiseContext> Fail(TMiseContext context, Microsoft.Identity.ServiceEssentials.IMiseComponent host, Microsoft.Identity.ServiceEssentials.Exceptions.MiseException failure) => throw null;
                public System.Exception Failure { get => throw null; set { } }
                public TMiseContext MiseContext { get => throw null; set { } }
                public bool Succeeded { get => throw null; set { } }
                public static Microsoft.Identity.ServiceEssentials.MiseResult<TMiseContext> Success(TMiseContext context, Microsoft.Identity.ServiceEssentials.AuthenticationTicket authTicket, Microsoft.Identity.ServiceEssentials.IMiseComponent host) => throw null;
            }
            public class ModuleAssociation : Microsoft.Identity.ServiceEssentials.IModuleAssociation
            {
                public string CollectionName { get => throw null; }
                public ModuleAssociation(System.Type module, string name, string collectionName = default(string)) => throw null;
                public const string DefaultCollectionName = default;
                public string ModuleName { get => throw null; }
                public System.Type ModuleType { get => throw null; }
                public bool Registered { get => throw null; set { } }
            }
            public class ModuleContainer<TMiseContext> : System.ICloneable, Microsoft.Identity.ServiceEssentials.IModuleContainer<TMiseContext>, Microsoft.Identity.ServiceEssentials.IModuleProvider<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                public object Clone() => throw null;
                public ModuleContainer() => throw null;
                public System.Collections.Generic.IReadOnlyCollection<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> GetModules(TMiseContext context) => throw null;
                public void RegisterModule(Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> miseModule) => throw null;
            }
            public class ModuleFilter<TMiseContext> : Microsoft.Identity.ServiceEssentials.IModuleFilter<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                public ModuleFilter(System.Collections.Generic.IReadOnlyCollection<string> filterList) => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> FilterModules(System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> modules) => throw null;
            }
            public class ModuleResult : Microsoft.Identity.ServiceEssentials.MiseComponentResult
            {
                protected ModuleResult() => throw null;
                public static Microsoft.Identity.ServiceEssentials.ModuleResult Fail(Microsoft.Identity.ServiceEssentials.IMiseComponent module, Microsoft.Identity.ServiceEssentials.MiseContext context) => throw null;
                public static Microsoft.Identity.ServiceEssentials.ModuleResult Fail(Microsoft.Identity.ServiceEssentials.IMiseComponent module, Microsoft.Identity.ServiceEssentials.MiseContext context, System.Exception exception) => throw null;
                public static Microsoft.Identity.ServiceEssentials.ModuleResult Success(Microsoft.Identity.ServiceEssentials.IMiseComponent module, Microsoft.Identity.ServiceEssentials.MiseContext context) => throw null;
            }
            public class NullMiseLogger : Microsoft.Identity.ServiceEssentials.IMiseLogger
            {
                public static Microsoft.Identity.ServiceEssentials.NullMiseLogger Instance { get => throw null; }
                public bool IsEnabled(Microsoft.Identity.ServiceEssentials.LogSeverityLevel logLevel) => throw null;
                public void Log(string message, Microsoft.Identity.ServiceEssentials.LogSeverityLevel logLevel) => throw null;
            }
            public class NullModuleFilter<TMiseContext> : Microsoft.Identity.ServiceEssentials.IModuleFilter<TMiseContext> where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext
            {
                public NullModuleFilter() => throw null;
                public System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> FilterModules(System.Collections.Generic.IEnumerable<Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext>> modules) => throw null;
            }
            public class NullTelemetryClient : Microsoft.Identity.ServiceEssentials.ITelemetryClient
            {
                public NullTelemetryClient() => throw null;
                public void OnEvent(Microsoft.Identity.ServiceEssentials.MiseContext context, string message, string componentName, string componentVersion, string eventId, Microsoft.Identity.ServiceEssentials.LogSeverityLevel severity) => throw null;
            }
            public static class PropertyBagReservedKeys
            {
                public const string ContextAuthenticationTicket = default;
                public const string HttpContext = default;
            }
            public static class RegistrationConstants
            {
                public const string DefaultSectionName = default;
            }
            public static class Registrations
            {
                public static void RegisterModule<TMiseContext, TModule, TOptions>(Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, string moduleName) where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext where TModule : Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> where TOptions : class => throw null;
                public static void RegisterModule<TMiseContext, TModule, TOptions>(Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, string sectionName, string moduleName) where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext where TModule : Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> where TOptions : class => throw null;
                public static void RegisterModule<TMiseContext, TModule, TOptions>(Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, string moduleName, System.Action<TOptions> configureOptions) where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext where TModule : Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> where TOptions : class => throw null;
                public static void RegisterModule<TMiseContext, TModule>(Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, string moduleName) where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext where TModule : Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> => throw null;
                public static void RegisterModule<TMiseContext, TModule>(Microsoft.Identity.ServiceEssentials.MiseAuthenticationBuilderWithConfiguration builder, TModule module, string moduleName) where TMiseContext : Microsoft.Identity.ServiceEssentials.MiseContext where TModule : Microsoft.Identity.ServiceEssentials.IMiseModule<TMiseContext> => throw null;
            }
            public enum SetCause
            {
                SetValue = 0,
                ValueExpired = 1,
                PreemptiveRefresh = 2,
            }
            public static class Utility
            {
                public static string GetBrokerVersion() => throw null;
                public static string GetMiseCoreTarget() => throw null;
                public static string GetOsVersion() => throw null;
            }
        }
    }
}
