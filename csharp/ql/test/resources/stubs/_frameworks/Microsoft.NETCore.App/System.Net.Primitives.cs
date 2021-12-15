// This file contains auto-generated code.

namespace System
{
    namespace Net
    {
        // Generated from `System.Net.AuthenticationSchemes` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum AuthenticationSchemes
        {
            Anonymous,
            Basic,
            Digest,
            IntegratedWindowsAuthentication,
            Negotiate,
            None,
            Ntlm,
        }

        // Generated from `System.Net.Cookie` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.CookieCollection` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.CookieContainer` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            public string GetCookieHeader(System.Uri uri) => throw null;
            public System.Net.CookieCollection GetCookies(System.Uri uri) => throw null;
            public int MaxCookieSize { get => throw null; set => throw null; }
            public int PerDomainCapacity { get => throw null; set => throw null; }
            public void SetCookies(System.Uri uri, string cookieHeader) => throw null;
        }

        // Generated from `System.Net.CookieException` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class CookieException : System.FormatException, System.Runtime.Serialization.ISerializable
        {
            public CookieException() => throw null;
            protected CookieException(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
        }

        // Generated from `System.Net.CredentialCache` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.DecompressionMethods` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum DecompressionMethods
        {
            All,
            Brotli,
            Deflate,
            GZip,
            None,
        }

        // Generated from `System.Net.DnsEndPoint` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.EndPoint` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class EndPoint
        {
            public virtual System.Net.Sockets.AddressFamily AddressFamily { get => throw null; }
            public virtual System.Net.EndPoint Create(System.Net.SocketAddress socketAddress) => throw null;
            protected EndPoint() => throw null;
            public virtual System.Net.SocketAddress Serialize() => throw null;
        }

        // Generated from `System.Net.HttpStatusCode` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum HttpStatusCode
        {
            Accepted,
            AlreadyReported,
            Ambiguous,
            BadGateway,
            BadRequest,
            Conflict,
            Continue,
            Created,
            EarlyHints,
            ExpectationFailed,
            FailedDependency,
            Forbidden,
            Found,
            GatewayTimeout,
            Gone,
            HttpVersionNotSupported,
            IMUsed,
            InsufficientStorage,
            InternalServerError,
            LengthRequired,
            Locked,
            LoopDetected,
            MethodNotAllowed,
            MisdirectedRequest,
            Moved,
            MovedPermanently,
            MultiStatus,
            MultipleChoices,
            NetworkAuthenticationRequired,
            NoContent,
            NonAuthoritativeInformation,
            NotAcceptable,
            NotExtended,
            NotFound,
            NotImplemented,
            NotModified,
            OK,
            PartialContent,
            PaymentRequired,
            PermanentRedirect,
            PreconditionFailed,
            PreconditionRequired,
            Processing,
            ProxyAuthenticationRequired,
            Redirect,
            RedirectKeepVerb,
            RedirectMethod,
            RequestEntityTooLarge,
            RequestHeaderFieldsTooLarge,
            RequestTimeout,
            RequestUriTooLong,
            RequestedRangeNotSatisfiable,
            ResetContent,
            SeeOther,
            ServiceUnavailable,
            SwitchingProtocols,
            TemporaryRedirect,
            TooManyRequests,
            Unauthorized,
            UnavailableForLegalReasons,
            UnprocessableEntity,
            UnsupportedMediaType,
            Unused,
            UpgradeRequired,
            UseProxy,
            VariantAlsoNegotiates,
        }

        // Generated from `System.Net.HttpVersion` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class HttpVersion
        {
            public static System.Version Unknown;
            public static System.Version Version10;
            public static System.Version Version11;
            public static System.Version Version20;
        }

        // Generated from `System.Net.ICredentials` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ICredentials
        {
            System.Net.NetworkCredential GetCredential(System.Uri uri, string authType);
        }

        // Generated from `System.Net.ICredentialsByHost` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface ICredentialsByHost
        {
            System.Net.NetworkCredential GetCredential(string host, int port, string authenticationType);
        }

        // Generated from `System.Net.IPAddress` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.IPEndPoint` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.IWebProxy` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public interface IWebProxy
        {
            System.Net.ICredentials Credentials { get; set; }
            System.Uri GetProxy(System.Uri destination);
            bool IsBypassed(System.Uri host);
        }

        // Generated from `System.Net.NetworkCredential` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.SocketAddress` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

        // Generated from `System.Net.TransportContext` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public abstract class TransportContext
        {
            public abstract System.Security.Authentication.ExtendedProtection.ChannelBinding GetChannelBinding(System.Security.Authentication.ExtendedProtection.ChannelBindingKind kind);
            protected TransportContext() => throw null;
        }

        namespace Cache
        {
            // Generated from `System.Net.Cache.RequestCacheLevel` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum RequestCacheLevel
            {
                BypassCache,
                CacheIfAvailable,
                CacheOnly,
                Default,
                NoCacheNoStore,
                Reload,
                Revalidate,
            }

            // Generated from `System.Net.Cache.RequestCachePolicy` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            // Generated from `System.Net.NetworkInformation.IPAddressCollection` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            // Generated from `System.Net.Security.AuthenticationLevel` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum AuthenticationLevel
            {
                MutualAuthRequested,
                MutualAuthRequired,
                None,
            }

            // Generated from `System.Net.Security.SslPolicyErrors` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SslPolicyErrors
            {
                None,
                RemoteCertificateChainErrors,
                RemoteCertificateNameMismatch,
                RemoteCertificateNotAvailable,
            }

        }
        namespace Sockets
        {
            // Generated from `System.Net.Sockets.AddressFamily` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum AddressFamily
            {
                AppleTalk,
                Atm,
                Banyan,
                Ccitt,
                Chaos,
                Cluster,
                ControllerAreaNetwork,
                DataKit,
                DataLink,
                DecNet,
                Ecma,
                FireFox,
                HyperChannel,
                Ieee12844,
                ImpLink,
                InterNetwork,
                InterNetworkV6,
                Ipx,
                Irda,
                Iso,
                Lat,
                Max,
                NS,
                NetBios,
                NetworkDesigners,
                Osi,
                Packet,
                Pup,
                Sna,
                Unix,
                Unknown,
                Unspecified,
                VoiceView,
            }

            // Generated from `System.Net.Sockets.SocketError` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SocketError
            {
                AccessDenied,
                AddressAlreadyInUse,
                AddressFamilyNotSupported,
                AddressNotAvailable,
                AlreadyInProgress,
                ConnectionAborted,
                ConnectionRefused,
                ConnectionReset,
                DestinationAddressRequired,
                Disconnecting,
                Fault,
                HostDown,
                HostNotFound,
                HostUnreachable,
                IOPending,
                InProgress,
                Interrupted,
                InvalidArgument,
                IsConnected,
                MessageSize,
                NetworkDown,
                NetworkReset,
                NetworkUnreachable,
                NoBufferSpaceAvailable,
                NoData,
                NoRecovery,
                NotConnected,
                NotInitialized,
                NotSocket,
                OperationAborted,
                OperationNotSupported,
                ProcessLimit,
                ProtocolFamilyNotSupported,
                ProtocolNotSupported,
                ProtocolOption,
                ProtocolType,
                Shutdown,
                SocketError,
                SocketNotSupported,
                Success,
                SystemNotReady,
                TimedOut,
                TooManyOpenSockets,
                TryAgain,
                TypeNotFound,
                VersionNotSupported,
                WouldBlock,
            }

            // Generated from `System.Net.Sockets.SocketException` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
            // Generated from `System.Security.Authentication.CipherAlgorithmType` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum CipherAlgorithmType
            {
                Aes,
                Aes128,
                Aes192,
                Aes256,
                Des,
                None,
                Null,
                Rc2,
                Rc4,
                TripleDes,
            }

            // Generated from `System.Security.Authentication.ExchangeAlgorithmType` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ExchangeAlgorithmType
            {
                DiffieHellman,
                None,
                RsaKeyX,
                RsaSign,
            }

            // Generated from `System.Security.Authentication.HashAlgorithmType` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum HashAlgorithmType
            {
                Md5,
                None,
                Sha1,
                Sha256,
                Sha384,
                Sha512,
            }

            // Generated from `System.Security.Authentication.SslProtocols` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SslProtocols
            {
                Default,
                None,
                Ssl2,
                Ssl3,
                Tls,
                Tls11,
                Tls12,
                Tls13,
            }

            namespace ExtendedProtection
            {
                // Generated from `System.Security.Authentication.ExtendedProtection.ChannelBinding` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public abstract class ChannelBinding : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
                {
                    protected ChannelBinding() : base(default(bool)) => throw null;
                    protected ChannelBinding(bool ownsHandle) : base(default(bool)) => throw null;
                    public abstract int Size { get; }
                }

                // Generated from `System.Security.Authentication.ExtendedProtection.ChannelBindingKind` in `System.Net.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                public enum ChannelBindingKind
                {
                    Endpoint,
                    Unique,
                    Unknown,
                }

            }
        }
    }
}
