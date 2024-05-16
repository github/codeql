// This file contains auto-generated code.
// Generated from `System.Net.ServicePoint, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Net
    {
        public delegate System.Net.IPEndPoint BindIPEndPoint(System.Net.ServicePoint servicePoint, System.Net.IPEndPoint remoteEndPoint, int retryCount);
        [System.Flags]
        public enum SecurityProtocolType
        {
            SystemDefault = 0,
            Ssl3 = 48,
            Tls = 192,
            Tls11 = 768,
            Tls12 = 3072,
            Tls13 = 12288,
        }
        public class ServicePoint
        {
            public System.Uri Address { get => throw null; }
            public System.Net.BindIPEndPoint BindIPEndPointDelegate { get => throw null; set { } }
            public System.Security.Cryptography.X509Certificates.X509Certificate Certificate { get => throw null; }
            public System.Security.Cryptography.X509Certificates.X509Certificate ClientCertificate { get => throw null; }
            public bool CloseConnectionGroup(string connectionGroupName) => throw null;
            public int ConnectionLeaseTimeout { get => throw null; set { } }
            public int ConnectionLimit { get => throw null; set { } }
            public string ConnectionName { get => throw null; }
            public int CurrentConnections { get => throw null; }
            public bool Expect100Continue { get => throw null; set { } }
            public System.DateTime IdleSince { get => throw null; }
            public int MaxIdleTime { get => throw null; set { } }
            public virtual System.Version ProtocolVersion { get => throw null; }
            public int ReceiveBufferSize { get => throw null; set { } }
            public void SetTcpKeepAlive(bool enabled, int keepAliveTime, int keepAliveInterval) => throw null;
            public bool SupportsPipelining { get => throw null; }
            public bool UseNagleAlgorithm { get => throw null; set { } }
        }
        public class ServicePointManager
        {
            public static bool CheckCertificateRevocationList { get => throw null; set { } }
            public static int DefaultConnectionLimit { get => throw null; set { } }
            public const int DefaultNonPersistentConnectionLimit = 4;
            public const int DefaultPersistentConnectionLimit = 2;
            public static int DnsRefreshTimeout { get => throw null; set { } }
            public static bool EnableDnsRoundRobin { get => throw null; set { } }
            public static System.Net.Security.EncryptionPolicy EncryptionPolicy { get => throw null; }
            public static bool Expect100Continue { get => throw null; set { } }
            public static System.Net.ServicePoint FindServicePoint(string uriString, System.Net.IWebProxy proxy) => throw null;
            public static System.Net.ServicePoint FindServicePoint(System.Uri address) => throw null;
            public static System.Net.ServicePoint FindServicePoint(System.Uri address, System.Net.IWebProxy proxy) => throw null;
            public static int MaxServicePointIdleTime { get => throw null; set { } }
            public static int MaxServicePoints { get => throw null; set { } }
            public static bool ReusePort { get => throw null; set { } }
            public static System.Net.SecurityProtocolType SecurityProtocol { get => throw null; set { } }
            public static System.Net.Security.RemoteCertificateValidationCallback ServerCertificateValidationCallback { get => throw null; set { } }
            public static void SetTcpKeepAlive(bool enabled, int keepAliveTime, int keepAliveInterval) => throw null;
            public static bool UseNagleAlgorithm { get => throw null; set { } }
        }
    }
}
