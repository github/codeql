// This file contains auto-generated code.
// Generated from `ServiceStack.Interfaces, Version=6.0.0.0, Culture=neutral, PublicKeyToken=null`.
public interface IHasRedisResolver
{
    IRedisResolver RedisResolver { get; set; }
}
public interface IRedisResolver
{
    ServiceStack.Redis.IRedisClient CreateClient(string host);
    ServiceStack.Redis.IRedisEndpoint PrimaryEndpoint { get; }
    int ReadOnlyHostsCount { get; }
    int ReadWriteHostsCount { get; }
    void ResetMasters(System.Collections.Generic.IEnumerable<string> hosts);
    void ResetSlaves(System.Collections.Generic.IEnumerable<string> hosts);
}
namespace ServiceStack
{
    namespace AI
    {
        public class InitSpeechToText
        {
            public InitSpeechToText() => throw null;
            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, int>> PhraseWeights { get => throw null; set { } }
        }
        public interface IPhrasesProvider
        {
            System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<string>> GetPhrasesAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IPhraseWeightsProvider
        {
            System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<(string, int)>> GetPhraseWeightsAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IPromptProvider
        {
            System.Threading.Tasks.Task<string> CreatePromptAsync(string userMessage, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<string> CreateSchemaAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IPromptProviderFactory
        {
            ServiceStack.AI.IPromptProvider Get(string name);
        }
        public interface ISpeechToText
        {
            System.Threading.Tasks.Task InitAsync(ServiceStack.AI.InitSpeechToText config, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<ServiceStack.AI.TranscriptResult> TranscribeAsync(string recordingPath, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface ISpeechToTextFactory
        {
            ServiceStack.AI.ISpeechToText Get(string name);
        }
        public interface ITypeChat
        {
            System.Threading.Tasks.Task<ServiceStack.AI.TypeChatResponse> TranslateMessageAsync(ServiceStack.AI.TypeChatRequest request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface ITypeChatFactory
        {
            ServiceStack.AI.ITypeChat Get(string name);
        }
        public class PromptProviderFactory : ServiceStack.AI.IPromptProviderFactory
        {
            public PromptProviderFactory() => throw null;
            public ServiceStack.AI.IPromptProvider Get(string name) => throw null;
            public System.Collections.Generic.Dictionary<string, ServiceStack.AI.IPromptProvider> Providers { get => throw null; }
        }
        public class SpeechToTextFactory : ServiceStack.AI.ISpeechToTextFactory
        {
            public SpeechToTextFactory() => throw null;
            public ServiceStack.AI.ISpeechToText Get(string name) => throw null;
            public System.Collections.Generic.Dictionary<string, ServiceStack.AI.ISpeechToText> Providers { get => throw null; }
            public System.Func<string, ServiceStack.AI.ISpeechToText> Resolve { get => throw null; set { } }
        }
        public class TranscriptResult
        {
            public string ApiResponse { get => throw null; set { } }
            public float Confidence { get => throw null; set { } }
            public TranscriptResult() => throw null;
            public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
            public string Transcript { get => throw null; set { } }
        }
        public class TypeChatFactory : ServiceStack.AI.ITypeChatFactory
        {
            public TypeChatFactory() => throw null;
            public ServiceStack.AI.ITypeChat Get(string name) => throw null;
            public System.Collections.Generic.Dictionary<string, ServiceStack.AI.ITypeChat> Providers { get => throw null; }
            public System.Func<string, ServiceStack.AI.ITypeChat> Resolve { get => throw null; set { } }
        }
        public class TypeChatRequest
        {
            public TypeChatRequest(string schema, string prompt, string userMessage) => throw null;
            public string NodePath { get => throw null; set { } }
            public int NodeProcessTimeoutMs { get => throw null; set { } }
            public string Prompt { get => throw null; set { } }
            public string Schema { get => throw null; set { } }
            public string SchemaPath { get => throw null; set { } }
            public string ScriptPath { get => throw null; set { } }
            public ServiceStack.AI.TypeChatTranslator TypeChatTranslator { get => throw null; set { } }
            public string UserMessage { get => throw null; }
            public string WorkingDirectory { get => throw null; set { } }
        }
        public class TypeChatResponse
        {
            public TypeChatResponse() => throw null;
            public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
            public string Result { get => throw null; set { } }
        }
        public enum TypeChatTranslator
        {
            Json = 0,
            Program = 1,
        }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class AllowResetAttribute : ServiceStack.AttributeBase
    {
        public AllowResetAttribute() => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class ApiAllowableValuesAttribute : ServiceStack.AttributeBase
    {
        public ApiAllowableValuesAttribute() => throw null;
        public ApiAllowableValuesAttribute(string name) => throw null;
        public ApiAllowableValuesAttribute(string name, int min, int max) => throw null;
        public ApiAllowableValuesAttribute(int min, int max) => throw null;
        public ApiAllowableValuesAttribute(string name, params string[] values) => throw null;
        public ApiAllowableValuesAttribute(string[] values) => throw null;
        public ApiAllowableValuesAttribute(string name, System.Type enumType) => throw null;
        public ApiAllowableValuesAttribute(System.Type enumType) => throw null;
        public ApiAllowableValuesAttribute(string name, System.Func<string[]> listAction) => throw null;
        public ApiAllowableValuesAttribute(System.Func<string[]> listAction) => throw null;
        public int? Max { get => throw null; set { } }
        public int? Min { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string Type { get => throw null; set { } }
        public string[] Values { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
    public class ApiAttribute : ServiceStack.AttributeBase
    {
        public int BodyParameter { get => throw null; set { } }
        public ApiAttribute() => throw null;
        public ApiAttribute(string description) => throw null;
        public ApiAttribute(string description, int generateBodyParameter) => throw null;
        public ApiAttribute(string description, int generateBodyParameter, bool isRequired) => throw null;
        public string Description { get => throw null; set { } }
        public bool IsRequired { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class ApiMemberAttribute : ServiceStack.AttributeBase
    {
        public bool AllowMultiple { get => throw null; set { } }
        public ApiMemberAttribute() => throw null;
        public string DataType { get => throw null; set { } }
        public string Description { get => throw null; set { } }
        public bool ExcludeInSchema { get => throw null; set { } }
        public string Format { get => throw null; set { } }
        public bool IsOptional { get => throw null; set { } }
        public bool IsRequired { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string ParameterType { get => throw null; set { } }
        public string Route { get => throw null; set { } }
        public string Verb { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = true)]
    public class ApiResponseAttribute : ServiceStack.AttributeBase, ServiceStack.IApiResponseDescription
    {
        public ApiResponseAttribute() => throw null;
        public ApiResponseAttribute(System.Net.HttpStatusCode statusCode, string description) => throw null;
        public ApiResponseAttribute(int statusCode, string description) => throw null;
        public string Description { get => throw null; set { } }
        public bool IsDefaultResponse { get => throw null; set { } }
        public System.Type ResponseType { get => throw null; set { } }
        public int StatusCode { get => throw null; set { } }
    }
    [System.Flags]
    public enum ApplyTo
    {
        None = 0,
        All = 2147483647,
        Get = 1,
        Post = 2,
        Put = 4,
        Delete = 8,
        Patch = 16,
        Options = 32,
        Head = 64,
        Connect = 128,
        Trace = 256,
        PropFind = 512,
        PropPatch = 1024,
        MkCol = 2048,
        Copy = 4096,
        Move = 8192,
        Lock = 16384,
        UnLock = 32768,
        Report = 65536,
        CheckOut = 131072,
        CheckIn = 262144,
        UnCheckOut = 524288,
        MkWorkSpace = 1048576,
        Update = 2097152,
        Label = 4194304,
        Merge = 8388608,
        MkActivity = 16777216,
        OrderPatch = 33554432,
        Acl = 67108864,
        Search = 134217728,
        VersionControl = 268435456,
        BaseLineControl = 536870912,
    }
    public class ArrayOfGuid : System.Collections.Generic.List<System.Guid>
    {
        public ArrayOfGuid() => throw null;
        public ArrayOfGuid(System.Collections.Generic.IEnumerable<System.Guid> collection) => throw null;
        public ArrayOfGuid(params System.Guid[] args) => throw null;
    }
    public class ArrayOfGuidId : System.Collections.Generic.List<System.Guid>
    {
        public ArrayOfGuidId() => throw null;
        public ArrayOfGuidId(System.Collections.Generic.IEnumerable<System.Guid> collection) => throw null;
        public ArrayOfGuidId(params System.Guid[] args) => throw null;
    }
    public class ArrayOfInt : System.Collections.Generic.List<int>
    {
        public ArrayOfInt() => throw null;
        public ArrayOfInt(System.Collections.Generic.IEnumerable<int> collection) => throw null;
        public ArrayOfInt(params int[] args) => throw null;
    }
    public class ArrayOfIntId : System.Collections.Generic.List<int>
    {
        public ArrayOfIntId() => throw null;
        public ArrayOfIntId(System.Collections.Generic.IEnumerable<int> collection) => throw null;
        public ArrayOfIntId(params int[] args) => throw null;
    }
    public class ArrayOfLong : System.Collections.Generic.List<long>
    {
        public ArrayOfLong() => throw null;
        public ArrayOfLong(System.Collections.Generic.IEnumerable<long> collection) => throw null;
        public ArrayOfLong(params long[] args) => throw null;
    }
    public class ArrayOfLongId : System.Collections.Generic.List<long>
    {
        public ArrayOfLongId() => throw null;
        public ArrayOfLongId(System.Collections.Generic.IEnumerable<long> collection) => throw null;
        public ArrayOfLongId(params long[] args) => throw null;
    }
    public class ArrayOfString : System.Collections.Generic.List<string>
    {
        public ArrayOfString() => throw null;
        public ArrayOfString(System.Collections.Generic.IEnumerable<string> collection) => throw null;
        public ArrayOfString(params string[] args) => throw null;
    }
    public class ArrayOfStringId : System.Collections.Generic.List<string>
    {
        public ArrayOfStringId() => throw null;
        public ArrayOfStringId(System.Collections.Generic.IEnumerable<string> collection) => throw null;
        public ArrayOfStringId(params string[] args) => throw null;
    }
    public class AttributeBase : System.Attribute
    {
        public AttributeBase() => throw null;
        protected readonly System.Guid typeId;
    }
    public static partial class AttributeExtensions
    {
        public static string GetDescription(this System.Type type) => throw null;
        public static string GetDescription(this System.Reflection.MemberInfo mi) => throw null;
        public static string GetDescription(this System.Reflection.ParameterInfo pi) => throw null;
        public static string GetNotes(this System.Type type) => throw null;
    }
    public abstract class AuditBase
    {
        public string CreatedBy { get => throw null; set { } }
        public System.DateTime CreatedDate { get => throw null; set { } }
        protected AuditBase() => throw null;
        public string DeletedBy { get => throw null; set { } }
        public System.DateTime? DeletedDate { get => throw null; set { } }
        public string ModifiedBy { get => throw null; set { } }
        public System.DateTime ModifiedDate { get => throw null; set { } }
    }
    namespace Auth
    {
        public interface IAuthTokens : ServiceStack.Auth.IUserAuthDetailsExtended
        {
            string AccessToken { get; set; }
            string AccessTokenSecret { get; set; }
            System.Collections.Generic.Dictionary<string, string> Items { get; set; }
            string Provider { get; set; }
            string RefreshToken { get; set; }
            System.DateTime? RefreshTokenExpiry { get; set; }
            string RequestToken { get; set; }
            string RequestTokenSecret { get; set; }
            string UserId { get; set; }
        }
        public interface IPasswordHasher
        {
            string HashPassword(string password);
            bool VerifyPassword(string hashedPassword, string providedPassword, out bool needsRehash);
            byte Version { get; }
        }
        public interface IUserAuth : ServiceStack.IMeta, ServiceStack.Auth.IUserAuthDetailsExtended
        {
            System.DateTime CreatedDate { get; set; }
            string DigestHa1Hash { get; set; }
            int Id { get; set; }
            int InvalidLoginAttempts { get; set; }
            System.DateTime? LastLoginAttempt { get; set; }
            System.DateTime? LockedDate { get; set; }
            System.DateTime ModifiedDate { get; set; }
            string PasswordHash { get; set; }
            System.Collections.Generic.List<string> Permissions { get; set; }
            string PrimaryEmail { get; set; }
            int? RefId { get; set; }
            string RefIdStr { get; set; }
            System.Collections.Generic.List<string> Roles { get; set; }
            string Salt { get; set; }
        }
        public interface IUserAuthDetails : ServiceStack.Auth.IAuthTokens, ServiceStack.IMeta, ServiceStack.Auth.IUserAuthDetailsExtended
        {
            System.DateTime CreatedDate { get; set; }
            int Id { get; set; }
            System.DateTime ModifiedDate { get; set; }
            int? RefId { get; set; }
            string RefIdStr { get; set; }
            int UserAuthId { get; set; }
        }
        public interface IUserAuthDetailsExtended
        {
            string Address { get; set; }
            string Address2 { get; set; }
            System.DateTime? BirthDate { get; set; }
            string BirthDateRaw { get; set; }
            string City { get; set; }
            string Company { get; set; }
            string Country { get; set; }
            string Culture { get; set; }
            string DisplayName { get; set; }
            string Email { get; set; }
            string FirstName { get; set; }
            string FullName { get; set; }
            string Gender { get; set; }
            string Language { get; set; }
            string LastName { get; set; }
            string MailAddress { get; set; }
            string Nickname { get; set; }
            string PhoneNumber { get; set; }
            string PostalCode { get; set; }
            string State { get; set; }
            string TimeZone { get; set; }
            string UserName { get; set; }
        }
        public class UserAuthBase : ServiceStack.IMeta, ServiceStack.Auth.IUserAuth, ServiceStack.Auth.IUserAuthDetailsExtended
        {
            public virtual string Address { get => throw null; set { } }
            public virtual string Address2 { get => throw null; set { } }
            public virtual System.DateTime? BirthDate { get => throw null; set { } }
            public virtual string BirthDateRaw { get => throw null; set { } }
            public virtual string City { get => throw null; set { } }
            public virtual string Company { get => throw null; set { } }
            public virtual string Country { get => throw null; set { } }
            public virtual System.DateTime CreatedDate { get => throw null; set { } }
            public UserAuthBase() => throw null;
            public virtual string Culture { get => throw null; set { } }
            public virtual string DigestHa1Hash { get => throw null; set { } }
            public virtual string DisplayName { get => throw null; set { } }
            public virtual string Email { get => throw null; set { } }
            public virtual string FirstName { get => throw null; set { } }
            public virtual string FullName { get => throw null; set { } }
            public virtual string Gender { get => throw null; set { } }
            public virtual int Id { get => throw null; set { } }
            public virtual int InvalidLoginAttempts { get => throw null; set { } }
            public virtual string Language { get => throw null; set { } }
            public virtual System.DateTime? LastLoginAttempt { get => throw null; set { } }
            public virtual string LastName { get => throw null; set { } }
            public virtual System.DateTime? LockedDate { get => throw null; set { } }
            public virtual string MailAddress { get => throw null; set { } }
            public virtual System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
            public virtual System.DateTime ModifiedDate { get => throw null; set { } }
            public virtual string Nickname { get => throw null; set { } }
            public virtual string PasswordHash { get => throw null; set { } }
            public virtual System.Collections.Generic.List<string> Permissions { get => throw null; set { } }
            public virtual string PhoneNumber { get => throw null; set { } }
            public virtual string PostalCode { get => throw null; set { } }
            public virtual string PrimaryEmail { get => throw null; set { } }
            public virtual int? RefId { get => throw null; set { } }
            public virtual string RefIdStr { get => throw null; set { } }
            public virtual System.Collections.Generic.List<string> Roles { get => throw null; set { } }
            public virtual string Salt { get => throw null; set { } }
            public virtual string State { get => throw null; set { } }
            public virtual string TimeZone { get => throw null; set { } }
            public virtual string UserName { get => throw null; set { } }
        }
        public class UserAuthDetailsBase : ServiceStack.Auth.IAuthTokens, ServiceStack.IMeta, ServiceStack.Auth.IUserAuthDetails, ServiceStack.Auth.IUserAuthDetailsExtended
        {
            public virtual string AccessToken { get => throw null; set { } }
            public virtual string AccessTokenSecret { get => throw null; set { } }
            public virtual string Address { get => throw null; set { } }
            public virtual string Address2 { get => throw null; set { } }
            public virtual System.DateTime? BirthDate { get => throw null; set { } }
            public virtual string BirthDateRaw { get => throw null; set { } }
            public virtual string City { get => throw null; set { } }
            public virtual string Company { get => throw null; set { } }
            public virtual string Country { get => throw null; set { } }
            public virtual System.DateTime CreatedDate { get => throw null; set { } }
            public UserAuthDetailsBase() => throw null;
            public virtual string Culture { get => throw null; set { } }
            public virtual string DisplayName { get => throw null; set { } }
            public virtual string Email { get => throw null; set { } }
            public virtual string FirstName { get => throw null; set { } }
            public virtual string FullName { get => throw null; set { } }
            public virtual string Gender { get => throw null; set { } }
            public virtual int Id { get => throw null; set { } }
            public virtual System.Collections.Generic.Dictionary<string, string> Items { get => throw null; set { } }
            public virtual string Language { get => throw null; set { } }
            public virtual string LastName { get => throw null; set { } }
            public virtual string MailAddress { get => throw null; set { } }
            public virtual System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
            public virtual System.DateTime ModifiedDate { get => throw null; set { } }
            public virtual string Nickname { get => throw null; set { } }
            public virtual string PhoneNumber { get => throw null; set { } }
            public virtual string PostalCode { get => throw null; set { } }
            public virtual string Provider { get => throw null; set { } }
            public virtual int? RefId { get => throw null; set { } }
            public virtual string RefIdStr { get => throw null; set { } }
            public virtual string RefreshToken { get => throw null; set { } }
            public virtual System.DateTime? RefreshTokenExpiry { get => throw null; set { } }
            public virtual string RequestToken { get => throw null; set { } }
            public virtual string RequestTokenSecret { get => throw null; set { } }
            public virtual string State { get => throw null; set { } }
            public virtual string TimeZone { get => throw null; set { } }
            public virtual int UserAuthId { get => throw null; set { } }
            public virtual string UserId { get => throw null; set { } }
            public virtual string UserName { get => throw null; set { } }
        }
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = true)]
    public class AutoApplyAttribute : ServiceStack.AttributeBase
    {
        public string[] Args { get => throw null; }
        public AutoApplyAttribute(string name, params string[] args) => throw null;
        public string Name { get => throw null; }
    }
    [System.AttributeUsage((System.AttributeTargets)132, AllowMultiple = false, Inherited = true)]
    public class AutoDefaultAttribute : ServiceStack.ScriptValueAttribute
    {
        public AutoDefaultAttribute() => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = true)]
    public class AutoFilterAttribute : ServiceStack.ScriptValueAttribute
    {
        public AutoFilterAttribute() => throw null;
        public AutoFilterAttribute(string field) => throw null;
        public AutoFilterAttribute(string field, string template) => throw null;
        public AutoFilterAttribute(ServiceStack.QueryTerm term, string field) => throw null;
        public AutoFilterAttribute(ServiceStack.QueryTerm term, string field, string template) => throw null;
        public string Field { get => throw null; set { } }
        public string Operand { get => throw null; set { } }
        public string Template { get => throw null; set { } }
        public ServiceStack.QueryTerm Term { get => throw null; set { } }
        public string ValueFormat { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class AutoIgnoreAttribute : ServiceStack.AttributeBase
    {
        public AutoIgnoreAttribute() => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)132, AllowMultiple = false, Inherited = true)]
    public class AutoMapAttribute : ServiceStack.AttributeBase
    {
        public AutoMapAttribute(string to) => throw null;
        public AutoMapAttribute() => throw null;
        public string To { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = true)]
    public class AutoPopulateAttribute : ServiceStack.ScriptValueAttribute
    {
        public AutoPopulateAttribute(string field) => throw null;
        public AutoPopulateAttribute() => throw null;
        public string Field { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
    public class AutoQueryViewerAttribute : ServiceStack.AttributeBase
    {
        public string BackgroundColor { get => throw null; set { } }
        public string BackgroundImageUrl { get => throw null; set { } }
        public string BrandImageUrl { get => throw null; set { } }
        public string BrandUrl { get => throw null; set { } }
        public AutoQueryViewerAttribute() => throw null;
        public string DefaultFields { get => throw null; set { } }
        public string DefaultSearchField { get => throw null; set { } }
        public string DefaultSearchText { get => throw null; set { } }
        public string DefaultSearchType { get => throw null; set { } }
        public string Description { get => throw null; set { } }
        public string IconUrl { get => throw null; set { } }
        public string LinkColor { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string TextColor { get => throw null; set { } }
        public string Title { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = true, Inherited = true)]
    public class AutoQueryViewerFieldAttribute : ServiceStack.AttributeBase
    {
        public AutoQueryViewerFieldAttribute() => throw null;
        public string Description { get => throw null; set { } }
        public bool HideInSummary { get => throw null; set { } }
        public string LayoutHint { get => throw null; set { } }
        public string Title { get => throw null; set { } }
        public string ValueFormat { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class AutoUpdateAttribute : ServiceStack.AttributeBase
    {
        public AutoUpdateAttribute(ServiceStack.AutoUpdateStyle style) => throw null;
        public ServiceStack.AutoUpdateStyle Style { get => throw null; set { } }
    }
    public enum AutoUpdateStyle
    {
        Always = 0,
        NonDefaults = 1,
    }
    public static class Behavior
    {
        public const string AuditCreate = default;
        public const string AuditDelete = default;
        public const string AuditModify = default;
        public const string AuditQuery = default;
        public const string AuditSoftDelete = default;
    }
    public class BoolResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public BoolResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public bool Result { get => throw null; set { } }
    }
    namespace Caching
    {
        public interface ICacheClient : System.IDisposable
        {
            bool Add<T>(string key, T value);
            bool Add<T>(string key, T value, System.DateTime expiresAt);
            bool Add<T>(string key, T value, System.TimeSpan expiresIn);
            long Decrement(string key, uint amount);
            void FlushAll();
            T Get<T>(string key);
            System.Collections.Generic.IDictionary<string, T> GetAll<T>(System.Collections.Generic.IEnumerable<string> keys);
            long Increment(string key, uint amount);
            bool Remove(string key);
            void RemoveAll(System.Collections.Generic.IEnumerable<string> keys);
            bool Replace<T>(string key, T value);
            bool Replace<T>(string key, T value, System.DateTime expiresAt);
            bool Replace<T>(string key, T value, System.TimeSpan expiresIn);
            bool Set<T>(string key, T value);
            bool Set<T>(string key, T value, System.DateTime expiresAt);
            bool Set<T>(string key, T value, System.TimeSpan expiresIn);
            void SetAll<T>(System.Collections.Generic.IDictionary<string, T> values);
        }
        public interface ICacheClientAsync : System.IAsyncDisposable
        {
            System.Threading.Tasks.Task<bool> AddAsync<T>(string key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> AddAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> AddAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<long> DecrementAsync(string key, uint amount, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task FlushAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.Collections.Generic.IDictionary<string, T>> GetAllAsync<T>(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<T> GetAsync<T>(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Collections.Generic.IAsyncEnumerable<string> GetKeysByPatternAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.TimeSpan?> GetTimeToLiveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<long> IncrementAsync(string key, uint amount, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task RemoveAllAsync(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> RemoveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task RemoveExpiredEntriesAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> ReplaceAsync<T>(string key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> ReplaceAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> ReplaceAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task SetAllAsync<T>(System.Collections.Generic.IDictionary<string, T> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> SetAsync<T>(string key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> SetAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> SetAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface ICacheClientExtended : ServiceStack.Caching.ICacheClient, System.IDisposable
        {
            System.Collections.Generic.IEnumerable<string> GetKeysByPattern(string pattern);
            System.TimeSpan? GetTimeToLive(string key);
            void RemoveExpiredEntries();
        }
        public interface IDeflateProvider
        {
            byte[] Deflate(string text);
            byte[] Deflate(byte[] bytes);
            System.IO.Stream DeflateStream(System.IO.Stream outputStream);
            string Inflate(byte[] gzBuffer);
            byte[] InflateBytes(byte[] gzBuffer);
            System.IO.Stream InflateStream(System.IO.Stream inputStream);
        }
        public interface IGZipProvider
        {
            string GUnzip(byte[] gzBuffer);
            byte[] GUnzipBytes(byte[] gzBuffer);
            System.IO.Stream GUnzipStream(System.IO.Stream gzStream);
            byte[] GZip(string text);
            byte[] GZip(byte[] bytes);
            System.IO.Stream GZipStream(System.IO.Stream outputStream);
        }
        public interface IMemcachedClient : System.IDisposable
        {
            bool Add(string key, object value);
            bool Add(string key, object value, System.DateTime expiresAt);
            bool CheckAndSet(string key, object value, ulong lastModifiedValue);
            bool CheckAndSet(string key, object value, ulong lastModifiedValue, System.DateTime expiresAt);
            long Decrement(string key, uint amount);
            void FlushAll();
            object Get(string key);
            object Get(string key, out ulong lastModifiedValue);
            System.Collections.Generic.IDictionary<string, object> GetAll(System.Collections.Generic.IEnumerable<string> keys);
            System.Collections.Generic.IDictionary<string, object> GetAll(System.Collections.Generic.IEnumerable<string> keys, out System.Collections.Generic.IDictionary<string, ulong> lastModifiedValues);
            long Increment(string key, uint amount);
            bool Remove(string key);
            void RemoveAll(System.Collections.Generic.IEnumerable<string> keys);
            bool Replace(string key, object value);
            bool Replace(string key, object value, System.DateTime expiresAt);
            bool Set(string key, object value);
            bool Set(string key, object value, System.DateTime expiresAt);
        }
        public interface IRemoveByPattern
        {
            void RemoveByPattern(string pattern);
            void RemoveByRegex(string regex);
        }
        public interface IRemoveByPatternAsync
        {
            System.Threading.Tasks.Task RemoveByPatternAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task RemoveByRegexAsync(string regex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface ISession
        {
            T Get<T>(string key);
            bool Remove(string key);
            void RemoveAll();
            void Set<T>(string key, T value);
            object this[string key] { get; set; }
        }
        public interface ISessionAsync
        {
            System.Threading.Tasks.Task<T> GetAsync<T>(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task RemoveAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> RemoveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task SetAsync<T>(string key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface ISessionFactory
        {
            ServiceStack.Caching.ISession CreateSession(string sessionId);
            ServiceStack.Caching.ISessionAsync CreateSessionAsync(string sessionId);
            ServiceStack.Caching.ISession GetOrCreateSession(ServiceStack.Web.IRequest httpReq, ServiceStack.Web.IResponse httpRes);
            ServiceStack.Caching.ISession GetOrCreateSession();
            ServiceStack.Caching.ISessionAsync GetOrCreateSessionAsync(ServiceStack.Web.IRequest httpReq, ServiceStack.Web.IResponse httpRes);
            ServiceStack.Caching.ISessionAsync GetOrCreateSessionAsync();
        }
        public interface IStreamCompressor
        {
            byte[] Compress(string text, System.Text.Encoding encoding = default(System.Text.Encoding));
            byte[] Compress(byte[] bytes);
            System.IO.Stream Compress(System.IO.Stream outputStream, bool leaveOpen = default(bool));
            string Decompress(byte[] zipBuffer, System.Text.Encoding encoding = default(System.Text.Encoding));
            System.IO.Stream Decompress(System.IO.Stream zipBuffer, bool leaveOpen = default(bool));
            byte[] DecompressBytes(byte[] zipBuffer);
            string Encoding { get; }
        }
    }
    public enum CallStyle : long
    {
        OneWay = 8192,
        Reply = 16384,
    }
    namespace Commands
    {
        public interface ICommand<ReturnType>
        {
            ReturnType Execute();
        }
        public interface ICommand
        {
            void Execute();
        }
        public interface ICommandExec : ServiceStack.Commands.ICommand<bool>
        {
        }
        public interface ICommandList<T> : ServiceStack.Commands.ICommand<System.Collections.Generic.List<T>>
        {
        }
    }
    namespace Configuration
    {
        public interface IAppSettings
        {
            bool Exists(string key);
            T Get<T>(string name);
            T Get<T>(string name, T defaultValue);
            System.Collections.Generic.Dictionary<string, string> GetAll();
            System.Collections.Generic.List<string> GetAllKeys();
            System.Collections.Generic.IDictionary<string, string> GetDictionary(string key);
            System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>> GetKeyValuePairs(string key);
            System.Collections.Generic.IList<string> GetList(string key);
            string GetString(string name);
            void Set<T>(string key, T value);
        }
        public interface IContainerAdapter : ServiceStack.Configuration.IResolver
        {
            T Resolve<T>();
        }
        public interface IHasResolver
        {
            ServiceStack.Configuration.IResolver Resolver { get; }
        }
        public interface IRelease
        {
            void Release(object instance);
        }
        public interface IResolver
        {
            T TryResolve<T>();
        }
        public interface IRuntimeAppSettings
        {
            T Get<T>(ServiceStack.Web.IRequest request, string name, T defaultValue);
        }
        public interface ITypeFactory
        {
            object CreateInstance(ServiceStack.Configuration.IResolver resolver, System.Type type);
        }
    }
    public enum CurrencyDisplay
    {
        Undefined = 0,
        Symbol = 1,
        NarrowSymbol = 2,
        Code = 3,
        Name = 4,
    }
    public enum CurrencySign
    {
        Undefined = 0,
        Accounting = 1,
        Standard = 2,
    }
    namespace Data
    {
        public class DataException : System.Exception
        {
            public DataException() => throw null;
            public DataException(string message) => throw null;
            public DataException(string message, System.Exception innerException) => throw null;
        }
        public interface IEntityStore : System.IDisposable
        {
            void Delete<T>(T entity);
            void DeleteAll<TEntity>();
            void DeleteById<T>(object id);
            void DeleteByIds<T>(System.Collections.ICollection ids);
            T GetById<T>(object id);
            System.Collections.Generic.IList<T> GetByIds<T>(System.Collections.ICollection ids);
            T Store<T>(T entity);
            void StoreAll<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities);
        }
        public interface IEntityStore<T>
        {
            void Delete(T entity);
            void DeleteAll();
            void DeleteById(object id);
            void DeleteByIds(System.Collections.IEnumerable ids);
            System.Collections.Generic.IList<T> GetAll();
            T GetById(object id);
            System.Collections.Generic.IList<T> GetByIds(System.Collections.IEnumerable ids);
            T Store(T entity);
            void StoreAll(System.Collections.Generic.IEnumerable<T> entities);
        }
        public interface IEntityStoreAsync
        {
            System.Threading.Tasks.Task DeleteAllAsync<TEntity>(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task DeleteAsync<T>(T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task DeleteByIdAsync<T>(object id, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task DeleteByIdsAsync<T>(System.Collections.ICollection ids, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<T> GetByIdAsync<T>(object id, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.Collections.Generic.IList<T>> GetByIdsAsync<T>(System.Collections.ICollection ids, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task StoreAllAsync<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<T> StoreAsync<T>(T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IEntityStoreAsync<T>
        {
            System.Threading.Tasks.Task DeleteAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task DeleteAsync(T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task DeleteByIdAsync(object id, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task DeleteByIdsAsync(System.Collections.IEnumerable ids, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.Collections.Generic.IList<T>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<T> GetByIdAsync(object id, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.Collections.Generic.IList<T>> GetByIdsAsync(System.Collections.IEnumerable ids, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task StoreAllAsync(System.Collections.Generic.IEnumerable<T> entities, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<T> StoreAsync(T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public class OptimisticConcurrencyException : ServiceStack.Data.DataException
        {
            public OptimisticConcurrencyException() => throw null;
            public OptimisticConcurrencyException(string message) => throw null;
            public OptimisticConcurrencyException(string message, System.Exception innerException) => throw null;
        }
    }
    namespace DataAnnotations
    {
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class AddColumnAttribute : ServiceStack.DataAnnotations.AlterColumnAttribute
        {
            public AddColumnAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)460)]
        public class AliasAttribute : ServiceStack.AttributeBase
        {
            public AliasAttribute(string name) => throw null;
            public string Name { get => throw null; set { } }
        }
        public abstract class AlterColumnAttribute : ServiceStack.AttributeBase
        {
            protected AlterColumnAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)384)]
        public class AutoIdAttribute : ServiceStack.AttributeBase
        {
            public AutoIdAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)384)]
        public class AutoIncrementAttribute : ServiceStack.AttributeBase
        {
            public AutoIncrementAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class BelongToAttribute : ServiceStack.AttributeBase
        {
            public System.Type BelongToTableType { get => throw null; set { } }
            public BelongToAttribute(System.Type belongToTableType) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class CheckConstraintAttribute : ServiceStack.AttributeBase
        {
            public string Constraint { get => throw null; }
            public CheckConstraintAttribute(string constraint) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)12, AllowMultiple = true)]
        public class CompositeIndexAttribute : ServiceStack.AttributeBase
        {
            public CompositeIndexAttribute() => throw null;
            public CompositeIndexAttribute(params string[] fieldNames) => throw null;
            public CompositeIndexAttribute(bool unique, params string[] fieldNames) => throw null;
            public System.Collections.Generic.List<string> FieldNames { get => throw null; set { } }
            public string Name { get => throw null; set { } }
            public bool Unique { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)12, AllowMultiple = false)]
        public class CompositeKeyAttribute : ServiceStack.AttributeBase
        {
            public CompositeKeyAttribute() => throw null;
            public CompositeKeyAttribute(params string[] fieldNames) => throw null;
            public System.Collections.Generic.List<string> FieldNames { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class ComputeAttribute : ServiceStack.AttributeBase
        {
            public ComputeAttribute() => throw null;
            public ComputeAttribute(string expression) => throw null;
            public string Expression { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class ComputedAttribute : ServiceStack.AttributeBase
        {
            public ComputedAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class CustomFieldAttribute : ServiceStack.AttributeBase
        {
            public CustomFieldAttribute() => throw null;
            public CustomFieldAttribute(string sql) => throw null;
            public int Order { get => throw null; set { } }
            public string Sql { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class CustomInsertAttribute : ServiceStack.AttributeBase
        {
            public CustomInsertAttribute(string sql) => throw null;
            public string Sql { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class CustomSelectAttribute : ServiceStack.AttributeBase
        {
            public CustomSelectAttribute(string sql) => throw null;
            public string Sql { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class CustomUpdateAttribute : ServiceStack.AttributeBase
        {
            public CustomUpdateAttribute(string sql) => throw null;
            public string Sql { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class DecimalLengthAttribute : ServiceStack.AttributeBase
        {
            public DecimalLengthAttribute(int precision, int scale) => throw null;
            public DecimalLengthAttribute(int precision) => throw null;
            public DecimalLengthAttribute() => throw null;
            public int Precision { get => throw null; set { } }
            public int Scale { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)384)]
        public class DefaultAttribute : ServiceStack.AttributeBase
        {
            public DefaultAttribute(int intValue) => throw null;
            public DefaultAttribute(double doubleValue) => throw null;
            public DefaultAttribute(string defaultValue) => throw null;
            public DefaultAttribute(System.Type defaultType, string defaultValue) => throw null;
            public System.Type DefaultType { get => throw null; set { } }
            public string DefaultValue { get => throw null; set { } }
            public double DoubleValue { get => throw null; set { } }
            public int IntValue { get => throw null; set { } }
            public bool OnUpdate { get => throw null; set { } }
        }
        public class DescriptionAttribute : ServiceStack.AttributeBase
        {
            public DescriptionAttribute(string description) => throw null;
            public string Description { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)16)]
        public class EnumAsCharAttribute : ServiceStack.AttributeBase
        {
            public EnumAsCharAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)16)]
        public class EnumAsIntAttribute : ServiceStack.AttributeBase
        {
            public EnumAsIntAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true)]
        public class ExcludeAttribute : ServiceStack.AttributeBase
        {
            public ExcludeAttribute(ServiceStack.Feature feature) => throw null;
            public ServiceStack.Feature Feature { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)132)]
        public class ExcludeMetadataAttribute : ServiceStack.DataAnnotations.ExcludeAttribute
        {
            public ExcludeMetadataAttribute() : base(default(ServiceStack.Feature)) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class ForeignKeyAttribute : ServiceStack.DataAnnotations.ReferencesAttribute
        {
            public ForeignKeyAttribute(System.Type type) : base(default(System.Type)) => throw null;
            public string ForeignKeyName { get => throw null; set { } }
            public string OnDelete { get => throw null; set { } }
            public string OnUpdate { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class HashKeyAttribute : ServiceStack.AttributeBase
        {
            public HashKeyAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)460)]
        public class IdAttribute : ServiceStack.AttributeBase
        {
            public IdAttribute(int id) => throw null;
            public int Id { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class IgnoreAttribute : ServiceStack.AttributeBase
        {
            public IgnoreAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class IgnoreOnInsertAttribute : ServiceStack.AttributeBase
        {
            public IgnoreOnInsertAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class IgnoreOnSelectAttribute : ServiceStack.AttributeBase
        {
            public IgnoreOnSelectAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class IgnoreOnUpdateAttribute : ServiceStack.AttributeBase
        {
            public IgnoreOnUpdateAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)396)]
        public class IndexAttribute : ServiceStack.AttributeBase
        {
            public bool Clustered { get => throw null; set { } }
            public IndexAttribute() => throw null;
            public IndexAttribute(bool unique) => throw null;
            public string Name { get => throw null; set { } }
            public bool NonClustered { get => throw null; set { } }
            public bool Unique { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
        public class MapColumnAttribute : ServiceStack.AttributeBase
        {
            public string Column { get => throw null; set { } }
            public MapColumnAttribute(string table, string column) => throw null;
            public string Table { get => throw null; set { } }
        }
        public class MetaAttribute : ServiceStack.AttributeBase
        {
            public MetaAttribute(string name, string value) => throw null;
            public string Name { get => throw null; set { } }
            public string Value { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class PersistedAttribute : ServiceStack.AttributeBase
        {
            public PersistedAttribute() => throw null;
        }
        public class PgSqlBigIntArrayAttribute : ServiceStack.DataAnnotations.PgSqlLongArrayAttribute
        {
            public PgSqlBigIntArrayAttribute() => throw null;
        }
        public class PgSqlDecimalArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlDecimalArrayAttribute() => throw null;
        }
        public class PgSqlDoubleArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlDoubleArrayAttribute() => throw null;
        }
        public class PgSqlFloatArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlFloatArrayAttribute() => throw null;
        }
        public class PgSqlHStoreAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlHStoreAttribute() => throw null;
        }
        public class PgSqlIntArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlIntArrayAttribute() => throw null;
        }
        public class PgSqlJsonAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlJsonAttribute() => throw null;
        }
        public class PgSqlJsonBAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlJsonBAttribute() => throw null;
        }
        public class PgSqlLongArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlLongArrayAttribute() => throw null;
        }
        public class PgSqlShortArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlShortArrayAttribute() => throw null;
        }
        public class PgSqlTextArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTextArrayAttribute() => throw null;
        }
        public class PgSqlTimestampArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTimestampArrayAttribute() => throw null;
        }
        public class PgSqlTimestampAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTimestampAttribute() => throw null;
        }
        public class PgSqlTimestampTzArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTimestampTzArrayAttribute() => throw null;
        }
        public class PgSqlTimestampTzAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTimestampTzAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true)]
        public class PostCreateTableAttribute : ServiceStack.AttributeBase
        {
            public PostCreateTableAttribute(string sql) => throw null;
            public string Sql { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true)]
        public class PostDropTableAttribute : ServiceStack.AttributeBase
        {
            public PostDropTableAttribute(string sql) => throw null;
            public string Sql { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true)]
        public class PreCreateTableAttribute : ServiceStack.AttributeBase
        {
            public PreCreateTableAttribute(string sql) => throw null;
            public string Sql { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true)]
        public class PreDropTableAttribute : ServiceStack.AttributeBase
        {
            public PreDropTableAttribute(string sql) => throw null;
            public string Sql { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class PrimaryKeyAttribute : ServiceStack.AttributeBase
        {
            public PrimaryKeyAttribute() => throw null;
        }
        public class RangeAttribute : ServiceStack.AttributeBase
        {
            public RangeAttribute(int minimum, int maximum) => throw null;
            public RangeAttribute(double minimum, double maximum) => throw null;
            public RangeAttribute(System.Type type, string minimum, string maximum) => throw null;
            public object Maximum { get => throw null; }
            public object Minimum { get => throw null; }
            public System.Type OperandType { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class RangeKeyAttribute : ServiceStack.AttributeBase
        {
            public RangeKeyAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class ReferenceAttribute : ServiceStack.AttributeBase
        {
            public ReferenceAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class ReferenceFieldAttribute : ServiceStack.AttributeBase
        {
            public ReferenceFieldAttribute() => throw null;
            public ReferenceFieldAttribute(System.Type model, string id) => throw null;
            public ReferenceFieldAttribute(System.Type model, string id, string field) => throw null;
            public string Field { get => throw null; set { } }
            public string Id { get => throw null; set { } }
            public System.Type Model { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)396, AllowMultiple = true)]
        public class ReferencesAttribute : ServiceStack.AttributeBase
        {
            public ReferencesAttribute(System.Type type) => throw null;
            public System.Type Type { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class RemoveColumnAttribute : ServiceStack.DataAnnotations.AlterColumnAttribute
        {
            public RemoveColumnAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class RenameColumnAttribute : ServiceStack.DataAnnotations.AlterColumnAttribute
        {
            public RenameColumnAttribute(string from) => throw null;
            public string From { get => throw null; }
        }
        public class RequiredAttribute : ServiceStack.AttributeBase
        {
            public RequiredAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class ReturnOnInsertAttribute : ServiceStack.AttributeBase
        {
            public ReturnOnInsertAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class RowVersionAttribute : ServiceStack.AttributeBase
        {
            public RowVersionAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)4)]
        public class SchemaAttribute : ServiceStack.AttributeBase
        {
            public SchemaAttribute(string name) => throw null;
            public string Name { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class SequenceAttribute : ServiceStack.AttributeBase
        {
            public SequenceAttribute(string name) => throw null;
            public string Name { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false)]
        public class SqlServerBucketCountAttribute : ServiceStack.AttributeBase
        {
            public int Count { get => throw null; set { } }
            public SqlServerBucketCountAttribute(int count) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false)]
        public class SqlServerCollateAttribute : ServiceStack.AttributeBase
        {
            public string Collation { get => throw null; set { } }
            public SqlServerCollateAttribute(string collation) => throw null;
        }
        public enum SqlServerDurability
        {
            SchemaOnly = 0,
            SchemaAndData = 1,
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
        public class SqlServerFileTableAttribute : ServiceStack.AttributeBase
        {
            public SqlServerFileTableAttribute() => throw null;
            public SqlServerFileTableAttribute(string directory, string collateFileName = default(string)) => throw null;
            public string FileTableCollateFileName { get => throw null; }
            public string FileTableDirectory { get => throw null; }
        }
        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false)]
        public class SqlServerMemoryOptimizedAttribute : ServiceStack.AttributeBase
        {
            public SqlServerMemoryOptimizedAttribute() => throw null;
            public SqlServerMemoryOptimizedAttribute(ServiceStack.DataAnnotations.SqlServerDurability durability) => throw null;
            public ServiceStack.DataAnnotations.SqlServerDurability? Durability { get => throw null; set { } }
        }
        public class StringLengthAttribute : ServiceStack.AttributeBase
        {
            public StringLengthAttribute(int maximumLength) => throw null;
            public StringLengthAttribute(int minimumLength, int maximumLength) => throw null;
            public int MaximumLength { get => throw null; set { } }
            public const int MaxText = 2147483647;
            public int MinimumLength { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)128)]
        public class UniqueAttribute : ServiceStack.AttributeBase
        {
            public UniqueAttribute() => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)12, AllowMultiple = true)]
        public class UniqueConstraintAttribute : ServiceStack.AttributeBase
        {
            public UniqueConstraintAttribute() => throw null;
            public UniqueConstraintAttribute(params string[] fieldNames) => throw null;
            public System.Collections.Generic.List<string> FieldNames { get => throw null; set { } }
            public string Name { get => throw null; set { } }
        }
        [System.AttributeUsage((System.AttributeTargets)460)]
        public class UniqueIdAttribute : ServiceStack.AttributeBase
        {
            public UniqueIdAttribute(int id) => throw null;
            public int Id { get => throw null; }
        }
    }
    public enum DateMonth
    {
        Undefined = 0,
        Numeric = 1,
        Digits2 = 2,
        Narrow = 3,
        Short = 4,
        Long = 5,
    }
    public enum DatePart
    {
        Undefined = 0,
        Numeric = 1,
        Digits2 = 2,
    }
    public enum DateStyle
    {
        Undefined = 0,
        Full = 1,
        Long = 2,
        Medium = 3,
        Short = 4,
    }
    public enum DateText
    {
        Undefined = 0,
        Narrow = 1,
        Short = 2,
        Long = 3,
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class DenyResetAttribute : ServiceStack.AttributeBase
    {
        public DenyResetAttribute() => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitCodeAttribute : ServiceStack.AttributeBase
    {
        public EmitCodeAttribute(ServiceStack.Lang lang, string statement) => throw null;
        public EmitCodeAttribute(ServiceStack.Lang lang, string[] statements) => throw null;
        public ServiceStack.Lang Lang { get => throw null; set { } }
        public string[] Statements { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitCSharp : ServiceStack.EmitCodeAttribute
    {
        public EmitCSharp(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitDart : ServiceStack.EmitCodeAttribute
    {
        public EmitDart(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitFSharp : ServiceStack.EmitCodeAttribute
    {
        public EmitFSharp(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitJava : ServiceStack.EmitCodeAttribute
    {
        public EmitJava(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitKotlin : ServiceStack.EmitCodeAttribute
    {
        public EmitKotlin(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitPhp : ServiceStack.EmitCodeAttribute
    {
        public EmitPhp(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitPython : ServiceStack.EmitCodeAttribute
    {
        public EmitPython(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitSwift : ServiceStack.EmitCodeAttribute
    {
        public EmitSwift(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitTypeScript : ServiceStack.EmitCodeAttribute
    {
        public EmitTypeScript(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)140, AllowMultiple = true)]
    public class EmitVb : ServiceStack.EmitCodeAttribute
    {
        public EmitVb(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }
    public class EmptyResponse : ServiceStack.IHasResponseStatus
    {
        public EmptyResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    public enum Endpoint : long
    {
        Http = 67108864,
        Mq = 134217728,
        Tcp = 268435456,
        Other = 536870912,
    }
    public class ErrorResponse : ServiceStack.IHasResponseStatus
    {
        public ErrorResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = false)]
    public class ExplorerCssAttribute : ServiceStack.AttributeBase
    {
        public ExplorerCssAttribute() => throw null;
        public string Field { get => throw null; set { } }
        public string Fieldset { get => throw null; set { } }
        public string Form { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = false, Inherited = true)]
    public class FallbackRouteAttribute : ServiceStack.RouteAttribute
    {
        public FallbackRouteAttribute(string path) : base(default(string)) => throw null;
        public FallbackRouteAttribute(string path, string verbs) : base(default(string)) => throw null;
    }
    [System.Flags]
    public enum Feature
    {
        None = 0,
        All = 2147483647,
        Soap = 192,
        Metadata = 1,
        PredefinedRoutes = 2,
        RequestInfo = 4,
        Json = 8,
        Xml = 16,
        Jsv = 32,
        Soap11 = 64,
        Soap12 = 128,
        Csv = 256,
        Html = 512,
        CustomFormat = 1024,
        Markdown = 2048,
        Razor = 4096,
        ProtoBuf = 8192,
        MsgPack = 16384,
        Wire = 32768,
        Grpc = 65536,
        ServiceDiscovery = 131072,
        Validation = 262144,
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = true)]
    public class FieldAttribute : ServiceStack.InputAttributeBase
    {
        public FieldAttribute() => throw null;
        public FieldAttribute(string name) => throw null;
        public string FieldCss { get => throw null; set { } }
        public string InputCss { get => throw null; set { } }
        public string LabelCss { get => throw null; set { } }
        public string Name { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = false)]
    public class FieldCssAttribute : ServiceStack.AttributeBase
    {
        public FieldCssAttribute() => throw null;
        public string Field { get => throw null; set { } }
        public string Input { get => throw null; set { } }
        public string Label { get => throw null; set { } }
    }
    public enum Format : long
    {
        Soap11 = 32768,
        Soap12 = 65536,
        Xml = 131072,
        Json = 262144,
        Jsv = 524288,
        ProtoBuf = 1048576,
        Csv = 2097152,
        Html = 4194304,
        Wire = 8388608,
        MsgPack = 16777216,
        Other = 33554432,
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class FormatAttribute : ServiceStack.AttributeBase
    {
        public FormatAttribute() => throw null;
        public FormatAttribute(string method) => throw null;
        public string Locale { get => throw null; set { } }
        public string Method { get => throw null; set { } }
        public string Options { get => throw null; set { } }
    }
    public class FormatEnumFlags : ServiceStack.FormatAttribute
    {
        public FormatEnumFlags(string type) => throw null;
    }
    public static class FormatMethods
    {
        public const string Attachment = default;
        public const string Bytes = default;
        public const string Currency = default;
        public const string EnumFlags = default;
        public const string Hidden = default;
        public const string Icon = default;
        public const string IconRounded = default;
        public const string Link = default;
        public const string LinkEmail = default;
        public const string LinkPhone = default;
    }
    public static class GenerateBodyParameter
    {
        public const int Always = 1;
        public const int IfNotDisabled = 0;
        public const int Never = 2;
    }
    public enum Http : long
    {
        Head = 32,
        Get = 64,
        Post = 128,
        Put = 256,
        Delete = 512,
        Patch = 1024,
        Options = 2048,
        Other = 4096,
    }
    public interface IAny<T>
    {
        object Any(T request);
    }
    public interface IAnyAsync<T>
    {
        System.Threading.Tasks.Task<object> AnyAsync(T request);
    }
    public interface IAnyVoid<T>
    {
        void Any(T request);
    }
    public interface IAnyVoidAsync<T>
    {
        System.Threading.Tasks.Task AnyAsync(T request);
    }
    public interface IApiResponseDescription
    {
        string Description { get; }
        int StatusCode { get; }
    }
    public interface ICompressor
    {
        string Compress(string source);
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
    public class IconAttribute : ServiceStack.AttributeBase
    {
        public string Alt { get => throw null; set { } }
        public string Cls { get => throw null; set { } }
        public IconAttribute() => throw null;
        public string Svg { get => throw null; set { } }
        public string Uri { get => throw null; set { } }
    }
    public interface IContainer
    {
        ServiceStack.IContainer AddSingleton(System.Type type, System.Func<object> factory);
        ServiceStack.IContainer AddTransient(System.Type type, System.Func<object> factory);
        System.Func<object> CreateFactory(System.Type type);
        bool Exists(System.Type type);
        object Resolve(System.Type type);
    }
    public interface ICreateDb<Table> : ServiceStack.ICrud
    {
    }
    public interface ICrud
    {
    }
    public interface IDelete : ServiceStack.IVerb
    {
    }
    public interface IDelete<T>
    {
        object Delete(T request);
    }
    public interface IDeleteAsync<T>
    {
        System.Threading.Tasks.Task<object> DeleteAsync(T request);
    }
    public interface IDeleteDb<Table> : ServiceStack.ICrud
    {
    }
    public interface IDeleteVoid<T>
    {
        void Delete(T request);
    }
    public interface IDeleteVoidAsync<T>
    {
        System.Threading.Tasks.Task DeleteAsync(T request);
    }
    public class IdResponse : ServiceStack.IHasResponseStatus
    {
        public IdResponse() => throw null;
        public string Id { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
    }
    public interface IEncryptedClient : ServiceStack.IHasBearerToken, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IReplyClient, ServiceStack.IServiceGateway
    {
        ServiceStack.IJsonServiceClient Client { get; }
        TResponse Send<TResponse>(string httpMethod, object request);
        TResponse Send<TResponse>(string httpMethod, ServiceStack.IReturn<TResponse> request);
        string ServerPublicKeyXml { get; }
    }
    public interface IGet : ServiceStack.IVerb
    {
    }
    public interface IGet<T>
    {
        object Get(T request);
    }
    public interface IGetAsync<T>
    {
        System.Threading.Tasks.Task<object> GetAsync(T request);
    }
    public interface IGetVoid<T>
    {
        void Get(T request);
    }
    public interface IGetVoidAsync<T>
    {
        System.Threading.Tasks.Task GetAsync(T request);
    }
    public interface IHasAuthSecret
    {
        string AuthSecret { get; set; }
    }
    public interface IHasBearerToken
    {
        string BearerToken { get; set; }
    }
    public interface IHasErrorCode
    {
        string ErrorCode { get; }
    }
    public interface IHasErrorStatus
    {
        ServiceStack.ResponseStatus Error { get; }
    }
    public interface IHasQueryParams
    {
        System.Collections.Generic.Dictionary<string, string> QueryParams { get; set; }
    }
    public interface IHasRefreshToken
    {
        string RefreshToken { get; set; }
    }
    public interface IHasResponseStatus
    {
        ServiceStack.ResponseStatus ResponseStatus { get; set; }
    }
    public interface IHasSessionId
    {
        string SessionId { get; set; }
    }
    public interface IHasTraceId
    {
        string TraceId { get; }
    }
    public interface IHasVersion
    {
        int Version { get; set; }
    }
    public interface IHtmlString
    {
        string ToHtmlString();
    }
    public interface IHttpRestClientAsync : System.IDisposable, ServiceStack.IRestClientAsync, ServiceStack.IServiceClientCommon
    {
        System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(string httpMethod, string absoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }
    public interface IJoin
    {
    }
    public interface IJoin<Source, Join1> : ServiceStack.IJoin
    {
    }
    public interface IJoin<Source, Join1, Join2> : ServiceStack.IJoin
    {
    }
    public interface IJoin<Source, Join1, Join2, Join3> : ServiceStack.IJoin
    {
    }
    public interface IJoin<Source, Join1, Join2, Join3, Join4> : ServiceStack.IJoin
    {
    }
    public interface IJsonServiceClient : System.IDisposable, ServiceStack.IHasBearerToken, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IHttpRestClientAsync, ServiceStack.IOneWayClient, ServiceStack.IReplyClient, ServiceStack.IRestClient, ServiceStack.IRestClientAsync, ServiceStack.IRestClientSync, ServiceStack.IRestServiceClient, ServiceStack.IServiceClient, ServiceStack.IServiceClientAsync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientSync, ServiceStack.IServiceGateway, ServiceStack.IServiceGatewayAsync
    {
        string BaseUri { get; }
    }
    public interface ILeftJoin<Source, Join1> : ServiceStack.IJoin
    {
    }
    public interface ILeftJoin<Source, Join1, Join2> : ServiceStack.IJoin
    {
    }
    public interface ILeftJoin<Source, Join1, Join2, Join3> : ServiceStack.IJoin
    {
    }
    public interface ILeftJoin<Source, Join1, Join2, Join3, Join4> : ServiceStack.IJoin
    {
    }
    public interface IMeta
    {
        System.Collections.Generic.Dictionary<string, string> Meta { get; set; }
    }
    public class InfoException : System.Exception
    {
        public InfoException(string message) => throw null;
        public override string ToString() => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)128)]
    public class InputAttribute : ServiceStack.InputAttributeBase
    {
        public InputAttribute() => throw null;
    }
    public class InputAttributeBase : ServiceStack.MetadataAttributeBase
    {
        public string Accept { get => throw null; set { } }
        public string[] AllowableValues { get => throw null; set { } }
        public System.Type AllowableValuesEnum { get => throw null; set { } }
        public string Autocomplete { get => throw null; set { } }
        public string Autofocus { get => throw null; set { } }
        public string Capture { get => throw null; set { } }
        public InputAttributeBase() => throw null;
        public bool Disabled { get => throw null; set { } }
        public string EvalAllowableEntries { get => throw null; set { } }
        public string EvalAllowableValues { get => throw null; set { } }
        public string Help { get => throw null; set { } }
        public bool Ignore { get => throw null; set { } }
        public string Label { get => throw null; set { } }
        public string Max { get => throw null; set { } }
        public int MaxLength { get => throw null; set { } }
        public string Min { get => throw null; set { } }
        public int MinLength { get => throw null; set { } }
        public bool Multiple { get => throw null; set { } }
        public string Options { get => throw null; set { } }
        public string Pattern { get => throw null; set { } }
        public string Placeholder { get => throw null; set { } }
        public bool ReadOnly { get => throw null; set { } }
        public bool Required { get => throw null; set { } }
        public string Size { get => throw null; set { } }
        public string Step { get => throw null; set { } }
        public string Title { get => throw null; set { } }
        public string Type { get => throw null; set { } }
        public string Value { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class Intl : ServiceStack.MetadataAttributeBase
    {
        public Intl() => throw null;
        public Intl(ServiceStack.IntlFormat type) => throw null;
        public string Currency { get => throw null; set { } }
        public ServiceStack.CurrencyDisplay CurrencyDisplay { get => throw null; set { } }
        public ServiceStack.CurrencySign CurrencySign { get => throw null; set { } }
        public ServiceStack.DateStyle Date { get => throw null; set { } }
        public ServiceStack.DatePart Day { get => throw null; set { } }
        public ServiceStack.DateText Era { get => throw null; set { } }
        public int FractionalSecondDigits { get => throw null; set { } }
        public ServiceStack.DatePart Hour { get => throw null; set { } }
        public bool Hour12 { get => throw null; set { } }
        public string Locale { get => throw null; set { } }
        public int MaximumFractionDigits { get => throw null; set { } }
        public int MaximumSignificantDigits { get => throw null; set { } }
        public int MinimumFractionDigits { get => throw null; set { } }
        public int MinimumIntegerDigits { get => throw null; set { } }
        public int MinimumSignificantDigits { get => throw null; set { } }
        public ServiceStack.DatePart Minute { get => throw null; set { } }
        public ServiceStack.DateMonth Month { get => throw null; set { } }
        public ServiceStack.Notation Notation { get => throw null; set { } }
        public ServiceStack.NumberStyle Number { get => throw null; set { } }
        public ServiceStack.Numeric Numeric { get => throw null; set { } }
        public string Options { get => throw null; set { } }
        public ServiceStack.RelativeTimeStyle RelativeTime { get => throw null; set { } }
        public ServiceStack.RoundingMode RoundingMode { get => throw null; set { } }
        public ServiceStack.DatePart Second { get => throw null; set { } }
        public ServiceStack.SignDisplay SignDisplay { get => throw null; set { } }
        public ServiceStack.TimeStyle Time { get => throw null; set { } }
        public string TimeZone { get => throw null; set { } }
        public ServiceStack.DateText TimeZoneName { get => throw null; set { } }
        public ServiceStack.IntlFormat Type { get => throw null; set { } }
        public string Unit { get => throw null; set { } }
        public ServiceStack.UnitDisplay UnitDisplay { get => throw null; set { } }
        public ServiceStack.DateText Weekday { get => throw null; set { } }
        public ServiceStack.DatePart Year { get => throw null; set { } }
    }
    public class IntlDateTime : ServiceStack.Intl
    {
        public IntlDateTime() => throw null;
        public IntlDateTime(ServiceStack.DateStyle date, ServiceStack.TimeStyle time = default(ServiceStack.TimeStyle)) => throw null;
        public override bool ShouldInclude(System.Reflection.PropertyInfo pi, string value) => throw null;
    }
    public enum IntlFormat
    {
        Number = 0,
        DateTime = 1,
        RelativeTime = 2,
    }
    public class IntlNumber : ServiceStack.Intl
    {
        public IntlNumber() => throw null;
        public IntlNumber(ServiceStack.NumberStyle style) => throw null;
        public override bool ShouldInclude(System.Reflection.PropertyInfo pi, string value) => throw null;
    }
    public class IntlRelativeTime : ServiceStack.Intl
    {
        public IntlRelativeTime() => throw null;
        public IntlRelativeTime(ServiceStack.Numeric numeric) => throw null;
        public override bool ShouldInclude(System.Reflection.PropertyInfo pi, string value) => throw null;
    }
    public class IntResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public IntResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public int Result { get => throw null; set { } }
    }
    namespace IO
    {
        public interface IEndpoint
        {
            string Host { get; }
            int Port { get; }
        }
        public interface IHasVirtualFiles
        {
            ServiceStack.IO.IVirtualDirectory GetDirectory();
            ServiceStack.IO.IVirtualFile GetFile();
            bool IsDirectory { get; }
            bool IsFile { get; }
        }
        public interface IRequireVirtualFiles
        {
            ServiceStack.IO.IVirtualFiles VirtualFiles { get; set; }
        }
        public interface IVirtualDirectory : System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualNode>, System.Collections.IEnumerable, ServiceStack.IO.IVirtualNode
        {
            System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> Directories { get; }
            System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> Files { get; }
            System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllMatchingFiles(string globPattern, int maxDepth = default(int));
            ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath);
            ServiceStack.IO.IVirtualDirectory GetDirectory(System.Collections.Generic.Stack<string> virtualPath);
            ServiceStack.IO.IVirtualFile GetFile(string virtualPath);
            ServiceStack.IO.IVirtualFile GetFile(System.Collections.Generic.Stack<string> virtualPath);
            bool IsRoot { get; }
            ServiceStack.IO.IVirtualDirectory ParentDirectory { get; }
        }
        public interface IVirtualFile : ServiceStack.IO.IVirtualNode
        {
            string Extension { get; }
            object GetContents();
            string GetFileHash();
            long Length { get; }
            System.IO.Stream OpenRead();
            System.IO.StreamReader OpenText();
            System.Threading.Tasks.Task<byte[]> ReadAllBytesAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            string ReadAllText();
            System.Threading.Tasks.Task<string> ReadAllTextAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            void Refresh();
            ServiceStack.IO.IVirtualPathProvider VirtualPathProvider { get; }
            System.Threading.Tasks.Task WritePartialToAsync(System.IO.Stream toStream, long start, long end, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IVirtualFiles : ServiceStack.IO.IVirtualPathProvider
        {
            void AppendFile(string filePath, string textContents);
            void AppendFile(string filePath, System.IO.Stream stream);
            void AppendFile(string filePath, object contents);
            void DeleteFile(string filePath);
            void DeleteFiles(System.Collections.Generic.IEnumerable<string> filePaths);
            void DeleteFolder(string dirPath);
            void WriteFile(string filePath, string textContents);
            void WriteFile(string filePath, System.IO.Stream stream);
            void WriteFile(string filePath, object contents);
            System.Threading.Tasks.Task WriteFileAsync(string filePath, object contents, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            void WriteFiles(System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> files, System.Func<ServiceStack.IO.IVirtualFile, string> toPath = default(System.Func<ServiceStack.IO.IVirtualFile, string>));
            void WriteFiles(System.Collections.Generic.Dictionary<string, string> textFiles);
            void WriteFiles(System.Collections.Generic.Dictionary<string, object> files);
        }
        public interface IVirtualFilesAsync : ServiceStack.IO.IVirtualFiles, ServiceStack.IO.IVirtualPathProvider
        {
            System.Threading.Tasks.Task AppendFileAsync(string filePath, string textContents);
            System.Threading.Tasks.Task AppendFileAsync(string filePath, System.IO.Stream stream);
            System.Threading.Tasks.Task DeleteFileAsync(string filePath);
            System.Threading.Tasks.Task DeleteFilesAsync(System.Collections.Generic.IEnumerable<string> filePaths);
            System.Threading.Tasks.Task DeleteFolderAsync(string dirPath);
            System.Threading.Tasks.Task WriteFileAsync(string filePath, string textContents);
            System.Threading.Tasks.Task WriteFileAsync(string filePath, System.IO.Stream stream);
            System.Threading.Tasks.Task WriteFilesAsync(System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> files, System.Func<ServiceStack.IO.IVirtualFile, string> toPath = default(System.Func<ServiceStack.IO.IVirtualFile, string>));
        }
        public interface IVirtualNode
        {
            ServiceStack.IO.IVirtualDirectory Directory { get; }
            bool IsDirectory { get; }
            System.DateTime LastModified { get; }
            string Name { get; }
            string RealPath { get; }
            string VirtualPath { get; }
        }
        public interface IVirtualPathProvider
        {
            string CombineVirtualPath(string basePath, string relativePath);
            bool DirectoryExists(string virtualPath);
            bool FileExists(string virtualPath);
            System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllFiles();
            System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetAllMatchingFiles(string globPattern, int maxDepth = default(int));
            ServiceStack.IO.IVirtualDirectory GetDirectory(string virtualPath);
            ServiceStack.IO.IVirtualFile GetFile(string virtualPath);
            string GetFileHash(string virtualPath);
            string GetFileHash(ServiceStack.IO.IVirtualFile virtualFile);
            System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualDirectory> GetRootDirectories();
            System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> GetRootFiles();
            bool IsSharedFile(ServiceStack.IO.IVirtualFile virtualFile);
            bool IsViewFile(ServiceStack.IO.IVirtualFile virtualFile);
            string RealPathSeparator { get; }
            ServiceStack.IO.IVirtualDirectory RootDirectory { get; }
            string VirtualPathSeparator { get; }
        }
    }
    public interface IOneWayClient
    {
        void SendAllOneWay(System.Collections.Generic.IEnumerable<object> requests);
        void SendOneWay(object requestDto);
        void SendOneWay(string relativeOrAbsoluteUri, object requestDto);
    }
    public interface IOptions : ServiceStack.IVerb
    {
    }
    public interface IOptionsAsync<T>
    {
        System.Threading.Tasks.Task<object> OptionsAsync(T request);
    }
    public interface IOptionsVerb<T>
    {
        object Options(T request);
    }
    public interface IOptionsVoid<T>
    {
        void Options(T request);
    }
    public interface IOptionsVoidAsync<T>
    {
        System.Threading.Tasks.Task OptionsAsync(T request);
    }
    public interface IPatch : ServiceStack.IVerb
    {
    }
    public interface IPatch<T>
    {
        object Patch(T request);
    }
    public interface IPatchAsync<T>
    {
        System.Threading.Tasks.Task<object> PatchAsync(T request);
    }
    public interface IPatchDb<Table> : ServiceStack.ICrud
    {
    }
    public interface IPatchVoid<T>
    {
        void Patch(T request);
    }
    public interface IPatchVoidAsync<T>
    {
        System.Threading.Tasks.Task PatchAsync(T request);
    }
    public interface IPost : ServiceStack.IVerb
    {
    }
    public interface IPost<T>
    {
        object Post(T request);
    }
    public interface IPostAsync<T>
    {
        System.Threading.Tasks.Task<object> PostAsync(T request);
    }
    public interface IPostVoid<T>
    {
        void Post(T request);
    }
    public interface IPostVoidAsync<T>
    {
        System.Threading.Tasks.Task PostAsync(T request);
    }
    public interface IPut : ServiceStack.IVerb
    {
    }
    public interface IPut<T>
    {
        object Put(T request);
    }
    public interface IPutAsync<T>
    {
        System.Threading.Tasks.Task<object> PutAsync(T request);
    }
    public interface IPutVoid<T>
    {
        void Put(T request);
    }
    public interface IPutVoidAsync<T>
    {
        System.Threading.Tasks.Task PutAsync(T request);
    }
    public interface IQuery : ServiceStack.IMeta
    {
        string Fields { get; set; }
        string Include { get; set; }
        string OrderBy { get; set; }
        string OrderByDesc { get; set; }
        int? Skip { get; set; }
        int? Take { get; set; }
    }
    public interface IQueryData : ServiceStack.IMeta, ServiceStack.IQuery
    {
    }
    public interface IQueryData<From> : ServiceStack.IMeta, ServiceStack.IQuery, ServiceStack.IQueryData
    {
    }
    public interface IQueryData<From, Into> : ServiceStack.IMeta, ServiceStack.IQuery, ServiceStack.IQueryData
    {
    }
    public interface IQueryDb : ServiceStack.IMeta, ServiceStack.IQuery
    {
    }
    public interface IQueryDb<From> : ServiceStack.IMeta, ServiceStack.IQuery, ServiceStack.IQueryDb
    {
    }
    public interface IQueryDb<From, Into> : ServiceStack.IMeta, ServiceStack.IQuery, ServiceStack.IQueryDb
    {
    }
    public interface IQueryResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        int Offset { get; set; }
        int Total { get; set; }
    }
    public interface IRawString
    {
        string ToRawString();
    }
    public interface IReceiver
    {
        void NoSuchMethod(string selector, object message);
    }
    public interface IReflectAttributeConverter
    {
        ServiceStack.ReflectAttribute ToReflectAttribute();
    }
    public interface IReflectAttributeFilter
    {
        bool ShouldInclude(System.Reflection.PropertyInfo pi, string value);
    }
    public interface IReplyClient : ServiceStack.IServiceGateway
    {
    }
    public interface IRequiresSchema
    {
        void InitSchema();
    }
    public interface IRequiresSchemaAsync
    {
        System.Threading.Tasks.Task InitSchemaAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }
    public interface IResponseStatus
    {
        string ErrorCode { get; set; }
        string ErrorMessage { get; set; }
        bool IsSuccess { get; }
        string StackTrace { get; set; }
    }
    public interface IRestClient : System.IDisposable, ServiceStack.IRestClientSync, ServiceStack.IServiceClientCommon
    {
        void AddHeader(string name, string value);
        void ClearCookies();
        TResponse Delete<TResponse>(string relativeOrAbsoluteUrl);
        TResponse Get<TResponse>(string relativeOrAbsoluteUrl);
        System.Collections.Generic.Dictionary<string, string> GetCookieValues();
        System.Collections.Generic.IEnumerable<TResponse> GetLazy<TResponse>(ServiceStack.IReturn<ServiceStack.QueryResponse<TResponse>> queryDto);
        TResponse Patch<TResponse>(string relativeOrAbsoluteUrl, object requestDto);
        TResponse Post<TResponse>(string relativeOrAbsoluteUrl, object request);
        TResponse PostFile<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, string mimeType, string fieldName = default(string));
        TResponse PostFilesWithRequest<TResponse>(object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files);
        TResponse PostFilesWithRequest<TResponse>(string relativeOrAbsoluteUrl, object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files);
        TResponse PostFileWithRequest<TResponse>(System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string));
        TResponse PostFileWithRequest<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string));
        TResponse Put<TResponse>(string relativeOrAbsoluteUrl, object requestDto);
        TResponse Send<TResponse>(string httpMethod, string relativeOrAbsoluteUrl, object request);
        void SetCookie(string name, string value, System.TimeSpan? expiresIn = default(System.TimeSpan?));
    }
    public interface IRestClientAsync : System.IDisposable, ServiceStack.IServiceClientCommon
    {
        System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task CustomMethodAsync(string httpVerb, ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task DeleteAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task GetAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task PatchAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task PostAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task PutAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }
    public interface IRestClientSync : System.IDisposable, ServiceStack.IServiceClientCommon
    {
        TResponse CustomMethod<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto);
        TResponse CustomMethod<TResponse>(string httpVerb, object requestDto);
        void CustomMethod(string httpVerb, ServiceStack.IReturnVoid requestDto);
        TResponse Delete<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
        TResponse Delete<TResponse>(object requestDto);
        void Delete(ServiceStack.IReturnVoid requestDto);
        TResponse Get<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
        TResponse Get<TResponse>(object requestDto);
        void Get(ServiceStack.IReturnVoid requestDto);
        TResponse Patch<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
        TResponse Patch<TResponse>(object requestDto);
        void Patch(ServiceStack.IReturnVoid requestDto);
        TResponse Post<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
        TResponse Post<TResponse>(object requestDto);
        void Post(ServiceStack.IReturnVoid requestDto);
        TResponse Put<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
        TResponse Put<TResponse>(object requestDto);
        void Put(ServiceStack.IReturnVoid requestDto);
    }
    public interface IRestGateway
    {
        T Delete<T>(ServiceStack.IReturn<T> request);
        T Get<T>(ServiceStack.IReturn<T> request);
        T Post<T>(ServiceStack.IReturn<T> request);
        T Put<T>(ServiceStack.IReturn<T> request);
        T Send<T>(ServiceStack.IReturn<T> request);
    }
    public interface IRestGatewayAsync
    {
        System.Threading.Tasks.Task<T> DeleteAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
        System.Threading.Tasks.Task<T> GetAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
        System.Threading.Tasks.Task<T> PostAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
        System.Threading.Tasks.Task<T> PutAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
        System.Threading.Tasks.Task<T> SendAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
    }
    public interface IRestServiceClient : System.IDisposable, ServiceStack.IHasBearerToken, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IRestClientAsync, ServiceStack.IRestClientSync, ServiceStack.IServiceClientAsync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientSync, ServiceStack.IServiceGateway, ServiceStack.IServiceGatewayAsync
    {
    }
    public interface IReturn
    {
    }
    public interface IReturn<T> : ServiceStack.IReturn
    {
    }
    public interface IReturnVoid : ServiceStack.IReturn
    {
    }
    public interface ISaveDb<Table> : ServiceStack.ICrud
    {
    }
    public interface IScriptValue
    {
        string Eval { get; set; }
        string Expression { get; set; }
        bool NoCache { get; set; }
        object Value { get; set; }
    }
    public interface ISequenceSource : ServiceStack.IRequiresSchema
    {
        long Increment(string key, long amount = default(long));
        void Reset(string key, long startingAt = default(long));
    }
    public interface ISequenceSourceAsync : ServiceStack.IRequiresSchema
    {
        System.Threading.Tasks.Task<long> IncrementAsync(string key, long amount = default(long), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task ResetAsync(string key, long startingAt = default(long), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }
    public interface IService
    {
    }
    public interface IServiceAfterFilter
    {
        object OnAfterExecute(object response);
    }
    public interface IServiceAfterFilterAsync
    {
        System.Threading.Tasks.Task<object> OnAfterExecuteAsync(object response);
    }
    public interface IServiceBeforeFilter
    {
        void OnBeforeExecute(object requestDto);
    }
    public interface IServiceBeforeFilterAsync
    {
        System.Threading.Tasks.Task OnBeforeExecuteAsync(object requestDto);
    }
    public interface IServiceClient : System.IDisposable, ServiceStack.IHasBearerToken, ServiceStack.IHasSessionId, ServiceStack.IHasVersion, ServiceStack.IHttpRestClientAsync, ServiceStack.IOneWayClient, ServiceStack.IReplyClient, ServiceStack.IRestClient, ServiceStack.IRestClientAsync, ServiceStack.IRestClientSync, ServiceStack.IRestServiceClient, ServiceStack.IServiceClientAsync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientSync, ServiceStack.IServiceGateway, ServiceStack.IServiceGatewayAsync
    {
    }
    public interface IServiceClientAsync : System.IDisposable, ServiceStack.IRestClientAsync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceGatewayAsync
    {
    }
    public interface IServiceClientCommon : System.IDisposable
    {
        void SetCredentials(string userName, string password);
    }
    public interface IServiceClientSync : System.IDisposable, ServiceStack.IRestClientSync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceGateway
    {
    }
    public interface IServiceErrorFilter
    {
        System.Threading.Tasks.Task<object> OnExceptionAsync(object requestDto, System.Exception ex);
    }
    public interface IServiceFilters : ServiceStack.IServiceAfterFilter, ServiceStack.IServiceBeforeFilter, ServiceStack.IServiceErrorFilter
    {
    }
    public interface IServiceGateway
    {
        void Publish(object requestDto);
        void PublishAll(System.Collections.Generic.IEnumerable<object> requestDtos);
        TResponse Send<TResponse>(object requestDto);
        System.Collections.Generic.List<TResponse> SendAll<TResponse>(System.Collections.Generic.IEnumerable<object> requestDtos);
    }
    public interface IServiceGatewayAsync
    {
        System.Threading.Tasks.Task PublishAllAsync(System.Collections.Generic.IEnumerable<object> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task PublishAsync(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<System.Collections.Generic.List<TResponse>> SendAllAsync<TResponse>(System.Collections.Generic.IEnumerable<object> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }
    public interface IStream : ServiceStack.IVerb
    {
    }
    public interface IUpdateDb<Table> : ServiceStack.ICrud
    {
    }
    public interface IUrlFilter
    {
        string ToUrl(string absoluteUrl);
    }
    public interface IValidateRule
    {
        string Condition { get; set; }
        string ErrorCode { get; set; }
        string Message { get; set; }
        string Validator { get; set; }
    }
    public interface IValidationSource
    {
        System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, ServiceStack.IValidateRule>> GetValidationRules(System.Type type);
    }
    public interface IValidationSourceAdmin
    {
        System.Threading.Tasks.Task ClearCacheAsync();
        System.Threading.Tasks.Task DeleteValidationRulesAsync(params int[] ids);
        System.Collections.Generic.List<ServiceStack.ValidationRule> GetAllValidateRules();
        System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.ValidationRule>> GetAllValidateRulesAsync();
        System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.ValidationRule>> GetAllValidateRulesAsync(string typeName);
        System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.ValidationRule>> GetValidateRulesByIdsAsync(params int[] ids);
        void SaveValidationRules(System.Collections.Generic.List<ServiceStack.ValidationRule> validateRules);
        System.Threading.Tasks.Task SaveValidationRulesAsync(System.Collections.Generic.List<ServiceStack.ValidationRule> validateRules);
    }
    public interface IVerb
    {
    }
    [System.Flags]
    public enum Lang
    {
        CSharp = 1,
        FSharp = 2,
        Vb = 4,
        TypeScript = 8,
        Dart = 16,
        Swift = 32,
        Java = 64,
        Kotlin = 128,
        Python = 256,
        Go = 512,
        Php = 1024,
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = false)]
    public class LocodeCssAttribute : ServiceStack.AttributeBase
    {
        public LocodeCssAttribute() => throw null;
        public string Field { get => throw null; set { } }
        public string Fieldset { get => throw null; set { } }
        public string Form { get => throw null; set { } }
    }
    namespace Logging
    {
        public class GenericLogFactory : ServiceStack.Logging.ILogFactory
        {
            public GenericLogFactory(System.Action<string> onMessage) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
            public System.Action<string> OnMessage;
        }
        public class GenericLogger : ServiceStack.Logging.ILog
        {
            public bool CaptureLogs { get => throw null; set { } }
            public GenericLogger(System.Type type) => throw null;
            public GenericLogger(string type) => throw null;
            public void Debug(object message, System.Exception exception) => throw null;
            public void Debug(object message) => throw null;
            public void DebugFormat(string format, params object[] args) => throw null;
            public void Error(object message, System.Exception exception) => throw null;
            public void Error(object message) => throw null;
            public void ErrorFormat(string format, params object[] args) => throw null;
            public void Fatal(object message, System.Exception exception) => throw null;
            public void Fatal(object message) => throw null;
            public void FatalFormat(string format, params object[] args) => throw null;
            public void Info(object message, System.Exception exception) => throw null;
            public void Info(object message) => throw null;
            public void InfoFormat(string format, params object[] args) => throw null;
            public bool IsDebugEnabled { get => throw null; set { } }
            public virtual void Log(object message, System.Exception exception) => throw null;
            public virtual void Log(object message) => throw null;
            public virtual void LogFormat(object message, params object[] args) => throw null;
            public System.Text.StringBuilder Logs;
            public virtual void OnLog(string message) => throw null;
            public System.Action<string> OnMessage;
            public void Warn(object message, System.Exception exception) => throw null;
            public void Warn(object message) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }
        public interface ILog
        {
            void Debug(object message);
            void Debug(object message, System.Exception exception);
            void DebugFormat(string format, params object[] args);
            void Error(object message);
            void Error(object message, System.Exception exception);
            void ErrorFormat(string format, params object[] args);
            void Fatal(object message);
            void Fatal(object message, System.Exception exception);
            void FatalFormat(string format, params object[] args);
            void Info(object message);
            void Info(object message, System.Exception exception);
            void InfoFormat(string format, params object[] args);
            bool IsDebugEnabled { get; }
            void Warn(object message);
            void Warn(object message, System.Exception exception);
            void WarnFormat(string format, params object[] args);
        }
        public interface ILogFactory
        {
            ServiceStack.Logging.ILog GetLogger(System.Type type);
            ServiceStack.Logging.ILog GetLogger(string typeName);
        }
        public interface ILogTrace
        {
            bool IsTraceEnabled { get; }
            void Trace(object message);
            void Trace(object message, System.Exception exception);
            void TraceFormat(string format, params object[] args);
        }
        public interface ILogWithContext : ServiceStack.Logging.ILog, ServiceStack.Logging.ILogWithException
        {
            System.IDisposable PushProperty(string key, object value);
        }
        public static partial class ILogWithContextExtensions
        {
            public static System.IDisposable PushProperty(this ServiceStack.Logging.ILog logger, string key, object value) => throw null;
        }
        public interface ILogWithException : ServiceStack.Logging.ILog
        {
            void Debug(System.Exception exception, string format, params object[] args);
            void Error(System.Exception exception, string format, params object[] args);
            void Fatal(System.Exception exception, string format, params object[] args);
            void Info(System.Exception exception, string format, params object[] args);
            void Warn(System.Exception exception, string format, params object[] args);
        }
        public static partial class ILogWithExceptionExtensions
        {
            public static void Debug(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
            public static void Error(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
            public static void Fatal(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
            public static void Info(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
            public static void Warn(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
        }
        public class LazyLogger : ServiceStack.Logging.ILog
        {
            public LazyLogger(System.Type type) => throw null;
            public void Debug(object message) => throw null;
            public void Debug(object message, System.Exception exception) => throw null;
            public void DebugFormat(string format, params object[] args) => throw null;
            public void Error(object message) => throw null;
            public void Error(object message, System.Exception exception) => throw null;
            public void ErrorFormat(string format, params object[] args) => throw null;
            public void Fatal(object message) => throw null;
            public void Fatal(object message, System.Exception exception) => throw null;
            public void FatalFormat(string format, params object[] args) => throw null;
            public void Info(object message) => throw null;
            public void Info(object message, System.Exception exception) => throw null;
            public void InfoFormat(string format, params object[] args) => throw null;
            public bool IsDebugEnabled { get => throw null; }
            public System.Type Type { get => throw null; }
            public void Warn(object message) => throw null;
            public void Warn(object message, System.Exception exception) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }
        public class LogManager
        {
            public LogManager() => throw null;
            public static ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public static ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
            public static ServiceStack.Logging.ILogFactory LogFactory { get => throw null; set { } }
        }
        public static class LogUtils
        {
            public static bool IsTraceEnabled(this ServiceStack.Logging.ILog log) => throw null;
            public static void Trace(this ServiceStack.Logging.ILog log, object message) => throw null;
            public static void Trace(this ServiceStack.Logging.ILog log, object message, System.Exception exception) => throw null;
            public static void TraceFormat(this ServiceStack.Logging.ILog log, string format, params object[] args) => throw null;
        }
        public class NullDebugLogger : ServiceStack.Logging.ILog
        {
            public NullDebugLogger(string type) => throw null;
            public NullDebugLogger(System.Type type) => throw null;
            public void Debug(object message, System.Exception exception) => throw null;
            public void Debug(object message) => throw null;
            public void DebugFormat(string format, params object[] args) => throw null;
            public void Error(object message, System.Exception exception) => throw null;
            public void Error(object message) => throw null;
            public void ErrorFormat(string format, params object[] args) => throw null;
            public void Fatal(object message, System.Exception exception) => throw null;
            public void Fatal(object message) => throw null;
            public void FatalFormat(string format, params object[] args) => throw null;
            public void Info(object message, System.Exception exception) => throw null;
            public void Info(object message) => throw null;
            public void InfoFormat(string format, params object[] args) => throw null;
            public bool IsDebugEnabled { get => throw null; set { } }
            public void Warn(object message, System.Exception exception) => throw null;
            public void Warn(object message) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }
        public class NullLogFactory : ServiceStack.Logging.ILogFactory
        {
            public NullLogFactory(bool debugEnabled = default(bool)) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
        }
        public class StringBuilderLog : ServiceStack.Logging.ILog
        {
            public StringBuilderLog(string type, System.Text.StringBuilder logs) => throw null;
            public StringBuilderLog(System.Type type, System.Text.StringBuilder logs) => throw null;
            public void Debug(object message, System.Exception exception) => throw null;
            public void Debug(object message) => throw null;
            public void DebugFormat(string format, params object[] args) => throw null;
            public void Error(object message, System.Exception exception) => throw null;
            public void Error(object message) => throw null;
            public void ErrorFormat(string format, params object[] args) => throw null;
            public void Fatal(object message, System.Exception exception) => throw null;
            public void Fatal(object message) => throw null;
            public void FatalFormat(string format, params object[] args) => throw null;
            public void Info(object message, System.Exception exception) => throw null;
            public void Info(object message) => throw null;
            public void InfoFormat(string format, params object[] args) => throw null;
            public bool IsDebugEnabled { get => throw null; set { } }
            public void Warn(object message, System.Exception exception) => throw null;
            public void Warn(object message) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }
        public class StringBuilderLogFactory : ServiceStack.Logging.ILogFactory
        {
            public void ClearLogs() => throw null;
            public StringBuilderLogFactory(bool debugEnabled = default(bool)) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
            public string GetLogs() => throw null;
        }
        public class TestLogFactory : ServiceStack.Logging.ILogFactory
        {
            public TestLogFactory(bool debugEnabled = default(bool)) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
        }
        public class TestLogger : ServiceStack.Logging.ILog
        {
            public TestLogger(string type) => throw null;
            public TestLogger(System.Type type) => throw null;
            public void Debug(object message, System.Exception exception) => throw null;
            public void Debug(object message) => throw null;
            public void DebugFormat(string format, params object[] args) => throw null;
            public void Error(object message, System.Exception exception) => throw null;
            public void Error(object message) => throw null;
            public void ErrorFormat(string format, params object[] args) => throw null;
            public void Fatal(object message, System.Exception exception) => throw null;
            public void Fatal(object message) => throw null;
            public void FatalFormat(string format, params object[] args) => throw null;
            public static System.Collections.Generic.IList<System.Collections.Generic.KeyValuePair<ServiceStack.Logging.TestLogger.Levels, string>> GetLogs() => throw null;
            public void Info(object message, System.Exception exception) => throw null;
            public void Info(object message) => throw null;
            public void InfoFormat(string format, params object[] args) => throw null;
            public bool IsDebugEnabled { get => throw null; set { } }
            public enum Levels
            {
                DEBUG = 0,
                ERROR = 1,
                FATAL = 2,
                INFO = 3,
                WARN = 4,
            }
            public void Warn(object message, System.Exception exception) => throw null;
            public void Warn(object message) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }
    }
    namespace Messaging
    {
        public interface IMessage : ServiceStack.Model.IHasId<System.Guid>, ServiceStack.IMeta
        {
            object Body { get; set; }
            System.DateTime CreatedDate { get; }
            ServiceStack.ResponseStatus Error { get; set; }
            int Options { get; set; }
            long Priority { get; set; }
            System.Guid? ReplyId { get; set; }
            string ReplyTo { get; set; }
            int RetryAttempts { get; set; }
            string Tag { get; set; }
            string TraceId { get; set; }
        }
        public interface IMessage<T> : ServiceStack.Model.IHasId<System.Guid>, ServiceStack.Messaging.IMessage, ServiceStack.IMeta
        {
            T GetBody();
        }
        public interface IMessageFactory : System.IDisposable, ServiceStack.Messaging.IMessageQueueClientFactory
        {
            ServiceStack.Messaging.IMessageProducer CreateMessageProducer();
        }
        public interface IMessageHandler
        {
            ServiceStack.Messaging.IMessageHandlerStats GetStats();
            System.Type MessageType { get; }
            ServiceStack.Messaging.IMessageQueueClient MqClient { get; }
            void Process(ServiceStack.Messaging.IMessageQueueClient mqClient);
            void ProcessMessage(ServiceStack.Messaging.IMessageQueueClient mqClient, object mqResponse);
            int ProcessQueue(ServiceStack.Messaging.IMessageQueueClient mqClient, string queueName, System.Func<bool> doNext = default(System.Func<bool>));
        }
        public interface IMessageHandlerStats
        {
            void Add(ServiceStack.Messaging.IMessageHandlerStats stats);
            System.DateTime? LastMessageProcessed { get; }
            string Name { get; }
            int TotalMessagesFailed { get; }
            int TotalMessagesProcessed { get; }
            int TotalNormalMessagesReceived { get; }
            int TotalPriorityMessagesReceived { get; }
            int TotalRetries { get; }
        }
        public interface IMessageProducer : System.IDisposable
        {
            void Publish<T>(T messageBody);
            void Publish<T>(ServiceStack.Messaging.IMessage<T> message);
        }
        public interface IMessageQueueClient : System.IDisposable, ServiceStack.Messaging.IMessageProducer
        {
            void Ack(ServiceStack.Messaging.IMessage message);
            ServiceStack.Messaging.IMessage<T> CreateMessage<T>(object mqResponse);
            ServiceStack.Messaging.IMessage<T> Get<T>(string queueName, System.TimeSpan? timeOut = default(System.TimeSpan?));
            ServiceStack.Messaging.IMessage<T> GetAsync<T>(string queueName);
            string GetTempQueueName();
            void Nak(ServiceStack.Messaging.IMessage message, bool requeue, System.Exception exception = default(System.Exception));
            void Notify(string queueName, ServiceStack.Messaging.IMessage message);
            void Publish(string queueName, ServiceStack.Messaging.IMessage message);
        }
        public interface IMessageQueueClientFactory : System.IDisposable
        {
            ServiceStack.Messaging.IMessageQueueClient CreateMessageQueueClient();
        }
        public interface IMessageSerializer
        {
            byte[] ToBytes(ServiceStack.Messaging.IMessage message);
            byte[] ToBytes<T>(ServiceStack.Messaging.IMessage<T> message);
            ServiceStack.Messaging.IMessage ToMessage(byte[] bytes, System.Type ofType);
            ServiceStack.Messaging.Message<T> ToMessage<T>(byte[] bytes);
        }
        public interface IMessageService : System.IDisposable
        {
            ServiceStack.Messaging.IMessageHandlerStats GetStats();
            string GetStatsDescription();
            string GetStatus();
            ServiceStack.Messaging.IMessageFactory MessageFactory { get; }
            System.Collections.Generic.List<System.Type> RegisteredTypes { get; }
            void RegisterHandler<T>(System.Func<ServiceStack.Messaging.IMessage<T>, object> processMessageFn);
            void RegisterHandler<T>(System.Func<ServiceStack.Messaging.IMessage<T>, object> processMessageFn, int noOfThreads);
            void RegisterHandler<T>(System.Func<ServiceStack.Messaging.IMessage<T>, object> processMessageFn, System.Action<ServiceStack.Messaging.IMessageHandler, ServiceStack.Messaging.IMessage<T>, System.Exception> processExceptionEx);
            void RegisterHandler<T>(System.Func<ServiceStack.Messaging.IMessage<T>, object> processMessageFn, System.Action<ServiceStack.Messaging.IMessageHandler, ServiceStack.Messaging.IMessage<T>, System.Exception> processExceptionEx, int noOfThreads);
            void Start();
            void Stop();
        }
        public class Message : ServiceStack.Model.IHasId<System.Guid>, ServiceStack.Messaging.IMessage, ServiceStack.IMeta
        {
            public object Body { get => throw null; set { } }
            public static ServiceStack.Messaging.Message<T> Create<T>(T request) => throw null;
            public System.DateTime CreatedDate { get => throw null; set { } }
            public Message() => throw null;
            public ServiceStack.ResponseStatus Error { get => throw null; set { } }
            public System.Guid Id { get => throw null; set { } }
            public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
            public int Options { get => throw null; set { } }
            public long Priority { get => throw null; set { } }
            public System.Guid? ReplyId { get => throw null; set { } }
            public string ReplyTo { get => throw null; set { } }
            public int RetryAttempts { get => throw null; set { } }
            public string Tag { get => throw null; set { } }
            public string TraceId { get => throw null; set { } }
        }
        public class Message<T> : ServiceStack.Messaging.Message, ServiceStack.Model.IHasId<System.Guid>, ServiceStack.Messaging.IMessage<T>, ServiceStack.Messaging.IMessage, ServiceStack.IMeta
        {
            public static ServiceStack.Messaging.IMessage Create(object oBody) => throw null;
            public Message() => throw null;
            public Message(T body) => throw null;
            public T GetBody() => throw null;
            public override string ToString() => throw null;
        }
        public static class MessageFactory
        {
            public static ServiceStack.Messaging.IMessage Create(object response) => throw null;
        }
        public class MessageHandlerStats : ServiceStack.Messaging.IMessageHandlerStats
        {
            public virtual void Add(ServiceStack.Messaging.IMessageHandlerStats stats) => throw null;
            public MessageHandlerStats(string name) => throw null;
            public MessageHandlerStats(string name, int totalMessagesProcessed, int totalMessagesFailed, int totalRetries, int totalNormalMessagesReceived, int totalPriorityMessagesReceived, System.DateTime? lastMessageProcessed) => throw null;
            public System.DateTime? LastMessageProcessed { get => throw null; }
            public string Name { get => throw null; }
            public override string ToString() => throw null;
            public int TotalMessagesFailed { get => throw null; }
            public int TotalMessagesProcessed { get => throw null; }
            public int TotalNormalMessagesReceived { get => throw null; }
            public int TotalPriorityMessagesReceived { get => throw null; }
            public int TotalRetries { get => throw null; }
        }
        public static partial class MessageHandlerStatsExtensions
        {
            public static ServiceStack.Messaging.IMessageHandlerStats CombineStats(this System.Collections.Generic.IEnumerable<ServiceStack.Messaging.IMessageHandlerStats> stats) => throw null;
        }
        [System.Flags]
        public enum MessageOption
        {
            None = 0,
            All = 2147483647,
            NotifyOneWay = 1,
        }
        public class MessagingException : System.Exception, ServiceStack.IHasResponseStatus, ServiceStack.Model.IResponseStatusConvertible
        {
            public MessagingException() => throw null;
            public MessagingException(string message) => throw null;
            public MessagingException(string message, System.Exception innerException) => throw null;
            public MessagingException(ServiceStack.ResponseStatus responseStatus, System.Exception innerException = default(System.Exception)) => throw null;
            public MessagingException(ServiceStack.ResponseStatus responseStatus, object responseDto, System.Exception innerException = default(System.Exception)) => throw null;
            public object ResponseDto { get => throw null; set { } }
            public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
            public ServiceStack.ResponseStatus ToResponseStatus() => throw null;
        }
        public static class QueueNames<T>
        {
            public static string[] AllQueueNames { get => throw null; }
            public static string Dlq { get => throw null; }
            public static string In { get => throw null; }
            public static string Out { get => throw null; }
            public static string Priority { get => throw null; }
        }
        public class QueueNames
        {
            public QueueNames(System.Type messageType) => throw null;
            public string Dlq { get => throw null; }
            public static string Exchange;
            public static string ExchangeDlq;
            public static string ExchangeTopic;
            public static string GetTempQueueName() => throw null;
            public string In { get => throw null; }
            public static bool IsTempQueue(string queueName) => throw null;
            public static string MqPrefix;
            public string Out { get => throw null; }
            public string Priority { get => throw null; }
            public static string QueuePrefix;
            public static string ResolveQueueName(string typeName, string queueSuffix) => throw null;
            public static System.Func<string, string, string> ResolveQueueNameFn;
            public static void SetQueuePrefix(string prefix) => throw null;
            public static string TempMqPrefix;
            public static string TopicIn;
            public static string TopicOut;
        }
        public class UnRetryableMessagingException : ServiceStack.Messaging.MessagingException
        {
            public UnRetryableMessagingException() => throw null;
            public UnRetryableMessagingException(string message) => throw null;
            public UnRetryableMessagingException(string message, System.Exception innerException) => throw null;
        }
        public static class WorkerStatus
        {
            public const int Disposed = -1;
            public const int Started = 3;
            public const int Starting = 2;
            public const int Stopped = 0;
            public const int Stopping = 1;
            public static string ToString(int workerStatus) => throw null;
        }
    }
    public class MetadataAttributeBase : ServiceStack.AttributeBase, ServiceStack.IReflectAttributeFilter
    {
        public MetadataAttributeBase() => throw null;
        public virtual bool ShouldInclude(System.Reflection.PropertyInfo pi, string value) => throw null;
    }
    namespace Model
    {
        public interface ICacheByDateModified
        {
            System.DateTime? LastModified { get; }
        }
        public interface ICacheByEtag
        {
            string Etag { get; }
        }
        public interface IHasAction
        {
            string Action { get; }
        }
        public interface IHasGuidId : ServiceStack.Model.IHasId<System.Guid>
        {
        }
        public interface IHasId<T>
        {
            T Id { get; }
        }
        public interface IHasIntId : ServiceStack.Model.IHasId<int>
        {
        }
        public interface IHasLongId : ServiceStack.Model.IHasId<long>
        {
        }
        public interface IHasNamed<T>
        {
            T this[string listId] { get; set; }
        }
        public interface IHasNamedCollection<T> : ServiceStack.Model.IHasNamed<System.Collections.Generic.ICollection<T>>
        {
        }
        public interface IHasNamedList<T> : ServiceStack.Model.IHasNamed<System.Collections.Generic.IList<T>>
        {
        }
        public interface IHasStringId : ServiceStack.Model.IHasId<string>
        {
        }
        public interface IMutId<T>
        {
            T Id { get; set; }
        }
        public interface IMutIntId : ServiceStack.Model.IMutId<int>
        {
        }
        public interface IMutLongId : ServiceStack.Model.IMutId<long>
        {
        }
        public interface IMutStringId : ServiceStack.Model.IMutId<string>
        {
        }
        public interface IResponseStatusConvertible
        {
            ServiceStack.ResponseStatus ToResponseStatus();
        }
    }
    [System.AttributeUsage((System.AttributeTargets)384)]
    public class MultiPartFieldAttribute : ServiceStack.AttributeBase
    {
        public string ContentType { get => throw null; set { } }
        public MultiPartFieldAttribute(string contentType) => throw null;
        public MultiPartFieldAttribute(System.Type stringSerializer) => throw null;
        public System.Type StringSerializer { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = true)]
    public class NamedConnectionAttribute : ServiceStack.AttributeBase
    {
        public NamedConnectionAttribute(string name) => throw null;
        public string Name { get => throw null; set { } }
    }
    public class NavItem : ServiceStack.IMeta
    {
        public System.Collections.Generic.List<ServiceStack.NavItem> Children { get => throw null; set { } }
        public string ClassName { get => throw null; set { } }
        public NavItem() => throw null;
        public bool? Exact { get => throw null; set { } }
        public string Hide { get => throw null; set { } }
        public string Href { get => throw null; set { } }
        public string IconClass { get => throw null; set { } }
        public string IconSrc { get => throw null; set { } }
        public string Id { get => throw null; set { } }
        public string Label { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string Show { get => throw null; set { } }
    }
    public enum Network : long
    {
        Localhost = 1,
        LocalSubnet = 2,
        External = 4,
    }
    public enum Notation
    {
        Undefined = 0,
        Standard = 1,
        Scientific = 2,
        Engineering = 3,
        Compact = 4,
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
    public class NotesAttribute : ServiceStack.AttributeBase
    {
        public NotesAttribute(string notes) => throw null;
        public string Notes { get => throw null; set { } }
    }
    public static class NumberCurrency
    {
        public const string AED = default;
        public static string[] All;
        public const string AUD = default;
        public const string BRL = default;
        public const string CAD = default;
        public const string CHF = default;
        public const string CLP = default;
        public const string CNY = default;
        public const string COP = default;
        public const string CZK = default;
        public const string DKK = default;
        public const string EUR = default;
        public const string GBP = default;
        public const string HKD = default;
        public const string HUF = default;
        public const string IDR = default;
        public const string ILS = default;
        public const string INR = default;
        public const string JPY = default;
        public const string KRW = default;
        public const string MXN = default;
        public const string MYR = default;
        public const string NOK = default;
        public const string NZD = default;
        public const string PHP = default;
        public const string PLN = default;
        public const string RON = default;
        public const string RUB = default;
        public const string SAR = default;
        public const string SEK = default;
        public const string SGD = default;
        public const string THB = default;
        public const string TRY = default;
        public const string TWD = default;
        public const string USD = default;
        public const string ZAR = default;
    }
    public enum NumberStyle
    {
        Undefined = 0,
        Decimal = 1,
        Currency = 2,
        Percent = 3,
        Unit = 4,
    }
    public static class NumberUnit
    {
        public const string Acre = default;
        public const string Bit = default;
        public const string Byte = default;
        public const string Celsius = default;
        public const string Centimeter = default;
        public const string Day = default;
        public const string Degree = default;
        public const string Fahrenheit = default;
        public const string Foot = default;
        public const string Gallon = default;
        public const string Gigabit = default;
        public const string Gigabyte = default;
        public const string Gram = default;
        public const string Hectare = default;
        public const string Hour = default;
        public const string Inch = default;
        public const string Kilobit = default;
        public const string Kilobyte = default;
        public const string Kilogram = default;
        public const string Kilometer = default;
        public const string Liter = default;
        public const string Megabit = default;
        public const string Megabyte = default;
        public const string Meter = default;
        public const string Mile = default;
        public const string Milliliter = default;
        public const string Millimeter = default;
        public const string Millisecond = default;
        public const string Minute = default;
        public const string Month = default;
        public const string Ounce = default;
        public const string Percent = default;
        public const string Petabyte = default;
        public const string Pound = default;
        public const string Second = default;
        public const string Stone = default;
        public const string Terabit = default;
        public const string Terabyte = default;
        public const string Week = default;
        public const string Yard = default;
        public const string Year = default;
    }
    public enum Numeric
    {
        Undefined = 0,
        Always = 1,
        Auto = 2,
    }
    public class PageArgAttribute : ServiceStack.AttributeBase
    {
        public PageArgAttribute(string name, string value) => throw null;
        public string Name { get => throw null; set { } }
        public string Value { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)68, Inherited = true)]
    public class PageAttribute : ServiceStack.AttributeBase
    {
        public PageAttribute(string virtualPath, string layout = default(string)) => throw null;
        public string Layout { get => throw null; set { } }
        public string VirtualPath { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)460)]
    public class PriorityAttribute : ServiceStack.AttributeBase
    {
        public PriorityAttribute(int value) => throw null;
        public int Value { get => throw null; set { } }
    }
    public class Properties : System.Collections.Generic.List<ServiceStack.Property>
    {
        public Properties() => throw null;
        public Properties(System.Collections.Generic.IEnumerable<ServiceStack.Property> collection) => throw null;
    }
    public class Property
    {
        public Property() => throw null;
        public string Name { get => throw null; set { } }
        public string Value { get => throw null; set { } }
    }
    public abstract class QueryBase : ServiceStack.IHasQueryParams, ServiceStack.IMeta, ServiceStack.IQuery
    {
        protected QueryBase() => throw null;
        public virtual string Fields { get => throw null; set { } }
        public virtual string Include { get => throw null; set { } }
        public virtual System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public virtual string OrderBy { get => throw null; set { } }
        public virtual string OrderByDesc { get => throw null; set { } }
        public virtual System.Collections.Generic.Dictionary<string, string> QueryParams { get => throw null; set { } }
        public virtual int? Skip { get => throw null; set { } }
        public virtual int? Take { get => throw null; set { } }
    }
    public abstract class QueryData<T> : ServiceStack.QueryBase, ServiceStack.IMeta, ServiceStack.IQuery, ServiceStack.IQueryData<T>, ServiceStack.IQueryData, ServiceStack.IReturn<ServiceStack.QueryResponse<T>>, ServiceStack.IReturn
    {
        protected QueryData() => throw null;
    }
    public abstract class QueryData<From, Into> : ServiceStack.QueryBase, ServiceStack.IMeta, ServiceStack.IQuery, ServiceStack.IQueryData<From, Into>, ServiceStack.IQueryData, ServiceStack.IReturn<ServiceStack.QueryResponse<Into>>, ServiceStack.IReturn
    {
        protected QueryData() => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
    public class QueryDataAttribute : ServiceStack.AttributeBase
    {
        public QueryDataAttribute() => throw null;
        public QueryDataAttribute(ServiceStack.QueryTerm defaultTerm) => throw null;
        public ServiceStack.QueryTerm DefaultTerm { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class QueryDataFieldAttribute : ServiceStack.AttributeBase
    {
        public string Condition { get => throw null; set { } }
        public QueryDataFieldAttribute() => throw null;
        public string Field { get => throw null; set { } }
        public ServiceStack.QueryTerm Term { get => throw null; set { } }
    }
    public abstract class QueryDb<T> : ServiceStack.QueryBase, ServiceStack.IMeta, ServiceStack.IQuery, ServiceStack.IQueryDb<T>, ServiceStack.IQueryDb, ServiceStack.IReturn<ServiceStack.QueryResponse<T>>, ServiceStack.IReturn
    {
        protected QueryDb() => throw null;
    }
    public abstract class QueryDb<From, Into> : ServiceStack.QueryBase, ServiceStack.IMeta, ServiceStack.IQuery, ServiceStack.IQueryDb<From, Into>, ServiceStack.IQueryDb, ServiceStack.IReturn<ServiceStack.QueryResponse<Into>>, ServiceStack.IReturn
    {
        protected QueryDb() => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
    public class QueryDbAttribute : ServiceStack.AttributeBase
    {
        public QueryDbAttribute() => throw null;
        public QueryDbAttribute(ServiceStack.QueryTerm defaultTerm) => throw null;
        public ServiceStack.QueryTerm DefaultTerm { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class QueryDbFieldAttribute : ServiceStack.AttributeBase
    {
        public QueryDbFieldAttribute() => throw null;
        public string Field { get => throw null; set { } }
        public string Operand { get => throw null; set { } }
        public string Template { get => throw null; set { } }
        public ServiceStack.QueryTerm Term { get => throw null; set { } }
        public int ValueArity { get => throw null; set { } }
        public string ValueFormat { get => throw null; set { } }
        public ServiceStack.ValueStyle ValueStyle { get => throw null; set { } }
    }
    public class QueryResponse<T> : ServiceStack.IHasResponseStatus, ServiceStack.IMeta, ServiceStack.IQueryResponse
    {
        public QueryResponse() => throw null;
        public virtual System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public virtual int Offset { get => throw null; set { } }
        public virtual ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public virtual System.Collections.Generic.List<T> Results { get => throw null; set { } }
        public virtual int Total { get => throw null; set { } }
    }
    public enum QueryTerm
    {
        Default = 0,
        And = 1,
        Or = 2,
        Ensure = 3,
    }
    namespace Redis
    {
        namespace Generic
        {
            public interface IRedisHash<TKey, TValue> : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IDictionary<TKey, TValue>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.IEnumerable, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
            {
                System.Collections.Generic.Dictionary<TKey, TValue> GetAll();
            }
            public interface IRedisHashAsync<TKey, TValue> : System.Collections.Generic.IAsyncEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
            {
                System.Threading.Tasks.ValueTask AddAsync(System.Collections.Generic.KeyValuePair<TKey, TValue> item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddAsync(TKey key, TValue value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ContainsKeyAsync(TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<TKey, TValue>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveAsync(TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }
            public interface IRedisList<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId, System.Collections.Generic.IList<T>
            {
                void AddRange(System.Collections.Generic.IEnumerable<T> values);
                void Append(T value);
                T BlockingDequeue(System.TimeSpan? timeOut);
                T BlockingPop(System.TimeSpan? timeOut);
                T BlockingRemoveStart(System.TimeSpan? timeOut);
                T Dequeue();
                void Enqueue(T value);
                System.Collections.Generic.List<T> GetAll();
                System.Collections.Generic.List<T> GetRange(int startingFrom, int endingAt);
                System.Collections.Generic.List<T> GetRangeFromSortedList(int startingFrom, int endingAt);
                T Pop();
                T PopAndPush(ServiceStack.Redis.Generic.IRedisList<T> toList);
                void Prepend(T value);
                void Push(T value);
                void RemoveAll();
                T RemoveEnd();
                T RemoveStart();
                long RemoveValue(T value);
                long RemoveValue(T value, int noOfMatches);
                void Trim(int keepStartingFrom, int keepEndingAt);
            }
            public interface IRedisListAsync<T> : System.Collections.Generic.IAsyncEnumerable<T>, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
            {
                System.Threading.Tasks.ValueTask AddAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddRangeAsync(System.Collections.Generic.IEnumerable<T> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AppendAsync(T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingDequeueAsync(System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingPopAsync(System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingRemoveStartAsync(System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ContainsAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> DequeueAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> ElementAtAsync(int index, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask EnqueueAsync(T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeAsync(int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedListAsync(int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<int> IndexOfAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopAndPushAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> toList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PrependAsync(T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PushAsync(T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask RemoveAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask RemoveAtAsync(int index, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> RemoveEndAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> RemoveStartAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> RemoveValueAsync(T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> RemoveValueAsync(T value, int noOfMatches, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetValueAsync(int index, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask TrimAsync(int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }
            public interface IRedisSet<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
            {
                System.Collections.Generic.HashSet<T> GetAll();
                void GetDifferences(params ServiceStack.Redis.Generic.IRedisSet<T>[] withSets);
                T GetRandomItem();
                void MoveTo(T item, ServiceStack.Redis.Generic.IRedisSet<T> toSet);
                T PopRandomItem();
                void PopulateWithDifferencesOf(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] withSets);
                void PopulateWithIntersectOf(params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                void PopulateWithUnionOf(params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                System.Collections.Generic.List<T> Sort(int startingFrom, int endingAt);
            }
            public interface IRedisSetAsync<T> : System.Collections.Generic.IAsyncEnumerable<T>, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
            {
                System.Threading.Tasks.ValueTask AddAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ContainsAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask GetDifferencesAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask GetDifferencesAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets);
                System.Threading.Tasks.ValueTask<T> GetRandomItemAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask MoveToAsync(T item, ServiceStack.Redis.Generic.IRedisSetAsync<T> toSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopRandomItemAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PopulateWithDifferencesOfAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PopulateWithDifferencesOfAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets);
                System.Threading.Tasks.ValueTask PopulateWithIntersectOfAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PopulateWithIntersectOfAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask PopulateWithUnionOfAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PopulateWithUnionOfAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask<bool> RemoveAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> SortAsync(int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }
            public interface IRedisSortedSet<T> : System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
            {
                void Add(T item, double score);
                System.Collections.Generic.List<T> GetAll();
                System.Collections.Generic.List<T> GetAllDescending();
                double GetItemScore(T item);
                System.Collections.Generic.List<T> GetRange(int fromRank, int toRank);
                System.Collections.Generic.List<T> GetRangeByHighestScore(double fromScore, double toScore);
                System.Collections.Generic.List<T> GetRangeByHighestScore(double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeByLowestScore(double fromScore, double toScore);
                System.Collections.Generic.List<T> GetRangeByLowestScore(double fromScore, double toScore, int? skip, int? take);
                double IncrementItem(T item, double incrementBy);
                int IndexOf(T item);
                long IndexOfDescending(T item);
                T PopItemWithHighestScore();
                T PopItemWithLowestScore();
                long PopulateWithIntersectOf(params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds);
                long PopulateWithIntersectOf(ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args);
                long PopulateWithUnionOf(params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds);
                long PopulateWithUnionOf(ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args);
                long RemoveRange(int minRank, int maxRank);
                long RemoveRangeByScore(double fromScore, double toScore);
            }
            public interface IRedisSortedSetAsync<T> : System.Collections.Generic.IAsyncEnumerable<T>, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
            {
                System.Threading.Tasks.ValueTask AddAsync(T item, double score, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ContainsAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetAllDescendingAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<double> GetItemScoreAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeAsync(int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeByHighestScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeByHighestScoreAsync(double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeByLowestScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeByLowestScoreAsync(double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<double> IncrementItemAsync(T item, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<int> IndexOfAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> IndexOfDescendingAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopItemWithHighestScoreAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopItemWithLowestScoreAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> PopulateWithIntersectOfAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> PopulateWithIntersectOfAsync(params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds);
                System.Threading.Tasks.ValueTask<long> PopulateWithIntersectOfAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> PopulateWithUnionOfAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> PopulateWithUnionOfAsync(params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds);
                System.Threading.Tasks.ValueTask<long> PopulateWithUnionOfAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> RemoveRangeAsync(int minRank, int maxRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> RemoveRangeByScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }
            public interface IRedisTypedClient<T> : ServiceStack.Data.IEntityStore<T>
            {
                System.IDisposable AcquireLock();
                System.IDisposable AcquireLock(System.TimeSpan timeOut);
                void AddItemToList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value);
                void AddItemToSet(ServiceStack.Redis.Generic.IRedisSet<T> toSet, T item);
                void AddItemToSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> toSet, T value);
                void AddItemToSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> toSet, T value, double score);
                void AddToRecentsList(T value);
                T BlockingDequeueItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.TimeSpan? timeOut);
                T BlockingPopAndPushItemBetweenLists(ServiceStack.Redis.Generic.IRedisList<T> fromList, ServiceStack.Redis.Generic.IRedisList<T> toList, System.TimeSpan? timeOut);
                T BlockingPopItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.TimeSpan? timeOut);
                T BlockingRemoveStartFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.TimeSpan? timeOut);
                bool ContainsKey(string key);
                ServiceStack.Redis.Generic.IRedisTypedPipeline<T> CreatePipeline();
                ServiceStack.Redis.Generic.IRedisTypedTransaction<T> CreateTransaction();
                long Db { get; set; }
                long DecrementValue(string key);
                long DecrementValueBy(string key, int count);
                void DeleteRelatedEntities<TChild>(object parentId);
                void DeleteRelatedEntity<TChild>(object parentId, object childId);
                T DequeueItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList);
                void EnqueueItemOnList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T item);
                bool ExpireAt(object id, System.DateTime dateTime);
                bool ExpireEntryAt(string key, System.DateTime dateTime);
                bool ExpireEntryIn(string key, System.TimeSpan expiresAt);
                bool ExpireIn(object id, System.TimeSpan expiresAt);
                void FlushAll();
                void FlushDb();
                System.Collections.Generic.Dictionary<TKey, T> GetAllEntriesFromHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash);
                System.Collections.Generic.List<T> GetAllItemsFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList);
                System.Collections.Generic.HashSet<T> GetAllItemsFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet);
                System.Collections.Generic.List<T> GetAllItemsFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set);
                System.Collections.Generic.List<T> GetAllItemsFromSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set);
                System.Collections.Generic.List<string> GetAllKeys();
                System.Collections.Generic.IDictionary<T, double> GetAllWithScoresFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set);
                T GetAndSetValue(string key, T value);
                System.Collections.Generic.HashSet<T> GetDifferencesFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] withSets);
                System.Collections.Generic.List<T> GetEarliestFromRecentsList(int skip, int take);
                ServiceStack.Redis.RedisKeyType GetEntryType(string key);
                T GetFromHash(object id);
                ServiceStack.Redis.Generic.IRedisHash<TKey, T> GetHash<TKey>(string hashId);
                long GetHashCount<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash);
                System.Collections.Generic.List<TKey> GetHashKeys<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash);
                System.Collections.Generic.List<T> GetHashValues<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash);
                System.Collections.Generic.HashSet<T> GetIntersectFromSets(params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                T GetItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int listIndex);
                long GetItemIndexInSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value);
                long GetItemIndexInSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value);
                double GetItemScoreInSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value);
                System.Collections.Generic.List<T> GetLatestFromRecentsList(int skip, int take);
                long GetListCount(ServiceStack.Redis.Generic.IRedisList<T> fromList);
                long GetNextSequence();
                long GetNextSequence(int incrBy);
                T GetRandomItemFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet);
                string GetRandomKey();
                System.Collections.Generic.List<T> GetRangeFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int startingFrom, int endingAt);
                System.Collections.Generic.List<T> GetRangeFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeFromSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank);
                System.Collections.Generic.List<TChild> GetRelatedEntities<TChild>(object parentId);
                long GetRelatedEntitiesCount<TChild>(object parentId);
                long GetSetCount(ServiceStack.Redis.Generic.IRedisSet<T> set);
                System.Collections.Generic.List<T> GetSortedEntryValues(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, int startingFrom, int endingAt);
                long GetSortedSetCount(ServiceStack.Redis.Generic.IRedisSortedSet<T> set);
                System.TimeSpan GetTimeToLive(string key);
                System.Collections.Generic.HashSet<T> GetUnionFromSets(params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                T GetValue(string key);
                T GetValueFromHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key);
                System.Collections.Generic.List<T> GetValues(System.Collections.Generic.List<string> keys);
                bool HashContainsEntry<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key);
                double IncrementItemInSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value, double incrementBy);
                long IncrementValue(string key);
                long IncrementValueBy(string key, int count);
                void InsertAfterItemInList(ServiceStack.Redis.Generic.IRedisList<T> toList, T pivot, T value);
                void InsertBeforeItemInList(ServiceStack.Redis.Generic.IRedisList<T> toList, T pivot, T value);
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisList<T>> Lists { get; set; }
                void MoveBetweenSets(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, ServiceStack.Redis.Generic.IRedisSet<T> toSet, T item);
                T PopAndPushItemBetweenLists(ServiceStack.Redis.Generic.IRedisList<T> fromList, ServiceStack.Redis.Generic.IRedisList<T> toList);
                T PopItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList);
                T PopItemFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet);
                T PopItemWithHighestScoreFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> fromSet);
                T PopItemWithLowestScoreFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> fromSet);
                void PrependItemToList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value);
                void PushItemToList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T item);
                ServiceStack.Redis.IRedisClient RedisClient { get; }
                void RemoveAllFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList);
                T RemoveEndFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList);
                bool RemoveEntry(string key);
                bool RemoveEntry(params string[] args);
                bool RemoveEntry(params ServiceStack.Model.IHasStringId[] entities);
                bool RemoveEntryFromHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key);
                long RemoveItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value);
                long RemoveItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value, int noOfMatches);
                void RemoveItemFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, T item);
                bool RemoveItemFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> fromSet, T value);
                long RemoveRangeFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int minRank, int maxRank);
                long RemoveRangeFromSortedSetByScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
                T RemoveStartFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList);
                void Save();
                void SaveAsync();
                T[] SearchKeys(string pattern);
                string SequenceKey { get; set; }
                bool SetContainsItem(ServiceStack.Redis.Generic.IRedisSet<T> set, T item);
                bool SetEntryInHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key, T value);
                bool SetEntryInHashIfNotExists<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key, T value);
                void SetItemInList(ServiceStack.Redis.Generic.IRedisList<T> toList, int listIndex, T value);
                void SetRangeInHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, T>> keyValuePairs);
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSet<T>> Sets { get; set; }
                void SetSequence(int value);
                void SetValue(string key, T entity);
                void SetValue(string key, T entity, System.TimeSpan expireIn);
                bool SetValueIfExists(string key, T entity);
                bool SetValueIfNotExists(string key, T entity);
                bool SortedSetContainsItem(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value);
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSortedSet<T>> SortedSets { get; set; }
                System.Collections.Generic.List<T> SortList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int startingFrom, int endingAt);
                T Store(T entity, System.TimeSpan expireIn);
                void StoreAsHash(T entity);
                void StoreDifferencesFromSet(ServiceStack.Redis.Generic.IRedisSet<T> intoSet, ServiceStack.Redis.Generic.IRedisSet<T> fromSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] withSets);
                void StoreIntersectFromSets(ServiceStack.Redis.Generic.IRedisSet<T> intoSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                long StoreIntersectFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds);
                long StoreIntersectFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args);
                void StoreRelatedEntities<TChild>(object parentId, System.Collections.Generic.List<TChild> children);
                void StoreRelatedEntities<TChild>(object parentId, params TChild[] children);
                void StoreUnionFromSets(ServiceStack.Redis.Generic.IRedisSet<T> intoSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                long StoreUnionFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds);
                long StoreUnionFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args);
                T this[string key] { get; set; }
                void TrimList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int keepStartingFrom, int keepEndingAt);
                ServiceStack.Redis.IRedisSet TypeIdsSet { get; }
                string UrnKey(T value);
            }
            public interface IRedisTypedClientAsync<T> : ServiceStack.Data.IEntityStoreAsync<T>
            {
                System.Threading.Tasks.ValueTask<System.IAsyncDisposable> AcquireLockAsync(System.TimeSpan? timeOut = default(System.TimeSpan?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddItemToListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddItemToSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> toSet, T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddItemToSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> toSet, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddItemToSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> toSet, T value, double score, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddToRecentsListAsync(T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask BackgroundSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingDequeueItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingPopAndPushItemBetweenListsAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, ServiceStack.Redis.Generic.IRedisListAsync<T> toList, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingPopItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingRemoveStartFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ContainsKeyAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Redis.Generic.IRedisTypedPipelineAsync<T> CreatePipeline();
                System.Threading.Tasks.ValueTask<ServiceStack.Redis.Generic.IRedisTypedTransactionAsync<T>> CreateTransactionAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                long Db { get; }
                System.Threading.Tasks.ValueTask<long> DecrementValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> DecrementValueByAsync(string key, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask DeleteRelatedEntitiesAsync<TChild>(object parentId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask DeleteRelatedEntityAsync<TChild>(object parentId, object childId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> DequeueItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask EnqueueItemOnListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ExpireAtAsync(object id, System.DateTime dateTime, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ExpireEntryAtAsync(string key, System.DateTime dateTime, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ExpireEntryInAsync(string key, System.TimeSpan expiresAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ExpireInAsync(object id, System.TimeSpan expiresAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask FlushAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask FlushDbAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask ForegroundSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<TKey, T>> GetAllEntriesFromHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetAllItemsFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetAllItemsFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetAllItemsFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetAllItemsFromSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetAllKeysAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetAllWithScoresFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetAndSetValueAsync(string key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets);
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetEarliestFromRecentsListAsync(int skip, int take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisKeyType> GetEntryTypeAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetFromHashAsync(object id, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> GetHash<TKey>(string hashId);
                System.Threading.Tasks.ValueTask<long> GetHashCountAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<TKey>> GetHashKeysAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetHashValuesAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetIntersectFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetIntersectFromSetsAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask<T> GetItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int listIndex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> GetItemIndexInSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> GetItemIndexInSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<double> GetItemScoreInSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetLatestFromRecentsListAsync(int skip, int take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> GetListCountAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> GetNextSequenceAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> GetNextSequenceAsync(int incrBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetRandomItemFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<string> GetRandomKeyAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<TChild>> GetRelatedEntitiesAsync<TChild>(object parentId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> GetRelatedEntitiesCountAsync<TChild>(object parentId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> GetSetCountAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> set, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetSortedEntryValuesAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> GetSortedSetCountAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.TimeSpan> GetTimeToLiveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetUnionFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetUnionFromSetsAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask<T> GetValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetValueFromHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetValuesAsync(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> HashContainsEntryAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<double> IncrementItemInSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> IncrementValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> IncrementValueByAsync(string key, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask InsertAfterItemInListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> toList, T pivot, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask InsertBeforeItemInListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> toList, T pivot, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisListAsync<T>> Lists { get; }
                System.Threading.Tasks.ValueTask MoveBetweenSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T> toSet, T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopAndPushItemBetweenListsAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, ServiceStack.Redis.Generic.IRedisListAsync<T> toList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopItemFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopItemWithHighestScoreFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> fromSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopItemWithLowestScoreFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> fromSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PrependItemToListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PushItemToListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Redis.IRedisClientAsync RedisClient { get; }
                System.Threading.Tasks.ValueTask RemoveAllFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> RemoveEndFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(params string[] args);
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(ServiceStack.Model.IHasStringId[] entities, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(params ServiceStack.Model.IHasStringId[] entities);
                System.Threading.Tasks.ValueTask<bool> RemoveEntryFromHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> RemoveItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> RemoveItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, int noOfMatches, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask RemoveItemFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveItemFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> fromSet, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> RemoveRangeFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int minRank, int maxRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> RemoveRangeFromSortedSetByScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> RemoveStartFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T[]> SearchKeysAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SelectAsync(long db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                string SequenceKey { get; set; }
                System.Threading.Tasks.ValueTask<bool> SetContainsItemAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> set, T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SetEntryInHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SetEntryInHashIfNotExistsAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetItemInListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> toList, int listIndex, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetRangeInHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, T>> keyValuePairs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSetAsync<T>> Sets { get; }
                System.Threading.Tasks.ValueTask SetSequenceAsync(int value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetValueAsync(string key, T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetValueAsync(string key, T entity, System.TimeSpan expireIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SetValueIfExistsAsync(string key, T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SetValueIfNotExistsAsync(string key, T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SortedSetContainsItemAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>> SortedSets { get; }
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> SortListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreAsHashAsync(T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> StoreAsync(T entity, System.TimeSpan expireIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets);
                System.Threading.Tasks.ValueTask StoreIntersectFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreIntersectFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask<long> StoreIntersectFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> StoreIntersectFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds);
                System.Threading.Tasks.ValueTask<long> StoreIntersectFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreRelatedEntitiesAsync<TChild>(object parentId, System.Collections.Generic.List<TChild> children, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreRelatedEntitiesAsync<TChild>(object parentId, TChild[] children, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreRelatedEntitiesAsync<TChild>(object parentId, params TChild[] children);
                System.Threading.Tasks.ValueTask StoreUnionFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreUnionFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask<long> StoreUnionFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<long> StoreUnionFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds);
                System.Threading.Tasks.ValueTask<long> StoreUnionFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask TrimListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Redis.IRedisSetAsync TypeIdsSet { get; }
                string UrnKey(T value);
            }
            public interface IRedisTypedPipeline<T> : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisPipelineShared, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation, ServiceStack.Redis.Generic.IRedisTypedQueueableOperation<T>
            {
            }
            public interface IRedisTypedPipelineAsync<T> : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync, ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>
            {
            }
            public interface IRedisTypedQueueableOperation<T>
            {
                void QueueCommand(System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> command);
                void QueueCommand(System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> command, System.Action onSuccessCallback);
                void QueueCommand(System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> command, System.Action onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, int> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, int> command, System.Action<int> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, int> command, System.Action<int> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, long> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, long> command, System.Action<long> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, long> command, System.Action<long> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, bool> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, bool> command, System.Action<bool> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, bool> command, System.Action<bool> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, double> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, double> command, System.Action<double> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, double> command, System.Action<double> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, byte[]> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, byte[]> command, System.Action<byte[]> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, byte[]> command, System.Action<byte[]> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, string> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, string> command, System.Action<string> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, string> command, System.Action<string> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> command, System.Action<T> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> command, System.Action<T> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> command, System.Action<System.Collections.Generic.List<T>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> command, System.Action<System.Collections.Generic.List<T>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
            }
            public interface IRedisTypedQueueableOperationAsync<T>
            {
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask> command, System.Action onSuccessCallback = default(System.Action), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<int>> command, System.Action<int> onSuccessCallback = default(System.Action<int>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<long>> command, System.Action<long> onSuccessCallback = default(System.Action<long>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<bool>> command, System.Action<bool> onSuccessCallback = default(System.Action<bool>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<double>> command, System.Action<double> onSuccessCallback = default(System.Action<double>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<byte[]>> command, System.Action<byte[]> onSuccessCallback = default(System.Action<byte[]>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<string>> command, System.Action<string> onSuccessCallback = default(System.Action<string>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<T>> command, System.Action<T> onSuccessCallback = default(System.Action<T>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback = default(System.Action<System.Collections.Generic.List<string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback = default(System.Action<System.Collections.Generic.HashSet<string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>>> command, System.Action<System.Collections.Generic.List<T>> onSuccessCallback = default(System.Action<System.Collections.Generic.List<T>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
            }
            public interface IRedisTypedTransaction<T> : System.IDisposable, ServiceStack.Redis.Generic.IRedisTypedQueueableOperation<T>
            {
                bool Commit();
                void Rollback();
            }
            public interface IRedisTypedTransactionAsync<T> : System.IAsyncDisposable, ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>
            {
                System.Threading.Tasks.ValueTask<bool> CommitAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask RollbackAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }
        }
        public interface IHasStats
        {
            System.Collections.Generic.Dictionary<string, long> Stats { get; }
        }
        public interface IRedisClient : ServiceStack.Caching.ICacheClient, ServiceStack.Caching.ICacheClientExtended, System.IDisposable, ServiceStack.Data.IEntityStore, ServiceStack.Caching.IRemoveByPattern
        {
            System.IDisposable AcquireLock(string key);
            System.IDisposable AcquireLock(string key, System.TimeSpan timeOut);
            long AddGeoMember(string key, double longitude, double latitude, string member);
            long AddGeoMembers(string key, params ServiceStack.Redis.RedisGeo[] geoPoints);
            void AddItemToList(string listId, string value);
            void AddItemToSet(string setId, string item);
            bool AddItemToSortedSet(string setId, string value);
            bool AddItemToSortedSet(string setId, string value, double score);
            void AddRangeToList(string listId, System.Collections.Generic.List<string> values);
            void AddRangeToSet(string setId, System.Collections.Generic.List<string> items);
            bool AddRangeToSortedSet(string setId, System.Collections.Generic.List<string> values, double score);
            bool AddRangeToSortedSet(string setId, System.Collections.Generic.List<string> values, long score);
            bool AddToHyperLog(string key, params string[] elements);
            long AppendTo(string key, string value);
            ServiceStack.Redis.Generic.IRedisTypedClient<T> As<T>();
            string BlockingDequeueItemFromList(string listId, System.TimeSpan? timeOut);
            ServiceStack.Redis.ItemRef BlockingDequeueItemFromLists(string[] listIds, System.TimeSpan? timeOut);
            string BlockingPopAndPushItemBetweenLists(string fromListId, string toListId, System.TimeSpan? timeOut);
            string BlockingPopItemFromList(string listId, System.TimeSpan? timeOut);
            ServiceStack.Redis.ItemRef BlockingPopItemFromLists(string[] listIds, System.TimeSpan? timeOut);
            string BlockingRemoveStartFromList(string listId, System.TimeSpan? timeOut);
            ServiceStack.Redis.ItemRef BlockingRemoveStartFromLists(string[] listIds, System.TimeSpan? timeOut);
            double CalculateDistanceBetweenGeoMembers(string key, string fromMember, string toMember, string unit = default(string));
            string CalculateSha1(string luaBody);
            int ConnectTimeout { get; set; }
            bool ContainsKey(string key);
            long CountHyperLog(string key);
            ServiceStack.Redis.Pipeline.IRedisPipeline CreatePipeline();
            ServiceStack.Redis.IRedisSubscription CreateSubscription();
            ServiceStack.Redis.IRedisTransaction CreateTransaction();
            ServiceStack.Redis.RedisText Custom(params object[] cmdWithArgs);
            long Db { get; set; }
            long DbSize { get; }
            long DecrementValue(string key);
            long DecrementValueBy(string key, int count);
            string DequeueItemFromList(string listId);
            string Echo(string text);
            void EnqueueItemOnList(string listId, string value);
            T ExecCachedLua<T>(string scriptBody, System.Func<string, T> scriptSha1);
            ServiceStack.Redis.RedisText ExecLua(string body, params string[] args);
            ServiceStack.Redis.RedisText ExecLua(string luaBody, string[] keys, string[] args);
            long ExecLuaAsInt(string luaBody, params string[] args);
            long ExecLuaAsInt(string luaBody, string[] keys, string[] args);
            System.Collections.Generic.List<string> ExecLuaAsList(string luaBody, params string[] args);
            System.Collections.Generic.List<string> ExecLuaAsList(string luaBody, string[] keys, string[] args);
            string ExecLuaAsString(string luaBody, params string[] args);
            string ExecLuaAsString(string luaBody, string[] keys, string[] args);
            ServiceStack.Redis.RedisText ExecLuaSha(string sha1, params string[] args);
            ServiceStack.Redis.RedisText ExecLuaSha(string sha1, string[] keys, string[] args);
            long ExecLuaShaAsInt(string sha1, params string[] args);
            long ExecLuaShaAsInt(string sha1, string[] keys, string[] args);
            System.Collections.Generic.List<string> ExecLuaShaAsList(string sha1, params string[] args);
            System.Collections.Generic.List<string> ExecLuaShaAsList(string sha1, string[] keys, string[] args);
            string ExecLuaShaAsString(string sha1, params string[] args);
            string ExecLuaShaAsString(string sha1, string[] keys, string[] args);
            bool ExpireEntryAt(string key, System.DateTime expireAt);
            bool ExpireEntryIn(string key, System.TimeSpan expireIn);
            string[] FindGeoMembersInRadius(string key, double longitude, double latitude, double radius, string unit);
            string[] FindGeoMembersInRadius(string key, string member, double radius, string unit);
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> FindGeoResultsInRadius(string key, double longitude, double latitude, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?));
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> FindGeoResultsInRadius(string key, string member, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?));
            void FlushDb();
            System.Collections.Generic.Dictionary<string, string> GetAllEntriesFromHash(string hashId);
            System.Collections.Generic.List<string> GetAllItemsFromList(string listId);
            System.Collections.Generic.HashSet<string> GetAllItemsFromSet(string setId);
            System.Collections.Generic.List<string> GetAllItemsFromSortedSet(string setId);
            System.Collections.Generic.List<string> GetAllItemsFromSortedSetDesc(string setId);
            System.Collections.Generic.List<string> GetAllKeys();
            System.Collections.Generic.IDictionary<string, double> GetAllWithScoresFromSortedSet(string setId);
            string GetAndSetValue(string key, string value);
            string GetClient();
            System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>> GetClientsInfo();
            string GetConfig(string item);
            System.Collections.Generic.HashSet<string> GetDifferencesFromSet(string fromSetId, params string[] withSetIds);
            ServiceStack.Redis.RedisKeyType GetEntryType(string key);
            T GetFromHash<T>(object id);
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeo> GetGeoCoordinates(string key, params string[] members);
            string[] GetGeohashes(string key, params string[] members);
            long GetHashCount(string hashId);
            System.Collections.Generic.List<string> GetHashKeys(string hashId);
            System.Collections.Generic.List<string> GetHashValues(string hashId);
            System.Collections.Generic.HashSet<string> GetIntersectFromSets(params string[] setIds);
            string GetItemFromList(string listId, int listIndex);
            long GetItemIndexInSortedSet(string setId, string value);
            long GetItemIndexInSortedSetDesc(string setId, string value);
            double GetItemScoreInSortedSet(string setId, string value);
            long GetListCount(string listId);
            string GetRandomItemFromSet(string setId);
            string GetRandomKey();
            System.Collections.Generic.List<string> GetRangeFromList(string listId, int startingFrom, int endingAt);
            System.Collections.Generic.List<string> GetRangeFromSortedList(string listId, int startingFrom, int endingAt);
            System.Collections.Generic.List<string> GetRangeFromSortedSet(string setId, int fromRank, int toRank);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, double fromScore, double toScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, long fromScore, long toScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, double fromScore, double toScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, long fromScore, long toScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, double fromScore, double toScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, long fromScore, long toScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, double fromScore, double toScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, long fromScore, long toScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetDesc(string setId, int fromRank, int toRank);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSet(string setId, int fromRank, int toRank);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, double fromScore, double toScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, long fromScore, long toScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, double fromScore, double toScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, long fromScore, long toScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, double fromScore, double toScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, long fromScore, long toScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, double fromScore, double toScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, long fromScore, long toScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetDesc(string setId, int fromRank, int toRank);
            ServiceStack.Redis.RedisServerRole GetServerRole();
            ServiceStack.Redis.RedisText GetServerRoleInfo();
            System.DateTime GetServerTime();
            long GetSetCount(string setId);
            System.Collections.Generic.List<string> GetSortedEntryValues(string key, int startingFrom, int endingAt);
            System.Collections.Generic.List<string> GetSortedItemsFromList(string listId, ServiceStack.Redis.SortOptions sortOptions);
            long GetSortedSetCount(string setId);
            long GetSortedSetCount(string setId, string fromStringScore, string toStringScore);
            long GetSortedSetCount(string setId, long fromScore, long toScore);
            long GetSortedSetCount(string setId, double fromScore, double toScore);
            long GetStringCount(string key);
            System.Collections.Generic.HashSet<string> GetUnionFromSets(params string[] setIds);
            string GetValue(string key);
            string GetValueFromHash(string hashId, string key);
            System.Collections.Generic.List<string> GetValues(System.Collections.Generic.List<string> keys);
            System.Collections.Generic.List<T> GetValues<T>(System.Collections.Generic.List<string> keys);
            System.Collections.Generic.List<string> GetValuesFromHash(string hashId, params string[] keys);
            System.Collections.Generic.Dictionary<string, string> GetValuesMap(System.Collections.Generic.List<string> keys);
            System.Collections.Generic.Dictionary<string, T> GetValuesMap<T>(System.Collections.Generic.List<string> keys);
            bool HadExceptions { get; }
            bool HashContainsEntry(string hashId, string key);
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisHash> Hashes { get; set; }
            bool HasLuaScript(string sha1Ref);
            string Host { get; }
            double IncrementItemInSortedSet(string setId, string value, double incrementBy);
            double IncrementItemInSortedSet(string setId, string value, long incrementBy);
            long IncrementValue(string key);
            long IncrementValueBy(string key, int count);
            long IncrementValueBy(string key, long count);
            double IncrementValueBy(string key, double count);
            long IncrementValueInHash(string hashId, string key, int incrementBy);
            double IncrementValueInHash(string hashId, string key, double incrementBy);
            System.Collections.Generic.Dictionary<string, string> Info { get; }
            long InsertAt(string key, int offset, string value);
            void KillClient(string address);
            long KillClients(string fromAddress = default(string), string withId = default(string), ServiceStack.Redis.RedisClientType? ofType = default(ServiceStack.Redis.RedisClientType?), bool? skipMe = default(bool?));
            void KillRunningLuaScript();
            System.DateTime LastSave { get; }
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisList> Lists { get; set; }
            string LoadLuaScript(string body);
            void MergeHyperLogs(string toKey, params string[] fromKeys);
            void MoveBetweenSets(string fromSetId, string toSetId, string item);
            string Password { get; set; }
            void PauseAllClients(System.TimeSpan duration);
            bool Ping();
            string PopAndPushItemBetweenLists(string fromListId, string toListId);
            string PopItemFromList(string listId);
            string PopItemFromSet(string setId);
            System.Collections.Generic.List<string> PopItemsFromSet(string setId, int count);
            string PopItemWithHighestScoreFromSortedSet(string setId);
            string PopItemWithLowestScoreFromSortedSet(string setId);
            int Port { get; }
            void PrependItemToList(string listId, string value);
            void PrependRangeToList(string listId, System.Collections.Generic.List<string> values);
            long PublishMessage(string toChannel, string message);
            void PushItemToList(string listId, string value);
            void RemoveAllFromList(string listId);
            void RemoveAllLuaScripts();
            string RemoveEndFromList(string listId);
            bool RemoveEntry(params string[] args);
            bool RemoveEntryFromHash(string hashId, string key);
            long RemoveItemFromList(string listId, string value);
            long RemoveItemFromList(string listId, string value, int noOfMatches);
            void RemoveItemFromSet(string setId, string item);
            bool RemoveItemFromSortedSet(string setId, string value);
            long RemoveItemsFromSortedSet(string setId, System.Collections.Generic.List<string> values);
            long RemoveRangeFromSortedSet(string setId, int minRank, int maxRank);
            long RemoveRangeFromSortedSetByScore(string setId, double fromScore, double toScore);
            long RemoveRangeFromSortedSetByScore(string setId, long fromScore, long toScore);
            long RemoveRangeFromSortedSetBySearch(string setId, string start = default(string), string end = default(string));
            string RemoveStartFromList(string listId);
            void RenameKey(string fromName, string toName);
            void ResetInfoStats();
            int RetryCount { get; set; }
            int RetryTimeout { get; set; }
            void RewriteAppendOnlyFileAsync();
            void Save();
            void SaveAsync();
            void SaveConfig();
            System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> ScanAllHashEntries(string hashId, string pattern = default(string), int pageSize = default(int));
            System.Collections.Generic.IEnumerable<string> ScanAllKeys(string pattern = default(string), int pageSize = default(int));
            System.Collections.Generic.IEnumerable<string> ScanAllSetItems(string setId, string pattern = default(string), int pageSize = default(int));
            System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, double>> ScanAllSortedSetItems(string setId, string pattern = default(string), int pageSize = default(int));
            System.Collections.Generic.List<string> SearchKeys(string pattern);
            System.Collections.Generic.List<string> SearchSortedSet(string setId, string start = default(string), string end = default(string), int? skip = default(int?), int? take = default(int?));
            long SearchSortedSetCount(string setId, string start = default(string), string end = default(string));
            int SendTimeout { get; set; }
            void SetAll(System.Collections.Generic.IEnumerable<string> keys, System.Collections.Generic.IEnumerable<string> values);
            void SetAll(System.Collections.Generic.Dictionary<string, string> map);
            void SetClient(string name);
            void SetConfig(string item, string value);
            bool SetContainsItem(string setId, string item);
            bool SetEntryInHash(string hashId, string key, string value);
            bool SetEntryInHashIfNotExists(string hashId, string key, string value);
            void SetItemInList(string listId, int listIndex, string value);
            void SetRangeInHash(string hashId, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> keyValuePairs);
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSet> Sets { get; set; }
            void SetValue(string key, string value);
            void SetValue(string key, string value, System.TimeSpan expireIn);
            bool SetValueIfExists(string key, string value);
            bool SetValueIfExists(string key, string value, System.TimeSpan expireIn);
            bool SetValueIfNotExists(string key, string value);
            bool SetValueIfNotExists(string key, string value, System.TimeSpan expireIn);
            void SetValues(System.Collections.Generic.Dictionary<string, string> map);
            void Shutdown();
            void ShutdownNoSave();
            string Slice(string key, int fromIndex, int toIndex);
            bool SortedSetContainsItem(string setId, string value);
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSortedSet> SortedSets { get; set; }
            void StoreAsHash<T>(T entity);
            void StoreDifferencesFromSet(string intoSetId, string fromSetId, params string[] withSetIds);
            void StoreIntersectFromSets(string intoSetId, params string[] setIds);
            long StoreIntersectFromSortedSets(string intoSetId, params string[] setIds);
            long StoreIntersectFromSortedSets(string intoSetId, string[] setIds, string[] args);
            object StoreObject(object entity);
            void StoreUnionFromSets(string intoSetId, params string[] setIds);
            long StoreUnionFromSortedSets(string intoSetId, params string[] setIds);
            long StoreUnionFromSortedSets(string intoSetId, string[] setIds, string[] args);
            string this[string key] { get; set; }
            void TrimList(string listId, int keepStartingFrom, int keepEndingAt);
            string Type(string key);
            void UnWatch();
            string UrnKey<T>(T value);
            string UrnKey<T>(object id);
            string UrnKey(System.Type type, object id);
            string Username { get; set; }
            void Watch(params string[] keys);
            System.Collections.Generic.Dictionary<string, bool> WhichLuaScriptsExists(params string[] sha1Refs);
            void WriteAll<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities);
        }
        public interface IRedisClientAsync : System.IAsyncDisposable, ServiceStack.Caching.ICacheClientAsync, ServiceStack.Data.IEntityStoreAsync, ServiceStack.Caching.IRemoveByPatternAsync
        {
            System.Threading.Tasks.ValueTask<System.IAsyncDisposable> AcquireLockAsync(string key, System.TimeSpan? timeOut = default(System.TimeSpan?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> AddGeoMemberAsync(string key, double longitude, double latitude, string member, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> AddGeoMembersAsync(string key, ServiceStack.Redis.RedisGeo[] geoPoints, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> AddGeoMembersAsync(string key, params ServiceStack.Redis.RedisGeo[] geoPoints);
            System.Threading.Tasks.ValueTask AddItemToListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddItemToSetAsync(string setId, string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddItemToSortedSetAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddItemToSortedSetAsync(string setId, string value, double score, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddRangeToListAsync(string listId, System.Collections.Generic.List<string> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddRangeToSetAsync(string setId, System.Collections.Generic.List<string> items, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddRangeToSortedSetAsync(string setId, System.Collections.Generic.List<string> values, double score, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddRangeToSortedSetAsync(string setId, System.Collections.Generic.List<string> values, long score, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddToHyperLogAsync(string key, string[] elements, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddToHyperLogAsync(string key, params string[] elements);
            System.Threading.Tasks.ValueTask<long> AppendToAsync(string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Redis.Generic.IRedisTypedClientAsync<T> As<T>();
            System.Threading.Tasks.ValueTask BackgroundRewriteAppendOnlyFileAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask BackgroundSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> BlockingDequeueItemFromListAsync(string listId, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ItemRef> BlockingDequeueItemFromListsAsync(string[] listIds, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> BlockingPopAndPushItemBetweenListsAsync(string fromListId, string toListId, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> BlockingPopItemFromListAsync(string listId, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ItemRef> BlockingPopItemFromListsAsync(string[] listIds, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> BlockingRemoveStartFromListAsync(string listId, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ItemRef> BlockingRemoveStartFromListsAsync(string[] listIds, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> CalculateDistanceBetweenGeoMembersAsync(string key, string fromMember, string toMember, string unit = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> CalculateSha1Async(string luaBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            int ConnectTimeout { get; set; }
            System.Threading.Tasks.ValueTask<bool> ContainsKeyAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> CountHyperLogAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Redis.Pipeline.IRedisPipelineAsync CreatePipeline();
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisSubscriptionAsync> CreateSubscriptionAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisTransactionAsync> CreateTransactionAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> CustomAsync(object[] cmdWithArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> CustomAsync(params object[] cmdWithArgs);
            long Db { get; }
            System.Threading.Tasks.ValueTask<long> DbSizeAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> DecrementValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> DecrementValueByAsync(string key, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> DequeueItemFromListAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> EchoAsync(string text, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask EnqueueItemOnListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<T> ExecCachedLuaAsync<T>(string scriptBody, System.Func<string, System.Threading.Tasks.ValueTask<T>> scriptSha1, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ExecLuaAsIntAsync(string luaBody, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ExecLuaAsIntAsync(string luaBody, params string[] args);
            System.Threading.Tasks.ValueTask<long> ExecLuaAsIntAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaAsListAsync(string luaBody, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaAsListAsync(string luaBody, params string[] args);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaAsListAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ExecLuaAsStringAsync(string luaBody, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ExecLuaAsStringAsync(string luaBody, params string[] args);
            System.Threading.Tasks.ValueTask<string> ExecLuaAsStringAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaAsync(string body, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaAsync(string body, params string[] args);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ExecLuaShaAsIntAsync(string sha1, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ExecLuaShaAsIntAsync(string sha1, params string[] args);
            System.Threading.Tasks.ValueTask<long> ExecLuaShaAsIntAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaShaAsListAsync(string sha1, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaShaAsListAsync(string sha1, params string[] args);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaShaAsListAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ExecLuaShaAsStringAsync(string sha1, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ExecLuaShaAsStringAsync(string sha1, params string[] args);
            System.Threading.Tasks.ValueTask<string> ExecLuaShaAsStringAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaShaAsync(string sha1, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaShaAsync(string sha1, params string[] args);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaShaAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ExpireEntryAtAsync(string key, System.DateTime expireAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ExpireEntryInAsync(string key, System.TimeSpan expireIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string[]> FindGeoMembersInRadiusAsync(string key, double longitude, double latitude, double radius, string unit, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string[]> FindGeoMembersInRadiusAsync(string key, string member, double radius, string unit, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> FindGeoResultsInRadiusAsync(string key, double longitude, double latitude, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> FindGeoResultsInRadiusAsync(string key, string member, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask FlushDbAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ForegroundSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> GetAllEntriesFromHashAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetAllItemsFromListAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetAllItemsFromSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetAllItemsFromSortedSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetAllItemsFromSortedSetDescAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetAllKeysAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetAllWithScoresFromSortedSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetAndSetValueAsync(string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetClientAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, string>>> GetClientsInfoAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetConfigAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetDifferencesFromSetAsync(string fromSetId, string[] withSetIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetDifferencesFromSetAsync(string fromSetId, params string[] withSetIds);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisKeyType> GetEntryTypeAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<T> GetFromHashAsync<T>(object id, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> GetGeoCoordinatesAsync(string key, string[] members, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> GetGeoCoordinatesAsync(string key, params string[] members);
            System.Threading.Tasks.ValueTask<string[]> GetGeohashesAsync(string key, string[] members, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string[]> GetGeohashesAsync(string key, params string[] members);
            System.Threading.Tasks.ValueTask<long> GetHashCountAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetHashKeysAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetHashValuesAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetIntersectFromSetsAsync(string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetIntersectFromSetsAsync(params string[] setIds);
            System.Threading.Tasks.ValueTask<string> GetItemFromListAsync(string listId, int listIndex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetItemIndexInSortedSetAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetItemIndexInSortedSetDescAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> GetItemScoreInSortedSetAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetListCountAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetRandomItemFromSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetRandomKeyAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromListAsync(string listId, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedListAsync(string listId, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, long fromScore, long toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, long fromScore, long toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, long fromScore, long toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, long fromScore, long toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetDescAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, long fromScore, long toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, long fromScore, long toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, long fromScore, long toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, long fromScore, long toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetDescAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisServerRole> GetServerRoleAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> GetServerRoleInfoAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.DateTime> GetServerTimeAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetSetCountAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.SlowlogItem[]> GetSlowlogAsync(int? numberOfRecords = default(int?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetSortedEntryValuesAsync(string key, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetSortedItemsFromListAsync(string listId, ServiceStack.Redis.SortOptions sortOptions, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetSortedSetCountAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetSortedSetCountAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetSortedSetCountAsync(string setId, long fromScore, long toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetSortedSetCountAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetStringCountAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetUnionFromSetsAsync(string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetUnionFromSetsAsync(params string[] setIds);
            System.Threading.Tasks.ValueTask<string> GetValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetValueFromHashAsync(string hashId, string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetValuesAsync(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetValuesAsync<T>(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetValuesFromHashAsync(string hashId, string[] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetValuesFromHashAsync(string hashId, params string[] keys);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> GetValuesMapAsync(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, T>> GetValuesMapAsync<T>(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            bool HadExceptions { get; }
            System.Threading.Tasks.ValueTask<bool> HashContainsEntryAsync(string hashId, string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisHashAsync> Hashes { get; }
            System.Threading.Tasks.ValueTask<bool> HasLuaScriptAsync(string sha1Ref, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            string Host { get; }
            System.Threading.Tasks.ValueTask<double> IncrementItemInSortedSetAsync(string setId, string value, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> IncrementItemInSortedSetAsync(string setId, string value, long incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> IncrementValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> IncrementValueByAsync(string key, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> IncrementValueByAsync(string key, long count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> IncrementValueByAsync(string key, double count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> IncrementValueInHashAsync(string hashId, string key, int incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> IncrementValueInHashAsync(string hashId, string key, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> InfoAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> InsertAtAsync(string key, int offset, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask KillClientAsync(string address, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> KillClientsAsync(string fromAddress = default(string), string withId = default(string), ServiceStack.Redis.RedisClientType? ofType = default(ServiceStack.Redis.RedisClientType?), bool? skipMe = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask KillRunningLuaScriptAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.DateTime> LastSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisListAsync> Lists { get; }
            System.Threading.Tasks.ValueTask<string> LoadLuaScriptAsync(string body, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask MergeHyperLogsAsync(string toKey, string[] fromKeys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask MergeHyperLogsAsync(string toKey, params string[] fromKeys);
            System.Threading.Tasks.ValueTask MoveBetweenSetsAsync(string fromSetId, string toSetId, string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            string Password { get; set; }
            System.Threading.Tasks.ValueTask PauseAllClientsAsync(System.TimeSpan duration, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> PingAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopAndPushItemBetweenListsAsync(string fromListId, string toListId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopItemFromListAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopItemFromSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> PopItemsFromSetAsync(string setId, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopItemWithHighestScoreFromSortedSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopItemWithLowestScoreFromSortedSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            int Port { get; }
            System.Threading.Tasks.ValueTask PrependItemToListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PrependRangeToListAsync(string listId, System.Collections.Generic.List<string> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> PublishMessageAsync(string toChannel, string message, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PushItemToListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveAllFromListAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveAllLuaScriptsAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> RemoveEndFromListAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(params string[] args);
            System.Threading.Tasks.ValueTask<bool> RemoveEntryFromHashAsync(string hashId, string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RemoveItemFromListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RemoveItemFromListAsync(string listId, string value, int noOfMatches, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveItemFromSetAsync(string setId, string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveItemFromSortedSetAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RemoveItemsFromSortedSetAsync(string setId, System.Collections.Generic.List<string> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RemoveRangeFromSortedSetAsync(string setId, int minRank, int maxRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RemoveRangeFromSortedSetByScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RemoveRangeFromSortedSetByScoreAsync(string setId, long fromScore, long toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RemoveRangeFromSortedSetBySearchAsync(string setId, string start = default(string), string end = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> RemoveStartFromListAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RenameKeyAsync(string fromName, string toName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ResetInfoStatsAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            int RetryCount { get; set; }
            int RetryTimeout { get; set; }
            System.Threading.Tasks.ValueTask SaveConfigAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Collections.Generic.IAsyncEnumerable<System.Collections.Generic.KeyValuePair<string, string>> ScanAllHashEntriesAsync(string hashId, string pattern = default(string), int pageSize = default(int), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Collections.Generic.IAsyncEnumerable<string> ScanAllKeysAsync(string pattern = default(string), int pageSize = default(int), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Collections.Generic.IAsyncEnumerable<string> ScanAllSetItemsAsync(string setId, string pattern = default(string), int pageSize = default(int), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Collections.Generic.IAsyncEnumerable<System.Collections.Generic.KeyValuePair<string, double>> ScanAllSortedSetItemsAsync(string setId, string pattern = default(string), int pageSize = default(int), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> SearchKeysAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> SearchSortedSetAsync(string setId, string start = default(string), string end = default(string), int? skip = default(int?), int? take = default(int?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> SearchSortedSetCountAsync(string setId, string start = default(string), string end = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SelectAsync(long db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            int SendTimeout { get; set; }
            System.Threading.Tasks.ValueTask SetAllAsync(System.Collections.Generic.IEnumerable<string> keys, System.Collections.Generic.IEnumerable<string> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetAllAsync(System.Collections.Generic.IDictionary<string, string> map, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetClientAsync(string name, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetConfigAsync(string item, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SetContainsItemAsync(string setId, string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SetEntryInHashAsync(string hashId, string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SetEntryInHashIfNotExistsAsync(string hashId, string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetItemInListAsync(string listId, int listIndex, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetRangeInHashAsync(string hashId, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> keyValuePairs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSetAsync> Sets { get; }
            System.Threading.Tasks.ValueTask SetValueAsync(string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetValueAsync(string key, string value, System.TimeSpan expireIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SetValueIfExistsAsync(string key, string value, System.TimeSpan? expireIn = default(System.TimeSpan?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SetValueIfNotExistsAsync(string key, string value, System.TimeSpan? expireIn = default(System.TimeSpan?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetValuesAsync(System.Collections.Generic.IDictionary<string, string> map, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ShutdownAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ShutdownNoSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> SliceAsync(string key, int fromIndex, int toIndex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SlowlogResetAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SortedSetContainsItemAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSortedSetAsync> SortedSets { get; }
            System.Threading.Tasks.ValueTask StoreAsHashAsync<T>(T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreDifferencesFromSetAsync(string intoSetId, string fromSetId, string[] withSetIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreDifferencesFromSetAsync(string intoSetId, string fromSetId, params string[] withSetIds);
            System.Threading.Tasks.ValueTask StoreIntersectFromSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreIntersectFromSetsAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<long> StoreIntersectFromSortedSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> StoreIntersectFromSortedSetsAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<long> StoreIntersectFromSortedSetsAsync(string intoSetId, string[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<object> StoreObjectAsync(object entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreUnionFromSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreUnionFromSetsAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<long> StoreUnionFromSortedSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> StoreUnionFromSortedSetsAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<long> StoreUnionFromSortedSetsAsync(string intoSetId, string[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask TrimListAsync(string listId, int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> TypeAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask UnWatchAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            string UrnKey<T>(T value);
            string UrnKey<T>(object id);
            string UrnKey(System.Type type, object id);
            string Username { get; set; }
            System.Threading.Tasks.ValueTask WatchAsync(string[] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask WatchAsync(params string[] keys);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, bool>> WhichLuaScriptsExistsAsync(string[] sha1Refs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, bool>> WhichLuaScriptsExistsAsync(params string[] sha1Refs);
            System.Threading.Tasks.ValueTask WriteAllAsync<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IRedisClientCacheManager : System.IDisposable
        {
            ServiceStack.Caching.ICacheClient GetCacheClient();
            ServiceStack.Redis.IRedisClient GetClient();
            ServiceStack.Caching.ICacheClient GetReadOnlyCacheClient();
            ServiceStack.Redis.IRedisClient GetReadOnlyClient();
        }
        public interface IRedisClientsManager : System.IDisposable
        {
            ServiceStack.Caching.ICacheClient GetCacheClient();
            ServiceStack.Redis.IRedisClient GetClient();
            ServiceStack.Caching.ICacheClient GetReadOnlyCacheClient();
            ServiceStack.Redis.IRedisClient GetReadOnlyClient();
            IRedisResolver RedisResolver { get; }
        }
        public interface IRedisClientsManagerAsync : System.IAsyncDisposable
        {
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> GetCacheClientAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> GetClientAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> GetReadOnlyCacheClientAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> GetReadOnlyClientAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            IRedisResolver RedisResolver { get; }
        }
        public interface IRedisEndpoint : ServiceStack.IO.IEndpoint
        {
            string Client { get; }
            int ConnectTimeout { get; }
            long Db { get; }
            int IdleTimeOutSecs { get; }
            string Password { get; }
            int ReceiveTimeout { get; }
            int RetryTimeout { get; }
            int SendTimeout { get; }
            bool Ssl { get; }
            string Username { get; }
        }
        public interface IRedisHash : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.Generic.IDictionary<string, string>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.IEnumerable, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
        {
            bool AddIfNotExists(System.Collections.Generic.KeyValuePair<string, string> item);
            void AddRange(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> items);
            long IncrementValue(string key, int incrementBy);
        }
        public interface IRedisHashAsync : System.Collections.Generic.IAsyncEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
        {
            System.Threading.Tasks.ValueTask AddAsync(System.Collections.Generic.KeyValuePair<string, string> item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddAsync(string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddIfNotExistsAsync(System.Collections.Generic.KeyValuePair<string, string> item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddRangeAsync(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> items, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ContainsKeyAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> IncrementValueAsync(string key, int incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IRedisList : System.Collections.Generic.ICollection<string>, System.Collections.Generic.IEnumerable<string>, System.Collections.IEnumerable, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId, System.Collections.Generic.IList<string>
        {
            void Append(string value);
            string BlockingDequeue(System.TimeSpan? timeOut);
            string BlockingPop(System.TimeSpan? timeOut);
            string BlockingRemoveStart(System.TimeSpan? timeOut);
            string Dequeue();
            void Enqueue(string value);
            System.Collections.Generic.List<string> GetAll();
            System.Collections.Generic.List<string> GetRange(int startingFrom, int endingAt);
            System.Collections.Generic.List<string> GetRangeFromSortedList(int startingFrom, int endingAt);
            string Pop();
            string PopAndPush(ServiceStack.Redis.IRedisList toList);
            void Prepend(string value);
            void Push(string value);
            void RemoveAll();
            string RemoveEnd();
            string RemoveStart();
            long RemoveValue(string value);
            long RemoveValue(string value, int noOfMatches);
            void Trim(int keepStartingFrom, int keepEndingAt);
        }
        public interface IRedisListAsync : System.Collections.Generic.IAsyncEnumerable<string>, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
        {
            System.Threading.Tasks.ValueTask AddAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AppendAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> BlockingDequeueAsync(System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> BlockingPopAsync(System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> BlockingRemoveStartAsync(System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ContainsAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> DequeueAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ElementAtAsync(int index, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask EnqueueAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeAsync(int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedListAsync(int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<int> IndexOfAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopAndPushAsync(ServiceStack.Redis.IRedisListAsync toList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PrependAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PushAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveAtAsync(int index, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> RemoveEndAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> RemoveStartAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RemoveValueAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RemoveValueAsync(string value, int noOfMatches, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetValueAsync(int index, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask TrimAsync(int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IRedisNativeClient : System.IDisposable
        {
            long Append(string key, byte[] value);
            void BgRewriteAof();
            void BgSave();
            byte[][] BLPop(string listId, int timeOutSecs);
            byte[][] BLPop(string[] listIds, int timeOutSecs);
            byte[] BLPopValue(string listId, int timeOutSecs);
            byte[][] BLPopValue(string[] listIds, int timeOutSecs);
            byte[][] BRPop(string listId, int timeOutSecs);
            byte[][] BRPop(string[] listIds, int timeOutSecs);
            byte[] BRPopLPush(string fromListId, string toListId, int timeOutSecs);
            byte[] BRPopValue(string listId, int timeOutSecs);
            byte[][] BRPopValue(string[] listIds, int timeOutSecs);
            string CalculateSha1(string luaBody);
            string ClientGetName();
            void ClientKill(string host);
            long ClientKill(string addr = default(string), string id = default(string), string type = default(string), string skipMe = default(string));
            byte[] ClientList();
            void ClientPause(int timeOutMs);
            void ClientSetName(string client);
            byte[][] ConfigGet(string pattern);
            void ConfigResetStat();
            void ConfigRewrite();
            void ConfigSet(string item, byte[] value);
            ServiceStack.Redis.IRedisSubscription CreateSubscription();
            long Db { get; set; }
            long DbSize { get; }
            void DebugSegfault();
            long Decr(string key);
            long DecrBy(string key, int decrBy);
            long Del(string key);
            long Del(params string[] keys);
            byte[] Dump(string key);
            string Echo(string text);
            byte[][] Eval(string luaBody, int numberOfKeys, params byte[][] keysAndArgs);
            ServiceStack.Redis.RedisData EvalCommand(string luaBody, int numberKeysInArgs, params byte[][] keys);
            long EvalInt(string luaBody, int numberOfKeys, params byte[][] keysAndArgs);
            byte[][] EvalSha(string sha1, int numberOfKeys, params byte[][] keysAndArgs);
            ServiceStack.Redis.RedisData EvalShaCommand(string sha1, int numberKeysInArgs, params byte[][] keys);
            long EvalShaInt(string sha1, int numberOfKeys, params byte[][] keysAndArgs);
            string EvalShaStr(string sha1, int numberOfKeys, params byte[][] keysAndArgs);
            string EvalStr(string luaBody, int numberOfKeys, params byte[][] keysAndArgs);
            long Exists(string key);
            bool Expire(string key, int seconds);
            bool ExpireAt(string key, long unixTime);
            void FlushAll();
            void FlushDb();
            long GeoAdd(string key, double longitude, double latitude, string member);
            long GeoAdd(string key, params ServiceStack.Redis.RedisGeo[] geoPoints);
            double GeoDist(string key, string fromMember, string toMember, string unit = default(string));
            string[] GeoHash(string key, params string[] members);
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeo> GeoPos(string key, params string[] members);
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> GeoRadius(string key, double longitude, double latitude, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?));
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> GeoRadiusByMember(string key, string member, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?));
            byte[] Get(string key);
            long GetBit(string key, int offset);
            byte[] GetRange(string key, int fromIndex, int toIndex);
            byte[] GetSet(string key, byte[] value);
            long HDel(string hashId, byte[] key);
            long HExists(string hashId, byte[] key);
            byte[] HGet(string hashId, byte[] key);
            byte[][] HGetAll(string hashId);
            long HIncrby(string hashId, byte[] key, int incrementBy);
            double HIncrbyFloat(string hashId, byte[] key, double incrementBy);
            byte[][] HKeys(string hashId);
            long HLen(string hashId);
            byte[][] HMGet(string hashId, params byte[][] keysAndArgs);
            void HMSet(string hashId, byte[][] keys, byte[][] values);
            ServiceStack.Redis.ScanResult HScan(string hashId, ulong cursor, int count = default(int), string match = default(string));
            long HSet(string hashId, byte[] key, byte[] value);
            long HSetNX(string hashId, byte[] key, byte[] value);
            byte[][] HVals(string hashId);
            long Incr(string key);
            long IncrBy(string key, int incrBy);
            double IncrByFloat(string key, double incrBy);
            System.Collections.Generic.Dictionary<string, string> Info { get; }
            byte[][] Keys(string pattern);
            System.DateTime LastSave { get; }
            byte[] LIndex(string listId, int listIndex);
            void LInsert(string listId, bool insertBefore, byte[] pivot, byte[] value);
            long LLen(string listId);
            byte[] LPop(string listId);
            long LPush(string listId, byte[] value);
            long LPushX(string listId, byte[] value);
            byte[][] LRange(string listId, int startingFrom, int endingAt);
            long LRem(string listId, int removeNoOfMatches, byte[] value);
            void LSet(string listId, int listIndex, byte[] value);
            void LTrim(string listId, int keepStartingFrom, int keepEndingAt);
            byte[][] MGet(params byte[][] keysAndArgs);
            byte[][] MGet(params string[] keys);
            void Migrate(string host, int port, string key, int destinationDb, long timeoutMs);
            bool Move(string key, int db);
            void MSet(byte[][] keys, byte[][] values);
            void MSet(string[] keys, byte[][] values);
            bool MSetNx(byte[][] keys, byte[][] values);
            bool MSetNx(string[] keys, byte[][] values);
            long ObjectIdleTime(string key);
            bool Persist(string key);
            bool PExpire(string key, long ttlMs);
            bool PExpireAt(string key, long unixTimeMs);
            bool PfAdd(string key, params byte[][] elements);
            long PfCount(string key);
            void PfMerge(string toKeyId, params string[] fromKeys);
            bool Ping();
            void PSetEx(string key, long expireInMs, byte[] value);
            byte[][] PSubscribe(params string[] toChannelsMatchingPatterns);
            long PTtl(string key);
            long Publish(string toChannel, byte[] message);
            byte[][] PUnSubscribe(params string[] toChannelsMatchingPatterns);
            void Quit();
            string RandomKey();
            ServiceStack.Redis.RedisData RawCommand(params object[] cmdWithArgs);
            ServiceStack.Redis.RedisData RawCommand(params byte[][] cmdWithBinaryArgs);
            byte[][] ReceiveMessages();
            void Rename(string oldKeyName, string newKeyName);
            bool RenameNx(string oldKeyName, string newKeyName);
            byte[] Restore(string key, long expireMs, byte[] dumpValue);
            ServiceStack.Redis.RedisText Role();
            byte[] RPop(string listId);
            byte[] RPopLPush(string fromListId, string toListId);
            long RPush(string listId, byte[] value);
            long RPushX(string listId, byte[] value);
            long SAdd(string setId, byte[] value);
            long SAdd(string setId, byte[][] value);
            void Save();
            ServiceStack.Redis.ScanResult Scan(ulong cursor, int count = default(int), string match = default(string));
            long SCard(string setId);
            byte[][] ScriptExists(params byte[][] sha1Refs);
            void ScriptFlush();
            void ScriptKill();
            byte[] ScriptLoad(string body);
            byte[][] SDiff(string fromSetId, params string[] withSetIds);
            void SDiffStore(string intoSetId, string fromSetId, params string[] withSetIds);
            void Set(string key, byte[] value);
            long SetBit(string key, int offset, int value);
            void SetEx(string key, int expireInSeconds, byte[] value);
            long SetNX(string key, byte[] value);
            long SetRange(string key, int offset, byte[] value);
            void Shutdown();
            byte[][] SInter(params string[] setIds);
            void SInterStore(string intoSetId, params string[] setIds);
            long SIsMember(string setId, byte[] value);
            void SlaveOf(string hostname, int port);
            void SlaveOfNoOne();
            byte[][] SMembers(string setId);
            void SMove(string fromSetId, string toSetId, byte[] value);
            byte[][] Sort(string listOrSetId, ServiceStack.Redis.SortOptions sortOptions);
            byte[] SPop(string setId);
            byte[][] SPop(string setId, int count);
            byte[] SRandMember(string setId);
            long SRem(string setId, byte[] value);
            ServiceStack.Redis.ScanResult SScan(string setId, ulong cursor, int count = default(int), string match = default(string));
            long StrLen(string key);
            byte[][] Subscribe(params string[] toChannels);
            byte[][] SUnion(params string[] setIds);
            void SUnionStore(string intoSetId, params string[] setIds);
            byte[][] Time();
            long Ttl(string key);
            string Type(string key);
            byte[][] UnSubscribe(params string[] toChannels);
            void UnWatch();
            void Watch(params string[] keys);
            long ZAdd(string setId, double score, byte[] value);
            long ZAdd(string setId, long score, byte[] value);
            long ZCard(string setId);
            double ZIncrBy(string setId, double incrBy, byte[] value);
            double ZIncrBy(string setId, long incrBy, byte[] value);
            long ZInterStore(string intoSetId, params string[] setIds);
            long ZLexCount(string setId, string min, string max);
            byte[][] ZRange(string setId, int min, int max);
            byte[][] ZRangeByLex(string setId, string min, string max, int? skip = default(int?), int? take = default(int?));
            byte[][] ZRangeByScore(string setId, double min, double max, int? skip, int? take);
            byte[][] ZRangeByScore(string setId, long min, long max, int? skip, int? take);
            byte[][] ZRangeByScoreWithScores(string setId, double min, double max, int? skip, int? take);
            byte[][] ZRangeByScoreWithScores(string setId, long min, long max, int? skip, int? take);
            byte[][] ZRangeWithScores(string setId, int min, int max);
            long ZRank(string setId, byte[] value);
            long ZRem(string setId, byte[] value);
            long ZRem(string setId, byte[][] values);
            long ZRemRangeByLex(string setId, string min, string max);
            long ZRemRangeByRank(string setId, int min, int max);
            long ZRemRangeByScore(string setId, double fromScore, double toScore);
            long ZRemRangeByScore(string setId, long fromScore, long toScore);
            byte[][] ZRevRange(string setId, int min, int max);
            byte[][] ZRevRangeByScore(string setId, double min, double max, int? skip, int? take);
            byte[][] ZRevRangeByScore(string setId, long min, long max, int? skip, int? take);
            byte[][] ZRevRangeByScoreWithScores(string setId, double min, double max, int? skip, int? take);
            byte[][] ZRevRangeByScoreWithScores(string setId, long min, long max, int? skip, int? take);
            byte[][] ZRevRangeWithScores(string setId, int min, int max);
            long ZRevRank(string setId, byte[] value);
            ServiceStack.Redis.ScanResult ZScan(string setId, ulong cursor, int count = default(int), string match = default(string));
            double ZScore(string setId, byte[] value);
            long ZUnionStore(string intoSetId, params string[] setIds);
        }
        public interface IRedisNativeClientAsync : System.IAsyncDisposable
        {
            System.Threading.Tasks.ValueTask<long> AppendAsync(string key, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask BgRewriteAofAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask BgSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> BitCountAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> BLPopAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> BLPopAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> BLPopValueAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> BLPopValueAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> BRPopAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> BRPopAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> BRPopLPushAsync(string fromListId, string toListId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> BRPopValueAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> BRPopValueAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> CalculateSha1Async(string luaBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ClientGetNameAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClientKillAsync(string host, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ClientKillAsync(string addr = default(string), string id = default(string), string type = default(string), string skipMe = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> ClientListAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClientPauseAsync(int timeOutMs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClientSetNameAsync(string client, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ConfigGetAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ConfigResetStatAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ConfigRewriteAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ConfigSetAsync(string item, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisSubscriptionAsync> CreateSubscriptionAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            long Db { get; }
            System.Threading.Tasks.ValueTask<long> DbSizeAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask DebugSegfaultAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> DecrAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> DecrByAsync(string key, long decrBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> DelAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> DelAsync(string[] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> DelAsync(params string[] keys);
            System.Threading.Tasks.ValueTask<byte[]> DumpAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> EchoAsync(string text, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> EvalAsync(string luaBody, int numberOfKeys, byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> EvalAsync(string luaBody, int numberOfKeys, params byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> EvalCommandAsync(string luaBody, int numberKeysInArgs, byte[][] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> EvalCommandAsync(string luaBody, int numberKeysInArgs, params byte[][] keys);
            System.Threading.Tasks.ValueTask<long> EvalIntAsync(string luaBody, int numberOfKeys, byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> EvalIntAsync(string luaBody, int numberOfKeys, params byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<byte[][]> EvalShaAsync(string sha1, int numberOfKeys, byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> EvalShaAsync(string sha1, int numberOfKeys, params byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> EvalShaCommandAsync(string sha1, int numberKeysInArgs, byte[][] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> EvalShaCommandAsync(string sha1, int numberKeysInArgs, params byte[][] keys);
            System.Threading.Tasks.ValueTask<long> EvalShaIntAsync(string sha1, int numberOfKeys, byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> EvalShaIntAsync(string sha1, int numberOfKeys, params byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<string> EvalShaStrAsync(string sha1, int numberOfKeys, byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> EvalShaStrAsync(string sha1, int numberOfKeys, params byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<string> EvalStrAsync(string luaBody, int numberOfKeys, byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> EvalStrAsync(string luaBody, int numberOfKeys, params byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<long> ExistsAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ExpireAsync(string key, int seconds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ExpireAtAsync(string key, long unixTime, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask FlushAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask FlushDbAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GeoAddAsync(string key, double longitude, double latitude, string member, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GeoAddAsync(string key, ServiceStack.Redis.RedisGeo[] geoPoints, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GeoAddAsync(string key, params ServiceStack.Redis.RedisGeo[] geoPoints);
            System.Threading.Tasks.ValueTask<double> GeoDistAsync(string key, string fromMember, string toMember, string unit = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string[]> GeoHashAsync(string key, string[] members, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string[]> GeoHashAsync(string key, params string[] members);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> GeoPosAsync(string key, string[] members, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> GeoPosAsync(string key, params string[] members);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> GeoRadiusAsync(string key, double longitude, double latitude, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> GeoRadiusByMemberAsync(string key, string member, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> GetAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetBitAsync(string key, int offset, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> GetRangeAsync(string key, int fromIndex, int toIndex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> GetSetAsync(string key, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> HDelAsync(string hashId, byte[] key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> HExistsAsync(string hashId, byte[] key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> HGetAllAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> HGetAsync(string hashId, byte[] key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> HIncrbyAsync(string hashId, byte[] key, int incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> HIncrbyFloatAsync(string hashId, byte[] key, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> HKeysAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> HLenAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> HMGetAsync(string hashId, byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> HMGetAsync(string hashId, params byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask HMSetAsync(string hashId, byte[][] keys, byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> HScanAsync(string hashId, ulong cursor, int count = default(int), string match = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> HSetAsync(string hashId, byte[] key, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> HSetNXAsync(string hashId, byte[] key, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> HValsAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> IncrAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> IncrByAsync(string key, long incrBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> IncrByFloatAsync(string key, double incrBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> InfoAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> KeysAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.DateTime> LastSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> LIndexAsync(string listId, int listIndex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask LInsertAsync(string listId, bool insertBefore, byte[] pivot, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> LLenAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> LPopAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> LPushAsync(string listId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> LPushXAsync(string listId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> LRangeAsync(string listId, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> LRemAsync(string listId, int removeNoOfMatches, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask LSetAsync(string listId, int listIndex, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask LTrimAsync(string listId, int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> MGetAsync(byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> MGetAsync(params byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<byte[][]> MGetAsync(string[] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> MGetAsync(params string[] keys);
            System.Threading.Tasks.ValueTask MigrateAsync(string host, int port, string key, int destinationDb, long timeoutMs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> MoveAsync(string key, int db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask MSetAsync(byte[][] keys, byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask MSetAsync(string[] keys, byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> MSetNxAsync(byte[][] keys, byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> MSetNxAsync(string[] keys, byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ObjectIdleTimeAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> PersistAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> PExpireAsync(string key, long ttlMs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> PExpireAtAsync(string key, long unixTimeMs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> PfAddAsync(string key, byte[][] elements, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> PfAddAsync(string key, params byte[][] elements);
            System.Threading.Tasks.ValueTask<long> PfCountAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PfMergeAsync(string toKeyId, string[] fromKeys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PfMergeAsync(string toKeyId, params string[] fromKeys);
            System.Threading.Tasks.ValueTask<bool> PingAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PSetExAsync(string key, long expireInMs, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> PSubscribeAsync(string[] toChannelsMatchingPatterns, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> PSubscribeAsync(params string[] toChannelsMatchingPatterns);
            System.Threading.Tasks.ValueTask<long> PTtlAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> PublishAsync(string toChannel, byte[] message, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> PUnSubscribeAsync(string[] toChannelsMatchingPatterns, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> PUnSubscribeAsync(params string[] toChannelsMatchingPatterns);
            System.Threading.Tasks.ValueTask QuitAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> RandomKeyAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> RawCommandAsync(object[] cmdWithArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> RawCommandAsync(params object[] cmdWithArgs);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> RawCommandAsync(byte[][] cmdWithBinaryArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> RawCommandAsync(params byte[][] cmdWithBinaryArgs);
            System.Threading.Tasks.ValueTask<byte[][]> ReceiveMessagesAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RenameAsync(string oldKeyName, string newKeyName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RenameNxAsync(string oldKeyName, string newKeyName, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> RestoreAsync(string key, long expireMs, byte[] dumpValue, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> RoleAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> RPopAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> RPopLPushAsync(string fromListId, string toListId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RPushAsync(string listId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> RPushXAsync(string listId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> SAddAsync(string setId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> SAddAsync(string setId, byte[][] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> ScanAsync(ulong cursor, int count = default(int), string match = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> SCardAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ScriptExistsAsync(byte[][] sha1Refs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ScriptExistsAsync(params byte[][] sha1Refs);
            System.Threading.Tasks.ValueTask ScriptFlushAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ScriptKillAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> ScriptLoadAsync(string body, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SDiffAsync(string fromSetId, string[] withSetIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SDiffAsync(string fromSetId, params string[] withSetIds);
            System.Threading.Tasks.ValueTask SDiffStoreAsync(string intoSetId, string fromSetId, string[] withSetIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SDiffStoreAsync(string intoSetId, string fromSetId, params string[] withSetIds);
            System.Threading.Tasks.ValueTask SelectAsync(long db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SetAsync(string key, byte[] value, bool exists, long expirySeconds = default(long), long expiryMilliseconds = default(long), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetAsync(string key, byte[] value, long expirySeconds = default(long), long expiryMilliseconds = default(long), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> SetBitAsync(string key, int offset, int value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetExAsync(string key, int expireInSeconds, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> SetNXAsync(string key, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> SetRangeAsync(string key, int offset, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ShutdownAsync(bool noSave = default(bool), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SInterAsync(string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SInterAsync(params string[] setIds);
            System.Threading.Tasks.ValueTask SInterStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SInterStoreAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<long> SIsMemberAsync(string setId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SlaveOfAsync(string hostname, int port, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SlaveOfNoOneAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<object[]> SlowlogGetAsync(int? top = default(int?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SlowlogResetAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SMembersAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SMoveAsync(string fromSetId, string toSetId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SortAsync(string listOrSetId, ServiceStack.Redis.SortOptions sortOptions, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> SPopAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SPopAsync(string setId, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[]> SRandMemberAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> SRemAsync(string setId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> SScanAsync(string setId, ulong cursor, int count = default(int), string match = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> StrLenAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SubscribeAsync(string[] toChannels, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SubscribeAsync(params string[] toChannels);
            System.Threading.Tasks.ValueTask<byte[][]> SUnionAsync(string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> SUnionAsync(params string[] setIds);
            System.Threading.Tasks.ValueTask SUnionStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SUnionStoreAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<byte[][]> TimeAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> TtlAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> TypeAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> UnSubscribeAsync(string[] toChannels, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> UnSubscribeAsync(params string[] toChannels);
            System.Threading.Tasks.ValueTask UnWatchAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask WatchAsync(string[] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask WatchAsync(params string[] keys);
            System.Threading.Tasks.ValueTask<long> ZAddAsync(string setId, double score, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZAddAsync(string setId, long score, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZCardAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZCountAsync(string setId, double min, double max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> ZIncrByAsync(string setId, double incrBy, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> ZIncrByAsync(string setId, long incrBy, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZInterStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZInterStoreAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<long> ZLexCountAsync(string setId, string min, string max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRangeAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRangeByLexAsync(string setId, string min, string max, int? skip = default(int?), int? take = default(int?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRangeByScoreAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRangeByScoreAsync(string setId, long min, long max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRangeByScoreWithScoresAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRangeByScoreWithScoresAsync(string setId, long min, long max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRangeWithScoresAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZRankAsync(string setId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZRemAsync(string setId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZRemAsync(string setId, byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZRemRangeByLexAsync(string setId, string min, string max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZRemRangeByRankAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZRemRangeByScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZRemRangeByScoreAsync(string setId, long fromScore, long toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRevRangeAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRevRangeByScoreAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRevRangeByScoreAsync(string setId, long min, long max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRevRangeByScoreWithScoresAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRevRangeByScoreWithScoresAsync(string setId, long min, long max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<byte[][]> ZRevRangeWithScoresAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZRevRankAsync(string setId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> ZScanAsync(string setId, ulong cursor, int count = default(int), string match = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> ZScoreAsync(string setId, byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZUnionStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> ZUnionStoreAsync(string intoSetId, params string[] setIds);
        }
        public interface IRedisPubSubServer : System.IDisposable
        {
            string[] Channels { get; }
            ServiceStack.Redis.IRedisClientsManager ClientsManager { get; }
            System.DateTime CurrentServerTime { get; }
            string GetStatsDescription();
            string GetStatus();
            System.Action OnDispose { get; set; }
            System.Action<System.Exception> OnError { get; set; }
            System.Action<string> OnEvent { get; set; }
            System.Action<ServiceStack.Redis.IRedisPubSubServer> OnFailover { get; set; }
            System.Action OnInit { get; set; }
            System.Action<string, string> OnMessage { get; set; }
            System.Action OnStart { get; set; }
            System.Action OnStop { get; set; }
            System.Action<string> OnUnSubscribe { get; set; }
            void Restart();
            ServiceStack.Redis.IRedisPubSubServer Start();
            void Stop();
            System.TimeSpan? WaitBeforeNextRestart { get; set; }
        }
        public interface IRedisSet : System.Collections.Generic.ICollection<string>, System.Collections.Generic.IEnumerable<string>, System.Collections.IEnumerable, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
        {
            System.Collections.Generic.HashSet<string> Diff(ServiceStack.Redis.IRedisSet[] withSets);
            System.Collections.Generic.HashSet<string> GetAll();
            string GetRandomEntry();
            System.Collections.Generic.List<string> GetRangeFromSortedSet(int startingFrom, int endingAt);
            System.Collections.Generic.HashSet<string> Intersect(params ServiceStack.Redis.IRedisSet[] withSets);
            void Move(string value, ServiceStack.Redis.IRedisSet toSet);
            string Pop();
            void StoreDiff(ServiceStack.Redis.IRedisSet fromSet, params ServiceStack.Redis.IRedisSet[] withSets);
            void StoreIntersect(params ServiceStack.Redis.IRedisSet[] withSets);
            void StoreUnion(params ServiceStack.Redis.IRedisSet[] withSets);
            System.Collections.Generic.HashSet<string> Union(params ServiceStack.Redis.IRedisSet[] withSets);
        }
        public interface IRedisSetAsync : System.Collections.Generic.IAsyncEnumerable<string>, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
        {
            System.Threading.Tasks.ValueTask AddAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ContainsAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> DiffAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetRandomEntryAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetAsync(int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> IntersectAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> IntersectAsync(params ServiceStack.Redis.IRedisSetAsync[] withSets);
            System.Threading.Tasks.ValueTask MoveAsync(string value, ServiceStack.Redis.IRedisSetAsync toSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreDiffAsync(ServiceStack.Redis.IRedisSetAsync fromSet, ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreDiffAsync(ServiceStack.Redis.IRedisSetAsync fromSet, params ServiceStack.Redis.IRedisSetAsync[] withSets);
            System.Threading.Tasks.ValueTask StoreIntersectAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreIntersectAsync(params ServiceStack.Redis.IRedisSetAsync[] withSets);
            System.Threading.Tasks.ValueTask StoreUnionAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreUnionAsync(params ServiceStack.Redis.IRedisSetAsync[] withSets);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> UnionAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> UnionAsync(params ServiceStack.Redis.IRedisSetAsync[] withSets);
        }
        public interface IRedisSortedSet : System.Collections.Generic.ICollection<string>, System.Collections.Generic.IEnumerable<string>, System.Collections.IEnumerable, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
        {
            System.Collections.Generic.List<string> GetAll();
            long GetItemIndex(string value);
            double GetItemScore(string value);
            System.Collections.Generic.List<string> GetRange(int startingRank, int endingRank);
            System.Collections.Generic.List<string> GetRangeByScore(string fromStringScore, string toStringScore);
            System.Collections.Generic.List<string> GetRangeByScore(string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeByScore(double fromScore, double toScore);
            System.Collections.Generic.List<string> GetRangeByScore(double fromScore, double toScore, int? skip, int? take);
            void IncrementItemScore(string value, double incrementByScore);
            string PopItemWithHighestScore();
            string PopItemWithLowestScore();
            void RemoveRange(int fromRank, int toRank);
            void RemoveRangeByScore(double fromScore, double toScore);
            void StoreFromIntersect(params ServiceStack.Redis.IRedisSortedSet[] ofSets);
            void StoreFromUnion(params ServiceStack.Redis.IRedisSortedSet[] ofSets);
        }
        public interface IRedisSortedSetAsync : System.Collections.Generic.IAsyncEnumerable<string>, ServiceStack.Model.IHasId<string>, ServiceStack.Model.IHasStringId
        {
            System.Threading.Tasks.ValueTask AddAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ContainsAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<long> GetItemIndexAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> GetItemScoreAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeAsync(int startingRank, int endingRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeByScoreAsync(string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeByScoreAsync(string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeByScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeByScoreAsync(double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask IncrementItemScoreAsync(string value, double incrementByScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopItemWithHighestScoreAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopItemWithLowestScoreAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveRangeAsync(int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveRangeByScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreFromIntersectAsync(ServiceStack.Redis.IRedisSortedSetAsync[] ofSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreFromIntersectAsync(params ServiceStack.Redis.IRedisSortedSetAsync[] ofSets);
            System.Threading.Tasks.ValueTask StoreFromUnionAsync(ServiceStack.Redis.IRedisSortedSetAsync[] ofSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreFromUnionAsync(params ServiceStack.Redis.IRedisSortedSetAsync[] ofSets);
        }
        public interface IRedisSubscription : System.IDisposable
        {
            System.Action<string, string> OnMessage { get; set; }
            System.Action<string, byte[]> OnMessageBytes { get; set; }
            System.Action<string> OnSubscribe { get; set; }
            System.Action<string> OnUnSubscribe { get; set; }
            void SubscribeToChannels(params string[] channels);
            void SubscribeToChannelsMatching(params string[] patterns);
            long SubscriptionCount { get; }
            void UnSubscribeFromAllChannels();
            void UnSubscribeFromChannels(params string[] channels);
            void UnSubscribeFromChannelsMatching(params string[] patterns);
        }
        public interface IRedisSubscriptionAsync : System.IAsyncDisposable
        {
            event System.Func<string, string, System.Threading.Tasks.ValueTask> OnMessageAsync;
            event System.Func<string, byte[], System.Threading.Tasks.ValueTask> OnMessageBytesAsync;
            event System.Func<string, System.Threading.Tasks.ValueTask> OnSubscribeAsync;
            event System.Func<string, System.Threading.Tasks.ValueTask> OnUnSubscribeAsync;
            System.Threading.Tasks.ValueTask SubscribeToChannelsAsync(string[] channels, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SubscribeToChannelsAsync(params string[] channels);
            System.Threading.Tasks.ValueTask SubscribeToChannelsMatchingAsync(string[] patterns, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SubscribeToChannelsMatchingAsync(params string[] patterns);
            long SubscriptionCount { get; }
            System.Threading.Tasks.ValueTask UnSubscribeFromAllChannelsAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask UnSubscribeFromChannelsAsync(string[] channels, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask UnSubscribeFromChannelsAsync(params string[] channels);
            System.Threading.Tasks.ValueTask UnSubscribeFromChannelsMatchingAsync(string[] patterns, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask UnSubscribeFromChannelsMatchingAsync(params string[] patterns);
        }
        public interface IRedisTransaction : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisPipelineShared, ServiceStack.Redis.Pipeline.IRedisQueueableOperation, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation, ServiceStack.Redis.IRedisTransactionBase
        {
            bool Commit();
            void Rollback();
        }
        public interface IRedisTransactionAsync : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync, ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync, ServiceStack.Redis.IRedisTransactionBaseAsync
        {
            System.Threading.Tasks.ValueTask<bool> CommitAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RollbackAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IRedisTransactionBase : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisPipelineShared, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation
        {
        }
        public interface IRedisTransactionBaseAsync : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync
        {
        }
        public class ItemRef
        {
            public ItemRef() => throw null;
            public string Id { get => throw null; set { } }
            public string Item { get => throw null; set { } }
        }
        namespace Pipeline
        {
            public interface IRedisPipeline : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisPipelineShared, ServiceStack.Redis.Pipeline.IRedisQueueableOperation, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation
            {
            }
            public interface IRedisPipelineAsync : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync, ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync
            {
            }
            public interface IRedisPipelineShared : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation
            {
                void Flush();
                bool Replay();
            }
            public interface IRedisPipelineSharedAsync : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync
            {
                System.Threading.Tasks.ValueTask FlushAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ReplayAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }
            public interface IRedisQueueableOperation
            {
                void QueueCommand(System.Action<ServiceStack.Redis.IRedisClient> command);
                void QueueCommand(System.Action<ServiceStack.Redis.IRedisClient> command, System.Action onSuccessCallback);
                void QueueCommand(System.Action<ServiceStack.Redis.IRedisClient> command, System.Action onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, int> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, int> command, System.Action<int> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, int> command, System.Action<int> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, long> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, long> command, System.Action<long> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, long> command, System.Action<long> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, bool> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, bool> command, System.Action<bool> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, bool> command, System.Action<bool> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, double> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, double> command, System.Action<double> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, double> command, System.Action<double> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, byte[]> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, byte[]> command, System.Action<byte[]> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, byte[]> command, System.Action<byte[]> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, byte[][]> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, byte[][]> command, System.Action<byte[][]> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, byte[][]> command, System.Action<byte[][]> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, string> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, string> command, System.Action<string> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, string> command, System.Action<string> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.List<string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.HashSet<string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.Dictionary<string, string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.Dictionary<string, string>> command, System.Action<System.Collections.Generic.Dictionary<string, string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.Dictionary<string, string>> command, System.Action<System.Collections.Generic.Dictionary<string, string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisData> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisData> command, System.Action<ServiceStack.Redis.RedisData> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisData> command, System.Action<ServiceStack.Redis.RedisData> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisText> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisText> command, System.Action<ServiceStack.Redis.RedisText> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisText> command, System.Action<ServiceStack.Redis.RedisText> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
            }
            public interface IRedisQueueableOperationAsync
            {
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask> command, System.Action onSuccessCallback = default(System.Action), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<int>> command, System.Action<int> onSuccessCallback = default(System.Action<int>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<long>> command, System.Action<long> onSuccessCallback = default(System.Action<long>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<bool>> command, System.Action<bool> onSuccessCallback = default(System.Action<bool>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<double>> command, System.Action<double> onSuccessCallback = default(System.Action<double>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<byte[]>> command, System.Action<byte[]> onSuccessCallback = default(System.Action<byte[]>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<byte[][]>> command, System.Action<byte[][]> onSuccessCallback = default(System.Action<byte[][]>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<string>> command, System.Action<string> onSuccessCallback = default(System.Action<string>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback = default(System.Action<System.Collections.Generic.List<string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback = default(System.Action<System.Collections.Generic.HashSet<string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>>> command, System.Action<System.Collections.Generic.Dictionary<string, string>> onSuccessCallback = default(System.Action<System.Collections.Generic.Dictionary<string, string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData>> command, System.Action<ServiceStack.Redis.RedisData> onSuccessCallback = default(System.Action<ServiceStack.Redis.RedisData>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText>> command, System.Action<ServiceStack.Redis.RedisText> onSuccessCallback = default(System.Action<ServiceStack.Redis.RedisText>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
            }
            public interface IRedisQueueCompletableOperation
            {
                void CompleteBytesQueuedCommand(System.Func<byte[]> bytesReadCommand);
                void CompleteDoubleQueuedCommand(System.Func<double> doubleReadCommand);
                void CompleteIntQueuedCommand(System.Func<int> intReadCommand);
                void CompleteLongQueuedCommand(System.Func<long> longReadCommand);
                void CompleteMultiBytesQueuedCommand(System.Func<byte[][]> multiBytesReadCommand);
                void CompleteMultiStringQueuedCommand(System.Func<System.Collections.Generic.List<string>> multiStringReadCommand);
                void CompleteRedisDataQueuedCommand(System.Func<ServiceStack.Redis.RedisData> redisDataReadCommand);
                void CompleteStringQueuedCommand(System.Func<string> stringReadCommand);
                void CompleteVoidQueuedCommand(System.Action voidReadCommand);
            }
            public interface IRedisQueueCompletableOperationAsync
            {
                void CompleteBytesQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<byte[]>> bytesReadCommand);
                void CompleteDoubleQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<double>> doubleReadCommand);
                void CompleteIntQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<int>> intReadCommand);
                void CompleteLongQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<long>> longReadCommand);
                void CompleteMultiBytesQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<byte[][]>> multiBytesReadCommand);
                void CompleteMultiStringQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> multiStringReadCommand);
                void CompleteRedisDataQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData>> redisDataReadCommand);
                void CompleteStringQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<string>> stringReadCommand);
                void CompleteVoidQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> voidReadCommand);
            }
        }
        public enum RedisClientType
        {
            Normal = 0,
            Slave = 1,
            PubSub = 2,
        }
        public class RedisData
        {
            public System.Collections.Generic.List<ServiceStack.Redis.RedisData> Children { get => throw null; set { } }
            public RedisData() => throw null;
            public byte[] Data { get => throw null; set { } }
        }
        public class RedisGeo
        {
            public RedisGeo() => throw null;
            public RedisGeo(double longitude, double latitude, string member) => throw null;
            public double Latitude { get => throw null; set { } }
            public double Longitude { get => throw null; set { } }
            public string Member { get => throw null; set { } }
        }
        public class RedisGeoResult
        {
            public RedisGeoResult() => throw null;
            public double Distance { get => throw null; set { } }
            public long Hash { get => throw null; set { } }
            public double Latitude { get => throw null; set { } }
            public double Longitude { get => throw null; set { } }
            public string Member { get => throw null; set { } }
            public string Unit { get => throw null; set { } }
        }
        public static class RedisGeoUnit
        {
            public const string Feet = default;
            public const string Kilometers = default;
            public const string Meters = default;
            public const string Miles = default;
        }
        public enum RedisKeyType
        {
            None = 0,
            String = 1,
            List = 2,
            Set = 3,
            SortedSet = 4,
            Hash = 5,
        }
        public enum RedisServerRole
        {
            Unknown = 0,
            Master = 1,
            Slave = 2,
            Sentinel = 3,
        }
        public class RedisText
        {
            public System.Collections.Generic.List<ServiceStack.Redis.RedisText> Children { get => throw null; set { } }
            public RedisText() => throw null;
            public string Text { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        public class ScanResult
        {
            public ScanResult() => throw null;
            public ulong Cursor { get => throw null; set { } }
            public System.Collections.Generic.List<byte[]> Results { get => throw null; set { } }
        }
        public class SlowlogItem
        {
            public string[] Arguments { get => throw null; }
            public SlowlogItem(int id, System.DateTime timeStamp, int duration, string[] arguments) => throw null;
            public int Duration { get => throw null; }
            public int Id { get => throw null; }
            public System.DateTime Timestamp { get => throw null; }
        }
        public class SortOptions
        {
            public SortOptions() => throw null;
            public string GetPattern { get => throw null; set { } }
            public int? Skip { get => throw null; set { } }
            public bool SortAlpha { get => throw null; set { } }
            public bool SortDesc { get => throw null; set { } }
            public string SortPattern { get => throw null; set { } }
            public string StoreAtKey { get => throw null; set { } }
            public int? Take { get => throw null; set { } }
        }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class RefAttribute : ServiceStack.AttributeBase
    {
        public RefAttribute() => throw null;
        public string Model { get => throw null; set { } }
        public System.Type ModelType { get => throw null; set { } }
        public bool None { get => throw null; set { } }
        public System.Type QueryType { get => throw null; set { } }
        public string RefId { get => throw null; set { } }
        public string RefLabel { get => throw null; set { } }
        public string SelfId { get => throw null; set { } }
    }
    public class ReflectAttribute
    {
        public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<System.Reflection.PropertyInfo, object>> ConstructorArgs { get => throw null; set { } }
        public ReflectAttribute() => throw null;
        public string Name { get => throw null; set { } }
        public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<System.Reflection.PropertyInfo, object>> PropertyArgs { get => throw null; set { } }
    }
    public enum RelativeTimeStyle
    {
        Undefined = 0,
        Long = 1,
        Short = 2,
        Narrow = 3,
    }
    [System.Flags]
    public enum RequestAttributes : long
    {
        None = 0,
        Any = -1,
        AnyNetworkAccessType = -2147483641,
        AnySecurityMode = 24,
        AnyHttpMethod = 8160,
        AnyCallStyle = 24576,
        AnyFormat = 67076096,
        AnyEndpoint = 2080374784,
        InternalNetworkAccess = -2147483645,
        Localhost = 1,
        LocalSubnet = 2,
        External = 4,
        Secure = 8,
        InSecure = 16,
        HttpHead = 32,
        HttpGet = 64,
        HttpPost = 128,
        HttpPut = 256,
        HttpDelete = 512,
        HttpPatch = 1024,
        HttpOptions = 2048,
        HttpOther = 4096,
        OneWay = 8192,
        Reply = 16384,
        Soap11 = 32768,
        Soap12 = 65536,
        Xml = 131072,
        Json = 262144,
        Jsv = 524288,
        ProtoBuf = 1048576,
        Csv = 2097152,
        Html = 4194304,
        Wire = 8388608,
        MsgPack = 16777216,
        FormatOther = 33554432,
        Http = 67108864,
        MessageQueue = 134217728,
        Tcp = 268435456,
        Grpc = 536870912,
        EndpointOther = 1073741824,
        InProcess = -2147483648,
    }
    public static partial class RequestAttributesExtensions
    {
        public static string FromFormat(this ServiceStack.Format format) => throw null;
        public static bool IsExternal(this ServiceStack.RequestAttributes attrs) => throw null;
        public static bool IsLocalhost(this ServiceStack.RequestAttributes attrs) => throw null;
        public static bool IsLocalSubnet(this ServiceStack.RequestAttributes attrs) => throw null;
        public static ServiceStack.Feature ToFeature(this ServiceStack.Format format) => throw null;
        public static ServiceStack.Format ToFormat(this string format) => throw null;
        public static ServiceStack.Format ToFormat(this ServiceStack.Feature feature) => throw null;
        public static ServiceStack.RequestAttributes ToRequestAttribute(this ServiceStack.Format format) => throw null;
        public static ServiceStack.Feature ToSoapFeature(this ServiceStack.RequestAttributes attributes) => throw null;
    }
    public class RequestLogEntry : ServiceStack.IMeta
    {
        public string AbsoluteUri { get => throw null; set { } }
        public RequestLogEntry() => throw null;
        public System.DateTime DateTime { get => throw null; set { } }
        public object ErrorResponse { get => throw null; set { } }
        public System.Collections.IDictionary ExceptionData { get => throw null; set { } }
        public string ExceptionSource { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> FormData { get => throw null; set { } }
        public string ForwardedFor { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Headers { get => throw null; set { } }
        public string HttpMethod { get => throw null; set { } }
        public long Id { get => throw null; set { } }
        public string IpAddress { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Items { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string OperationName { get => throw null; set { } }
        public string PathInfo { get => throw null; set { } }
        public string Referer { get => throw null; set { } }
        public string RequestBody { get => throw null; set { } }
        public object RequestDto { get => throw null; set { } }
        public System.TimeSpan RequestDuration { get => throw null; set { } }
        public object ResponseDto { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> ResponseHeaders { get => throw null; set { } }
        public object Session { get => throw null; set { } }
        public string SessionId { get => throw null; set { } }
        public int StatusCode { get => throw null; set { } }
        public string StatusDescription { get => throw null; set { } }
        public string TraceId { get => throw null; set { } }
        public string UserAuthId { get => throw null; set { } }
    }
    public class ResponseError : ServiceStack.IMeta
    {
        public ResponseError() => throw null;
        public string ErrorCode { get => throw null; set { } }
        public string FieldName { get => throw null; set { } }
        public string Message { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
    }
    public class ResponseStatus : ServiceStack.IMeta
    {
        public ResponseStatus() => throw null;
        public ResponseStatus(string errorCode) => throw null;
        public ResponseStatus(string errorCode, string message) => throw null;
        public string ErrorCode { get => throw null; set { } }
        public System.Collections.Generic.List<ServiceStack.ResponseError> Errors { get => throw null; set { } }
        public string Message { get => throw null; set { } }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public string StackTrace { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false, Inherited = true)]
    public class RestrictAttribute : ServiceStack.AttributeBase
    {
        public ServiceStack.RequestAttributes[] AccessibleToAny { get => throw null; }
        public ServiceStack.RequestAttributes AccessTo { get => throw null; set { } }
        public bool CanShowTo(ServiceStack.RequestAttributes restrictions) => throw null;
        public RestrictAttribute() => throw null;
        public RestrictAttribute(params ServiceStack.RequestAttributes[] restrictAccessAndVisibilityToScenarios) => throw null;
        public RestrictAttribute(ServiceStack.RequestAttributes[] allowedAccessScenarios, ServiceStack.RequestAttributes[] visibleToScenarios) => throw null;
        public bool ExternalOnly { get => throw null; set { } }
        public bool HasAccessTo(ServiceStack.RequestAttributes restrictions) => throw null;
        public bool HasNoAccessRestrictions { get => throw null; }
        public bool HasNoVisibilityRestrictions { get => throw null; }
        public bool Hide { set { } }
        public bool InternalOnly { get => throw null; set { } }
        public bool LocalhostOnly { get => throw null; set { } }
        public ServiceStack.RequestAttributes VisibilityTo { get => throw null; set { } }
        public bool VisibleInternalOnly { get => throw null; set { } }
        public bool VisibleLocalhostOnly { get => throw null; set { } }
        public ServiceStack.RequestAttributes[] VisibleToAny { get => throw null; }
    }
    public static partial class RestrictExtensions
    {
        public static bool HasAnyRestrictionsOf(ServiceStack.RequestAttributes allRestrictions, ServiceStack.RequestAttributes restrictions) => throw null;
        public static ServiceStack.RequestAttributes ToAllowedFlagsSet(this ServiceStack.RequestAttributes restrictTo) => throw null;
    }
    public enum RoundingMode
    {
        Undefined = 0,
        Ceil = 1,
        Floor = 2,
        Expand = 3,
        Trunc = 4,
        HalfCeil = 5,
        HalfFloor = 6,
        HalfExpand = 7,
        HalfTrunc = 8,
        HalfEven = 9,
    }
    [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = true)]
    public class RouteAttribute : ServiceStack.AttributeBase, ServiceStack.IReflectAttributeConverter
    {
        public RouteAttribute(string path) => throw null;
        public RouteAttribute(string path, string verbs) => throw null;
        protected bool Equals(ServiceStack.RouteAttribute other) => throw null;
        public override bool Equals(object obj) => throw null;
        public override int GetHashCode() => throw null;
        public string Matches { get => throw null; set { } }
        public string Notes { get => throw null; set { } }
        public string Path { get => throw null; set { } }
        public int Priority { get => throw null; set { } }
        public string Summary { get => throw null; set { } }
        public ServiceStack.ReflectAttribute ToReflectAttribute() => throw null;
        public string Verbs { get => throw null; set { } }
    }
    public struct ScriptValue : ServiceStack.IScriptValue
    {
        public string Eval { get => throw null; set { } }
        public string Expression { get => throw null; set { } }
        public bool NoCache { get => throw null; set { } }
        public object Value { get => throw null; set { } }
    }
    public abstract class ScriptValueAttribute : ServiceStack.AttributeBase, ServiceStack.IScriptValue
    {
        protected ScriptValueAttribute() => throw null;
        public string Eval { get => throw null; set { } }
        public string Expression { get => throw null; set { } }
        public bool NoCache { get => throw null; set { } }
        public object Value { get => throw null; set { } }
    }
    public enum Security : long
    {
        Secure = 8,
        InSecure = 16,
    }
    public enum SignDisplay
    {
        Undefined = 0,
        Always = 1,
        Auto = 2,
        ExceptZero = 3,
        Negative = 4,
        Never = 5,
    }
    public static class SqlTemplate
    {
        public const string CaseInsensitiveLike = default;
        public const string CaseSensitiveLike = default;
        public const string GreaterThan = default;
        public const string GreaterThanOrEqual = default;
        public const string IsNotNull = default;
        public const string IsNull = default;
        public const string LessThan = default;
        public const string LessThanOrEqual = default;
        public const string NotEqual = default;
    }
    public class StrictModeException : System.ArgumentException
    {
        public string Code { get => throw null; set { } }
        public StrictModeException() => throw null;
        public StrictModeException(string message, string code = default(string)) => throw null;
        public StrictModeException(string message, System.Exception innerException, string code = default(string)) => throw null;
        public StrictModeException(string message, string paramName, string code = default(string)) => throw null;
    }
    public class StringResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public StringResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public string Result { get => throw null; set { } }
    }
    public class StringsResponse : ServiceStack.IHasResponseStatus, ServiceStack.IMeta
    {
        public StringsResponse() => throw null;
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set { } }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set { } }
        public System.Collections.Generic.List<string> Results { get => throw null; set { } }
    }
    public static class SwaggerType
    {
        public const string Array = default;
        public const string Boolean = default;
        public const string Byte = default;
        public const string Date = default;
        public const string Double = default;
        public const string Float = default;
        public const string Int = default;
        public const string Long = default;
        public const string String = default;
    }
    [System.AttributeUsage((System.AttributeTargets)196, AllowMultiple = false)]
    public class SynthesizeAttribute : ServiceStack.AttributeBase
    {
        public SynthesizeAttribute() => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = false)]
    public class TagAttribute : ServiceStack.AttributeBase
    {
        public TagAttribute() => throw null;
        public TagAttribute(string name) => throw null;
        public string Name { get => throw null; set { } }
    }
    public static class TagNames
    {
        public const string Admin = default;
        public const string Auth = default;
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = true, Inherited = false)]
    public class TextInputAttribute : ServiceStack.AttributeBase
    {
        public string[] AllowableValues { get => throw null; set { } }
        public TextInputAttribute() => throw null;
        public TextInputAttribute(string id) => throw null;
        public TextInputAttribute(string id, string type) => throw null;
        public string Help { get => throw null; set { } }
        public string Id { get => throw null; set { } }
        public bool? IsRequired { get => throw null; set { } }
        public string Label { get => throw null; set { } }
        public string Max { get => throw null; set { } }
        public int? MaxLength { get => throw null; set { } }
        public string Min { get => throw null; set { } }
        public int? MinLength { get => throw null; set { } }
        public string Name { get => throw null; set { } }
        public string Pattern { get => throw null; set { } }
        public string Placeholder { get => throw null; set { } }
        public bool? ReadOnly { get => throw null; set { } }
        public string Size { get => throw null; set { } }
        public int? Step { get => throw null; set { } }
        public string Type { get => throw null; set { } }
        public string Value { get => throw null; set { } }
    }
    public enum TimeStyle
    {
        Undefined = 0,
        Full = 1,
        Long = 2,
        Medium = 3,
        Short = 4,
    }
    public enum UnitDisplay
    {
        Undefined = 0,
        Long = 1,
        Short = 2,
        Narrow = 3,
    }
    public class UploadFile
    {
        public string ContentType { get => throw null; set { } }
        public UploadFile(System.IO.Stream stream) => throw null;
        public UploadFile(string fileName, System.IO.Stream stream) => throw null;
        public UploadFile(string fileName, System.IO.Stream stream, string fieldName) => throw null;
        public UploadFile(string fileName, System.IO.Stream stream, string fieldName, string contentType) => throw null;
        public string FieldName { get => throw null; set { } }
        public string FileName { get => throw null; set { } }
        public System.IO.Stream Stream { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = false, Inherited = true)]
    public class UploadToAttribute : ServiceStack.AttributeBase
    {
        public UploadToAttribute(string location) => throw null;
        public string Location { get => throw null; set { } }
    }
    [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = true, Inherited = true)]
    public class ValidateAttribute : ServiceStack.AttributeBase, ServiceStack.IReflectAttributeConverter, ServiceStack.IValidateRule
    {
        public string[] AllConditions { get => throw null; set { } }
        public string[] AnyConditions { get => throw null; set { } }
        public static string Combine(string comparand, params string[] conditions) => throw null;
        public string Condition { get => throw null; set { } }
        public ValidateAttribute() => throw null;
        public ValidateAttribute(string validator) => throw null;
        public string ErrorCode { get => throw null; set { } }
        public string Message { get => throw null; set { } }
        public ServiceStack.ReflectAttribute ToReflectAttribute() => throw null;
        public string Validator { get => throw null; set { } }
    }
    public class ValidateCreditCardAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateCreditCardAttribute() => throw null;
    }
    public class ValidateEmailAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateEmailAttribute() => throw null;
    }
    public class ValidateEmptyAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateEmptyAttribute() => throw null;
    }
    public class ValidateEqualAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateEqualAttribute(string value) => throw null;
        public ValidateEqualAttribute(int value) => throw null;
        public ValidateEqualAttribute(bool value) => throw null;
    }
    public class ValidateExactLengthAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateExactLengthAttribute(int length) => throw null;
    }
    public class ValidateExclusiveBetweenAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateExclusiveBetweenAttribute(string from, string to) => throw null;
        public ValidateExclusiveBetweenAttribute(char from, char to) => throw null;
        public ValidateExclusiveBetweenAttribute(int from, int to) => throw null;
    }
    public class ValidateGreaterThanAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateGreaterThanAttribute(int value) => throw null;
    }
    public class ValidateGreaterThanOrEqualAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateGreaterThanOrEqualAttribute(int value) => throw null;
    }
    public class ValidateHasClaimAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateHasClaimAttribute(string type, string value) => throw null;
    }
    public class ValidateHasPermissionAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateHasPermissionAttribute(string permission) => throw null;
    }
    public class ValidateHasRoleAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateHasRoleAttribute(string role) => throw null;
    }
    public class ValidateHasScopeAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateHasScopeAttribute(string scope) => throw null;
    }
    public class ValidateInclusiveBetweenAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateInclusiveBetweenAttribute(string from, string to) => throw null;
        public ValidateInclusiveBetweenAttribute(char from, char to) => throw null;
        public ValidateInclusiveBetweenAttribute(int from, int to) => throw null;
    }
    public class ValidateIsAdminAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateIsAdminAttribute() => throw null;
    }
    public class ValidateIsAuthenticatedAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateIsAuthenticatedAttribute() => throw null;
    }
    public class ValidateLengthAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateLengthAttribute(int min, int max) => throw null;
    }
    public class ValidateLessThanAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateLessThanAttribute(int value) => throw null;
    }
    public class ValidateLessThanOrEqualAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateLessThanOrEqualAttribute(int value) => throw null;
    }
    public class ValidateMaximumLengthAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateMaximumLengthAttribute(int max) => throw null;
    }
    public class ValidateMinimumLengthAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateMinimumLengthAttribute(int min) => throw null;
    }
    public class ValidateNotEmptyAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateNotEmptyAttribute() => throw null;
    }
    public class ValidateNotEqualAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateNotEqualAttribute(string value) => throw null;
        public ValidateNotEqualAttribute(int value) => throw null;
        public ValidateNotEqualAttribute(bool value) => throw null;
    }
    public class ValidateNotNullAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateNotNullAttribute() => throw null;
    }
    public class ValidateNullAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateNullAttribute() => throw null;
    }
    public class ValidateRegularExpressionAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateRegularExpressionAttribute(string pattern) => throw null;
    }
    [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = true, Inherited = true)]
    public class ValidateRequestAttribute : ServiceStack.AttributeBase, ServiceStack.IReflectAttributeConverter, ServiceStack.IValidateRule
    {
        public string[] AllConditions { get => throw null; set { } }
        public string[] AnyConditions { get => throw null; set { } }
        public string Condition { get => throw null; set { } }
        public string[] Conditions { get => throw null; set { } }
        public ValidateRequestAttribute() => throw null;
        public ValidateRequestAttribute(string validator) => throw null;
        public string ErrorCode { get => throw null; set { } }
        public string Message { get => throw null; set { } }
        public int StatusCode { get => throw null; set { } }
        public ServiceStack.ReflectAttribute ToReflectAttribute() => throw null;
        public string Validator { get => throw null; set { } }
    }
    public class ValidateRule : ServiceStack.IValidateRule
    {
        public string Condition { get => throw null; set { } }
        public ValidateRule() => throw null;
        public string ErrorCode { get => throw null; set { } }
        public string Message { get => throw null; set { } }
        public string Validator { get => throw null; set { } }
    }
    public class ValidateScalePrecisionAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateScalePrecisionAttribute(int scale, int precision) => throw null;
    }
    public class ValidationRule : ServiceStack.ValidateRule
    {
        public string CreatedBy { get => throw null; set { } }
        public System.DateTime? CreatedDate { get => throw null; set { } }
        public ValidationRule() => throw null;
        protected bool Equals(ServiceStack.ValidationRule other) => throw null;
        public override bool Equals(object obj) => throw null;
        public string Field { get => throw null; set { } }
        public override int GetHashCode() => throw null;
        public int Id { get => throw null; set { } }
        public string ModifiedBy { get => throw null; set { } }
        public System.DateTime? ModifiedDate { get => throw null; set { } }
        public string Notes { get => throw null; set { } }
        public string SuspendedBy { get => throw null; set { } }
        public System.DateTime? SuspendedDate { get => throw null; set { } }
        public string Type { get => throw null; set { } }
    }
    public enum ValueStyle
    {
        Single = 0,
        Multiple = 1,
        List = 2,
    }
    namespace Web
    {
        public interface IContentTypeReader
        {
            object DeserializeFromStream(string contentType, System.Type type, System.IO.Stream requestStream);
            object DeserializeFromString(string contentType, System.Type type, string request);
            ServiceStack.Web.StreamDeserializerDelegate GetStreamDeserializer(string contentType);
            ServiceStack.Web.StreamDeserializerDelegateAsync GetStreamDeserializerAsync(string contentType);
        }
        public interface IContentTypes : ServiceStack.Web.IContentTypeReader, ServiceStack.Web.IContentTypeWriter
        {
            System.Collections.Generic.Dictionary<string, string> ContentTypeFormats { get; }
            string GetFormatContentType(string format);
            void Register(string contentType, ServiceStack.Web.StreamSerializerDelegate streamSerializer, ServiceStack.Web.StreamDeserializerDelegate streamDeserializer);
            void RegisterAsync(string contentType, ServiceStack.Web.StreamSerializerDelegateAsync responseSerializer, ServiceStack.Web.StreamDeserializerDelegateAsync streamDeserializer);
            void Remove(string contentType);
        }
        public interface IContentTypeWriter
        {
            ServiceStack.Web.StreamSerializerDelegateAsync GetStreamSerializerAsync(string contentType);
            byte[] SerializeToBytes(ServiceStack.Web.IRequest req, object response);
            System.Threading.Tasks.Task SerializeToStreamAsync(ServiceStack.Web.IRequest requestContext, object response, System.IO.Stream toStream);
            string SerializeToString(ServiceStack.Web.IRequest req, object response);
            string SerializeToString(ServiceStack.Web.IRequest req, object response, string contentType);
        }
        public interface IConvertRequest
        {
            T Convert<T>(T value);
        }
        public interface ICookies
        {
            void AddPermanentCookie(string cookieName, string cookieValue, bool? secureOnly = default(bool?));
            void AddSessionCookie(string cookieName, string cookieValue, bool? secureOnly = default(bool?));
            System.Collections.Generic.List<System.Net.Cookie> Collection { get; }
            void DeleteCookie(string cookieName);
        }
        public interface IExpirable
        {
            System.DateTime? LastModified { get; }
        }
        public interface IHasHeaders
        {
            System.Collections.Generic.Dictionary<string, string> Headers { get; }
        }
        public interface IHasOptions
        {
            System.Collections.Generic.IDictionary<string, string> Options { get; }
        }
        public interface IHasRequestFilter : ServiceStack.Web.IRequestFilterBase
        {
            void RequestFilter(ServiceStack.Web.IRequest req, ServiceStack.Web.IResponse res, object requestDto);
        }
        public interface IHasRequestFilterAsync : ServiceStack.Web.IRequestFilterBase
        {
            System.Threading.Tasks.Task RequestFilterAsync(ServiceStack.Web.IRequest req, ServiceStack.Web.IResponse res, object requestDto);
        }
        public interface IHasResponseFilter : ServiceStack.Web.IResponseFilterBase
        {
            void ResponseFilter(ServiceStack.Web.IRequest req, ServiceStack.Web.IResponse res, object response);
        }
        public interface IHasResponseFilterAsync : ServiceStack.Web.IResponseFilterBase
        {
            System.Threading.Tasks.Task ResponseFilterAsync(ServiceStack.Web.IRequest req, ServiceStack.Web.IResponse res, object response);
        }
        public interface IHttpError : ServiceStack.Web.IHasOptions, ServiceStack.Web.IHttpResult
        {
            string ErrorCode { get; }
            string Message { get; }
            string StackTrace { get; }
        }
        public interface IHttpFile
        {
            long ContentLength { get; }
            string ContentType { get; }
            string FileName { get; }
            System.IO.Stream InputStream { get; }
            string Name { get; }
        }
        public interface IHttpRequest : ServiceStack.Web.IRequest, ServiceStack.Configuration.IResolver
        {
            string Accept { get; }
            string HttpMethod { get; }
            ServiceStack.Web.IHttpResponse HttpResponse { get; }
            string XForwardedFor { get; }
            int? XForwardedPort { get; }
            string XForwardedProtocol { get; }
            string XRealIp { get; }
        }
        public interface IHttpResponse : ServiceStack.Web.IResponse
        {
            void ClearCookies();
            ServiceStack.Web.ICookies Cookies { get; }
            void SetCookie(System.Net.Cookie cookie);
        }
        public interface IHttpResult : ServiceStack.Web.IHasOptions
        {
            string ContentType { get; set; }
            System.Collections.Generic.List<System.Net.Cookie> Cookies { get; }
            System.Collections.Generic.Dictionary<string, string> Headers { get; }
            int PaddingLength { get; set; }
            ServiceStack.Web.IRequest RequestContext { get; set; }
            object Response { get; set; }
            ServiceStack.Web.IContentTypeWriter ResponseFilter { get; set; }
            System.Func<System.IDisposable> ResultScope { get; set; }
            int Status { get; set; }
            System.Net.HttpStatusCode StatusCode { get; set; }
            string StatusDescription { get; set; }
        }
        public interface IPartialWriter
        {
            bool IsPartialRequest { get; }
            void WritePartialTo(ServiceStack.Web.IResponse response);
        }
        public interface IPartialWriterAsync
        {
            bool IsPartialRequest { get; }
            System.Threading.Tasks.Task WritePartialToAsync(ServiceStack.Web.IResponse response, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public interface IRequest : ServiceStack.Configuration.IResolver
        {
            string AbsoluteUri { get; }
            string[] AcceptTypes { get; }
            string Authorization { get; }
            long ContentLength { get; }
            string ContentType { get; }
            System.Collections.Generic.IDictionary<string, System.Net.Cookie> Cookies { get; }
            object Dto { get; set; }
            ServiceStack.Web.IHttpFile[] Files { get; }
            System.Collections.Specialized.NameValueCollection FormData { get; }
            string GetRawBody();
            System.Threading.Tasks.Task<string> GetRawBodyAsync();
            bool HasExplicitResponseContentType { get; }
            System.Collections.Specialized.NameValueCollection Headers { get; }
            System.IO.Stream InputStream { get; }
            bool IsLocal { get; }
            bool IsSecureConnection { get; }
            System.Collections.Generic.Dictionary<string, object> Items { get; }
            string OperationName { get; set; }
            string OriginalPathInfo { get; }
            object OriginalRequest { get; }
            string PathInfo { get; }
            System.Collections.Specialized.NameValueCollection QueryString { get; }
            string RawUrl { get; }
            string RemoteIp { get; }
            ServiceStack.RequestAttributes RequestAttributes { get; set; }
            ServiceStack.Web.IRequestPreferences RequestPreferences { get; }
            ServiceStack.Web.IResponse Response { get; }
            string ResponseContentType { get; set; }
            System.Uri UrlReferrer { get; }
            bool UseBufferedStream { get; set; }
            string UserAgent { get; }
            string UserHostAddress { get; }
            string Verb { get; }
        }
        public interface IRequestFilterBase
        {
            ServiceStack.Web.IRequestFilterBase Copy();
            int Priority { get; }
        }
        public interface IRequestLogger
        {
            System.Func<System.DateTime> CurrentDateFn { get; set; }
            bool EnableErrorTracking { get; set; }
            bool EnableRequestBodyTracking { get; set; }
            bool EnableResponseTracking { get; set; }
            bool EnableSessionTracking { get; set; }
            System.Type[] ExcludeRequestDtoTypes { get; set; }
            System.Type[] ExcludeResponseTypes { get; set; }
            System.Collections.Generic.List<ServiceStack.RequestLogEntry> GetLatestLogs(int? take);
            System.Type[] HideRequestBodyForRequestDtoTypes { get; set; }
            System.Func<object, bool> IgnoreFilter { get; set; }
            bool LimitToServiceRequests { get; set; }
            void Log(ServiceStack.Web.IRequest request, object requestDto, object response, System.TimeSpan elapsed);
            System.Func<ServiceStack.Web.IRequest, bool> RequestBodyTrackingFilter { get; set; }
            System.Action<ServiceStack.Web.IRequest, ServiceStack.RequestLogEntry> RequestLogFilter { get; set; }
            string[] RequiredRoles { get; set; }
            System.Func<ServiceStack.Web.IRequest, bool> ResponseTrackingFilter { get; set; }
            System.Func<ServiceStack.Web.IRequest, bool> SkipLogging { get; set; }
        }
        public interface IRequestPreferences
        {
            bool AcceptsBrotli { get; }
            bool AcceptsDeflate { get; }
            bool AcceptsGzip { get; }
        }
        public interface IRequiresRequest
        {
            ServiceStack.Web.IRequest Request { get; set; }
        }
        public interface IRequiresRequestStream
        {
            System.IO.Stream RequestStream { get; set; }
        }
        public interface IResponse
        {
            void AddHeader(string name, string value);
            void Close();
            System.Threading.Tasks.Task CloseAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            string ContentType { get; set; }
            object Dto { get; set; }
            void End();
            void Flush();
            System.Threading.Tasks.Task FlushAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            string GetHeader(string name);
            bool HasStarted { get; }
            bool IsClosed { get; }
            System.Collections.Generic.Dictionary<string, object> Items { get; }
            bool KeepAlive { get; set; }
            object OriginalResponse { get; }
            System.IO.Stream OutputStream { get; }
            void Redirect(string url);
            void RemoveHeader(string name);
            ServiceStack.Web.IRequest Request { get; }
            void SetContentLength(long contentLength);
            int StatusCode { get; set; }
            string StatusDescription { get; set; }
            bool UseBufferedStream { get; set; }
        }
        public interface IResponseFilterBase
        {
            ServiceStack.Web.IResponseFilterBase Copy();
            int Priority { get; }
        }
        public interface IRestPath
        {
            object CreateRequest(string pathInfo, System.Collections.Generic.Dictionary<string, string> queryStringAndFormData, object fromInstance);
            bool IsWildCardPath { get; }
            System.Type RequestType { get; }
        }
        public interface IServiceController : ServiceStack.Web.IServiceExecutor
        {
            object Execute(object requestDto, ServiceStack.Web.IRequest request);
            object Execute(object requestDto, ServiceStack.Web.IRequest request, bool applyFilters);
            object Execute(object requestDto);
            object Execute(ServiceStack.Web.IRequest request, bool applyFilters);
            object ExecuteMessage(ServiceStack.Messaging.IMessage mqMessage);
            object ExecuteMessage(ServiceStack.Messaging.IMessage dto, ServiceStack.Web.IRequest request);
            System.Threading.Tasks.Task<object> GatewayExecuteAsync(object requestDto, ServiceStack.Web.IRequest req, bool applyFilters);
            ServiceStack.Web.IRestPath GetRestPathForRequest(string httpMethod, string pathInfo);
        }
        public interface IServiceExecutor
        {
            System.Threading.Tasks.Task<object> ExecuteAsync(object requestDto, ServiceStack.Web.IRequest request);
        }
        public interface IServiceGatewayFactory
        {
            ServiceStack.IServiceGateway GetServiceGateway(ServiceStack.Web.IRequest request);
        }
        public interface IServiceRoutes
        {
            ServiceStack.Web.IServiceRoutes Add<TRequest>(string restPath);
            ServiceStack.Web.IServiceRoutes Add<TRequest>(string restPath, string verbs);
            ServiceStack.Web.IServiceRoutes Add(System.Type requestType, string restPath, string verbs);
            ServiceStack.Web.IServiceRoutes Add(System.Type requestType, string restPath, string verbs, int priority);
            ServiceStack.Web.IServiceRoutes Add(System.Type requestType, string restPath, string verbs, string summary, string notes);
            ServiceStack.Web.IServiceRoutes Add(System.Type requestType, string restPath, string verbs, string summary, string notes, string matches);
        }
        public interface IServiceRunner
        {
            object Process(ServiceStack.Web.IRequest requestContext, object instance, object request);
        }
        public interface IServiceRunner<TRequest> : ServiceStack.Web.IServiceRunner
        {
            object Execute(ServiceStack.Web.IRequest req, object instance, ServiceStack.Messaging.IMessage<TRequest> request);
            System.Threading.Tasks.Task<object> ExecuteAsync(ServiceStack.Web.IRequest req, object instance, TRequest requestDto);
            object ExecuteOneWay(ServiceStack.Web.IRequest req, object instance, TRequest requestDto);
            System.Threading.Tasks.Task<object> HandleExceptionAsync(ServiceStack.Web.IRequest req, TRequest requestDto, System.Exception ex, object instance);
            object OnAfterExecute(ServiceStack.Web.IRequest req, object response, object service);
            void OnBeforeExecute(ServiceStack.Web.IRequest req, TRequest request, object service);
        }
        public interface IStreamWriter
        {
            void WriteTo(System.IO.Stream responseStream);
        }
        public interface IStreamWriterAsync
        {
            System.Threading.Tasks.Task WriteToAsync(System.IO.Stream responseStream, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }
        public delegate object StreamDeserializerDelegate(System.Type type, System.IO.Stream fromStream);
        public delegate System.Threading.Tasks.Task<object> StreamDeserializerDelegateAsync(System.Type type, System.IO.Stream fromStream);
        public delegate void StreamSerializerDelegate(ServiceStack.Web.IRequest req, object dto, System.IO.Stream outputStream);
        public delegate System.Threading.Tasks.Task StreamSerializerDelegateAsync(ServiceStack.Web.IRequest req, object dto, System.IO.Stream outputStream);
        public delegate object StringDeserializerDelegate(string contents, System.Type type);
        public delegate string StringSerializerDelegate(ServiceStack.Web.IRequest req, object dto);
        public delegate object TextDeserializerDelegate(System.Type type, string dto);
        public delegate string TextSerializerDelegate(object dto);
    }
}
