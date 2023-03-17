// This file contains auto-generated code.
// Generated from `System.Net.Primitives, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    namespace Net
    {
        [System.Flags]
        public enum AuthenticationSchemes : int
        {
            Anonymous = 32768,
            Basic = 8,
            Digest = 1,
            IntegratedWindowsAuthentication = 6,
            Negotiate = 2,
            None = 0,
            Ntlm = 4,
        }

        public class Cookie
        {
            public string Comment { get => throw null; set => throw null; }
            public System.Uri CommentUri { get => throw null; set => throw null; }
            public Cookie() => throw null;
            public Cookie(string name, string value) => throw null;
            public Cookie(string name, string value, string path) => throw null;
            public Cookie(string name, string value, string path, string domain) => throw null;
            public bool Discard { get => throw null; set => throw null; }
            public string Domain { get => throw null; set => throw null; }
            public override bool Equals(object comparand) => throw null;
            public bool Expired { get => throw null; set => throw null; }
            public System.DateTime Expires { get => throw null; set => throw null; }
            public override int GetHashCode() => throw null;
            public bool HttpOnly { get => throw null; set => throw null; }
            public string Name { get => throw null; set => throw null; }
            public string Path { get => throw null; set => throw null; }
            public string Port { get => throw null; set => throw null; }
            public bool Secure { get => throw null; set => throw null; }
            public System.DateTime TimeStamp { get => throw null; }
            public override string ToString() => throw null;
            public string Value { get => throw null; set => throw null; }
            public int Version { get => throw null; set => throw null; }
        }

        public class CookieCollection : System.Collections.Generic.ICollection<System.Net.Cookie>, System.Collections.Generic.IEnumerable<System.Net.Cookie>, System.Collections.Generic.IReadOnlyCollection<System.Net.Cookie>, System.Collections.ICollection, System.Collections.IEnumerable
        {
            public void Add(System.Net.Cookie cookie) => throw null;
            public void Add(System.Net.CookieCollection cookies) => throw null;
            public void Clear() => throw null;
            public bool Contains(System.Net.Cookie cookie) => throw null;
            public CookieCollection() => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public void CopyTo(System.Net.Cookie[] array, int index) => throw null;
            public int Count { get => throw null; }
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            System.Collections.Generic.IEnumerator<System.Net.Cookie> System.Collections.Generic.IEnumerable<System.Net.Cookie>.GetEnumerator() => throw null;
            public bool IsReadOnly { get => throw null; }
            public bool IsSynchronized { get => throw null; }
            public System.Net.Cookie this[int index] { get => throw null; }
            public System.Net.Cookie this[string name] { get => throw null; }
            public bool Remove(System.Net.Cookie cookie) => throw null;
            public object SyncRoot { get => throw null; }
        }

        public class CookieContainer
        {
            public void Add(System.Net.Cookie cookie) => throw null;
            public void Add(System.Net.CookieCollection cookies) => throw null;
            public void Add(System.Uri uri, System.Net.Cookie cookie) => throw null;
            public void Add(System.Uri uri, System.Net.CookieCollection cookies) => throw null;
            public int Capacity { get => throw null; set => throw null; }
            public CookieContainer() => throw null;
            public CookieContainer(int capacity) => throw null;
            public CookieContainer(int capacity, int perDomainCapacity, int maxCookieSize) => throw null;
            public int Count { get => throw null; }
            public const int DefaultCookieLengthLimit = default;
            public const int DefaultCookieLimit = default;
            public const int DefaultPerDomainCookieLimit = default;
            public System.Net.CookieCollection GetAllCookies() => throw null;
            public string GetCookieHeader(System.Uri uri) => throw null;
            public System.Net.CookieCollection GetCookies(System.Uri uri) => throw null;
            public int MaxCookieSize { get => throw null; set => throw null; }
            public int PerDomainCapacity { get => throw null; set => throw null; }
            public void SetCookies(System.Uri uri, string cookieHeader) => throw null;
        }

        public class CookieException : System.FormatException, System.Runtime.Serialization.ISerializable
        {
            public CookieException() => throw null;
            protected CookieException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        }

        public class CredentialCache : System.Collections.IEnumerable, System.Net.ICredentials, System.Net.ICredentialsByHost
        {
            public void Add(System.Uri uriPrefix, string authType, System.Net.NetworkCredential cred) => throw null;
            public void Add(string host, int port, string authenticationType, System.Net.NetworkCredential credential) => throw null;
            public CredentialCache() => throw null;
            public static System.Net.ICredentials DefaultCredentials { get => throw null; }
            public static System.Net.NetworkCredential DefaultNetworkCredentials { get => throw null; }
            public System.Net.NetworkCredential GetCredential(System.Uri uriPrefix, string authType) => throw null;
            public System.Net.NetworkCredential GetCredential(string host, int port, string authenticationType) => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public void Remove(System.Uri uriPrefix, string authType) => throw null;
            public void Remove(string host, int port, string authenticationType) => throw null;
        }

        [System.Flags]
        public enum DecompressionMethods : int
        {
            All = -1,
            Brotli = 4,
            Deflate = 2,
            GZip = 1,
            None = 0,
        }

        public class DnsEndPoint : System.Net.EndPoint
        {
            public override System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
            public DnsEndPoint(string host, int port) => throw null;
            public DnsEndPoint(string host, int port, System.Net.Sockets.AddressFamily addressFamily) => throw null;
            public override bool Equals(object comparand) => throw null;
            public override int GetHashCode() => throw null;
            public string Host { get => throw null; }
            public int Port { get => throw null; }
            public override string ToString() => throw null;
        }

        public abstract class EndPoint
        {
            public virtual System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
            public virtual System.Net.EndPoint Create(System.Net.SocketAddress socketAddress) => throw null;
            protected EndPoint() => throw null;
            public virtual System.Net.SocketAddress Serialize() => throw null;
        }

        public enum HttpStatusCode : int
        {
            Accepted = 202,
            AlreadyReported = 208,
            Ambiguous = 300,
            BadGateway = 502,
            BadRequest = 400,
            Conflict = 409,
            Continue = 100,
            Created = 201,
            EarlyHints = 103,
            ExpectationFailed = 417,
            FailedDependency = 424,
            Forbidden = 403,
            Found = 302,
            GatewayTimeout = 504,
            Gone = 410,
            HttpVersionNotSupported = 505,
            IMUsed = 226,
            InsufficientStorage = 507,
            InternalServerError = 500,
            LengthRequired = 411,
            Locked = 423,
            LoopDetected = 508,
            MethodNotAllowed = 405,
            MisdirectedRequest = 421,
            Moved = 301,
            MovedPermanently = 301,
            MultiStatus = 207,
            MultipleChoices = 300,
            NetworkAuthenticationRequired = 511,
            NoContent = 204,
            NonAuthoritativeInformation = 203,
            NotAcceptable = 406,
            NotExtended = 510,
            NotFound = 404,
            NotImplemented = 501,
            NotModified = 304,
            OK = 200,
            PartialContent = 206,
            PaymentRequired = 402,
            PermanentRedirect = 308,
            PreconditionFailed = 412,
            PreconditionRequired = 428,
            Processing = 102,
            ProxyAuthenticationRequired = 407,
            Redirect = 302,
            RedirectKeepVerb = 307,
            RedirectMethod = 303,
            RequestEntityTooLarge = 413,
            RequestHeaderFieldsTooLarge = 431,
            RequestTimeout = 408,
            RequestUriTooLong = 414,
            RequestedRangeNotSatisfiable = 416,
            ResetContent = 205,
            SeeOther = 303,
            ServiceUnavailable = 503,
            SwitchingProtocols = 101,
            TemporaryRedirect = 307,
            TooManyRequests = 429,
            Unauthorized = 401,
            UnavailableForLegalReasons = 451,
            UnprocessableEntity = 422,
            UnsupportedMediaType = 415,
            Unused = 306,
            UpgradeRequired = 426,
            UseProxy = 305,
            VariantAlsoNegotiates = 506,
        }

        public static class HttpVersion
        {
            public static System.Version Unknown;
            public static System.Version Version10;
            public static System.Version Version11;
            public static System.Version Version20;
            public static System.Version Version30;
        }

        public interface ICredentials
        {
            System.Net.NetworkCredential GetCredential(System.Uri uri, string authType);
        }

        public interface ICredentialsByHost
        {
            System.Net.NetworkCredential GetCredential(string host, int port, string authenticationType);
        }

        public class IPAddress
        {
            public System.Int64 Address { get => throw null; set => throw null; }
            public System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
            public static System.Net.IPAddress Any;
            public static System.Net.IPAddress Broadcast;
            public override bool Equals(object comparand) => throw null;
            public System.Byte[] GetAddressBytes() => throw null;
            public override int GetHashCode() => throw null;
            public static int HostToNetworkOrder(int host) => throw null;
            public static System.Int64 HostToNetworkOrder(System.Int64 host) => throw null;
            public static System.Int16 HostToNetworkOrder(System.Int16 host) => throw null;
            public IPAddress(System.Byte[] address) => throw null;
            public IPAddress(System.Byte[] address, System.Int64 scopeid) => throw null;
            public IPAddress(System.ReadOnlySpan<System.Byte> address) => throw null;
            public IPAddress(System.ReadOnlySpan<System.Byte> address, System.Int64 scopeid) => throw null;
            public IPAddress(System.Int64 newAddress) => throw null;
            public static System.Net.IPAddress IPv6Any;
            public static System.Net.IPAddress IPv6Loopback;
            public static System.Net.IPAddress IPv6None;
            public bool IsIPv4MappedToIPv6 { get => throw null; }
            public bool IsIPv6LinkLocal { get => throw null; }
            public bool IsIPv6Multicast { get => throw null; }
            public bool IsIPv6SiteLocal { get => throw null; }
            public bool IsIPv6Teredo { get => throw null; }
            public bool IsIPv6UniqueLocal { get => throw null; }
            public static bool IsLoopback(System.Net.IPAddress address) => throw null;
            public static System.Net.IPAddress Loopback;
            public System.Net.IPAddress MapToIPv4() => throw null;
            public System.Net.IPAddress MapToIPv6() => throw null;
            public static int NetworkToHostOrder(int network) => throw null;
            public static System.Int64 NetworkToHostOrder(System.Int64 network) => throw null;
            public static System.Int16 NetworkToHostOrder(System.Int16 network) => throw null;
            public static System.Net.IPAddress None;
            public static System.Net.IPAddress Parse(System.ReadOnlySpan<System.Char> ipSpan) => throw null;
            public static System.Net.IPAddress Parse(string ipString) => throw null;
            public System.Int64 ScopeId { get => throw null; set => throw null; }
            public override string ToString() => throw null;
            public bool TryFormat(System.Span<System.Char> destination, out int charsWritten) => throw null;
            public static bool TryParse(System.ReadOnlySpan<System.Char> ipSpan, out System.Net.IPAddress address) => throw null;
            public static bool TryParse(string ipString, out System.Net.IPAddress address) => throw null;
            public bool TryWriteBytes(System.Span<System.Byte> destination, out int bytesWritten) => throw null;
        }

        public class IPEndPoint : System.Net.EndPoint
        {
            public System.Net.IPAddress Address { get => throw null; set => throw null; }
            public override System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
            public override System.Net.EndPoint Create(System.Net.SocketAddress socketAddress) => throw null;
            public override bool Equals(object comparand) => throw null;
            public override int GetHashCode() => throw null;
            public IPEndPoint(System.Net.IPAddress address, int port) => throw null;
            public IPEndPoint(System.Int64 address, int port) => throw null;
            public const int MaxPort = default;
            public const int MinPort = default;
            public static System.Net.IPEndPoint Parse(System.ReadOnlySpan<System.Char> s) => throw null;
            public static System.Net.IPEndPoint Parse(string s) => throw null;
            public int Port { get => throw null; set => throw null; }
            public override System.Net.SocketAddress Serialize() => throw null;
            public override string ToString() => throw null;
            public static bool TryParse(System.ReadOnlySpan<System.Char> s, out System.Net.IPEndPoint result) => throw null;
            public static bool TryParse(string s, out System.Net.IPEndPoint result) => throw null;
        }

        public interface IWebProxy
        {
            System.Net.ICredentials Credentials { get; set; }
            System.Uri GetProxy(System.Uri destination);
            bool IsBypassed(System.Uri host);
        }

        public class NetworkCredential : System.Net.ICredentials, System.Net.ICredentialsByHost
        {
            public string Domain { get => throw null; set => throw null; }
            public System.Net.NetworkCredential GetCredential(System.Uri uri, string authenticationType) => throw null;
            public System.Net.NetworkCredential GetCredential(string host, int port, string authenticationType) => throw null;
            public NetworkCredential() => throw null;
            public NetworkCredential(string userName, System.Security.SecureString password) => throw null;
            public NetworkCredential(string userName, System.Security.SecureString password, string domain) => throw null;
            public NetworkCredential(string userName, string password) => throw null;
            public NetworkCredential(string userName, string password, string domain) => throw null;
            public string Password { get => throw null; set => throw null; }
            public System.Security.SecureString SecurePassword { get => throw null; set => throw null; }
            public string UserName { get => throw null; set => throw null; }
        }

        public class SocketAddress
        {
            public override bool Equals(object comparand) => throw null;
            public System.Net.Sockets.AddressFamily Family { get => throw null; }
            public override int GetHashCode() => throw null;
            public System.Byte this[int offset] { get => throw null; set => throw null; }
            public int Size { get => throw null; }
            public SocketAddress(System.Net.Sockets.AddressFamily family) => throw null;
            public SocketAddress(System.Net.Sockets.AddressFamily family, int size) => throw null;
            public override string ToString() => throw null;
        }

        public abstract class TransportContext
        {
            public abstract System.Security.Authentication.ExtendedProtection.ChannelBinding GetChannelBinding(System.Security.Authentication.ExtendedProtection.ChannelBindingKind kind);
            protected TransportContext() => throw null;
        }

        namespace Cache
        {
            public enum RequestCacheLevel : int
            {
                BypassCache = 1,
                CacheIfAvailable = 3,
                CacheOnly = 2,
                Default = 0,
                NoCacheNoStore = 6,
                Reload = 5,
                Revalidate = 4,
            }

            public class RequestCachePolicy
            {
                public System.Net.Cache.RequestCacheLevel Level { get => throw null; }
                public RequestCachePolicy() => throw null;
                public RequestCachePolicy(System.Net.Cache.RequestCacheLevel level) => throw null;
                public override string ToString() => throw null;
            }

        }
        namespace NetworkInformation
        {
            public class IPAddressCollection : System.Collections.Generic.ICollection<System.Net.IPAddress>, System.Collections.Generic.IEnumerable<System.Net.IPAddress>, System.Collections.IEnumerable
            {
                public virtual void Add(System.Net.IPAddress address) => throw null;
                public virtual void Clear() => throw null;
                public virtual bool Contains(System.Net.IPAddress address) => throw null;
                public virtual void CopyTo(System.Net.IPAddress[] array, int offset) => throw null;
                public virtual int Count { get => throw null; }
                public virtual System.Collections.Generic.IEnumerator<System.Net.IPAddress> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                protected internal IPAddressCollection() => throw null;
                public virtual bool IsReadOnly { get => throw null; }
                public virtual System.Net.IPAddress this[int index] { get => throw null; }
                public virtual bool Remove(System.Net.IPAddress address) => throw null;
            }

        }
        namespace Security
        {
            public enum AuthenticationLevel : int
            {
                MutualAuthRequested = 1,
                MutualAuthRequired = 2,
                None = 0,
            }

            [System.Flags]
            public enum SslPolicyErrors : int
            {
                None = 0,
                RemoteCertificateChainErrors = 4,
                RemoteCertificateNameMismatch = 2,
                RemoteCertificateNotAvailable = 1,
            }

        }
        namespace Sockets
        {
            public enum AddressFamily : int
            {
                AppleTalk = 16,
                Atm = 22,
                Banyan = 21,
                Ccitt = 10,
                Chaos = 5,
                Cluster = 24,
                ControllerAreaNetwork = 65537,
                DataKit = 9,
                DataLink = 13,
                DecNet = 12,
                Ecma = 8,
                FireFox = 19,
                HyperChannel = 15,
                Ieee12844 = 25,
                ImpLink = 3,
                InterNetwork = 2,
                InterNetworkV6 = 23,
                Ipx = 6,
                Irda = 26,
                Iso = 7,
                Lat = 14,
                Max = 29,
                NS = 6,
                NetBios = 17,
                NetworkDesigners = 28,
                Osi = 7,
                Packet = 65536,
                Pup = 4,
                Sna = 11,
                Unix = 1,
                Unknown = -1,
                Unspecified = 0,
                VoiceView = 18,
            }

            public enum SocketError : int
            {
                AccessDenied = 10013,
                AddressAlreadyInUse = 10048,
                AddressFamilyNotSupported = 10047,
                AddressNotAvailable = 10049,
                AlreadyInProgress = 10037,
                ConnectionAborted = 10053,
                ConnectionRefused = 10061,
                ConnectionReset = 10054,
                DestinationAddressRequired = 10039,
                Disconnecting = 10101,
                Fault = 10014,
                HostDown = 10064,
                HostNotFound = 11001,
                HostUnreachable = 10065,
                IOPending = 997,
                InProgress = 10036,
                Interrupted = 10004,
                InvalidArgument = 10022,
                IsConnected = 10056,
                MessageSize = 10040,
                NetworkDown = 10050,
                NetworkReset = 10052,
                NetworkUnreachable = 10051,
                NoBufferSpaceAvailable = 10055,
                NoData = 11004,
                NoRecovery = 11003,
                NotConnected = 10057,
                NotInitialized = 10093,
                NotSocket = 10038,
                OperationAborted = 995,
                OperationNotSupported = 10045,
                ProcessLimit = 10067,
                ProtocolFamilyNotSupported = 10046,
                ProtocolNotSupported = 10043,
                ProtocolOption = 10042,
                ProtocolType = 10041,
                Shutdown = 10058,
                SocketError = -1,
                SocketNotSupported = 10044,
                Success = 0,
                SystemNotReady = 10091,
                TimedOut = 10060,
                TooManyOpenSockets = 10024,
                TryAgain = 11002,
                TypeNotFound = 10109,
                VersionNotSupported = 10092,
                WouldBlock = 10035,
            }

            public class SocketException : System.ComponentModel.Win32Exception
            {
                public override int ErrorCode { get => throw null; }
                public override string Message { get => throw null; }
                public System.Net.Sockets.SocketError SocketErrorCode { get => throw null; }
                public SocketException() => throw null;
                protected SocketException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public SocketException(int errorCode) => throw null;
            }

        }
    }
    namespace Security
    {
        namespace Authentication
        {
            public enum CipherAlgorithmType : int
            {
                Aes = 26129,
                Aes128 = 26126,
                Aes192 = 26127,
                Aes256 = 26128,
                Des = 26113,
                None = 0,
                Null = 24576,
                Rc2 = 26114,
                Rc4 = 26625,
                TripleDes = 26115,
            }

            public enum ExchangeAlgorithmType : int
            {
                DiffieHellman = 43522,
                None = 0,
                RsaKeyX = 41984,
                RsaSign = 9216,
            }

            public enum HashAlgorithmType : int
            {
                Md5 = 32771,
                None = 0,
                Sha1 = 32772,
                Sha256 = 32780,
                Sha384 = 32781,
                Sha512 = 32782,
            }

            [System.Flags]
            public enum SslProtocols : int
            {
                Default = 240,
                None = 0,
                Ssl2 = 12,
                Ssl3 = 48,
                Tls = 192,
                Tls11 = 768,
                Tls12 = 3072,
                Tls13 = 12288,
            }

            namespace ExtendedProtection
            {
                public abstract class ChannelBinding : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
                {
                    protected ChannelBinding() : base(default(bool)) => throw null;
                    protected ChannelBinding(bool ownsHandle) : base(default(bool)) => throw null;
                    public abstract int Size { get; }
                }

                public enum ChannelBindingKind : int
                {
                    Endpoint = 26,
                    Unique = 25,
                    Unknown = 0,
                }

            }
        }
    }
}
