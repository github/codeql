// This file contains auto-generated code.
// Generated from `ServiceStack.Client, Version=6.0.0.0, Culture=neutral, PublicKeyToken=null`.
namespace ServiceStack
{
    public class AdminCreateUser : ServiceStack.AdminUserBase, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.AdminUserResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public AdminCreateUser() => throw null;
        public System.Collections.Generic.List<string> Permissions { get => throw null; set { } }
        public System.Collections.Generic.List<string> Roles { get => throw null; set { } }
    }
    public class AdminDatabaseInfo : ServiceStack.IMeta
    {
        public AdminDatabaseInfo() => throw null;
        public System.Collections.Generic.List<ServiceStack.DatabaseInfo> Databases { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public int QueryLimit { get => throw null; set { } }
    }
    public class AdminDeleteUser : ServiceStack.IDelete, ServiceStack.IReturn<ServiceStack.AdminDeleteUserResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public AdminDeleteUser() => throw null;
        public string Id { get => throw null; set { } }
    }
    public class AdminDeleteUserResponse : ServiceStack.IHasResponseStatus
    {
        public AdminDeleteUserResponse() => throw null;
        public string Id { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    public class AdminGetUser : ServiceStack.IGet, ServiceStack.IReturn<ServiceStack.AdminUserResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public AdminGetUser() => throw null;
        public string Id { get => throw null; set { } }
    }
    public class AdminQueryUsers : ServiceStack.IGet, ServiceStack.IReturn<ServiceStack.AdminUsersResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public AdminQueryUsers() => throw null;
        public string OrderBy { get => throw null; set { } }
        public string Query { get => throw null; set { } }
        public int? Skip { get => throw null; set { } }
        public int? Take { get => throw null; set { } }
    }
    public class AdminRedisInfo : ServiceStack.IMeta
    {
        public AdminRedisInfo() => throw null;
        public System.Collections.Generic.List<int> Databases { get => throw null; set { } }
        public ServiceStack.RedisEndpointInfo Endpoint { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public bool? ModifiableConnection { get => throw null; set { } }
        public int QueryLimit { get => throw null; set { } }
    }
    public class AdminUi
    {
        public ServiceStack.ApiCss Css { get => throw null; set { } }
        public AdminUi() => throw null;
    }
    public class AdminUpdateUser : ServiceStack.AdminUserBase, ServiceStack.IPut, ServiceStack.IReturn<ServiceStack.AdminUserResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public System.Collections.Generic.List<string> AddPermissions { get => throw null; set { } }
        public System.Collections.Generic.List<string> AddRoles { get => throw null; set { } }
        public AdminUpdateUser() => throw null;
        public string Id { get => throw null; set { } }
        public bool? LockUser { get => throw null; set { } }
        public System.Collections.Generic.List<string> RemovePermissions { get => throw null; set { } }
        public System.Collections.Generic.List<string> RemoveRoles { get => throw null; set { } }
        public bool? UnlockUser { get => throw null; set { } }
    }
    public abstract class AdminUserBase : ServiceStack.IMeta
    {
        protected AdminUserBase() => throw null;
        public string DisplayName { get => throw null; set { } }
        public string Email { get => throw null; set { } }
        public string FirstName { get => throw null; set { } }
        public string LastName { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Password { get => throw null; set { } }
        public string ProfileUrl { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> UserAuthProperties { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
    }
    public class AdminUserResponse : ServiceStack.IHasResponseStatus
    {
        public AdminUserResponse() => throw null;
        public System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object>> Details { get => throw null; set { } }
        public string Id { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, object> Result { get => throw null; set { } }
    }
    public class AdminUsersInfo : ServiceStack.IMeta
    {
        public string AccessRole { get => throw null; set { } }
        public System.Collections.Generic.List<string> AllPermissions { get => throw null; set { } }
        public System.Collections.Generic.List<string> AllRoles { get => throw null; set { } }
        public ServiceStack.ApiCss Css { get => throw null; set { } }
        public AdminUsersInfo() => throw null;
        public System.Collections.Generic.List<string> Enabled { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.InputInfo> FormLayout { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.MediaRule> QueryMediaRules { get => throw null; set { } }
        public System.Collections.Generic.List<string> QueryUserAuthProperties { get => throw null; set { } }
        public ServiceStack.MetadataType UserAuth { get => throw null; set { } }
    }
    public class AdminUsersResponse : ServiceStack.IHasResponseStatus
    {
        public AdminUsersResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object>> Results { get => throw null; set { } }
    }
    public static class AesUtils
    {
        public const int BlockSize = 128;
        public const int BlockSizeBytes = 16;
        public static string CreateBase64Key() => throw null;
        public static void CreateCryptAuthKeysAndIv(out byte[] cryptKey, out byte[] authKey, out byte[] iv) => throw null;
        public static byte[] CreateIv() => throw null;
        public static byte[] CreateKey() => throw null;
        public static void CreateKeyAndIv(out byte[] cryptKey, out byte[] iv) => throw null;
        public static System.Security.Cryptography.SymmetricAlgorithm CreateSymmetricAlgorithm() => throw null;
        public static string Decrypt(string encryptedBase64, byte[] cryptKey, byte[] iv) => throw null;
        public static byte[] Decrypt(byte[] encryptedBytes, byte[] cryptKey, byte[] iv) => throw null;
        public static string Encrypt(string text, byte[] cryptKey, byte[] iv) => throw null;
        public static byte[] Encrypt(byte[] bytesToEncrypt, byte[] cryptKey, byte[] iv) => throw null;
        public const int KeySize = 256;
        public const int KeySizeBytes = 32;
    }
    public class ApiCss
    {
        public ApiCss() => throw null;
        public string Field { get => throw null; set { } }
        public string Fieldset { get => throw null; set { } }
        public string Form { get => throw null; set { } }
    }
    public class ApiDescription
    {
        public ApiDescription() => throw null;
        public string Description { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Links { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string Notes { get => throw null; set { } }
        public string Returns { get => throw null; set { } }
    }
    public class ApiFormat
    {
        public bool AssumeUtc { get => throw null; set { } }
        public ApiFormat() => throw null;
        public ServiceStack.FormatInfo Date { get => throw null; set { } }
        public string Locale { get => throw null; set { } }
        public ServiceStack.FormatInfo Number { get => throw null; set { } }
    }
    public static class ApiResult
    {
        public static ServiceStack.ApiResult<TResponse> Create<TResponse>(TResponse response) => throw null;
        public static ServiceStack.ApiResult<TResponse> CreateError<TResponse>(ServiceStack.ResponseStatus errorStatus) => throw null;
        public static ServiceStack.ApiResult<ServiceStack.EmptyResponse> CreateError(ServiceStack.ResponseStatus errorStatus) => throw null;
        public static ServiceStack.ApiResult<TResponse> CreateError<TResponse>(string message, string errorCode = default(string)) => throw null;
        public static ServiceStack.ApiResult<ServiceStack.EmptyResponse> CreateError(string message, string errorCode = default(string)) => throw null;
        public static ServiceStack.ApiResult<TResponse> CreateError<TResponse>(System.Exception ex) => throw null;
        public static ServiceStack.ApiResult<ServiceStack.EmptyResponse> CreateError(System.Exception ex) => throw null;
        public static ServiceStack.ApiResult<TResponse> CreateFieldError<TResponse>(string fieldName, string message, string errorCode = default(string)) => throw null;
        public static ServiceStack.ApiResult<ServiceStack.EmptyResponse> CreateFieldError(string fieldName, string message, string errorCode = default(string)) => throw null;
        public const string FieldErrorCode = default;
    }
    public class ApiResult<TResponse> : ServiceStack.IHasErrorStatus
    {
        public void AddFieldError(string fieldName, string message, string errorCode = default(string)) => throw null;
        public void ClearErrors() => throw null;
        public bool Completed { get => throw null; }
        public ApiResult() => throw null;
        public ApiResult(TResponse response) => throw null;
        public ApiResult(ServiceStack.ResponseStatus errorStatus) => throw null;
        public ServiceStack.ResponseStatus Error { get => throw null; }
        public string ErrorMessage { get => throw null; }
        public ServiceStack.ResponseError[] Errors { get => throw null; }
        public string ErrorSummary { get => throw null; }
        public bool Failed { get => throw null; }
        public ServiceStack.ResponseError FieldError(string fieldName) => throw null;
        public string FieldErrorMessage(string fieldName) => throw null;
        public bool HasFieldError(string fieldName) => throw null;
        public bool IsLoading { get => throw null; set { } }
        public TResponse Response { get => throw null; }
        public void SetError(string errorMessage, string errorCode = default(string)) => throw null;
        public string StackTrace { get => throw null; set { } }
        public bool Succeeded { get => throw null; }
    }
    public static class ApiResultUtils
    {
        public static ServiceStack.ApiResult<TResponse> Api<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> request) => throw null;
        public static ServiceStack.ApiResult<ServiceStack.EmptyResponse> Api(this ServiceStack.IServiceClient client, ServiceStack.IReturnVoid request) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> request) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<ServiceStack.EmptyResponse>> ApiAsync(this ServiceStack.IServiceClient client, ServiceStack.IReturnVoid request) => throw null;
        public static void ThrowIfError<TResponse>(this ServiceStack.ApiResult<TResponse> api) => throw null;
        public static ServiceStack.ApiResult<TResponse> ToApiResult<TResponse>(this System.Exception ex) => throw null;
        public static ServiceStack.ApiResult<ServiceStack.EmptyResponse> ToApiResult(this System.Exception ex) => throw null;
        public static ServiceStack.AuthenticateResponse ToAuthenticateResponse(this ServiceStack.RegisterResponse from) => throw null;
    }
    public class ApiUiInfo : ServiceStack.IMeta
    {
        public ApiUiInfo() => throw null;
        public ServiceStack.ApiCss ExplorerCss { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.InputInfo> FormLayout { get => throw null; set { } }
        public ServiceStack.ApiCss LocodeCss { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
    }
    public class AppInfo : ServiceStack.IMeta
    {
        public string ApiVersion { get => throw null; set { } }
        public string BackgroundColor { get => throw null; set { } }
        public string BackgroundImageUrl { get => throw null; set { } }
        public string BaseUrl { get => throw null; set { } }
        public string BrandImageUrl { get => throw null; set { } }
        public string BrandUrl { get => throw null; set { } }
        public AppInfo() => throw null;
        public string IconUrl { get => throw null; set { } }
        public string JsTextCase { get => throw null; set { } }
        public string LinkColor { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string ServiceDescription { get => throw null; set { } }
        public string ServiceIconUrl { get => throw null; set { } }
        public string ServiceName { get => throw null; set { } }
        public string ServiceStackVersion { get => throw null; }
        public string TextColor { get => throw null; set { } }
    }
    public class AppMetadata : ServiceStack.IMeta
    {
        public ServiceStack.MetadataTypes Api { get => throw null; set { } }
        public ServiceStack.AppInfo App { get => throw null; set { } }
        public ServiceStack.AppMetadataCache Cache { get => throw null; set { } }
        public ServiceStack.ConfigInfo Config { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> ContentTypeFormats { get => throw null; set { } }
        public AppMetadata() => throw null;
        public System.Collections.Generic.Dictionary<string, ServiceStack.CustomPluginInfo> CustomPlugins { get => throw null; set { } }
        public System.DateTime Date { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> HttpHandlers { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.PluginInfo Plugins { get => throw null; set { } }
        public ServiceStack.UiInfo Ui { get => throw null; set { } }
    }
    public class AppMetadataCache
    {
        public AppMetadataCache(System.Collections.Generic.Dictionary<string, ServiceStack.MetadataOperationType> operationsMap, System.Collections.Generic.Dictionary<string, ServiceStack.MetadataType> typesMap) => throw null;
        public System.Collections.Generic.Dictionary<string, ServiceStack.MetadataOperationType> OperationsMap { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, ServiceStack.MetadataType> TypesMap { get => throw null; set { } }
    }
    public static class AppMetadataUtils
    {
        public static ServiceStack.RefInfo CreateRef(this ServiceStack.AppMetadata meta, ServiceStack.MetadataType type, ServiceStack.MetadataPropertyType p) => throw null;
        public static ServiceStack.RefInfo CreateRef(this ServiceStack.MetadataPropertyType p) => throw null;
        public static ServiceStack.RefInfo CreateRefModel(this ServiceStack.AppMetadata meta, string model) => throw null;
        public static ServiceStack.RefInfo CreateRefModel(this System.Type refType) => throw null;
        public static void EachOperation(this ServiceStack.AppMetadata app, System.Action<ServiceStack.MetadataOperationType> configure) => throw null;
        public static void EachOperation(this ServiceStack.AppMetadata app, System.Action<ServiceStack.MetadataOperationType> configure, System.Predicate<ServiceStack.MetadataOperationType> where) => throw null;
        public static void EachProperty(this ServiceStack.MetadataType type, System.Func<ServiceStack.MetadataPropertyType, bool> where, System.Action<ServiceStack.MetadataPropertyType> configure) => throw null;
        public static void EachType(this ServiceStack.AppMetadata app, System.Action<ServiceStack.MetadataType> configure) => throw null;
        public static void EachType(this ServiceStack.AppMetadata app, System.Action<ServiceStack.MetadataType> configure, System.Predicate<ServiceStack.MetadataType> where) => throw null;
        public static System.Collections.Generic.List<ServiceStack.MetadataPropertyType> GetAllMetadataProperties(this System.Type type) => throw null;
        public static System.Collections.Generic.List<ServiceStack.MetadataPropertyType> GetAllProperties(this ServiceStack.AppMetadata api, string typeName) => throw null;
        public static System.Collections.Generic.List<ServiceStack.MetadataPropertyType> GetAllProperties(this ServiceStack.AppMetadata api, string @namespace, string typeName) => throw null;
        public static System.Collections.Generic.List<ServiceStack.MetadataPropertyType> GetAllProperties(this ServiceStack.AppMetadata api, ServiceStack.MetadataType metaType) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.AppMetadata> GetAppMetadataAsync(this string baseUrl) => throw null;
        public static ServiceStack.AppMetadataCache GetCache(this ServiceStack.AppMetadata app) => throw null;
        public static ServiceStack.ImageInfo GetIcon(this System.Type type) => throw null;
        public static ServiceStack.ImageInfo GetIcon(this ServiceStack.MetadataType type) => throw null;
        public static object GetId<T>(this ServiceStack.MetadataType type, T model) => throw null;
        public static object GetId<T>(this System.Collections.Generic.List<ServiceStack.MetadataPropertyType> props, T model) => throw null;
        public static System.Reflection.PropertyInfo[] GetInstancePublicProperties(this System.Type type) => throw null;
        public static ServiceStack.MetadataOperationType GetOperation(this ServiceStack.AppMetadata app, string name) => throw null;
        public static ServiceStack.MetadataPropertyType GetPrimaryKey(this System.Collections.Generic.List<ServiceStack.MetadataPropertyType> props) => throw null;
        public static System.Reflection.PropertyInfo GetPrimaryKey(this System.Reflection.PropertyInfo[] props) => throw null;
        public static System.Type GetResponseType(this System.Type requestType) => throw null;
        public static string GetSerializedAlias(this ServiceStack.MetadataPropertyType prop) => throw null;
        public static ServiceStack.MetadataType GetType(this ServiceStack.AppMetadata app, System.Type type) => throw null;
        public static ServiceStack.MetadataType GetType(this ServiceStack.AppMetadata app, string name) => throw null;
        public static ServiceStack.MetadataType GetType(this ServiceStack.AppMetadata app, ServiceStack.MetadataTypeName typeRef) => throw null;
        public static ServiceStack.MetadataType GetType(this ServiceStack.AppMetadata app, string @namespace, string name) => throw null;
        public static object GetValue<T>(this ServiceStack.MetadataPropertyType prop, T model) => throw null;
        public static bool IsSystemType(this ServiceStack.MetadataPropertyType prop) => throw null;
        public static void PopulateInput(this ServiceStack.MetadataPropertyType property, ServiceStack.InputInfo input) => throw null;
        public static System.Collections.Generic.List<ServiceStack.MetadataPropertyType> PopulatePrimaryKey(this System.Collections.Generic.List<ServiceStack.MetadataPropertyType> props) => throw null;
        public static ServiceStack.MetadataPropertyType Property(this ServiceStack.MetadataType type, string name) => throw null;
        public static void Property(this ServiceStack.MetadataType type, string name, System.Action<ServiceStack.MetadataPropertyType> configure) => throw null;
        public static string PropertyStringValue(this System.Reflection.PropertyInfo pi, object instance, object ignoreIfValue = default(object)) => throw null;
        public static string PropertyValueAsString(this System.Reflection.PropertyInfo pi, object value) => throw null;
        public static void RemoveProperty(this ServiceStack.MetadataType type, System.Predicate<ServiceStack.MetadataPropertyType> where) => throw null;
        public static void RemoveProperty(this ServiceStack.MetadataType type, string name) => throw null;
        public static ServiceStack.MetadataPropertyType ReorderProperty(this ServiceStack.MetadataType type, string name, string before = default(string), string after = default(string)) => throw null;
        public static ServiceStack.MetadataPropertyType ReorderProperty(this ServiceStack.MetadataType type, string name, int index) => throw null;
        public static ServiceStack.MetadataPropertyType RequiredProperty(this ServiceStack.MetadataType type, string name) => throw null;
        public static ServiceStack.FieldCss ToCss(this ServiceStack.FieldCssAttribute attr) => throw null;
        public static ServiceStack.MetadataDataMember ToDataMember(this System.Runtime.Serialization.DataMemberAttribute attr) => throw null;
        public static ServiceStack.FormatInfo ToFormat(this ServiceStack.FormatAttribute attr) => throw null;
        public static ServiceStack.FormatInfo ToFormat(this ServiceStack.Intl attr) => throw null;
        public static string[] ToGenericArgs(this System.Type propType) => throw null;
        public static ServiceStack.InputInfo ToInput(this ServiceStack.InputAttributeBase input, System.Action<ServiceStack.InputInfo> configure = default(System.Action<ServiceStack.InputInfo>)) => throw null;
        public static ServiceStack.MetadataPropertyType ToMetadataPropertyType(this System.Reflection.PropertyInfo pi, object instance = default(object), System.Collections.Generic.Dictionary<string, object> ignoreValues = default(System.Collections.Generic.Dictionary<string, object>), bool treatNonNullableRefTypesAsRequired = default(bool)) => throw null;
        public static ServiceStack.MetadataType ToMetadataType(this System.Type type) => throw null;
        public static System.Collections.Generic.List<ServiceStack.MetadataPropertyType> ToProperties(System.Type type, System.Func<System.Reflection.PropertyInfo, ServiceStack.MetadataPropertyType> toProperty, System.Collections.Generic.HashSet<System.Type> exportTypes = default(System.Collections.Generic.HashSet<System.Type>)) => throw null;
    }
    public class AppTags
    {
        public AppTags() => throw null;
        public string Default { get => throw null; set { } }
        public string Other { get => throw null; set { } }
    }
    public class AssignRoles : ServiceStack.IMeta, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.AssignRolesResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public AssignRoles() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.List<string> Permissions { get => throw null; set { } }
        public System.Collections.Generic.List<string> Roles { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
    }
    public class AssignRolesResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public System.Collections.Generic.List<string> AllPermissions { get => throw null; set { } }
        public System.Collections.Generic.List<string> AllRoles { get => throw null; set { } }
        public AssignRolesResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    public class AsyncServiceClient : ServiceStack.IHasBearerToken, ServiceStack.IHasSessionId, ServiceStack.IHasVersion
    {
        public bool AlwaysSendBasicAuthHeader { get => throw null; set { } }
        public string BaseUri { get => throw null; set { } }
        public string BearerToken { get => throw null; set { } }
        public static int BufferSize;
        public string ContentType { get => throw null; set { } }
        public System.Net.CookieContainer CookieContainer { get => throw null; set { } }
        public System.Net.ICredentials Credentials { get => throw null; set { } }
        public AsyncServiceClient() => throw null;
        public bool DisableAutoCompression { get => throw null; set { } }
        public static bool DisableTimer { get => throw null; set { } }
        public void Dispose() => throw null;
        public bool EmulateHttpViaPost { get => throw null; set { } }
        public bool EnableAutoRefreshToken { get => throw null; set { } }
        public ServiceStack.ExceptionFilterDelegate ExceptionFilter { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> GetCookieValues() => throw null;
        public static System.Action<System.Net.HttpWebRequest> GlobalRequestFilter { get => throw null; set { } }
        public static System.Action<System.Net.HttpWebResponse> GlobalResponseFilter { get => throw null; set { } }
        public System.Collections.Specialized.NameValueCollection Headers { get => throw null; set { } }
        public System.Net.Http.HttpClient HttpClient { get => throw null; set { } }
        public System.Text.StringBuilder HttpLog { get => throw null; set { } }
        public System.Action<System.Text.StringBuilder> HttpLogFilter { get => throw null; set { } }
        public System.Action OnAuthenticationRequired { get => throw null; set { } }
        public ServiceStack.ProgressDelegate OnDownloadProgress { get => throw null; set { } }
        public ServiceStack.ProgressDelegate OnUploadProgress { get => throw null; set { } }
        public string Password { get => throw null; set { } }
        public System.Net.IWebProxy Proxy { get => throw null; set { } }
        public string RefreshToken { get => throw null; set { } }
        public string RefreshTokenUri { get => throw null; set { } }
        public string RequestCompressionType { get => throw null; set { } }
        public System.Action<System.Net.HttpWebRequest> RequestFilter { get => throw null; set { } }
        public System.Action<System.Net.HttpWebResponse> ResponseFilter { get => throw null; set { } }
        public ServiceStack.ResultsFilterDelegate ResultsFilter { get => throw null; set { } }
        public ServiceStack.ResultsFilterResponseDelegate ResultsFilterResponse { get => throw null; set { } }
        public System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(string httpMethod, string absoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public string SessionId { get => throw null; set { } }
        public void SetCredentials(string userName, string password) => throw null;
        public bool ShareCookiesWithBrowser { get => throw null; set { } }
        public bool StoreCookies { get => throw null; set { } }
        public ServiceStack.Web.StreamDeserializerDelegate StreamDeserializer { get => throw null; set { } }
        public ServiceStack.Web.StreamSerializerDelegate StreamSerializer { get => throw null; set { } }
        public System.TimeSpan? Timeout { get => throw null; set { } }
        public string UserAgent { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
        public int Version { get => throw null; set { } }
    }
    public class AsyncTimer : System.IDisposable, ServiceStack.ITimer
    {
        public void Cancel() => throw null;
        public AsyncTimer(System.Threading.Timer timer) => throw null;
        public void Dispose() => throw null;
        public System.Threading.Timer Timer;
    }
    public class Authenticate : ServiceStack.IMeta, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.AuthenticateResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public string AccessToken { get => throw null; set { } }
        public string AccessTokenSecret { get => throw null; set { } }
        public string cnonce { get => throw null; set { } }
        public Authenticate() => throw null;
        public Authenticate(string provider) => throw null;
        public string ErrorView { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string nc { get => throw null; set { } }
        public string nonce { get => throw null; set { } }
        public string oauth_token { get => throw null; set { } }
        public string oauth_verifier { get => throw null; set { } }
        public string Password { get => throw null; set { } }
        public string provider { get => throw null; set { } }
        public string qop { get => throw null; set { } }
        public bool? RememberMe { get => throw null; set { } }
        public string response { get => throw null; set { } }
        public string ReturnUrl { get => throw null; set { } }
        public string scope { get => throw null; set { } }
        public string State { get => throw null; set { } }
        public string uri { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
    }
    public class AuthenticateResponse : ServiceStack.IHasBearerToken, ServiceStack.IHasRefreshToken, ServiceStack.IHasResponseStatus, ServiceStack.IHasSessionId, ServiceStack.IMeta
    {
        public string BearerToken { get => throw null; set { } }
        public AuthenticateResponse() => throw null;
        public string DisplayName { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.List<string> Permissions { get => throw null; set { } }
        public string ProfileUrl { get => throw null; set { } }
        public string ReferrerUrl { get => throw null; set { } }
        public string RefreshToken { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<string> Roles { get => throw null; set { } }
        public string SessionId { get => throw null; set { } }
        public string UserId { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
    }
    public class AuthenticationException : System.Exception, ServiceStack.IHasStatusCode
    {
        public AuthenticationException() => throw null;
        public AuthenticationException(string message) => throw null;
        public AuthenticationException(string message, System.Exception innerException) => throw null;
        public int StatusCode { get => throw null; }
    }
    public class AuthenticationInfo
    {
        public string cnonce { get => throw null; set { } }
        public AuthenticationInfo(string authHeader) => throw null;
        public string method { get => throw null; set { } }
        public int nc { get => throw null; set { } }
        public string nonce { get => throw null; set { } }
        public string opaque { get => throw null; set { } }
        public string qop { get => throw null; set { } }
        public string realm { get => throw null; set { } }
        public override string ToString() => throw null;
    }
    public class AuthInfo : ServiceStack.IMeta
    {
        public System.Collections.Generic.List<ServiceStack.MetaAuthProvider> AuthProviders { get => throw null; set { } }
        public AuthInfo() => throw null;
        public bool? HasAuthRepository { get => throw null; set { } }
        public bool? HasAuthSecret { get => throw null; set { } }
        public string HtmlRedirect { get => throw null; set { } }
        public bool? IncludesOAuthTokens { get => throw null; set { } }
        public bool? IncludesRoles { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<ServiceStack.LinkInfo>> RoleLinks { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string[]> ServiceRoutes { get => throw null; set { } }
    }
    public class AutoQueryConvention
    {
        public AutoQueryConvention() => throw null;
        public string Name { get => throw null; set { } }
        public string Types { get => throw null; set { } }
        public string Value { get => throw null; set { } }
        public string ValueType { get => throw null; set { } }
    }
    public class AutoQueryInfo : ServiceStack.IMeta
    {
        public string AccessRole { get => throw null; set { } }
        public bool? Async { get => throw null; set { } }
        public bool? AutoQueryViewer { get => throw null; set { } }
        public bool? CrudEvents { get => throw null; set { } }
        public bool? CrudEventsServices { get => throw null; set { } }
        public AutoQueryInfo() => throw null;
        public int? MaxLimit { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string NamedConnection { get => throw null; set { } }
        public bool? OrderByPrimaryKey { get => throw null; set { } }
        public bool? RawSqlFilters { get => throw null; set { } }
        public bool? UntypedQueries { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.AutoQueryConvention> ViewerConventions { get => throw null; set { } }
    }
    public class BrotliCompressor : ServiceStack.Caching.IStreamCompressor
    {
        public byte[] Compress(string text, System.Text.Encoding encoding = default(System.Text.Encoding)) => throw null;
        public byte[] Compress(byte[] buffer) => throw null;
        public System.IO.Stream Compress(System.IO.Stream outputStream, bool leaveOpen = default(bool)) => throw null;
        public BrotliCompressor() => throw null;
        public string Decompress(byte[] zipBuffer, System.Text.Encoding encoding = default(System.Text.Encoding)) => throw null;
        public System.IO.Stream Decompress(System.IO.Stream gzStream, bool leaveOpen = default(bool)) => throw null;
        public byte[] DecompressBytes(byte[] zipBuffer) => throw null;
        public string Encoding { get => throw null; }
        public static ServiceStack.BrotliCompressor Instance { get => throw null; }
    }
    public class CachedServiceClient : ServiceStack.ICachedServiceClient, System.IDisposable, ServiceStack.IHasBearerToken, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IHttpRestClientAsync, ServiceStack.IOneWayClient, ServiceStack.IReplyClient, ServiceStack.IRestClient, ServiceStack.IRestClientAsync, ServiceStack.IRestClientSync, ServiceStack.IRestServiceClient, ServiceStack.IServiceClient, ServiceStack.IServiceClientAsync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientSync, ServiceStack.IServiceGateway, ServiceStack.IServiceGatewayAsync
    {
        public void AddHeader(string name, string value) => throw null;
        public string BearerToken { get => throw null; set { } }
        public int CacheCount { get => throw null; }
        public long CacheHits { get => throw null; }
        public long CachesAdded { get => throw null; }
        public long CachesRemoved { get => throw null; }
        public int CleanCachesWhenCountExceeds { get => throw null; set { } }
        public System.TimeSpan? ClearCachesOlderThan { get => throw null; set { } }
        public void ClearCookies() => throw null;
        public System.TimeSpan? ClearExpiredCachesOlderThan { get => throw null; set { } }
        public CachedServiceClient(ServiceStack.ServiceClientBase client, System.Collections.Concurrent.ConcurrentDictionary<string, ServiceStack.HttpCacheEntry> cache) => throw null;
        public CachedServiceClient(ServiceStack.ServiceClientBase client) => throw null;
        public void CustomMethod(string httpVerb, ServiceStack.IReturnVoid requestDto) => throw null;
        public TResponse CustomMethod<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse CustomMethod<TResponse>(string httpVerb, object requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task CustomMethodAsync(string httpVerb, ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public void Delete(ServiceStack.IReturnVoid requestDto) => throw null;
        public TResponse Delete<TResponse>(ServiceStack.IReturn<TResponse> request) => throw null;
        public TResponse Delete<TResponse>(object request) => throw null;
        public TResponse Delete<TResponse>(string relativeOrAbsoluteUrl) => throw null;
        public System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task DeleteAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public void Dispose() => throw null;
        public long ErrorFallbackHits { get => throw null; }
        public void Get(ServiceStack.IReturnVoid request) => throw null;
        public TResponse Get<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse Get<TResponse>(object requestDto) => throw null;
        public TResponse Get<TResponse>(string relativeOrAbsoluteUrl) => throw null;
        public System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task GetAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Collections.Generic.Dictionary<string, string> GetCookieValues() => throw null;
        public System.Collections.Generic.IEnumerable<TResponse> GetLazy<TResponse>(ServiceStack.IReturn<ServiceStack.QueryResponse<TResponse>> queryDto) => throw null;
        public long NotModifiedHits { get => throw null; }
        public object OnExceptionFilter(System.Net.WebException webEx, System.Net.WebResponse webRes, string requestUri, System.Type responseType) => throw null;
        public void Patch(ServiceStack.IReturnVoid requestDto) => throw null;
        public TResponse Patch<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse Patch<TResponse>(object requestDto) => throw null;
        public TResponse Patch<TResponse>(string relativeOrAbsoluteUrl, object requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task PatchAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public void Post(ServiceStack.IReturnVoid requestDto) => throw null;
        public TResponse Post<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse Post<TResponse>(object requestDto) => throw null;
        public TResponse Post<TResponse>(string relativeOrAbsoluteUrl, object request) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task PostAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public TResponse PostFile<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, string mimeType, string fieldName = default(string)) => throw null;
        public TResponse PostFilesWithRequest<TResponse>(object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files) => throw null;
        public TResponse PostFilesWithRequest<TResponse>(string relativeOrAbsoluteUrl, object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files) => throw null;
        public TResponse PostFileWithRequest<TResponse>(System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string)) => throw null;
        public TResponse PostFileWithRequest<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string)) => throw null;
        public void Publish(object requestDto) => throw null;
        public void PublishAll(System.Collections.Generic.IEnumerable<object> requestDtos) => throw null;
        public System.Threading.Tasks.Task PublishAllAsync(System.Collections.Generic.IEnumerable<object> requestDtos, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task PublishAsync(object requestDto, System.Threading.CancellationToken token) => throw null;
        public void Put(ServiceStack.IReturnVoid requestDto) => throw null;
        public TResponse Put<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse Put<TResponse>(object requestDto) => throw null;
        public TResponse Put<TResponse>(string relativeOrAbsoluteUrl, object requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task PutAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public int RemoveCachesOlderThan(System.TimeSpan age) => throw null;
        public int RemoveExpiredCachesOlderThan(System.TimeSpan age) => throw null;
        public TResponse Send<TResponse>(string httpMethod, string relativeOrAbsoluteUrl, object request) => throw null;
        public TResponse Send<TResponse>(object request) => throw null;
        public System.Collections.Generic.List<TResponse> SendAll<TResponse>(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public System.Threading.Tasks.Task<System.Collections.Generic.List<TResponse>> SendAllAsync<TResponse>(System.Collections.Generic.IEnumerable<object> requests, System.Threading.CancellationToken token) => throw null;
        public void SendAllOneWay(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(string httpMethod, string absoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(object requestDto, System.Threading.CancellationToken token) => throw null;
        public void SendOneWay(object requestDto) => throw null;
        public void SendOneWay(string relativeOrAbsoluteUri, object requestDto) => throw null;
        public string SessionId { get => throw null; set { } }
        public void SetCache(System.Collections.Concurrent.ConcurrentDictionary<string, ServiceStack.HttpCacheEntry> cache) => throw null;
        public void SetCookie(string name, string value, System.TimeSpan? expiresIn = default(System.TimeSpan?)) => throw null;
        public void SetCredentials(string userName, string password) => throw null;
        public int Version { get => throw null; set { } }
    }
    public static partial class CachedServiceClientExtensions
    {
        public static ServiceStack.IServiceClient WithCache(this ServiceStack.ServiceClientBase client) => throw null;
        public static ServiceStack.IServiceClient WithCache(this ServiceStack.ServiceClientBase client, System.Collections.Concurrent.ConcurrentDictionary<string, ServiceStack.HttpCacheEntry> cache) => throw null;
    }
    public class CancelRequest : ServiceStack.IMeta, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.CancelRequestResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public CancelRequest() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Tag { get => throw null; set { } }
    }
    public class CancelRequestResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public CancelRequestResponse() => throw null;
        public System.TimeSpan Elapsed { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public string Tag { get => throw null; set { } }
    }
    public class CheckCrudEvents : ServiceStack.IReturn<ServiceStack.CheckCrudEventsResponse>, ServiceStack.IReturn
    {
        public string AuthSecret { get => throw null; set { } }
        public CheckCrudEvents() => throw null;
        public System.Collections.Generic.List<string> Ids { get => throw null; set { } }
        public string Model { get => throw null; set { } }
    }
    public class CheckCrudEventsResponse : ServiceStack.IHasResponseStatus
    {
        public CheckCrudEventsResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<string> Results { get => throw null; set { } }
    }
    public static class ClaimUtils
    {
        public static string Admin { get => throw null; set { } }
        public static System.Security.Claims.ClaimsPrincipal AuthenticatedUser(this System.Security.Claims.ClaimsPrincipal principal) => throw null;
        public static string GetDisplayName(this System.Security.Claims.ClaimsPrincipal principal) => throw null;
        public static string GetEmail(this System.Security.Claims.ClaimsPrincipal principal) => throw null;
        public static string[] GetPermissions(this System.Security.Claims.ClaimsPrincipal principal) => throw null;
        public static string GetPicture(this System.Security.Claims.ClaimsPrincipal principal) => throw null;
        public static string[] GetRoles(this System.Security.Claims.ClaimsPrincipal principal) => throw null;
        public static string GetUserId(this System.Security.Claims.ClaimsPrincipal principal) => throw null;
        public static bool HasAllRoles(this System.Security.Claims.ClaimsPrincipal principal, params string[] roleNames) => throw null;
        public static bool HasClaim(this System.Security.Claims.ClaimsPrincipal principal, string type, string value) => throw null;
        public static bool HasRole(this System.Security.Claims.ClaimsPrincipal principal, string roleName) => throw null;
        public static bool HasScope(this System.Security.Claims.ClaimsPrincipal principal, string scope) => throw null;
        public static bool IsAdmin(this System.Security.Claims.ClaimsPrincipal principal) => throw null;
        public static bool IsAuthenticated(this System.Security.Claims.ClaimsPrincipal principal) => throw null;
        public static string PermissionType { get => throw null; set { } }
        public static string Picture { get => throw null; set { } }
    }
    public static class ClientConfig
    {
        public static void ConfigureTls12() => throw null;
        public static string DefaultEncodeDispositionFileName(string fileName) => throw null;
        public static System.Func<string, string> EncodeDispositionFileName { get => throw null; set { } }
        public static System.Func<string, object> EvalExpression { get => throw null; set { } }
        public static bool ImplicitRefInfo { get => throw null; set { } }
        public static bool SkipEmptyArrays { get => throw null; set { } }
    }
    public static class ClientDiagnostics
    {
        public static void WriteRequestAfter(this System.Diagnostics.DiagnosticListener listener, System.Guid operationId, System.Net.Http.HttpRequestMessage httpReq, object response, string operation = default(string)) => throw null;
        public static System.Guid WriteRequestBefore(this System.Diagnostics.DiagnosticListener listener, System.Net.Http.HttpRequestMessage httpReq, object request, System.Type responseType, string operation = default(string)) => throw null;
        public static void WriteRequestError(this System.Diagnostics.DiagnosticListener listener, System.Guid operationId, System.Net.Http.HttpRequestMessage httpReq, System.Exception ex, string operation = default(string)) => throw null;
    }
    public static class ClientDiagnosticUtils
    {
        public static void InitMessage(this System.Diagnostics.DiagnosticListener listener, ServiceStack.Messaging.IMessage msg) => throw null;
    }
    public static class ClientFactory
    {
        public static ServiceStack.IOneWayClient Create(string endpointUrl) => throw null;
    }
    public class ConfigInfo : ServiceStack.IMeta
    {
        public ConfigInfo() => throw null;
        public bool? DebugMode { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
    }
    public static class ContentFormat
    {
        public static readonly System.Collections.Generic.Dictionary<string, string> ContentTypeAliases;
        public static string GetContentFormat(ServiceStack.Format format) => throw null;
        public static string GetContentFormat(string contentType) => throw null;
        public static ServiceStack.RequestAttributes GetEndpointAttributes(string contentType) => throw null;
        public static string GetRealContentType(string contentType) => throw null;
        public static ServiceStack.RequestAttributes GetRequestAttribute(string httpMethod) => throw null;
        public static bool IsBinary(this string contentType) => throw null;
        public static bool MatchesContentType(this string contentType, string matchesContentType) => throw null;
        public static string NormalizeContentType(string contentType) => throw null;
        public static string ToContentFormat(this string contentType) => throw null;
        public static string ToContentType(this ServiceStack.Format formats) => throw null;
        public static ServiceStack.Feature ToFeature(this string contentType) => throw null;
        public const string Utf8Suffix = default;
    }
    public class ConvertSessionToToken : ServiceStack.IMeta, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.ConvertSessionToTokenResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public ConvertSessionToToken() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public bool PreserveSession { get => throw null; set { } }
    }
    public class ConvertSessionToTokenResponse : ServiceStack.IMeta
    {
        public string AccessToken { get => throw null; set { } }
        public ConvertSessionToTokenResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string RefreshToken { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    public static class Crud
    {
        public static System.Collections.Generic.HashSet<string> All { get => throw null; }
        public static System.Collections.Generic.HashSet<string> ApiBaseTypes { get => throw null; }
        public static string[] ApiCrudInterfaces { get => throw null; }
        public static System.Collections.Generic.HashSet<string> ApiInterfaces { get => throw null; }
        public static string[] ApiMarkerInterfaces { get => throw null; }
        public static string[] ApiQueryBaseTypes { get => throw null; }
        public static string[] ApiReturnInterfaces { get => throw null; }
        public static System.Collections.Generic.HashSet<T> CombineSet<T>(T[] original, params T[][] others) => throw null;
        public static string[] CrudInterfaceMetadataNames(System.Collections.Generic.List<string> operations = default(System.Collections.Generic.List<string>)) => throw null;
        public static string CrudModel(this ServiceStack.MetadataType type) => throw null;
        public static System.Collections.Generic.List<string> Default { get => throw null; }
        public static string FirstGenericArg(this ServiceStack.MetadataTypeName type) => throw null;
        public static bool HasInterface(ServiceStack.MetadataOperationType op, string cls) => throw null;
        public static bool IsAnyQuery(this ServiceStack.MetadataType type) => throw null;
        public static bool IsAnyQueryData(this ServiceStack.MetadataType type) => throw null;
        public static bool IsAutoQuery(this ServiceStack.MetadataType type, string model) => throw null;
        public static bool IsCrud(this ServiceStack.MetadataOperationType op) => throw null;
        public static bool IsCrud(this ServiceStack.MetadataType type) => throw null;
        public static bool IsCrud(this ServiceStack.MetadataType type, string model) => throw null;
        public static bool IsCrudCreate(this ServiceStack.MetadataType type) => throw null;
        public static bool IsCrudCreate(this ServiceStack.MetadataType type, string model) => throw null;
        public static bool IsCrudCreate(System.Type type) => throw null;
        public static bool IsCrudCreateOrUpdate(this ServiceStack.MetadataType type) => throw null;
        public static bool IsCrudCreateOrUpdate(this ServiceStack.MetadataType type, string model) => throw null;
        public static bool IsCrudDelete(this ServiceStack.MetadataType type) => throw null;
        public static bool IsCrudDelete(this ServiceStack.MetadataType type, string model) => throw null;
        public static bool IsCrudDelete(System.Type type) => throw null;
        public static bool IsCrudPatch(System.Type type) => throw null;
        public static bool IsCrudQuery(System.Type type) => throw null;
        public static bool IsCrudQueryData(System.Type type) => throw null;
        public static bool IsCrudQueryDb(System.Type type) => throw null;
        public static bool IsCrudRead(this ServiceStack.MetadataOperationType op) => throw null;
        public static bool IsCrudRead(this ServiceStack.MetadataType type) => throw null;
        public static bool IsCrudRead(this ServiceStack.MetadataType type, string model) => throw null;
        public static bool IsCrudUpdate(this ServiceStack.MetadataType type) => throw null;
        public static bool IsCrudUpdate(this ServiceStack.MetadataType type, string model) => throw null;
        public static bool IsCrudUpdate(System.Type type) => throw null;
        public static bool IsCrudWrite(this ServiceStack.MetadataOperationType op) => throw null;
        public static bool IsCrudWrite(this ServiceStack.MetadataType type) => throw null;
        public static bool IsCrudWrite(this ServiceStack.MetadataType type, string model) => throw null;
        public static bool IsQuery(this ServiceStack.MetadataType type) => throw null;
        public static bool IsQueryData(this ServiceStack.MetadataType type) => throw null;
        public static bool IsQueryDataInto(this ServiceStack.MetadataType type) => throw null;
        public static bool IsQueryInto(this ServiceStack.MetadataType type) => throw null;
        public static System.Collections.Generic.List<string> Read { get => throw null; }
        public static string[] ReadInterfaces { get => throw null; }
        public static System.Collections.Generic.List<string> Write { get => throw null; }
        public static string[] WriteInterfaces { get => throw null; }
    }
    public class CrudEvent : ServiceStack.IMeta
    {
        public CrudEvent() => throw null;
        public System.DateTime EventDate { get => throw null; set { } }
        public string EventType { get => throw null; set { } }
        public long Id { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Model { get => throw null; set { } }
        public string ModelId { get => throw null; set { } }
        public int? RefId { get => throw null; set { } }
        public string RefIdStr { get => throw null; set { } }
        public string RemoteIp { get => throw null; set { } }
        public string RequestBody { get => throw null; set { } }
        public string RequestType { get => throw null; set { } }
        public long? RowsUpdated { get => throw null; set { } }
        public string Urn { get => throw null; set { } }
        public string UserAuthId { get => throw null; set { } }
        public string UserAuthName { get => throw null; set { } }
    }
    public static class CssUtils
    {
        public static string Active(bool condition) => throw null;
        public static class Bootstrap
        {
            public static string InputClass<T>(ServiceStack.ApiResult<T> apiResult, string fieldName, string valid = default(string), string invalid = default(string)) => throw null;
            public static string InputClass(ServiceStack.ResponseStatus status, string fieldName, string valid = default(string), string invalid = default(string)) => throw null;
        }
        public static string ClassNames(params string[] classes) => throw null;
        public static string Selected(bool condition) => throw null;
        public static class Tailwind
        {
            public static string Input(string cls) => throw null;
            public static string Input(bool invalid, string cls) => throw null;
            public static string InputClass<T>(ServiceStack.ApiResult<T> apiResult, string fieldName, string valid = default(string), string invalid = default(string)) => throw null;
            public static string InputClass(ServiceStack.ResponseStatus status, string fieldName, string valid = default(string), string invalid = default(string)) => throw null;
            public static string ToolbarButtonClass { get => throw null; set { } }
        }
    }
    public class CsvServiceClient : ServiceStack.ServiceClientBase
    {
        public override string ContentType { get => throw null; }
        public CsvServiceClient() => throw null;
        public CsvServiceClient(string baseUri) => throw null;
        public CsvServiceClient(string syncReplyBaseUri, string asyncOneWayBaseUri) => throw null;
        public override T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
        public override string Format { get => throw null; }
        public override void SerializeToStream(ServiceStack.Web.IRequest req, object request, System.IO.Stream stream) => throw null;
        public override ServiceStack.Web.StreamDeserializerDelegate StreamDeserializer { get => throw null; }
    }
    public class CustomPluginInfo : ServiceStack.IMeta
    {
        public string AccessRole { get => throw null; set { } }
        public CustomPluginInfo() => throw null;
        public System.Collections.Generic.List<string> Enabled { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string[]> ServiceRoutes { get => throw null; set { } }
    }
    public class DatabaseInfo
    {
        public string Alias { get => throw null; set { } }
        public DatabaseInfo() => throw null;
        public string Name { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.SchemaInfo> Schemas { get => throw null; set { } }
    }
    public class DeflateCompressor : ServiceStack.Caching.IStreamCompressor
    {
        public byte[] Compress(string text, System.Text.Encoding encoding = default(System.Text.Encoding)) => throw null;
        public byte[] Compress(byte[] bytes) => throw null;
        public System.IO.Stream Compress(System.IO.Stream outputStream, bool leaveOpen = default(bool)) => throw null;
        public DeflateCompressor() => throw null;
        public string Decompress(byte[] zipBuffer, System.Text.Encoding encoding = default(System.Text.Encoding)) => throw null;
        public System.IO.Stream Decompress(System.IO.Stream zipBuffer, bool leaveOpen = default(bool)) => throw null;
        public byte[] DecompressBytes(byte[] zipBuffer) => throw null;
        public string Encoding { get => throw null; }
        public static ServiceStack.DeflateCompressor Instance { get => throw null; }
    }
    public class DeleteFileUpload : ServiceStack.IDelete, ServiceStack.IHasBearerToken, ServiceStack.IReturn<ServiceStack.DeleteFileUploadResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public string BearerToken { get => throw null; set { } }
        public DeleteFileUpload() => throw null;
        public string Name { get => throw null; set { } }
        public string Path { get => throw null; set { } }
    }
    public class DeleteFileUploadResponse
    {
        public DeleteFileUploadResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public bool Result { get => throw null; set { } }
    }
    public class DynamicRequest
    {
        public DynamicRequest() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Params { get => throw null; set { } }
    }
    public class EncryptedMessage : ServiceStack.IReturn<ServiceStack.EncryptedMessageResponse>, ServiceStack.IReturn
    {
        public EncryptedMessage() => throw null;
        public string EncryptedBody { get => throw null; set { } }
        public string EncryptedSymmetricKey { get => throw null; set { } }
        public string KeyId { get => throw null; set { } }
    }
    public class EncryptedMessageResponse
    {
        public EncryptedMessageResponse() => throw null;
        public string EncryptedBody { get => throw null; set { } }
    }
    public class EncryptedServiceClient : ServiceStack.IEncryptedClient, ServiceStack.IHasBearerToken, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IReplyClient, ServiceStack.IServiceGateway
    {
        public string BearerToken { get => throw null; set { } }
        public ServiceStack.IJsonServiceClient Client { get => throw null; set { } }
        public ServiceStack.EncryptedMessage CreateEncryptedMessage(object request, string operationName, byte[] cryptKey, byte[] authKey, byte[] iv, string verb = default(string)) => throw null;
        public EncryptedServiceClient(ServiceStack.IJsonServiceClient client, string publicKeyXml) => throw null;
        public EncryptedServiceClient(ServiceStack.IJsonServiceClient client, System.Security.Cryptography.RSAParameters publicKey) => throw null;
        public ServiceStack.WebServiceException DecryptedException(ServiceStack.WebServiceException ex, byte[] cryptKey, byte[] authKey) => throw null;
        public string KeyId { get => throw null; set { } }
        public System.Security.Cryptography.RSAParameters PublicKey { get => throw null; set { } }
        public void Publish(object request) => throw null;
        public void PublishAll(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public TResponse Send<TResponse>(object request) => throw null;
        public TResponse Send<TResponse>(string httpMethod, object request) => throw null;
        public TResponse Send<TResponse>(string httpMethod, ServiceStack.IReturn<TResponse> request) => throw null;
        public System.Collections.Generic.List<TResponse> SendAll<TResponse>(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public string ServerPublicKeyXml { get => throw null; }
        public string SessionId { get => throw null; set { } }
        public int Version { get => throw null; set { } }
    }
    public static class ErrorUtils
    {
        public static ServiceStack.ResponseStatus AddFieldError(this ServiceStack.ResponseStatus status, string fieldName, string errorMessage, string errorCode = default(string)) => throw null;
        public static ServiceStack.ResponseStatus AsResponseStatus(this System.Exception ex) => throw null;
        public static ServiceStack.ResponseStatus CreateError(System.Exception ex) => throw null;
        public static ServiceStack.ResponseStatus CreateError(string message, string errorCode = default(string)) => throw null;
        public static ServiceStack.ResponseStatus CreateFieldError(string fieldName, string errorMessage, string errorCode = default(string)) => throw null;
        public static ServiceStack.ResponseError FieldError(this ServiceStack.ResponseStatus status, string fieldName) => throw null;
        public const string FieldErrorCode = default;
        public static string FieldErrorMessage(this ServiceStack.ResponseStatus status, string fieldName) => throw null;
        public static bool HasErrorField(this ServiceStack.ResponseStatus status, string fieldName) => throw null;
        public static bool IsError(this ServiceStack.ResponseStatus status) => throw null;
        public static bool IsSuccess(this ServiceStack.ResponseStatus status) => throw null;
        public static bool ShowSummary(this ServiceStack.ResponseStatus status, params string[] exceptFields) => throw null;
        public static string SummaryMessage(this ServiceStack.ResponseStatus status, params string[] exceptFields) => throw null;
    }
    public delegate object ExceptionFilterDelegate(System.Net.WebException webEx, System.Net.WebResponse webResponse, string requestUri, System.Type responseType);
    public delegate object ExceptionFilterHttpDelegate(System.Net.Http.HttpResponseMessage webResponse, string requestUri, System.Type responseType);
    public class ExplorerUi
    {
        public ServiceStack.ApiCss Css { get => throw null; set { } }
        public ExplorerUi() => throw null;
        public ServiceStack.AppTags Tags { get => throw null; set { } }
    }
    public class FieldCss
    {
        public FieldCss() => throw null;
        public string Field { get => throw null; set { } }
        public string Input { get => throw null; set { } }
        public string Label { get => throw null; set { } }
    }
    public class FileContent
    {
        public byte[] Body { get => throw null; set { } }
        public FileContent() => throw null;
        public int Length { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public string Type { get => throw null; set { } }
    }
    public class FilesUploadInfo : ServiceStack.IMeta
    {
        public string BasePath { get => throw null; set { } }
        public FilesUploadInfo() => throw null;
        public System.Collections.Generic.List<ServiceStack.FilesUploadLocation> Locations { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
    }
    public class FilesUploadLocation
    {
        public System.Collections.Generic.HashSet<string> AllowExtensions { get => throw null; set { } }
        public string AllowOperations { get => throw null; set { } }
        public FilesUploadLocation() => throw null;
        public long? MaxFileBytes { get => throw null; set { } }
        public int? MaxFileCount { get => throw null; set { } }
        public long? MinFileBytes { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string ReadAccessRole { get => throw null; set { } }
        public string WriteAccessRole { get => throw null; set { } }
    }
    public class FormatInfo
    {
        public FormatInfo() => throw null;
        public string Locale { get => throw null; set { } }
        public string Method { get => throw null; set { } }
        public string Options { get => throw null; set { } }
    }
    public class GetAccessToken : ServiceStack.IMeta, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.GetAccessTokenResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public GetAccessToken() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string RefreshToken { get => throw null; set { } }
    }
    public class GetAccessTokenResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public string AccessToken { get => throw null; set { } }
        public GetAccessTokenResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    public class GetApiKeys : ServiceStack.IGet, ServiceStack.IMeta, ServiceStack.IReturn<ServiceStack.GetApiKeysResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public GetApiKeys() => throw null;
        public string Environment { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
    }
    public class GetApiKeysResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public GetApiKeysResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.UserApiKey> Results { get => throw null; set { } }
    }
    public class GetCrudEvents : ServiceStack.QueryDb<ServiceStack.CrudEvent>
    {
        public string AuthSecret { get => throw null; set { } }
        public GetCrudEvents() => throw null;
        public string Model { get => throw null; set { } }
        public string ModelId { get => throw null; set { } }
    }
    public class GetEventSubscribers : ServiceStack.IGet, ServiceStack.IReturn<System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>>>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public string[] Channels { get => throw null; set { } }
        public GetEventSubscribers() => throw null;
    }
    public class GetFile : ServiceStack.IGet, ServiceStack.IReturn<ServiceStack.FileContent>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public GetFile() => throw null;
        public string Path { get => throw null; set { } }
    }
    public class GetFileUpload : ServiceStack.IGet, ServiceStack.IHasBearerToken, ServiceStack.IReturn<byte[]>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public bool? Attachment { get => throw null; set { } }
        public string BearerToken { get => throw null; set { } }
        public GetFileUpload() => throw null;
        public string Name { get => throw null; set { } }
        public string Path { get => throw null; set { } }
    }
    public class GetNavItems : ServiceStack.IReturn<ServiceStack.GetNavItemsResponse>, ServiceStack.IReturn
    {
        public GetNavItems() => throw null;
        public string Name { get => throw null; set { } }
    }
    public class GetNavItemsResponse : ServiceStack.IMeta
    {
        public string BaseUrl { get => throw null; set { } }
        public GetNavItemsResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, System.Collections.Generic.List<ServiceStack.NavItem>> NavItemsMap { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.NavItem> Results { get => throw null; set { } }
    }
    public class GetPublicKey : ServiceStack.IReturn<string>, ServiceStack.IReturn
    {
        public GetPublicKey() => throw null;
    }
    public class GetValidationRules : ServiceStack.IReturn<ServiceStack.GetValidationRulesResponse>, ServiceStack.IReturn
    {
        public string AuthSecret { get => throw null; set { } }
        public GetValidationRules() => throw null;
        public string Type { get => throw null; set { } }
    }
    public class GetValidationRulesResponse
    {
        public GetValidationRulesResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.ValidationRule> Results { get => throw null; set { } }
    }
    public class GZipCompressor : ServiceStack.Caching.IStreamCompressor
    {
        public byte[] Compress(string text, System.Text.Encoding encoding = default(System.Text.Encoding)) => throw null;
        public byte[] Compress(byte[] buffer) => throw null;
        public System.IO.Stream Compress(System.IO.Stream outputStream, bool leaveOpen = default(bool)) => throw null;
        public GZipCompressor() => throw null;
        public string Decompress(byte[] gzBuffer, System.Text.Encoding encoding = default(System.Text.Encoding)) => throw null;
        public System.IO.Stream Decompress(System.IO.Stream gzStream, bool leaveOpen = default(bool)) => throw null;
        public byte[] DecompressBytes(byte[] gzBuffer) => throw null;
        public string Encoding { get => throw null; }
        public static ServiceStack.GZipCompressor Instance { get => throw null; }
    }
    public static class HashUtils
    {
        public static System.Security.Cryptography.HashAlgorithm GetHashAlgorithm(string hashAlgorithm) => throw null;
    }
    public static class HmacUtils
    {
        public static byte[] Authenticate(byte[] encryptedBytes, byte[] authKey, byte[] iv) => throw null;
        public static System.Security.Cryptography.HMAC CreateHashAlgorithm(byte[] authKey) => throw null;
        public static byte[] DecryptAuthenticated(byte[] authEncryptedBytes, byte[] cryptKey) => throw null;
        public const int KeySize = 256;
        public const int KeySizeBytes = 32;
        public static bool Verify(byte[] authEncryptedBytes, byte[] authKey) => throw null;
    }
    namespace Html
    {
        public static class Formats
        {
            public static ServiceStack.FormatInfo Attachment { get => throw null; set { } }
            public static ServiceStack.FormatInfo Bytes { get => throw null; set { } }
            public static ServiceStack.FormatInfo Currency { get => throw null; set { } }
            public static ServiceStack.FormatInfo Hidden { get => throw null; set { } }
            public static ServiceStack.FormatInfo Icon { get => throw null; set { } }
            public static ServiceStack.FormatInfo IconRounded { get => throw null; set { } }
            public static ServiceStack.FormatInfo Link { get => throw null; set { } }
            public static ServiceStack.FormatInfo LinkEmail { get => throw null; set { } }
            public static ServiceStack.FormatInfo LinkPhone { get => throw null; set { } }
        }
        public static class Input
        {
            public static ServiceStack.InputInfo AddCss(this ServiceStack.InputInfo input, System.Action<ServiceStack.Html.Input.ConfigureCss> configure) => throw null;
            public class ConfigureCss
            {
                public ConfigureCss(ServiceStack.InputInfo input) => throw null;
                public ServiceStack.Html.Input.ConfigureCss FieldsPerRow(int sm, int? md = default(int?), int? lg = default(int?), int? xl = default(int?), int? xl2 = default(int?)) => throw null;
                public ServiceStack.InputInfo Input { get => throw null; }
            }
            public static ServiceStack.InputInfo Create(System.Reflection.PropertyInfo pi) => throw null;
            public static ServiceStack.InputInfo FieldsPerRow(this ServiceStack.InputInfo input, int sm, int? md = default(int?), int? lg = default(int?), int? xl = default(int?), int? xl2 = default(int?)) => throw null;
            public static ServiceStack.InputInfo For<TModel>(System.Linq.Expressions.Expression<System.Func<TModel, object>> expr, System.Action<ServiceStack.InputInfo> configure) => throw null;
            public static ServiceStack.InputInfo For<TModel>(System.Linq.Expressions.Expression<System.Func<TModel, object>> expr) => throw null;
            public static System.Collections.Generic.List<ServiceStack.InputInfo> FromGridLayout(System.Collections.Generic.IEnumerable<System.Collections.Generic.List<ServiceStack.InputInfo>> gridLayout) => throw null;
            public static string GetDescription(System.Reflection.MemberInfo mi) => throw null;
            public static System.Collections.Generic.KeyValuePair<string, string>[] GetEnumEntries(System.Type enumType) => throw null;
            public static bool GetEnumEntries(System.Type enumType, out System.Collections.Generic.KeyValuePair<string, string>[] entries) => throw null;
            public static string[] GetEnumValues(System.Type enumType) => throw null;
            public static System.Collections.Generic.Dictionary<string, string> TypeNameMap { get => throw null; }
            public static class Types
            {
                public const string Checkbox = default;
                public const string Color = default;
                public const string Combobox = default;
                public const string Date = default;
                public const string DatetimeLocal = default;
                public const string Email = default;
                public const string File = default;
                public const string Hidden = default;
                public const string Image = default;
                public const string Month = default;
                public const string Number = default;
                public const string Password = default;
                public const string Radio = default;
                public const string Range = default;
                public const string Reset = default;
                public const string Search = default;
                public const string Select = default;
                public const string Submit = default;
                public const string Tag = default;
                public const string Tel = default;
                public const string Text = default;
                public const string Textarea = default;
                public const string Time = default;
                public const string Url = default;
                public const string Week = default;
            }
            public static System.Collections.Generic.Dictionary<System.Type, string> TypesMap { get => throw null; set { } }
        }
        public static class InspectUtils
        {
            public static object Evaluate(System.Linq.Expressions.Expression arg) => throw null;
            public static System.Linq.Expressions.Expression FindMember(System.Linq.Expressions.Expression e) => throw null;
            public static string[] GetFieldNames<T>(this System.Linq.Expressions.Expression<System.Func<T, object>> expr) => throw null;
            public static System.Reflection.PropertyInfo PropertyFromExpression<TModel>(System.Linq.Expressions.Expression<System.Func<TModel, object>> expr) => throw null;
        }
        public static class Media
        {
        }
        public class MediaRuleCreator
        {
            public MediaRuleCreator(string size) => throw null;
            public ServiceStack.MediaRule Show<T>(System.Linq.Expressions.Expression<System.Func<T, object>> expr) => throw null;
            public string Size { get => throw null; }
        }
        public static class MediaRules
        {
            public static ServiceStack.Html.MediaRuleCreator ExtraLarge;
            public static ServiceStack.Html.MediaRuleCreator ExtraLarge2x;
            public static ServiceStack.Html.MediaRuleCreator ExtraSmall;
            public static ServiceStack.Html.MediaRuleCreator Large;
            public static ServiceStack.Html.MediaRuleCreator Medium;
            public static string MinVisibleSize(this System.Collections.Generic.IEnumerable<ServiceStack.MediaRule> mediaRules, string target) => throw null;
            public static ServiceStack.Html.MediaRuleCreator Small;
        }
        public static class MediaSizes
        {
            public static string[] All;
            public const string ExtraLarge = default;
            public const string ExtraLarge2x = default;
            public const string ExtraSmall = default;
            public static string ForBootstrap(string size) => throw null;
            public static string ForTailwind(string size) => throw null;
            public const string Large = default;
            public const string Medium = default;
            public const string Small = default;
        }
    }
    public class HttpCacheEntry
    {
        public System.TimeSpan? Age { get => throw null; set { } }
        public bool CanUseCacheOnError() => throw null;
        public long? ContentLength { get => throw null; set { } }
        public System.DateTime Created { get => throw null; set { } }
        public HttpCacheEntry(object response) => throw null;
        public string ETag { get => throw null; set { } }
        public System.DateTime Expires { get => throw null; set { } }
        public bool HasExpired() => throw null;
        public System.DateTime? LastModified { get => throw null; set { } }
        public System.TimeSpan MaxAge { get => throw null; set { } }
        public bool MustRevalidate { get => throw null; set { } }
        public bool NoCache { get => throw null; set { } }
        public object Response { get => throw null; set { } }
        public void SetMaxAge(System.TimeSpan maxAge) => throw null;
        public bool ShouldRevalidate() => throw null;
    }
    public class HttpClientDiagnosticEvent : ServiceStack.DiagnosticEvent
    {
        public HttpClientDiagnosticEvent() => throw null;
        public System.Net.Http.HttpRequestMessage HttpRequest { get => throw null; set { } }
        public System.Net.Http.HttpResponseMessage HttpResponse { get => throw null; set { } }
        public object Request { get => throw null; set { } }
        public object Response { get => throw null; set { } }
        public System.Type ResponseType { get => throw null; set { } }
        public override string Source { get => throw null; }
    }
    public static class HttpExt
    {
        public static string GetDispositionFileName(string fileName) => throw null;
        public static bool HasNonAscii(string s) => throw null;
    }
    public interface ICachedServiceClient : System.IDisposable, ServiceStack.IHasBearerToken, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IHttpRestClientAsync, ServiceStack.IOneWayClient, ServiceStack.IReplyClient, ServiceStack.IRestClient, ServiceStack.IRestClientAsync, ServiceStack.IRestClientSync, ServiceStack.IRestServiceClient, ServiceStack.IServiceClient, ServiceStack.IServiceClientAsync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientSync, ServiceStack.IServiceGateway, ServiceStack.IServiceGatewayAsync
    {
        int CacheCount { get; }
        long CacheHits { get; }
        long CachesAdded { get; }
        long CachesRemoved { get; }
        long ErrorFallbackHits { get; }
        long NotModifiedHits { get; }
        int RemoveCachesOlderThan(System.TimeSpan age);
        int RemoveExpiredCachesOlderThan(System.TimeSpan age);
        void SetCache(System.Collections.Concurrent.ConcurrentDictionary<string, ServiceStack.HttpCacheEntry> cache);
    }
    public static partial class ICachedServiceClientExtensions
    {
        public static void ClearCache(this ServiceStack.ICachedServiceClient client) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> GetStats(this ServiceStack.ICachedServiceClient client) => throw null;
    }
    public interface IClientFactory
    {
        ServiceStack.JsonApiClient GetClient();
        ServiceStack.IServiceGateway GetGateway();
    }
    public interface ICloneServiceGateway
    {
        ServiceStack.IServiceGateway Clone();
    }
    public interface IHasCookieContainer
    {
        System.Net.CookieContainer CookieContainer { get; }
    }
    public interface IHasJsonApiClient
    {
        ServiceStack.JsonApiClient Client { get; }
    }
    public class ImageInfo
    {
        public string Alt { get => throw null; set { } }
        public string Cls { get => throw null; set { } }
        public ImageInfo() => throw null;
        public string Svg { get => throw null; set { } }
        public string Uri { get => throw null; set { } }
    }
    public class InputInfo : ServiceStack.IMeta
    {
        public string Accept { get => throw null; set { } }
        public System.Collections.Generic.KeyValuePair<string, string>[] AllowableEntries { get => throw null; set { } }
        public string[] AllowableValues { get => throw null; set { } }
        public string Autocomplete { get => throw null; set { } }
        public string Autofocus { get => throw null; set { } }
        public string Capture { get => throw null; set { } }
        public ServiceStack.FieldCss Css { get => throw null; set { } }
        public InputInfo() => throw null;
        public InputInfo(string id) => throw null;
        public InputInfo(string id, string type) => throw null;
        public bool? Disabled { get => throw null; set { } }
        public string Help { get => throw null; set { } }
        public string Id { get => throw null; set { } }
        public bool? Ignore { get => throw null; set { } }
        public string Label { get => throw null; set { } }
        public string Max { get => throw null; set { } }
        public int? MaxLength { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Min { get => throw null; set { } }
        public int? MinLength { get => throw null; set { } }
        public bool? Multiple { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string Options { get => throw null; set { } }
        public string Pattern { get => throw null; set { } }
        public string Placeholder { get => throw null; set { } }
        public bool? ReadOnly { get => throw null; set { } }
        public bool? Required { get => throw null; set { } }
        public string Size { get => throw null; set { } }
        public string Step { get => throw null; set { } }
        public string Title { get => throw null; set { } }
        public string Type { get => throw null; set { } }
        public string Value { get => throw null; set { } }
    }
    public interface IServiceClientMeta
    {
        bool AlwaysSendBasicAuthHeader { get; }
        string AsyncOneWayBaseUri { get; }
        string BaseUri { get; set; }
        string BearerToken { get; set; }
        string Format { get; }
        string Password { get; }
        string RefreshToken { get; set; }
        string RefreshTokenUri { get; set; }
        string ResolveTypedUrl(string httpMethod, object requestDto);
        string ResolveUrl(string httpMethod, string relativeOrAbsoluteUrl);
        string SessionId { get; }
        string SyncReplyBaseUri { get; }
        string UserName { get; }
        int Version { get; }
    }
    public interface IServiceGatewayFormAsync
    {
        System.Threading.Tasks.Task<TResponse> SendFormAsync<TResponse>(object requestDto, System.Net.Http.MultipartFormDataContent formData, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }
    public interface ITimer : System.IDisposable
    {
        void Cancel();
    }
    public class JsonApiClient : System.IDisposable, ServiceStack.IHasBearerToken, ServiceStack.IHasCookieContainer, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IHttpRestClientAsync, ServiceStack.IJsonServiceClient, ServiceStack.IOneWayClient, ServiceStack.IReplyClient, ServiceStack.IRestClient, ServiceStack.IRestClientAsync, ServiceStack.IRestClientSync, ServiceStack.IRestServiceClient, ServiceStack.IServiceClient, ServiceStack.IServiceClientAsync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientMeta, ServiceStack.IServiceClientSync, ServiceStack.IServiceGateway, ServiceStack.IServiceGatewayAsync, ServiceStack.IServiceGatewayFormAsync
    {
        public void AddHeader(string name, string value) => throw null;
        public bool AlwaysSendBasicAuthHeader { get => throw null; set { } }
        public ServiceStack.ApiResult<TResponse> ApiForm<TResponse>(string relativeOrAbsoluteUrl, System.Net.Http.MultipartFormDataContent request) => throw null;
        public ServiceStack.ApiResult<TResponse> ApiForm<TResponse>(ServiceStack.IReturn<TResponse> request, System.Net.Http.MultipartFormDataContent body) => throw null;
        public System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiFormAsync<TResponse>(string method, string relativeOrAbsoluteUrl, System.Net.Http.MultipartFormDataContent request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiFormAsync<TResponse>(string relativeOrAbsoluteUrl, System.Net.Http.MultipartFormDataContent request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiFormAsync<TResponse>(ServiceStack.IReturn<TResponse> request, System.Net.Http.MultipartFormDataContent body, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public string AsyncOneWayBaseUri { get => throw null; set { } }
        public string BasePath { get => throw null; set { } }
        public string BaseUri { get => throw null; set { } }
        public string BearerToken { get => throw null; set { } }
        public void CancelAsync() => throw null;
        public void ClearCookies() => throw null;
        public void ClearHeaders() => throw null;
        public string ContentType;
        public System.Net.CookieContainer CookieContainer { get => throw null; set { } }
        public System.Net.ICredentials Credentials { get => throw null; set { } }
        public JsonApiClient(System.Net.Http.HttpClient httpClient) => throw null;
        public JsonApiClient(string baseUri) => throw null;
        public TResponse CustomMethod<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse CustomMethod<TResponse>(string httpVerb, object requestDto) => throw null;
        public void CustomMethod(string httpVerb, ServiceStack.IReturnVoid requestDto) => throw null;
        public TResponse CustomMethod<TResponse>(string httpVerb, string relativeOrAbsoluteUrl, object request) => throw null;
        public System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task CustomMethodAsync(string httpVerb, ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static string DefaultBasePath { get => throw null; set { } }
        public const string DefaultHttpMethod = default;
        public static string DefaultUserAgent;
        public TResponse Delete<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse Delete<TResponse>(object requestDto) => throw null;
        public TResponse Delete<TResponse>(string relativeOrAbsoluteUrl) => throw null;
        public void Delete(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(object requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(object requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(string relativeOrAbsoluteUrl) => throw null;
        public System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task DeleteAsync(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task DeleteAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token) => throw null;
        public void DeleteHeader(string name) => throw null;
        public void Dispose() => throw null;
        public bool EnableAutoRefreshToken { get => throw null; set { } }
        public ServiceStack.ExceptionFilterHttpDelegate ExceptionFilter { get => throw null; set { } }
        public string Format { get => throw null; }
        public TResponse Get<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse Get<TResponse>(object requestDto) => throw null;
        public TResponse Get<TResponse>(string relativeOrAbsoluteUrl) => throw null;
        public void Get(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(object requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(object requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(string relativeOrAbsoluteUrl) => throw null;
        public System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task GetAsync(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task GetAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Collections.Generic.Dictionary<string, string> GetCookieValues() => throw null;
        public System.Net.Http.HttpClient GetHttpClient() => throw null;
        public string GetHttpMethod(object request) => throw null;
        public virtual System.Collections.Generic.IEnumerable<TResponse> GetLazy<TResponse>(ServiceStack.IReturn<ServiceStack.QueryResponse<TResponse>> queryDto) => throw null;
        public static byte[] GetResponseBytes(object response) => throw null;
        public static System.Func<System.Net.Http.HttpMessageHandler> GlobalHttpMessageHandlerFactory { get => throw null; set { } }
        public static System.Action<System.Net.Http.HttpRequestMessage> GlobalRequestFilter { get => throw null; set { } }
        public static System.Action<System.Net.Http.HttpResponseMessage> GlobalResponseFilter { get => throw null; set { } }
        public System.Collections.Specialized.NameValueCollection Headers { get => throw null; }
        public System.Net.Http.HttpClient HttpClient { get => throw null; set { } }
        public System.Net.Http.HttpMessageHandler HttpMessageHandler { get => throw null; set { } }
        public static System.Action<ServiceStack.JsonApiClient, System.Net.Http.HttpMessageHandler> HttpMessageHandlerFilter { get => throw null; set { } }
        public string Password { get => throw null; set { } }
        public TResponse Patch<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse Patch<TResponse>(object requestDto) => throw null;
        public TResponse Patch<TResponse>(string relativeOrAbsoluteUrl, object request) => throw null;
        public void Patch(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(object requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(object requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(string relativeOrAbsoluteUrl, object request) => throw null;
        public System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task PatchAsync(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task PatchAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token) => throw null;
        public TResponse Post<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse Post<TResponse>(object requestDto) => throw null;
        public TResponse Post<TResponse>(string relativeOrAbsoluteUrl, object request) => throw null;
        public void Post(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(object requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(object requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(string relativeOrAbsoluteUrl, object request) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task PostAsync(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task PostAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token) => throw null;
        public virtual TResponse PostFile<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, string mimeType = default(string), string fieldName = default(string)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PostFileAsync<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, string mimeType = default(string), string fieldName = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public TResponse PostFilesWithRequest<TResponse>(object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files) => throw null;
        public TResponse PostFilesWithRequest<TResponse>(string relativeOrAbsoluteUrl, object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files) => throw null;
        public virtual TResponse PostFilesWithRequest<TResponse>(string requestUri, object request, ServiceStack.UploadFile[] files) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostFilesWithRequestAsync<TResponse>(object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostFilesWithRequestAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PostFilesWithRequestAsync<TResponse>(string requestUri, object request, ServiceStack.UploadFile[] files, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public TResponse PostFileWithRequest<TResponse>(System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string)) => throw null;
        public TResponse PostFileWithRequest<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string)) => throw null;
        public System.Threading.Tasks.Task<TResponse> PostFileWithRequestAsync<TResponse>(System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PostFileWithRequestAsync<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual void Publish(object request) => throw null;
        public void PublishAll(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public System.Threading.Tasks.Task PublishAllAsync(System.Collections.Generic.IEnumerable<object> requests, System.Threading.CancellationToken token) => throw null;
        public virtual System.Threading.Tasks.Task PublishAsync(object request, System.Threading.CancellationToken token) => throw null;
        public TResponse Put<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public TResponse Put<TResponse>(object requestDto) => throw null;
        public TResponse Put<TResponse>(string relativeOrAbsoluteUrl, object request) => throw null;
        public void Put(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(object requestDto) => throw null;
        public System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(object requestDto, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(string relativeOrAbsoluteUrl, object request) => throw null;
        public System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task PutAsync(ServiceStack.IReturnVoid requestDto) => throw null;
        public System.Threading.Tasks.Task PutAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token) => throw null;
        public virtual TResponse PutFile<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, string mimeType = default(string), string fieldName = default(string)) => throw null;
        public string RefreshToken { get => throw null; set { } }
        public string RefreshTokenUri { get => throw null; set { } }
        public string RequestCompressionType { get => throw null; set { } }
        public System.Action<System.Net.Http.HttpRequestMessage> RequestFilter { get => throw null; set { } }
        public virtual string ResolveTypedUrl(string httpMethod, object requestDto) => throw null;
        public virtual string ResolveUrl(string httpMethod, string relativeOrAbsoluteUrl) => throw null;
        public System.Action<System.Net.Http.HttpResponseMessage> ResponseFilter { get => throw null; set { } }
        protected T ResultFilter<T>(T response, System.Net.Http.HttpResponseMessage httpRes, string httpMethod, string requestUri, object request) where T : class => throw null;
        public ServiceStack.ResultsFilterHttpDelegate ResultsFilter { get => throw null; set { } }
        public ServiceStack.ResultsFilterHttpResponseDelegate ResultsFilterResponse { get => throw null; set { } }
        public virtual TResponse Send<TResponse>(object request) => throw null;
        public TResponse Send<TResponse>(string httpMethod, string absoluteUrl, object request) => throw null;
        public TResponse Send<TResponse>(string httpMethod, string absoluteUrl, object request, object dto) => throw null;
        public System.Collections.Generic.List<TResponse> SendAll<TResponse>(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<TResponse>> SendAllAsync<TResponse>(System.Collections.Generic.IEnumerable<object> requests, System.Threading.CancellationToken token) => throw null;
        public void SendAllOneWay(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(object request) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(object request, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(string httpMethod, string absoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(string httpMethod, string absoluteUrl, object request, object dto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public TResponse SendForm<TResponse>(string httpMethod, string relativeOrAbsoluteUrl, System.Net.Http.MultipartFormDataContent request) => throw null;
        public System.Threading.Tasks.Task<TResponse> SendFormAsync<TResponse>(string httpMethod, string relativeOrAbsoluteUrl, System.Net.Http.MultipartFormDataContent request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> SendFormAsync<TResponse>(object requestDto, System.Net.Http.MultipartFormDataContent formData, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public void SendOneWay(object request) => throw null;
        public void SendOneWay(string relativeOrAbsoluteUrl, object request) => throw null;
        public string SessionId { get => throw null; set { } }
        public ServiceStack.JsonApiClient SetBaseUri(string baseUri) => throw null;
        public void SetCookie(string name, string value, System.TimeSpan? expiresIn = default(System.TimeSpan?)) => throw null;
        public void SetCredentials(string userName, string password) => throw null;
        public string SyncReplyBaseUri { get => throw null; set { } }
        public void ThrowWebServiceException<TResponse>(System.Net.Http.HttpResponseMessage httpRes, object request, string requestUri, object response) => throw null;
        public virtual string ToAbsoluteUrl(string relativeOrAbsoluteUrl) => throw null;
        public static ServiceStack.WebServiceException ToWebServiceException(System.Net.Http.HttpResponseMessage httpRes, object response, System.Func<System.IO.Stream, object> parseDtoFn) => throw null;
        public ServiceStack.TypedUrlResolverDelegate TypedUrlResolver { get => throw null; set { } }
        public ServiceStack.UrlResolverDelegate UrlResolver { get => throw null; set { } }
        public string UseBasePath { set { } }
        public bool UseCookies { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
        public int Version { get => throw null; set { } }
    }
    public static class JsonApiClientUtils
    {
        public static void AddApiKeyAuth(this System.Net.Http.HttpRequestMessage request, string apiKey) => throw null;
        public static void AddBasicAuth(this System.Net.Http.HttpRequestMessage request, string userName, string password) => throw null;
        public static void AddBearerToken(this System.Net.Http.HttpRequestMessage request, string bearerToken) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddCsvParam<T>(this System.Net.Http.MultipartFormDataContent content, string key, T value) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddFile(this System.Net.Http.MultipartFormDataContent content, string fieldName, string fileName, System.IO.Stream fileContents, string mimeType = default(string)) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddFile(this System.Net.Http.MultipartFormDataContent content, string fieldName, string fileName, System.ReadOnlyMemory<byte> fileContents, string mimeType = default(string)) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddFile(this System.Net.Http.MultipartFormDataContent content, string fieldName, System.IO.FileInfo file, string mimeType = default(string)) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddFile(this System.Net.Http.MultipartFormDataContent content, string fieldName, ServiceStack.IO.IVirtualFile file, string mimeType = default(string)) => throw null;
        public static System.Threading.Tasks.Task<System.Net.Http.MultipartFormDataContent> AddFileAsync(this System.Net.Http.MultipartFormDataContent content, string fieldName, System.IO.FileInfo file, string mimeType = default(string)) => throw null;
        public static System.Net.Http.HttpContent AddFileInfo(this System.Net.Http.HttpContent content, string fieldName, string fileName, string mimeType = default(string)) => throw null;
        public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddJsonApiClient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string baseUrl) => throw null;
        public static Microsoft.Extensions.DependencyInjection.IHttpClientBuilder AddJsonApiClient(this Microsoft.Extensions.DependencyInjection.IServiceCollection services, string baseUrl, System.Action<System.Net.Http.HttpClient> configureClient) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddJsonParam<T>(this System.Net.Http.MultipartFormDataContent content, string key, T value) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddJsvParam<T>(this System.Net.Http.MultipartFormDataContent content, string key, T value) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddParam(this System.Net.Http.MultipartFormDataContent content, string key, string value) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddParam(this System.Net.Http.MultipartFormDataContent content, string key, object value) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddParams(this System.Net.Http.MultipartFormDataContent content, System.Collections.IDictionary map) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddParams(this System.Net.Http.MultipartFormDataContent content, System.Collections.Generic.Dictionary<string, object> map) => throw null;
        public static System.Net.Http.MultipartFormDataContent AddParams<T>(this System.Net.Http.MultipartFormDataContent content, T dto) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<ServiceStack.AppMetadata>> ApiAppMetadataAsync(this ServiceStack.IHasJsonApiClient instance, bool reload = default(bool)) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiAsync<TResponse>(this ServiceStack.IHasJsonApiClient instance, ServiceStack.IReturn<TResponse> request) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<ServiceStack.EmptyResponse>> ApiAsync(this ServiceStack.IHasJsonApiClient instance, ServiceStack.IReturnVoid request) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.IHasErrorStatus> ApiAsync<Model>(this ServiceStack.JsonApiClient client, object request) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<T>> ApiCacheAsync<T>(this ServiceStack.IServiceGateway client, ServiceStack.IReturn<T> requestDto) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiFormAsync<TResponse>(this ServiceStack.IHasJsonApiClient instance, string method, string relativeOrAbsoluteUrl, System.Net.Http.MultipartFormDataContent request) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiFormAsync<TResponse>(this ServiceStack.IHasJsonApiClient instance, string relativeOrAbsoluteUrl, System.Net.Http.MultipartFormDataContent request) => throw null;
        public static string GetContentType(this System.Net.Http.HttpResponseMessage httpRes) => throw null;
        public static byte[] ReadAsByteArray(this System.Net.Http.HttpContent content) => throw null;
        public static System.ReadOnlyMemory<byte> ReadAsMemoryBytes(this System.Net.Http.HttpContent content) => throw null;
        public static string ReadAsString(this System.Net.Http.HttpContent content) => throw null;
        public static System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(this ServiceStack.IHasJsonApiClient instance, ServiceStack.IReturn<TResponse> request) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> ToDictionary(this System.Net.Http.Headers.HttpResponseHeaders headers) => throw null;
        public static System.Net.Http.HttpContent ToHttpContent(this ServiceStack.IO.IVirtualFile file) => throw null;
        public static System.Net.WebHeaderCollection ToWebHeaderCollection(this System.Net.Http.Headers.HttpResponseHeaders headers) => throw null;
    }
    public class JsonServiceClient : ServiceStack.ServiceClientBase, System.IDisposable, ServiceStack.IHasBearerToken, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IHttpRestClientAsync, ServiceStack.IJsonServiceClient, ServiceStack.IOneWayClient, ServiceStack.IReplyClient, ServiceStack.IRestClient, ServiceStack.IRestClientAsync, ServiceStack.IRestClientSync, ServiceStack.IRestServiceClient, ServiceStack.IServiceClient, ServiceStack.IServiceClientAsync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientSync, ServiceStack.IServiceGateway, ServiceStack.IServiceGatewayAsync
    {
        public override string ContentType { get => throw null; }
        public JsonServiceClient() => throw null;
        public JsonServiceClient(string baseUri) => throw null;
        public JsonServiceClient(string syncReplyBaseUri, string asyncOneWayBaseUri) => throw null;
        public override T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
        public override string Format { get => throw null; }
        public override void SerializeToStream(ServiceStack.Web.IRequest req, object request, System.IO.Stream stream) => throw null;
        public override ServiceStack.Web.StreamDeserializerDelegate StreamDeserializer { get => throw null; }
    }
    public class JsvServiceClient : ServiceStack.ServiceClientBase
    {
        public override string ContentType { get => throw null; }
        public JsvServiceClient() => throw null;
        public JsvServiceClient(string baseUri) => throw null;
        public JsvServiceClient(string syncReplyBaseUri, string asyncOneWayBaseUri) => throw null;
        public override T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
        public override string Format { get => throw null; }
        public override void SerializeToStream(ServiceStack.Web.IRequest req, object request, System.IO.Stream stream) => throw null;
        public override ServiceStack.Web.StreamDeserializerDelegate StreamDeserializer { get => throw null; }
    }
    public static class JwtClaimTypes
    {
        public const string AccessTokenHash = default;
        public const string Actor = default;
        public const string Address = default;
        public const string Algorithm = default;
        public const string Audience = default;
        public const string AuthClass = default;
        public const string AuthMethod = default;
        public const string AuthorizedParty = default;
        public const string AuthTime = default;
        public const string BirthDate = default;
        public const string ClientId = default;
        public const string CodeHash = default;
        public const string Confirmation = default;
        public const string DefaultProfileUrl = default;
        public const string DestinationIdentity = default;
        public const string Email = default;
        public const string EmailVerified = default;
        public const string Events = default;
        public const string Expiration = default;
        public const string FamilyName = default;
        public const string Gender = default;
        public const string GivenName = default;
        public const string Groups = default;
        public const string IdentityProvider = default;
        public const string IssuedAt = default;
        public const string Issuer = default;
        public const string JwtId = default;
        public const string KeyId = default;
        public const string Locale = default;
        public const string MayAct = default;
        public const string MiddleName = default;
        public const string Name = default;
        public const string NickName = default;
        public const string Nonce = default;
        public const string NotBefore = default;
        public const string OriginIdentity = default;
        public const string Permission = default;
        public const string Permissions = default;
        public const string PhoneNumber = default;
        public const string PhoneNumberVerified = default;
        public const string Picture = default;
        public const string PreferredUserName = default;
        public const string Profile = default;
        public const string Role = default;
        public const string Roles = default;
        public const string Scope = default;
        public const string SessionId = default;
        public const string Subject = default;
        public const string TimeOfEvent = default;
        public const string TransactionIdentifier = default;
        public const string Type = default;
        public const string UpdatedAt = default;
        public const string WebSite = default;
        public const string ZoneInfo = default;
    }
    public class LinkInfo
    {
        public LinkInfo() => throw null;
        public string Hide { get => throw null; set { } }
        public string Href { get => throw null; set { } }
        public ServiceStack.ImageInfo Icon { get => throw null; set { } }
        public string Id { get => throw null; set { } }
        public string Label { get => throw null; set { } }
        public string Show { get => throw null; set { } }
    }
    public class LocodeUi
    {
        public ServiceStack.ApiCss Css { get => throw null; set { } }
        public LocodeUi() => throw null;
        public int MaxFieldLength { get => throw null; set { } }
        public int MaxNestedFieldLength { get => throw null; set { } }
        public int MaxNestedFields { get => throw null; set { } }
        public ServiceStack.AppTags Tags { get => throw null; set { } }
    }
    public class MediaRule : ServiceStack.IMeta
    {
        public string[] ApplyTo { get => throw null; set { } }
        public MediaRule() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Rule { get => throw null; set { } }
        public string Size { get => throw null; set { } }
    }
    public static partial class MessageExtensions
    {
        public static ServiceStack.Messaging.IMessageProducer CreateMessageProducer(this ServiceStack.Messaging.IMessageService mqServer) => throw null;
        public static ServiceStack.Messaging.IMessageQueueClient CreateMessageQueueClient(this ServiceStack.Messaging.IMessageService mqServer) => throw null;
        public static byte[] ToBytes(this ServiceStack.Messaging.IMessage message) => throw null;
        public static byte[] ToBytes<T>(this ServiceStack.Messaging.IMessage<T> message) => throw null;
        public static string ToDlqQueueName(this ServiceStack.Messaging.IMessage message) => throw null;
        public static string ToInQueueName(this ServiceStack.Messaging.IMessage message) => throw null;
        public static string ToInQueueName<T>(this ServiceStack.Messaging.IMessage<T> message) => throw null;
        public static ServiceStack.Messaging.IMessage ToMessage(this byte[] bytes, System.Type ofType) => throw null;
        public static ServiceStack.Messaging.Message<T> ToMessage<T>(this byte[] bytes) => throw null;
        public static string ToString(byte[] bytes) => throw null;
    }
    public class MessageSerializer
    {
        public MessageSerializer() => throw null;
        public static ServiceStack.Messaging.IMessageSerializer Instance { get => throw null; set { } }
    }
    namespace Messaging
    {
        public class InMemoryMessageQueueClient : System.IDisposable, ServiceStack.Messaging.IMessageProducer, ServiceStack.Messaging.IMessageQueueClient, ServiceStack.IOneWayClient
        {
            public void Ack(ServiceStack.Messaging.IMessage message) => throw null;
            public ServiceStack.Messaging.IMessage<T> CreateMessage<T>(object mqResponse) => throw null;
            public InMemoryMessageQueueClient(ServiceStack.Messaging.MessageQueueClientFactory factory) => throw null;
            public void Dispose() => throw null;
            public ServiceStack.Messaging.IMessage<T> Get<T>(string queueName, System.TimeSpan? timeOut = default(System.TimeSpan?)) => throw null;
            public ServiceStack.Messaging.IMessage<T> GetAsync<T>(string queueName) => throw null;
            public string GetTempQueueName() => throw null;
            public void Nak(ServiceStack.Messaging.IMessage message, bool requeue, System.Exception exception = default(System.Exception)) => throw null;
            public void Notify(string queueName, ServiceStack.Messaging.IMessage message) => throw null;
            public void Publish<T>(T messageBody) => throw null;
            public void Publish<T>(ServiceStack.Messaging.IMessage<T> message) => throw null;
            public void Publish(string queueName, ServiceStack.Messaging.IMessage message) => throw null;
            public void SendAllOneWay(System.Collections.Generic.IEnumerable<object> requests) => throw null;
            public void SendOneWay(object requestDto) => throw null;
            public void SendOneWay(string queueName, object requestDto) => throw null;
        }
        public class MessageQueueClientFactory : System.IDisposable, ServiceStack.Messaging.IMessageQueueClientFactory
        {
            public ServiceStack.Messaging.IMessageQueueClient CreateMessageQueueClient() => throw null;
            public MessageQueueClientFactory() => throw null;
            public void Dispose() => throw null;
            public byte[] GetMessageAsync(string queueName) => throw null;
            public event System.EventHandler<System.EventArgs> MessageReceived;
            public void PublishMessage<T>(string queueName, ServiceStack.Messaging.IMessage<T> message) => throw null;
            public void PublishMessage(string queueName, byte[] messageBytes) => throw null;
        }
        public class RedisMessageFactory : System.IDisposable, ServiceStack.Messaging.IMessageFactory, ServiceStack.Messaging.IMessageQueueClientFactory
        {
            public ServiceStack.Messaging.IMessageProducer CreateMessageProducer() => throw null;
            public ServiceStack.Messaging.IMessageQueueClient CreateMessageQueueClient() => throw null;
            public RedisMessageFactory(ServiceStack.Redis.IRedisClientsManager clientsManager) => throw null;
            public void Dispose() => throw null;
            public static string RegisterAllowRuntimeTypeInTypes { get => throw null; set { } }
        }
        public class RedisMessageProducer : System.IDisposable, ServiceStack.Messaging.IMessageProducer, ServiceStack.IOneWayClient
        {
            public RedisMessageProducer(ServiceStack.Redis.IRedisClientsManager clientsManager) => throw null;
            public RedisMessageProducer(ServiceStack.Redis.IRedisClientsManager clientsManager, System.Action onPublishedCallback) => throw null;
            public void Dispose() => throw null;
            public void Publish<T>(T messageBody) => throw null;
            public void Publish<T>(ServiceStack.Messaging.IMessage<T> message) => throw null;
            public void Publish(string queueName, ServiceStack.Messaging.IMessage message) => throw null;
            public ServiceStack.Redis.IRedisNativeClient ReadWriteClient { get => throw null; }
            public void SendAllOneWay(System.Collections.Generic.IEnumerable<object> requests) => throw null;
            public void SendOneWay(object requestDto) => throw null;
            public void SendOneWay(string queueName, object requestDto) => throw null;
        }
        public class RedisMessageQueueClient : System.IDisposable, ServiceStack.Messaging.IMessageProducer, ServiceStack.Messaging.IMessageQueueClient, ServiceStack.IOneWayClient
        {
            public void Ack(ServiceStack.Messaging.IMessage message) => throw null;
            public ServiceStack.Messaging.IMessage<T> CreateMessage<T>(object mqResponse) => throw null;
            public RedisMessageQueueClient(ServiceStack.Redis.IRedisClientsManager clientsManager) => throw null;
            public RedisMessageQueueClient(ServiceStack.Redis.IRedisClientsManager clientsManager, System.Action onPublishedCallback) => throw null;
            public void Dispose() => throw null;
            public ServiceStack.Messaging.IMessage<T> Get<T>(string queueName, System.TimeSpan? timeOut = default(System.TimeSpan?)) => throw null;
            public ServiceStack.Messaging.IMessage<T> GetAsync<T>(string queueName) => throw null;
            public string GetTempQueueName() => throw null;
            public int MaxSuccessQueueSize { get => throw null; set { } }
            public void Nak(ServiceStack.Messaging.IMessage message, bool requeue, System.Exception exception = default(System.Exception)) => throw null;
            public void Notify(string queueName, ServiceStack.Messaging.IMessage message) => throw null;
            public void Publish<T>(T messageBody) => throw null;
            public void Publish<T>(ServiceStack.Messaging.IMessage<T> message) => throw null;
            public void Publish(string queueName, ServiceStack.Messaging.IMessage message) => throw null;
            public ServiceStack.Redis.IRedisNativeClient ReadOnlyClient { get => throw null; }
            public ServiceStack.Redis.IRedisNativeClient ReadWriteClient { get => throw null; }
            public void SendAllOneWay(System.Collections.Generic.IEnumerable<object> requests) => throw null;
            public void SendOneWay(object requestDto) => throw null;
            public void SendOneWay(string queueName, object requestDto) => throw null;
        }
        public class RedisMessageQueueClientFactory : System.IDisposable, ServiceStack.Messaging.IMessageQueueClientFactory
        {
            public ServiceStack.Messaging.IMessageQueueClient CreateMessageQueueClient() => throw null;
            public RedisMessageQueueClientFactory(ServiceStack.Redis.IRedisClientsManager clientsManager, System.Action onPublishedCallback) => throw null;
            public void Dispose() => throw null;
        }
    }
    public class MetaAuthProvider : ServiceStack.IMeta
    {
        public MetaAuthProvider() => throw null;
        public System.Collections.Generic.List<ServiceStack.InputInfo> FormLayout { get => throw null; set { } }
        public ServiceStack.ImageInfo Icon { get => throw null; set { } }
        public string Label { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public ServiceStack.NavItem NavItem { get => throw null; set { } }
        public string Type { get => throw null; set { } }
    }
    public class MetadataApp : ServiceStack.IGet, ServiceStack.IReturn<ServiceStack.AppMetadata>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public MetadataApp() => throw null;
        public System.Collections.Generic.List<string> IncludeTypes { get => throw null; set { } }
        public string View { get => throw null; set { } }
    }
    public class MetadataAttribute
    {
        public System.Collections.Generic.List<ServiceStack.MetadataPropertyType> Args { get => throw null; set { } }
        public System.Attribute Attribute { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.MetadataPropertyType> ConstructorArgs { get => throw null; set { } }
        public MetadataAttribute() => throw null;
        public string Name { get => throw null; set { } }
    }
    public class MetadataDataContract
    {
        public MetadataDataContract() => throw null;
        public string Name { get => throw null; set { } }
        public string Namespace { get => throw null; set { } }
    }
    public class MetadataDataMember
    {
        public MetadataDataMember() => throw null;
        public bool? EmitDefaultValue { get => throw null; set { } }
        public bool? IsRequired { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public int? Order { get => throw null; set { } }
    }
    public class MetadataOperationType
    {
        public System.Collections.Generic.List<string> Actions { get => throw null; set { } }
        public MetadataOperationType() => throw null;
        public ServiceStack.MetadataTypeName DataModel { get => throw null; set { } }
        public string Method { get => throw null; set { } }
        public ServiceStack.MetadataType Request { get => throw null; set { } }
        public System.Collections.Generic.List<string> RequiredPermissions { get => throw null; set { } }
        public System.Collections.Generic.List<string> RequiredRoles { get => throw null; set { } }
        public System.Collections.Generic.List<string> RequiresAnyPermission { get => throw null; set { } }
        public System.Collections.Generic.List<string> RequiresAnyRole { get => throw null; set { } }
        public bool? RequiresAuth { get => throw null; set { } }
        public ServiceStack.MetadataType Response { get => throw null; set { } }
        public bool? ReturnsVoid { get => throw null; set { } }
        public ServiceStack.MetadataTypeName ReturnType { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.MetadataRoute> Routes { get => throw null; set { } }
        public System.Collections.Generic.List<string> Tags { get => throw null; set { } }
        public ServiceStack.ApiUiInfo Ui { get => throw null; set { } }
        public ServiceStack.MetadataTypeName ViewModel { get => throw null; set { } }
    }
    public class MetadataPropertyType
    {
        public int? AllowableMax { get => throw null; set { } }
        public int? AllowableMin { get => throw null; set { } }
        public string[] AllowableValues { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.MetadataAttribute> Attributes { get => throw null; set { } }
        public MetadataPropertyType() => throw null;
        public ServiceStack.MetadataDataMember DataMember { get => throw null; set { } }
        public string Description { get => throw null; set { } }
        public string DisplayType { get => throw null; set { } }
        public ServiceStack.FormatInfo Format { get => throw null; set { } }
        public string[] GenericArgs { get => throw null; set { } }
        public ServiceStack.InputInfo Input { get => throw null; set { } }
        public bool? IsEnum { get => throw null; set { } }
        public bool? IsPrimaryKey { get => throw null; set { } }
        public bool? IsRequired { get => throw null; set { } }
        public bool? IsValueType { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, object> Items { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string Namespace { get => throw null; set { } }
        public string ParamType { get => throw null; set { } }
        public System.Reflection.PropertyInfo PropertyInfo { get => throw null; set { } }
        public System.Type PropertyType { get => throw null; set { } }
        public bool? ReadOnly { get => throw null; set { } }
        public ServiceStack.RefInfo Ref { get => throw null; set { } }
        public string Type { get => throw null; set { } }
        public string UploadTo { get => throw null; set { } }
        public string Value { get => throw null; set { } }
    }
    public class MetadataRoute
    {
        public MetadataRoute() => throw null;
        public string Notes { get => throw null; set { } }
        public string Path { get => throw null; set { } }
        public ServiceStack.RouteAttribute RouteAttribute { get => throw null; set { } }
        public string Summary { get => throw null; set { } }
        public string Verbs { get => throw null; set { } }
    }
    public class MetadataType : ServiceStack.IMeta
    {
        public System.Collections.Generic.List<ServiceStack.MetadataAttribute> Attributes { get => throw null; set { } }
        public MetadataType() => throw null;
        public ServiceStack.MetadataDataContract DataContract { get => throw null; set { } }
        public string Description { get => throw null; set { } }
        public string DisplayType { get => throw null; set { } }
        public System.Collections.Generic.List<string> EnumDescriptions { get => throw null; set { } }
        public System.Collections.Generic.List<string> EnumMemberValues { get => throw null; set { } }
        public System.Collections.Generic.List<string> EnumNames { get => throw null; set { } }
        public System.Collections.Generic.List<string> EnumValues { get => throw null; set { } }
        protected bool Equals(ServiceStack.MetadataType other) => throw null;
        public override bool Equals(object obj) => throw null;
        public string[] GenericArgs { get => throw null; set { } }
        public string GetFullName() => throw null;
        public override int GetHashCode() => throw null;
        public ServiceStack.ImageInfo Icon { get => throw null; set { } }
        public ServiceStack.MetadataTypeName[] Implements { get => throw null; set { } }
        public ServiceStack.MetadataTypeName Inherits { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.MetadataTypeName> InnerTypes { get => throw null; set { } }
        public bool? IsAbstract { get => throw null; set { } }
        public bool IsClass { get => throw null; }
        public bool? IsEnum { get => throw null; set { } }
        public bool? IsEnumInt { get => throw null; set { } }
        public bool? IsGenericTypeDef { get => throw null; set { } }
        public bool? IsInterface { get => throw null; set { } }
        public bool? IsNested { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, object> Items { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string Namespace { get => throw null; set { } }
        public string Notes { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.MetadataPropertyType> Properties { get => throw null; set { } }
        public ServiceStack.MetadataOperationType RequestType { get => throw null; set { } }
        public System.Type Type { get => throw null; set { } }
    }
    public static partial class MetadataTypeExtensions
    {
        public static ServiceStack.MetadataOperationType FindAutoQueryReturning(this ServiceStack.MetadataTypes types, string dataModel) => throw null;
        public static System.Collections.Generic.List<ServiceStack.MetadataOperationType> GetOperationsByTags(this ServiceStack.MetadataTypes types, string[] tags) => throw null;
        public static System.Collections.Generic.List<ServiceStack.MetadataRoute> GetRoutes(this System.Collections.Generic.List<ServiceStack.MetadataOperationType> operations, ServiceStack.MetadataType type) => throw null;
        public static System.Collections.Generic.List<ServiceStack.MetadataRoute> GetRoutes(this System.Collections.Generic.List<ServiceStack.MetadataOperationType> operations, string typeName) => throw null;
        public static bool ImplementsAny(this ServiceStack.MetadataType type, params string[] typeNames) => throw null;
        public static bool ImplementsAny(this ServiceStack.MetadataType type, System.Collections.Generic.HashSet<string> typeNames) => throw null;
        public static bool InheritsAny(this ServiceStack.MetadataType type, params string[] typeNames) => throw null;
        public static bool InheritsAny(this ServiceStack.MetadataType type, System.Collections.Generic.HashSet<string> typeNames) => throw null;
        public static bool IsSystemOrServiceStackType(this ServiceStack.MetadataTypeName metaRef) => throw null;
        public static bool ReferencesAny(this ServiceStack.MetadataOperationType op, params string[] typeNames) => throw null;
        public static string ToScriptSignature(this ServiceStack.ScriptMethodType method) => throw null;
    }
    public class MetadataTypeName
    {
        public MetadataTypeName() => throw null;
        public string[] GenericArgs { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string Namespace { get => throw null; set { } }
        public System.Type Type { get => throw null; set { } }
    }
    public class MetadataTypes
    {
        public ServiceStack.MetadataTypesConfig Config { get => throw null; set { } }
        public MetadataTypes() => throw null;
        public System.Collections.Generic.List<string> Namespaces { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.MetadataOperationType> Operations { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.MetadataType> Types { get => throw null; set { } }
    }
    public class MetadataTypesConfig
    {
        public bool AddDataContractAttributes { get => throw null; set { } }
        public string AddDefaultXmlNamespace { get => throw null; set { } }
        public bool AddDescriptionAsComments { get => throw null; set { } }
        public bool AddDocAnnotations { get => throw null; set { } }
        public bool AddGeneratedCodeAttributes { get => throw null; set { } }
        public int? AddImplicitVersion { get => throw null; set { } }
        public bool AddIndexesToDataMembers { get => throw null; set { } }
        public bool AddModelExtensions { get => throw null; set { } }
        public System.Collections.Generic.List<string> AddNamespaces { get => throw null; set { } }
        public bool AddNullableAnnotations { get => throw null; set { } }
        public bool AddPropertyAccessors { get => throw null; set { } }
        public bool AddResponseStatus { get => throw null; set { } }
        public bool AddReturnMarker { get => throw null; set { } }
        public bool AddServiceStackTypes { get => throw null; set { } }
        public string BaseClass { get => throw null; set { } }
        public string BaseUrl { get => throw null; set { } }
        public MetadataTypesConfig(string baseUrl = default(string), bool makePartial = default(bool), bool makeVirtual = default(bool), bool addReturnMarker = default(bool), bool convertDescriptionToComments = default(bool), bool addDocAnnotations = default(bool), bool addDataContractAttributes = default(bool), bool addIndexesToDataMembers = default(bool), bool addGeneratedCodeAttributes = default(bool), string addDefaultXmlNamespace = default(string), string baseClass = default(string), string package = default(string), bool addResponseStatus = default(bool), bool addServiceStackTypes = default(bool), bool addModelExtensions = default(bool), bool addPropertyAccessors = default(bool), bool excludeGenericBaseTypes = default(bool), bool settersReturnThis = default(bool), bool addNullableAnnotations = default(bool), bool makePropertiesOptional = default(bool), bool makeDataContractsExtensible = default(bool), bool initializeCollections = default(bool), int? addImplicitVersion = default(int?)) => throw null;
        public string DataClass { get => throw null; set { } }
        public string DataClassJson { get => throw null; set { } }
        public System.Collections.Generic.List<string> DefaultImports { get => throw null; set { } }
        public System.Collections.Generic.List<string> DefaultNamespaces { get => throw null; set { } }
        public bool ExcludeGenericBaseTypes { get => throw null; set { } }
        public bool ExcludeImplementedInterfaces { get => throw null; set { } }
        public bool ExcludeNamespace { get => throw null; set { } }
        public System.Collections.Generic.List<string> ExcludeTypes { get => throw null; set { } }
        public bool ExportAsTypes { get => throw null; set { } }
        public System.Collections.Generic.HashSet<System.Type> ExportAttributes { get => throw null; set { } }
        public System.Collections.Generic.List<string> ExportTags { get => throw null; set { } }
        public System.Collections.Generic.HashSet<System.Type> ExportTypes { get => throw null; set { } }
        public bool ExportValueTypes { get => throw null; set { } }
        public string GlobalNamespace { get => throw null; set { } }
        public System.Collections.Generic.HashSet<System.Type> IgnoreTypes { get => throw null; set { } }
        public System.Collections.Generic.List<string> IgnoreTypesInNamespaces { get => throw null; set { } }
        public System.Collections.Generic.List<string> IncludeTypes { get => throw null; set { } }
        public bool InitializeCollections { get => throw null; set { } }
        public bool MakeDataContractsExtensible { get => throw null; set { } }
        public bool MakeInternal { get => throw null; set { } }
        public bool MakePartial { get => throw null; set { } }
        public bool MakePropertiesOptional { get => throw null; set { } }
        public bool MakeVirtual { get => throw null; set { } }
        public string Package { get => throw null; set { } }
        public bool SettersReturnThis { get => throw null; set { } }
        public System.Collections.Generic.List<string> TreatTypesAsStrings { get => throw null; set { } }
        public string UsePath { get => throw null; set { } }
    }
    public class ModifyValidationRules : ServiceStack.IReturn, ServiceStack.IReturnVoid
    {
        public string AuthSecret { get => throw null; set { } }
        public bool? ClearCache { get => throw null; set { } }
        public ModifyValidationRules() => throw null;
        public int[] DeleteRuleIds { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.ValidationRule> SaveRules { get => throw null; set { } }
        public int[] SuspendRuleIds { get => throw null; set { } }
        public int[] UnsuspendRuleIds { get => throw null; set { } }
    }
    public static partial class NameValueCollectionWrapperExtensions
    {
        public static void AddQueryParam(this ServiceStack.IHasQueryParams queryParams, string key, string value) => throw null;
        public static System.Collections.Specialized.NameValueCollection Clone(this System.Collections.Specialized.NameValueCollection nameValues) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> ToDictionary(this System.Collections.Specialized.NameValueCollection nameValues) => throw null;
        public static string ToFormUrlEncoded(this System.Collections.Specialized.NameValueCollection queryParams) => throw null;
        public static System.Collections.Specialized.NameValueCollection ToNameValueCollection(this System.Collections.Generic.Dictionary<string, string> map) => throw null;
    }
    public class NetStandardPclExportClient : ServiceStack.PclExportClient
    {
        public static ServiceStack.PclExportClient Configure() => throw null;
        public NetStandardPclExportClient() => throw null;
        public override string GetHeader(System.Net.WebHeaderCollection headers, string name, System.Func<string, bool> valuePredicate) => throw null;
        public static ServiceStack.NetStandardPclExportClient Provider;
        public override void SetIfModifiedSince(System.Net.HttpWebRequest webReq, System.DateTime lastModified) => throw null;
    }
    public class NewInstanceResolver : ServiceStack.Configuration.IResolver
    {
        public NewInstanceResolver() => throw null;
        public T TryResolve<T>() => throw null;
    }
    namespace Pcl
    {
        public class HttpUtility
        {
            public HttpUtility() => throw null;
            public static System.Collections.Specialized.NameValueCollection ParseQueryString(string query) => throw null;
            public static System.Collections.Specialized.NameValueCollection ParseQueryString(string query, System.Text.Encoding encoding) => throw null;
        }
    }
    public class PclExportClient
    {
        public virtual void AddHeader(System.Net.WebRequest webReq, System.Collections.Specialized.NameValueCollection headers) => throw null;
        public virtual void CloseReadStream(System.IO.Stream stream) => throw null;
        public virtual void CloseWriteStream(System.IO.Stream stream) => throw null;
        public static void Configure(ServiceStack.PclExportClient instance) => throw null;
        public static bool ConfigureProvider(string typeName) => throw null;
        public virtual System.Exception CreateTimeoutException(System.Exception ex, string errorMsg) => throw null;
        public virtual ServiceStack.ITimer CreateTimer(System.Threading.TimerCallback cb, System.TimeSpan timeOut, object state) => throw null;
        public PclExportClient() => throw null;
        public static readonly System.Threading.Tasks.Task<object> EmptyTask;
        public virtual string GetHeader(System.Net.WebHeaderCollection headers, string name, System.Func<string, bool> valuePredicate) => throw null;
        public virtual string HtmlAttributeEncode(string html) => throw null;
        public virtual string HtmlDecode(string html) => throw null;
        public virtual string HtmlEncode(string html) => throw null;
        public static ServiceStack.PclExportClient Instance;
        public virtual bool IsWebException(System.Net.WebException webEx) => throw null;
        public System.Collections.Specialized.NameValueCollection NewNameValueCollection() => throw null;
        public virtual System.Collections.Specialized.NameValueCollection ParseQueryString(string query) => throw null;
        public virtual void RunOnUiThread(System.Action fn) => throw null;
        public virtual void SetCookieContainer(System.Net.HttpWebRequest webRequest, ServiceStack.ServiceClientBase client) => throw null;
        public virtual void SetCookieContainer(System.Net.HttpWebRequest webRequest, ServiceStack.AsyncServiceClient client) => throw null;
        public virtual void SetIfModifiedSince(System.Net.HttpWebRequest webReq, System.DateTime lastModified) => throw null;
        public virtual void SynchronizeCookies(ServiceStack.AsyncServiceClient client) => throw null;
        public System.Threading.SynchronizationContext UiContext;
        public virtual string UrlDecode(string url) => throw null;
        public virtual string UrlEncode(string url) => throw null;
        public virtual System.Threading.Tasks.Task WaitAsync(int waitForMs) => throw null;
    }
    public static class PlatformRsaUtils
    {
        public static byte[] Decrypt(this System.Security.Cryptography.RSA rsa, byte[] bytes) => throw null;
        public static byte[] Encrypt(this System.Security.Cryptography.RSA rsa, byte[] bytes) => throw null;
        public static string ExportToXml(System.Security.Cryptography.RSAParameters csp, bool includePrivateParameters) => throw null;
        public static System.Security.Cryptography.RSAParameters ExtractFromXml(string xml) => throw null;
        public static void FromXml(this System.Security.Cryptography.RSA rsa, string xml) => throw null;
        public static byte[] SignData(this System.Security.Cryptography.RSA rsa, byte[] bytes, string hashAlgorithm) => throw null;
        public static System.Security.Cryptography.HashAlgorithmName ToHashAlgorithmName(string hashAlgorithm) => throw null;
        public static string ToXml(this System.Security.Cryptography.RSA rsa, bool includePrivateParameters) => throw null;
        public static bool VerifyData(this System.Security.Cryptography.RSA rsa, byte[] bytes, byte[] signature, string hashAlgorithm) => throw null;
    }
    public class PluginInfo : ServiceStack.IMeta
    {
        public ServiceStack.AdminDatabaseInfo AdminDatabase { get => throw null; set { } }
        public ServiceStack.AdminRedisInfo AdminRedis { get => throw null; set { } }
        public ServiceStack.AdminUsersInfo AdminUsers { get => throw null; set { } }
        public ServiceStack.AuthInfo Auth { get => throw null; set { } }
        public ServiceStack.AutoQueryInfo AutoQuery { get => throw null; set { } }
        public PluginInfo() => throw null;
        public ServiceStack.FilesUploadInfo FilesUpload { get => throw null; set { } }
        public System.Collections.Generic.List<string> Loaded { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ProfilingInfo Profiling { get => throw null; set { } }
        public ServiceStack.RequestLogsInfo RequestLogs { get => throw null; set { } }
        public ServiceStack.SharpPagesInfo SharpPages { get => throw null; set { } }
        public ServiceStack.ValidationInfo Validation { get => throw null; set { } }
    }
    public class ProfilingInfo : ServiceStack.IMeta
    {
        public string AccessRole { get => throw null; set { } }
        public ProfilingInfo() => throw null;
        public int DefaultLimit { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.List<string> SummaryFields { get => throw null; set { } }
        public string TagLabel { get => throw null; set { } }
    }
    public delegate void ProgressDelegate(long done, long total);
    public class RedisEndpointInfo
    {
        public RedisEndpointInfo() => throw null;
        public long Db { get => throw null; set { } }
        public string Host { get => throw null; set { } }
        public string Password { get => throw null; set { } }
        public int Port { get => throw null; set { } }
        public bool? Ssl { get => throw null; set { } }
        public string Username { get => throw null; set { } }
    }
    public class RefInfo
    {
        public RefInfo() => throw null;
        public string Model { get => throw null; set { } }
        public System.Type ModelType { get => throw null; set { } }
        public string QueryApi { get => throw null; set { } }
        public System.Type QueryType { get => throw null; set { } }
        public string RefId { get => throw null; set { } }
        public string RefLabel { get => throw null; set { } }
        public string SelfId { get => throw null; set { } }
    }
    public class RefreshTokenException : ServiceStack.WebServiceException
    {
        public RefreshTokenException(string message) => throw null;
        public RefreshTokenException(string message, System.Exception innerException) => throw null;
        public RefreshTokenException(ServiceStack.WebServiceException webEx) => throw null;
    }
    public class RegenerateApiKeys : ServiceStack.IMeta, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.RegenerateApiKeysResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public RegenerateApiKeys() => throw null;
        public string Environment { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
    }
    public class RegenerateApiKeysResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public RegenerateApiKeysResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.UserApiKey> Results { get => throw null; set { } }
    }
    public class Register : ServiceStack.IMeta, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.RegisterResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public bool? AutoLogin { get => throw null; set { } }
        public string ConfirmPassword { get => throw null; set { } }
        public Register() => throw null;
        public string DisplayName { get => throw null; set { } }
        public string Email { get => throw null; set { } }
        public string ErrorView { get => throw null; set { } }
        public string FirstName { get => throw null; set { } }
        public string LastName { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Password { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
    }
    public class RegisterResponse : ServiceStack.IHasBearerToken, ServiceStack.IHasRefreshToken, ServiceStack.IHasResponseStatus, ServiceStack.IHasSessionId, ServiceStack.IMeta
    {
        public string BearerToken { get => throw null; set { } }
        public RegisterResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.List<string> Permissions { get => throw null; set { } }
        public string ReferrerUrl { get => throw null; set { } }
        public string RefreshToken { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<string> Roles { get => throw null; set { } }
        public string SessionId { get => throw null; set { } }
        public string UserId { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
    }
    public class ReplaceFileUpload : ServiceStack.IHasBearerToken, ServiceStack.IPut, ServiceStack.IReturn<ServiceStack.ReplaceFileUploadResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public string BearerToken { get => throw null; set { } }
        public ReplaceFileUpload() => throw null;
        public string Name { get => throw null; set { } }
        public string Path { get => throw null; set { } }
    }
    public class ReplaceFileUploadResponse
    {
        public ReplaceFileUploadResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    public class RequestLogsInfo : ServiceStack.IMeta
    {
        public string AccessRole { get => throw null; set { } }
        public RequestLogsInfo() => throw null;
        public int DefaultLimit { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string RequestLogger { get => throw null; set { } }
        public string[] RequiredRoles { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string[]> ServiceRoutes { get => throw null; set { } }
    }
    public static class ResponseStatusUtils
    {
        public static ServiceStack.ResponseStatus CreateResponseStatus(string errorCode, string errorMessage, System.Collections.Generic.IEnumerable<ServiceStack.Validation.ValidationErrorField> validationErrors = default(System.Collections.Generic.IEnumerable<ServiceStack.Validation.ValidationErrorField>)) => throw null;
        public static string GetDetailedError(this ServiceStack.ResponseStatus status) => throw null;
    }
    public class RestRoute
    {
        public ServiceStack.RouteResolutionResult Apply(object request, string httpMethod) => throw null;
        public RestRoute(System.Type type, string path, string verbs, int priority) => throw null;
        public const string EmptyArray = default;
        public string ErrorMsg { get => throw null; }
        public string FormatQueryParameters(object request) => throw null;
        public static System.Func<object, string> FormatQueryParameterValue;
        public static System.Func<object, string> FormatVariable;
        public string[] HttpMethods { get => throw null; }
        public bool IsValid { get => throw null; }
        public string Path { get => throw null; }
        public int Priority { get => throw null; }
        public System.Collections.Generic.List<string> QueryStringVariables { get => throw null; }
        public System.Type Type { get => throw null; }
        public System.Collections.Generic.ICollection<string> Variables { get => throw null; }
    }
    public delegate object ResultsFilterDelegate(System.Type responseType, string httpMethod, string requestUri, object request);
    public delegate object ResultsFilterHttpDelegate(System.Type responseType, string httpMethod, string requestUri, object request);
    public delegate void ResultsFilterHttpResponseDelegate(System.Net.Http.HttpResponseMessage webResponse, object response, string httpMethod, string requestUri, object request);
    public delegate void ResultsFilterResponseDelegate(System.Net.WebResponse webResponse, object response, string httpMethod, string requestUri, object request);
    public class RouteResolutionResult
    {
        public RouteResolutionResult() => throw null;
        public static ServiceStack.RouteResolutionResult Error(ServiceStack.RestRoute route, string errorMsg) => throw null;
        public string FailReason { get => throw null; }
        public bool Matches { get => throw null; }
        public ServiceStack.RestRoute Route { get => throw null; }
        public static ServiceStack.RouteResolutionResult Success(ServiceStack.RestRoute route, string uri) => throw null;
        public string Uri { get => throw null; }
    }
    public enum RsaKeyLengths
    {
        Bit1024 = 1024,
        Bit2048 = 2048,
        Bit4096 = 4096,
    }
    public class RsaKeyPair
    {
        public RsaKeyPair() => throw null;
        public string PrivateKey { get => throw null; set { } }
        public string PublicKey { get => throw null; set { } }
    }
    public static class RsaUtils
    {
        public static byte[] Authenticate(byte[] dataToSign, System.Security.Cryptography.RSAParameters privateKey, string hashAlgorithm = default(string), ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static System.Security.Cryptography.RSAParameters CreatePrivateKeyParams(ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static ServiceStack.RsaKeyPair CreatePublicAndPrivateKeyPair(ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static string Decrypt(this string text) => throw null;
        public static string Decrypt(string encryptedText, string privateKeyXml, ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static string Decrypt(string encryptedText, System.Security.Cryptography.RSAParameters privateKey, ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static byte[] Decrypt(byte[] encryptedBytes, string privateKeyXml, ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static byte[] Decrypt(byte[] encryptedBytes, System.Security.Cryptography.RSAParameters privateKey, ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static ServiceStack.RsaKeyPair DefaultKeyPair;
        public static bool DoOAEPPadding;
        public static string Encrypt(this string text) => throw null;
        public static string Encrypt(string text, string publicKeyXml, ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static string Encrypt(string text, System.Security.Cryptography.RSAParameters publicKey, ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static byte[] Encrypt(byte[] bytes, string publicKeyXml, ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static byte[] Encrypt(byte[] bytes, System.Security.Cryptography.RSAParameters publicKey, ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
        public static string FromPrivateRSAParameters(this System.Security.Cryptography.RSAParameters privateKey) => throw null;
        public static string FromPublicRSAParameters(this System.Security.Cryptography.RSAParameters publicKey) => throw null;
        public static ServiceStack.RsaKeyLengths KeyLength;
        public static string ToPrivateKeyXml(this System.Security.Cryptography.RSAParameters privateKey) => throw null;
        public static System.Security.Cryptography.RSAParameters ToPrivateRSAParameters(this string privateKeyXml) => throw null;
        public static string ToPublicKeyXml(this System.Security.Cryptography.RSAParameters publicKey) => throw null;
        public static System.Security.Cryptography.RSAParameters ToPublicRsaParameters(this System.Security.Cryptography.RSAParameters privateKey) => throw null;
        public static System.Security.Cryptography.RSAParameters ToPublicRSAParameters(this string publicKeyXml) => throw null;
        public static bool Verify(byte[] dataToVerify, byte[] signature, System.Security.Cryptography.RSAParameters publicKey, string hashAlgorithm = default(string), ServiceStack.RsaKeyLengths rsaKeyLength = default(ServiceStack.RsaKeyLengths)) => throw null;
    }
    public class SchemaInfo
    {
        public string Alias { get => throw null; set { } }
        public SchemaInfo() => throw null;
        public string Name { get => throw null; set { } }
        public System.Collections.Generic.List<string> Tables { get => throw null; set { } }
    }
    public class ScriptMethodType
    {
        public ScriptMethodType() => throw null;
        public string Name { get => throw null; set { } }
        public string[] ParamNames { get => throw null; set { } }
        public string[] ParamTypes { get => throw null; set { } }
        public string ReturnType { get => throw null; set { } }
    }
    namespace Serialization
    {
        public class DataContractSerializer : ServiceStack.Text.IStringSerializer
        {
            public byte[] Compress<XmlDto>(XmlDto from) => throw null;
            public void CompressToStream<XmlDto>(XmlDto from, System.IO.Stream stream) => throw null;
            public DataContractSerializer(System.Xml.XmlDictionaryReaderQuotas quotas = default(System.Xml.XmlDictionaryReaderQuotas)) => throw null;
            public T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public object DeserializeFromString(string xml, System.Type type) => throw null;
            public T DeserializeFromString<T>(string xml) => throw null;
            public static ServiceStack.Serialization.DataContractSerializer Instance;
            public string Parse<XmlDto>(XmlDto from, bool indentXml) => throw null;
            public void SerializeToStream(object obj, System.IO.Stream stream) => throw null;
            public string SerializeToString<XmlDto>(XmlDto from) => throw null;
        }
        public interface IStringStreamSerializer
        {
            T DeserializeFromStream<T>(System.IO.Stream stream);
            object DeserializeFromStream(System.Type type, System.IO.Stream stream);
            void SerializeToStream<T>(T obj, System.IO.Stream stream);
        }
        public class JsonDataContractSerializer : ServiceStack.Text.IStringSerializer
        {
            public static object BclDeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public static object BclDeserializeFromString(string json, System.Type returnType) => throw null;
            public static void BclSerializeToStream<T>(T obj, System.IO.Stream stream) => throw null;
            public static string BclSerializeToString<T>(T obj) => throw null;
            public JsonDataContractSerializer() => throw null;
            public T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
            public object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public object DeserializeFromString(string json, System.Type returnType) => throw null;
            public T DeserializeFromString<T>(string json) => throw null;
            public static ServiceStack.Serialization.JsonDataContractSerializer Instance;
            public void SerializeToStream<T>(T obj, System.IO.Stream stream) => throw null;
            public string SerializeToString<T>(T obj) => throw null;
            public ServiceStack.Text.IStringSerializer TextSerializer { get => throw null; set { } }
            public bool UseBcl { get => throw null; set { } }
            public static void UseSerializer(ServiceStack.Text.IStringSerializer textSerializer) => throw null;
        }
        public class KeyValueDataContractDeserializer
        {
            public KeyValueDataContractDeserializer() => throw null;
            public static ServiceStack.Serialization.KeyValueDataContractDeserializer Instance;
            public object Parse(System.Collections.Generic.IDictionary<string, string> keyValuePairs, System.Type returnType) => throw null;
            public object Parse(System.Collections.Specialized.NameValueCollection nameValues, System.Type returnType) => throw null;
            public To Parse<To>(System.Collections.Generic.IDictionary<string, string> keyValuePairs) => throw null;
            public object Populate(object instance, System.Collections.Specialized.NameValueCollection nameValues, System.Type returnType) => throw null;
        }
        public class RequestBindingError
        {
            public RequestBindingError() => throw null;
            public string ErrorMessage { get => throw null; set { } }
            public string PropertyName { get => throw null; set { } }
            public System.Type PropertyType { get => throw null; set { } }
            public string PropertyValueString { get => throw null; set { } }
        }
        public class StringMapTypeDeserializer
        {
            public static System.Collections.Generic.Dictionary<string, ServiceStack.Text.IStringSerializer> ContentTypeStringSerializers { get => throw null; }
            public object CreateFromMap(System.Collections.Generic.IDictionary<string, string> keyValuePairs) => throw null;
            public object CreateFromMap(System.Collections.Specialized.NameValueCollection nameValues) => throw null;
            public StringMapTypeDeserializer(System.Type type) => throw null;
            public object PopulateFromMap(object instance, System.Collections.Generic.IDictionary<string, string> keyValuePairs, System.Collections.Generic.HashSet<string> ignoredWarningsOnPropertyNames = default(System.Collections.Generic.HashSet<string>)) => throw null;
            public object PopulateFromMap(object instance, System.Collections.Specialized.NameValueCollection nameValues, System.Collections.Generic.HashSet<string> ignoredWarningsOnPropertyNames = default(System.Collections.Generic.HashSet<string>)) => throw null;
            public static System.Collections.Concurrent.ConcurrentDictionary<System.Type, ServiceStack.Text.IStringSerializer> TypeStringSerializers { get => throw null; }
        }
        public class XmlSerializableSerializer : ServiceStack.Text.IStringSerializer
        {
            public XmlSerializableSerializer() => throw null;
            public object DeserializeFromStream(System.Type type, System.IO.Stream stream) => throw null;
            public To DeserializeFromString<To>(string xml) => throw null;
            public object DeserializeFromString(string xml, System.Type type) => throw null;
            public static ServiceStack.Serialization.XmlSerializableSerializer Instance;
            public To Parse<To>(System.IO.TextReader from) => throw null;
            public To Parse<To>(System.IO.Stream from) => throw null;
            public void SerializeToStream(object obj, System.IO.Stream stream) => throw null;
            public string SerializeToString<XmlDto>(XmlDto from) => throw null;
            public static System.Xml.XmlWriterSettings XmlWriterSettings { get => throw null; set { } }
        }
        public sealed class XmlSerializerWrapper : System.Runtime.Serialization.XmlObjectSerializer
        {
            public XmlSerializerWrapper(System.Type type) => throw null;
            public XmlSerializerWrapper(System.Type type, string name, string ns) => throw null;
            public static string GetNamespace(System.Type type) => throw null;
            public override bool IsStartObject(System.Xml.XmlDictionaryReader reader) => throw null;
            public override object ReadObject(System.Xml.XmlDictionaryReader reader, bool verifyObjectName) => throw null;
            public override object ReadObject(System.Xml.XmlDictionaryReader reader) => throw null;
            public override void WriteEndObject(System.Xml.XmlDictionaryWriter writer) => throw null;
            public override void WriteObject(System.Xml.XmlDictionaryWriter writer, object graph) => throw null;
            public override void WriteObjectContent(System.Xml.XmlDictionaryWriter writer, object graph) => throw null;
            public override void WriteStartObject(System.Xml.XmlDictionaryWriter writer, object graph) => throw null;
        }
    }
    public delegate void ServerEventCallback(ServiceStack.ServerEventsClient source, ServiceStack.ServerEventMessage args);
    public static partial class ServerEventClientExtensions
    {
        public static ServiceStack.AuthenticateResponse Authenticate(this ServiceStack.ServerEventsClient client, ServiceStack.Authenticate request) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.AuthenticateResponse> AuthenticateAsync(this ServiceStack.ServerEventsClient client, ServiceStack.Authenticate request) => throw null;
        public static System.Collections.Generic.List<ServiceStack.ServerEventUser> GetChannelSubscribers(this ServiceStack.ServerEventsClient client) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.ServerEventUser>> GetChannelSubscribersAsync(this ServiceStack.ServerEventsClient client) => throw null;
        public static T Populate<T>(this T dst, ServiceStack.ServerEventMessage src, System.Collections.Generic.Dictionary<string, string> msg) where T : ServiceStack.ServerEventMessage => throw null;
        public static ServiceStack.ServerEventsClient RegisterHandlers(this ServiceStack.ServerEventsClient client, System.Collections.Generic.Dictionary<string, ServiceStack.ServerEventCallback> handlers) => throw null;
        public static void SubscribeToChannels(this ServiceStack.ServerEventsClient client, params string[] channels) => throw null;
        public static System.Threading.Tasks.Task SubscribeToChannelsAsync(this ServiceStack.ServerEventsClient client, params string[] channels) => throw null;
        public static void UnsubscribeFromChannels(this ServiceStack.ServerEventsClient client, params string[] channels) => throw null;
        public static System.Threading.Tasks.Task UnsubscribeFromChannelsAsync(this ServiceStack.ServerEventsClient client, params string[] channels) => throw null;
        public static void UpdateSubscriber(this ServiceStack.ServerEventsClient client, ServiceStack.UpdateEventSubscriber request) => throw null;
        public static System.Threading.Tasks.Task UpdateSubscriberAsync(this ServiceStack.ServerEventsClient client, ServiceStack.UpdateEventSubscriber request) => throw null;
    }
    public class ServerEventCommand : ServiceStack.ServerEventMessage
    {
        public string[] Channels { get => throw null; set { } }
        public System.DateTime CreatedAt { get => throw null; set { } }
        public ServerEventCommand() => throw null;
        public string DisplayName { get => throw null; set { } }
        public bool IsAuthenticated { get => throw null; set { } }
        public string ProfileUrl { get => throw null; set { } }
        public string UserId { get => throw null; set { } }
    }
    public class ServerEventConnect : ServiceStack.ServerEventCommand
    {
        public ServerEventConnect() => throw null;
        public long HeartbeatIntervalMs { get => throw null; set { } }
        public string HeartbeatUrl { get => throw null; set { } }
        public string Id { get => throw null; set { } }
        public long IdleTimeoutMs { get => throw null; set { } }
        public string UnRegisterUrl { get => throw null; set { } }
        public string UpdateSubscriberUrl { get => throw null; set { } }
    }
    public class ServerEventHeartbeat : ServiceStack.ServerEventCommand
    {
        public ServerEventHeartbeat() => throw null;
    }
    public class ServerEventJoin : ServiceStack.ServerEventCommand
    {
        public ServerEventJoin() => throw null;
    }
    public class ServerEventLeave : ServiceStack.ServerEventCommand
    {
        public ServerEventLeave() => throw null;
    }
    public class ServerEventMessage : ServiceStack.IMeta
    {
        public string Channel { get => throw null; set { } }
        public string CssSelector { get => throw null; set { } }
        public ServerEventMessage() => throw null;
        public string Data { get => throw null; set { } }
        public long EventId { get => throw null; set { } }
        public string Json { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Op { get => throw null; set { } }
        public string Selector { get => throw null; set { } }
        public string Target { get => throw null; set { } }
    }
    public class ServerEventReceiver : ServiceStack.IReceiver
    {
        public ServiceStack.ServerEventsClient Client { get => throw null; set { } }
        public ServerEventReceiver() => throw null;
        public static ServiceStack.Logging.ILog Log;
        public virtual void NoSuchMethod(string selector, object message) => throw null;
        public ServiceStack.ServerEventMessage Request { get => throw null; set { } }
    }
    public class ServerEventsClient : System.IDisposable
    {
        public ServiceStack.ServerEventsClient AddListener(string eventName, System.Action<ServiceStack.ServerEventMessage> handler) => throw null;
        public System.Action<System.Net.Http.HttpRequestMessage> AllRequestFilters { get => throw null; set { } }
        public string BaseUri { get => throw null; set { } }
        public static int BufferSize;
        public string[] Channels { get => throw null; set { } }
        public System.Threading.Tasks.Task<ServiceStack.ServerEventConnect> Connect() => throw null;
        public System.Threading.Tasks.Task<ServiceStack.ServerEventConnect> ConnectAsync() => throw null;
        public string ConnectionDisplayName { get => throw null; }
        public ServiceStack.ServerEventConnect ConnectionInfo { get => throw null; }
        public ServerEventsClient(string baseUri, params string[] channels) => throw null;
        public void Dispose() => throw null;
        public string EventStreamPath { get => throw null; set { } }
        public System.Action<System.Net.Http.HttpRequestMessage> EventStreamRequestFilter { get => throw null; set { } }
        public string EventStreamUri { get => throw null; }
        public virtual string GetStatsDescription() => throw null;
        public System.Collections.Concurrent.ConcurrentDictionary<string, ServiceStack.ServerEventCallback> Handlers { get => throw null; }
        public bool HasListener(string eventName, System.Action<ServiceStack.ServerEventMessage> handler) => throw null;
        public bool HasListeners(string eventName) => throw null;
        protected void Heartbeat(object state) => throw null;
        public System.Action<System.Net.Http.HttpRequestMessage> HeartbeatRequestFilter { get => throw null; set { } }
        public System.Func<ServiceStack.IServiceClient, System.Net.Http.HttpClientHandler> HttpClientHandlerFactory { get => throw null; set { } }
        public virtual System.Threading.Tasks.Task InternalStop() => throw null;
        public bool IsStopped { get => throw null; }
        public System.DateTime LastPulseAt { get => throw null; set { } }
        public System.Collections.Concurrent.ConcurrentDictionary<string, ServiceStack.ServerEventCallback> NamedReceivers { get => throw null; }
        public System.Action<ServiceStack.ServerEventMessage> OnCommand;
        protected void OnCommandReceived(ServiceStack.ServerEventCommand e) => throw null;
        public System.Action<ServiceStack.ServerEventConnect> OnConnect;
        protected void OnConnectReceived() => throw null;
        public System.Action<System.Exception> OnException;
        protected void OnExceptionReceived(System.Exception ex) => throw null;
        public System.Action OnHeartbeat;
        protected void OnHeartbeatReceived(ServiceStack.ServerEventHeartbeat e) => throw null;
        public System.Action<ServiceStack.ServerEventJoin> OnJoin;
        protected void OnJoinReceived(ServiceStack.ServerEventJoin e) => throw null;
        public System.Action<ServiceStack.ServerEventLeave> OnLeave;
        protected void OnLeaveReceived(ServiceStack.ServerEventLeave e) => throw null;
        public System.Action<ServiceStack.ServerEventMessage> OnMessage;
        protected void OnMessageReceived(ServiceStack.ServerEventMessage e) => throw null;
        public System.Action OnReconnect;
        public System.Action<ServiceStack.ServerEventUpdate> OnUpdate;
        protected void OnUpdateReceived(ServiceStack.ServerEventUpdate e) => throw null;
        public void ProcessLine(string line) => throw null;
        public void ProcessResponse(System.IO.Stream stream) => throw null;
        public void RaiseEvent(string eventName, ServiceStack.ServerEventMessage message) => throw null;
        public System.Collections.Generic.List<System.Type> ReceiverTypes { get => throw null; }
        public ServiceStack.ServerEventsClient RegisterNamedReceiver<T>(string receiverName) where T : ServiceStack.IReceiver => throw null;
        public ServiceStack.ServerEventsClient RegisterReceiver<T>() where T : ServiceStack.IReceiver => throw null;
        public void RemoveAllListeners() => throw null;
        public void RemoveAllRegistrations() => throw null;
        public ServiceStack.ServerEventsClient RemoveListener(string eventName, System.Action<ServiceStack.ServerEventMessage> handler) => throw null;
        public ServiceStack.ServerEventsClient RemoveListeners(string eventName) => throw null;
        public ServiceStack.Configuration.IResolver Resolver { get => throw null; set { } }
        public System.Func<string, string> ResolveStreamUrl { get => throw null; set { } }
        public void Restart() => throw null;
        public ServiceStack.IServiceClient ServiceClient { get => throw null; set { } }
        public ServiceStack.ServerEventsClient Start() => throw null;
        public System.Threading.Tasks.Task<ServiceStack.ServerEventsClient> StartAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        protected void StartNewHeartbeat() => throw null;
        public string Status { get => throw null; }
        public virtual System.Threading.Tasks.Task Stop() => throw null;
        public bool StrictMode { get => throw null; set { } }
        public string SubscriptionId { get => throw null; }
        public int TimesStarted { get => throw null; }
        public static ServiceStack.ServerEventMessage ToTypedMessage(ServiceStack.ServerEventMessage e) => throw null;
        public System.Action<System.Net.Http.HttpRequestMessage> UnRegisterRequestFilter { get => throw null; set { } }
        public void Update(string[] subscribe = default(string[]), string[] unsubscribe = default(string[])) => throw null;
        public System.Threading.Tasks.Task<ServiceStack.ServerEventCommand> WaitForNextCommand() => throw null;
        public System.Threading.Tasks.Task<ServiceStack.ServerEventHeartbeat> WaitForNextHeartbeat() => throw null;
        public System.Threading.Tasks.Task<ServiceStack.ServerEventMessage> WaitForNextMessage() => throw null;
    }
    public class ServerEventUpdate : ServiceStack.ServerEventCommand
    {
        public ServerEventUpdate() => throw null;
    }
    public class ServerEventUser : ServiceStack.IMeta
    {
        public string[] Channels { get => throw null; set { } }
        public ServerEventUser() => throw null;
        public string DisplayName { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string ProfileUrl { get => throw null; set { } }
        public string UserId { get => throw null; set { } }
    }
    public abstract class ServiceClientBase : System.IDisposable, ServiceStack.IHasBearerToken, ServiceStack.IHasCookieContainer, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IHttpRestClientAsync, ServiceStack.Messaging.IMessageProducer, ServiceStack.IOneWayClient, ServiceStack.IReplyClient, ServiceStack.IRestClient, ServiceStack.IRestClientAsync, ServiceStack.IRestClientSync, ServiceStack.IRestServiceClient, ServiceStack.IServiceClient, ServiceStack.IServiceClientAsync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientMeta, ServiceStack.IServiceClientSync, ServiceStack.IServiceGateway, ServiceStack.IServiceGatewayAsync
    {
        public virtual string Accept { get => throw null; }
        public void AddHeader(string name, string value) => throw null;
        public bool AllowAutoRedirect { get => throw null; set { } }
        public bool AlwaysSendBasicAuthHeader { get => throw null; set { } }
        public string AsyncOneWayBaseUri { get => throw null; set { } }
        public string BasePath { get => throw null; set { } }
        public string BaseUri { get => throw null; set { } }
        public string BearerToken { get => throw null; set { } }
        public void CaptureHttp(bool print = default(bool), bool log = default(bool), bool clear = default(bool)) => throw null;
        public void CaptureHttp(System.Action<System.Text.StringBuilder> httpFilter) => throw null;
        public void ClearCookies() => throw null;
        public abstract string ContentType { get; }
        public System.Net.CookieContainer CookieContainer { get => throw null; set { } }
        public System.Net.ICredentials Credentials { get => throw null; set { } }
        protected ServiceClientBase() => throw null;
        protected ServiceClientBase(string syncReplyBaseUri, string asyncOneWayBaseUri) => throw null;
        public virtual void CustomMethod(string httpVerb, ServiceStack.IReturnVoid requestDto) => throw null;
        public virtual System.Net.HttpWebResponse CustomMethod(string httpVerb, object requestDto) => throw null;
        public virtual System.Net.HttpWebResponse CustomMethod(string httpVerb, string relativeOrAbsoluteUrl, object requestDto) => throw null;
        public virtual TResponse CustomMethod<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public virtual TResponse CustomMethod<TResponse>(string httpVerb, object requestDto) => throw null;
        public virtual TResponse CustomMethod<TResponse>(string httpVerb, string relativeOrAbsoluteUrl, object requestDto = default(object)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task CustomMethodAsync(string httpVerb, ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public const string DefaultHttpMethod = default;
        public static string DefaultUserAgent;
        public virtual void Delete(ServiceStack.IReturnVoid requestDto) => throw null;
        public virtual System.Net.HttpWebResponse Delete(object requestDto) => throw null;
        public virtual System.Net.HttpWebResponse Delete(string relativeOrAbsoluteUrl) => throw null;
        public virtual TResponse Delete<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public virtual TResponse Delete<TResponse>(object requestDto) => throw null;
        public virtual TResponse Delete<TResponse>(string relativeOrAbsoluteUrl) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task DeleteAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        protected T Deserialize<T>(string text) => throw null;
        public abstract T DeserializeFromStream<T>(System.IO.Stream stream);
        public bool DisableAutoCompression { get => throw null; set { } }
        public void Dispose() => throw null;
        public byte[] DownloadBytes(string httpMethod, string requestUri, object request) => throw null;
        public System.Threading.Tasks.Task<byte[]> DownloadBytesAsync(string httpMethod, string requestUri, object request) => throw null;
        public bool EmulateHttpViaPost { get => throw null; set { } }
        public bool EnableAutoRefreshToken { get => throw null; set { } }
        public ServiceStack.ExceptionFilterDelegate ExceptionFilter { get => throw null; set { } }
        public abstract string Format { get; }
        public virtual void Get(ServiceStack.IReturnVoid requestDto) => throw null;
        public virtual System.Net.HttpWebResponse Get(object requestDto) => throw null;
        public virtual System.Net.HttpWebResponse Get(string relativeOrAbsoluteUrl) => throw null;
        public virtual TResponse Get<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public virtual TResponse Get<TResponse>(object requestDto) => throw null;
        public virtual TResponse Get<TResponse>(string relativeOrAbsoluteUrl) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task GetAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Collections.Generic.Dictionary<string, string> GetCookieValues() => throw null;
        public string GetHttpMethod(object request) => throw null;
        public virtual System.Collections.Generic.IEnumerable<TResponse> GetLazy<TResponse>(ServiceStack.IReturn<ServiceStack.QueryResponse<TResponse>> queryDto) => throw null;
        protected TResponse GetResponse<TResponse>(System.Net.WebResponse webRes) => throw null;
        public static System.Action<System.Net.HttpWebRequest> GlobalRequestFilter { get => throw null; set { } }
        public static System.Action<System.Net.HttpWebResponse> GlobalResponseFilter { get => throw null; set { } }
        protected virtual bool HandleResponseException<TResponse>(System.Exception ex, object request, string requestUri, System.Func<System.Net.WebRequest> createWebRequest, System.Func<System.Net.WebRequest, System.Net.WebResponse> getResponse, out TResponse response) => throw null;
        public virtual System.Net.HttpWebResponse Head(ServiceStack.IReturn requestDto) => throw null;
        public virtual System.Net.HttpWebResponse Head(object requestDto) => throw null;
        public virtual System.Net.HttpWebResponse Head(string relativeOrAbsoluteUrl) => throw null;
        public System.Collections.Specialized.NameValueCollection Headers { get => throw null; }
        public System.Net.Http.HttpClient HttpClient { get => throw null; set { } }
        public System.Text.StringBuilder HttpLog { get => throw null; set { } }
        public System.Action<System.Text.StringBuilder> HttpLogFilter { get => throw null; set { } }
        public string HttpMethod { get => throw null; set { } }
        public System.Action OnAuthenticationRequired { get => throw null; set { } }
        public ServiceStack.ProgressDelegate OnDownloadProgress { get => throw null; set { } }
        public ServiceStack.ProgressDelegate OnUploadProgress { get => throw null; set { } }
        public string Password { get => throw null; set { } }
        public virtual void Patch(ServiceStack.IReturnVoid requestDto) => throw null;
        public virtual System.Net.HttpWebResponse Patch(object requestDto) => throw null;
        public virtual TResponse Patch<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public virtual TResponse Patch<TResponse>(object requestDto) => throw null;
        public virtual TResponse Patch<TResponse>(string relativeOrAbsoluteUrl, object requestDto) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task PatchAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual void Post(ServiceStack.IReturnVoid requestDto) => throw null;
        public virtual System.Net.HttpWebResponse Post(object requestDto) => throw null;
        public virtual TResponse Post<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public virtual TResponse Post<TResponse>(object requestDto) => throw null;
        public virtual TResponse Post<TResponse>(string relativeOrAbsoluteUrl, object requestDto) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task PostAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual TResponse PostFile<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, string mimeType, string fieldName = default(string)) => throw null;
        public virtual TResponse PostFilesWithRequest<TResponse>(object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files) => throw null;
        public virtual TResponse PostFilesWithRequest<TResponse>(string relativeOrAbsoluteUrl, object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files) => throw null;
        public virtual TResponse PostFileWithRequest<TResponse>(System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string)) => throw null;
        public virtual TResponse PostFileWithRequest<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string)) => throw null;
        protected System.Net.WebRequest PrepareWebRequest(string httpMethod, string requestUri, object request, System.Action<System.Net.HttpWebRequest> sendRequestAction) => throw null;
        public System.Net.IWebProxy Proxy { get => throw null; set { } }
        public virtual void Publish(object requestDto) => throw null;
        public void Publish<T>(T requestDto) => throw null;
        public void Publish<T>(ServiceStack.Messaging.IMessage<T> message) => throw null;
        public void PublishAll(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public System.Threading.Tasks.Task PublishAllAsync(System.Collections.Generic.IEnumerable<object> requests, System.Threading.CancellationToken token) => throw null;
        public System.Threading.Tasks.Task PublishAsync(object request, System.Threading.CancellationToken token) => throw null;
        public virtual void Put(ServiceStack.IReturnVoid requestDto) => throw null;
        public virtual System.Net.HttpWebResponse Put(object requestDto) => throw null;
        public virtual TResponse Put<TResponse>(ServiceStack.IReturn<TResponse> requestDto) => throw null;
        public virtual TResponse Put<TResponse>(object requestDto) => throw null;
        public virtual TResponse Put<TResponse>(string relativeOrAbsoluteUrl, object requestDto) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual System.Threading.Tasks.Task PutAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.TimeSpan? ReadWriteTimeout { get => throw null; set { } }
        public string RefreshToken { get => throw null; set { } }
        public string RefreshTokenUri { get => throw null; set { } }
        public string RequestCompressionType { get => throw null; set { } }
        public System.Action<System.Net.HttpWebRequest> RequestFilter { get => throw null; set { } }
        public virtual string ResolveTypedUrl(string httpMethod, object requestDto) => throw null;
        public virtual string ResolveUrl(string httpMethod, string relativeOrAbsoluteUrl) => throw null;
        public System.Action<System.Net.HttpWebResponse> ResponseFilter { get => throw null; set { } }
        public ServiceStack.ResultsFilterDelegate ResultsFilter { get => throw null; set { } }
        public ServiceStack.ResultsFilterResponseDelegate ResultsFilterResponse { get => throw null; set { } }
        public virtual TResponse Send<TResponse>(object request) => throw null;
        public virtual TResponse Send<TResponse>(string httpMethod, string relativeOrAbsoluteUrl, object request) => throw null;
        public virtual System.Collections.Generic.List<TResponse> SendAll<TResponse>(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public System.Threading.Tasks.Task<System.Collections.Generic.List<TResponse>> SendAllAsync<TResponse>(System.Collections.Generic.IEnumerable<object> requests, System.Threading.CancellationToken token) => throw null;
        public virtual void SendAllOneWay(System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public virtual System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(string httpMethod, string absoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public virtual void SendOneWay(object request) => throw null;
        public virtual void SendOneWay(string relativeOrAbsoluteUrl, object request) => throw null;
        public virtual void SendOneWay(string httpMethod, string relativeOrAbsoluteUrl, object requestDto) => throw null;
        protected virtual System.Net.WebRequest SendRequest(string httpMethod, string requestUri, object request) => throw null;
        public static string SendStringToUrl(System.Net.HttpWebRequest webReq, string method, string requestBody, string contentType, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>)) => throw null;
        public static System.Threading.Tasks.Task<string> SendStringToUrlAsync(System.Net.HttpWebRequest webReq, string method, string requestBody, string contentType, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), System.Action<System.Net.HttpWebResponse> responseFilter = default(System.Action<System.Net.HttpWebResponse>), System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        protected virtual void SerializeRequestToStream(object request, System.IO.Stream requestStream, bool keepOpen = default(bool)) => throw null;
        public abstract void SerializeToStream(ServiceStack.Web.IRequest req, object request, System.IO.Stream stream);
        public string SessionId { get => throw null; set { } }
        public void SetBaseUri(string baseUri) => throw null;
        public void SetCookie(string name, string value, System.TimeSpan? expiresIn = default(System.TimeSpan?)) => throw null;
        public void SetCredentials(string userName, string password) => throw null;
        public bool ShareCookiesWithBrowser { get => throw null; set { } }
        public bool StoreCookies { get => throw null; set { } }
        public abstract ServiceStack.Web.StreamDeserializerDelegate StreamDeserializer { get; }
        public string SyncReplyBaseUri { get => throw null; set { } }
        protected void ThrowResponseTypeException<TResponse>(object request, System.Exception ex, string requestUri) => throw null;
        public void ThrowWebServiceException<TResponse>(System.Exception ex, string requestUri) => throw null;
        public System.TimeSpan? Timeout { get => throw null; set { } }
        public virtual string ToAbsoluteUrl(string relativeOrAbsoluteUrl) => throw null;
        public static ServiceStack.WebServiceException ToWebServiceException(System.Net.WebException webEx, System.Func<System.IO.Stream, object> parseDtoFn, string contentType) => throw null;
        public ServiceStack.TypedUrlResolverDelegate TypedUrlResolver { get => throw null; set { } }
        public static void UploadFile(System.Net.WebRequest webRequest, System.IO.Stream fileStream, string fileName, string mimeType, string accept = default(string), System.Action<System.Net.HttpWebRequest> requestFilter = default(System.Action<System.Net.HttpWebRequest>), string method = default(string), string fieldName = default(string)) => throw null;
        public ServiceStack.UrlResolverDelegate UrlResolver { get => throw null; set { } }
        public string UseBasePath { set { } }
        public string UserAgent { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
        public int Version { get => throw null; set { } }
    }
    public static partial class ServiceClientExtensions
    {
        public static void AddAuthSecret(this ServiceStack.IRestClient client, string authsecret) => throw null;
        public static T Apply<T>(this T client, System.Action<T> fn) where T : ServiceStack.IServiceGateway => throw null;
        public static System.Net.CookieContainer AssertCookieContainer(this ServiceStack.IServiceClient client) => throw null;
        public static TResponse Delete<TResponse>(this ServiceStack.IEncryptedClient client, ServiceStack.IReturn<TResponse> request) => throw null;
        public static void DeleteCookie(this System.Net.CookieContainer cookieContainer, System.Uri uri, string name) => throw null;
        public static void DeleteCookie(this ServiceStack.IHasCookieContainer hasCookieContainer, System.Uri uri, string name) => throw null;
        public static void DeleteCookie(this ServiceStack.IJsonServiceClient client, string name) => throw null;
        public static void DeleteRefreshTokenCookie(this ServiceStack.IJsonServiceClient client) => throw null;
        public static void DeleteTokenCookie(this ServiceStack.IJsonServiceClient client) => throw null;
        public static void DeleteTokenCookies(this ServiceStack.IJsonServiceClient client) => throw null;
        public static TResponse Get<TResponse>(this ServiceStack.IEncryptedClient client, ServiceStack.IReturn<TResponse> request) => throw null;
        public static string GetCookieValue(this ServiceStack.AsyncServiceClient client, string name) => throw null;
        public static ServiceStack.IEncryptedClient GetEncryptedClient(this ServiceStack.IJsonServiceClient client, string serverPublicKeyXml) => throw null;
        public static ServiceStack.IEncryptedClient GetEncryptedClient(this ServiceStack.IJsonServiceClient client, System.Security.Cryptography.RSAParameters publicKey) => throw null;
        public static string GetOptions(this ServiceStack.IServiceClient client) => throw null;
        public static string GetPermanentSessionId(this ServiceStack.IServiceClient client) => throw null;
        public static string GetRefreshTokenCookie(this ServiceStack.IServiceClient client) => throw null;
        public static string GetRefreshTokenCookie(this System.Net.CookieContainer cookies, string baseUri) => throw null;
        public static string GetRefreshTokenCookie(this ServiceStack.AsyncServiceClient client) => throw null;
        public static string GetSessionId(this ServiceStack.IServiceClient client) => throw null;
        public static string GetTokenCookie(this ServiceStack.IServiceClient client) => throw null;
        public static string GetTokenCookie(this System.Net.CookieContainer cookies, string baseUri) => throw null;
        public static string GetTokenCookie(this ServiceStack.AsyncServiceClient client) => throw null;
        public static TResponse PatchBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, object requestBody) => throw null;
        public static TResponse PatchBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, string requestBody) => throw null;
        public static TResponse PatchBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, byte[] requestBody) => throw null;
        public static TResponse PatchBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, System.IO.Stream requestBody) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PatchBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, object requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PatchBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, string requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PatchBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, byte[] requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PatchBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, System.IO.Stream requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static void PopulateRequestMetadata(this ServiceStack.IHasSessionId client, object request) => throw null;
        public static void PopulateRequestMetadatas(this ServiceStack.IHasSessionId client, System.Collections.Generic.IEnumerable<object> requests) => throw null;
        public static TResponse Post<TResponse>(this ServiceStack.IEncryptedClient client, ServiceStack.IReturn<TResponse> request) => throw null;
        public static TResponse PostBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, object requestBody) => throw null;
        public static TResponse PostBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, string requestBody) => throw null;
        public static TResponse PostBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, byte[] requestBody) => throw null;
        public static TResponse PostBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, System.IO.Stream requestBody) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PostBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, object requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PostBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, string requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PostBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, byte[] requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PostBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, System.IO.Stream requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static TResponse PostFile<TResponse>(this ServiceStack.IRestClient client, string relativeOrAbsoluteUrl, System.IO.FileInfo fileToUpload, string mimeType, string fieldName = default(string)) => throw null;
        public static TResponse PostFileWithRequest<TResponse>(this ServiceStack.IRestClient client, System.IO.FileInfo fileToUpload, object request, string fieldName = default(string)) => throw null;
        public static TResponse PostFileWithRequest<TResponse>(this ServiceStack.IRestClient client, string relativeOrAbsoluteUrl, System.IO.FileInfo fileToUpload, object request, string fieldName = default(string)) => throw null;
        public static TResponse Put<TResponse>(this ServiceStack.IEncryptedClient client, ServiceStack.IReturn<TResponse> request) => throw null;
        public static TResponse PutBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, object requestBody) => throw null;
        public static TResponse PutBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, string requestBody) => throw null;
        public static TResponse PutBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, byte[] requestBody) => throw null;
        public static TResponse PutBody<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, System.IO.Stream requestBody) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PutBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, object requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PutBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, string requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PutBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, byte[] requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> PutBodyAsync<TResponse>(this ServiceStack.IServiceClient client, ServiceStack.IReturn<TResponse> toRequest, System.IO.Stream requestBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.IO.Stream ResponseStream(this System.Net.WebResponse webRes) => throw null;
        public static void Send(this ServiceStack.IEncryptedClient client, ServiceStack.IReturnVoid request) => throw null;
        public static void SetCookie(this ServiceStack.IServiceClient client, System.Uri baseUri, string name, string value, System.DateTime? expiresAt = default(System.DateTime?), string path = default(string), bool? httpOnly = default(bool?), bool? secure = default(bool?)) => throw null;
        public static void SetCookie(this System.Net.CookieContainer cookieContainer, System.Uri baseUri, string name, string value, System.DateTime? expiresAt, string path = default(string), bool? httpOnly = default(bool?), bool? secure = default(bool?)) => throw null;
        public static void SetOptions(this ServiceStack.IServiceClient client, string options) => throw null;
        public static void SetPermanentSessionId(this ServiceStack.IServiceClient client, string sessionId) => throw null;
        public static void SetRefreshTokenCookie(this ServiceStack.IServiceClient client, string token) => throw null;
        public static void SetRefreshTokenCookie(this System.Net.CookieContainer cookies, string baseUri, string token) => throw null;
        public static void SetSessionId(this ServiceStack.IServiceClient client, string sessionId) => throw null;
        public static void SetTokenCookie(this ServiceStack.IServiceClient client, string token) => throw null;
        public static void SetTokenCookie(this System.Net.CookieContainer cookies, string baseUri, string token) => throw null;
        public static void SetUserAgent(this System.Net.HttpWebRequest req, string userAgent) => throw null;
        public static System.Collections.Generic.Dictionary<string, string> ToDictionary(this System.Net.CookieContainer cookies, string baseUri) => throw null;
        public static T WithBasePath<T>(this T client, string basePath) where T : ServiceStack.ServiceClientBase => throw null;
    }
    public static class ServiceClientUtils
    {
        public static string GetAutoQueryMethod(System.Type requestType) => throw null;
        public static string GetHttpMethod(System.Type requestType) => throw null;
        public static string GetIVerbMethod(System.Type requestType) => throw null;
        public static string GetIVerbMethod(System.Type[] interfaceTypes) => throw null;
        public static string[] GetRouteMethods(System.Type requestType) => throw null;
        public static string GetSingleRouteMethod(System.Type requestType) => throw null;
        public static System.Collections.Generic.HashSet<string> SupportedMethods { get => throw null; }
    }
    public static class ServiceGatewayAsyncWrappers
    {
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> Api<TResponse>(this ServiceStack.IServiceClientAsync client, ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<System.Collections.Generic.List<TResponse>>> ApiAllAsync<TResponse>(this ServiceStack.IServiceGateway client, System.Collections.Generic.IEnumerable<ServiceStack.IReturn<TResponse>> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<System.Collections.Generic.List<TResponse>>> ApiAllAsync<TResponse>(this ServiceStack.IServiceClientAsync client, ServiceStack.IReturn<TResponse>[] requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<System.Collections.Generic.List<TResponse>>> ApiAllAsync<TResponse>(this ServiceStack.IServiceClientAsync client, System.Collections.Generic.List<ServiceStack.IReturn<TResponse>> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiAsync<TResponse>(this ServiceStack.IServiceGateway client, ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiAsync<TResponse>(this ServiceStack.IServiceGateway client, object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<ServiceStack.EmptyResponse>> ApiAsync(this ServiceStack.IServiceGateway client, ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<ServiceStack.ApiResult<TResponse>> ApiFormAsync<TResponse>(this ServiceStack.IServiceGatewayFormAsync client, object requestDto, System.Net.Http.MultipartFormDataContent formData, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task PublishAllAsync(this ServiceStack.IServiceGateway client, System.Collections.Generic.IEnumerable<object> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task PublishAllAsync(this ServiceStack.IServiceGatewayAsync client, System.Collections.Generic.IEnumerable<ServiceStack.IReturnVoid> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task PublishAsync(this ServiceStack.IServiceGateway client, object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> Send<TResponse>(this ServiceStack.IServiceClientAsync client, ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.List<TResponse>> SendAllAsync<TResponse>(this ServiceStack.IServiceGateway client, System.Collections.Generic.IEnumerable<ServiceStack.IReturn<TResponse>> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.List<TResponse>> SendAllAsync<TResponse>(this ServiceStack.IServiceClientAsync client, ServiceStack.IReturn<TResponse>[] requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.List<TResponse>> SendAllAsync<TResponse>(this ServiceStack.IServiceClientAsync client, System.Collections.Generic.List<ServiceStack.IReturn<TResponse>> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(this ServiceStack.IServiceGateway client, ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(this ServiceStack.IServiceGateway client, object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
        public static System.Threading.Tasks.Task SendAsync(this ServiceStack.IServiceGateway client, ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
    }
    public static partial class ServiceGatewayExtensions
    {
        public static ServiceStack.ApiResult<TResponse> Api<TResponse>(this ServiceStack.IServiceGateway client, ServiceStack.IReturn<TResponse> request) => throw null;
        public static ServiceStack.ApiResult<ServiceStack.EmptyResponse> Api(this ServiceStack.IServiceGateway client, ServiceStack.IReturnVoid request) => throw null;
        public static ServiceStack.ApiResult<System.Collections.Generic.List<TResponse>> ApiAll<TResponse>(this ServiceStack.IServiceGateway client, System.Collections.Generic.IEnumerable<ServiceStack.IReturn<TResponse>> request) => throw null;
        public static System.Type GetResponseType(this ServiceStack.IServiceGateway client, object request) => throw null;
        public static TResponse Send<TResponse>(this ServiceStack.IServiceGateway client, ServiceStack.IReturn<TResponse> request) => throw null;
        public static void Send(this ServiceStack.IServiceGateway client, ServiceStack.IReturnVoid request) => throw null;
        public static object Send(this ServiceStack.IServiceGateway client, System.Type responseType, object request) => throw null;
        public static System.Collections.Generic.List<TResponse> SendAll<TResponse>(this ServiceStack.IServiceGateway client, System.Collections.Generic.IEnumerable<ServiceStack.IReturn<TResponse>> request) => throw null;
        public static System.Threading.Tasks.Task<object> SendAsync(this ServiceStack.IServiceGateway client, System.Type responseType, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken)) => throw null;
    }
    public class ServiceStackMessageSerializer : ServiceStack.Messaging.IMessageSerializer
    {
        public ServiceStackMessageSerializer() => throw null;
        public byte[] ToBytes(ServiceStack.Messaging.IMessage message) => throw null;
        public byte[] ToBytes<T>(ServiceStack.Messaging.IMessage<T> message) => throw null;
        public ServiceStack.Messaging.IMessage ToMessage(byte[] bytes, System.Type ofType) => throw null;
        public ServiceStack.Messaging.Message<T> ToMessage<T>(byte[] bytes) => throw null;
    }
    public class SharpPagesInfo : ServiceStack.IMeta
    {
        public string ApiPath { get => throw null; set { } }
        public SharpPagesInfo() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public bool? MetadataDebug { get => throw null; set { } }
        public string MetadataDebugAdminRole { get => throw null; set { } }
        public string ScriptAdminRole { get => throw null; set { } }
        public bool? SpaFallback { get => throw null; set { } }
    }
    public class SingletonInstanceResolver : ServiceStack.Configuration.IResolver
    {
        public SingletonInstanceResolver() => throw null;
        public T TryResolve<T>() => throw null;
    }
    public class StoreFileUpload : ServiceStack.IHasBearerToken, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.StoreFileUploadResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public string BearerToken { get => throw null; set { } }
        public StoreFileUpload() => throw null;
        public string Name { get => throw null; set { } }
        public string Path { get => throw null; set { } }
    }
    public class StoreFileUploadResponse
    {
        public StoreFileUploadResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<string> Results { get => throw null; set { } }
    }
    public static class StreamCompressors
    {
        public static ServiceStack.Caching.IStreamCompressor Get(string encoding) => throw null;
        public static ServiceStack.Caching.IStreamCompressor GetRequired(string encoding) => throw null;
        public static bool Remove(string encoding) => throw null;
        public static void Set(string encoding, ServiceStack.Caching.IStreamCompressor compressor) => throw null;
        public static bool SupportsEncoding(string encoding) => throw null;
    }
    public static class StreamExt
    {
        public static byte[] Compress(this string text, string compressionType, System.Text.Encoding encoding = default(System.Text.Encoding)) => throw null;
        public static byte[] CompressBytes(this byte[] bytes, string compressionType) => throw null;
        public static System.IO.Stream CompressStream(this System.IO.Stream stream, string compressionType) => throw null;
        public static string Decompress(this byte[] gzBuffer, string compressionType) => throw null;
        public static System.IO.Stream Decompress(this System.IO.Stream gzStream, string compressionType) => throw null;
        public static byte[] DecompressBytes(this byte[] gzBuffer, string compressionType) => throw null;
        public static byte[] Deflate(this string text) => throw null;
        public static string GUnzip(this byte[] gzBuffer) => throw null;
        public static byte[] GZip(this string text) => throw null;
        public static string Inflate(this byte[] gzBuffer) => throw null;
        public static byte[] ToBytes(this System.IO.Stream stream) => throw null;
        public static string ToUtf8String(this System.IO.Stream stream) => throw null;
        public static void Write(this System.IO.Stream stream, string text) => throw null;
    }
    public class StreamFiles : ServiceStack.IReturn<ServiceStack.FileContent>, ServiceStack.IReturn
    {
        public StreamFiles() => throw null;
        public System.Collections.Generic.List<string> Paths { get => throw null; set { } }
    }
    public class StreamServerEvents : ServiceStack.IReturn<ServiceStack.StreamServerEventsResponse>, ServiceStack.IReturn
    {
        public string[] Channels { get => throw null; set { } }
        public StreamServerEvents() => throw null;
    }
    public class StreamServerEventsResponse
    {
        public string Channel { get => throw null; set { } }
        public string[] Channels { get => throw null; set { } }
        public long CreatedAt { get => throw null; set { } }
        public string CssSelector { get => throw null; set { } }
        public StreamServerEventsResponse() => throw null;
        public string Data { get => throw null; set { } }
        public string DisplayName { get => throw null; set { } }
        public long EventId { get => throw null; set { } }
        public long HeartbeatIntervalMs { get => throw null; set { } }
        public string HeartbeatUrl { get => throw null; set { } }
        public string Id { get => throw null; set { } }
        public long IdleTimeoutMs { get => throw null; set { } }
        public bool IsAuthenticated { get => throw null; set { } }
        public string Json { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Op { get => throw null; set { } }
        public string ProfileUrl { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public string Selector { get => throw null; set { } }
        public string Target { get => throw null; set { } }
        public string UnRegisterUrl { get => throw null; set { } }
        public string UpdateSubscriberUrl { get => throw null; set { } }
        public string UserId { get => throw null; set { } }
    }
    namespace Support
    {
        public class NetDeflateProvider : ServiceStack.Caching.IDeflateProvider
        {
            public NetDeflateProvider() => throw null;
            public byte[] Deflate(string text) => throw null;
            public byte[] Deflate(byte[] bytes) => throw null;
            public System.IO.Stream DeflateStream(System.IO.Stream outputStream) => throw null;
            public string Inflate(byte[] gzBuffer) => throw null;
            public byte[] InflateBytes(byte[] gzBuffer) => throw null;
            public System.IO.Stream InflateStream(System.IO.Stream inputStream) => throw null;
            public static ServiceStack.Support.NetDeflateProvider Instance { get => throw null; }
        }
        public class NetGZipProvider : ServiceStack.Caching.IGZipProvider
        {
            public NetGZipProvider() => throw null;
            public string GUnzip(byte[] gzBuffer) => throw null;
            public byte[] GUnzipBytes(byte[] gzBuffer) => throw null;
            public System.IO.Stream GUnzipStream(System.IO.Stream inputStream) => throw null;
            public byte[] GZip(string text) => throw null;
            public byte[] GZip(byte[] bytes) => throw null;
            public System.IO.Stream GZipStream(System.IO.Stream outputStream) => throw null;
            public static ServiceStack.Support.NetGZipProvider Instance { get => throw null; }
        }
    }
    public class ThemeInfo
    {
        public ThemeInfo() => throw null;
        public string Form { get => throw null; set { } }
        public ServiceStack.ImageInfo ModelIcon { get => throw null; set { } }
    }
    public class TokenException : ServiceStack.AuthenticationException
    {
        public TokenException(string message) => throw null;
    }
    public delegate string TypedUrlResolverDelegate(ServiceStack.IServiceClientMeta client, string httpMethod, object requestDto);
    public class UiInfo : ServiceStack.IMeta
    {
        public ServiceStack.AdminUi Admin { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.LinkInfo> AdminLinks { get => throw null; set { } }
        public System.Collections.Generic.List<string> AlwaysHideTags { get => throw null; set { } }
        public ServiceStack.ImageInfo BrandIcon { get => throw null; set { } }
        public UiInfo() => throw null;
        public ServiceStack.ApiFormat DefaultFormats { get => throw null; set { } }
        public ServiceStack.ExplorerUi Explorer { get => throw null; set { } }
        public System.Collections.Generic.List<string> HideTags { get => throw null; set { } }
        public ServiceStack.LocodeUi Locode { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.List<string> Modules { get => throw null; set { } }
        public ServiceStack.ThemeInfo Theme { get => throw null; set { } }
    }
    public class UnAssignRoles : ServiceStack.IMeta, ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.UnAssignRolesResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public UnAssignRoles() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.List<string> Permissions { get => throw null; set { } }
        public System.Collections.Generic.List<string> Roles { get => throw null; set { } }
        public string UserName { get => throw null; set { } }
    }
    public class UnAssignRolesResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public System.Collections.Generic.List<string> AllPermissions { get => throw null; set { } }
        public System.Collections.Generic.List<string> AllRoles { get => throw null; set { } }
        public UnAssignRolesResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    public class UpdateEventSubscriber : ServiceStack.IPost, ServiceStack.IReturn<ServiceStack.UpdateEventSubscriberResponse>, ServiceStack.IReturn, ServiceStack.IVerb
    {
        public UpdateEventSubscriber() => throw null;
        public string Id { get => throw null; set { } }
        public string[] SubscribeChannels { get => throw null; set { } }
        public string[] UnsubscribeChannels { get => throw null; set { } }
    }
    public class UpdateEventSubscriberResponse
    {
        public UpdateEventSubscriberResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    public class UploadedFile
    {
        public long ContentLength { get => throw null; set { } }
        public string ContentType { get => throw null; set { } }
        public UploadedFile() => throw null;
        public string FileName { get => throw null; set { } }
        public string FilePath { get => throw null; set { } }
    }
    public static partial class UrlExtensions
    {
        public static void AppendQueryParam(this System.Text.StringBuilder sb, string key, object value) => throw null;
        public static string AsHttps(this string absoluteUrl) => throw null;
        public static string ExpandGenericTypeName(System.Type type) => throw null;
        public static string ExpandTypeName(this System.Type type) => throw null;
        public static string GetFullyQualifiedName(this System.Type type) => throw null;
        public static string GetMetadataPropertyType(this System.Type type) => throw null;
        public static string GetOperationName(this System.Type type) => throw null;
        public static System.Collections.Generic.Dictionary<string, System.Type> GetQueryPropertyTypes(this System.Type requestType) => throw null;
        public static string ToApiUrl(this System.Type requestType) => throw null;
        public static string ToDeleteUrl(this object requestDto) => throw null;
        public static string ToGetUrl(this object requestDto) => throw null;
        public static string ToOneWayUrl(this object requestDto, string format = default(string)) => throw null;
        public static string ToOneWayUrlOnly(this object requestDto, string format = default(string)) => throw null;
        public static string ToPostUrl(this object requestDto) => throw null;
        public static string ToPutUrl(this object requestDto) => throw null;
        public static string ToRelativeUri(this ServiceStack.IReturn requestDto, string httpMethod, string formatFallbackToPredefinedRoute = default(string)) => throw null;
        public static string ToRelativeUri(this object requestDto, string httpMethod, string formatFallbackToPredefinedRoute = default(string)) => throw null;
        public static string ToReplyUrl(this object requestDto, string format = default(string)) => throw null;
        public static string ToReplyUrlOnly(this object requestDto, string format = default(string)) => throw null;
        public static string ToUrl(this ServiceStack.IReturn requestDto, string httpMethod, string formatFallbackToPredefinedRoute = default(string)) => throw null;
        public static string ToUrl(this object requestDto, string httpMethod = default(string), string formatFallbackToPredefinedRoute = default(string)) => throw null;
        public static string ToUrl(this object requestDto, string httpMethod, System.Func<System.Type, string> fallback) => throw null;
    }
    public delegate string UrlResolverDelegate(ServiceStack.IServiceClientMeta client, string httpMethod, string relativeOrAbsoluteUrl);
    public class UserApiKey : ServiceStack.IMeta
    {
        public UserApiKey() => throw null;
        public System.DateTime? ExpiryDate { get => throw null; set { } }
        public string Key { get => throw null; set { } }
        public string KeyType { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
    }
    namespace Validation
    {
        public class ValidationError : System.ArgumentException, ServiceStack.Model.IResponseStatusConvertible
        {
            public static ServiceStack.Validation.ValidationError CreateException(System.Enum errorCode) => throw null;
            public static ServiceStack.Validation.ValidationError CreateException(System.Enum errorCode, string errorMessage) => throw null;
            public static ServiceStack.Validation.ValidationError CreateException(System.Enum errorCode, string errorMessage, string fieldName) => throw null;
            public static ServiceStack.Validation.ValidationError CreateException(string errorCode) => throw null;
            public static ServiceStack.Validation.ValidationError CreateException(string errorCode, string errorMessage) => throw null;
            public static ServiceStack.Validation.ValidationError CreateException(string errorCode, string errorMessage, string fieldName) => throw null;
            public static ServiceStack.Validation.ValidationError CreateException(ServiceStack.Validation.ValidationErrorField error) => throw null;
            public ValidationError(string errorCode) => throw null;
            public ValidationError(ServiceStack.Validation.ValidationErrorResult validationResult) => throw null;
            public ValidationError(ServiceStack.Validation.ValidationErrorField validationError) => throw null;
            public ValidationError(string errorCode, string errorMessage) => throw null;
            public string ErrorCode { get => throw null; }
            public string ErrorMessage { get => throw null; }
            public override string Message { get => throw null; }
            public static void ThrowIfNotValid(ServiceStack.Validation.ValidationErrorResult validationResult) => throw null;
            public ServiceStack.ResponseStatus ToResponseStatus() => throw null;
            public string ToXml() => throw null;
            public System.Collections.Generic.IList<ServiceStack.Validation.ValidationErrorField> Violations { get => throw null; }
        }
        public class ValidationErrorField : ServiceStack.IMeta
        {
            public object AttemptedValue { get => throw null; set { } }
            public ValidationErrorField(string errorCode, string fieldName) => throw null;
            public ValidationErrorField(string errorCode) => throw null;
            public ValidationErrorField(System.Enum errorCode) => throw null;
            public ValidationErrorField(System.Enum errorCode, string fieldName) => throw null;
            public ValidationErrorField(System.Enum errorCode, string fieldName, string errorMessage) => throw null;
            public ValidationErrorField(string errorCode, string fieldName, string errorMessage) => throw null;
            public ValidationErrorField(string errorCode, string fieldName, string errorMessage, object attemptedValue) => throw null;
            public string ErrorCode { get => throw null; set { } }
            public string ErrorMessage { get => throw null; set { } }
            public string FieldName { get => throw null; set { } }
            public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        }
        public class ValidationErrorResult
        {
            public ValidationErrorResult() => throw null;
            public ValidationErrorResult(System.Collections.Generic.IList<ServiceStack.Validation.ValidationErrorField> errors) => throw null;
            public ValidationErrorResult(System.Collections.Generic.IList<ServiceStack.Validation.ValidationErrorField> errors, string successCode, string errorCode) => throw null;
            public string ErrorCode { get => throw null; set { } }
            public string ErrorMessage { get => throw null; set { } }
            public System.Collections.Generic.IList<ServiceStack.Validation.ValidationErrorField> Errors { get => throw null; set { } }
            public virtual bool IsValid { get => throw null; }
            public void Merge(ServiceStack.Validation.ValidationErrorResult result) => throw null;
            public virtual string Message { get => throw null; }
            public static ServiceStack.Validation.ValidationErrorResult Success { get => throw null; }
            public string SuccessCode { get => throw null; set { } }
            public string SuccessMessage { get => throw null; set { } }
        }
    }
    public class ValidationInfo : ServiceStack.IMeta
    {
        public string AccessRole { get => throw null; set { } }
        public ValidationInfo() => throw null;
        public bool? HasValidationSource { get => throw null; set { } }
        public bool? HasValidationSourceAdmin { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.ScriptMethodType> PropertyValidators { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string[]> ServiceRoutes { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.ScriptMethodType> TypeValidators { get => throw null; set { } }
    }
    public static class WebRequestUtils
    {
        public static void AddApiKeyAuth(this System.Net.WebRequest client, string apiKey) => throw null;
        public static void AddBasicAuth(this System.Net.WebRequest client, string userName, string password) => throw null;
        public static void AddBearerToken(this System.Net.WebRequest client, string bearerToken) => throw null;
        public static void AppendHttpRequestHeaders(this System.Net.HttpWebRequest webReq, System.Text.StringBuilder sb, System.Uri baseUri = default(System.Uri)) => throw null;
        public static void AppendHttpResponseHeaders(this System.Net.HttpWebResponse webRes, System.Text.StringBuilder sb) => throw null;
        public static string CalculateMD5Hash(string input) => throw null;
        public static System.Type GetErrorResponseDtoType<TResponse>(object request) => throw null;
        public static System.Type GetErrorResponseDtoType(object request) => throw null;
        public static System.Type GetErrorResponseDtoType(System.Type requestType) => throw null;
        public static string GetResponseDtoName(System.Type requestType) => throw null;
        public static ServiceStack.ResponseStatus GetResponseStatus(this object response) => throw null;
        public static System.Net.HttpWebRequest InitWebRequest(string url, string method = default(string), System.Collections.Generic.Dictionary<string, string> headers = default(System.Collections.Generic.Dictionary<string, string>)) => throw null;
        public const string ResponseDtoSuffix = default;
    }
    public class WebServiceException : System.Exception, ServiceStack.IHasResponseStatus, ServiceStack.IHasStatusCode, ServiceStack.IHasStatusDescription, ServiceStack.Model.IResponseStatusConvertible
    {
        public WebServiceException() => throw null;
        public WebServiceException(string message) => throw null;
        public WebServiceException(string message, System.Exception innerException) => throw null;
        public string ErrorCode { get => throw null; }
        public string ErrorMessage { get => throw null; }
        public System.Collections.Generic.List<ServiceStack.ResponseError> GetFieldErrors() => throw null;
        public bool IsAny400() => throw null;
        public bool IsAny500() => throw null;
        public static ServiceStack.Logging.ILog log;
        public override string Message { get => throw null; }
        public string ResponseBody { get => throw null; set { } }
        public object ResponseDto { get => throw null; set { } }
        public System.Net.WebHeaderCollection ResponseHeaders { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public string ServerStackTrace { get => throw null; }
        public object State { get => throw null; set { } }
        public int StatusCode { get => throw null; set { } }
        public string StatusDescription { get => throw null; set { } }
        public ServiceStack.ResponseStatus ToResponseStatus() => throw null;
        public override string ToString() => throw null;
    }
    public class XmlServiceClient : ServiceStack.ServiceClientBase
    {
        public override string ContentType { get => throw null; }
        public XmlServiceClient() => throw null;
        public XmlServiceClient(string baseUri) => throw null;
        public XmlServiceClient(string syncReplyBaseUri, string asyncOneWayBaseUri) => throw null;
        public override T DeserializeFromStream<T>(System.IO.Stream stream) => throw null;
        public override string Format { get => throw null; }
        public override void SerializeToStream(ServiceStack.Web.IRequest req, object request, System.IO.Stream stream) => throw null;
        public override ServiceStack.Web.StreamDeserializerDelegate StreamDeserializer { get => throw null; }
    }
    public class ZLibCompressor : ServiceStack.Caching.IStreamCompressor
    {
        public byte[] Compress(string text, System.Text.Encoding encoding = default(System.Text.Encoding)) => throw null;
        public byte[] Compress(byte[] bytes) => throw null;
        public System.IO.Stream Compress(System.IO.Stream outputStream, bool leaveOpen = default(bool)) => throw null;
        public ZLibCompressor() => throw null;
        public string Decompress(byte[] zipBuffer, System.Text.Encoding encoding = default(System.Text.Encoding)) => throw null;
        public System.IO.Stream Decompress(System.IO.Stream zipBuffer, bool leaveOpen = default(bool)) => throw null;
        public byte[] DecompressBytes(byte[] zipBuffer) => throw null;
        public string Encoding { get => throw null; }
        public static ServiceStack.ZLibCompressor Instance { get => throw null; }
    }
}
