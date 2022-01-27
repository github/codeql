// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        // Generated from `System.Net.AuthenticationManager` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.Authorization` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.FileWebRequest` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.FileWebResponse` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.FtpStatusCode` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum FtpStatusCode
        {
            AccountNeeded,
            ActionAbortedLocalProcessingError,
            ActionAbortedUnknownPageType,
            ActionNotTakenFileUnavailable,
            ActionNotTakenFileUnavailableOrBusy,
            ActionNotTakenFilenameNotAllowed,
            ActionNotTakenInsufficientSpace,
            ArgumentSyntaxError,
            BadCommandSequence,
            CantOpenData,
            ClosingControl,
            ClosingData,
            CommandExtraneous,
            CommandNotImplemented,
            CommandOK,
            CommandSyntaxError,
            ConnectionClosed,
            DataAlreadyOpen,
            DirectoryStatus,
            EnteringPassive,
            FileActionAborted,
            FileActionOK,
            FileCommandPending,
            FileStatus,
            LoggedInProceed,
            NeedLoginAccount,
            NotLoggedIn,
            OpeningData,
            PathnameCreated,
            RestartMarker,
            SendPasswordCommand,
            SendUserCommand,
            ServerWantsSecureSession,
            ServiceNotAvailable,
            ServiceTemporarilyNotAvailable,
            SystemType,
            Undefined,
        }

        // Generated from `System.Net.FtpWebRequest` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.FtpWebResponse` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.GlobalProxySelection` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class GlobalProxySelection
        {
            public static System.Net.IWebProxy GetEmptyWebProxy() => throw null;
            public GlobalProxySelection() => throw null;
            public static System.Net.IWebProxy Select { get => throw null; set => throw null; }
        }

        // Generated from `System.Net.HttpContinueDelegate` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public delegate void HttpContinueDelegate(int StatusCode, System.Net.WebHeaderCollection httpHeaders);

        // Generated from `System.Net.HttpWebRequest` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.HttpWebResponse` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.IAuthenticationModule` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IAuthenticationModule
        {
            System.Net.Authorization Authenticate(string challenge, System.Net.WebRequest request, System.Net.ICredentials credentials);
            string AuthenticationType { get; }
            bool CanPreAuthenticate { get; }
            System.Net.Authorization PreAuthenticate(System.Net.WebRequest request, System.Net.ICredentials credentials);
        }

        // Generated from `System.Net.ICredentialPolicy` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ICredentialPolicy
        {
            bool ShouldSendCredential(System.Uri challengeUri, System.Net.WebRequest request, System.Net.NetworkCredential credential, System.Net.IAuthenticationModule authenticationModule);
        }

        // Generated from `System.Net.IWebRequestCreate` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IWebRequestCreate
        {
            System.Net.WebRequest Create(System.Uri uri);
        }

        // Generated from `System.Net.ProtocolViolationException` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class ProtocolViolationException : System.InvalidOperationException, System.Runtime.Serialization.ISerializable
        {
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public ProtocolViolationException() => throw null;
            protected ProtocolViolationException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public ProtocolViolationException(string message) => throw null;
        }

        // Generated from `System.Net.WebException` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.WebExceptionStatus` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum WebExceptionStatus
        {
            CacheEntryNotFound,
            ConnectFailure,
            ConnectionClosed,
            KeepAliveFailure,
            MessageLengthLimitExceeded,
            NameResolutionFailure,
            Pending,
            PipelineFailure,
            ProtocolError,
            ProxyNameResolutionFailure,
            ReceiveFailure,
            RequestCanceled,
            RequestProhibitedByCachePolicy,
            RequestProhibitedByProxy,
            SecureChannelFailure,
            SendFailure,
            ServerProtocolViolation,
            Success,
            Timeout,
            TrustFailure,
            UnknownError,
        }

        // Generated from `System.Net.WebRequest` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.WebRequestMethods` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class WebRequestMethods
        {
            // Generated from `System.Net.WebRequestMethods+File` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class File
            {
                public const string DownloadFile = default;
                public const string UploadFile = default;
            }


            // Generated from `System.Net.WebRequestMethods+Ftp` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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


            // Generated from `System.Net.WebRequestMethods+Http` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.WebResponse` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            // Generated from `System.Net.Cache.HttpCacheAgeControl` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum HttpCacheAgeControl
            {
                MaxAge,
                MaxAgeAndMaxStale,
                MaxAgeAndMinFresh,
                MaxStale,
                MinFresh,
                None,
            }

            // Generated from `System.Net.Cache.HttpRequestCacheLevel` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum HttpRequestCacheLevel
            {
                BypassCache,
                CacheIfAvailable,
                CacheOnly,
                CacheOrNextCacheOnly,
                Default,
                NoCacheNoStore,
                Refresh,
                Reload,
                Revalidate,
            }

            // Generated from `System.Net.Cache.HttpRequestCachePolicy` in `System.Net.Requests, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
