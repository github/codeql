// This file contains auto-generated code.

namespace ServiceStack
{
    // Generated from `ServiceStack.ApiAllowableValuesAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ApiAllowableValuesAttribute : ServiceStack.AttributeBase
    {
        public ApiAllowableValuesAttribute(string[] values) => throw null;
        public ApiAllowableValuesAttribute(string name, params string[] values) => throw null;
        public ApiAllowableValuesAttribute(string name, int min, int max) => throw null;
        public ApiAllowableValuesAttribute(string name, System.Type enumType) => throw null;
        public ApiAllowableValuesAttribute(string name, System.Func<string[]> listAction) => throw null;
        public ApiAllowableValuesAttribute(string name) => throw null;
        public ApiAllowableValuesAttribute(int min, int max) => throw null;
        public ApiAllowableValuesAttribute(System.Type enumType) => throw null;
        public ApiAllowableValuesAttribute(System.Func<string[]> listAction) => throw null;
        public ApiAllowableValuesAttribute() => throw null;
        public int? Max { get => throw null; set => throw null; }
        public int? Min { get => throw null; set => throw null; }
        public string Name { get => throw null; set => throw null; }
        public string Type { get => throw null; set => throw null; }
        public string[] Values { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ApiAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ApiAttribute : ServiceStack.AttributeBase
    {
        public ApiAttribute(string description, int generateBodyParameter, bool isRequired) => throw null;
        public ApiAttribute(string description, int generateBodyParameter) => throw null;
        public ApiAttribute(string description) => throw null;
        public ApiAttribute() => throw null;
        public int BodyParameter { get => throw null; set => throw null; }
        public string Description { get => throw null; set => throw null; }
        public bool IsRequired { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ApiMemberAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ApiMemberAttribute : ServiceStack.AttributeBase
    {
        public bool AllowMultiple { get => throw null; set => throw null; }
        public ApiMemberAttribute() => throw null;
        public string DataType { get => throw null; set => throw null; }
        public string Description { get => throw null; set => throw null; }
        public bool ExcludeInSchema { get => throw null; set => throw null; }
        public string Format { get => throw null; set => throw null; }
        public bool IsRequired { get => throw null; set => throw null; }
        public string Name { get => throw null; set => throw null; }
        public string ParameterType { get => throw null; set => throw null; }
        public string Route { get => throw null; set => throw null; }
        public string Verb { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ApiResponseAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ApiResponseAttribute : ServiceStack.AttributeBase, ServiceStack.IApiResponseDescription
    {
        public ApiResponseAttribute(int statusCode, string description) => throw null;
        public ApiResponseAttribute(System.Net.HttpStatusCode statusCode, string description) => throw null;
        public ApiResponseAttribute() => throw null;
        public string Description { get => throw null; set => throw null; }
        public bool IsDefaultResponse { get => throw null; set => throw null; }
        public System.Type ResponseType { get => throw null; set => throw null; }
        public int StatusCode { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ApplyTo` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    [System.Flags]
    public enum ApplyTo
    {
        Acl,
        All,
        BaseLineControl,
        CheckIn,
        CheckOut,
        Connect,
        Copy,
        Delete,
        Get,
        Head,
        Label,
        Lock,
        Merge,
        MkActivity,
        MkCol,
        MkWorkSpace,
        Move,
        None,
        Options,
        OrderPatch,
        Patch,
        Post,
        PropFind,
        PropPatch,
        Put,
        Report,
        Search,
        Trace,
        UnCheckOut,
        UnLock,
        Update,
        VersionControl,
    }

    // Generated from `ServiceStack.ArrayOfGuid` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ArrayOfGuid : System.Collections.Generic.List<System.Guid>
    {
        public ArrayOfGuid(params System.Guid[] args) => throw null;
        public ArrayOfGuid(System.Collections.Generic.IEnumerable<System.Guid> collection) => throw null;
        public ArrayOfGuid() => throw null;
    }

    // Generated from `ServiceStack.ArrayOfGuidId` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ArrayOfGuidId : System.Collections.Generic.List<System.Guid>
    {
        public ArrayOfGuidId(params System.Guid[] args) => throw null;
        public ArrayOfGuidId(System.Collections.Generic.IEnumerable<System.Guid> collection) => throw null;
        public ArrayOfGuidId() => throw null;
    }

    // Generated from `ServiceStack.ArrayOfInt` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ArrayOfInt : System.Collections.Generic.List<int>
    {
        public ArrayOfInt(params int[] args) => throw null;
        public ArrayOfInt(System.Collections.Generic.IEnumerable<int> collection) => throw null;
        public ArrayOfInt() => throw null;
    }

    // Generated from `ServiceStack.ArrayOfIntId` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ArrayOfIntId : System.Collections.Generic.List<int>
    {
        public ArrayOfIntId(params int[] args) => throw null;
        public ArrayOfIntId(System.Collections.Generic.IEnumerable<int> collection) => throw null;
        public ArrayOfIntId() => throw null;
    }

    // Generated from `ServiceStack.ArrayOfLong` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ArrayOfLong : System.Collections.Generic.List<System.Int64>
    {
        public ArrayOfLong(params System.Int64[] args) => throw null;
        public ArrayOfLong(System.Collections.Generic.IEnumerable<System.Int64> collection) => throw null;
        public ArrayOfLong() => throw null;
    }

    // Generated from `ServiceStack.ArrayOfLongId` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ArrayOfLongId : System.Collections.Generic.List<System.Int64>
    {
        public ArrayOfLongId(params System.Int64[] args) => throw null;
        public ArrayOfLongId(System.Collections.Generic.IEnumerable<System.Int64> collection) => throw null;
        public ArrayOfLongId() => throw null;
    }

    // Generated from `ServiceStack.ArrayOfString` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ArrayOfString : System.Collections.Generic.List<string>
    {
        public ArrayOfString(params string[] args) => throw null;
        public ArrayOfString(System.Collections.Generic.IEnumerable<string> collection) => throw null;
        public ArrayOfString() => throw null;
    }

    // Generated from `ServiceStack.ArrayOfStringId` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ArrayOfStringId : System.Collections.Generic.List<string>
    {
        public ArrayOfStringId(params string[] args) => throw null;
        public ArrayOfStringId(System.Collections.Generic.IEnumerable<string> collection) => throw null;
        public ArrayOfStringId() => throw null;
    }

    // Generated from `ServiceStack.AttributeBase` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AttributeBase : System.Attribute
    {
        public AttributeBase() => throw null;
        protected System.Guid typeId;
    }

    // Generated from `ServiceStack.AuditBase` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class AuditBase
    {
        protected AuditBase() => throw null;
        public string CreatedBy { get => throw null; set => throw null; }
        public System.DateTime CreatedDate { get => throw null; set => throw null; }
        public string DeletedBy { get => throw null; set => throw null; }
        public System.DateTime? DeletedDate { get => throw null; set => throw null; }
        public string ModifiedBy { get => throw null; set => throw null; }
        public System.DateTime ModifiedDate { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.AutoApplyAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AutoApplyAttribute : ServiceStack.AttributeBase
    {
        public string[] Args { get => throw null; }
        public AutoApplyAttribute(string name, params string[] args) => throw null;
        public string Name { get => throw null; }
    }

    // Generated from `ServiceStack.AutoDefaultAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AutoDefaultAttribute : ServiceStack.ScriptValueAttribute
    {
        public AutoDefaultAttribute() => throw null;
    }

    // Generated from `ServiceStack.AutoFilterAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AutoFilterAttribute : ServiceStack.ScriptValueAttribute
    {
        public AutoFilterAttribute(string field, string template) => throw null;
        public AutoFilterAttribute(string field) => throw null;
        public AutoFilterAttribute(ServiceStack.QueryTerm term, string field, string template) => throw null;
        public AutoFilterAttribute(ServiceStack.QueryTerm term, string field) => throw null;
        public string Field { get => throw null; set => throw null; }
        public string Operand { get => throw null; set => throw null; }
        public string Template { get => throw null; set => throw null; }
        public ServiceStack.QueryTerm Term { get => throw null; set => throw null; }
        public string ValueFormat { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.AutoIgnoreAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AutoIgnoreAttribute : ServiceStack.AttributeBase
    {
        public AutoIgnoreAttribute() => throw null;
    }

    // Generated from `ServiceStack.AutoMapAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AutoMapAttribute : ServiceStack.AttributeBase
    {
        public AutoMapAttribute(string to) => throw null;
        public string To { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.AutoPopulateAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AutoPopulateAttribute : ServiceStack.ScriptValueAttribute
    {
        public AutoPopulateAttribute(string field) => throw null;
        public string Field { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.AutoQueryViewerAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AutoQueryViewerAttribute : ServiceStack.AttributeBase
    {
        public AutoQueryViewerAttribute() => throw null;
        public string BackgroundColor { get => throw null; set => throw null; }
        public string BackgroundImageUrl { get => throw null; set => throw null; }
        public string BrandImageUrl { get => throw null; set => throw null; }
        public string BrandUrl { get => throw null; set => throw null; }
        public string DefaultFields { get => throw null; set => throw null; }
        public string DefaultSearchField { get => throw null; set => throw null; }
        public string DefaultSearchText { get => throw null; set => throw null; }
        public string DefaultSearchType { get => throw null; set => throw null; }
        public string Description { get => throw null; set => throw null; }
        public string IconUrl { get => throw null; set => throw null; }
        public string LinkColor { get => throw null; set => throw null; }
        public string Name { get => throw null; set => throw null; }
        public string TextColor { get => throw null; set => throw null; }
        public string Title { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.AutoQueryViewerFieldAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AutoQueryViewerFieldAttribute : ServiceStack.AttributeBase
    {
        public AutoQueryViewerFieldAttribute() => throw null;
        public string Description { get => throw null; set => throw null; }
        public bool HideInSummary { get => throw null; set => throw null; }
        public string LayoutHint { get => throw null; set => throw null; }
        public string Title { get => throw null; set => throw null; }
        public string ValueFormat { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.AutoUpdateAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class AutoUpdateAttribute : ServiceStack.AttributeBase
    {
        public AutoUpdateAttribute(ServiceStack.AutoUpdateStyle style) => throw null;
        public ServiceStack.AutoUpdateStyle Style { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.AutoUpdateStyle` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum AutoUpdateStyle
    {
        Always,
        NonDefaults,
    }

    // Generated from `ServiceStack.Behavior` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class Behavior
    {
        public const string AuditCreate = default;
        public const string AuditDelete = default;
        public const string AuditModify = default;
        public const string AuditQuery = default;
        public const string AuditSoftDelete = default;
    }

    // Generated from `ServiceStack.CallStyle` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum CallStyle
    {
        OneWay,
        Reply,
    }

    // Generated from `ServiceStack.EmitCSharp` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmitCSharp : ServiceStack.EmitCodeAttribute
    {
        public EmitCSharp(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }

    // Generated from `ServiceStack.EmitCodeAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmitCodeAttribute : ServiceStack.AttributeBase
    {
        public EmitCodeAttribute(ServiceStack.Lang lang, string[] statements) => throw null;
        public EmitCodeAttribute(ServiceStack.Lang lang, string statement) => throw null;
        public ServiceStack.Lang Lang { get => throw null; set => throw null; }
        public string[] Statements { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.EmitDart` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmitDart : ServiceStack.EmitCodeAttribute
    {
        public EmitDart(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }

    // Generated from `ServiceStack.EmitFSharp` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmitFSharp : ServiceStack.EmitCodeAttribute
    {
        public EmitFSharp(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }

    // Generated from `ServiceStack.EmitJava` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmitJava : ServiceStack.EmitCodeAttribute
    {
        public EmitJava(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }

    // Generated from `ServiceStack.EmitKotlin` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmitKotlin : ServiceStack.EmitCodeAttribute
    {
        public EmitKotlin(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }

    // Generated from `ServiceStack.EmitSwift` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmitSwift : ServiceStack.EmitCodeAttribute
    {
        public EmitSwift(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }

    // Generated from `ServiceStack.EmitTypeScript` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmitTypeScript : ServiceStack.EmitCodeAttribute
    {
        public EmitTypeScript(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }

    // Generated from `ServiceStack.EmitVb` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmitVb : ServiceStack.EmitCodeAttribute
    {
        public EmitVb(params string[] statements) : base(default(ServiceStack.Lang), default(string)) => throw null;
    }

    // Generated from `ServiceStack.EmptyResponse` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class EmptyResponse : ServiceStack.IHasResponseStatus
    {
        public EmptyResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.Endpoint` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum Endpoint
    {
        Http,
        Mq,
        Other,
        Tcp,
    }

    // Generated from `ServiceStack.ErrorResponse` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ErrorResponse : ServiceStack.IHasResponseStatus
    {
        public ErrorResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.FallbackRouteAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class FallbackRouteAttribute : ServiceStack.RouteAttribute
    {
        public FallbackRouteAttribute(string path, string verbs) : base(default(string)) => throw null;
        public FallbackRouteAttribute(string path) : base(default(string)) => throw null;
    }

    // Generated from `ServiceStack.Feature` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    [System.Flags]
    public enum Feature
    {
        All,
        Csv,
        CustomFormat,
        Grpc,
        Html,
        Json,
        Jsv,
        Markdown,
        Metadata,
        MsgPack,
        None,
        PredefinedRoutes,
        ProtoBuf,
        Razor,
        RequestInfo,
        ServiceDiscovery,
        Soap,
        Soap11,
        Soap12,
        Wire,
        Xml,
    }

    // Generated from `ServiceStack.Format` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum Format
    {
        Csv,
        Html,
        Json,
        Jsv,
        MsgPack,
        Other,
        ProtoBuf,
        Soap11,
        Soap12,
        Wire,
        Xml,
    }

    // Generated from `ServiceStack.GenerateBodyParameter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class GenerateBodyParameter
    {
        public const int Always = default;
        public const int IfNotDisabled = default;
        public const int Never = default;
    }

    // Generated from `ServiceStack.Http` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum Http
    {
        Delete,
        Get,
        Head,
        Options,
        Other,
        Patch,
        Post,
        Put,
    }

    // Generated from `ServiceStack.IAny<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IAny<T>
    {
        object Any(T request);
    }

    // Generated from `ServiceStack.IAnyVoid<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IAnyVoid<T>
    {
        void Any(T request);
    }

    // Generated from `ServiceStack.IApiResponseDescription` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IApiResponseDescription
    {
        string Description { get; }
        int StatusCode { get; }
    }

    // Generated from `ServiceStack.ICompressor` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ICompressor
    {
        string Compress(string source);
    }

    // Generated from `ServiceStack.IContainer` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IContainer
    {
        ServiceStack.IContainer AddSingleton(System.Type type, System.Func<object> factory);
        ServiceStack.IContainer AddTransient(System.Type type, System.Func<object> factory);
        System.Func<object> CreateFactory(System.Type type);
        bool Exists(System.Type type);
        object Resolve(System.Type type);
    }

    // Generated from `ServiceStack.ICreateDb<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ICreateDb<Table> : ServiceStack.ICrud
    {
    }

    // Generated from `ServiceStack.ICrud` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ICrud
    {
    }

    // Generated from `ServiceStack.IDelete` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IDelete : ServiceStack.IVerb
    {
    }

    // Generated from `ServiceStack.IDelete<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IDelete<T>
    {
        object Delete(T request);
    }

    // Generated from `ServiceStack.IDeleteDb<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IDeleteDb<Table> : ServiceStack.ICrud
    {
    }

    // Generated from `ServiceStack.IDeleteVoid<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IDeleteVoid<T>
    {
        void Delete(T request);
    }

    // Generated from `ServiceStack.IEncryptedClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IEncryptedClient : ServiceStack.IServiceGateway, ServiceStack.IReplyClient, ServiceStack.IHasVersion, ServiceStack.IHasSessionId, ServiceStack.IHasBearerToken
    {
        ServiceStack.IJsonServiceClient Client { get; }
        TResponse Send<TResponse>(string httpMethod, object request);
        TResponse Send<TResponse>(string httpMethod, ServiceStack.IReturn<TResponse> request);
        string ServerPublicKeyXml { get; }
    }

    // Generated from `ServiceStack.IGet` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IGet : ServiceStack.IVerb
    {
    }

    // Generated from `ServiceStack.IGet<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IGet<T>
    {
        object Get(T request);
    }

    // Generated from `ServiceStack.IGetVoid<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IGetVoid<T>
    {
        void Get(T request);
    }

    // Generated from `ServiceStack.IHasBearerToken` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHasBearerToken
    {
        string BearerToken { get; set; }
    }

    // Generated from `ServiceStack.IHasErrorCode` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHasErrorCode
    {
        string ErrorCode { get; }
    }

    // Generated from `ServiceStack.IHasResponseStatus` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHasResponseStatus
    {
        ServiceStack.ResponseStatus ResponseStatus { get; set; }
    }

    // Generated from `ServiceStack.IHasSessionId` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHasSessionId
    {
        string SessionId { get; set; }
    }

    // Generated from `ServiceStack.IHasVersion` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHasVersion
    {
        int Version { get; set; }
    }

    // Generated from `ServiceStack.IHtmlString` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHtmlString
    {
        string ToHtmlString();
    }

    // Generated from `ServiceStack.IHttpRestClientAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IHttpRestClientAsync : System.IDisposable, ServiceStack.IServiceClientCommon, ServiceStack.IRestClientAsync
    {
        System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(string relativeOrAbsoluteUrl, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(string relativeOrAbsoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(string httpMethod, string absoluteUrl, object request, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }

    // Generated from `ServiceStack.IJoin` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IJoin
    {
    }

    // Generated from `ServiceStack.IJoin<,,,,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IJoin<Source, Join1, Join2, Join3, Join4> : ServiceStack.IJoin
    {
    }

    // Generated from `ServiceStack.IJoin<,,,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IJoin<Source, Join1, Join2, Join3> : ServiceStack.IJoin
    {
    }

    // Generated from `ServiceStack.IJoin<,,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IJoin<Source, Join1, Join2> : ServiceStack.IJoin
    {
    }

    // Generated from `ServiceStack.IJoin<,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IJoin<Source, Join1> : ServiceStack.IJoin
    {
    }

    // Generated from `ServiceStack.IJsonServiceClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IJsonServiceClient : System.IDisposable, ServiceStack.IServiceGatewayAsync, ServiceStack.IServiceGateway, ServiceStack.IServiceClientSync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientAsync, ServiceStack.IServiceClient, ServiceStack.IRestServiceClient, ServiceStack.IRestClientSync, ServiceStack.IRestClientAsync, ServiceStack.IRestClient, ServiceStack.IReplyClient, ServiceStack.IOneWayClient, ServiceStack.IHttpRestClientAsync, ServiceStack.IHasVersion, ServiceStack.IHasSessionId, ServiceStack.IHasBearerToken
    {
    }

    // Generated from `ServiceStack.ILeftJoin<,,,,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ILeftJoin<Source, Join1, Join2, Join3, Join4> : ServiceStack.IJoin
    {
    }

    // Generated from `ServiceStack.ILeftJoin<,,,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ILeftJoin<Source, Join1, Join2, Join3> : ServiceStack.IJoin
    {
    }

    // Generated from `ServiceStack.ILeftJoin<,,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ILeftJoin<Source, Join1, Join2> : ServiceStack.IJoin
    {
    }

    // Generated from `ServiceStack.ILeftJoin<,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ILeftJoin<Source, Join1> : ServiceStack.IJoin
    {
    }

    // Generated from `ServiceStack.IMeta` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IMeta
    {
        System.Collections.Generic.Dictionary<string, string> Meta { get; set; }
    }

    // Generated from `ServiceStack.IOneWayClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IOneWayClient
    {
        void SendAllOneWay(System.Collections.Generic.IEnumerable<object> requests);
        void SendOneWay(string relativeOrAbsoluteUri, object requestDto);
        void SendOneWay(object requestDto);
    }

    // Generated from `ServiceStack.IOptions` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IOptions : ServiceStack.IVerb
    {
    }

    // Generated from `ServiceStack.IOptions<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IOptions<T>
    {
        object Options(T request);
    }

    // Generated from `ServiceStack.IOptionsVoid<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IOptionsVoid<T>
    {
        void Options(T request);
    }

    // Generated from `ServiceStack.IPatch` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPatch : ServiceStack.IVerb
    {
    }

    // Generated from `ServiceStack.IPatch<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPatch<T>
    {
        object Patch(T request);
    }

    // Generated from `ServiceStack.IPatchDb<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPatchDb<Table> : ServiceStack.ICrud
    {
    }

    // Generated from `ServiceStack.IPatchVoid<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPatchVoid<T>
    {
        void Patch(T request);
    }

    // Generated from `ServiceStack.IPost` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPost : ServiceStack.IVerb
    {
    }

    // Generated from `ServiceStack.IPost<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPost<T>
    {
        object Post(T request);
    }

    // Generated from `ServiceStack.IPostVoid<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPostVoid<T>
    {
        void Post(T request);
    }

    // Generated from `ServiceStack.IPut` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPut : ServiceStack.IVerb
    {
    }

    // Generated from `ServiceStack.IPut<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPut<T>
    {
        object Put(T request);
    }

    // Generated from `ServiceStack.IPutVoid<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IPutVoid<T>
    {
        void Put(T request);
    }

    // Generated from `ServiceStack.IQuery` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IQuery : ServiceStack.IMeta
    {
        string Fields { get; set; }
        string Include { get; set; }
        string OrderBy { get; set; }
        string OrderByDesc { get; set; }
        int? Skip { get; set; }
        int? Take { get; set; }
    }

    // Generated from `ServiceStack.IQueryData` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IQueryData : ServiceStack.IQuery, ServiceStack.IMeta
    {
    }

    // Generated from `ServiceStack.IQueryData<,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IQueryData<From, Into> : ServiceStack.IQueryData, ServiceStack.IQuery, ServiceStack.IMeta
    {
    }

    // Generated from `ServiceStack.IQueryData<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IQueryData<From> : ServiceStack.IQueryData, ServiceStack.IQuery, ServiceStack.IMeta
    {
    }

    // Generated from `ServiceStack.IQueryDb` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IQueryDb : ServiceStack.IQuery, ServiceStack.IMeta
    {
    }

    // Generated from `ServiceStack.IQueryDb<,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IQueryDb<From, Into> : ServiceStack.IQueryDb, ServiceStack.IQuery, ServiceStack.IMeta
    {
    }

    // Generated from `ServiceStack.IQueryDb<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IQueryDb<From> : ServiceStack.IQueryDb, ServiceStack.IQuery, ServiceStack.IMeta
    {
    }

    // Generated from `ServiceStack.IQueryResponse` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IQueryResponse : ServiceStack.IMeta, ServiceStack.IHasResponseStatus
    {
        int Offset { get; set; }
        int Total { get; set; }
    }

    // Generated from `ServiceStack.IRawString` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IRawString
    {
        string ToRawString();
    }

    // Generated from `ServiceStack.IReceiver` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IReceiver
    {
        void NoSuchMethod(string selector, object message);
    }

    // Generated from `ServiceStack.IReflectAttributeConverter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IReflectAttributeConverter
    {
        ServiceStack.ReflectAttribute ToReflectAttribute();
    }

    // Generated from `ServiceStack.IReplyClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IReplyClient : ServiceStack.IServiceGateway
    {
    }

    // Generated from `ServiceStack.IRequiresSchema` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IRequiresSchema
    {
        void InitSchema();
    }

    // Generated from `ServiceStack.IRequiresSchemaAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IRequiresSchemaAsync
    {
        System.Threading.Tasks.Task InitSchemaAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }

    // Generated from `ServiceStack.IResponseStatus` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IResponseStatus
    {
        string ErrorCode { get; set; }
        string ErrorMessage { get; set; }
        bool IsSuccess { get; }
        string StackTrace { get; set; }
    }

    // Generated from `ServiceStack.IRestClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IRestClient : System.IDisposable, ServiceStack.IServiceClientCommon, ServiceStack.IRestClientSync
    {
        void AddHeader(string name, string value);
        void ClearCookies();
        TResponse Delete<TResponse>(string relativeOrAbsoluteUrl);
        TResponse Get<TResponse>(string relativeOrAbsoluteUrl);
        System.Collections.Generic.Dictionary<string, string> GetCookieValues();
        System.Collections.Generic.IEnumerable<TResponse> GetLazy<TResponse>(ServiceStack.IReturn<ServiceStack.QueryResponse<TResponse>> queryDto);
        TResponse Patch<TResponse>(string relativeOrAbsoluteUrl, object requestDto);
        TResponse Post<TResponse>(string relativeOrAbsoluteUrl, object request);
        TResponse PostFile<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, string mimeType);
        TResponse PostFileWithRequest<TResponse>(string relativeOrAbsoluteUrl, System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string));
        TResponse PostFileWithRequest<TResponse>(System.IO.Stream fileToUpload, string fileName, object request, string fieldName = default(string));
        TResponse PostFilesWithRequest<TResponse>(string relativeOrAbsoluteUrl, object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files);
        TResponse PostFilesWithRequest<TResponse>(object request, System.Collections.Generic.IEnumerable<ServiceStack.UploadFile> files);
        TResponse Put<TResponse>(string relativeOrAbsoluteUrl, object requestDto);
        TResponse Send<TResponse>(string httpMethod, string relativeOrAbsoluteUrl, object request);
        void SetCookie(string name, string value, System.TimeSpan? expiresIn = default(System.TimeSpan?));
    }

    // Generated from `ServiceStack.IRestClientAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IRestClientAsync : System.IDisposable, ServiceStack.IServiceClientCommon
    {
        System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> CustomMethodAsync<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task CustomMethodAsync(string httpVerb, ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> DeleteAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task DeleteAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> GetAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task GetAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PatchAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task PatchAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PostAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task PostAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> PutAsync<TResponse>(ServiceStack.IReturn<TResponse> requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task PutAsync(ServiceStack.IReturnVoid requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }

    // Generated from `ServiceStack.IRestClientSync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IRestClientSync : System.IDisposable, ServiceStack.IServiceClientCommon
    {
        void CustomMethod(string httpVerb, ServiceStack.IReturnVoid requestDto);
        TResponse CustomMethod<TResponse>(string httpVerb, object requestDto);
        TResponse CustomMethod<TResponse>(string httpVerb, ServiceStack.IReturn<TResponse> requestDto);
        void Delete(ServiceStack.IReturnVoid requestDto);
        TResponse Delete<TResponse>(object requestDto);
        TResponse Delete<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
        void Get(ServiceStack.IReturnVoid requestDto);
        TResponse Get<TResponse>(object requestDto);
        TResponse Get<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
        void Patch(ServiceStack.IReturnVoid requestDto);
        TResponse Patch<TResponse>(object requestDto);
        TResponse Patch<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
        void Post(ServiceStack.IReturnVoid requestDto);
        TResponse Post<TResponse>(object requestDto);
        TResponse Post<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
        void Put(ServiceStack.IReturnVoid requestDto);
        TResponse Put<TResponse>(object requestDto);
        TResponse Put<TResponse>(ServiceStack.IReturn<TResponse> requestDto);
    }

    // Generated from `ServiceStack.IRestGateway` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IRestGateway
    {
        T Delete<T>(ServiceStack.IReturn<T> request);
        T Get<T>(ServiceStack.IReturn<T> request);
        T Post<T>(ServiceStack.IReturn<T> request);
        T Put<T>(ServiceStack.IReturn<T> request);
        T Send<T>(ServiceStack.IReturn<T> request);
    }

    // Generated from `ServiceStack.IRestGatewayAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IRestGatewayAsync
    {
        System.Threading.Tasks.Task<T> DeleteAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
        System.Threading.Tasks.Task<T> GetAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
        System.Threading.Tasks.Task<T> PostAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
        System.Threading.Tasks.Task<T> PutAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
        System.Threading.Tasks.Task<T> SendAsync<T>(ServiceStack.IReturn<T> request, System.Threading.CancellationToken token);
    }

    // Generated from `ServiceStack.IRestServiceClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IRestServiceClient : System.IDisposable, ServiceStack.IServiceGatewayAsync, ServiceStack.IServiceGateway, ServiceStack.IServiceClientSync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientAsync, ServiceStack.IRestClientSync, ServiceStack.IRestClientAsync, ServiceStack.IHasVersion, ServiceStack.IHasSessionId, ServiceStack.IHasBearerToken
    {
    }

    // Generated from `ServiceStack.IReturn` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IReturn
    {
    }

    // Generated from `ServiceStack.IReturn<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IReturn<T> : ServiceStack.IReturn
    {
    }

    // Generated from `ServiceStack.IReturnVoid` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IReturnVoid : ServiceStack.IReturn
    {
    }

    // Generated from `ServiceStack.ISaveDb<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ISaveDb<Table> : ServiceStack.ICrud
    {
    }

    // Generated from `ServiceStack.IScriptValue` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IScriptValue
    {
        string Eval { get; set; }
        string Expression { get; set; }
        bool NoCache { get; set; }
        object Value { get; set; }
    }

    // Generated from `ServiceStack.ISequenceSource` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ISequenceSource : ServiceStack.IRequiresSchema
    {
        System.Int64 Increment(string key, System.Int64 amount = default(System.Int64));
        void Reset(string key, System.Int64 startingAt = default(System.Int64));
    }

    // Generated from `ServiceStack.ISequenceSourceAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface ISequenceSourceAsync : ServiceStack.IRequiresSchema
    {
        System.Threading.Tasks.Task<System.Int64> IncrementAsync(string key, System.Int64 amount = default(System.Int64), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task ResetAsync(string key, System.Int64 startingAt = default(System.Int64), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }

    // Generated from `ServiceStack.IService` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IService
    {
    }

    // Generated from `ServiceStack.IServiceAfterFilter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceAfterFilter
    {
        object OnAfterExecute(object response);
    }

    // Generated from `ServiceStack.IServiceAfterFilterAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceAfterFilterAsync
    {
        System.Threading.Tasks.Task<object> OnAfterExecuteAsync(object response);
    }

    // Generated from `ServiceStack.IServiceBeforeFilter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceBeforeFilter
    {
        void OnBeforeExecute(object requestDto);
    }

    // Generated from `ServiceStack.IServiceBeforeFilterAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceBeforeFilterAsync
    {
        System.Threading.Tasks.Task OnBeforeExecuteAsync(object requestDto);
    }

    // Generated from `ServiceStack.IServiceClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceClient : System.IDisposable, ServiceStack.IServiceGatewayAsync, ServiceStack.IServiceGateway, ServiceStack.IServiceClientSync, ServiceStack.IServiceClientCommon, ServiceStack.IServiceClientAsync, ServiceStack.IRestServiceClient, ServiceStack.IRestClientSync, ServiceStack.IRestClientAsync, ServiceStack.IRestClient, ServiceStack.IReplyClient, ServiceStack.IOneWayClient, ServiceStack.IHttpRestClientAsync, ServiceStack.IHasVersion, ServiceStack.IHasSessionId, ServiceStack.IHasBearerToken
    {
    }

    // Generated from `ServiceStack.IServiceClientAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceClientAsync : System.IDisposable, ServiceStack.IServiceGatewayAsync, ServiceStack.IServiceClientCommon, ServiceStack.IRestClientAsync
    {
    }

    // Generated from `ServiceStack.IServiceClientCommon` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceClientCommon : System.IDisposable
    {
        void SetCredentials(string userName, string password);
    }

    // Generated from `ServiceStack.IServiceClientSync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceClientSync : System.IDisposable, ServiceStack.IServiceGateway, ServiceStack.IServiceClientCommon, ServiceStack.IRestClientSync
    {
    }

    // Generated from `ServiceStack.IServiceErrorFilter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceErrorFilter
    {
        System.Threading.Tasks.Task<object> OnExceptionAsync(object requestDto, System.Exception ex);
    }

    // Generated from `ServiceStack.IServiceFilters` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceFilters : ServiceStack.IServiceErrorFilter, ServiceStack.IServiceBeforeFilter, ServiceStack.IServiceAfterFilter
    {
    }

    // Generated from `ServiceStack.IServiceGateway` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceGateway
    {
        void Publish(object requestDto);
        void PublishAll(System.Collections.Generic.IEnumerable<object> requestDtos);
        TResponse Send<TResponse>(object requestDto);
        System.Collections.Generic.List<TResponse> SendAll<TResponse>(System.Collections.Generic.IEnumerable<object> requestDtos);
    }

    // Generated from `ServiceStack.IServiceGatewayAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IServiceGatewayAsync
    {
        System.Threading.Tasks.Task PublishAllAsync(System.Collections.Generic.IEnumerable<object> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task PublishAsync(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<System.Collections.Generic.List<TResponse>> SendAllAsync<TResponse>(System.Collections.Generic.IEnumerable<object> requestDtos, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        System.Threading.Tasks.Task<TResponse> SendAsync<TResponse>(object requestDto, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
    }

    // Generated from `ServiceStack.IStream` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IStream : ServiceStack.IVerb
    {
    }

    // Generated from `ServiceStack.IUpdateDb<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IUpdateDb<Table> : ServiceStack.ICrud
    {
    }

    // Generated from `ServiceStack.IUrlFilter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IUrlFilter
    {
        string ToUrl(string absoluteUrl);
    }

    // Generated from `ServiceStack.IValidateRule` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IValidateRule
    {
        string Condition { get; set; }
        string ErrorCode { get; set; }
        string Message { get; set; }
        string Validator { get; set; }
    }

    // Generated from `ServiceStack.IValidationSource` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IValidationSource
    {
        System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, ServiceStack.IValidateRule>> GetValidationRules(System.Type type);
    }

    // Generated from `ServiceStack.IValidationSourceAdmin` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IValidationSourceAdmin
    {
        System.Threading.Tasks.Task ClearCacheAsync();
        System.Threading.Tasks.Task DeleteValidationRulesAsync(params int[] ids);
        System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.ValidationRule>> GetAllValidateRulesAsync(string typeName);
        System.Threading.Tasks.Task<System.Collections.Generic.List<ServiceStack.ValidationRule>> GetValidateRulesByIdsAsync(params int[] ids);
        System.Threading.Tasks.Task SaveValidationRulesAsync(System.Collections.Generic.List<ServiceStack.ValidationRule> validateRules);
    }

    // Generated from `ServiceStack.IVerb` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public interface IVerb
    {
    }

    // Generated from `ServiceStack.IdResponse` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class IdResponse : ServiceStack.IHasResponseStatus
    {
        public string Id { get => throw null; set => throw null; }
        public IdResponse() => throw null;
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.Lang` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    [System.Flags]
    public enum Lang
    {
        CSharp,
        Dart,
        FSharp,
        Java,
        Kotlin,
        Swift,
        TypeScript,
        Vb,
    }

    // Generated from `ServiceStack.NamedConnectionAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class NamedConnectionAttribute : ServiceStack.AttributeBase
    {
        public string Name { get => throw null; set => throw null; }
        public NamedConnectionAttribute(string name) => throw null;
    }

    // Generated from `ServiceStack.NavItem` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class NavItem : ServiceStack.IMeta
    {
        public System.Collections.Generic.List<ServiceStack.NavItem> Children { get => throw null; set => throw null; }
        public string ClassName { get => throw null; set => throw null; }
        public bool? Exact { get => throw null; set => throw null; }
        public string Hide { get => throw null; set => throw null; }
        public string Href { get => throw null; set => throw null; }
        public string IconClass { get => throw null; set => throw null; }
        public string Id { get => throw null; set => throw null; }
        public string Label { get => throw null; set => throw null; }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set => throw null; }
        public NavItem() => throw null;
        public string Show { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.Network` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum Network
    {
        External,
        LocalSubnet,
        Localhost,
    }

    // Generated from `ServiceStack.PageArgAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class PageArgAttribute : ServiceStack.AttributeBase
    {
        public string Name { get => throw null; set => throw null; }
        public PageArgAttribute(string name, string value) => throw null;
        public string Value { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.PageAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class PageAttribute : ServiceStack.AttributeBase
    {
        public string Layout { get => throw null; set => throw null; }
        public PageAttribute(string virtualPath, string layout = default(string)) => throw null;
        public string VirtualPath { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.PriorityAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class PriorityAttribute : ServiceStack.AttributeBase
    {
        public PriorityAttribute(int value) => throw null;
        public int Value { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.Properties` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class Properties : System.Collections.Generic.List<ServiceStack.Property>
    {
        public Properties(System.Collections.Generic.IEnumerable<ServiceStack.Property> collection) => throw null;
        public Properties() => throw null;
    }

    // Generated from `ServiceStack.Property` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class Property
    {
        public string Name { get => throw null; set => throw null; }
        public Property() => throw null;
        public string Value { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.QueryBase` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class QueryBase : ServiceStack.IQuery, ServiceStack.IMeta
    {
        public virtual string Fields { get => throw null; set => throw null; }
        public virtual string Include { get => throw null; set => throw null; }
        public virtual System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set => throw null; }
        public virtual string OrderBy { get => throw null; set => throw null; }
        public virtual string OrderByDesc { get => throw null; set => throw null; }
        protected QueryBase() => throw null;
        public virtual int? Skip { get => throw null; set => throw null; }
        public virtual int? Take { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.QueryData<,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class QueryData<From, Into> : ServiceStack.QueryBase, ServiceStack.IReturn<ServiceStack.QueryResponse<Into>>, ServiceStack.IReturn, ServiceStack.IQueryData<From, Into>, ServiceStack.IQueryData, ServiceStack.IQuery, ServiceStack.IMeta
    {
        protected QueryData() => throw null;
    }

    // Generated from `ServiceStack.QueryData<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class QueryData<T> : ServiceStack.QueryBase, ServiceStack.IReturn<ServiceStack.QueryResponse<T>>, ServiceStack.IReturn, ServiceStack.IQueryData<T>, ServiceStack.IQueryData, ServiceStack.IQuery, ServiceStack.IMeta
    {
        protected QueryData() => throw null;
    }

    // Generated from `ServiceStack.QueryDataAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class QueryDataAttribute : ServiceStack.AttributeBase
    {
        public ServiceStack.QueryTerm DefaultTerm { get => throw null; set => throw null; }
        public QueryDataAttribute(ServiceStack.QueryTerm defaultTerm) => throw null;
        public QueryDataAttribute() => throw null;
    }

    // Generated from `ServiceStack.QueryDataFieldAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class QueryDataFieldAttribute : ServiceStack.AttributeBase
    {
        public string Condition { get => throw null; set => throw null; }
        public string Field { get => throw null; set => throw null; }
        public QueryDataFieldAttribute() => throw null;
        public ServiceStack.QueryTerm Term { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.QueryDb<,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class QueryDb<From, Into> : ServiceStack.QueryBase, ServiceStack.IReturn<ServiceStack.QueryResponse<Into>>, ServiceStack.IReturn, ServiceStack.IQueryDb<From, Into>, ServiceStack.IQueryDb, ServiceStack.IQuery, ServiceStack.IMeta
    {
        protected QueryDb() => throw null;
    }

    // Generated from `ServiceStack.QueryDb<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class QueryDb<T> : ServiceStack.QueryBase, ServiceStack.IReturn<ServiceStack.QueryResponse<T>>, ServiceStack.IReturn, ServiceStack.IQueryDb<T>, ServiceStack.IQueryDb, ServiceStack.IQuery, ServiceStack.IMeta
    {
        protected QueryDb() => throw null;
    }

    // Generated from `ServiceStack.QueryDbAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class QueryDbAttribute : ServiceStack.AttributeBase
    {
        public ServiceStack.QueryTerm DefaultTerm { get => throw null; set => throw null; }
        public QueryDbAttribute(ServiceStack.QueryTerm defaultTerm) => throw null;
        public QueryDbAttribute() => throw null;
    }

    // Generated from `ServiceStack.QueryDbFieldAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class QueryDbFieldAttribute : ServiceStack.AttributeBase
    {
        public string Field { get => throw null; set => throw null; }
        public string Operand { get => throw null; set => throw null; }
        public QueryDbFieldAttribute() => throw null;
        public string Template { get => throw null; set => throw null; }
        public ServiceStack.QueryTerm Term { get => throw null; set => throw null; }
        public int ValueArity { get => throw null; set => throw null; }
        public string ValueFormat { get => throw null; set => throw null; }
        public ServiceStack.ValueStyle ValueStyle { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.QueryResponse<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class QueryResponse<T> : ServiceStack.IQueryResponse, ServiceStack.IMeta, ServiceStack.IHasResponseStatus
    {
        public virtual System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set => throw null; }
        public virtual int Offset { get => throw null; set => throw null; }
        public QueryResponse() => throw null;
        public virtual ServiceStack.ResponseStatus ResponseStatus { get => throw null; set => throw null; }
        public virtual System.Collections.Generic.List<T> Results { get => throw null; set => throw null; }
        public virtual int Total { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.QueryTerm` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum QueryTerm
    {
        And,
        Default,
        Ensure,
        Or,
    }

    // Generated from `ServiceStack.ReflectAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ReflectAttribute
    {
        public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<System.Reflection.PropertyInfo, object>> ConstructorArgs { get => throw null; set => throw null; }
        public string Name { get => throw null; set => throw null; }
        public System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<System.Reflection.PropertyInfo, object>> PropertyArgs { get => throw null; set => throw null; }
        public ReflectAttribute() => throw null;
    }

    // Generated from `ServiceStack.RequestAttributes` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    [System.Flags]
    public enum RequestAttributes
    {
        Any,
        AnyCallStyle,
        AnyEndpoint,
        AnyFormat,
        AnyHttpMethod,
        AnyNetworkAccessType,
        AnySecurityMode,
        Csv,
        EndpointOther,
        External,
        FormatOther,
        Grpc,
        Html,
        Http,
        HttpDelete,
        HttpGet,
        HttpHead,
        HttpOptions,
        HttpOther,
        HttpPatch,
        HttpPost,
        HttpPut,
        InProcess,
        InSecure,
        InternalNetworkAccess,
        Json,
        Jsv,
        LocalSubnet,
        Localhost,
        MessageQueue,
        MsgPack,
        None,
        OneWay,
        ProtoBuf,
        Reply,
        Secure,
        Soap11,
        Soap12,
        Tcp,
        Wire,
        Xml,
    }

    // Generated from `ServiceStack.RequestAttributesExtensions` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class RequestAttributesExtensions
    {
        public static string FromFormat(this ServiceStack.Format format) => throw null;
        public static bool IsExternal(this ServiceStack.RequestAttributes attrs) => throw null;
        public static bool IsLocalSubnet(this ServiceStack.RequestAttributes attrs) => throw null;
        public static bool IsLocalhost(this ServiceStack.RequestAttributes attrs) => throw null;
        public static ServiceStack.Feature ToFeature(this ServiceStack.Format format) => throw null;
        public static ServiceStack.Format ToFormat(this string format) => throw null;
        public static ServiceStack.Format ToFormat(this ServiceStack.Feature feature) => throw null;
        public static ServiceStack.Feature ToSoapFeature(this ServiceStack.RequestAttributes attributes) => throw null;
    }

    // Generated from `ServiceStack.RequestLogEntry` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class RequestLogEntry : ServiceStack.IMeta
    {
        public string AbsoluteUri { get => throw null; set => throw null; }
        public System.DateTime DateTime { get => throw null; set => throw null; }
        public object ErrorResponse { get => throw null; set => throw null; }
        public System.Collections.IDictionary ExceptionData { get => throw null; set => throw null; }
        public string ExceptionSource { get => throw null; set => throw null; }
        public System.Collections.Generic.Dictionary<string, string> FormData { get => throw null; set => throw null; }
        public string ForwardedFor { get => throw null; set => throw null; }
        public System.Collections.Generic.Dictionary<string, string> Headers { get => throw null; set => throw null; }
        public string HttpMethod { get => throw null; set => throw null; }
        public System.Int64 Id { get => throw null; set => throw null; }
        public string IpAddress { get => throw null; set => throw null; }
        public System.Collections.Generic.Dictionary<string, string> Items { get => throw null; set => throw null; }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set => throw null; }
        public string PathInfo { get => throw null; set => throw null; }
        public string Referer { get => throw null; set => throw null; }
        public string RequestBody { get => throw null; set => throw null; }
        public object RequestDto { get => throw null; set => throw null; }
        public System.TimeSpan RequestDuration { get => throw null; set => throw null; }
        public RequestLogEntry() => throw null;
        public object ResponseDto { get => throw null; set => throw null; }
        public object Session { get => throw null; set => throw null; }
        public string SessionId { get => throw null; set => throw null; }
        public int StatusCode { get => throw null; set => throw null; }
        public string StatusDescription { get => throw null; set => throw null; }
        public string UserAuthId { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ResponseError` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ResponseError : ServiceStack.IMeta
    {
        public string ErrorCode { get => throw null; set => throw null; }
        public string FieldName { get => throw null; set => throw null; }
        public string Message { get => throw null; set => throw null; }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set => throw null; }
        public ResponseError() => throw null;
    }

    // Generated from `ServiceStack.ResponseStatus` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ResponseStatus : ServiceStack.IMeta
    {
        public string ErrorCode { get => throw null; set => throw null; }
        public System.Collections.Generic.List<ServiceStack.ResponseError> Errors { get => throw null; set => throw null; }
        public string Message { get => throw null; set => throw null; }
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set => throw null; }
        public ResponseStatus(string errorCode, string message) => throw null;
        public ResponseStatus(string errorCode) => throw null;
        public ResponseStatus() => throw null;
        public string StackTrace { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.RestrictAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class RestrictAttribute : ServiceStack.AttributeBase
    {
        public ServiceStack.RequestAttributes AccessTo { get => throw null; set => throw null; }
        public ServiceStack.RequestAttributes[] AccessibleToAny { get => throw null; set => throw null; }
        public bool CanShowTo(ServiceStack.RequestAttributes restrictions) => throw null;
        public bool ExternalOnly { get => throw null; set => throw null; }
        public bool HasAccessTo(ServiceStack.RequestAttributes restrictions) => throw null;
        public bool HasNoAccessRestrictions { get => throw null; }
        public bool HasNoVisibilityRestrictions { get => throw null; }
        public bool InternalOnly { get => throw null; set => throw null; }
        public bool LocalhostOnly { get => throw null; set => throw null; }
        public RestrictAttribute(params ServiceStack.RequestAttributes[] restrictAccessAndVisibilityToScenarios) => throw null;
        public RestrictAttribute(ServiceStack.RequestAttributes[] allowedAccessScenarios, ServiceStack.RequestAttributes[] visibleToScenarios) => throw null;
        public RestrictAttribute() => throw null;
        public ServiceStack.RequestAttributes VisibilityTo { get => throw null; set => throw null; }
        public bool VisibleInternalOnly { get => throw null; set => throw null; }
        public bool VisibleLocalhostOnly { get => throw null; set => throw null; }
        public ServiceStack.RequestAttributes[] VisibleToAny { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.RestrictExtensions` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public static class RestrictExtensions
    {
        public static bool HasAnyRestrictionsOf(ServiceStack.RequestAttributes allRestrictions, ServiceStack.RequestAttributes restrictions) => throw null;
        public static ServiceStack.RequestAttributes ToAllowedFlagsSet(this ServiceStack.RequestAttributes restrictTo) => throw null;
    }

    // Generated from `ServiceStack.RouteAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class RouteAttribute : ServiceStack.AttributeBase, ServiceStack.IReflectAttributeConverter
    {
        public override bool Equals(object obj) => throw null;
        protected bool Equals(ServiceStack.RouteAttribute other) => throw null;
        public override int GetHashCode() => throw null;
        public string Matches { get => throw null; set => throw null; }
        public string Notes { get => throw null; set => throw null; }
        public string Path { get => throw null; set => throw null; }
        public int Priority { get => throw null; set => throw null; }
        public RouteAttribute(string path, string verbs) => throw null;
        public RouteAttribute(string path) => throw null;
        public string Summary { get => throw null; set => throw null; }
        public ServiceStack.ReflectAttribute ToReflectAttribute() => throw null;
        public string Verbs { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ScriptValue` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public struct ScriptValue : ServiceStack.IScriptValue
    {
        public string Eval { get => throw null; set => throw null; }
        public string Expression { get => throw null; set => throw null; }
        public bool NoCache { get => throw null; set => throw null; }
        // Stub generator skipped constructor 
        public object Value { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ScriptValueAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public abstract class ScriptValueAttribute : ServiceStack.AttributeBase, ServiceStack.IScriptValue
    {
        public string Eval { get => throw null; set => throw null; }
        public string Expression { get => throw null; set => throw null; }
        public bool NoCache { get => throw null; set => throw null; }
        protected ScriptValueAttribute() => throw null;
        public object Value { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.Security` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum Security
    {
        InSecure,
        Secure,
    }

    // Generated from `ServiceStack.SqlTemplate` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

    // Generated from `ServiceStack.StrictModeException` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class StrictModeException : System.ArgumentException
    {
        public string Code { get => throw null; set => throw null; }
        public StrictModeException(string message, string paramName, string code = default(string)) => throw null;
        public StrictModeException(string message, string code = default(string)) => throw null;
        public StrictModeException(string message, System.Exception innerException, string code = default(string)) => throw null;
        public StrictModeException() => throw null;
    }

    // Generated from `ServiceStack.StringResponse` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class StringResponse : ServiceStack.IMeta, ServiceStack.IHasResponseStatus
    {
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set => throw null; }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set => throw null; }
        public string Results { get => throw null; set => throw null; }
        public StringResponse() => throw null;
    }

    // Generated from `ServiceStack.StringsResponse` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class StringsResponse : ServiceStack.IMeta, ServiceStack.IHasResponseStatus
    {
        public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set => throw null; }
        public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set => throw null; }
        public System.Collections.Generic.List<string> Results { get => throw null; set => throw null; }
        public StringsResponse() => throw null;
    }

    // Generated from `ServiceStack.SwaggerType` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

    // Generated from `ServiceStack.SynthesizeAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class SynthesizeAttribute : ServiceStack.AttributeBase
    {
        public SynthesizeAttribute() => throw null;
    }

    // Generated from `ServiceStack.TagAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class TagAttribute : ServiceStack.AttributeBase
    {
        public ServiceStack.ApplyTo ApplyTo { get => throw null; set => throw null; }
        public string Name { get => throw null; set => throw null; }
        public TagAttribute(string name, ServiceStack.ApplyTo applyTo) => throw null;
        public TagAttribute(string name) => throw null;
        public TagAttribute() => throw null;
    }

    // Generated from `ServiceStack.UploadFile` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class UploadFile
    {
        public string ContentType { get => throw null; set => throw null; }
        public string FieldName { get => throw null; set => throw null; }
        public string FileName { get => throw null; set => throw null; }
        public System.IO.Stream Stream { get => throw null; set => throw null; }
        public UploadFile(string fileName, System.IO.Stream stream, string fieldName, string contentType) => throw null;
        public UploadFile(string fileName, System.IO.Stream stream, string fieldName) => throw null;
        public UploadFile(string fileName, System.IO.Stream stream) => throw null;
        public UploadFile(System.IO.Stream stream) => throw null;
    }

    // Generated from `ServiceStack.ValidateAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateAttribute : ServiceStack.AttributeBase, ServiceStack.IValidateRule, ServiceStack.IReflectAttributeConverter
    {
        public string[] AllConditions { get => throw null; set => throw null; }
        public string[] AnyConditions { get => throw null; set => throw null; }
        public static string Combine(string comparand, params string[] conditions) => throw null;
        public string Condition { get => throw null; set => throw null; }
        public string ErrorCode { get => throw null; set => throw null; }
        public string Message { get => throw null; set => throw null; }
        public ServiceStack.ReflectAttribute ToReflectAttribute() => throw null;
        public ValidateAttribute(string validator) => throw null;
        public ValidateAttribute() => throw null;
        public string Validator { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ValidateCreditCardAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateCreditCardAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateCreditCardAttribute() => throw null;
    }

    // Generated from `ServiceStack.ValidateEmailAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateEmailAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateEmailAttribute() => throw null;
    }

    // Generated from `ServiceStack.ValidateEmptyAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateEmptyAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateEmptyAttribute() => throw null;
    }

    // Generated from `ServiceStack.ValidateEqualAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateEqualAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateEqualAttribute(string value) => throw null;
        public ValidateEqualAttribute(int value) => throw null;
    }

    // Generated from `ServiceStack.ValidateExactLengthAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateExactLengthAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateExactLengthAttribute(int length) => throw null;
    }

    // Generated from `ServiceStack.ValidateExclusiveBetweenAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateExclusiveBetweenAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateExclusiveBetweenAttribute(string from, string to) => throw null;
        public ValidateExclusiveBetweenAttribute(int from, int to) => throw null;
        public ValidateExclusiveBetweenAttribute(System.Char from, System.Char to) => throw null;
    }

    // Generated from `ServiceStack.ValidateGreaterThanAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateGreaterThanAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateGreaterThanAttribute(int value) => throw null;
    }

    // Generated from `ServiceStack.ValidateGreaterThanOrEqualAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateGreaterThanOrEqualAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateGreaterThanOrEqualAttribute(int value) => throw null;
    }

    // Generated from `ServiceStack.ValidateHasPermissionAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateHasPermissionAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateHasPermissionAttribute(string permission) => throw null;
    }

    // Generated from `ServiceStack.ValidateHasRoleAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateHasRoleAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateHasRoleAttribute(string role) => throw null;
    }

    // Generated from `ServiceStack.ValidateInclusiveBetweenAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateInclusiveBetweenAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateInclusiveBetweenAttribute(string from, string to) => throw null;
        public ValidateInclusiveBetweenAttribute(int from, int to) => throw null;
        public ValidateInclusiveBetweenAttribute(System.Char from, System.Char to) => throw null;
    }

    // Generated from `ServiceStack.ValidateIsAdminAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateIsAdminAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateIsAdminAttribute() => throw null;
    }

    // Generated from `ServiceStack.ValidateIsAuthenticatedAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateIsAuthenticatedAttribute : ServiceStack.ValidateRequestAttribute
    {
        public ValidateIsAuthenticatedAttribute() => throw null;
    }

    // Generated from `ServiceStack.ValidateLengthAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateLengthAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateLengthAttribute(int min, int max) => throw null;
    }

    // Generated from `ServiceStack.ValidateLessThanAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateLessThanAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateLessThanAttribute(int value) => throw null;
    }

    // Generated from `ServiceStack.ValidateLessThanOrEqualAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateLessThanOrEqualAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateLessThanOrEqualAttribute(int value) => throw null;
    }

    // Generated from `ServiceStack.ValidateMaximumLengthAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateMaximumLengthAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateMaximumLengthAttribute(int max) => throw null;
    }

    // Generated from `ServiceStack.ValidateMinimumLengthAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateMinimumLengthAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateMinimumLengthAttribute(int min) => throw null;
    }

    // Generated from `ServiceStack.ValidateNotEmptyAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateNotEmptyAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateNotEmptyAttribute() => throw null;
    }

    // Generated from `ServiceStack.ValidateNotEqualAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateNotEqualAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateNotEqualAttribute(string value) => throw null;
        public ValidateNotEqualAttribute(int value) => throw null;
    }

    // Generated from `ServiceStack.ValidateNotNullAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateNotNullAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateNotNullAttribute() => throw null;
    }

    // Generated from `ServiceStack.ValidateNullAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateNullAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateNullAttribute() => throw null;
    }

    // Generated from `ServiceStack.ValidateRegularExpressionAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateRegularExpressionAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateRegularExpressionAttribute(string pattern) => throw null;
    }

    // Generated from `ServiceStack.ValidateRequestAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateRequestAttribute : ServiceStack.AttributeBase, ServiceStack.IValidateRule, ServiceStack.IReflectAttributeConverter
    {
        public string[] AllConditions { get => throw null; set => throw null; }
        public string[] AnyConditions { get => throw null; set => throw null; }
        public string Condition { get => throw null; set => throw null; }
        public string[] Conditions { get => throw null; set => throw null; }
        public string ErrorCode { get => throw null; set => throw null; }
        public string Message { get => throw null; set => throw null; }
        public int StatusCode { get => throw null; set => throw null; }
        public ServiceStack.ReflectAttribute ToReflectAttribute() => throw null;
        public ValidateRequestAttribute(string validator) => throw null;
        public ValidateRequestAttribute() => throw null;
        public string Validator { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ValidateRule` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateRule : ServiceStack.IValidateRule
    {
        public string Condition { get => throw null; set => throw null; }
        public string ErrorCode { get => throw null; set => throw null; }
        public string Message { get => throw null; set => throw null; }
        public ValidateRule() => throw null;
        public string Validator { get => throw null; set => throw null; }
    }

    // Generated from `ServiceStack.ValidateScalePrecisionAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidateScalePrecisionAttribute : ServiceStack.ValidateAttribute
    {
        public ValidateScalePrecisionAttribute(int scale, int precision) => throw null;
    }

    // Generated from `ServiceStack.ValidationRule` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public class ValidationRule : ServiceStack.ValidateRule
    {
        public string CreatedBy { get => throw null; set => throw null; }
        public System.DateTime? CreatedDate { get => throw null; set => throw null; }
        public override bool Equals(object obj) => throw null;
        protected bool Equals(ServiceStack.ValidationRule other) => throw null;
        public string Field { get => throw null; set => throw null; }
        public override int GetHashCode() => throw null;
        public int Id { get => throw null; set => throw null; }
        public string ModifiedBy { get => throw null; set => throw null; }
        public System.DateTime? ModifiedDate { get => throw null; set => throw null; }
        public string Notes { get => throw null; set => throw null; }
        public string SuspendedBy { get => throw null; set => throw null; }
        public System.DateTime? SuspendedDate { get => throw null; set => throw null; }
        public string Type { get => throw null; set => throw null; }
        public ValidationRule() => throw null;
    }

    // Generated from `ServiceStack.ValueStyle` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
    public enum ValueStyle
    {
        List,
        Multiple,
        Single,
    }

    namespace Auth
    {
        // Generated from `ServiceStack.Auth.IAuthTokens` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Auth.IPasswordHasher` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IPasswordHasher
        {
            string HashPassword(string password);
            bool VerifyPassword(string hashedPassword, string providedPassword, out bool needsRehash);
            System.Byte Version { get; }
        }

        // Generated from `ServiceStack.Auth.IUserAuth` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Auth.IUserAuthDetails` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IUserAuthDetails : ServiceStack.IMeta, ServiceStack.Auth.IUserAuthDetailsExtended, ServiceStack.Auth.IAuthTokens
        {
            System.DateTime CreatedDate { get; set; }
            int Id { get; set; }
            System.DateTime ModifiedDate { get; set; }
            int? RefId { get; set; }
            string RefIdStr { get; set; }
            int UserAuthId { get; set; }
        }

        // Generated from `ServiceStack.Auth.IUserAuthDetailsExtended` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

    }
    namespace Caching
    {
        // Generated from `ServiceStack.Caching.ICacheClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICacheClient : System.IDisposable
        {
            bool Add<T>(string key, T value, System.TimeSpan expiresIn);
            bool Add<T>(string key, T value, System.DateTime expiresAt);
            bool Add<T>(string key, T value);
            System.Int64 Decrement(string key, System.UInt32 amount);
            void FlushAll();
            T Get<T>(string key);
            System.Collections.Generic.IDictionary<string, T> GetAll<T>(System.Collections.Generic.IEnumerable<string> keys);
            System.Int64 Increment(string key, System.UInt32 amount);
            bool Remove(string key);
            void RemoveAll(System.Collections.Generic.IEnumerable<string> keys);
            bool Replace<T>(string key, T value, System.TimeSpan expiresIn);
            bool Replace<T>(string key, T value, System.DateTime expiresAt);
            bool Replace<T>(string key, T value);
            bool Set<T>(string key, T value, System.TimeSpan expiresIn);
            bool Set<T>(string key, T value, System.DateTime expiresAt);
            bool Set<T>(string key, T value);
            void SetAll<T>(System.Collections.Generic.IDictionary<string, T> values);
        }

        // Generated from `ServiceStack.Caching.ICacheClientAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICacheClientAsync : System.IAsyncDisposable
        {
            System.Threading.Tasks.Task<bool> AddAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> AddAsync<T>(string key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> AddAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.Int64> DecrementAsync(string key, System.UInt32 amount, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task FlushAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.Collections.Generic.IDictionary<string, T>> GetAllAsync<T>(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<T> GetAsync<T>(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Collections.Generic.IAsyncEnumerable<string> GetKeysByPatternAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.TimeSpan?> GetTimeToLiveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<System.Int64> IncrementAsync(string key, System.UInt32 amount, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task RemoveAllAsync(System.Collections.Generic.IEnumerable<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> RemoveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task RemoveExpiredEntriesAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> ReplaceAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> ReplaceAsync<T>(string key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> ReplaceAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task SetAllAsync<T>(System.Collections.Generic.IDictionary<string, T> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> SetAsync<T>(string key, T value, System.TimeSpan expiresIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> SetAsync<T>(string key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> SetAsync<T>(string key, T value, System.DateTime expiresAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Caching.ICacheClientExtended` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICacheClientExtended : System.IDisposable, ServiceStack.Caching.ICacheClient
        {
            System.Collections.Generic.IEnumerable<string> GetKeysByPattern(string pattern);
            System.TimeSpan? GetTimeToLive(string key);
            void RemoveExpiredEntries();
        }

        // Generated from `ServiceStack.Caching.IDeflateProvider` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IDeflateProvider
        {
            System.Byte[] Deflate(string text);
            System.Byte[] Deflate(System.Byte[] bytes);
            System.IO.Stream DeflateStream(System.IO.Stream outputStream);
            string Inflate(System.Byte[] gzBuffer);
            System.Byte[] InflateBytes(System.Byte[] gzBuffer);
            System.IO.Stream InflateStream(System.IO.Stream inputStream);
        }

        // Generated from `ServiceStack.Caching.IGZipProvider` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IGZipProvider
        {
            string GUnzip(System.Byte[] gzBuffer);
            System.Byte[] GUnzipBytes(System.Byte[] gzBuffer);
            System.IO.Stream GUnzipStream(System.IO.Stream gzStream);
            System.Byte[] GZip(string text);
            System.Byte[] GZip(System.Byte[] bytes);
            System.IO.Stream GZipStream(System.IO.Stream outputStream);
        }

        // Generated from `ServiceStack.Caching.IMemcachedClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IMemcachedClient : System.IDisposable
        {
            bool Add(string key, object value, System.DateTime expiresAt);
            bool Add(string key, object value);
            bool CheckAndSet(string key, object value, System.UInt64 lastModifiedValue, System.DateTime expiresAt);
            bool CheckAndSet(string key, object value, System.UInt64 lastModifiedValue);
            System.Int64 Decrement(string key, System.UInt32 amount);
            void FlushAll();
            object Get(string key, out System.UInt64 lastModifiedValue);
            object Get(string key);
            System.Collections.Generic.IDictionary<string, object> GetAll(System.Collections.Generic.IEnumerable<string> keys, out System.Collections.Generic.IDictionary<string, System.UInt64> lastModifiedValues);
            System.Collections.Generic.IDictionary<string, object> GetAll(System.Collections.Generic.IEnumerable<string> keys);
            System.Int64 Increment(string key, System.UInt32 amount);
            bool Remove(string key);
            void RemoveAll(System.Collections.Generic.IEnumerable<string> keys);
            bool Replace(string key, object value, System.DateTime expiresAt);
            bool Replace(string key, object value);
            bool Set(string key, object value, System.DateTime expiresAt);
            bool Set(string key, object value);
        }

        // Generated from `ServiceStack.Caching.IRemoveByPattern` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRemoveByPattern
        {
            void RemoveByPattern(string pattern);
            void RemoveByRegex(string regex);
        }

        // Generated from `ServiceStack.Caching.IRemoveByPatternAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRemoveByPatternAsync
        {
            System.Threading.Tasks.Task RemoveByPatternAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task RemoveByRegexAsync(string regex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Caching.ISession` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ISession
        {
            T Get<T>(string key);
            object this[string key] { get; set; }
            bool Remove(string key);
            void RemoveAll();
            void Set<T>(string key, T value);
        }

        // Generated from `ServiceStack.Caching.ISessionAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ISessionAsync
        {
            System.Threading.Tasks.Task<T> GetAsync<T>(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task RemoveAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task<bool> RemoveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.Task SetAsync<T>(string key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Caching.ISessionFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ISessionFactory
        {
            ServiceStack.Caching.ISession CreateSession(string sessionId);
            ServiceStack.Caching.ISessionAsync CreateSessionAsync(string sessionId);
            ServiceStack.Caching.ISession GetOrCreateSession(ServiceStack.Web.IRequest httpReq, ServiceStack.Web.IResponse httpRes);
            ServiceStack.Caching.ISession GetOrCreateSession();
            ServiceStack.Caching.ISessionAsync GetOrCreateSessionAsync(ServiceStack.Web.IRequest httpReq, ServiceStack.Web.IResponse httpRes);
            ServiceStack.Caching.ISessionAsync GetOrCreateSessionAsync();
        }

    }
    namespace Commands
    {
        // Generated from `ServiceStack.Commands.ICommand` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICommand
        {
            void Execute();
        }

        // Generated from `ServiceStack.Commands.ICommand<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICommand<ReturnType>
        {
            ReturnType Execute();
        }

        // Generated from `ServiceStack.Commands.ICommandExec` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICommandExec : ServiceStack.Commands.ICommand<bool>
        {
        }

        // Generated from `ServiceStack.Commands.ICommandList<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICommandList<T> : ServiceStack.Commands.ICommand<System.Collections.Generic.List<T>>
        {
        }

    }
    namespace Configuration
    {
        // Generated from `ServiceStack.Configuration.IAppSettings` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IAppSettings
        {
            bool Exists(string key);
            T Get<T>(string name, T defaultValue);
            T Get<T>(string name);
            System.Collections.Generic.Dictionary<string, string> GetAll();
            System.Collections.Generic.List<string> GetAllKeys();
            System.Collections.Generic.IDictionary<string, string> GetDictionary(string key);
            System.Collections.Generic.List<System.Collections.Generic.KeyValuePair<string, string>> GetKeyValuePairs(string key);
            System.Collections.Generic.IList<string> GetList(string key);
            string GetString(string name);
            void Set<T>(string key, T value);
        }

        // Generated from `ServiceStack.Configuration.IContainerAdapter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IContainerAdapter : ServiceStack.Configuration.IResolver
        {
            T Resolve<T>();
        }

        // Generated from `ServiceStack.Configuration.IHasResolver` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasResolver
        {
            ServiceStack.Configuration.IResolver Resolver { get; }
        }

        // Generated from `ServiceStack.Configuration.IRelease` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRelease
        {
            void Release(object instance);
        }

        // Generated from `ServiceStack.Configuration.IResolver` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IResolver
        {
            T TryResolve<T>();
        }

        // Generated from `ServiceStack.Configuration.IRuntimeAppSettings` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRuntimeAppSettings
        {
            T Get<T>(ServiceStack.Web.IRequest request, string name, T defaultValue);
        }

        // Generated from `ServiceStack.Configuration.ITypeFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ITypeFactory
        {
            object CreateInstance(ServiceStack.Configuration.IResolver resolver, System.Type type);
        }

    }
    namespace Data
    {
        // Generated from `ServiceStack.Data.DataException` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class DataException : System.Exception
        {
            public DataException(string message, System.Exception innerException) => throw null;
            public DataException(string message) => throw null;
            public DataException() => throw null;
        }

        // Generated from `ServiceStack.Data.IEntityStore` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Data.IEntityStore<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Data.IEntityStoreAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Data.IEntityStoreAsync<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Data.OptimisticConcurrencyException` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class OptimisticConcurrencyException : ServiceStack.Data.DataException
        {
            public OptimisticConcurrencyException(string message, System.Exception innerException) => throw null;
            public OptimisticConcurrencyException(string message) => throw null;
            public OptimisticConcurrencyException() => throw null;
        }

    }
    namespace DataAnnotations
    {
        // Generated from `ServiceStack.DataAnnotations.AliasAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class AliasAttribute : ServiceStack.AttributeBase
        {
            public AliasAttribute(string name) => throw null;
            public string Name { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.AutoIdAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class AutoIdAttribute : ServiceStack.AttributeBase
        {
            public AutoIdAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.AutoIncrementAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class AutoIncrementAttribute : ServiceStack.AttributeBase
        {
            public AutoIncrementAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.BelongToAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class BelongToAttribute : ServiceStack.AttributeBase
        {
            public BelongToAttribute(System.Type belongToTableType) => throw null;
            public System.Type BelongToTableType { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.CheckConstraintAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CheckConstraintAttribute : ServiceStack.AttributeBase
        {
            public CheckConstraintAttribute(string constraint) => throw null;
            public string Constraint { get => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.CompositeIndexAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CompositeIndexAttribute : ServiceStack.AttributeBase
        {
            public CompositeIndexAttribute(params string[] fieldNames) => throw null;
            public CompositeIndexAttribute(bool unique, params string[] fieldNames) => throw null;
            public CompositeIndexAttribute() => throw null;
            public System.Collections.Generic.List<string> FieldNames { get => throw null; set => throw null; }
            public string Name { get => throw null; set => throw null; }
            public bool Unique { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.CompositeKeyAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CompositeKeyAttribute : ServiceStack.AttributeBase
        {
            public CompositeKeyAttribute(params string[] fieldNames) => throw null;
            public CompositeKeyAttribute() => throw null;
            public System.Collections.Generic.List<string> FieldNames { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.ComputeAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ComputeAttribute : ServiceStack.AttributeBase
        {
            public ComputeAttribute(string expression) => throw null;
            public ComputeAttribute() => throw null;
            public string Expression { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.ComputedAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ComputedAttribute : ServiceStack.AttributeBase
        {
            public ComputedAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.CustomFieldAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CustomFieldAttribute : ServiceStack.AttributeBase
        {
            public CustomFieldAttribute(string sql) => throw null;
            public string Sql { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.CustomInsertAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CustomInsertAttribute : ServiceStack.AttributeBase
        {
            public CustomInsertAttribute(string sql) => throw null;
            public string Sql { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.CustomSelectAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CustomSelectAttribute : ServiceStack.AttributeBase
        {
            public CustomSelectAttribute(string sql) => throw null;
            public string Sql { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.CustomUpdateAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class CustomUpdateAttribute : ServiceStack.AttributeBase
        {
            public CustomUpdateAttribute(string sql) => throw null;
            public string Sql { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.DecimalLengthAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class DecimalLengthAttribute : ServiceStack.AttributeBase
        {
            public DecimalLengthAttribute(int precision, int scale) => throw null;
            public DecimalLengthAttribute(int precision) => throw null;
            public DecimalLengthAttribute() => throw null;
            public int Precision { get => throw null; set => throw null; }
            public int Scale { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.DefaultAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class DefaultAttribute : ServiceStack.AttributeBase
        {
            public DefaultAttribute(string defaultValue) => throw null;
            public DefaultAttribute(int intValue) => throw null;
            public DefaultAttribute(double doubleValue) => throw null;
            public DefaultAttribute(System.Type defaultType, string defaultValue) => throw null;
            public System.Type DefaultType { get => throw null; set => throw null; }
            public string DefaultValue { get => throw null; set => throw null; }
            public double DoubleValue { get => throw null; set => throw null; }
            public int IntValue { get => throw null; set => throw null; }
            public bool OnUpdate { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.DescriptionAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class DescriptionAttribute : ServiceStack.AttributeBase
        {
            public string Description { get => throw null; set => throw null; }
            public DescriptionAttribute(string description) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.EnumAsCharAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class EnumAsCharAttribute : ServiceStack.AttributeBase
        {
            public EnumAsCharAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.EnumAsIntAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class EnumAsIntAttribute : ServiceStack.AttributeBase
        {
            public EnumAsIntAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.ExcludeAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ExcludeAttribute : ServiceStack.AttributeBase
        {
            public ExcludeAttribute(ServiceStack.Feature feature) => throw null;
            public ServiceStack.Feature Feature { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.ExcludeMetadataAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ExcludeMetadataAttribute : ServiceStack.DataAnnotations.ExcludeAttribute
        {
            public ExcludeMetadataAttribute() : base(default(ServiceStack.Feature)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.ForeignKeyAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ForeignKeyAttribute : ServiceStack.DataAnnotations.ReferencesAttribute
        {
            public ForeignKeyAttribute(System.Type type) : base(default(System.Type)) => throw null;
            public string ForeignKeyName { get => throw null; set => throw null; }
            public string OnDelete { get => throw null; set => throw null; }
            public string OnUpdate { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.HashKeyAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class HashKeyAttribute : ServiceStack.AttributeBase
        {
            public HashKeyAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.IdAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class IdAttribute : ServiceStack.AttributeBase
        {
            public int Id { get => throw null; }
            public IdAttribute(int id) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.IgnoreAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class IgnoreAttribute : ServiceStack.AttributeBase
        {
            public IgnoreAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.IgnoreOnInsertAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class IgnoreOnInsertAttribute : ServiceStack.AttributeBase
        {
            public IgnoreOnInsertAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.IgnoreOnSelectAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class IgnoreOnSelectAttribute : ServiceStack.AttributeBase
        {
            public IgnoreOnSelectAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.IgnoreOnUpdateAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class IgnoreOnUpdateAttribute : ServiceStack.AttributeBase
        {
            public IgnoreOnUpdateAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.IndexAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class IndexAttribute : ServiceStack.AttributeBase
        {
            public bool Clustered { get => throw null; set => throw null; }
            public IndexAttribute(bool unique) => throw null;
            public IndexAttribute() => throw null;
            public string Name { get => throw null; set => throw null; }
            public bool NonClustered { get => throw null; set => throw null; }
            public bool Unique { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.MetaAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class MetaAttribute : ServiceStack.AttributeBase
        {
            public MetaAttribute(string name, string value) => throw null;
            public string Name { get => throw null; set => throw null; }
            public string Value { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.PersistedAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PersistedAttribute : ServiceStack.AttributeBase
        {
            public PersistedAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlBigIntArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlBigIntArrayAttribute : ServiceStack.DataAnnotations.PgSqlLongArrayAttribute
        {
            public PgSqlBigIntArrayAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlDecimalArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlDecimalArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlDecimalArrayAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlDoubleArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlDoubleArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlDoubleArrayAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlFloatArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlFloatArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlFloatArrayAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlHStoreAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlHStoreAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlHStoreAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlIntArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlIntArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlIntArrayAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlJsonAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlJsonAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlJsonAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlJsonBAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlJsonBAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlJsonBAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlLongArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlLongArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlLongArrayAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlShortArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlShortArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlShortArrayAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlTextArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlTextArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTextArrayAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlTimestampArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlTimestampArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTimestampArrayAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlTimestampAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlTimestampAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTimestampAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlTimestampTzArrayAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlTimestampTzArrayAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTimestampTzArrayAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PgSqlTimestampTzAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PgSqlTimestampTzAttribute : ServiceStack.DataAnnotations.CustomFieldAttribute
        {
            public PgSqlTimestampTzAttribute() : base(default(string)) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.PostCreateTableAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PostCreateTableAttribute : ServiceStack.AttributeBase
        {
            public PostCreateTableAttribute(string sql) => throw null;
            public string Sql { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.PostDropTableAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PostDropTableAttribute : ServiceStack.AttributeBase
        {
            public PostDropTableAttribute(string sql) => throw null;
            public string Sql { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.PreCreateTableAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PreCreateTableAttribute : ServiceStack.AttributeBase
        {
            public PreCreateTableAttribute(string sql) => throw null;
            public string Sql { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.PreDropTableAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PreDropTableAttribute : ServiceStack.AttributeBase
        {
            public PreDropTableAttribute(string sql) => throw null;
            public string Sql { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.PrimaryKeyAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class PrimaryKeyAttribute : ServiceStack.AttributeBase
        {
            public PrimaryKeyAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.RangeAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RangeAttribute : ServiceStack.AttributeBase
        {
            public object Maximum { get => throw null; set => throw null; }
            public object Minimum { get => throw null; set => throw null; }
            public System.Type OperandType { get => throw null; set => throw null; }
            public RangeAttribute(int minimum, int maximum) => throw null;
            public RangeAttribute(double minimum, double maximum) => throw null;
            public RangeAttribute(System.Type type, string minimum, string maximum) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.RangeKeyAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RangeKeyAttribute : ServiceStack.AttributeBase
        {
            public RangeKeyAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.ReferenceAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ReferenceAttribute : ServiceStack.AttributeBase
        {
            public ReferenceAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.ReferencesAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ReferencesAttribute : ServiceStack.AttributeBase
        {
            public ReferencesAttribute(System.Type type) => throw null;
            public System.Type Type { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.DataAnnotations.RequiredAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RequiredAttribute : ServiceStack.AttributeBase
        {
            public RequiredAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.ReturnOnInsertAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ReturnOnInsertAttribute : ServiceStack.AttributeBase
        {
            public ReturnOnInsertAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.RowVersionAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RowVersionAttribute : ServiceStack.AttributeBase
        {
            public RowVersionAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.SchemaAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class SchemaAttribute : ServiceStack.AttributeBase
        {
            public string Name { get => throw null; set => throw null; }
            public SchemaAttribute(string name) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.SequenceAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class SequenceAttribute : ServiceStack.AttributeBase
        {
            public string Name { get => throw null; set => throw null; }
            public SequenceAttribute(string name) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.SqlServerBucketCountAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class SqlServerBucketCountAttribute : ServiceStack.AttributeBase
        {
            public int Count { get => throw null; set => throw null; }
            public SqlServerBucketCountAttribute(int count) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.SqlServerCollateAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class SqlServerCollateAttribute : ServiceStack.AttributeBase
        {
            public string Collation { get => throw null; set => throw null; }
            public SqlServerCollateAttribute(string collation) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.SqlServerDurability` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public enum SqlServerDurability
        {
            SchemaAndData,
            SchemaOnly,
        }

        // Generated from `ServiceStack.DataAnnotations.SqlServerFileTableAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class SqlServerFileTableAttribute : ServiceStack.AttributeBase
        {
            public string FileTableCollateFileName { get => throw null; set => throw null; }
            public string FileTableDirectory { get => throw null; set => throw null; }
            public SqlServerFileTableAttribute(string directory, string collateFileName = default(string)) => throw null;
            public SqlServerFileTableAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.SqlServerMemoryOptimizedAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class SqlServerMemoryOptimizedAttribute : ServiceStack.AttributeBase
        {
            public ServiceStack.DataAnnotations.SqlServerDurability? Durability { get => throw null; set => throw null; }
            public SqlServerMemoryOptimizedAttribute(ServiceStack.DataAnnotations.SqlServerDurability durability) => throw null;
            public SqlServerMemoryOptimizedAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.StringLengthAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class StringLengthAttribute : ServiceStack.AttributeBase
        {
            public const int MaxText = default;
            public int MaximumLength { get => throw null; set => throw null; }
            public int MinimumLength { get => throw null; set => throw null; }
            public StringLengthAttribute(int minimumLength, int maximumLength) => throw null;
            public StringLengthAttribute(int maximumLength) => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.UniqueAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class UniqueAttribute : ServiceStack.AttributeBase
        {
            public UniqueAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.UniqueConstraintAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class UniqueConstraintAttribute : ServiceStack.AttributeBase
        {
            public System.Collections.Generic.List<string> FieldNames { get => throw null; set => throw null; }
            public string Name { get => throw null; set => throw null; }
            public UniqueConstraintAttribute(params string[] fieldNames) => throw null;
            public UniqueConstraintAttribute() => throw null;
        }

        // Generated from `ServiceStack.DataAnnotations.UniqueIdAttribute` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class UniqueIdAttribute : ServiceStack.AttributeBase
        {
            public int Id { get => throw null; }
            public UniqueIdAttribute(int id) => throw null;
        }

    }
    namespace IO
    {
        // Generated from `ServiceStack.IO.IEndpoint` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IEndpoint
        {
            string Host { get; }
            int Port { get; }
        }

        // Generated from `ServiceStack.IO.IHasVirtualFiles` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasVirtualFiles
        {
            ServiceStack.IO.IVirtualDirectory GetDirectory();
            ServiceStack.IO.IVirtualFile GetFile();
            bool IsDirectory { get; }
            bool IsFile { get; }
        }

        // Generated from `ServiceStack.IO.IVirtualDirectory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IVirtualDirectory : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualNode>, ServiceStack.IO.IVirtualNode
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

        // Generated from `ServiceStack.IO.IVirtualFile` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IVirtualFile : ServiceStack.IO.IVirtualNode
        {
            string Extension { get; }
            object GetContents();
            string GetFileHash();
            System.Int64 Length { get; }
            System.IO.Stream OpenRead();
            System.IO.StreamReader OpenText();
            string ReadAllText();
            void Refresh();
            ServiceStack.IO.IVirtualPathProvider VirtualPathProvider { get; }
        }

        // Generated from `ServiceStack.IO.IVirtualFiles` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IVirtualFiles : ServiceStack.IO.IVirtualPathProvider
        {
            void AppendFile(string filePath, string textContents);
            void AppendFile(string filePath, object contents);
            void AppendFile(string filePath, System.IO.Stream stream);
            void DeleteFile(string filePath);
            void DeleteFiles(System.Collections.Generic.IEnumerable<string> filePaths);
            void DeleteFolder(string dirPath);
            void WriteFile(string filePath, string textContents);
            void WriteFile(string filePath, object contents);
            void WriteFile(string filePath, System.IO.Stream stream);
            void WriteFiles(System.Collections.Generic.IEnumerable<ServiceStack.IO.IVirtualFile> files, System.Func<ServiceStack.IO.IVirtualFile, string> toPath = default(System.Func<ServiceStack.IO.IVirtualFile, string>));
            void WriteFiles(System.Collections.Generic.Dictionary<string, string> textFiles);
            void WriteFiles(System.Collections.Generic.Dictionary<string, object> files);
        }

        // Generated from `ServiceStack.IO.IVirtualFilesAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IVirtualFilesAsync : ServiceStack.IO.IVirtualPathProvider, ServiceStack.IO.IVirtualFiles
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

        // Generated from `ServiceStack.IO.IVirtualNode` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IVirtualNode
        {
            ServiceStack.IO.IVirtualDirectory Directory { get; }
            bool IsDirectory { get; }
            System.DateTime LastModified { get; }
            string Name { get; }
            string RealPath { get; }
            string VirtualPath { get; }
        }

        // Generated from `ServiceStack.IO.IVirtualPathProvider` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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
    namespace Logging
    {
        // Generated from `ServiceStack.Logging.GenericLogFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class GenericLogFactory : ServiceStack.Logging.ILogFactory
        {
            public GenericLogFactory(System.Action<string> onMessage) => throw null;
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public System.Action<string> OnMessage;
        }

        // Generated from `ServiceStack.Logging.GenericLogger` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class GenericLogger : ServiceStack.Logging.ILog
        {
            public bool CaptureLogs { get => throw null; set => throw null; }
            public void Debug(object message, System.Exception exception) => throw null;
            public void Debug(object message) => throw null;
            public void DebugFormat(string format, params object[] args) => throw null;
            public void Error(object message, System.Exception exception) => throw null;
            public void Error(object message) => throw null;
            public void ErrorFormat(string format, params object[] args) => throw null;
            public void Fatal(object message, System.Exception exception) => throw null;
            public void Fatal(object message) => throw null;
            public void FatalFormat(string format, params object[] args) => throw null;
            public GenericLogger(string type) => throw null;
            public GenericLogger(System.Type type) => throw null;
            public void Info(object message, System.Exception exception) => throw null;
            public void Info(object message) => throw null;
            public void InfoFormat(string format, params object[] args) => throw null;
            public bool IsDebugEnabled { get => throw null; set => throw null; }
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

        // Generated from `ServiceStack.Logging.ILog` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ILog
        {
            void Debug(object message, System.Exception exception);
            void Debug(object message);
            void DebugFormat(string format, params object[] args);
            void Error(object message, System.Exception exception);
            void Error(object message);
            void ErrorFormat(string format, params object[] args);
            void Fatal(object message, System.Exception exception);
            void Fatal(object message);
            void FatalFormat(string format, params object[] args);
            void Info(object message, System.Exception exception);
            void Info(object message);
            void InfoFormat(string format, params object[] args);
            bool IsDebugEnabled { get; }
            void Warn(object message, System.Exception exception);
            void Warn(object message);
            void WarnFormat(string format, params object[] args);
        }

        // Generated from `ServiceStack.Logging.ILogFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ILogFactory
        {
            ServiceStack.Logging.ILog GetLogger(string typeName);
            ServiceStack.Logging.ILog GetLogger(System.Type type);
        }

        // Generated from `ServiceStack.Logging.ILogWithContext` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ILogWithContext : ServiceStack.Logging.ILogWithException, ServiceStack.Logging.ILog
        {
            System.IDisposable PushProperty(string key, object value);
        }

        // Generated from `ServiceStack.Logging.ILogWithContextExtensions` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class ILogWithContextExtensions
        {
            public static System.IDisposable PushProperty(this ServiceStack.Logging.ILog logger, string key, object value) => throw null;
        }

        // Generated from `ServiceStack.Logging.ILogWithException` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ILogWithException : ServiceStack.Logging.ILog
        {
            void Debug(System.Exception exception, string format, params object[] args);
            void Error(System.Exception exception, string format, params object[] args);
            void Fatal(System.Exception exception, string format, params object[] args);
            void Info(System.Exception exception, string format, params object[] args);
            void Warn(System.Exception exception, string format, params object[] args);
        }

        // Generated from `ServiceStack.Logging.ILogWithExceptionExtensions` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class ILogWithExceptionExtensions
        {
            public static void Debug(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
            public static void Error(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
            public static void Fatal(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
            public static void Info(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
            public static void Warn(this ServiceStack.Logging.ILog logger, System.Exception exception, string format, params object[] args) => throw null;
        }

        // Generated from `ServiceStack.Logging.LogManager` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class LogManager
        {
            public static ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
            public static ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public static ServiceStack.Logging.ILogFactory LogFactory { get => throw null; set => throw null; }
            public LogManager() => throw null;
        }

        // Generated from `ServiceStack.Logging.NullDebugLogger` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class NullDebugLogger : ServiceStack.Logging.ILog
        {
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
            public bool IsDebugEnabled { get => throw null; set => throw null; }
            public NullDebugLogger(string type) => throw null;
            public NullDebugLogger(System.Type type) => throw null;
            public void Warn(object message, System.Exception exception) => throw null;
            public void Warn(object message) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }

        // Generated from `ServiceStack.Logging.NullLogFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class NullLogFactory : ServiceStack.Logging.ILogFactory
        {
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public NullLogFactory(bool debugEnabled = default(bool)) => throw null;
        }

        // Generated from `ServiceStack.Logging.StringBuilderLog` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class StringBuilderLog : ServiceStack.Logging.ILog
        {
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
            public bool IsDebugEnabled { get => throw null; set => throw null; }
            public StringBuilderLog(string type, System.Text.StringBuilder logs) => throw null;
            public StringBuilderLog(System.Type type, System.Text.StringBuilder logs) => throw null;
            public void Warn(object message, System.Exception exception) => throw null;
            public void Warn(object message) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }

        // Generated from `ServiceStack.Logging.StringBuilderLogFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class StringBuilderLogFactory : ServiceStack.Logging.ILogFactory
        {
            public void ClearLogs() => throw null;
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public string GetLogs() => throw null;
            public StringBuilderLogFactory(bool debugEnabled = default(bool)) => throw null;
        }

        // Generated from `ServiceStack.Logging.TestLogFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class TestLogFactory : ServiceStack.Logging.ILogFactory
        {
            public ServiceStack.Logging.ILog GetLogger(string typeName) => throw null;
            public ServiceStack.Logging.ILog GetLogger(System.Type type) => throw null;
            public TestLogFactory(bool debugEnabled = default(bool)) => throw null;
        }

        // Generated from `ServiceStack.Logging.TestLogger` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class TestLogger : ServiceStack.Logging.ILog
        {
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
            public bool IsDebugEnabled { get => throw null; set => throw null; }
            // Generated from `ServiceStack.Logging.TestLogger+Levels` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public enum Levels
            {
                DEBUG,
                ERROR,
                FATAL,
                INFO,
                WARN,
            }


            public TestLogger(string type) => throw null;
            public TestLogger(System.Type type) => throw null;
            public void Warn(object message, System.Exception exception) => throw null;
            public void Warn(object message) => throw null;
            public void WarnFormat(string format, params object[] args) => throw null;
        }

    }
    namespace Messaging
    {
        // Generated from `ServiceStack.Messaging.IMessage` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IMessage : ServiceStack.Model.IHasId<System.Guid>, ServiceStack.IMeta
        {
            object Body { get; set; }
            System.DateTime CreatedDate { get; }
            ServiceStack.ResponseStatus Error { get; set; }
            int Options { get; set; }
            System.Int64 Priority { get; set; }
            System.Guid? ReplyId { get; set; }
            string ReplyTo { get; set; }
            int RetryAttempts { get; set; }
            string Tag { get; set; }
        }

        // Generated from `ServiceStack.Messaging.IMessage<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IMessage<T> : ServiceStack.Model.IHasId<System.Guid>, ServiceStack.Messaging.IMessage, ServiceStack.IMeta
        {
            T GetBody();
        }

        // Generated from `ServiceStack.Messaging.IMessageFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IMessageFactory : System.IDisposable, ServiceStack.Messaging.IMessageQueueClientFactory
        {
            ServiceStack.Messaging.IMessageProducer CreateMessageProducer();
        }

        // Generated from `ServiceStack.Messaging.IMessageHandler` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IMessageHandler
        {
            ServiceStack.Messaging.IMessageHandlerStats GetStats();
            System.Type MessageType { get; }
            ServiceStack.Messaging.IMessageQueueClient MqClient { get; }
            void Process(ServiceStack.Messaging.IMessageQueueClient mqClient);
            void ProcessMessage(ServiceStack.Messaging.IMessageQueueClient mqClient, object mqResponse);
            int ProcessQueue(ServiceStack.Messaging.IMessageQueueClient mqClient, string queueName, System.Func<bool> doNext = default(System.Func<bool>));
        }

        // Generated from `ServiceStack.Messaging.IMessageHandlerStats` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Messaging.IMessageProducer` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IMessageProducer : System.IDisposable
        {
            void Publish<T>(T messageBody);
            void Publish<T>(ServiceStack.Messaging.IMessage<T> message);
        }

        // Generated from `ServiceStack.Messaging.IMessageQueueClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Messaging.IMessageQueueClientFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IMessageQueueClientFactory : System.IDisposable
        {
            ServiceStack.Messaging.IMessageQueueClient CreateMessageQueueClient();
        }

        // Generated from `ServiceStack.Messaging.IMessageService` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IMessageService : System.IDisposable
        {
            ServiceStack.Messaging.IMessageHandlerStats GetStats();
            string GetStatsDescription();
            string GetStatus();
            ServiceStack.Messaging.IMessageFactory MessageFactory { get; }
            void RegisterHandler<T>(System.Func<ServiceStack.Messaging.IMessage<T>, object> processMessageFn, int noOfThreads);
            void RegisterHandler<T>(System.Func<ServiceStack.Messaging.IMessage<T>, object> processMessageFn, System.Action<ServiceStack.Messaging.IMessageHandler, ServiceStack.Messaging.IMessage<T>, System.Exception> processExceptionEx, int noOfThreads);
            void RegisterHandler<T>(System.Func<ServiceStack.Messaging.IMessage<T>, object> processMessageFn, System.Action<ServiceStack.Messaging.IMessageHandler, ServiceStack.Messaging.IMessage<T>, System.Exception> processExceptionEx);
            void RegisterHandler<T>(System.Func<ServiceStack.Messaging.IMessage<T>, object> processMessageFn);
            System.Collections.Generic.List<System.Type> RegisteredTypes { get; }
            void Start();
            void Stop();
        }

        // Generated from `ServiceStack.Messaging.Message` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class Message : ServiceStack.Model.IHasId<System.Guid>, ServiceStack.Messaging.IMessage, ServiceStack.IMeta
        {
            public object Body { get => throw null; set => throw null; }
            public System.DateTime CreatedDate { get => throw null; set => throw null; }
            public ServiceStack.ResponseStatus Error { get => throw null; set => throw null; }
            public System.Guid Id { get => throw null; set => throw null; }
            public Message() => throw null;
            public System.Collections.Generic.Dictionary<string, string> Meta { get => throw null; set => throw null; }
            public int Options { get => throw null; set => throw null; }
            public System.Int64 Priority { get => throw null; set => throw null; }
            public System.Guid? ReplyId { get => throw null; set => throw null; }
            public string ReplyTo { get => throw null; set => throw null; }
            public int RetryAttempts { get => throw null; set => throw null; }
            public string Tag { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Messaging.Message<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class Message<T> : ServiceStack.Messaging.Message, ServiceStack.Model.IHasId<System.Guid>, ServiceStack.Messaging.IMessage<T>, ServiceStack.Messaging.IMessage, ServiceStack.IMeta
        {
            public static ServiceStack.Messaging.IMessage Create(object oBody) => throw null;
            public T GetBody() => throw null;
            public Message(T body) => throw null;
            public Message() => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `ServiceStack.Messaging.MessageFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class MessageFactory
        {
            public static ServiceStack.Messaging.IMessage Create(object response) => throw null;
        }

        // Generated from `ServiceStack.Messaging.MessageHandlerStats` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class MessageHandlerStats : ServiceStack.Messaging.IMessageHandlerStats
        {
            public virtual void Add(ServiceStack.Messaging.IMessageHandlerStats stats) => throw null;
            public System.DateTime? LastMessageProcessed { get => throw null; set => throw null; }
            public MessageHandlerStats(string name, int totalMessagesProcessed, int totalMessagesFailed, int totalRetries, int totalNormalMessagesReceived, int totalPriorityMessagesReceived, System.DateTime? lastMessageProcessed) => throw null;
            public MessageHandlerStats(string name) => throw null;
            public string Name { get => throw null; set => throw null; }
            public override string ToString() => throw null;
            public int TotalMessagesFailed { get => throw null; set => throw null; }
            public int TotalMessagesProcessed { get => throw null; set => throw null; }
            public int TotalNormalMessagesReceived { get => throw null; set => throw null; }
            public int TotalPriorityMessagesReceived { get => throw null; set => throw null; }
            public int TotalRetries { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Messaging.MessageHandlerStatsExtensions` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class MessageHandlerStatsExtensions
        {
            public static ServiceStack.Messaging.IMessageHandlerStats CombineStats(this System.Collections.Generic.IEnumerable<ServiceStack.Messaging.IMessageHandlerStats> stats) => throw null;
        }

        // Generated from `ServiceStack.Messaging.MessageOption` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        [System.Flags]
        public enum MessageOption
        {
            All,
            None,
            NotifyOneWay,
        }

        // Generated from `ServiceStack.Messaging.MessagingException` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class MessagingException : System.Exception, ServiceStack.Model.IResponseStatusConvertible, ServiceStack.IHasResponseStatus
        {
            public MessagingException(string message, System.Exception innerException) => throw null;
            public MessagingException(string message) => throw null;
            public MessagingException(ServiceStack.ResponseStatus responseStatus, object responseDto, System.Exception innerException = default(System.Exception)) => throw null;
            public MessagingException(ServiceStack.ResponseStatus responseStatus, System.Exception innerException = default(System.Exception)) => throw null;
            public MessagingException() => throw null;
            public object ResponseDto { get => throw null; set => throw null; }
            public ServiceStack.ResponseStatus ResponseStatus { get => throw null; set => throw null; }
            public ServiceStack.ResponseStatus ToResponseStatus() => throw null;
        }

        // Generated from `ServiceStack.Messaging.QueueNames` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class QueueNames
        {
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
            public QueueNames(System.Type messageType) => throw null;
            public static string QueuePrefix;
            public static string ResolveQueueName(string typeName, string queueSuffix) => throw null;
            public static System.Func<string, string, string> ResolveQueueNameFn;
            public static void SetQueuePrefix(string prefix) => throw null;
            public static string TempMqPrefix;
            public static string TopicIn;
            public static string TopicOut;
        }

        // Generated from `ServiceStack.Messaging.QueueNames<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class QueueNames<T>
        {
            public static string[] AllQueueNames { get => throw null; }
            public static string Dlq { get => throw null; set => throw null; }
            public static string In { get => throw null; set => throw null; }
            public static string Out { get => throw null; set => throw null; }
            public static string Priority { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Messaging.UnRetryableMessagingException` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class UnRetryableMessagingException : ServiceStack.Messaging.MessagingException
        {
            public UnRetryableMessagingException(string message, System.Exception innerException) => throw null;
            public UnRetryableMessagingException(string message) => throw null;
            public UnRetryableMessagingException() => throw null;
        }

        // Generated from `ServiceStack.Messaging.WorkerStatus` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class WorkerStatus
        {
            public const int Disposed = default;
            public const int Started = default;
            public const int Starting = default;
            public const int Stopped = default;
            public const int Stopping = default;
            public static string ToString(int workerStatus) => throw null;
        }

    }
    namespace Model
    {
        // Generated from `ServiceStack.Model.ICacheByDateModified` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICacheByDateModified
        {
            System.DateTime? LastModified { get; }
        }

        // Generated from `ServiceStack.Model.ICacheByEtag` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICacheByEtag
        {
            string Etag { get; }
        }

        // Generated from `ServiceStack.Model.IHasAction` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasAction
        {
            string Action { get; }
        }

        // Generated from `ServiceStack.Model.IHasGuidId` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasGuidId : ServiceStack.Model.IHasId<System.Guid>
        {
        }

        // Generated from `ServiceStack.Model.IHasId<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasId<T>
        {
            T Id { get; }
        }

        // Generated from `ServiceStack.Model.IHasIntId` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasIntId : ServiceStack.Model.IHasId<int>
        {
        }

        // Generated from `ServiceStack.Model.IHasLongId` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasLongId : ServiceStack.Model.IHasId<System.Int64>
        {
        }

        // Generated from `ServiceStack.Model.IHasNamed<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasNamed<T>
        {
            T this[string listId] { get; set; }
        }

        // Generated from `ServiceStack.Model.IHasNamedCollection<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasNamedCollection<T> : ServiceStack.Model.IHasNamed<System.Collections.Generic.ICollection<T>>
        {
        }

        // Generated from `ServiceStack.Model.IHasNamedList<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasNamedList<T> : ServiceStack.Model.IHasNamed<System.Collections.Generic.IList<T>>
        {
        }

        // Generated from `ServiceStack.Model.IHasStringId` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasStringId : ServiceStack.Model.IHasId<string>
        {
        }

        // Generated from `ServiceStack.Model.IResponseStatusConvertible` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IResponseStatusConvertible
        {
            ServiceStack.ResponseStatus ToResponseStatus();
        }

    }
    namespace Redis
    {
        // Generated from `ServiceStack.Redis.IRedisClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisClient : System.IDisposable, ServiceStack.Data.IEntityStore, ServiceStack.Caching.IRemoveByPattern, ServiceStack.Caching.ICacheClientExtended, ServiceStack.Caching.ICacheClient
        {
            System.IDisposable AcquireLock(string key, System.TimeSpan timeOut);
            System.IDisposable AcquireLock(string key);
            System.Int64 AddGeoMember(string key, double longitude, double latitude, string member);
            System.Int64 AddGeoMembers(string key, params ServiceStack.Redis.RedisGeo[] geoPoints);
            void AddItemToList(string listId, string value);
            void AddItemToSet(string setId, string item);
            bool AddItemToSortedSet(string setId, string value, double score);
            bool AddItemToSortedSet(string setId, string value);
            void AddRangeToList(string listId, System.Collections.Generic.List<string> values);
            void AddRangeToSet(string setId, System.Collections.Generic.List<string> items);
            bool AddRangeToSortedSet(string setId, System.Collections.Generic.List<string> values, double score);
            bool AddRangeToSortedSet(string setId, System.Collections.Generic.List<string> values, System.Int64 score);
            bool AddToHyperLog(string key, params string[] elements);
            System.Int64 AppendToValue(string key, string value);
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
            System.Int64 CountHyperLog(string key);
            ServiceStack.Redis.Pipeline.IRedisPipeline CreatePipeline();
            ServiceStack.Redis.IRedisSubscription CreateSubscription();
            ServiceStack.Redis.IRedisTransaction CreateTransaction();
            ServiceStack.Redis.RedisText Custom(params object[] cmdWithArgs);
            System.Int64 Db { get; set; }
            System.Int64 DbSize { get; }
            System.Int64 DecrementValue(string key);
            System.Int64 DecrementValueBy(string key, int count);
            string DequeueItemFromList(string listId);
            string Echo(string text);
            void EnqueueItemOnList(string listId, string value);
            T ExecCachedLua<T>(string scriptBody, System.Func<string, T> scriptSha1);
            ServiceStack.Redis.RedisText ExecLua(string luaBody, string[] keys, string[] args);
            ServiceStack.Redis.RedisText ExecLua(string body, params string[] args);
            System.Int64 ExecLuaAsInt(string luaBody, string[] keys, string[] args);
            System.Int64 ExecLuaAsInt(string luaBody, params string[] args);
            System.Collections.Generic.List<string> ExecLuaAsList(string luaBody, string[] keys, string[] args);
            System.Collections.Generic.List<string> ExecLuaAsList(string luaBody, params string[] args);
            string ExecLuaAsString(string luaBody, string[] keys, string[] args);
            string ExecLuaAsString(string luaBody, params string[] args);
            ServiceStack.Redis.RedisText ExecLuaSha(string sha1, string[] keys, string[] args);
            ServiceStack.Redis.RedisText ExecLuaSha(string sha1, params string[] args);
            System.Int64 ExecLuaShaAsInt(string sha1, string[] keys, string[] args);
            System.Int64 ExecLuaShaAsInt(string sha1, params string[] args);
            System.Collections.Generic.List<string> ExecLuaShaAsList(string sha1, string[] keys, string[] args);
            System.Collections.Generic.List<string> ExecLuaShaAsList(string sha1, params string[] args);
            string ExecLuaShaAsString(string sha1, string[] keys, string[] args);
            string ExecLuaShaAsString(string sha1, params string[] args);
            bool ExpireEntryAt(string key, System.DateTime expireAt);
            bool ExpireEntryIn(string key, System.TimeSpan expireIn);
            string[] FindGeoMembersInRadius(string key, string member, double radius, string unit);
            string[] FindGeoMembersInRadius(string key, double longitude, double latitude, double radius, string unit);
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> FindGeoResultsInRadius(string key, string member, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?));
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> FindGeoResultsInRadius(string key, double longitude, double latitude, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?));
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
            System.Int64 GetHashCount(string hashId);
            System.Collections.Generic.List<string> GetHashKeys(string hashId);
            System.Collections.Generic.List<string> GetHashValues(string hashId);
            System.Collections.Generic.HashSet<string> GetIntersectFromSets(params string[] setIds);
            string GetItemFromList(string listId, int listIndex);
            System.Int64 GetItemIndexInSortedSet(string setId, string value);
            System.Int64 GetItemIndexInSortedSetDesc(string setId, string value);
            double GetItemScoreInSortedSet(string setId, string value);
            System.Int64 GetListCount(string listId);
            string GetRandomItemFromSet(string setId);
            string GetRandomKey();
            System.Collections.Generic.List<string> GetRangeFromList(string listId, int startingFrom, int endingAt);
            System.Collections.Generic.List<string> GetRangeFromSortedList(string listId, int startingFrom, int endingAt);
            System.Collections.Generic.List<string> GetRangeFromSortedSet(string setId, int fromRank, int toRank);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, double fromScore, double toScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, double fromScore, double toScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByHighestScore(string setId, System.Int64 fromScore, System.Int64 toScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, double fromScore, double toScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, double fromScore, double toScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeFromSortedSetByLowestScore(string setId, System.Int64 fromScore, System.Int64 toScore);
            System.Collections.Generic.List<string> GetRangeFromSortedSetDesc(string setId, int fromRank, int toRank);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSet(string setId, int fromRank, int toRank);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, string fromStringScore, string toStringScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, double fromScore, double toScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, double fromScore, double toScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByHighestScore(string setId, System.Int64 fromScore, System.Int64 toScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, string fromStringScore, string toStringScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, double fromScore, double toScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, double fromScore, double toScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetByLowestScore(string setId, System.Int64 fromScore, System.Int64 toScore);
            System.Collections.Generic.IDictionary<string, double> GetRangeWithScoresFromSortedSetDesc(string setId, int fromRank, int toRank);
            ServiceStack.Redis.RedisServerRole GetServerRole();
            ServiceStack.Redis.RedisText GetServerRoleInfo();
            System.DateTime GetServerTime();
            System.Int64 GetSetCount(string setId);
            System.Collections.Generic.List<string> GetSortedEntryValues(string key, int startingFrom, int endingAt);
            System.Collections.Generic.List<string> GetSortedItemsFromList(string listId, ServiceStack.Redis.SortOptions sortOptions);
            System.Int64 GetSortedSetCount(string setId, string fromStringScore, string toStringScore);
            System.Int64 GetSortedSetCount(string setId, double fromScore, double toScore);
            System.Int64 GetSortedSetCount(string setId, System.Int64 fromScore, System.Int64 toScore);
            System.Int64 GetSortedSetCount(string setId);
            System.Int64 GetStringCount(string key);
            System.Collections.Generic.HashSet<string> GetUnionFromSets(params string[] setIds);
            string GetValue(string key);
            string GetValueFromHash(string hashId, string key);
            System.Collections.Generic.List<string> GetValues(System.Collections.Generic.List<string> keys);
            System.Collections.Generic.List<T> GetValues<T>(System.Collections.Generic.List<string> keys);
            System.Collections.Generic.List<string> GetValuesFromHash(string hashId, params string[] keys);
            System.Collections.Generic.Dictionary<string, string> GetValuesMap(System.Collections.Generic.List<string> keys);
            System.Collections.Generic.Dictionary<string, T> GetValuesMap<T>(System.Collections.Generic.List<string> keys);
            bool HadExceptions { get; }
            bool HasLuaScript(string sha1Ref);
            bool HashContainsEntry(string hashId, string key);
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisHash> Hashes { get; set; }
            string Host { get; }
            double IncrementItemInSortedSet(string setId, string value, double incrementBy);
            double IncrementItemInSortedSet(string setId, string value, System.Int64 incrementBy);
            System.Int64 IncrementValue(string key);
            double IncrementValueBy(string key, double count);
            System.Int64 IncrementValueBy(string key, int count);
            System.Int64 IncrementValueBy(string key, System.Int64 count);
            double IncrementValueInHash(string hashId, string key, double incrementBy);
            System.Int64 IncrementValueInHash(string hashId, string key, int incrementBy);
            System.Collections.Generic.Dictionary<string, string> Info { get; }
            string this[string key] { get; set; }
            void KillClient(string address);
            System.Int64 KillClients(string fromAddress = default(string), string withId = default(string), ServiceStack.Redis.RedisClientType? ofType = default(ServiceStack.Redis.RedisClientType?), bool? skipMe = default(bool?));
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
            string PopItemWithHighestScoreFromSortedSet(string setId);
            string PopItemWithLowestScoreFromSortedSet(string setId);
            System.Collections.Generic.List<string> PopItemsFromSet(string setId, int count);
            int Port { get; }
            void PrependItemToList(string listId, string value);
            void PrependRangeToList(string listId, System.Collections.Generic.List<string> values);
            System.Int64 PublishMessage(string toChannel, string message);
            void PushItemToList(string listId, string value);
            void RemoveAllFromList(string listId);
            void RemoveAllLuaScripts();
            string RemoveEndFromList(string listId);
            bool RemoveEntry(params string[] args);
            bool RemoveEntryFromHash(string hashId, string key);
            System.Int64 RemoveItemFromList(string listId, string value, int noOfMatches);
            System.Int64 RemoveItemFromList(string listId, string value);
            void RemoveItemFromSet(string setId, string item);
            bool RemoveItemFromSortedSet(string setId, string value);
            System.Int64 RemoveItemsFromSortedSet(string setId, System.Collections.Generic.List<string> values);
            System.Int64 RemoveRangeFromSortedSet(string setId, int minRank, int maxRank);
            System.Int64 RemoveRangeFromSortedSetByScore(string setId, double fromScore, double toScore);
            System.Int64 RemoveRangeFromSortedSetByScore(string setId, System.Int64 fromScore, System.Int64 toScore);
            System.Int64 RemoveRangeFromSortedSetBySearch(string setId, string start = default(string), string end = default(string));
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
            System.Int64 SearchSortedSetCount(string setId, string start = default(string), string end = default(string));
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
            void SetValue(string key, string value, System.TimeSpan expireIn);
            void SetValue(string key, string value);
            bool SetValueIfExists(string key, string value, System.TimeSpan expireIn);
            bool SetValueIfExists(string key, string value);
            bool SetValueIfNotExists(string key, string value, System.TimeSpan expireIn);
            bool SetValueIfNotExists(string key, string value);
            void SetValues(System.Collections.Generic.Dictionary<string, string> map);
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSet> Sets { get; set; }
            void Shutdown();
            void ShutdownNoSave();
            bool SortedSetContainsItem(string setId, string value);
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSortedSet> SortedSets { get; set; }
            void StoreAsHash<T>(T entity);
            void StoreDifferencesFromSet(string intoSetId, string fromSetId, params string[] withSetIds);
            void StoreIntersectFromSets(string intoSetId, params string[] setIds);
            System.Int64 StoreIntersectFromSortedSets(string intoSetId, string[] setIds, string[] args);
            System.Int64 StoreIntersectFromSortedSets(string intoSetId, params string[] setIds);
            object StoreObject(object entity);
            void StoreUnionFromSets(string intoSetId, params string[] setIds);
            System.Int64 StoreUnionFromSortedSets(string intoSetId, string[] setIds, string[] args);
            System.Int64 StoreUnionFromSortedSets(string intoSetId, params string[] setIds);
            void TrimList(string listId, int keepStartingFrom, int keepEndingAt);
            string Type(string key);
            void UnWatch();
            string UrnKey<T>(object id);
            string UrnKey<T>(T value);
            string UrnKey(System.Type type, object id);
            void Watch(params string[] keys);
            System.Collections.Generic.Dictionary<string, bool> WhichLuaScriptsExists(params string[] sha1Refs);
            void WriteAll<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities);
        }

        // Generated from `ServiceStack.Redis.IRedisClientAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisClientAsync : System.IAsyncDisposable, ServiceStack.Data.IEntityStoreAsync, ServiceStack.Caching.IRemoveByPatternAsync, ServiceStack.Caching.ICacheClientAsync
        {
            System.Threading.Tasks.ValueTask<System.IAsyncDisposable> AcquireLockAsync(string key, System.TimeSpan? timeOut = default(System.TimeSpan?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> AddGeoMemberAsync(string key, double longitude, double latitude, string member, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> AddGeoMembersAsync(string key, params ServiceStack.Redis.RedisGeo[] geoPoints);
            System.Threading.Tasks.ValueTask<System.Int64> AddGeoMembersAsync(string key, ServiceStack.Redis.RedisGeo[] geoPoints, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddItemToListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddItemToSetAsync(string setId, string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddItemToSortedSetAsync(string setId, string value, double score, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddItemToSortedSetAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddRangeToListAsync(string listId, System.Collections.Generic.List<string> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddRangeToSetAsync(string setId, System.Collections.Generic.List<string> items, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddRangeToSortedSetAsync(string setId, System.Collections.Generic.List<string> values, double score, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddRangeToSortedSetAsync(string setId, System.Collections.Generic.List<string> values, System.Int64 score, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddToHyperLogAsync(string key, string[] elements, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddToHyperLogAsync(string key, params string[] elements);
            System.Threading.Tasks.ValueTask<System.Int64> AppendToValueAsync(string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
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
            System.Threading.Tasks.ValueTask<System.Int64> CountHyperLogAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Redis.Pipeline.IRedisPipelineAsync CreatePipeline();
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisSubscriptionAsync> CreateSubscriptionAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisTransactionAsync> CreateTransactionAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> CustomAsync(params object[] cmdWithArgs);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> CustomAsync(object[] cmdWithArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Int64 Db { get; }
            System.Threading.Tasks.ValueTask<System.Int64> DbSizeAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> DecrementValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> DecrementValueByAsync(string key, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> DequeueItemFromListAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> EchoAsync(string text, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask EnqueueItemOnListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<T> ExecCachedLuaAsync<T>(string scriptBody, System.Func<string, System.Threading.Tasks.ValueTask<T>> scriptSha1, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ExecLuaAsIntAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ExecLuaAsIntAsync(string luaBody, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ExecLuaAsIntAsync(string luaBody, params string[] args);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaAsListAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaAsListAsync(string luaBody, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaAsListAsync(string luaBody, params string[] args);
            System.Threading.Tasks.ValueTask<string> ExecLuaAsStringAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ExecLuaAsStringAsync(string luaBody, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ExecLuaAsStringAsync(string luaBody, params string[] args);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaAsync(string luaBody, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaAsync(string body, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaAsync(string body, params string[] args);
            System.Threading.Tasks.ValueTask<System.Int64> ExecLuaShaAsIntAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ExecLuaShaAsIntAsync(string sha1, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ExecLuaShaAsIntAsync(string sha1, params string[] args);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaShaAsListAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaShaAsListAsync(string sha1, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> ExecLuaShaAsListAsync(string sha1, params string[] args);
            System.Threading.Tasks.ValueTask<string> ExecLuaShaAsStringAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ExecLuaShaAsStringAsync(string sha1, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ExecLuaShaAsStringAsync(string sha1, params string[] args);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaShaAsync(string sha1, string[] keys, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaShaAsync(string sha1, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> ExecLuaShaAsync(string sha1, params string[] args);
            System.Threading.Tasks.ValueTask<bool> ExpireEntryAtAsync(string key, System.DateTime expireAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ExpireEntryInAsync(string key, System.TimeSpan expireIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string[]> FindGeoMembersInRadiusAsync(string key, string member, double radius, string unit, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string[]> FindGeoMembersInRadiusAsync(string key, double longitude, double latitude, double radius, string unit, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> FindGeoResultsInRadiusAsync(string key, string member, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> FindGeoResultsInRadiusAsync(string key, double longitude, double latitude, double radius, string unit, int? count = default(int?), bool? sortByNearest = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
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
            System.Threading.Tasks.ValueTask<System.Int64> GetHashCountAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetHashKeysAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetHashValuesAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetIntersectFromSetsAsync(string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetIntersectFromSetsAsync(params string[] setIds);
            System.Threading.Tasks.ValueTask<string> GetItemFromListAsync(string listId, int listIndex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetItemIndexInSortedSetAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetItemIndexInSortedSetDescAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> GetItemScoreInSortedSetAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetListCountAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetRandomItemFromSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetRandomKeyAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromListAsync(string listId, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedListAsync(string listId, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByHighestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetByLowestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetDescAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<string, double>> GetRangeWithScoresFromSortedSetDescAsync(string setId, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisServerRole> GetServerRoleAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> GetServerRoleInfoAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.DateTime> GetServerTimeAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetSetCountAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.SlowlogItem[]> GetSlowlogAsync(int? numberOfRecords = default(int?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetSortedEntryValuesAsync(string key, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetSortedItemsFromListAsync(string listId, ServiceStack.Redis.SortOptions sortOptions, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetSortedSetCountAsync(string setId, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetSortedSetCountAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetSortedSetCountAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetSortedSetCountAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetStringCountAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
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
            System.Threading.Tasks.ValueTask<bool> HasLuaScriptAsync(string sha1Ref, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> HashContainsEntryAsync(string hashId, string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisHashAsync> Hashes { get; }
            string Host { get; }
            System.Threading.Tasks.ValueTask<double> IncrementItemInSortedSetAsync(string setId, string value, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> IncrementItemInSortedSetAsync(string setId, string value, System.Int64 incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> IncrementValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> IncrementValueByAsync(string key, double count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> IncrementValueByAsync(string key, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> IncrementValueByAsync(string key, System.Int64 count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> IncrementValueInHashAsync(string hashId, string key, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> IncrementValueInHashAsync(string hashId, string key, int incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> InfoAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask KillClientAsync(string address, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> KillClientsAsync(string fromAddress = default(string), string withId = default(string), ServiceStack.Redis.RedisClientType? ofType = default(ServiceStack.Redis.RedisClientType?), bool? skipMe = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
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
            System.Threading.Tasks.ValueTask<string> PopItemWithHighestScoreFromSortedSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopItemWithLowestScoreFromSortedSetAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> PopItemsFromSetAsync(string setId, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            int Port { get; }
            System.Threading.Tasks.ValueTask PrependItemToListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PrependRangeToListAsync(string listId, System.Collections.Generic.List<string> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> PublishMessageAsync(string toChannel, string message, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PushItemToListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveAllFromListAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveAllLuaScriptsAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> RemoveEndFromListAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(params string[] args);
            System.Threading.Tasks.ValueTask<bool> RemoveEntryFromHashAsync(string hashId, string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RemoveItemFromListAsync(string listId, string value, int noOfMatches, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RemoveItemFromListAsync(string listId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveItemFromSetAsync(string setId, string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveItemFromSortedSetAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RemoveItemsFromSortedSetAsync(string setId, System.Collections.Generic.List<string> values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RemoveRangeFromSortedSetAsync(string setId, int minRank, int maxRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RemoveRangeFromSortedSetByScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RemoveRangeFromSortedSetByScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RemoveRangeFromSortedSetBySearchAsync(string setId, string start = default(string), string end = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
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
            System.Threading.Tasks.ValueTask<System.Int64> SearchSortedSetCountAsync(string setId, string start = default(string), string end = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SelectAsync(System.Int64 db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
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
            System.Threading.Tasks.ValueTask SetValueAsync(string key, string value, System.TimeSpan expireIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetValueAsync(string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SetValueIfExistsAsync(string key, string value, System.TimeSpan? expireIn = default(System.TimeSpan?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SetValueIfNotExistsAsync(string key, string value, System.TimeSpan? expireIn = default(System.TimeSpan?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetValuesAsync(System.Collections.Generic.IDictionary<string, string> map, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSetAsync> Sets { get; }
            System.Threading.Tasks.ValueTask ShutdownAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ShutdownNoSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SlowlogResetAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SortedSetContainsItemAsync(string setId, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            ServiceStack.Model.IHasNamed<ServiceStack.Redis.IRedisSortedSetAsync> SortedSets { get; }
            System.Threading.Tasks.ValueTask StoreAsHashAsync<T>(T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreDifferencesFromSetAsync(string intoSetId, string fromSetId, string[] withSetIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreDifferencesFromSetAsync(string intoSetId, string fromSetId, params string[] withSetIds);
            System.Threading.Tasks.ValueTask StoreIntersectFromSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreIntersectFromSetsAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<System.Int64> StoreIntersectFromSortedSetsAsync(string intoSetId, string[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> StoreIntersectFromSortedSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> StoreIntersectFromSortedSetsAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<object> StoreObjectAsync(object entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreUnionFromSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreUnionFromSetsAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<System.Int64> StoreUnionFromSortedSetsAsync(string intoSetId, string[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> StoreUnionFromSortedSetsAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> StoreUnionFromSortedSetsAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask TrimListAsync(string listId, int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> TypeAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask UnWatchAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            string UrnKey<T>(object id);
            string UrnKey<T>(T value);
            string UrnKey(System.Type type, object id);
            System.Threading.Tasks.ValueTask WatchAsync(string[] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask WatchAsync(params string[] keys);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, bool>> WhichLuaScriptsExistsAsync(string[] sha1Refs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, bool>> WhichLuaScriptsExistsAsync(params string[] sha1Refs);
            System.Threading.Tasks.ValueTask WriteAllAsync<TEntity>(System.Collections.Generic.IEnumerable<TEntity> entities, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Redis.IRedisClientCacheManager` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisClientCacheManager : System.IDisposable
        {
            ServiceStack.Caching.ICacheClient GetCacheClient();
            ServiceStack.Redis.IRedisClient GetClient();
            ServiceStack.Caching.ICacheClient GetReadOnlyCacheClient();
            ServiceStack.Redis.IRedisClient GetReadOnlyClient();
        }

        // Generated from `ServiceStack.Redis.IRedisClientsManager` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisClientsManager : System.IDisposable
        {
            ServiceStack.Caching.ICacheClient GetCacheClient();
            ServiceStack.Redis.IRedisClient GetClient();
            ServiceStack.Caching.ICacheClient GetReadOnlyCacheClient();
            ServiceStack.Redis.IRedisClient GetReadOnlyClient();
        }

        // Generated from `ServiceStack.Redis.IRedisClientsManagerAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisClientsManagerAsync : System.IAsyncDisposable
        {
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> GetCacheClientAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> GetClientAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Caching.ICacheClientAsync> GetReadOnlyCacheClientAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisClientAsync> GetReadOnlyClientAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Redis.IRedisHash` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisHash : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, System.Collections.Generic.IDictionary<string, string>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<string, string>>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
        {
            bool AddIfNotExists(System.Collections.Generic.KeyValuePair<string, string> item);
            void AddRange(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> items);
            System.Int64 IncrementValue(string key, int incrementBy);
        }

        // Generated from `ServiceStack.Redis.IRedisHashAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisHashAsync : System.Collections.Generic.IAsyncEnumerable<System.Collections.Generic.KeyValuePair<string, string>>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
        {
            System.Threading.Tasks.ValueTask AddAsync(string key, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddAsync(System.Collections.Generic.KeyValuePair<string, string> item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> AddIfNotExistsAsync(System.Collections.Generic.KeyValuePair<string, string> item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask AddRangeAsync(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, string>> items, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ContainsKeyAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> IncrementValueAsync(string key, int incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Redis.IRedisList` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisList : System.Collections.IEnumerable, System.Collections.Generic.IList<string>, System.Collections.Generic.IEnumerable<string>, System.Collections.Generic.ICollection<string>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
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
            System.Int64 RemoveValue(string value, int noOfMatches);
            System.Int64 RemoveValue(string value);
            void Trim(int keepStartingFrom, int keepEndingAt);
        }

        // Generated from `ServiceStack.Redis.IRedisListAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisListAsync : System.Collections.Generic.IAsyncEnumerable<string>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
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
            System.Threading.Tasks.ValueTask<System.Int64> RemoveValueAsync(string value, int noOfMatches, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RemoveValueAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetValueAsync(int index, string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask TrimAsync(int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Redis.IRedisNativeClient` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisNativeClient : System.IDisposable
        {
            System.Int64 Append(string key, System.Byte[] value);
            System.Byte[][] BLPop(string[] listIds, int timeOutSecs);
            System.Byte[][] BLPop(string listId, int timeOutSecs);
            System.Byte[][] BLPopValue(string[] listIds, int timeOutSecs);
            System.Byte[] BLPopValue(string listId, int timeOutSecs);
            System.Byte[][] BRPop(string[] listIds, int timeOutSecs);
            System.Byte[][] BRPop(string listId, int timeOutSecs);
            System.Byte[] BRPopLPush(string fromListId, string toListId, int timeOutSecs);
            System.Byte[][] BRPopValue(string[] listIds, int timeOutSecs);
            System.Byte[] BRPopValue(string listId, int timeOutSecs);
            void BgRewriteAof();
            void BgSave();
            string CalculateSha1(string luaBody);
            string ClientGetName();
            void ClientKill(string host);
            System.Int64 ClientKill(string addr = default(string), string id = default(string), string type = default(string), string skipMe = default(string));
            System.Byte[] ClientList();
            void ClientPause(int timeOutMs);
            void ClientSetName(string client);
            System.Byte[][] ConfigGet(string pattern);
            void ConfigResetStat();
            void ConfigRewrite();
            void ConfigSet(string item, System.Byte[] value);
            ServiceStack.Redis.IRedisSubscription CreateSubscription();
            System.Int64 Db { get; set; }
            System.Int64 DbSize { get; }
            void DebugSegfault();
            System.Int64 Decr(string key);
            System.Int64 DecrBy(string key, int decrBy);
            System.Int64 Del(string key);
            System.Int64 Del(params string[] keys);
            System.Byte[] Dump(string key);
            string Echo(string text);
            System.Byte[][] Eval(string luaBody, int numberOfKeys, params System.Byte[][] keysAndArgs);
            ServiceStack.Redis.RedisData EvalCommand(string luaBody, int numberKeysInArgs, params System.Byte[][] keys);
            System.Int64 EvalInt(string luaBody, int numberOfKeys, params System.Byte[][] keysAndArgs);
            System.Byte[][] EvalSha(string sha1, int numberOfKeys, params System.Byte[][] keysAndArgs);
            ServiceStack.Redis.RedisData EvalShaCommand(string sha1, int numberKeysInArgs, params System.Byte[][] keys);
            System.Int64 EvalShaInt(string sha1, int numberOfKeys, params System.Byte[][] keysAndArgs);
            string EvalShaStr(string sha1, int numberOfKeys, params System.Byte[][] keysAndArgs);
            string EvalStr(string luaBody, int numberOfKeys, params System.Byte[][] keysAndArgs);
            System.Int64 Exists(string key);
            bool Expire(string key, int seconds);
            bool ExpireAt(string key, System.Int64 unixTime);
            void FlushAll();
            void FlushDb();
            System.Int64 GeoAdd(string key, params ServiceStack.Redis.RedisGeo[] geoPoints);
            System.Int64 GeoAdd(string key, double longitude, double latitude, string member);
            double GeoDist(string key, string fromMember, string toMember, string unit = default(string));
            string[] GeoHash(string key, params string[] members);
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeo> GeoPos(string key, params string[] members);
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> GeoRadius(string key, double longitude, double latitude, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?));
            System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult> GeoRadiusByMember(string key, string member, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?));
            System.Byte[] Get(string key);
            System.Int64 GetBit(string key, int offset);
            System.Byte[] GetRange(string key, int fromIndex, int toIndex);
            System.Byte[] GetSet(string key, System.Byte[] value);
            System.Int64 HDel(string hashId, System.Byte[] key);
            System.Int64 HExists(string hashId, System.Byte[] key);
            System.Byte[] HGet(string hashId, System.Byte[] key);
            System.Byte[][] HGetAll(string hashId);
            System.Int64 HIncrby(string hashId, System.Byte[] key, int incrementBy);
            double HIncrbyFloat(string hashId, System.Byte[] key, double incrementBy);
            System.Byte[][] HKeys(string hashId);
            System.Int64 HLen(string hashId);
            System.Byte[][] HMGet(string hashId, params System.Byte[][] keysAndArgs);
            void HMSet(string hashId, System.Byte[][] keys, System.Byte[][] values);
            ServiceStack.Redis.ScanResult HScan(string hashId, System.UInt64 cursor, int count = default(int), string match = default(string));
            System.Int64 HSet(string hashId, System.Byte[] key, System.Byte[] value);
            System.Int64 HSetNX(string hashId, System.Byte[] key, System.Byte[] value);
            System.Byte[][] HVals(string hashId);
            System.Int64 Incr(string key);
            System.Int64 IncrBy(string key, int incrBy);
            double IncrByFloat(string key, double incrBy);
            System.Collections.Generic.Dictionary<string, string> Info { get; }
            System.Byte[][] Keys(string pattern);
            System.Byte[] LIndex(string listId, int listIndex);
            void LInsert(string listId, bool insertBefore, System.Byte[] pivot, System.Byte[] value);
            System.Int64 LLen(string listId);
            System.Byte[] LPop(string listId);
            System.Int64 LPush(string listId, System.Byte[] value);
            System.Int64 LPushX(string listId, System.Byte[] value);
            System.Byte[][] LRange(string listId, int startingFrom, int endingAt);
            System.Int64 LRem(string listId, int removeNoOfMatches, System.Byte[] value);
            void LSet(string listId, int listIndex, System.Byte[] value);
            void LTrim(string listId, int keepStartingFrom, int keepEndingAt);
            System.DateTime LastSave { get; }
            System.Byte[][] MGet(params string[] keys);
            System.Byte[][] MGet(params System.Byte[][] keysAndArgs);
            void MSet(string[] keys, System.Byte[][] values);
            void MSet(System.Byte[][] keys, System.Byte[][] values);
            bool MSetNx(string[] keys, System.Byte[][] values);
            bool MSetNx(System.Byte[][] keys, System.Byte[][] values);
            void Migrate(string host, int port, string key, int destinationDb, System.Int64 timeoutMs);
            bool Move(string key, int db);
            System.Int64 ObjectIdleTime(string key);
            bool PExpire(string key, System.Int64 ttlMs);
            bool PExpireAt(string key, System.Int64 unixTimeMs);
            void PSetEx(string key, System.Int64 expireInMs, System.Byte[] value);
            System.Byte[][] PSubscribe(params string[] toChannelsMatchingPatterns);
            System.Int64 PTtl(string key);
            System.Byte[][] PUnSubscribe(params string[] toChannelsMatchingPatterns);
            bool Persist(string key);
            bool PfAdd(string key, params System.Byte[][] elements);
            System.Int64 PfCount(string key);
            void PfMerge(string toKeyId, params string[] fromKeys);
            bool Ping();
            System.Int64 Publish(string toChannel, System.Byte[] message);
            void Quit();
            System.Byte[] RPop(string listId);
            System.Byte[] RPopLPush(string fromListId, string toListId);
            System.Int64 RPush(string listId, System.Byte[] value);
            System.Int64 RPushX(string listId, System.Byte[] value);
            string RandomKey();
            ServiceStack.Redis.RedisData RawCommand(params object[] cmdWithArgs);
            ServiceStack.Redis.RedisData RawCommand(params System.Byte[][] cmdWithBinaryArgs);
            System.Byte[][] ReceiveMessages();
            void Rename(string oldKeyname, string newKeyname);
            bool RenameNx(string oldKeyname, string newKeyname);
            System.Byte[] Restore(string key, System.Int64 expireMs, System.Byte[] dumpValue);
            ServiceStack.Redis.RedisText Role();
            System.Int64 SAdd(string setId, System.Byte[][] value);
            System.Int64 SAdd(string setId, System.Byte[] value);
            System.Int64 SCard(string setId);
            System.Byte[][] SDiff(string fromSetId, params string[] withSetIds);
            void SDiffStore(string intoSetId, string fromSetId, params string[] withSetIds);
            System.Byte[][] SInter(params string[] setIds);
            void SInterStore(string intoSetId, params string[] setIds);
            System.Int64 SIsMember(string setId, System.Byte[] value);
            System.Byte[][] SMembers(string setId);
            void SMove(string fromSetId, string toSetId, System.Byte[] value);
            System.Byte[][] SPop(string setId, int count);
            System.Byte[] SPop(string setId);
            System.Byte[] SRandMember(string setId);
            System.Int64 SRem(string setId, System.Byte[] value);
            ServiceStack.Redis.ScanResult SScan(string setId, System.UInt64 cursor, int count = default(int), string match = default(string));
            System.Byte[][] SUnion(params string[] setIds);
            void SUnionStore(string intoSetId, params string[] setIds);
            void Save();
            ServiceStack.Redis.ScanResult Scan(System.UInt64 cursor, int count = default(int), string match = default(string));
            System.Byte[][] ScriptExists(params System.Byte[][] sha1Refs);
            void ScriptFlush();
            void ScriptKill();
            System.Byte[] ScriptLoad(string body);
            void Set(string key, System.Byte[] value);
            System.Int64 SetBit(string key, int offset, int value);
            void SetEx(string key, int expireInSeconds, System.Byte[] value);
            System.Int64 SetNX(string key, System.Byte[] value);
            System.Int64 SetRange(string key, int offset, System.Byte[] value);
            void Shutdown();
            void SlaveOf(string hostname, int port);
            void SlaveOfNoOne();
            System.Byte[][] Sort(string listOrSetId, ServiceStack.Redis.SortOptions sortOptions);
            System.Int64 StrLen(string key);
            System.Byte[][] Subscribe(params string[] toChannels);
            System.Byte[][] Time();
            System.Int64 Ttl(string key);
            string Type(string key);
            System.Byte[][] UnSubscribe(params string[] toChannels);
            void UnWatch();
            void Watch(params string[] keys);
            System.Int64 ZAdd(string setId, double score, System.Byte[] value);
            System.Int64 ZAdd(string setId, System.Int64 score, System.Byte[] value);
            System.Int64 ZCard(string setId);
            double ZIncrBy(string setId, double incrBy, System.Byte[] value);
            double ZIncrBy(string setId, System.Int64 incrBy, System.Byte[] value);
            System.Int64 ZInterStore(string intoSetId, params string[] setIds);
            System.Int64 ZLexCount(string setId, string min, string max);
            System.Byte[][] ZRange(string setId, int min, int max);
            System.Byte[][] ZRangeByLex(string setId, string min, string max, int? skip = default(int?), int? take = default(int?));
            System.Byte[][] ZRangeByScore(string setId, double min, double max, int? skip, int? take);
            System.Byte[][] ZRangeByScore(string setId, System.Int64 min, System.Int64 max, int? skip, int? take);
            System.Byte[][] ZRangeByScoreWithScores(string setId, double min, double max, int? skip, int? take);
            System.Byte[][] ZRangeByScoreWithScores(string setId, System.Int64 min, System.Int64 max, int? skip, int? take);
            System.Byte[][] ZRangeWithScores(string setId, int min, int max);
            System.Int64 ZRank(string setId, System.Byte[] value);
            System.Int64 ZRem(string setId, System.Byte[][] values);
            System.Int64 ZRem(string setId, System.Byte[] value);
            System.Int64 ZRemRangeByLex(string setId, string min, string max);
            System.Int64 ZRemRangeByRank(string setId, int min, int max);
            System.Int64 ZRemRangeByScore(string setId, double fromScore, double toScore);
            System.Int64 ZRemRangeByScore(string setId, System.Int64 fromScore, System.Int64 toScore);
            System.Byte[][] ZRevRange(string setId, int min, int max);
            System.Byte[][] ZRevRangeByScore(string setId, double min, double max, int? skip, int? take);
            System.Byte[][] ZRevRangeByScore(string setId, System.Int64 min, System.Int64 max, int? skip, int? take);
            System.Byte[][] ZRevRangeByScoreWithScores(string setId, double min, double max, int? skip, int? take);
            System.Byte[][] ZRevRangeByScoreWithScores(string setId, System.Int64 min, System.Int64 max, int? skip, int? take);
            System.Byte[][] ZRevRangeWithScores(string setId, int min, int max);
            System.Int64 ZRevRank(string setId, System.Byte[] value);
            ServiceStack.Redis.ScanResult ZScan(string setId, System.UInt64 cursor, int count = default(int), string match = default(string));
            double ZScore(string setId, System.Byte[] value);
            System.Int64 ZUnionStore(string intoSetId, params string[] setIds);
        }

        // Generated from `ServiceStack.Redis.IRedisNativeClientAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisNativeClientAsync : System.IAsyncDisposable
        {
            System.Threading.Tasks.ValueTask<System.Int64> AppendAsync(string key, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> BLPopAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> BLPopAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> BLPopValueAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> BLPopValueAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> BRPopAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> BRPopAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> BRPopLPushAsync(string fromListId, string toListId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> BRPopValueAsync(string[] listIds, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> BRPopValueAsync(string listId, int timeOutSecs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask BgRewriteAofAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask BgSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> BitCountAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> CalculateSha1Async(string luaBody, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> ClientGetNameAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ClientKillAsync(string addr = default(string), string id = default(string), string type = default(string), string skipMe = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClientKillAsync(string host, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> ClientListAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClientPauseAsync(int timeOutMs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClientSetNameAsync(string client, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ConfigGetAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ConfigResetStatAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ConfigRewriteAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ConfigSetAsync(string item, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.IRedisSubscriptionAsync> CreateSubscriptionAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Int64 Db { get; }
            System.Threading.Tasks.ValueTask<System.Int64> DbSizeAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask DebugSegfaultAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> DecrAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> DecrByAsync(string key, System.Int64 decrBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> DelAsync(string[] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> DelAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> DelAsync(params string[] keys);
            System.Threading.Tasks.ValueTask<System.Byte[]> DumpAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> EchoAsync(string text, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> EvalAsync(string luaBody, int numberOfKeys, params System.Byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<System.Byte[][]> EvalAsync(string luaBody, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> EvalCommandAsync(string luaBody, int numberKeysInArgs, params System.Byte[][] keys);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> EvalCommandAsync(string luaBody, int numberKeysInArgs, System.Byte[][] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> EvalIntAsync(string luaBody, int numberOfKeys, params System.Byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<System.Int64> EvalIntAsync(string luaBody, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> EvalShaAsync(string sha1, int numberOfKeys, params System.Byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<System.Byte[][]> EvalShaAsync(string sha1, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> EvalShaCommandAsync(string sha1, int numberKeysInArgs, params System.Byte[][] keys);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> EvalShaCommandAsync(string sha1, int numberKeysInArgs, System.Byte[][] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> EvalShaIntAsync(string sha1, int numberOfKeys, params System.Byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<System.Int64> EvalShaIntAsync(string sha1, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> EvalShaStrAsync(string sha1, int numberOfKeys, params System.Byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<string> EvalShaStrAsync(string sha1, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> EvalStrAsync(string luaBody, int numberOfKeys, params System.Byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<string> EvalStrAsync(string luaBody, int numberOfKeys, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ExistsAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ExpireAsync(string key, int seconds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ExpireAtAsync(string key, System.Int64 unixTime, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask FlushAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask FlushDbAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GeoAddAsync(string key, params ServiceStack.Redis.RedisGeo[] geoPoints);
            System.Threading.Tasks.ValueTask<System.Int64> GeoAddAsync(string key, double longitude, double latitude, string member, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GeoAddAsync(string key, ServiceStack.Redis.RedisGeo[] geoPoints, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> GeoDistAsync(string key, string fromMember, string toMember, string unit = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string[]> GeoHashAsync(string key, string[] members, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string[]> GeoHashAsync(string key, params string[] members);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> GeoPosAsync(string key, string[] members, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeo>> GeoPosAsync(string key, params string[] members);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> GeoRadiusAsync(string key, double longitude, double latitude, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<ServiceStack.Redis.RedisGeoResult>> GeoRadiusByMemberAsync(string key, string member, double radius, string unit, bool withCoords = default(bool), bool withDist = default(bool), bool withHash = default(bool), int? count = default(int?), bool? asc = default(bool?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> GetAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetBitAsync(string key, int offset, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> GetRangeAsync(string key, int fromIndex, int toIndex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> GetSetAsync(string key, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> HDelAsync(string hashId, System.Byte[] key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> HExistsAsync(string hashId, System.Byte[] key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> HGetAllAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> HGetAsync(string hashId, System.Byte[] key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> HIncrbyAsync(string hashId, System.Byte[] key, int incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> HIncrbyFloatAsync(string hashId, System.Byte[] key, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> HKeysAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> HLenAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> HMGetAsync(string hashId, params System.Byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<System.Byte[][]> HMGetAsync(string hashId, System.Byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask HMSetAsync(string hashId, System.Byte[][] keys, System.Byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> HScanAsync(string hashId, System.UInt64 cursor, int count = default(int), string match = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> HSetAsync(string hashId, System.Byte[] key, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> HSetNXAsync(string hashId, System.Byte[] key, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> HValsAsync(string hashId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> IncrAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> IncrByAsync(string key, System.Int64 incrBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> IncrByFloatAsync(string key, double incrBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>> InfoAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> KeysAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> LIndexAsync(string listId, int listIndex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask LInsertAsync(string listId, bool insertBefore, System.Byte[] pivot, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> LLenAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> LPopAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> LPushAsync(string listId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> LPushXAsync(string listId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> LRangeAsync(string listId, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> LRemAsync(string listId, int removeNoOfMatches, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask LSetAsync(string listId, int listIndex, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask LTrimAsync(string listId, int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.DateTime> LastSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> MGetAsync(string[] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> MGetAsync(params string[] keys);
            System.Threading.Tasks.ValueTask<System.Byte[][]> MGetAsync(params System.Byte[][] keysAndArgs);
            System.Threading.Tasks.ValueTask<System.Byte[][]> MGetAsync(System.Byte[][] keysAndArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask MSetAsync(string[] keys, System.Byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask MSetAsync(System.Byte[][] keys, System.Byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> MSetNxAsync(string[] keys, System.Byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> MSetNxAsync(System.Byte[][] keys, System.Byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask MigrateAsync(string host, int port, string key, int destinationDb, System.Int64 timeoutMs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> MoveAsync(string key, int db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ObjectIdleTimeAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> PExpireAsync(string key, System.Int64 ttlMs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> PExpireAtAsync(string key, System.Int64 unixTimeMs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PSetExAsync(string key, System.Int64 expireInMs, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> PSubscribeAsync(string[] toChannelsMatchingPatterns, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> PSubscribeAsync(params string[] toChannelsMatchingPatterns);
            System.Threading.Tasks.ValueTask<System.Int64> PTtlAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> PUnSubscribeAsync(string[] toChannelsMatchingPatterns, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> PUnSubscribeAsync(params string[] toChannelsMatchingPatterns);
            System.Threading.Tasks.ValueTask<bool> PersistAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> PfAddAsync(string key, params System.Byte[][] elements);
            System.Threading.Tasks.ValueTask<bool> PfAddAsync(string key, System.Byte[][] elements, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> PfCountAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PfMergeAsync(string toKeyId, string[] fromKeys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask PfMergeAsync(string toKeyId, params string[] fromKeys);
            System.Threading.Tasks.ValueTask<bool> PingAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> PublishAsync(string toChannel, System.Byte[] message, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask QuitAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> RPopAsync(string listId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> RPopLPushAsync(string fromListId, string toListId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RPushAsync(string listId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> RPushXAsync(string listId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> RandomKeyAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> RawCommandAsync(params object[] cmdWithArgs);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> RawCommandAsync(params System.Byte[][] cmdWithBinaryArgs);
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> RawCommandAsync(object[] cmdWithArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData> RawCommandAsync(System.Byte[][] cmdWithBinaryArgs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ReceiveMessagesAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RenameAsync(string oldKeyname, string newKeyname, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RenameNxAsync(string oldKeyname, string newKeyname, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> RestoreAsync(string key, System.Int64 expireMs, System.Byte[] dumpValue, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText> RoleAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> SAddAsync(string setId, System.Byte[][] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> SAddAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> SCardAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SDiffAsync(string fromSetId, string[] withSetIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SDiffAsync(string fromSetId, params string[] withSetIds);
            System.Threading.Tasks.ValueTask SDiffStoreAsync(string intoSetId, string fromSetId, string[] withSetIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SDiffStoreAsync(string intoSetId, string fromSetId, params string[] withSetIds);
            System.Threading.Tasks.ValueTask<System.Byte[][]> SInterAsync(string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SInterAsync(params string[] setIds);
            System.Threading.Tasks.ValueTask SInterStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SInterStoreAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<System.Int64> SIsMemberAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SMembersAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SMoveAsync(string fromSetId, string toSetId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SPopAsync(string setId, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> SPopAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> SRandMemberAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> SRemAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> SScanAsync(string setId, System.UInt64 cursor, int count = default(int), string match = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SUnionAsync(string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SUnionAsync(params string[] setIds);
            System.Threading.Tasks.ValueTask SUnionStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SUnionStoreAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask SaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> ScanAsync(System.UInt64 cursor, int count = default(int), string match = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ScriptExistsAsync(params System.Byte[][] sha1Refs);
            System.Threading.Tasks.ValueTask<System.Byte[][]> ScriptExistsAsync(System.Byte[][] sha1Refs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ScriptFlushAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ScriptKillAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[]> ScriptLoadAsync(string body, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SelectAsync(System.Int64 db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> SetAsync(string key, System.Byte[] value, bool exists, System.Int64 expirySeconds = default(System.Int64), System.Int64 expiryMilliseconds = default(System.Int64), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetAsync(string key, System.Byte[] value, System.Int64 expirySeconds = default(System.Int64), System.Int64 expiryMilliseconds = default(System.Int64), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> SetBitAsync(string key, int offset, int value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SetExAsync(string key, int expireInSeconds, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> SetNXAsync(string key, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> SetRangeAsync(string key, int offset, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ShutdownAsync(bool noSave = default(bool), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SlaveOfAsync(string hostname, int port, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SlaveOfNoOneAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<object[]> SlowlogGetAsync(int? top = default(int?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SlowlogResetAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SortAsync(string listOrSetId, ServiceStack.Redis.SortOptions sortOptions, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> StrLenAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SubscribeAsync(string[] toChannels, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> SubscribeAsync(params string[] toChannels);
            System.Threading.Tasks.ValueTask<System.Byte[][]> TimeAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> TtlAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> TypeAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> UnSubscribeAsync(string[] toChannels, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> UnSubscribeAsync(params string[] toChannels);
            System.Threading.Tasks.ValueTask UnWatchAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask WatchAsync(string[] keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask WatchAsync(params string[] keys);
            System.Threading.Tasks.ValueTask<System.Int64> ZAddAsync(string setId, double score, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZAddAsync(string setId, System.Int64 score, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZCardAsync(string setId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZCountAsync(string setId, double min, double max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> ZIncrByAsync(string setId, double incrBy, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> ZIncrByAsync(string setId, System.Int64 incrBy, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZInterStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZInterStoreAsync(string intoSetId, params string[] setIds);
            System.Threading.Tasks.ValueTask<System.Int64> ZLexCountAsync(string setId, string min, string max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRangeAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRangeByLexAsync(string setId, string min, string max, int? skip = default(int?), int? take = default(int?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRangeByScoreAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRangeByScoreAsync(string setId, System.Int64 min, System.Int64 max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRangeByScoreWithScoresAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRangeByScoreWithScoresAsync(string setId, System.Int64 min, System.Int64 max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRangeWithScoresAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZRankAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZRemAsync(string setId, System.Byte[][] values, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZRemAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZRemRangeByLexAsync(string setId, string min, string max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZRemRangeByRankAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZRemRangeByScoreAsync(string setId, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZRemRangeByScoreAsync(string setId, System.Int64 fromScore, System.Int64 toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRevRangeAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRevRangeByScoreAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRevRangeByScoreAsync(string setId, System.Int64 min, System.Int64 max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRevRangeByScoreWithScoresAsync(string setId, double min, double max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRevRangeByScoreWithScoresAsync(string setId, System.Int64 min, System.Int64 max, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Byte[][]> ZRevRangeWithScoresAsync(string setId, int min, int max, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZRevRankAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<ServiceStack.Redis.ScanResult> ZScanAsync(string setId, System.UInt64 cursor, int count = default(int), string match = default(string), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> ZScoreAsync(string setId, System.Byte[] value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZUnionStoreAsync(string intoSetId, string[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> ZUnionStoreAsync(string intoSetId, params string[] setIds);
        }

        // Generated from `ServiceStack.Redis.IRedisPubSubServer` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisPubSubServer : System.IDisposable
        {
            string[] Channels { get; }
            ServiceStack.Redis.IRedisClientsManager ClientsManager { get; }
            System.DateTime CurrentServerTime { get; }
            string GetStatsDescription();
            string GetStatus();
            System.Action OnDispose { get; set; }
            System.Action<System.Exception> OnError { get; set; }
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

        // Generated from `ServiceStack.Redis.IRedisSet` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisSet : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<string>, System.Collections.Generic.ICollection<string>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
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

        // Generated from `ServiceStack.Redis.IRedisSetAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisSetAsync : System.Collections.Generic.IAsyncEnumerable<string>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
        {
            System.Threading.Tasks.ValueTask AddAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ContainsAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> DiffAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> GetRandomEntryAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeFromSortedSetAsync(int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> IntersectAsync(params ServiceStack.Redis.IRedisSetAsync[] withSets);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> IntersectAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask MoveAsync(string value, ServiceStack.Redis.IRedisSetAsync toSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreDiffAsync(ServiceStack.Redis.IRedisSetAsync fromSet, params ServiceStack.Redis.IRedisSetAsync[] withSets);
            System.Threading.Tasks.ValueTask StoreDiffAsync(ServiceStack.Redis.IRedisSetAsync fromSet, ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreIntersectAsync(params ServiceStack.Redis.IRedisSetAsync[] withSets);
            System.Threading.Tasks.ValueTask StoreIntersectAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreUnionAsync(params ServiceStack.Redis.IRedisSetAsync[] withSets);
            System.Threading.Tasks.ValueTask StoreUnionAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> UnionAsync(params ServiceStack.Redis.IRedisSetAsync[] withSets);
            System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>> UnionAsync(ServiceStack.Redis.IRedisSetAsync[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Redis.IRedisSortedSet` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisSortedSet : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<string>, System.Collections.Generic.ICollection<string>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
        {
            System.Collections.Generic.List<string> GetAll();
            System.Int64 GetItemIndex(string value);
            double GetItemScore(string value);
            System.Collections.Generic.List<string> GetRange(int startingRank, int endingRank);
            System.Collections.Generic.List<string> GetRangeByScore(string fromStringScore, string toStringScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeByScore(string fromStringScore, string toStringScore);
            System.Collections.Generic.List<string> GetRangeByScore(double fromScore, double toScore, int? skip, int? take);
            System.Collections.Generic.List<string> GetRangeByScore(double fromScore, double toScore);
            void IncrementItemScore(string value, double incrementByScore);
            string PopItemWithHighestScore();
            string PopItemWithLowestScore();
            void RemoveRange(int fromRank, int toRank);
            void RemoveRangeByScore(double fromScore, double toScore);
            void StoreFromIntersect(params ServiceStack.Redis.IRedisSortedSet[] ofSets);
            void StoreFromUnion(params ServiceStack.Redis.IRedisSortedSet[] ofSets);
        }

        // Generated from `ServiceStack.Redis.IRedisSortedSetAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisSortedSetAsync : System.Collections.Generic.IAsyncEnumerable<string>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
        {
            System.Threading.Tasks.ValueTask AddAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> ContainsAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Int64> GetItemIndexAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<double> GetItemScoreAsync(string value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeAsync(int startingRank, int endingRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeByScoreAsync(string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeByScoreAsync(string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeByScoreAsync(double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>> GetRangeByScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask IncrementItemScoreAsync(string value, double incrementByScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopItemWithHighestScoreAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<string> PopItemWithLowestScoreAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask<bool> RemoveAsync(string item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveRangeAsync(int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RemoveRangeByScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreFromIntersectAsync(params ServiceStack.Redis.IRedisSortedSetAsync[] ofSets);
            System.Threading.Tasks.ValueTask StoreFromIntersectAsync(ServiceStack.Redis.IRedisSortedSetAsync[] ofSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask StoreFromUnionAsync(params ServiceStack.Redis.IRedisSortedSetAsync[] ofSets);
            System.Threading.Tasks.ValueTask StoreFromUnionAsync(ServiceStack.Redis.IRedisSortedSetAsync[] ofSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Redis.IRedisSubscription` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisSubscription : System.IDisposable
        {
            System.Action<string, string> OnMessage { get; set; }
            System.Action<string, System.Byte[]> OnMessageBytes { get; set; }
            System.Action<string> OnSubscribe { get; set; }
            System.Action<string> OnUnSubscribe { get; set; }
            void SubscribeToChannels(params string[] channels);
            void SubscribeToChannelsMatching(params string[] patterns);
            System.Int64 SubscriptionCount { get; }
            void UnSubscribeFromAllChannels();
            void UnSubscribeFromChannels(params string[] channels);
            void UnSubscribeFromChannelsMatching(params string[] patterns);
        }

        // Generated from `ServiceStack.Redis.IRedisSubscriptionAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisSubscriptionAsync : System.IAsyncDisposable
        {
            event System.Func<string, string, System.Threading.Tasks.ValueTask> OnMessageAsync;
            event System.Func<string, System.Byte[], System.Threading.Tasks.ValueTask> OnMessageBytesAsync;
            event System.Func<string, System.Threading.Tasks.ValueTask> OnSubscribeAsync;
            event System.Func<string, System.Threading.Tasks.ValueTask> OnUnSubscribeAsync;
            System.Threading.Tasks.ValueTask SubscribeToChannelsAsync(string[] channels, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SubscribeToChannelsAsync(params string[] channels);
            System.Threading.Tasks.ValueTask SubscribeToChannelsMatchingAsync(string[] patterns, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask SubscribeToChannelsMatchingAsync(params string[] patterns);
            System.Int64 SubscriptionCount { get; }
            System.Threading.Tasks.ValueTask UnSubscribeFromAllChannelsAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask UnSubscribeFromChannelsAsync(string[] channels, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask UnSubscribeFromChannelsAsync(params string[] channels);
            System.Threading.Tasks.ValueTask UnSubscribeFromChannelsMatchingAsync(string[] patterns, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask UnSubscribeFromChannelsMatchingAsync(params string[] patterns);
        }

        // Generated from `ServiceStack.Redis.IRedisTransaction` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisTransaction : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisQueueableOperation, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation, ServiceStack.Redis.Pipeline.IRedisPipelineShared, ServiceStack.Redis.IRedisTransactionBase
        {
            bool Commit();
            void Rollback();
        }

        // Generated from `ServiceStack.Redis.IRedisTransactionAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisTransactionAsync : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync, ServiceStack.Redis.IRedisTransactionBaseAsync
        {
            System.Threading.Tasks.ValueTask<bool> CommitAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            System.Threading.Tasks.ValueTask RollbackAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Redis.IRedisTransactionBase` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisTransactionBase : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation, ServiceStack.Redis.Pipeline.IRedisPipelineShared
        {
        }

        // Generated from `ServiceStack.Redis.IRedisTransactionBaseAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRedisTransactionBaseAsync : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync
        {
        }

        // Generated from `ServiceStack.Redis.ItemRef` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ItemRef
        {
            public string Id { get => throw null; set => throw null; }
            public string Item { get => throw null; set => throw null; }
            public ItemRef() => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisClientType` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public enum RedisClientType
        {
            Normal,
            PubSub,
            Slave,
        }

        // Generated from `ServiceStack.Redis.RedisData` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisData
        {
            public System.Collections.Generic.List<ServiceStack.Redis.RedisData> Children { get => throw null; set => throw null; }
            public System.Byte[] Data { get => throw null; set => throw null; }
            public RedisData() => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisGeo` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisGeo
        {
            public double Latitude { get => throw null; set => throw null; }
            public double Longitude { get => throw null; set => throw null; }
            public string Member { get => throw null; set => throw null; }
            public RedisGeo(double longitude, double latitude, string member) => throw null;
            public RedisGeo() => throw null;
        }

        // Generated from `ServiceStack.Redis.RedisGeoResult` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisGeoResult
        {
            public double Distance { get => throw null; set => throw null; }
            public System.Int64 Hash { get => throw null; set => throw null; }
            public double Latitude { get => throw null; set => throw null; }
            public double Longitude { get => throw null; set => throw null; }
            public string Member { get => throw null; set => throw null; }
            public RedisGeoResult() => throw null;
            public string Unit { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Redis.RedisGeoUnit` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public static class RedisGeoUnit
        {
            public const string Feet = default;
            public const string Kilometers = default;
            public const string Meters = default;
            public const string Miles = default;
        }

        // Generated from `ServiceStack.Redis.RedisKeyType` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public enum RedisKeyType
        {
            Hash,
            List,
            None,
            Set,
            SortedSet,
            String,
        }

        // Generated from `ServiceStack.Redis.RedisServerRole` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public enum RedisServerRole
        {
            Master,
            Sentinel,
            Slave,
            Unknown,
        }

        // Generated from `ServiceStack.Redis.RedisText` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class RedisText
        {
            public System.Collections.Generic.List<ServiceStack.Redis.RedisText> Children { get => throw null; set => throw null; }
            public RedisText() => throw null;
            public string Text { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Redis.ScanResult` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class ScanResult
        {
            public System.UInt64 Cursor { get => throw null; set => throw null; }
            public System.Collections.Generic.List<System.Byte[]> Results { get => throw null; set => throw null; }
            public ScanResult() => throw null;
        }

        // Generated from `ServiceStack.Redis.SlowlogItem` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class SlowlogItem
        {
            public string[] Arguments { get => throw null; set => throw null; }
            public int Duration { get => throw null; set => throw null; }
            public int Id { get => throw null; set => throw null; }
            public SlowlogItem(int id, System.DateTime timeStamp, int duration, string[] arguments) => throw null;
            public System.DateTime Timestamp { get => throw null; set => throw null; }
        }

        // Generated from `ServiceStack.Redis.SortOptions` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public class SortOptions
        {
            public string GetPattern { get => throw null; set => throw null; }
            public int? Skip { get => throw null; set => throw null; }
            public bool SortAlpha { get => throw null; set => throw null; }
            public bool SortDesc { get => throw null; set => throw null; }
            public SortOptions() => throw null;
            public string SortPattern { get => throw null; set => throw null; }
            public string StoreAtKey { get => throw null; set => throw null; }
            public int? Take { get => throw null; set => throw null; }
        }

        namespace Generic
        {
            // Generated from `ServiceStack.Redis.Generic.IRedisHash<,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisHash<TKey, TValue> : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, System.Collections.Generic.IDictionary<TKey, TValue>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey, TValue>>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
            {
                System.Collections.Generic.Dictionary<TKey, TValue> GetAll();
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisHashAsync<,>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisHashAsync<TKey, TValue> : System.Collections.Generic.IAsyncEnumerable<System.Collections.Generic.KeyValuePair<TKey, TValue>>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
            {
                System.Threading.Tasks.ValueTask AddAsync(TKey key, TValue value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddAsync(System.Collections.Generic.KeyValuePair<TKey, TValue> item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ContainsKeyAsync(TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<TKey, TValue>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveAsync(TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisList<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisList<T> : System.Collections.IEnumerable, System.Collections.Generic.IList<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.ICollection<T>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
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
                System.Int64 RemoveValue(T value, int noOfMatches);
                System.Int64 RemoveValue(T value);
                void Trim(int keepStartingFrom, int keepEndingAt);
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisListAsync<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisListAsync<T> : System.Collections.Generic.IAsyncEnumerable<T>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
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
                System.Threading.Tasks.ValueTask<System.Int64> RemoveValueAsync(T value, int noOfMatches, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> RemoveValueAsync(T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetValueAsync(int index, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask TrimAsync(int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisSet<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisSet<T> : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.ICollection<T>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
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

            // Generated from `ServiceStack.Redis.Generic.IRedisSetAsync<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisSetAsync<T> : System.Collections.Generic.IAsyncEnumerable<T>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
            {
                System.Threading.Tasks.ValueTask AddAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask ClearAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ContainsAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<int> CountAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetAllAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask GetDifferencesAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets);
                System.Threading.Tasks.ValueTask GetDifferencesAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetRandomItemAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask MoveToAsync(T item, ServiceStack.Redis.Generic.IRedisSetAsync<T> toSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopRandomItemAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PopulateWithDifferencesOfAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets);
                System.Threading.Tasks.ValueTask PopulateWithDifferencesOfAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PopulateWithIntersectOfAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask PopulateWithIntersectOfAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask PopulateWithUnionOfAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask PopulateWithUnionOfAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> SortAsync(int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisSortedSet<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisSortedSet<T> : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.ICollection<T>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
            {
                void Add(T item, double score);
                System.Collections.Generic.List<T> GetAll();
                System.Collections.Generic.List<T> GetAllDescending();
                double GetItemScore(T item);
                System.Collections.Generic.List<T> GetRange(int fromRank, int toRank);
                System.Collections.Generic.List<T> GetRangeByHighestScore(double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeByHighestScore(double fromScore, double toScore);
                System.Collections.Generic.List<T> GetRangeByLowestScore(double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeByLowestScore(double fromScore, double toScore);
                double IncrementItem(T item, double incrementBy);
                int IndexOf(T item);
                System.Int64 IndexOfDescending(T item);
                T PopItemWithHighestScore();
                T PopItemWithLowestScore();
                System.Int64 PopulateWithIntersectOf(params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds);
                System.Int64 PopulateWithIntersectOf(ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args);
                System.Int64 PopulateWithUnionOf(params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds);
                System.Int64 PopulateWithUnionOf(ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args);
                System.Int64 RemoveRange(int minRank, int maxRank);
                System.Int64 RemoveRangeByScore(double fromScore, double toScore);
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisSortedSetAsync<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisSortedSetAsync<T> : System.Collections.Generic.IAsyncEnumerable<T>, ServiceStack.Model.IHasStringId, ServiceStack.Model.IHasId<string>
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
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeByHighestScoreAsync(double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeByHighestScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeByLowestScoreAsync(double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeByLowestScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<double> IncrementItemAsync(T item, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<int> IndexOfAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> IndexOfDescendingAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopItemWithHighestScoreAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> PopItemWithLowestScoreAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> PopulateWithIntersectOfAsync(params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds);
                System.Threading.Tasks.ValueTask<System.Int64> PopulateWithIntersectOfAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> PopulateWithIntersectOfAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> PopulateWithUnionOfAsync(params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds);
                System.Threading.Tasks.ValueTask<System.Int64> PopulateWithUnionOfAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> PopulateWithUnionOfAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveAsync(T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> RemoveRangeAsync(int minRank, int maxRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> RemoveRangeByScoreAsync(double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisTypedClient<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisTypedClient<T> : ServiceStack.Data.IEntityStore<T>
            {
                System.IDisposable AcquireLock(System.TimeSpan timeOut);
                System.IDisposable AcquireLock();
                void AddItemToList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value);
                void AddItemToSet(ServiceStack.Redis.Generic.IRedisSet<T> toSet, T item);
                void AddItemToSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> toSet, T value, double score);
                void AddItemToSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> toSet, T value);
                void AddToRecentsList(T value);
                T BlockingDequeueItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.TimeSpan? timeOut);
                T BlockingPopAndPushItemBetweenLists(ServiceStack.Redis.Generic.IRedisList<T> fromList, ServiceStack.Redis.Generic.IRedisList<T> toList, System.TimeSpan? timeOut);
                T BlockingPopItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.TimeSpan? timeOut);
                T BlockingRemoveStartFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, System.TimeSpan? timeOut);
                bool ContainsKey(string key);
                ServiceStack.Redis.Generic.IRedisTypedPipeline<T> CreatePipeline();
                ServiceStack.Redis.Generic.IRedisTypedTransaction<T> CreateTransaction();
                System.Int64 Db { get; set; }
                System.Int64 DecrementValue(string key);
                System.Int64 DecrementValueBy(string key, int count);
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
                System.Int64 GetHashCount<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash);
                System.Collections.Generic.List<TKey> GetHashKeys<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash);
                System.Collections.Generic.List<T> GetHashValues<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash);
                System.Collections.Generic.HashSet<T> GetIntersectFromSets(params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                T GetItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int listIndex);
                System.Int64 GetItemIndexInSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value);
                System.Int64 GetItemIndexInSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value);
                double GetItemScoreInSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value);
                System.Collections.Generic.List<T> GetLatestFromRecentsList(int skip, int take);
                System.Int64 GetListCount(ServiceStack.Redis.Generic.IRedisList<T> fromList);
                System.Int64 GetNextSequence(int incrBy);
                System.Int64 GetNextSequence();
                T GetRandomItemFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet);
                string GetRandomKey();
                System.Collections.Generic.List<T> GetRangeFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int startingFrom, int endingAt);
                System.Collections.Generic.List<T> GetRangeFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.List<T> GetRangeFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
                System.Collections.Generic.List<T> GetRangeFromSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByHighestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore, int? skip, int? take);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, string fromStringScore, string toStringScore);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore, int? skip, int? take);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetByLowestScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
                System.Collections.Generic.IDictionary<T, double> GetRangeWithScoresFromSortedSetDesc(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int fromRank, int toRank);
                System.Collections.Generic.List<TChild> GetRelatedEntities<TChild>(object parentId);
                System.Int64 GetRelatedEntitiesCount<TChild>(object parentId);
                System.Int64 GetSetCount(ServiceStack.Redis.Generic.IRedisSet<T> set);
                System.Collections.Generic.List<T> GetSortedEntryValues(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, int startingFrom, int endingAt);
                System.Int64 GetSortedSetCount(ServiceStack.Redis.Generic.IRedisSortedSet<T> set);
                System.TimeSpan GetTimeToLive(string key);
                System.Collections.Generic.HashSet<T> GetUnionFromSets(params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                T GetValue(string key);
                T GetValueFromHash<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key);
                System.Collections.Generic.List<T> GetValues(System.Collections.Generic.List<string> keys);
                bool HashContainsEntry<TKey>(ServiceStack.Redis.Generic.IRedisHash<TKey, T> hash, TKey key);
                double IncrementItemInSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value, double incrementBy);
                System.Int64 IncrementValue(string key);
                System.Int64 IncrementValueBy(string key, int count);
                void InsertAfterItemInList(ServiceStack.Redis.Generic.IRedisList<T> toList, T pivot, T value);
                void InsertBeforeItemInList(ServiceStack.Redis.Generic.IRedisList<T> toList, T pivot, T value);
                T this[string key] { get; set; }
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
                System.Int64 RemoveItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value, int noOfMatches);
                System.Int64 RemoveItemFromList(ServiceStack.Redis.Generic.IRedisList<T> fromList, T value);
                void RemoveItemFromSet(ServiceStack.Redis.Generic.IRedisSet<T> fromSet, T item);
                bool RemoveItemFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> fromSet, T value);
                System.Int64 RemoveRangeFromSortedSet(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, int minRank, int maxRank);
                System.Int64 RemoveRangeFromSortedSetByScore(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, double fromScore, double toScore);
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
                void SetSequence(int value);
                void SetValue(string key, T entity, System.TimeSpan expireIn);
                void SetValue(string key, T entity);
                bool SetValueIfExists(string key, T entity);
                bool SetValueIfNotExists(string key, T entity);
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSet<T>> Sets { get; set; }
                System.Collections.Generic.List<T> SortList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int startingFrom, int endingAt);
                bool SortedSetContainsItem(ServiceStack.Redis.Generic.IRedisSortedSet<T> set, T value);
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSortedSet<T>> SortedSets { get; set; }
                T Store(T entity, System.TimeSpan expireIn);
                void StoreAsHash(T entity);
                void StoreDifferencesFromSet(ServiceStack.Redis.Generic.IRedisSet<T> intoSet, ServiceStack.Redis.Generic.IRedisSet<T> fromSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] withSets);
                void StoreIntersectFromSets(ServiceStack.Redis.Generic.IRedisSet<T> intoSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                System.Int64 StoreIntersectFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds);
                System.Int64 StoreIntersectFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args);
                void StoreRelatedEntities<TChild>(object parentId, params TChild[] children);
                void StoreRelatedEntities<TChild>(object parentId, System.Collections.Generic.List<TChild> children);
                void StoreUnionFromSets(ServiceStack.Redis.Generic.IRedisSet<T> intoSet, params ServiceStack.Redis.Generic.IRedisSet<T>[] sets);
                System.Int64 StoreUnionFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds);
                System.Int64 StoreUnionFromSortedSets(ServiceStack.Redis.Generic.IRedisSortedSet<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSet<T>[] setIds, string[] args);
                void TrimList(ServiceStack.Redis.Generic.IRedisList<T> fromList, int keepStartingFrom, int keepEndingAt);
                ServiceStack.Redis.IRedisSet TypeIdsSet { get; }
                string UrnKey(T value);
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisTypedClientAsync<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisTypedClientAsync<T> : ServiceStack.Data.IEntityStoreAsync<T>
            {
                System.Threading.Tasks.ValueTask<System.IAsyncDisposable> AcquireLockAsync(System.TimeSpan? timeOut = default(System.TimeSpan?), System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddItemToListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddItemToSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> toSet, T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddItemToSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> toSet, T value, double score, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddItemToSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> toSet, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask AddToRecentsListAsync(T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask BackgroundSaveAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingDequeueItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingPopAndPushItemBetweenListsAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, ServiceStack.Redis.Generic.IRedisListAsync<T> toList, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingPopItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> BlockingRemoveStartFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.TimeSpan? timeOut, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ContainsKeyAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Redis.Generic.IRedisTypedPipelineAsync<T> CreatePipeline();
                System.Threading.Tasks.ValueTask<ServiceStack.Redis.Generic.IRedisTypedTransactionAsync<T>> CreateTransactionAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Int64 Db { get; }
                System.Threading.Tasks.ValueTask<System.Int64> DecrementValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> DecrementValueByAsync(string key, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
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
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets);
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetEarliestFromRecentsListAsync(int skip, int take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisKeyType> GetEntryTypeAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetFromHashAsync(object id, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> GetHash<TKey>(string hashId);
                System.Threading.Tasks.ValueTask<System.Int64> GetHashCountAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<TKey>> GetHashKeysAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetHashValuesAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetIntersectFromSetsAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetIntersectFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int listIndex, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> GetItemIndexInSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> GetItemIndexInSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<double> GetItemScoreInSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetLatestFromRecentsListAsync(int skip, int take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> GetListCountAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> GetNextSequenceAsync(int incrBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> GetNextSequenceAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetRandomItemFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<string> GetRandomKeyAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetRangeFromSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByHighestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, string fromStringScore, string toStringScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, int? skip, int? take, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetByLowestScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.IDictionary<T, double>> GetRangeWithScoresFromSortedSetDescAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int fromRank, int toRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<TChild>> GetRelatedEntitiesAsync<TChild>(object parentId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> GetRelatedEntitiesCountAsync<TChild>(object parentId, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> GetSetCountAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> set, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetSortedEntryValuesAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> GetSortedSetCountAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.TimeSpan> GetTimeToLiveAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetUnionFromSetsAsync(params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<T>> GetUnionFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> GetValueFromHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> GetValuesAsync(System.Collections.Generic.List<string> keys, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> HashContainsEntryAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<double> IncrementItemInSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, double incrementBy, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> IncrementValueAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> IncrementValueByAsync(string key, int count, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
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
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(string key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(params string[] args);
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(params ServiceStack.Model.IHasStringId[] entities);
                System.Threading.Tasks.ValueTask<bool> RemoveEntryAsync(ServiceStack.Model.IHasStringId[] entities, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveEntryFromHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> RemoveItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, int noOfMatches, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> RemoveItemFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask RemoveItemFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> RemoveItemFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> fromSet, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> RemoveRangeFromSortedSetAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, int minRank, int maxRank, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> RemoveRangeFromSortedSetByScoreAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, double fromScore, double toScore, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> RemoveStartFromListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T[]> SearchKeysAsync(string pattern, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SelectAsync(System.Int64 db, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                string SequenceKey { get; set; }
                System.Threading.Tasks.ValueTask<bool> SetContainsItemAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> set, T item, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SetEntryInHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SetEntryInHashIfNotExistsAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, TKey key, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetItemInListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> toList, int listIndex, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetRangeInHashAsync<TKey>(ServiceStack.Redis.Generic.IRedisHashAsync<TKey, T> hash, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey, T>> keyValuePairs, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetSequenceAsync(int value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetValueAsync(string key, T entity, System.TimeSpan expireIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask SetValueAsync(string key, T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SetValueIfExistsAsync(string key, T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SetValueIfNotExistsAsync(string key, T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSetAsync<T>> Sets { get; }
                System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>> SortListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int startingFrom, int endingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> SortedSetContainsItemAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> set, T value, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Model.IHasNamed<ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>> SortedSets { get; }
                System.Threading.Tasks.ValueTask StoreAsHashAsync(T entity, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<T> StoreAsync(T entity, System.TimeSpan expireIn, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets);
                System.Threading.Tasks.ValueTask StoreDifferencesFromSetAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T> fromSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] withSets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreIntersectFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask StoreIntersectFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> StoreIntersectFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds);
                System.Threading.Tasks.ValueTask<System.Int64> StoreIntersectFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> StoreIntersectFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreRelatedEntitiesAsync<TChild>(object parentId, params TChild[] children);
                System.Threading.Tasks.ValueTask StoreRelatedEntitiesAsync<TChild>(object parentId, TChild[] children, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreRelatedEntitiesAsync<TChild>(object parentId, System.Collections.Generic.List<TChild> children, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask StoreUnionFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, params ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets);
                System.Threading.Tasks.ValueTask StoreUnionFromSetsAsync(ServiceStack.Redis.Generic.IRedisSetAsync<T> intoSet, ServiceStack.Redis.Generic.IRedisSetAsync<T>[] sets, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> StoreUnionFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, params ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds);
                System.Threading.Tasks.ValueTask<System.Int64> StoreUnionFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, string[] args, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<System.Int64> StoreUnionFromSortedSetsAsync(ServiceStack.Redis.Generic.IRedisSortedSetAsync<T> intoSetId, ServiceStack.Redis.Generic.IRedisSortedSetAsync<T>[] setIds, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask TrimListAsync(ServiceStack.Redis.Generic.IRedisListAsync<T> fromList, int keepStartingFrom, int keepEndingAt, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                ServiceStack.Redis.IRedisSetAsync TypeIdsSet { get; }
                string UrnKey(T value);
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisTypedPipeline<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisTypedPipeline<T> : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation, ServiceStack.Redis.Pipeline.IRedisPipelineShared, ServiceStack.Redis.Generic.IRedisTypedQueueableOperation<T>
            {
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisTypedPipelineAsync<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisTypedPipelineAsync<T> : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync, ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>
            {
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisTypedQueueableOperation<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisTypedQueueableOperation<T>
            {
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, string> command, System.Action<string> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, string> command, System.Action<string> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, string> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, int> command, System.Action<int> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, int> command, System.Action<int> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, int> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, double> command, System.Action<double> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, double> command, System.Action<double> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, double> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, bool> command, System.Action<bool> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, bool> command, System.Action<bool> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, bool> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> command, System.Action<T> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> command, System.Action<T> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, T> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Int64> command, System.Action<System.Int64> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Int64> command, System.Action<System.Int64> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Int64> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> command, System.Action<System.Collections.Generic.List<T>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> command, System.Action<System.Collections.Generic.List<T>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.List<T>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Collections.Generic.HashSet<string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Byte[]> command, System.Action<System.Byte[]> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Byte[]> command, System.Action<System.Byte[]> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClient<T>, System.Byte[]> command);
                void QueueCommand(System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> command, System.Action onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> command, System.Action onSuccessCallback);
                void QueueCommand(System.Action<ServiceStack.Redis.Generic.IRedisTypedClient<T>> command);
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisTypedQueueableOperationAsync<T>
            {
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask> command, System.Action onSuccessCallback = default(System.Action), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<string>> command, System.Action<string> onSuccessCallback = default(System.Action<string>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<int>> command, System.Action<int> onSuccessCallback = default(System.Action<int>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<double>> command, System.Action<double> onSuccessCallback = default(System.Action<double>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<bool>> command, System.Action<bool> onSuccessCallback = default(System.Action<bool>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<T>> command, System.Action<T> onSuccessCallback = default(System.Action<T>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Int64>> command, System.Action<System.Int64> onSuccessCallback = default(System.Action<System.Int64>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback = default(System.Action<System.Collections.Generic.List<string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<T>>> command, System.Action<System.Collections.Generic.List<T>> onSuccessCallback = default(System.Action<System.Collections.Generic.List<T>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback = default(System.Action<System.Collections.Generic.HashSet<string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.Generic.IRedisTypedClientAsync<T>, System.Threading.Tasks.ValueTask<System.Byte[]>> command, System.Action<System.Byte[]> onSuccessCallback = default(System.Action<System.Byte[]>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisTypedTransaction<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisTypedTransaction<T> : System.IDisposable, ServiceStack.Redis.Generic.IRedisTypedQueueableOperation<T>
            {
                bool Commit();
                void Rollback();
            }

            // Generated from `ServiceStack.Redis.Generic.IRedisTypedTransactionAsync<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisTypedTransactionAsync<T> : System.IAsyncDisposable, ServiceStack.Redis.Generic.IRedisTypedQueueableOperationAsync<T>
            {
                System.Threading.Tasks.ValueTask<bool> CommitAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask RollbackAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }

        }
        namespace Pipeline
        {
            // Generated from `ServiceStack.Redis.Pipeline.IRedisPipeline` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisPipeline : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisQueueableOperation, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation, ServiceStack.Redis.Pipeline.IRedisPipelineShared
            {
            }

            // Generated from `ServiceStack.Redis.Pipeline.IRedisPipelineAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisPipelineAsync : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync, ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync
            {
            }

            // Generated from `ServiceStack.Redis.Pipeline.IRedisPipelineShared` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisPipelineShared : System.IDisposable, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation
            {
                void Flush();
                bool Replay();
            }

            // Generated from `ServiceStack.Redis.Pipeline.IRedisPipelineSharedAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisPipelineSharedAsync : System.IAsyncDisposable, ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync
            {
                System.Threading.Tasks.ValueTask FlushAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
                System.Threading.Tasks.ValueTask<bool> ReplayAsync(System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
            }

            // Generated from `ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperation` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisQueueCompletableOperation
            {
                void CompleteBytesQueuedCommand(System.Func<System.Byte[]> bytesReadCommand);
                void CompleteDoubleQueuedCommand(System.Func<double> doubleReadCommand);
                void CompleteIntQueuedCommand(System.Func<int> intReadCommand);
                void CompleteLongQueuedCommand(System.Func<System.Int64> longReadCommand);
                void CompleteMultiBytesQueuedCommand(System.Func<System.Byte[][]> multiBytesReadCommand);
                void CompleteMultiStringQueuedCommand(System.Func<System.Collections.Generic.List<string>> multiStringReadCommand);
                void CompleteRedisDataQueuedCommand(System.Func<ServiceStack.Redis.RedisData> redisDataReadCommand);
                void CompleteStringQueuedCommand(System.Func<string> stringReadCommand);
                void CompleteVoidQueuedCommand(System.Action voidReadCommand);
            }

            // Generated from `ServiceStack.Redis.Pipeline.IRedisQueueCompletableOperationAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisQueueCompletableOperationAsync
            {
                void CompleteBytesQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Byte[]>> bytesReadCommand);
                void CompleteDoubleQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<double>> doubleReadCommand);
                void CompleteIntQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<int>> intReadCommand);
                void CompleteLongQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Int64>> longReadCommand);
                void CompleteMultiBytesQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Byte[][]>> multiBytesReadCommand);
                void CompleteMultiStringQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> multiStringReadCommand);
                void CompleteRedisDataQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData>> redisDataReadCommand);
                void CompleteStringQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask<string>> stringReadCommand);
                void CompleteVoidQueuedCommandAsync(System.Func<System.Threading.CancellationToken, System.Threading.Tasks.ValueTask> voidReadCommand);
            }

            // Generated from `ServiceStack.Redis.Pipeline.IRedisQueueableOperation` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisQueueableOperation
            {
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, string> command, System.Action<string> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, string> command, System.Action<string> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, string> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, int> command, System.Action<int> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, int> command, System.Action<int> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, int> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, double> command, System.Action<double> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, double> command, System.Action<double> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, double> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, bool> command, System.Action<bool> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, bool> command, System.Action<bool> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, bool> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Int64> command, System.Action<System.Int64> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Int64> command, System.Action<System.Int64> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Int64> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.List<string>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.List<string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.HashSet<string>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.HashSet<string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.Dictionary<string, string>> command, System.Action<System.Collections.Generic.Dictionary<string, string>> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.Dictionary<string, string>> command, System.Action<System.Collections.Generic.Dictionary<string, string>> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Collections.Generic.Dictionary<string, string>> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[][]> command, System.Action<System.Byte[][]> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[][]> command, System.Action<System.Byte[][]> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[][]> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[]> command, System.Action<System.Byte[]> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[]> command, System.Action<System.Byte[]> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, System.Byte[]> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisText> command, System.Action<ServiceStack.Redis.RedisText> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisText> command, System.Action<ServiceStack.Redis.RedisText> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisText> command);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisData> command, System.Action<ServiceStack.Redis.RedisData> onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisData> command, System.Action<ServiceStack.Redis.RedisData> onSuccessCallback);
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClient, ServiceStack.Redis.RedisData> command);
                void QueueCommand(System.Action<ServiceStack.Redis.IRedisClient> command, System.Action onSuccessCallback, System.Action<System.Exception> onErrorCallback);
                void QueueCommand(System.Action<ServiceStack.Redis.IRedisClient> command, System.Action onSuccessCallback);
                void QueueCommand(System.Action<ServiceStack.Redis.IRedisClient> command);
            }

            // Generated from `ServiceStack.Redis.Pipeline.IRedisQueueableOperationAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
            public interface IRedisQueueableOperationAsync
            {
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask> command, System.Action onSuccessCallback = default(System.Action), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<string>> command, System.Action<string> onSuccessCallback = default(System.Action<string>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<int>> command, System.Action<int> onSuccessCallback = default(System.Action<int>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<double>> command, System.Action<double> onSuccessCallback = default(System.Action<double>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<bool>> command, System.Action<bool> onSuccessCallback = default(System.Action<bool>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Int64>> command, System.Action<System.Int64> onSuccessCallback = default(System.Action<System.Int64>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Collections.Generic.List<string>>> command, System.Action<System.Collections.Generic.List<string>> onSuccessCallback = default(System.Action<System.Collections.Generic.List<string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Collections.Generic.HashSet<string>>> command, System.Action<System.Collections.Generic.HashSet<string>> onSuccessCallback = default(System.Action<System.Collections.Generic.HashSet<string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Collections.Generic.Dictionary<string, string>>> command, System.Action<System.Collections.Generic.Dictionary<string, string>> onSuccessCallback = default(System.Action<System.Collections.Generic.Dictionary<string, string>>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Byte[][]>> command, System.Action<System.Byte[][]> onSuccessCallback = default(System.Action<System.Byte[][]>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<System.Byte[]>> command, System.Action<System.Byte[]> onSuccessCallback = default(System.Action<System.Byte[]>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisText>> command, System.Action<ServiceStack.Redis.RedisText> onSuccessCallback = default(System.Action<ServiceStack.Redis.RedisText>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
                void QueueCommand(System.Func<ServiceStack.Redis.IRedisClientAsync, System.Threading.Tasks.ValueTask<ServiceStack.Redis.RedisData>> command, System.Action<ServiceStack.Redis.RedisData> onSuccessCallback = default(System.Action<ServiceStack.Redis.RedisData>), System.Action<System.Exception> onErrorCallback = default(System.Action<System.Exception>));
            }

        }
    }
    namespace Web
    {
        // Generated from `ServiceStack.Web.IContentTypeReader` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IContentTypeReader
        {
            object DeserializeFromStream(string contentType, System.Type type, System.IO.Stream requestStream);
            object DeserializeFromString(string contentType, System.Type type, string request);
            ServiceStack.Web.StreamDeserializerDelegate GetStreamDeserializer(string contentType);
            ServiceStack.Web.StreamDeserializerDelegateAsync GetStreamDeserializerAsync(string contentType);
        }

        // Generated from `ServiceStack.Web.IContentTypeWriter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IContentTypeWriter
        {
            ServiceStack.Web.StreamSerializerDelegateAsync GetStreamSerializerAsync(string contentType);
            System.Byte[] SerializeToBytes(ServiceStack.Web.IRequest req, object response);
            System.Threading.Tasks.Task SerializeToStreamAsync(ServiceStack.Web.IRequest requestContext, object response, System.IO.Stream toStream);
            string SerializeToString(ServiceStack.Web.IRequest req, object response);
        }

        // Generated from `ServiceStack.Web.IContentTypes` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IContentTypes : ServiceStack.Web.IContentTypeWriter, ServiceStack.Web.IContentTypeReader
        {
            System.Collections.Generic.Dictionary<string, string> ContentTypeFormats { get; }
            string GetFormatContentType(string format);
            void Register(string contentType, ServiceStack.Web.StreamSerializerDelegate streamSerializer, ServiceStack.Web.StreamDeserializerDelegate streamDeserializer);
            void RegisterAsync(string contentType, ServiceStack.Web.StreamSerializerDelegateAsync responseSerializer, ServiceStack.Web.StreamDeserializerDelegateAsync streamDeserializer);
            void Remove(string contentType);
        }

        // Generated from `ServiceStack.Web.ICookies` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface ICookies
        {
            void AddPermanentCookie(string cookieName, string cookieValue, bool? secureOnly = default(bool?));
            void AddSessionCookie(string cookieName, string cookieValue, bool? secureOnly = default(bool?));
            void DeleteCookie(string cookieName);
        }

        // Generated from `ServiceStack.Web.IExpirable` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IExpirable
        {
            System.DateTime? LastModified { get; }
        }

        // Generated from `ServiceStack.Web.IHasHeaders` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasHeaders
        {
            System.Collections.Generic.Dictionary<string, string> Headers { get; }
        }

        // Generated from `ServiceStack.Web.IHasOptions` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasOptions
        {
            System.Collections.Generic.IDictionary<string, string> Options { get; }
        }

        // Generated from `ServiceStack.Web.IHasRequestFilter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasRequestFilter : ServiceStack.Web.IRequestFilterBase
        {
            void RequestFilter(ServiceStack.Web.IRequest req, ServiceStack.Web.IResponse res, object requestDto);
        }

        // Generated from `ServiceStack.Web.IHasRequestFilterAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasRequestFilterAsync : ServiceStack.Web.IRequestFilterBase
        {
            System.Threading.Tasks.Task RequestFilterAsync(ServiceStack.Web.IRequest req, ServiceStack.Web.IResponse res, object requestDto);
        }

        // Generated from `ServiceStack.Web.IHasResponseFilter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasResponseFilter : ServiceStack.Web.IResponseFilterBase
        {
            void ResponseFilter(ServiceStack.Web.IRequest req, ServiceStack.Web.IResponse res, object response);
        }

        // Generated from `ServiceStack.Web.IHasResponseFilterAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHasResponseFilterAsync : ServiceStack.Web.IResponseFilterBase
        {
            System.Threading.Tasks.Task ResponseFilterAsync(ServiceStack.Web.IRequest req, ServiceStack.Web.IResponse res, object response);
        }

        // Generated from `ServiceStack.Web.IHttpError` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHttpError : ServiceStack.Web.IHttpResult, ServiceStack.Web.IHasOptions
        {
            string ErrorCode { get; }
            string Message { get; }
            string StackTrace { get; }
        }

        // Generated from `ServiceStack.Web.IHttpFile` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHttpFile
        {
            System.Int64 ContentLength { get; }
            string ContentType { get; }
            string FileName { get; }
            System.IO.Stream InputStream { get; }
            string Name { get; }
        }

        // Generated from `ServiceStack.Web.IHttpRequest` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Web.IHttpResponse` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IHttpResponse : ServiceStack.Web.IResponse
        {
            void ClearCookies();
            ServiceStack.Web.ICookies Cookies { get; }
            void SetCookie(System.Net.Cookie cookie);
        }

        // Generated from `ServiceStack.Web.IHttpResult` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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

        // Generated from `ServiceStack.Web.IPartialWriter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IPartialWriter
        {
            bool IsPartialRequest { get; }
            void WritePartialTo(ServiceStack.Web.IResponse response);
        }

        // Generated from `ServiceStack.Web.IPartialWriterAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IPartialWriterAsync
        {
            bool IsPartialRequest { get; }
            System.Threading.Tasks.Task WritePartialToAsync(ServiceStack.Web.IResponse response, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Web.IRequest` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRequest : ServiceStack.Configuration.IResolver
        {
            string AbsoluteUri { get; }
            string[] AcceptTypes { get; }
            string Authorization { get; }
            System.Int64 ContentLength { get; }
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

        // Generated from `ServiceStack.Web.IRequestFilterBase` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRequestFilterBase
        {
            ServiceStack.Web.IRequestFilterBase Copy();
            int Priority { get; }
        }

        // Generated from `ServiceStack.Web.IRequestLogger` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRequestLogger
        {
            System.Func<System.DateTime> CurrentDateFn { get; set; }
            bool EnableErrorTracking { get; set; }
            bool EnableRequestBodyTracking { get; set; }
            bool EnableResponseTracking { get; set; }
            bool EnableSessionTracking { get; set; }
            System.Type[] ExcludeRequestDtoTypes { get; set; }
            System.Collections.Generic.List<ServiceStack.RequestLogEntry> GetLatestLogs(int? take);
            System.Type[] HideRequestBodyForRequestDtoTypes { get; set; }
            System.Func<object, bool> IgnoreFilter { get; set; }
            bool LimitToServiceRequests { get; set; }
            void Log(ServiceStack.Web.IRequest request, object requestDto, object response, System.TimeSpan elapsed);
            System.Action<ServiceStack.Web.IRequest, ServiceStack.RequestLogEntry> RequestLogFilter { get; set; }
            string[] RequiredRoles { get; set; }
            System.Func<ServiceStack.Web.IRequest, bool> SkipLogging { get; set; }
        }

        // Generated from `ServiceStack.Web.IRequestPreferences` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRequestPreferences
        {
            bool AcceptsDeflate { get; }
            bool AcceptsGzip { get; }
        }

        // Generated from `ServiceStack.Web.IRequiresRequest` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRequiresRequest
        {
            ServiceStack.Web.IRequest Request { get; set; }
        }

        // Generated from `ServiceStack.Web.IRequiresRequestStream` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRequiresRequestStream
        {
            System.IO.Stream RequestStream { get; set; }
        }

        // Generated from `ServiceStack.Web.IResponse` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
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
            void SetContentLength(System.Int64 contentLength);
            int StatusCode { get; set; }
            string StatusDescription { get; set; }
            bool UseBufferedStream { get; set; }
        }

        // Generated from `ServiceStack.Web.IResponseFilterBase` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IResponseFilterBase
        {
            ServiceStack.Web.IResponseFilterBase Copy();
            int Priority { get; }
        }

        // Generated from `ServiceStack.Web.IRestPath` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IRestPath
        {
            object CreateRequest(string pathInfo, System.Collections.Generic.Dictionary<string, string> queryStringAndFormData, object fromInstance);
            bool IsWildCardPath { get; }
            System.Type RequestType { get; }
        }

        // Generated from `ServiceStack.Web.IServiceController` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IServiceController : ServiceStack.Web.IServiceExecutor
        {
            object Execute(object requestDto, ServiceStack.Web.IRequest request, bool applyFilters);
            object Execute(object requestDto, ServiceStack.Web.IRequest request);
            object Execute(object requestDto);
            object Execute(ServiceStack.Web.IRequest request, bool applyFilters);
            object ExecuteMessage(ServiceStack.Messaging.IMessage mqMessage);
            object ExecuteMessage(ServiceStack.Messaging.IMessage dto, ServiceStack.Web.IRequest request);
            System.Threading.Tasks.Task<object> GatewayExecuteAsync(object requestDto, ServiceStack.Web.IRequest req, bool applyFilters);
            ServiceStack.Web.IRestPath GetRestPathForRequest(string httpMethod, string pathInfo);
        }

        // Generated from `ServiceStack.Web.IServiceExecutor` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IServiceExecutor
        {
            System.Threading.Tasks.Task<object> ExecuteAsync(object requestDto, ServiceStack.Web.IRequest request);
        }

        // Generated from `ServiceStack.Web.IServiceGatewayFactory` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IServiceGatewayFactory
        {
            ServiceStack.IServiceGateway GetServiceGateway(ServiceStack.Web.IRequest request);
        }

        // Generated from `ServiceStack.Web.IServiceRoutes` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IServiceRoutes
        {
            ServiceStack.Web.IServiceRoutes Add<TRequest>(string restPath, string verbs);
            ServiceStack.Web.IServiceRoutes Add<TRequest>(string restPath);
            ServiceStack.Web.IServiceRoutes Add(System.Type requestType, string restPath, string verbs, string summary, string notes, string matches);
            ServiceStack.Web.IServiceRoutes Add(System.Type requestType, string restPath, string verbs, string summary, string notes);
            ServiceStack.Web.IServiceRoutes Add(System.Type requestType, string restPath, string verbs, int priority);
            ServiceStack.Web.IServiceRoutes Add(System.Type requestType, string restPath, string verbs);
        }

        // Generated from `ServiceStack.Web.IServiceRunner` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IServiceRunner
        {
            object Process(ServiceStack.Web.IRequest requestContext, object instance, object request);
        }

        // Generated from `ServiceStack.Web.IServiceRunner<>` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IServiceRunner<TRequest> : ServiceStack.Web.IServiceRunner
        {
            object Execute(ServiceStack.Web.IRequest req, object instance, ServiceStack.Messaging.IMessage<TRequest> request);
            System.Threading.Tasks.Task<object> ExecuteAsync(ServiceStack.Web.IRequest req, object instance, TRequest requestDto);
            object ExecuteOneWay(ServiceStack.Web.IRequest req, object instance, TRequest requestDto);
            System.Threading.Tasks.Task<object> HandleExceptionAsync(ServiceStack.Web.IRequest req, TRequest requestDto, System.Exception ex, object instance);
            object OnAfterExecute(ServiceStack.Web.IRequest req, object response, object service);
            void OnBeforeExecute(ServiceStack.Web.IRequest req, TRequest request, object service);
        }

        // Generated from `ServiceStack.Web.IStreamWriter` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IStreamWriter
        {
            void WriteTo(System.IO.Stream responseStream);
        }

        // Generated from `ServiceStack.Web.IStreamWriterAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public interface IStreamWriterAsync
        {
            System.Threading.Tasks.Task WriteToAsync(System.IO.Stream responseStream, System.Threading.CancellationToken token = default(System.Threading.CancellationToken));
        }

        // Generated from `ServiceStack.Web.StreamDeserializerDelegate` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public delegate object StreamDeserializerDelegate(System.Type type, System.IO.Stream fromStream);

        // Generated from `ServiceStack.Web.StreamDeserializerDelegateAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public delegate System.Threading.Tasks.Task<object> StreamDeserializerDelegateAsync(System.Type type, System.IO.Stream fromStream);

        // Generated from `ServiceStack.Web.StreamSerializerDelegate` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public delegate void StreamSerializerDelegate(ServiceStack.Web.IRequest req, object dto, System.IO.Stream outputStream);

        // Generated from `ServiceStack.Web.StreamSerializerDelegateAsync` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public delegate System.Threading.Tasks.Task StreamSerializerDelegateAsync(ServiceStack.Web.IRequest req, object dto, System.IO.Stream outputStream);

        // Generated from `ServiceStack.Web.StringDeserializerDelegate` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public delegate object StringDeserializerDelegate(string contents, System.Type type);

        // Generated from `ServiceStack.Web.StringSerializerDelegate` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public delegate string StringSerializerDelegate(ServiceStack.Web.IRequest req, object dto);

        // Generated from `ServiceStack.Web.TextDeserializerDelegate` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public delegate object TextDeserializerDelegate(System.Type type, string dto);

        // Generated from `ServiceStack.Web.TextSerializerDelegate` in `ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null`
        public delegate string TextSerializerDelegate(object dto);

    }
}
namespace System
{
    namespace Runtime
    {
        namespace CompilerServices
        {
            /* Duplicate type 'IsReadOnlyAttribute' is not stubbed in this assembly 'ServiceStack.Interfaces, Version=5.0.0.0, Culture=neutral, PublicKeyToken=null'. */

        }
    }
}
