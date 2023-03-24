// This file contains auto-generated code.
// Generated from `System.Net.Requests, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    namespace Net
    {
        public class AuthenticationManager
        {
            public static System.Net.Authorization Authenticate(string challenge, System.Net.WebRequest request, System.Net.ICredentials credentials) => throw null;
            public static System.Net.ICredentialPolicy CredentialPolicy { get => throw null; set => throw null; }
            public static System.Collections.Specialized.StringDictionary CustomTargetNameDictionary { get => throw null; }
            public static System.Net.Authorization PreAuthenticate(System.Net.WebRequest request, System.Net.ICredentials credentials) => throw null;
            public static void Register(System.Net.IAuthenticationModule authenticationModule) => throw null;
            public static System.Collections.IEnumerator RegisteredModules { get => throw null; }
            public static void Unregister(System.Net.IAuthenticationModule authenticationModule) => throw null;
            public static void Unregister(string authenticationScheme) => throw null;
        }

        public class Authorization
        {
            public Authorization(string token) => throw null;
            public Authorization(string token, bool finished) => throw null;
            public Authorization(string token, bool finished, string connectionGroupId) => throw null;
            public bool Complete { get => throw null; }
            public string ConnectionGroupId { get => throw null; }
            public string Message { get => throw null; }
            public bool MutuallyAuthenticated { get => throw null; set => throw null; }
            public string[] ProtectionRealm { get => throw null; set => throw null; }
        }

        public class FileWebRequest : System.Net.WebRequest, System.Runtime.Serialization.ISerializable
        {
            public override void Abort() => throw null;
            public override System.IAsyncResult BeginGetRequestStream(System.AsyncCallback callback, object state) => throw null;
            public override System.IAsyncResult BeginGetResponse(System.AsyncCallback callback, object state) => throw null;
            public override string ConnectionGroupName { get => throw null; set => throw null; }
            public override System.Int64 ContentLength { get => throw null; set => throw null; }
            public override string ContentType { get => throw null; set => throw null; }
            public override System.Net.ICredentials Credentials { get => throw null; set => throw null; }
            public override System.IO.Stream EndGetRequestStream(System.IAsyncResult asyncResult) => throw null;
            public override System.Net.WebResponse EndGetResponse(System.IAsyncResult asyncResult) => throw null;
            protected FileWebRequest(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            protected override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public override System.IO.Stream GetRequestStream() => throw null;
            public override System.Threading.Tasks.Task<System.IO.Stream> GetRequestStreamAsync() => throw null;
            public override System.Net.WebResponse GetResponse() => throw null;
            public override System.Threading.Tasks.Task<System.Net.WebResponse> GetResponseAsync() => throw null;
            public override System.Net.WebHeaderCollection Headers { get => throw null; }
            public override string Method { get => throw null; set => throw null; }
            public override bool PreAuthenticate { get => throw null; set => throw null; }
            public override System.Net.IWebProxy Proxy { get => throw null; set => throw null; }
            public override System.Uri RequestUri { get => throw null; }
            public override int Timeout { get => throw null; set => throw null; }
            public override bool UseDefaultCredentials { get => throw null; set => throw null; }
        }

        public class FileWebResponse : System.Net.WebResponse, System.Runtime.Serialization.ISerializable
        {
            public override void Close() => throw null;
            public override System.Int64 ContentLength { get => throw null; }
            public override string ContentType { get => throw null; }
            protected FileWebResponse(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            protected override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public override System.IO.Stream GetResponseStream() => throw null;
            public override System.Net.WebHeaderCollection Headers { get => throw null; }
            public override System.Uri ResponseUri { get => throw null; }
            public override bool SupportsHeaders { get => throw null; }
        }

        public enum FtpStatusCode : int
        {
            AccountNeeded = 532,
            ActionAbortedLocalProcessingError = 451,
            ActionAbortedUnknownPageType = 551,
            ActionNotTakenFileUnavailable = 550,
            ActionNotTakenFileUnavailableOrBusy = 450,
            ActionNotTakenFilenameNotAllowed = 553,
            ActionNotTakenInsufficientSpace = 452,
            ArgumentSyntaxError = 501,
            BadCommandSequence = 503,
            CantOpenData = 425,
            ClosingControl = 221,
            ClosingData = 226,
            CommandExtraneous = 202,
            CommandNotImplemented = 502,
            CommandOK = 200,
            CommandSyntaxError = 500,
            ConnectionClosed = 426,
            DataAlreadyOpen = 125,
            DirectoryStatus = 212,
            EnteringPassive = 227,
            FileActionAborted = 552,
            FileActionOK = 250,
            FileCommandPending = 350,
            FileStatus = 213,
            LoggedInProceed = 230,
            NeedLoginAccount = 332,
            NotLoggedIn = 530,
            OpeningData = 150,
            PathnameCreated = 257,
            RestartMarker = 110,
            SendPasswordCommand = 331,
            SendUserCommand = 220,
            ServerWantsSecureSession = 234,
            ServiceNotAvailable = 421,
            ServiceTemporarilyNotAvailable = 120,
            SystemType = 215,
            Undefined = 0,
        }

        public class FtpWebRequest : System.Net.WebRequest
        {
            public override void Abort() => throw null;
            public override System.IAsyncResult BeginGetRequestStream(System.AsyncCallback callback, object state) => throw null;
            public override System.IAsyncResult BeginGetResponse(System.AsyncCallback callback, object state) => throw null;
            public System.Security.Cryptography.X509Certificates.X509CertificateCollection ClientCertificates { get => throw null; set => throw null; }
            public override string ConnectionGroupName { get => throw null; set => throw null; }
            public override System.Int64 ContentLength { get => throw null; set => throw null; }
            public System.Int64 ContentOffset { get => throw null; set => throw null; }
            public override string ContentType { get => throw null; set => throw null; }
            public override System.Net.ICredentials Credentials { get => throw null; set => throw null; }
            public static System.Net.Cache.RequestCachePolicy DefaultCachePolicy { get => throw null; set => throw null; }
            public bool EnableSsl { get => throw null; set => throw null; }
            public override System.IO.Stream EndGetRequestStream(System.IAsyncResult asyncResult) => throw null;
            public override System.Net.WebResponse EndGetResponse(System.IAsyncResult asyncResult) => throw null;
            public override System.IO.Stream GetRequestStream() => throw null;
            public override System.Net.WebResponse GetResponse() => throw null;
            public override System.Net.WebHeaderCollection Headers { get => throw null; set => throw null; }
            public bool KeepAlive { get => throw null; set => throw null; }
            public override string Method { get => throw null; set => throw null; }
            public override bool PreAuthenticate { get => throw null; set => throw null; }
            public override System.Net.IWebProxy Proxy { get => throw null; set => throw null; }
            public int ReadWriteTimeout { get => throw null; set => throw null; }
            public string RenameTo { get => throw null; set => throw null; }
            public override System.Uri RequestUri { get => throw null; }
            public System.Net.ServicePoint ServicePoint { get => throw null; }
            public override int Timeout { get => throw null; set => throw null; }
            public bool UseBinary { get => throw null; set => throw null; }
            public override bool UseDefaultCredentials { get => throw null; set => throw null; }
            public bool UsePassive { get => throw null; set => throw null; }
        }

        public class FtpWebResponse : System.Net.WebResponse, System.IDisposable
        {
            public string BannerMessage { get => throw null; }
            public override void Close() => throw null;
            public override System.Int64 ContentLength { get => throw null; }
            public string ExitMessage { get => throw null; }
            public override System.IO.Stream GetResponseStream() => throw null;
            public override System.Net.WebHeaderCollection Headers { get => throw null; }
            public System.DateTime LastModified { get => throw null; }
            public override System.Uri ResponseUri { get => throw null; }
            public System.Net.FtpStatusCode StatusCode { get => throw null; }
            public string StatusDescription { get => throw null; }
            public override bool SupportsHeaders { get => throw null; }
            public string WelcomeMessage { get => throw null; }
        }

        public class GlobalProxySelection
        {
            public static System.Net.IWebProxy GetEmptyWebProxy() => throw null;
            public GlobalProxySelection() => throw null;
            public static System.Net.IWebProxy Select { get => throw null; set => throw null; }
        }

        public delegate void HttpContinueDelegate(int StatusCode, System.Net.WebHeaderCollection httpHeaders);

        public class HttpWebRequest : System.Net.WebRequest, System.Runtime.Serialization.ISerializable
        {
            public override void Abort() => throw null;
            public string Accept { get => throw null; set => throw null; }
            public void AddRange(int range) => throw null;
            public void AddRange(int from, int to) => throw null;
            public void AddRange(System.Int64 range) => throw null;
            public void AddRange(System.Int64 from, System.Int64 to) => throw null;
            public void AddRange(string rangeSpecifier, int range) => throw null;
            public void AddRange(string rangeSpecifier, int from, int to) => throw null;
            public void AddRange(string rangeSpecifier, System.Int64 range) => throw null;
            public void AddRange(string rangeSpecifier, System.Int64 from, System.Int64 to) => throw null;
            public System.Uri Address { get => throw null; }
            public virtual bool AllowAutoRedirect { get => throw null; set => throw null; }
            public virtual bool AllowReadStreamBuffering { get => throw null; set => throw null; }
            public virtual bool AllowWriteStreamBuffering { get => throw null; set => throw null; }
            public System.Net.DecompressionMethods AutomaticDecompression { get => throw null; set => throw null; }
            public override System.IAsyncResult BeginGetRequestStream(System.AsyncCallback callback, object state) => throw null;
            public override System.IAsyncResult BeginGetResponse(System.AsyncCallback callback, object state) => throw null;
            public System.Security.Cryptography.X509Certificates.X509CertificateCollection ClientCertificates { get => throw null; set => throw null; }
            public string Connection { get => throw null; set => throw null; }
            public override string ConnectionGroupName { get => throw null; set => throw null; }
            public override System.Int64 ContentLength { get => throw null; set => throw null; }
            public override string ContentType { get => throw null; set => throw null; }
            public System.Net.HttpContinueDelegate ContinueDelegate { get => throw null; set => throw null; }
            public int ContinueTimeout { get => throw null; set => throw null; }
            public virtual System.Net.CookieContainer CookieContainer { get => throw null; set => throw null; }
            public override System.Net.ICredentials Credentials { get => throw null; set => throw null; }
            public System.DateTime Date { get => throw null; set => throw null; }
            public static System.Net.Cache.RequestCachePolicy DefaultCachePolicy { get => throw null; set => throw null; }
            public static int DefaultMaximumErrorResponseLength { get => throw null; set => throw null; }
            public static int DefaultMaximumResponseHeadersLength { get => throw null; set => throw null; }
            public override System.IO.Stream EndGetRequestStream(System.IAsyncResult asyncResult) => throw null;
            public System.IO.Stream EndGetRequestStream(System.IAsyncResult asyncResult, out System.Net.TransportContext context) => throw null;
            public override System.Net.WebResponse EndGetResponse(System.IAsyncResult asyncResult) => throw null;
            public string Expect { get => throw null; set => throw null; }
            protected override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public override System.IO.Stream GetRequestStream() => throw null;
            public System.IO.Stream GetRequestStream(out System.Net.TransportContext context) => throw null;
            public override System.Net.WebResponse GetResponse() => throw null;
            public virtual bool HaveResponse { get => throw null; }
            public override System.Net.WebHeaderCollection Headers { get => throw null; set => throw null; }
            public string Host { get => throw null; set => throw null; }
            protected HttpWebRequest(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public System.DateTime IfModifiedSince { get => throw null; set => throw null; }
            public bool KeepAlive { get => throw null; set => throw null; }
            public int MaximumAutomaticRedirections { get => throw null; set => throw null; }
            public int MaximumResponseHeadersLength { get => throw null; set => throw null; }
            public string MediaType { get => throw null; set => throw null; }
            public override string Method { get => throw null; set => throw null; }
            public bool Pipelined { get => throw null; set => throw null; }
            public override bool PreAuthenticate { get => throw null; set => throw null; }
            public System.Version ProtocolVersion { get => throw null; set => throw null; }
            public override System.Net.IWebProxy Proxy { get => throw null; set => throw null; }
            public int ReadWriteTimeout { get => throw null; set => throw null; }
            public string Referer { get => throw null; set => throw null; }
            public override System.Uri RequestUri { get => throw null; }
            public bool SendChunked { get => throw null; set => throw null; }
            public System.Net.Security.RemoteCertificateValidationCallback ServerCertificateValidationCallback { get => throw null; set => throw null; }
            public System.Net.ServicePoint ServicePoint { get => throw null; }
            public virtual bool SupportsCookieContainer { get => throw null; }
            public override int Timeout { get => throw null; set => throw null; }
            public string TransferEncoding { get => throw null; set => throw null; }
            public bool UnsafeAuthenticatedConnectionSharing { get => throw null; set => throw null; }
            public override bool UseDefaultCredentials { get => throw null; set => throw null; }
            public string UserAgent { get => throw null; set => throw null; }
        }

        public class HttpWebResponse : System.Net.WebResponse, System.Runtime.Serialization.ISerializable
        {
            public string CharacterSet { get => throw null; }
            public override void Close() => throw null;
            public string ContentEncoding { get => throw null; }
            public override System.Int64 ContentLength { get => throw null; }
            public override string ContentType { get => throw null; }
            public virtual System.Net.CookieCollection Cookies { get => throw null; set => throw null; }
            protected override void Dispose(bool disposing) => throw null;
            protected override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public string GetResponseHeader(string headerName) => throw null;
            public override System.IO.Stream GetResponseStream() => throw null;
            public override System.Net.WebHeaderCollection Headers { get => throw null; }
            public HttpWebResponse() => throw null;
            protected HttpWebResponse(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public override bool IsMutuallyAuthenticated { get => throw null; }
            public System.DateTime LastModified { get => throw null; }
            public virtual string Method { get => throw null; }
            public System.Version ProtocolVersion { get => throw null; }
            public override System.Uri ResponseUri { get => throw null; }
            public string Server { get => throw null; }
            public virtual System.Net.HttpStatusCode StatusCode { get => throw null; }
            public virtual string StatusDescription { get => throw null; }
            public override bool SupportsHeaders { get => throw null; }
        }

        public interface IAuthenticationModule
        {
            System.Net.Authorization Authenticate(string challenge, System.Net.WebRequest request, System.Net.ICredentials credentials);
            string AuthenticationType { get; }
            bool CanPreAuthenticate { get; }
            System.Net.Authorization PreAuthenticate(System.Net.WebRequest request, System.Net.ICredentials credentials);
        }

        public interface ICredentialPolicy
        {
            bool ShouldSendCredential(System.Uri challengeUri, System.Net.WebRequest request, System.Net.NetworkCredential credential, System.Net.IAuthenticationModule authenticationModule);
        }

        public interface IWebRequestCreate
        {
            System.Net.WebRequest Create(System.Uri uri);
        }

        public class ProtocolViolationException : System.InvalidOperationException, System.Runtime.Serialization.ISerializable
        {
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public ProtocolViolationException() => throw null;
            protected ProtocolViolationException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public ProtocolViolationException(string message) => throw null;
        }

        public class WebException : System.InvalidOperationException, System.Runtime.Serialization.ISerializable
        {
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public System.Net.WebResponse Response { get => throw null; }
            public System.Net.WebExceptionStatus Status { get => throw null; }
            public WebException() => throw null;
            protected WebException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public WebException(string message) => throw null;
            public WebException(string message, System.Exception innerException) => throw null;
            public WebException(string message, System.Exception innerException, System.Net.WebExceptionStatus status, System.Net.WebResponse response) => throw null;
            public WebException(string message, System.Net.WebExceptionStatus status) => throw null;
        }

        public enum WebExceptionStatus : int
        {
            CacheEntryNotFound = 18,
            ConnectFailure = 2,
            ConnectionClosed = 8,
            KeepAliveFailure = 12,
            MessageLengthLimitExceeded = 17,
            NameResolutionFailure = 1,
            Pending = 13,
            PipelineFailure = 5,
            ProtocolError = 7,
            ProxyNameResolutionFailure = 15,
            ReceiveFailure = 3,
            RequestCanceled = 6,
            RequestProhibitedByCachePolicy = 19,
            RequestProhibitedByProxy = 20,
            SecureChannelFailure = 10,
            SendFailure = 4,
            ServerProtocolViolation = 11,
            Success = 0,
            Timeout = 14,
            TrustFailure = 9,
            UnknownError = 16,
        }

        public abstract class WebRequest : System.MarshalByRefObject, System.Runtime.Serialization.ISerializable
        {
            public virtual void Abort() => throw null;
            public System.Net.Security.AuthenticationLevel AuthenticationLevel { get => throw null; set => throw null; }
            public virtual System.IAsyncResult BeginGetRequestStream(System.AsyncCallback callback, object state) => throw null;
            public virtual System.IAsyncResult BeginGetResponse(System.AsyncCallback callback, object state) => throw null;
            public virtual System.Net.Cache.RequestCachePolicy CachePolicy { get => throw null; set => throw null; }
            public virtual string ConnectionGroupName { get => throw null; set => throw null; }
            public virtual System.Int64 ContentLength { get => throw null; set => throw null; }
            public virtual string ContentType { get => throw null; set => throw null; }
            public static System.Net.WebRequest Create(System.Uri requestUri) => throw null;
            public static System.Net.WebRequest Create(string requestUriString) => throw null;
            public static System.Net.WebRequest CreateDefault(System.Uri requestUri) => throw null;
            public static System.Net.HttpWebRequest CreateHttp(System.Uri requestUri) => throw null;
            public static System.Net.HttpWebRequest CreateHttp(string requestUriString) => throw null;
            public virtual System.Net.ICredentials Credentials { get => throw null; set => throw null; }
            public static System.Net.Cache.RequestCachePolicy DefaultCachePolicy { get => throw null; set => throw null; }
            public static System.Net.IWebProxy DefaultWebProxy { get => throw null; set => throw null; }
            public virtual System.IO.Stream EndGetRequestStream(System.IAsyncResult asyncResult) => throw null;
            public virtual System.Net.WebResponse EndGetResponse(System.IAsyncResult asyncResult) => throw null;
            protected virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public virtual System.IO.Stream GetRequestStream() => throw null;
            public virtual System.Threading.Tasks.Task<System.IO.Stream> GetRequestStreamAsync() => throw null;
            public virtual System.Net.WebResponse GetResponse() => throw null;
            public virtual System.Threading.Tasks.Task<System.Net.WebResponse> GetResponseAsync() => throw null;
            public static System.Net.IWebProxy GetSystemWebProxy() => throw null;
            public virtual System.Net.WebHeaderCollection Headers { get => throw null; set => throw null; }
            public System.Security.Principal.TokenImpersonationLevel ImpersonationLevel { get => throw null; set => throw null; }
            public virtual string Method { get => throw null; set => throw null; }
            public virtual bool PreAuthenticate { get => throw null; set => throw null; }
            public virtual System.Net.IWebProxy Proxy { get => throw null; set => throw null; }
            public static bool RegisterPrefix(string prefix, System.Net.IWebRequestCreate creator) => throw null;
            public virtual System.Uri RequestUri { get => throw null; }
            public virtual int Timeout { get => throw null; set => throw null; }
            public virtual bool UseDefaultCredentials { get => throw null; set => throw null; }
            protected WebRequest() => throw null;
            protected WebRequest(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        }

        public static class WebRequestMethods
        {
            public static class File
            {
                public const string DownloadFile = default;
                public const string UploadFile = default;
            }


            public static class Ftp
            {
                public const string AppendFile = default;
                public const string DeleteFile = default;
                public const string DownloadFile = default;
                public const string GetDateTimestamp = default;
                public const string GetFileSize = default;
                public const string ListDirectory = default;
                public const string ListDirectoryDetails = default;
                public const string MakeDirectory = default;
                public const string PrintWorkingDirectory = default;
                public const string RemoveDirectory = default;
                public const string Rename = default;
                public const string UploadFile = default;
                public const string UploadFileWithUniqueName = default;
            }


            public static class Http
            {
                public const string Connect = default;
                public const string Get = default;
                public const string Head = default;
                public const string MkCol = default;
                public const string Post = default;
                public const string Put = default;
            }


        }

        public abstract class WebResponse : System.MarshalByRefObject, System.IDisposable, System.Runtime.Serialization.ISerializable
        {
            public virtual void Close() => throw null;
            public virtual System.Int64 ContentLength { get => throw null; set => throw null; }
            public virtual string ContentType { get => throw null; set => throw null; }
            public void Dispose() => throw null;
            protected virtual void Dispose(bool disposing) => throw null;
            protected virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public virtual System.IO.Stream GetResponseStream() => throw null;
            public virtual System.Net.WebHeaderCollection Headers { get => throw null; }
            public virtual bool IsFromCache { get => throw null; }
            public virtual bool IsMutuallyAuthenticated { get => throw null; }
            public virtual System.Uri ResponseUri { get => throw null; }
            public virtual bool SupportsHeaders { get => throw null; }
            protected WebResponse() => throw null;
            protected WebResponse(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        }

        namespace Cache
        {
            public enum HttpCacheAgeControl : int
            {
                MaxAge = 2,
                MaxAgeAndMaxStale = 6,
                MaxAgeAndMinFresh = 3,
                MaxStale = 4,
                MinFresh = 1,
                None = 0,
            }

            public enum HttpRequestCacheLevel : int
            {
                BypassCache = 1,
                CacheIfAvailable = 3,
                CacheOnly = 2,
                CacheOrNextCacheOnly = 7,
                Default = 0,
                NoCacheNoStore = 6,
                Refresh = 8,
                Reload = 5,
                Revalidate = 4,
            }

            public class HttpRequestCachePolicy : System.Net.Cache.RequestCachePolicy
            {
                public System.DateTime CacheSyncDate { get => throw null; }
                public HttpRequestCachePolicy() => throw null;
                public HttpRequestCachePolicy(System.DateTime cacheSyncDate) => throw null;
                public HttpRequestCachePolicy(System.Net.Cache.HttpCacheAgeControl cacheAgeControl, System.TimeSpan ageOrFreshOrStale) => throw null;
                public HttpRequestCachePolicy(System.Net.Cache.HttpCacheAgeControl cacheAgeControl, System.TimeSpan maxAge, System.TimeSpan freshOrStale) => throw null;
                public HttpRequestCachePolicy(System.Net.Cache.HttpCacheAgeControl cacheAgeControl, System.TimeSpan maxAge, System.TimeSpan freshOrStale, System.DateTime cacheSyncDate) => throw null;
                public HttpRequestCachePolicy(System.Net.Cache.HttpRequestCacheLevel level) => throw null;
                public System.Net.Cache.HttpRequestCacheLevel Level { get => throw null; }
                public System.TimeSpan MaxAge { get => throw null; }
                public System.TimeSpan MaxStale { get => throw null; }
                public System.TimeSpan MinFresh { get => throw null; }
                public override string ToString() => throw null;
            }

        }
    }
}
