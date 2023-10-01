// This file contains auto-generated code.
// Generated from `System.Net.Primitives, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Net
    {
        [System.Flags]
        public enum AuthenticationSchemes
        {
            None = 0,
            Digest = 1,
            Negotiate = 2,
            Ntlm = 4,
            IntegratedWindowsAuthentication = 6,
            Basic = 8,
            Anonymous = 32768,
        }
        namespace Cache
        {
            public enum RequestCacheLevel
            {
                Default = 0,
                BypassCache = 1,
                CacheOnly = 2,
                CacheIfAvailable = 3,
                Revalidate = 4,
                Reload = 5,
                NoCacheNoStore = 6,
            }
            public class RequestCachePolicy
            {
                public RequestCachePolicy() => throw null;
                public RequestCachePolicy(System.Net.Cache.RequestCacheLevel level) => throw null;
                public System.Net.Cache.RequestCacheLevel Level { get => throw null; }
                public override string ToString() => throw null;
            }
        }
        public sealed class Cookie
        {
            public string Comment { get => throw null; set { } }
            public System.Uri CommentUri { get => throw null; set { } }
            public Cookie() => throw null;
            public Cookie(string name, string value) => throw null;
            public Cookie(string name, string value, string path) => throw null;
            public Cookie(string name, string value, string path, string domain) => throw null;
            public bool Discard { get => throw null; set { } }
            public string Domain { get => throw null; set { } }
            public override bool Equals(object comparand) => throw null;
            public bool Expired { get => throw null; set { } }
            public System.DateTime Expires { get => throw null; set { } }
            public override int GetHashCode() => throw null;
            public bool HttpOnly { get => throw null; set { } }
            public string Name { get => throw null; set { } }
            public string Path { get => throw null; set { } }
            public string Port { get => throw null; set { } }
            public bool Secure { get => throw null; set { } }
            public System.DateTime TimeStamp { get => throw null; }
            public override string ToString() => throw null;
            public string Value { get => throw null; set { } }
            public int Version { get => throw null; set { } }
        }
        public class CookieCollection : System.Collections.Generic.ICollection<System.Net.Cookie>, System.Collections.ICollection, System.Collections.Generic.IEnumerable<System.Net.Cookie>, System.Collections.IEnumerable, System.Collections.Generic.IReadOnlyCollection<System.Net.Cookie>
        {
            public void Add(System.Net.Cookie cookie) => throw null;
            public void Add(System.Net.CookieCollection cookies) => throw null;
            public void Clear() => throw null;
            public bool Contains(System.Net.Cookie cookie) => throw null;
            public void CopyTo(System.Array array, int index) => throw null;
            public void CopyTo(System.Net.Cookie[] array, int index) => throw null;
            public int Count { get => throw null; }
            public CookieCollection() => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            System.Collections.Generic.IEnumerator<System.Net.Cookie> System.Collections.Generic.IEnumerable<System.Net.Cookie>.GetEnumerator() => throw null;
            public bool IsReadOnly { get => throw null; }
            public bool IsSynchronized { get => throw null; }
            public bool Remove(System.Net.Cookie cookie) => throw null;
            public object SyncRoot { get => throw null; }
            public System.Net.Cookie this[int index] { get => throw null; }
            public System.Net.Cookie this[string name] { get => throw null; }
        }
        public class CookieContainer
        {
            public void Add(System.Net.Cookie cookie) => throw null;
            public void Add(System.Net.CookieCollection cookies) => throw null;
            public void Add(System.Uri uri, System.Net.Cookie cookie) => throw null;
            public void Add(System.Uri uri, System.Net.CookieCollection cookies) => throw null;
            public int Capacity { get => throw null; set { } }
            public int Count { get => throw null; }
            public CookieContainer() => throw null;
            public CookieContainer(int capacity) => throw null;
            public CookieContainer(int capacity, int perDomainCapacity, int maxCookieSize) => throw null;
            public const int DefaultCookieLengthLimit = 4096;
            public const int DefaultCookieLimit = 300;
            public const int DefaultPerDomainCookieLimit = 20;
            public System.Net.CookieCollection GetAllCookies() => throw null;
            public string GetCookieHeader(System.Uri uri) => throw null;
            public System.Net.CookieCollection GetCookies(System.Uri uri) => throw null;
            public int MaxCookieSize { get => throw null; set { } }
            public int PerDomainCapacity { get => throw null; set { } }
            public void SetCookies(System.Uri uri, string cookieHeader) => throw null;
        }
        public class CookieException : System.FormatException, System.Runtime.Serialization.ISerializable
        {
            public CookieException() => throw null;
            protected CookieException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        }
        public class CredentialCache : System.Net.ICredentials, System.Net.ICredentialsByHost, System.Collections.IEnumerable
        {
            public void Add(string host, int port, string authenticationType, System.Net.NetworkCredential credential) => throw null;
            public void Add(System.Uri uriPrefix, string authType, System.Net.NetworkCredential cred) => throw null;
            public CredentialCache() => throw null;
            public static System.Net.ICredentials DefaultCredentials { get => throw null; }
            public static System.Net.NetworkCredential DefaultNetworkCredentials { get => throw null; }
            public System.Net.NetworkCredential GetCredential(string host, int port, string authenticationType) => throw null;
            public System.Net.NetworkCredential GetCredential(System.Uri uriPrefix, string authType) => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            public void Remove(string host, int port, string authenticationType) => throw null;
            public void Remove(System.Uri uriPrefix, string authType) => throw null;
        }
        [System.Flags]
        public enum DecompressionMethods
        {
            All = -1,
            None = 0,
            GZip = 1,
            Deflate = 2,
            Brotli = 4,
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
        public enum HttpStatusCode
        {
            Continue = 100,
            SwitchingProtocols = 101,
            Processing = 102,
            EarlyHints = 103,
            OK = 200,
            Created = 201,
            Accepted = 202,
            NonAuthoritativeInformation = 203,
            NoContent = 204,
            ResetContent = 205,
            PartialContent = 206,
            MultiStatus = 207,
            AlreadyReported = 208,
            IMUsed = 226,
            Ambiguous = 300,
            MultipleChoices = 300,
            Moved = 301,
            MovedPermanently = 301,
            Found = 302,
            Redirect = 302,
            RedirectMethod = 303,
            SeeOther = 303,
            NotModified = 304,
            UseProxy = 305,
            Unused = 306,
            RedirectKeepVerb = 307,
            TemporaryRedirect = 307,
            PermanentRedirect = 308,
            BadRequest = 400,
            Unauthorized = 401,
            PaymentRequired = 402,
            Forbidden = 403,
            NotFound = 404,
            MethodNotAllowed = 405,
            NotAcceptable = 406,
            ProxyAuthenticationRequired = 407,
            RequestTimeout = 408,
            Conflict = 409,
            Gone = 410,
            LengthRequired = 411,
            PreconditionFailed = 412,
            RequestEntityTooLarge = 413,
            RequestUriTooLong = 414,
            UnsupportedMediaType = 415,
            RequestedRangeNotSatisfiable = 416,
            ExpectationFailed = 417,
            MisdirectedRequest = 421,
            UnprocessableEntity = 422,
            Locked = 423,
            FailedDependency = 424,
            UpgradeRequired = 426,
            PreconditionRequired = 428,
            TooManyRequests = 429,
            RequestHeaderFieldsTooLarge = 431,
            UnavailableForLegalReasons = 451,
            InternalServerError = 500,
            NotImplemented = 501,
            BadGateway = 502,
            ServiceUnavailable = 503,
            GatewayTimeout = 504,
            HttpVersionNotSupported = 505,
            VariantAlsoNegotiates = 506,
            InsufficientStorage = 507,
            LoopDetected = 508,
            NotExtended = 510,
            NetworkAuthenticationRequired = 511,
        }
        public static class HttpVersion
        {
            public static readonly System.Version Unknown;
            public static readonly System.Version Version10;
            public static readonly System.Version Version11;
            public static readonly System.Version Version20;
            public static readonly System.Version Version30;
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
            public long Address { get => throw null; set { } }
            public System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
            public static readonly System.Net.IPAddress Any;
            public static readonly System.Net.IPAddress Broadcast;
            public IPAddress(byte[] address) => throw null;
            public IPAddress(byte[] address, long scopeid) => throw null;
            public IPAddress(long newAddress) => throw null;
            public IPAddress(System.ReadOnlySpan<byte> address) => throw null;
            public IPAddress(System.ReadOnlySpan<byte> address, long scopeid) => throw null;
            public override bool Equals(object comparand) => throw null;
            public byte[] GetAddressBytes() => throw null;
            public override int GetHashCode() => throw null;
            public static short HostToNetworkOrder(short host) => throw null;
            public static int HostToNetworkOrder(int host) => throw null;
            public static long HostToNetworkOrder(long host) => throw null;
            public static readonly System.Net.IPAddress IPv6Any;
            public static readonly System.Net.IPAddress IPv6Loopback;
            public static readonly System.Net.IPAddress IPv6None;
            public bool IsIPv4MappedToIPv6 { get => throw null; }
            public bool IsIPv6LinkLocal { get => throw null; }
            public bool IsIPv6Multicast { get => throw null; }
            public bool IsIPv6SiteLocal { get => throw null; }
            public bool IsIPv6Teredo { get => throw null; }
            public bool IsIPv6UniqueLocal { get => throw null; }
            public static bool IsLoopback(System.Net.IPAddress address) => throw null;
            public static readonly System.Net.IPAddress Loopback;
            public System.Net.IPAddress MapToIPv4() => throw null;
            public System.Net.IPAddress MapToIPv6() => throw null;
            public static short NetworkToHostOrder(short network) => throw null;
            public static int NetworkToHostOrder(int network) => throw null;
            public static long NetworkToHostOrder(long network) => throw null;
            public static readonly System.Net.IPAddress None;
            public static System.Net.IPAddress Parse(System.ReadOnlySpan<char> ipSpan) => throw null;
            public static System.Net.IPAddress Parse(string ipString) => throw null;
            public long ScopeId { get => throw null; set { } }
            public override string ToString() => throw null;
            public bool TryFormat(System.Span<char> destination, out int charsWritten) => throw null;
            public static bool TryParse(System.ReadOnlySpan<char> ipSpan, out System.Net.IPAddress address) => throw null;
            public static bool TryParse(string ipString, out System.Net.IPAddress address) => throw null;
            public bool TryWriteBytes(System.Span<byte> destination, out int bytesWritten) => throw null;
        }
        public class IPEndPoint : System.Net.EndPoint
        {
            public System.Net.IPAddress Address { get => throw null; set { } }
            public override System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
            public override System.Net.EndPoint Create(System.Net.SocketAddress socketAddress) => throw null;
            public IPEndPoint(long address, int port) => throw null;
            public IPEndPoint(System.Net.IPAddress address, int port) => throw null;
            public override bool Equals(object comparand) => throw null;
            public override int GetHashCode() => throw null;
            public const int MaxPort = 65535;
            public const int MinPort = 0;
            public static System.Net.IPEndPoint Parse(System.ReadOnlySpan<char> s) => throw null;
            public static System.Net.IPEndPoint Parse(string s) => throw null;
            public int Port { get => throw null; set { } }
            public override System.Net.SocketAddress Serialize() => throw null;
            public override string ToString() => throw null;
            public static bool TryParse(System.ReadOnlySpan<char> s, out System.Net.IPEndPoint result) => throw null;
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
            public NetworkCredential() => throw null;
            public NetworkCredential(string userName, System.Security.SecureString password) => throw null;
            public NetworkCredential(string userName, System.Security.SecureString password, string domain) => throw null;
            public NetworkCredential(string userName, string password) => throw null;
            public NetworkCredential(string userName, string password, string domain) => throw null;
            public string Domain { get => throw null; set { } }
            public System.Net.NetworkCredential GetCredential(string host, int port, string authenticationType) => throw null;
            public System.Net.NetworkCredential GetCredential(System.Uri uri, string authenticationType) => throw null;
            public string Password { get => throw null; set { } }
            public System.Security.SecureString SecurePassword { get => throw null; set { } }
            public string UserName { get => throw null; set { } }
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
                protected IPAddressCollection() => throw null;
                public virtual System.Collections.Generic.IEnumerator<System.Net.IPAddress> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public virtual bool IsReadOnly { get => throw null; }
                public virtual bool Remove(System.Net.IPAddress address) => throw null;
                public virtual System.Net.IPAddress this[int index] { get => throw null; }
            }
        }
        namespace Security
        {
            public enum AuthenticationLevel
            {
                None = 0,
                MutualAuthRequested = 1,
                MutualAuthRequired = 2,
            }
            [System.Flags]
            public enum SslPolicyErrors
            {
                None = 0,
                RemoteCertificateNotAvailable = 1,
                RemoteCertificateNameMismatch = 2,
                RemoteCertificateChainErrors = 4,
            }
        }
        public class SocketAddress
        {
            public SocketAddress(System.Net.Sockets.AddressFamily family) => throw null;
            public SocketAddress(System.Net.Sockets.AddressFamily family, int size) => throw null;
            public override bool Equals(object comparand) => throw null;
            public System.Net.Sockets.AddressFamily Family { get => throw null; }
            public override int GetHashCode() => throw null;
            public int Size { get => throw null; }
            public byte this[int offset] { get => throw null; set { } }
            public override string ToString() => throw null;
        }
        namespace Sockets
        {
            public enum AddressFamily
            {
                Unknown = -1,
                Unspecified = 0,
                Unix = 1,
                InterNetwork = 2,
                ImpLink = 3,
                Pup = 4,
                Chaos = 5,
                Ipx = 6,
                NS = 6,
                Iso = 7,
                Osi = 7,
                Ecma = 8,
                DataKit = 9,
                Ccitt = 10,
                Sna = 11,
                DecNet = 12,
                DataLink = 13,
                Lat = 14,
                HyperChannel = 15,
                AppleTalk = 16,
                NetBios = 17,
                VoiceView = 18,
                FireFox = 19,
                Banyan = 21,
                Atm = 22,
                InterNetworkV6 = 23,
                Cluster = 24,
                Ieee12844 = 25,
                Irda = 26,
                NetworkDesigners = 28,
                Max = 29,
                Packet = 65536,
                ControllerAreaNetwork = 65537,
            }
            public enum SocketError
            {
                SocketError = -1,
                Success = 0,
                OperationAborted = 995,
                IOPending = 997,
                Interrupted = 10004,
                AccessDenied = 10013,
                Fault = 10014,
                InvalidArgument = 10022,
                TooManyOpenSockets = 10024,
                WouldBlock = 10035,
                InProgress = 10036,
                AlreadyInProgress = 10037,
                NotSocket = 10038,
                DestinationAddressRequired = 10039,
                MessageSize = 10040,
                ProtocolType = 10041,
                ProtocolOption = 10042,
                ProtocolNotSupported = 10043,
                SocketNotSupported = 10044,
                OperationNotSupported = 10045,
                ProtocolFamilyNotSupported = 10046,
                AddressFamilyNotSupported = 10047,
                AddressAlreadyInUse = 10048,
                AddressNotAvailable = 10049,
                NetworkDown = 10050,
                NetworkUnreachable = 10051,
                NetworkReset = 10052,
                ConnectionAborted = 10053,
                ConnectionReset = 10054,
                NoBufferSpaceAvailable = 10055,
                IsConnected = 10056,
                NotConnected = 10057,
                Shutdown = 10058,
                TimedOut = 10060,
                ConnectionRefused = 10061,
                HostDown = 10064,
                HostUnreachable = 10065,
                ProcessLimit = 10067,
                SystemNotReady = 10091,
                VersionNotSupported = 10092,
                NotInitialized = 10093,
                Disconnecting = 10101,
                TypeNotFound = 10109,
                HostNotFound = 11001,
                TryAgain = 11002,
                NoRecovery = 11003,
                NoData = 11004,
            }
            public class SocketException : System.ComponentModel.Win32Exception
            {
                public SocketException() => throw null;
                public SocketException(int errorCode) => throw null;
                protected SocketException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public override int ErrorCode { get => throw null; }
                public override string Message { get => throw null; }
                public System.Net.Sockets.SocketError SocketErrorCode { get => throw null; }
            }
        }
        public abstract class TransportContext
        {
            protected TransportContext() => throw null;
            public abstract System.Security.Authentication.ExtendedProtection.ChannelBinding GetChannelBinding(System.Security.Authentication.ExtendedProtection.ChannelBindingKind kind);
        }
    }
    namespace Security
    {
        namespace Authentication
        {
            public enum CipherAlgorithmType
            {
                None = 0,
                Null = 24576,
                Des = 26113,
                Rc2 = 26114,
                TripleDes = 26115,
                Aes128 = 26126,
                Aes192 = 26127,
                Aes256 = 26128,
                Aes = 26129,
                Rc4 = 26625,
            }
            public enum ExchangeAlgorithmType
            {
                None = 0,
                RsaSign = 9216,
                RsaKeyX = 41984,
                DiffieHellman = 43522,
            }
            namespace ExtendedProtection
            {
                public abstract class ChannelBinding : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
                {
                    protected ChannelBinding() : base(default(bool)) => throw null;
                    protected ChannelBinding(bool ownsHandle) : base(default(bool)) => throw null;
                    public abstract int Size { get; }
                }
                public enum ChannelBindingKind
                {
                    Unknown = 0,
                    Unique = 25,
                    Endpoint = 26,
                }
            }
            public enum HashAlgorithmType
            {
                None = 0,
                Md5 = 32771,
                Sha1 = 32772,
                Sha256 = 32780,
                Sha384 = 32781,
                Sha512 = 32782,
            }
            [System.Flags]
            public enum SslProtocols
            {
                None = 0,
                Ssl2 = 12,
                Ssl3 = 48,
                Tls = 192,
                Default = 240,
                Tls11 = 768,
                Tls12 = 3072,
                Tls13 = 12288,
            }
        }
    }
}
